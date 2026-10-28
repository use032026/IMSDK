#!/usr/bin/env python3
"""Run the real Flutter Android host with private, non-bundled test tickets."""
import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser()
parser.add_argument('--config', type=Path, required=True)
parser.add_argument('--device', default='emulator-5554')
parser.add_argument('--label', choices=['direct', 'customer'], required=True)
parser.add_argument('--flutter', default=os.environ.get('FLUTTER_BIN', 'flutter'))
parser.add_argument('--adb', default='adb')
args = parser.parse_args()
config = json.loads(args.config.read_text())
package = 'com.imsdk.example.im_sdk_flutter_host'
logs = root / 'logs'
logs.mkdir(exist_ok=True)

def stage_private_input():
    # Flutter test can reinstall/erase the App. Wait for the test's explicit
    # handshake so the file lands in the current private data container.
    stage = subprocess.run([
        args.adb, '-s', args.device, 'shell', '-T',
        f"run-as {package} sh -c 'umask 077; mkdir -p files; cat > files/host-validation.json'",
    ], input=json.dumps(config).encode(), capture_output=True)
    if stage.returncode:
        raise RuntimeError('Unable to stage private input in the current debug App.')

secrets = []
def collect(value):
    if isinstance(value, dict):
        for key, item in value.items():
            if isinstance(item, str) and any(word in key.lower() for word in ('token', 'password')):
                if item:
                    secrets.append(item)
            else:
                collect(item)
    elif isinstance(value, list):
        for item in value:
            collect(item)
collect(config)

def redact(line):
    for secret in secrets:
        line = line.replace(secret, '[REDACTED]')
    line = re.sub(r'(?i)(Bearer\s+)[A-Za-z0-9._~+/-]+', r'\1[REDACTED]', line)
    return re.sub(r'(?i)(access_token=)[^&\s]+', r'\1[REDACTED]', line)

command = [args.flutter, 'test', '--no-pub', 'integration_test/host_live_test.dart',
           '-d', args.device, '--reporter', 'expanded']
stamp = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
log = logs / f'host-flutter-live-{args.label}-{stamp}.log'
evidence = []
with log.open('w') as output:
    process = subprocess.Popen(command, cwd=root / 'examples/flutter_host',
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    for line in process.stdout:
        output.write(redact(line))
        output.flush()
        if 'IMSDK_HOST_TEST_WAITING_FOR_PRIVATE_INPUT' in line:
            stage_private_input()
        if 'IMSDK_HOST_EVIDENCE ' in line:
            try:
                evidence.append(json.loads(line.split('IMSDK_HOST_EVIDENCE ', 1)[1]))
                (logs / f'host-flutter-live-{args.label}-result.json').write_text(
                    json.dumps({'scenario': args.label, 'steps': evidence}, indent=2)+'\n')
            except json.JSONDecodeError:
                pass
        if 'IMSDK_HOST_SCREENSHOT_READY' in line:
            read = subprocess.run([args.adb, '-s', args.device, 'exec-out',
                'run-as', package, 'cat', f'files/host-live-{args.label}.png'], capture_output=True)
            if not read.returncode and read.stdout.startswith(b'\x89PNG\r\n\x1a\n'):
                (logs / f'host-flutter-live-{args.label}.png').write_bytes(read.stdout)
    result = process.wait()

result_bytes = (json.dumps({'scenario': args.label, 'passed': result == 0,
                          'exitCode': result, 'steps': evidence}, indent=2)+'\n').encode()
(logs / f'host-flutter-live-{args.label}-{stamp}-result.json').write_bytes(result_bytes)
(logs / f'host-flutter-live-{args.label}-result.json').write_bytes(result_bytes)
(logs / f'host-flutter-live-{args.label}.log').write_bytes(log.read_bytes())

print(f'Flutter live {args.label}: exit={result}; redacted log: {log}')
sys.exit(result)
