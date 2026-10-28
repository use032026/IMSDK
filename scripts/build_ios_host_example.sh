#!/usr/bin/env bash
set -euo pipefail
task_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
mode="${1:-build}"
if [[ $# -gt 0 ]]; then shift; fi
task_derived_data="${IMSDK_IOS_HOST_DERIVED_DATA:-$task_root/native/ios/example/build/DerivedData}"
task_copy_to_dist=1
usage() { echo 'Usage: scripts/build_ios_host_example.sh [build|test] [--derived-data PATH] [--no-copy]' >&2; }
case "$mode" in build|test) ;; *) usage; exit 2 ;; esac
while [[ $# -gt 0 ]]; do
  case "$1" in
    --derived-data)
      [[ $# -ge 2 && -n "$2" ]] || { usage; exit 2; }
      task_derived_data="$2"; shift 2 ;;
    --no-copy) task_copy_to_dist=0; shift ;;
    *) usage; exit 2 ;;
  esac
done
task_derived_data="$(python3 -c 'from pathlib import Path; import sys; print(Path(sys.argv[1]).expanduser().resolve())' "$task_derived_data")"
python3 "$task_root/scripts/generate_ios_host_example.py"
task_stamp="$(date +%Y%m%d-%H%M%S)"
task_log="$task_root/logs/host-ios-$mode-$task_stamp"
mkdir -p "$task_root/logs"
if [[ -n "${IMSDK_IOS_SIMULATOR_UDID:-}" ]]; then
  task_destination="id=$IMSDK_IOS_SIMULATOR_UDID"
elif [[ "$mode" == test ]]; then
  echo 'Set IMSDK_IOS_SIMULATOR_UDID to the dedicated integration simulator before testing.' >&2
  exit 2
else
  task_destination='generic/platform=iOS Simulator'
fi
task_action=build-for-testing
if [[ "$mode" == test ]]; then task_action=test; fi
xcodebuild "$task_action" \
  -project "$task_root/native/ios/example/IMSDKHost.xcodeproj" \
  -scheme IMSDKHost -configuration Debug -sdk iphonesimulator \
  -destination "$task_destination" \
  -derivedDataPath "$task_derived_data" \
  -resultBundlePath "$task_log.xcresult" \
  -parallel-testing-enabled NO \
  CODE_SIGN_IDENTITY=- 2>&1 | tee "$task_log.log"
task_app="$task_derived_data/Build/Products/Debug-iphonesimulator/IMSDKHost.app"
test -d "$task_app"
if [[ "$task_copy_to_dist" == 1 ]]; then
  mkdir -p "$task_root/dist/ios/example"
  ditto "$task_app" "$task_root/dist/ios/example/IMSDKHost.app"
  echo "Native host application: $task_root/dist/ios/example/IMSDKHost.app"
else
  echo "Validation application (delivery unchanged): $task_app"
fi
echo "DerivedData: $task_derived_data"
echo "Evidence: $task_log.log and $task_log.xcresult"
