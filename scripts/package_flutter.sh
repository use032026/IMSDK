#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
imsdk_log source-independence python3 "$IMSDK_ROOT/scripts/verify_independence.py"
imsdk_log source-archive python3 "$IMSDK_ROOT/scripts/package_flutter.py"
imsdk_checksums "$IMSDK_ROOT/dist/flutter"
