#!/usr/bin/env bash
# cs-image-system lifecycle runner: identity
# run id: 2026_10_09t00_54_13_492907
# Deferred commands accumulated while generating this lifecycle,
# in phase order. Paths are relative to this lifecycle's directory.
# state: workspace opa-groups -> s3://csis-walk-tfstate-514190660293/statefiles/cs-image-system-walk/opa_groups.tfstate
# state: workspace okta-users -> s3://csis-walk-tfstate-514190660293/statefiles/cs-image-system-walk/okta_users.tfstate
# NOTE: builders' pre/post finalize hooks are NOT part of this
# script; a --no-dry-run run performs them in-process.
set -euo pipefail
cd "$(dirname "$0")"
CSIS_ROOT="$(cd "../.." && pwd)"   # the configuration root, relative to this script

# --- phase: group-generation ---
( cd "opa-groups/group-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && rm -f tfplan )
( cd "opa-groups/group-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu init -input=false -reconfigure -backend-config=opa-groups-group-generation.tfbackend.hcl )
( cd "opa-groups/group-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system --root-dir "$CSIS_ROOT" --no-dry-run prune-attachments --builder opa-groups --tofu tofu --run 2026_10_09t00_54_13_492907 )
( cd "opa-groups/group-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu plan -input=false -out=tfplan )
( cd "opa-groups/group-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system gate-plan --planfile tfplan --tofu tofu --allow-destroy-from csis-sanctioned-removals.txt )
( cd "opa-groups/group-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && cs-image-system apply-check --lifecycle identity --root opa-groups )
( cd "opa-groups/group-generation" && cd "$(cs-image-system materialize . --root-dir "$CSIS_ROOT")" && tofu apply -input=false tfplan )
