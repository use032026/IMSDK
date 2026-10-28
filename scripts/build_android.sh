#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
mode="${1:-release}"
if [[ $# -gt 0 ]]; then shift; fi
case "$mode" in
  release) mode_args=(--release --no-debug --no-profile) ;;
  debug) mode_args=(--debug --no-release --no-profile) ;;
  all) mode_args=(--debug --profile --release) ;;
  *) echo "Usage: scripts/build_android.sh [release|debug|all] [flutter build aar options]" >&2; exit 2 ;;
esac
imsdk_require_flutter
if [[ ! -f "$IMSDK_ROOT/module/.dart_tool/package_config.json" ]]; then
  echo "Resolve dependencies first: scripts/resolve_dependencies.sh (offline by default)." >&2
  exit 1
fi
python3 "$IMSDK_ROOT/scripts/prepare_module.py"
version="$(python3 -c 'import pathlib,re,sys; print(re.search(r"^version:\s*(\S+)",pathlib.Path(sys.argv[1]).read_text(),re.M)[1].split("+")[0])' "$IMSDK_ROOT/packages/im_sdk/pubspec.yaml")"
build_root="$IMSDK_ROOT/module/build/sdk-aar"
(
  cd "$IMSDK_ROOT/module"
  imsdk_log "android-$mode" "$IMSDK_FLUTTER_BIN" --no-version-check build aar --no-pub "${mode_args[@]}" --build-number "$version" --output "$build_root" "$@"
)
python3 - "$build_root/host/outputs/repo" "$IMSDK_ROOT/dist/android/maven" <<'PY'
from pathlib import Path
import shutil, sys
source, target = map(Path, sys.argv[1:])
if not source.is_dir() or not any(source.rglob('*.aar')):
    raise SystemExit('Flutter completed without an AAR repository at the expected output; inspect the build log.')
shutil.copytree(source, target, dirs_exist_ok=True)
PY
imsdk_checksums "$IMSDK_ROOT/dist/android"
echo "Android Maven repository: $IMSDK_ROOT/dist/android/maven"
