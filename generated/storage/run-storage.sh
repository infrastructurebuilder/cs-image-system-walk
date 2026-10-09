#!/usr/bin/env bash
# cs-image-system lifecycle runner: storage
# run id: 2026_10_09t12_21_20_389938
# Deferred commands accumulated while generating this lifecycle,
# in phase order. Paths are relative to this lifecycle's directory.
# state: workspace gcp-pd -> s3://csis-walk-tfstate-514190660293/statefiles/cs-image-system-walk/gcp_pd.tfstate
# NOTE: builders' pre/post finalize hooks are NOT part of this
# script; a --no-dry-run run performs them in-process.
set -euo pipefail
cd "$(dirname "$0")"
CSIS_ROOT="$(cd "../.." && pwd)"   # the configuration root, relative to this script

# --- phase: storage-generation ---
( cd "gcp-pd/storage-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && rm -f tfplan )
( cd "gcp-pd/storage-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu init -input=false -reconfigure -backend-config=gcp-pd-storage-generation.tfbackend.hcl )
( cd "gcp-pd/storage-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu plan -input=false -out=tfplan )
( cd "gcp-pd/storage-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system gate-plan --planfile tfplan --tofu tofu )
( cd "gcp-pd/storage-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system apply-check --lifecycle storage --root gcp-pd --root-alias gcp-main --apply-runtime gcp-main )
( cd "gcp-pd/storage-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu apply -input=false tfplan )
