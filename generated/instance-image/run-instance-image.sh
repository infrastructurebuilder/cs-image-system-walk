#!/usr/bin/env bash
# cs-image-system lifecycle runner: instance-image
# run id: 2026_10_08t13_03_36_162901
# Deferred commands accumulated while generating this lifecycle,
# in phase order. Paths are relative to this lifecycle's directory.
# state: workspace tofu-aws -> s3://csis-walk-tfstate-514190660293/statefiles/cs-image-system-walk/tofu_aws.tfstate
# NOTE: builders' pre/post finalize hooks are NOT part of this
# script; a --no-dry-run run performs them in-process.
set -euo pipefail
cd "$(dirname "$0")"
CSIS_ROOT="$(cd "../.." && pwd)"   # the configuration root, relative to this script

# --- phase: instance-generation ---
( cd "tofu-aws/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && rm -f tfplan )
( cd "tofu-aws/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu init -input=false -reconfigure -backend-config=tofu-aws-instance-generation.tfbackend.hcl )
( cd "tofu-aws/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu plan -input=false -out=tfplan )
( cd "tofu-aws/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system gate-plan --planfile tfplan --tofu tofu )
( cd "tofu-aws/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system apply-check --lifecycle instances --root tofu-aws --root-alias aws-main --apply-runtime aws-main )
( cd "tofu-aws/instance-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu apply -input=false tfplan )
