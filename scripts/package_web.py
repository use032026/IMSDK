#!/usr/bin/env python3
"""Package only reviewed Web inputs; never traverse native/private work folders."""
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import tarfile
import zipfile

ROOT = Path(__file__).resolve().parent.parent
WEB = ROOT / 'web'
OUT = ROOT / 'dist' / 'web'
version = json.loads((WEB / 'package.json').read_text())['version']
if OUT.exists():
    raise SystemExit('dist/web already exists. Retain the prior delivery before creating a new one.')
for item in ['im-sdk.js', 'index.js', 'index.cjs', 'types/index.d.ts', 'THIRD_PARTY_NOTICES.txt']:
    if not (WEB / 'dist' / item).is_file():
        raise SystemExit(f'Missing built Web output: {item}')
OUT.mkdir(parents=True)
for item in (WEB / 'dist').iterdir():
    destination = OUT / item.name
    if item.is_dir():
        shutil.copytree(item, destination)
    else:
        shutil.copy2(item, destination)
shutil.copy2(WEB / 'README.md', OUT / 'README.md')
shutil.copytree(WEB / 'example', OUT / 'example')
# Delivered example lives alongside flattened browser bundles.
example = OUT / 'example' / 'index.html'
example.write_text(example.read_text().replace('../dist/im-sdk.js', '../im-sdk.js'))
result = subprocess.run(['npm', 'pack', '--ignore-scripts', '--json', '--pack-destination', str(OUT)],
                        cwd=WEB, check=True, text=True, capture_output=True)
packed = json.loads(result.stdout)[0]
source_inputs = ['src', 'scripts', 'test', 'example', 'handoff', 'package.json', 'package-lock.json', 'tsconfig.json', 'README.md']
with tarfile.open(OUT / f'im_sdk_web_source_{version}.tar.gz', 'w:gz') as archive:
    for item in source_inputs:
        archive.add(WEB / item, arcname=f'im-sdk-web-{version}/{item}')
with zipfile.ZipFile(OUT / f'im_sdk_web_{version}.zip', 'w', zipfile.ZIP_DEFLATED) as archive:
    for path in sorted(OUT.rglob('*')):
        if path.is_file() and path.suffix != '.zip':
            archive.write(path, arcname=f'IMSDK-Web/{path.relative_to(OUT).as_posix()}')
checksums = []
for path in sorted(OUT.rglob('*')):
    if path.is_file() and path.name != 'SHA256SUMS':
        checksums.append(f'{hashlib.sha256(path.read_bytes()).hexdigest()}  {path.relative_to(OUT).as_posix()}')
(OUT / 'SHA256SUMS').write_text('\n'.join(checksums) + '\n')
print(json.dumps({'version': version, 'npm_package': packed['filename'], 'output': str(OUT), 'files': len(checksums)}, ensure_ascii=False))
