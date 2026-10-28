#!/usr/bin/env python3
"""Run the pure native host's live UI check using a private sandbox file."""
import argparse
from datetime import datetime
import json
from pathlib import Path, PurePosixPath
import plistlib
import os
import subprocess
import sys
import tempfile
import time

root = Path(__file__).resolve().parents[1]
BUNDLE_ID = 'com.example.imsdkhost.ios'
INPUT_NAME = 'imsdk-host-private-input.json'
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--device', required=True)
parser.add_argument('--input', required=True, type=Path)
parser.add_argument('--platform', choices=('simulator', 'device'), default='simulator')
parser.add_argument('--scenario', choices=('direct', 'customer'), required=True)
parser.add_argument('--message')
parser.add_argument('--expected-reply')
parser.add_argument('--derived-data', type=Path,
    default=Path(os.environ.get('IMSDK_IOS_HOST_DERIVED_DATA',
        str(root / 'native/ios/example/build/DerivedData'))))
parser.add_argument('--presentation-mode', choices=('push', 'present'))
options = parser.parse_args()
derived_data = options.derived_data.expanduser().resolve()
products = derived_data / 'Build/Products'
test_runs = sorted(products.glob('IMSDKHost_*.xctestrun'))
if len(test_runs) != 1:
    raise SystemExit('Build the native iOS host/UI test bundle first; one xctestrun is required.')
staging = [sys.executable, str(root / 'scripts/stage_ios_host_private_input.py'),
           '--device', options.device, '--input', str(options.input), '--platform', options.platform]
environment = {
    # The host resolves this fixed filename inside its own current tmp directory.
    'IMSDK_HOST_PRIVATE_CONFIG_PATH': INPUT_NAME,
    'IMSDK_HOST_LIVE_SCENARIO': options.scenario,
}
if options.message:
    environment['IMSDK_HOST_TEST_MESSAGE'] = options.message
if options.expected_reply:
    environment['IMSDK_HOST_EXPECTED_REPLY'] = options.expected_reply
if options.presentation_mode:
    environment['IMSDK_HOST_PRESENTATION_MODE'] = options.presentation_mode
document = plistlib.loads(test_runs[0].read_bytes())
targets = 0


def prepare(value):
    global targets
    if isinstance(value, dict):
        output = {key: prepare(item) for key, item in value.items()}
        if 'TestBundlePath' in output:
            output.setdefault('EnvironmentVariables', {}).update(environment)
            targets += 1
        return output
    if isinstance(value, list):
        return [prepare(item) for item in value]
    if isinstance(value, str):
        return value.replace('__TESTROOT__', str(products))
    return value


def device_json(arguments):
    """Use the documented JSON interface; never parse device console text."""
    with tempfile.TemporaryDirectory(prefix='imsdk-device-metadata-', dir=derived_data) as directory:
        output = Path(directory) / 'result.json'
        # Keep tool options before launch's bundle/remaining app arguments.
        command = ['xcrun', 'devicectl', 'device', *arguments[:2],
            '--device', options.device, '--quiet', '--timeout', '15',
            '--json-output', str(output), *arguments[2:]]
        try:
            result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=25)
            if result.returncode:
                raise RuntimeError()
            return json.loads(output.read_text())
        except (OSError, ValueError, subprocess.TimeoutExpired, RuntimeError):
            raise RuntimeError('The SDK app device operation could not be verified; private output suppressed.') from None


def device_input_exists():
    document = device_json(['info', 'files', '--domain-type', 'appDataContainer',
        '--domain-identifier', BUNDLE_ID, '--subdirectory', 'tmp', '--no-recurse'])
    if not isinstance(document, dict):
        raise RuntimeError('Unknown device file metadata; private-input removal is not verified.')
    result = document.get('result')
    files = result.get('files') if isinstance(result, dict) else None
    if not isinstance(files, list):
        raise RuntimeError('Unknown device file metadata; private-input removal is not verified.')
    for entry in files:
        name = entry if isinstance(entry, str) else None
        if isinstance(entry, dict):
            name = entry.get('name') or entry.get('path') or entry.get('relativePath')
        if not isinstance(name, str):
            raise RuntimeError('Unknown device file entry; private-input removal is not verified.')
        if PurePosixPath(name).name == INPUT_NAME:
            return True
    return False


def consume_remaining_device_input():
    """Only the SDK host may consume its one whitelisted temporary input file."""
    present = device_input_exists()
    relaunched = False
    if present:
        # A fresh launch is needed if XCTest failed before the loader ran.
        # This terminates/relaunches only this SDK example, never another app.
        device_json(['process', 'launch', '--terminate-existing',
            '--environment-variables', json.dumps({'IMSDK_HOST_PRIVATE_CONFIG_PATH': INPUT_NAME}),
            BUNDLE_ID])
        relaunched = True
        deadline = time.monotonic() + 30
        while device_input_exists():
            if time.monotonic() >= deadline:
                raise RuntimeError('The SDK host has not consumed its private device input; absence is not verified.')
            time.sleep(0.5)
    return {'platform': 'device', 'bundleIdentifier': BUNDLE_ID,
        'temporaryInput': 'tmp/' + INPUT_NAME, 'presentBeforeCleanup': present,
        'hostRelaunchedToConsume': relaunched, 'verifiedAbsent': True,
        'voiceOverValidation': 'Separate human observation required; not measured by this runner.'}


prepared = prepare(document)
if targets != 1:
    raise SystemExit('Unexpected xctestrun target layout; no private input was staged.')
stamp = datetime.now().strftime('%Y%m%d-%H%M%S-%f')
local_run = derived_data / f'live-{options.platform}-{options.scenario}-{stamp}.xctestrun'
local_run.write_bytes(plistlib.dumps(prepared))
prefix = 'device-' if options.platform == 'device' else ''
log = root / f'logs/host-ios-live-{prefix}{options.scenario}-{stamp}.log'
result = log.with_suffix('.xcresult')
method = ('testLiveRepeatedPagesOnPhysicalDevice' if options.platform == 'device'
    else 'testLiveTargetsFromPrivateDevelopmentInput')
command = [
    'xcodebuild', 'test-without-building', '-xctestrun', str(local_run),
    '-destination', 'id=' + options.device, '-parallel-testing-enabled', 'NO',
    '-only-testing:IMSDKHostUITests/IMSDKHostUITests/' + method,
    '-resultBundlePath', str(result),
]
print('Running live native iOS scenario:', options.scenario)
print('Platform:', options.platform)
print('Presentation mode:', options.presentation_mode or 'automatic')
print('DerivedData:', derived_data)
print('Private values are read from an app-sandbox file and are not printed.')
if options.platform == 'device':
    print('The physical repeated-page method sends no messages. VoiceOver requires separate human observation.')
staged_paths = []
staged_containers = set()
stage_attempted = False
process = None
cleanup_failure = None
returncode = 1
try:
    stage_attempted = True
    staged = subprocess.check_output(staging, text=True).strip()
    if options.platform == 'simulator':
        staged_paths.append(Path(staged))
        staged_containers.add(str(Path(staged).parent.parent))
    with log.open('wb') as output:
        process = subprocess.Popen(command, stdout=output, stderr=subprocess.STDOUT)
        while process.poll() is None:
            if options.platform == 'simulator':
                current = subprocess.run(['xcrun', 'simctl', 'get_app_container', options.device,
                    BUNDLE_ID, 'data'], text=True, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
                container = current.stdout.strip()
                expected = Path(container) / 'tmp' / INPUT_NAME if container else None
                if current.returncode == 0 and container and (
                        container not in staged_containers or not expected.exists()):
                    path = subprocess.check_output(staging, text=True).strip()
                    staged_paths.append(Path(path))
                    staged_containers.add(container)
            # A physical device is staged once; it never enters the simulator
            # restaging bootstrap needed for that method's reauthentication.
            time.sleep(0.4)
        returncode = process.wait()
finally:
    if process is not None and process.poll() is None:
        process.terminate()
        try:
            process.wait(timeout=10)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()
    if options.platform == 'device' and stage_attempted:
        try:
            cleanup = consume_remaining_device_input()
            log.with_suffix('.private-input.json').write_text(json.dumps(cleanup, indent=2) + '\n')
            print('Private device input: verified absent after host consumption.')
        except RuntimeError as error:
            cleanup_failure = str(error)
            log.with_suffix('.private-input.json').write_text(json.dumps(
                {'platform': 'device', 'verifiedAbsent': False, 'reason': cleanup_failure}, indent=2) + '\n')
    else:
        for path in staged_paths:
            path.unlink(missing_ok=True)
if cleanup_failure:
    raise SystemExit(cleanup_failure)
print('Evidence:', log)
print('Test result:', result)
raise SystemExit(returncode)
