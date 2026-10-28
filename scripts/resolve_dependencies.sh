#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
imsdk_require_flutter
pub_args=(--offline --enforce-lockfile)
if [[ "${1:-}" == "--online" ]]; then
  pub_args=(--enforce-lockfile)
  shift
fi
if [[ $# -ne 0 ]]; then
  echo "Usage: scripts/resolve_dependencies.sh [--online]" >&2
  exit 2
fi
for project in packages/im_sdk module examples/flutter_host; do
  (
    cd "$IMSDK_ROOT/$project"
    imsdk_log "pub-${project//\//-}" "$IMSDK_FLUTTER_BIN" --no-version-check pub get "${pub_args[@]}"
  )
done
(
  cd "$IMSDK_ROOT/packages/im_sdk"
  imsdk_log gen-l10n "$IMSDK_FLUTTER_BIN" --no-version-check gen-l10n
)
python3 "$IMSDK_ROOT/scripts/prepare_module.py"
echo "Dependencies resolved with checked-in locks. Offline misses require an explicitly authorized --online run."
