#!/usr/bin/env python3
"""Stage only native-host inputs in its own app sandbox; never print payloads."""
import argparse
import json
import os
from pathlib import Path
import subprocess
import tempfile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--device', required=True)
parser.add_argument('--input', required=True, type=Path)
parser.add_argument('--platform', choices=('simulator', 'device'), default='simulator')
arguments = parser.parse_args()
try:
    data = json.loads(arguments.input.read_text())
except (OSError, ValueError):
    raise SystemExit('Unable to read the local private input JSON.') from None

fields = {
    'configuration': {'apiBaseUrl', 'gatewayBaseUrl', 'serviceRealmId', 'storageNamespace', 'privacyConsentGranted', 'locale'},
    'credentials': {'platformUserId', 'userId', 'spaceId', 'accessToken', 'refreshToken', 'expiresAt',
                    'platformToken', 'platformRefreshToken', 'deviceSessionToken', 'tenantName'},
    'directTarget': {'conversationId', 'title', 'peerUserId', 'avatarUrl', 'serviceThreadId'},
    'customerServiceTarget': {'entry', 'serviceAccountId', 'locale', 'category', 'sourceUrl'},
}
staged = {}
for name, allowed in fields.items():
    value = data.get(name, data.get('config') if name == 'configuration' else None)
    if value is None and name in {'directTarget', 'customerServiceTarget'}:
        continue
    if not isinstance(value, dict):
        raise SystemExit('Private input requires configuration and credentials objects.')
    staged[name] = {key: value[key] for key in allowed if key in value}
payload = (json.dumps(staged, ensure_ascii=False) + '\n').encode()
if arguments.platform == 'device':
    # Both the source permissions and the destination are fixed. No source
    # credentials, extra fixture metadata or peer identity enters argv/logs.
    with tempfile.TemporaryDirectory(prefix='imsdk-private-transfer-') as directory:
        source = Path(directory) / 'imsdk-host-private-input.json'
        descriptor = os.open(source, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
        with os.fdopen(descriptor, 'wb') as output:
            output.write(payload)
            output.flush()
            os.fsync(output.fileno())
        try:
            copied = subprocess.run([
                'xcrun', 'devicectl', 'device', 'copy', 'to',
                '--device', arguments.device, '--source', str(source),
                '--destination', 'tmp/imsdk-host-private-input.json',
                '--domain-type', 'appDataContainer',
                '--domain-identifier', 'com.example.imsdkhost.ios',
                '--quiet', '--timeout', '30',
            ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=40)
        except (OSError, subprocess.TimeoutExpired):
            raise SystemExit('Private device input transfer did not complete; payload suppressed.') from None
        if copied.returncode:
            raise SystemExit('Private device input transfer failed; payload suppressed.')
    print('tmp/imsdk-host-private-input.json')
    raise SystemExit(0)

container = subprocess.check_output([
    'xcrun', 'simctl', 'get_app_container', arguments.device,
    'com.example.imsdkhost.ios', 'data'], text=True).strip()
destination = Path(container) / 'tmp' / 'imsdk-host-private-input.json'
destination.parent.mkdir(parents=True, exist_ok=True)
descriptor, temporary_name = tempfile.mkstemp(prefix='.imsdk-private-', dir=destination.parent)
temporary = Path(temporary_name)
try:
    os.fchmod(descriptor, 0o600)
    with os.fdopen(descriptor, 'wb') as output:
        output.write(payload)
        output.flush()
        os.fsync(output.fileno())
    os.replace(temporary, destination)
except BaseException:
    temporary.unlink(missing_ok=True)
    raise
print(destination)
