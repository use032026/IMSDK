#!/usr/bin/env python3
"""Run current-source mobile acceptance with private runtime-only QA input."""
import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import signal
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--input', required=True, type=Path)
parser.add_argument('--device', required=True)
parser.add_argument('--resume', action='store_true')
parser.add_argument('--lifecycle-only', action='store_true')
parser.add_argument('--platform', choices=['ios', 'android'], default='ios')
parser.add_argument('--flutter', default='/Users/starburst/fvm/versions/3.41.9/bin/flutter')
parser.add_argument('--adb', default='/Users/starburst/Library/Android/sdk/platform-tools/adb')
args = parser.parse_args()
fixture = json.loads(args.input.read_text())
run_id = fixture['runId']
private = ROOT / '.work/runtime-private'
private.mkdir(exist_ok=True)
logs = ROOT / 'logs'
logs.mkdir(exist_ok=True)
artifact_label = 'mobile-lifecycle' if args.lifecycle_only else 'mobile'
status_out = private / f'unification-live-{run_id}-{artifact_label}-status.json'
report_out = logs / f'unification-live-{run_id}-{artifact_label}.json'
log_out = logs / f'unification-live-{run_id}-{artifact_label}.log'
bundle = 'com.imsdk.example.imSdkFlutterHost' if args.platform == 'ios' else 'com.imsdk.example.im_sdk_flutter_host'
secrets = []
def collect(value):
    if isinstance(value, dict):
        for key, item in value.items():
            if isinstance(item, str) and any(word in key.lower() for word in ['password', 'token', 'identifier']):
                if item: secrets.append(item)
            else: collect(item)
    elif isinstance(value, list):
        for item in value: collect(item)
collect(fixture)
def redact(line):
    for secret in secrets: line = line.replace(secret, '[PRIVATE]')
    line = re.sub(r'(?i)(Bearer\s+)[A-Za-z0-9._~+/-]+', r'\1[PRIVATE]', line)
    line = re.sub(r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+', '[PRIVATE-JWT]', line)
    return re.sub(r'(?i)(access_token=)[^&\s]+', r'\1[PRIVATE]', line)
container = None
staged = False
evidence = []
if args.resume:
    if not status_out.exists(): raise SystemExit('Resume requires previous private SDK status')
    previous = json.loads(status_out.read_text())
    if previous.get('runId') != run_id or not previous.get('userId'): raise SystemExit('Resume status does not identify the dedicated registered account')
    fixture['resumeExistingAccount'] = True
    fixture['resumeState'] = previous
    evidence = [item for item in previous.get('steps', []) if item.get('step') != 'failed']

def ios_container():
    result = subprocess.run(['xcrun', 'simctl', 'get_app_container', args.device, bundle, 'data'], capture_output=True, text=True)
    if result.returncode: raise RuntimeError('Current debug host data container unavailable')
    return Path(result.stdout.strip())

def stage_input():
    global container, staged
    if staged: return
    if args.platform == 'ios':
        container = ios_container()
        folder = container / 'Library/Application Support'
        folder.mkdir(parents=True, exist_ok=True)
        target = folder / 'unification-live-input.json'
        target.write_text(json.dumps(fixture)); target.chmod(0o600)
    else:
        result = subprocess.run([args.adb, '-s', args.device, 'shell', '-T',
            f"run-as {bundle} sh -c 'umask 077; mkdir -p files; cat > files/unification-live-input.json'"],
            input=json.dumps(fixture).encode(), capture_output=True)
        if result.returncode: raise RuntimeError('Unable to stage private QA input')
    staged = True

def copy_status():
    try:
        if args.platform == 'ios':
            if container is None: return
            source = container / 'Library/Application Support/unification-mobile-status.json'
            raw = source.read_bytes()
        else:
            result = subprocess.run([args.adb, '-s', args.device, 'exec-out', 'run-as', bundle,
                'cat', 'files/unification-mobile-status.json'], capture_output=True)
            if result.returncode: return
            raw = result.stdout
        doc = json.loads(raw)
        if doc.get('runId') != run_id: return
        temp = status_out.with_suffix('.tmp')
        temp.write_bytes(raw); temp.chmod(0o600); temp.replace(status_out)
    except (OSError, ValueError): pass

def copy_screenshot(label):
    if label not in ['direct', 'group', 'failure']: return
    if args.platform == 'ios':
        source = container / f'Library/Application Support/unification-{label}.png'
        raw = source.read_bytes()
    else:
        result = subprocess.run([args.adb, '-s', args.device, 'exec-out', 'run-as', bundle,
            'cat', f'files/unification-{label}.png'], capture_output=True)
        raw = result.stdout
    if not raw.startswith(b'\x89PNG\r\n\x1a\n'): raise RuntimeError('Missing expected SDK screenshot')
    (logs / f'unification-live-{run_id}-mobile-{label}.png').write_bytes(raw)

command = [args.flutter, '--no-version-check', 'test', '--no-pub',
    'integration_test/sdk_lifecycle_live_test.dart' if args.lifecycle_only else 'integration_test/unified_live_test.dart', '-d', args.device, '--reporter', 'expanded']
started = datetime.now(timezone.utc).isoformat()
process = None
runner_error = None
input_absent = False
result = 1
try:
    process = subprocess.Popen(command, cwd=ROOT / 'examples/flutter_host', stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT, text=True, start_new_session=True)
    with log_out.open('w') as output:
        for line in process.stdout:
            output.write(redact(line)); output.flush()
            if 'IMSDK_UNIFICATION_WAITING_FOR_PRIVATE_INPUT' in line: stage_input()
            if 'IMSDK_UNIFICATION_EVIDENCE ' in line:
                try:
                    item = json.loads(line.split('IMSDK_UNIFICATION_EVIDENCE ', 1)[1]); evidence.append(item)
                    copy_status()
                    print('Mobile live phase:', item.get('step'), flush=True)
                except ValueError: pass
            if 'IMSDK_UNIFICATION_SCREENSHOT_READY ' in line:
                copy_screenshot(line.split('IMSDK_UNIFICATION_SCREENSHOT_READY ', 1)[1].strip())
    result = process.wait()
except Exception as error:
    runner_error = type(error).__name__
finally:
    if process is not None and process.poll() is None:
        os.killpg(process.pid, signal.SIGTERM)
        try: process.wait(timeout=20)
        except subprocess.TimeoutExpired:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait(timeout=10)
    copy_status()
    try:
        if args.platform == 'ios':
            if container is None and staged: container = ios_container()
            if container:
                target = container / 'Library/Application Support/unification-live-input.json'
                target.unlink(missing_ok=True)
                input_absent = not target.exists()
            else: input_absent = not staged
        else:
            operation = subprocess.run([args.adb, '-s', args.device, 'shell', '-T',
                f"run-as {bundle} sh -c 'rm -f files/unification-live-input.json; test ! -e files/unification-live-input.json'"],
                capture_output=True, timeout=15)
            input_absent = operation.returncode == 0
    except Exception as error:
        runner_error = runner_error or type(error).__name__
required = {'registered', 'friendAccepted', 'directSent', 'directReplyRendered', 'groupCreated',
    'groupSent', 'groupReplyRendered', 'conversationListVerified', 'reloginVerified', 'finalLogoutVerified', 'completed'}
if args.lifecycle_only:
    required = {'authenticatedExistingAccount', 'logoutForegroundReturned', 'disposeCompleted', 'completed'}
steps = {item.get('step') for item in evidence}
completed = any(item.get('step') == 'completed' and item.get('passed') is True for item in evidence)
cleanup_errors = log_out.exists() and any(marker in log_out.read_text() for marker in ['background cleanup failed', 'already disposed', 'after `dispose` was called'])
passed = result == 0 and runner_error is None and input_absent and completed and required <= steps and not cleanup_errors
report_out.write_text(json.dumps({'runId': run_id, 'startedAt': started, 'platform': args.platform,
    'device': args.device, 'passed': passed, 'exitCode': result, 'steps': evidence,
    'resumedExistingAccount': args.resume, 'lifecycleOnly': args.lifecycle_only, 'originalRegistrationEvidence': 'mobile-attempt1.json' if args.resume else None,
    'requiredCheckpointsPresent': required <= steps, 'missingCheckpoints': sorted(required - steps),
    'privateInputVerifiedAbsent': input_absent, 'logoutDisposeErrorsDetected': cleanup_errors, 'runnerErrorType': runner_error,
    'configurationBundled': False, 'verificationMessagesSent': False}, indent=2) + '\n')
print(f'Mobile current-source live test: passed={passed}; sanitized report={report_out}')
sys.exit(0 if passed else 1)
