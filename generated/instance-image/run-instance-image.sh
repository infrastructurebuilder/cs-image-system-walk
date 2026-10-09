#!/usr/bin/env bash
# cs-image-system lifecycle runner: instance-image
# run id: 2026_10_09t12_18_19_690441
# Deferred commands accumulated while generating this lifecycle,
# in phase order. Paths are relative to this lifecycle's directory.
# state: workspace tofu-gce -> s3://csis-walk-tfstate-514190660293/statefiles/cs-image-system-walk/tofu_gce.tfstate
# NOTE: builders' pre/post finalize hooks are NOT part of this
# script; a --no-dry-run run performs them in-process.
set -euo pipefail
cd "$(dirname "$0")"
CSIS_ROOT="$(cd "../.." && pwd)"   # the configuration root, relative to this script

# --- phase: image-generation ---
( cd "packer-gce/image-generation/block-000" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && packer build . )

# --- phase: instance-generation ---
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && rm -f tfplan )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu init -input=false -reconfigure -backend-config=tofu-gce-instance-generation.tfbackend.hcl )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu plan -input=false -out=tfplan )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system gate-plan --planfile tfplan --tofu tofu )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system apply-check --lifecycle instances --root tofu-gce --root-alias gcp-main --apply-runtime gcp-main )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu apply -input=false tfplan )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system --root-dir "$CSIS_ROOT" --no-dry-run verify instance walk-gce-1 )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && rm -f tfplan )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu init -input=false -reconfigure -backend-config=tofu-gce-instance-generation.tfbackend.hcl )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu plan -input=false -out=tfplan -var=ephemeral_present=false )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system gate-plan --planfile tfplan --tofu tofu --allow-destroy module.instance_walk_gce_1 )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system apply-check --lifecycle instances --root tofu-gce --root-alias gcp-main --apply-runtime gcp-main )
( cd "tofu-gce/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu apply -input=false tfplan )
