#!/usr/bin/env bash
set -euo pipefail

IMSDK_ROOT="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
IMSDK_FLUTTER_BIN="${FLUTTER_BIN:-flutter}"
IMSDK_LOG_DIR="$IMSDK_ROOT/logs"
mkdir -p "$IMSDK_LOG_DIR"

imsdk_require_flutter() {
  if ! command -v "$IMSDK_FLUTTER_BIN" >/dev/null 2>&1; then
    echo "Flutter is required. Install the version in .flutter-version or set FLUTTER_BIN." >&2
    return 1
  fi
  local machine_file="$IMSDK_LOG_DIR/flutter-version.json"
  "$IMSDK_FLUTTER_BIN" --no-version-check --version --machine > "$machine_file"
  python3 - "$machine_file" "$IMSDK_ROOT/.flutter-version" <<'PY'
import json, sys
from pathlib import Path
actual = json.loads(Path(sys.argv[1]).read_text()).get('frameworkVersion')
expected = Path(sys.argv[2]).read_text().strip()
if actual != expected:
    raise SystemExit(f'Flutter version mismatch: expected {expected}, found {actual}. Do not silently upgrade the SDK build toolchain.')
PY
}

imsdk_log() {
  local stage="$1"
  shift
  "$@" 2>&1 | tee "$IMSDK_LOG_DIR/${stage}-$(date -u +%Y%m%dT%H%M%SZ).log"
}

imsdk_checksums() {
  python3 "$IMSDK_ROOT/scripts/write_checksums.py" "$1"
}
