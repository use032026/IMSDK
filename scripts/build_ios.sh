#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
mode="${1:-release}"
if [[ $# -gt 0 ]]; then shift; fi
case "$mode" in
  release) mode_args=(--release --no-debug --no-profile) ;;
  debug) mode_args=(--debug --no-release --no-profile) ;;
  all) mode_args=(--debug --profile --release) ;;
  *) echo "Usage: scripts/build_ios.sh [release|debug|all] [flutter build ios-framework options]" >&2; exit 2 ;;
esac
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "iOS framework builds require macOS, Xcode and CocoaPods." >&2
  exit 1
fi
imsdk_require_flutter
if [[ ! -f "$IMSDK_ROOT/module/.dart_tool/package_config.json" ]]; then
  echo "Resolve dependencies first: scripts/resolve_dependencies.sh (offline by default)." >&2
  exit 1
fi
python3 "$IMSDK_ROOT/scripts/prepare_module.py"
(
  cd "$IMSDK_ROOT/module"
  # Flutter 3.41.9 passes all architecture names in one -verify_arch call.
  # Xcode 27.2 accepts only one name per call. Verify each architecture.
  export IMSDK_XCODE_LIPO="$(xcrun --find lipo)"
  lipo_dir="$(mktemp -d "$IMSDK_ROOT/module/.dart_tool/imsdk-lipo.XXXXXX")"
  trap 'rm -f -- "$lipo_dir/lipo"; rmdir -- "$lipo_dir"' EXIT
  cat > "$lipo_dir/lipo" <<'LIPO'
#!/usr/bin/env bash
if [[ "${2:-}" == "-verify_arch" && $# -gt 3 ]]; then
  binary="$1"
  shift 2
  for architecture in "$@"; do
    "$IMSDK_XCODE_LIPO" "$binary" -verify_arch "$architecture" || exit $?
  done
  exit 0
fi
exec "$IMSDK_XCODE_LIPO" "$@"
LIPO
  chmod +x "$lipo_dir/lipo"
  export PATH="$lipo_dir:$PATH"
  imsdk_log "ios-$mode" "$IMSDK_FLUTTER_BIN" --no-version-check build ios-framework --no-pub "${mode_args[@]}" --output "$IMSDK_ROOT/dist/ios" "$@"
)
case "$mode" in
  release) closure_modes=(Release) ;;
  debug) closure_modes=(Debug) ;;
  all) closure_modes=(Debug Profile Release) ;;
esac
for closure_mode in "${closure_modes[@]}"; do
  python3 "$IMSDK_ROOT/scripts/complete_ios_distribution.py" "$closure_mode"
done
python3 - "$IMSDK_ROOT/dist/ios" <<'PY'
from pathlib import Path
import sys
root = Path(sys.argv[1])
if not list(root.glob('*/App.xcframework')) or not list(root.glob('*/Flutter.xcframework')):
    raise SystemExit('The full App + Flutter XCFramework set is incomplete; inspect the build log.')
PY
imsdk_checksums "$IMSDK_ROOT/dist/ios"
echo "iOS framework set: $IMSDK_ROOT/dist/ios"
