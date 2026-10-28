#!/usr/bin/env python3
"""Create a consumer-only H5 handoff from the verified Web SDK binaries."""
import hashlib
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parent.parent
WEB = ROOT / 'web'
SOURCE = WEB / 'handoff'
LIBRARY = ROOT / 'dist/web'
version = json.loads((WEB / 'package.json').read_text())['version']
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--validation-report', type=Path,
                    default=ROOT / 'logs/unification-release-20261028/validation.json')
arguments = parser.parse_args()
report = json.loads(arguments.validation_report.read_text())
if report.get('sdkVersions', {}).get('web') != version or not report.get('realService', {}).get('passed'):
    raise SystemExit('A passing real-service report for this Web SDK version is required.')
validation = report.get('platforms', {}).get('web', {})
if validation.get('status') != 'passed':
    raise SystemExit('A passing Web package validation report is required.')
validation = {key: value for key, value in validation.items() if key != 'cleanup'}
entry_validation = validation.get('defaultEntry', {})
if entry_validation.get('status') != 'passed':
    raise SystemExit('A passing default user entry validation report is required.')
if entry_validation.get('bundledRealService') is not True:
    raise SystemExit('The default entry must use the validated bundled real-service configuration.')
root_entry = SOURCE / 'index.html'
if not root_entry.is_file() or hashlib.sha256(root_entry.read_bytes()).hexdigest() != entry_validation.get('rootEntrySha256'):
    raise SystemExit('The root user entry differs from its validated input.')
for name in ['index.html', 'host-config.js']:
    entry = SOURCE / 'examples/plain-html' / name
    expected = entry_validation.get('sourceSha256', {}).get(name)
    if not entry.is_file() or hashlib.sha256(entry.read_bytes()).hexdigest() != expected:
        raise SystemExit(f'Default user entry changed after validation: {name}')
required_checks = ['registration', 'login', 'friendRequestAccepted', 'conversationList',
                   'directRoundTrip', 'groupCreateRoundTrip', 'singleActiveSpace', 'logoutDisposeClean']
if not all(report['realService'].get('checks', {}).get(name) is True for name in required_checks):
    raise SystemExit('The real-service flow verification is incomplete.')
source_entries = [f'{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.relative_to(WEB / "src").as_posix()}\n'
                  for p in sorted((WEB / 'src').rglob('*')) if p.is_file()]
source_hash = hashlib.sha256(''.join(source_entries).encode()).hexdigest()
if report.get('runtimeSourceSha256', {}).get('web') != source_hash:
    raise SystemExit('Web runtime sources changed after real-service verification.')
OUT = ROOT / 'dist' / f'web-h5-{version}'
ARCHIVE = ROOT / 'dist' / f'IMSDK-Web-H5-{version}.zip'
if OUT.exists() or ARCHIVE.exists():
    raise SystemExit('H5 handoff already exists. Retain that delivery before creating another revision.')

required = [
    SOURCE / 'index.html', SOURCE / 'README.md', SOURCE / 'docs/INTEGRATION.md', SOURCE / 'docs/API.md',
    SOURCE / 'docs/ACCEPTANCE.md', SOURCE / 'examples/plain-html/index.html',
    SOURCE / 'examples/plain-html/host-config.js',
    SOURCE / 'examples/vue/ImChat.vue', SOURCE / 'examples/react/ImChat.tsx',
    LIBRARY / 'im-sdk.js', LIBRARY / 'index.js', LIBRARY / 'index.cjs',
    LIBRARY / 'types/index.d.ts', LIBRARY / 'THIRD_PARTY_NOTICES.txt',
]
for path in required:
    if not path.is_file() or path.is_symlink():
        raise SystemExit(f'Missing ordinary handoff input: {path}')
# Check every existing library delivery file before deriving the new handoff.
for line in (LIBRARY / 'SHA256SUMS').read_text().splitlines():
    digest, name = line.split('  ', 1)
    path = LIBRARY / name
    if hashlib.sha256(path.read_bytes()).hexdigest() != digest:
        raise SystemExit(f'Existing SDK checksum mismatch: {name}')
for path in (WEB / 'dist').rglob('*'):
    if path.is_file():
        delivered = LIBRARY / path.relative_to(WEB / 'dist')
        if not delivered.is_file() or delivered.read_bytes() != path.read_bytes():
            raise SystemExit(f'Local build differs from the validated SDK: {path.name}')
if validation.get('bundleSha256') != hashlib.sha256((LIBRARY / 'im-sdk.js').read_bytes()).hexdigest():
    raise SystemExit('The Web bundle differs from the verified build.')

shutil.copytree(SOURCE, OUT)
sdk = OUT / 'sdk'
sdk.mkdir()
for name in ['im-sdk.js', 'index.js', 'index.cjs', 'THIRD_PARTY_NOTICES.txt']:
    shutil.copy2(LIBRARY / name, sdk / name)
shutil.copytree(LIBRARY / 'types', sdk / 'types')
(OUT / 'npm').mkdir()
packed = subprocess.run(['npm', 'pack', '--ignore-scripts', '--json', '--pack-destination', str(OUT / 'npm')],
                        cwd=WEB, check=True, text=True, capture_output=True)
package = json.loads(packed.stdout)[0]['filename']
manifest = {
    'product': 'IM SDK Web / H5', 'sdkVersion': version, 'documentationRevision': '2026-10-28',
    'npmPackage': f'npm/{package}', 'browserEntry': 'sdk/im-sdk.js',
    'defaultUserEntry': 'index.html',
    'messengerDocument': 'examples/plain-html/index.html',
    'defaultEntryBehavior': 'bundled real-service connection; open directly to register/login without editing configuration; authenticated client opens conversation list',
    'bundleSha256': hashlib.sha256((sdk / 'im-sdk.js').read_bytes()).hexdigest(),
    'runtimeBinaryChangedByHandoff': False,
    'validatedOn': report['validatedOn'],
    'validation': validation,
    'realServiceValidation': report['realService'],
    'registrationSpacePolicy': 'no chooser; personal default; use actual authenticated enterprise response; one active space',
}
(OUT / 'MANIFEST.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
checksums = []
for path in sorted(OUT.rglob('*')):
    if path.is_symlink():
        raise SystemExit(f'Symlink not allowed in consumer handoff: {path}')
    if path.is_file():
        checksums.append(f'{hashlib.sha256(path.read_bytes()).hexdigest()}  {path.relative_to(OUT).as_posix()}')
(OUT / 'SHA256SUMS').write_text('\n'.join(checksums) + '\n')
with zipfile.ZipFile(ARCHIVE, 'w', zipfile.ZIP_DEFLATED) as archive:
    for path in sorted(OUT.rglob('*')):
        if path.is_file():
            archive.write(path, arcname=f'IMSDK-Web-H5-{version}/{path.relative_to(OUT).as_posix()}')
archive_digest = hashlib.sha256(ARCHIVE.read_bytes()).hexdigest()
ARCHIVE.with_suffix('.zip.sha256').write_text(f'{archive_digest}  {ARCHIVE.name}\n')
print(json.dumps({'sdkVersion': version, 'handoffDirectory': str(OUT), 'archive': str(ARCHIVE),
                  'files': len(checksums) + 1, 'archiveSha256': archive_digest}, ensure_ascii=False))
