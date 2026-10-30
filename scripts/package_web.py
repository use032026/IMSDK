#!/usr/bin/env python3
"""Package only reviewed Web inputs; never traverse native/private work folders."""
import hashlib
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import tarfile
import zipfile

ROOT = Path(__file__).resolve().parent.parent
WEB = ROOT / 'web'
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output', type=Path, default=ROOT / 'dist' / 'web')
arguments = parser.parse_args()
OUT = arguments.output.resolve()
if not OUT.is_relative_to((ROOT / 'dist').resolve()):
    raise SystemExit('Web delivery output must stay inside this project dist directory.')
version = json.loads((WEB / 'package.json').read_text())['version']
if OUT.exists():
    raise SystemExit(f'{OUT} already exists. Retain the prior delivery before creating a new one.')
for item in ['im-sdk.js', 'index.js', 'index.cjs', 'types/index.d.ts', 'THIRD_PARTY_NOTICES.txt']:
    if not (WEB / 'dist' / item).is_file():
        raise SystemExit(f'Missing built Web output: {item}')
# The localization audit is delivery metadata. It is packaged with the runtime
# but does not claim current-version real-backend or device validation.
coverage_path = ROOT / 'packages/im_sdk/lib/generated/l10n/sdk_coverage.json'
coverage = json.loads(coverage_path.read_text())
column_locales = ['pt-BR' if locale == 'pt' else locale.replace('_', '-')
                  for locale in coverage['translatedColumnLocales']]
locales = ['zh-CN', *column_locales]
if coverage.get('localeCount') != 35 or len(locales) != 35 or len(set(locales)) != 35:
    raise SystemExit('A complete 35-locale generated coverage report is required.')
localization = {
    'schemaVersion': 1, 'sdkVersion': version, 'catalogVersion': coverage['catalogVersion'],
    'supportedLocales': locales, 'translatedColumnLocales': column_locales,
    'originalLocalesPreserved': ['zh-CN', 'zh-TW', 'en', 'ja', 'ko', 'vi'],
    'web': coverage['tables']['web'],
    'policy': coverage['policy'],
    'legalAndExamples': coverage['legalAndExamples'],
    'bundleSha256': hashlib.sha256((WEB / 'dist/im-sdk.js').read_bytes()).hexdigest(),
    'generatedCatalogSha256': hashlib.sha256((WEB / 'src/generated/l10n/sdk_catalog.ts').read_bytes()).hexdigest(),
    'coverageSourceSha256': hashlib.sha256(coverage_path.read_bytes()).hexdigest(),
    'realServiceValidationForThisVersion': 'not_run',
}
(WEB / 'dist/LOCALIZATION.json').write_text(json.dumps(localization, ensure_ascii=False, indent=2) + '\n')
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
    archive.add(OUT / 'LOCALIZATION.json', arcname=f'im-sdk-web-{version}/LOCALIZATION.json')
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
