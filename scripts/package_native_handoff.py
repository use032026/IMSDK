#!/usr/bin/env python3
"""Prepare/finalize binary-only native handoffs without copying a developer checkout."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[1]
VERSION = '0.1.0'
REVISION = '2026-10-28'
EXPECTED_FRAMEWORKS = 35


def digest(path):
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def files(directory):
    for path in sorted(directory.rglob('*')):
        if path.is_symlink():
            raise SystemExit(f'Symlink not allowed in handoff: {path}')
        if path.is_file():
            yield path


def tree_digest(directory):
    entries = [f'{digest(p)}  {p.relative_to(directory).as_posix()}\n' for p in files(directory)]
    return hashlib.sha256(''.join(entries).encode()).hexdigest()


def prepare(platform):
    out = ROOT / 'dist' / f'{platform}-native-{VERSION}'
    archive = ROOT / 'dist' / f'IMSDK-{"iOS" if platform == "ios" else "Android"}-{VERSION}.zip'
    if out.exists() or archive.exists():
        raise SystemExit(f'Retain the previous delivery before preparing another: {out}')
    source = ROOT / 'native' / platform / 'handoff'
    for relative in ['README.md', 'docs/INTEGRATION.md', 'docs/API.md', 'docs/ACCEPTANCE.md']:
        if not (source / relative).is_file():
            raise SystemExit(f'Missing handoff document: {source / relative}')
    if not (source / 'sample-host').is_dir():
        raise SystemExit('Generate the independent sample projects first.')
    shutil.copytree(source, out)
    (out / 'config').mkdir(exist_ok=True)
    if platform == 'ios':
        for mode in ['Debug', 'Release']:
            binary = ROOT / 'dist/ios' / mode
            if len(list(binary.glob('*.xcframework'))) != EXPECTED_FRAMEWORKS:
                raise SystemExit(f'Incomplete iOS {mode} framework set')
            interfaces = list((binary / 'IMSDKNative.xcframework').rglob('*.swiftinterface'))
            if not interfaces or any('func openMessenger(' not in p.read_text() for p in interfaces):
                raise SystemExit(f'iOS {mode} facade lacks openMessenger')
            shutil.copytree(binary, out / 'binary' / mode)
        for name in ['INTEGRATION.json', 'THIRD_PARTY_NOTICES.plist', 'flutter_lldbinit', 'flutter_lldb_helper.py']:
            shutil.copy2(ROOT / 'dist/ios' / name, out / 'binary' / name)
        shutil.copy2(source / 'sample-host/IMSDKHost/IMSDKConfiguration.plist',
                     out / 'config/IMSDKConfiguration.example.plist')
    else:
        shutil.copytree(ROOT / 'dist/android/maven', out / 'maven')
        shutil.copy2(source / 'sample-host/app/src/main/assets/im_sdk_configuration.json',
                     out / 'config/im_sdk_configuration.example.json')
    print(json.dumps({'prepared': str(out)}, ensure_ascii=False))


def finalize(platform):
    out = ROOT / 'dist' / f'{platform}-native-{VERSION}'
    label = 'iOS' if platform == 'ios' else 'Android'
    archive = ROOT / 'dist' / f'IMSDK-{label}-{VERSION}.zip'
    if archive.exists():
        raise SystemExit(f'Retain the previous archive before finalizing another: {archive}')
    report = json.loads((ROOT / 'logs/native-handoff-20261028/validation.json').read_text())
    if report[platform]['status'] != 'passed':
        raise SystemExit('A passing package verification report is required.')
    # Refresh reviewed prose and snippets only; preserve the independently built sample inputs.
    source = ROOT / 'native' / platform / 'handoff'
    shutil.copy2(source / 'README.md', out / 'README.md')
    for name in ['docs', 'examples']:
        shutil.copytree(source / name, out / name, dirs_exist_ok=True)
    forbidden = {'build', '.gradle', 'local.properties', '.DS_Store', 'xcuserdata', '.work', 'logs'}
    for path in files(out):
        rel = path.relative_to(out)
        if set(rel.parts) & forbidden or path.suffix.lower() in {'.apk', '.app', '.ipa', '.jks', '.keystore', '.mobileprovision', '.p12'}:
            raise SystemExit(f'Developer output/private material in delivery: {rel}')
    binary = out / ('binary' if platform == 'ios' else 'maven')
    manifest = {
        'product': f'IM SDK {label}', 'sdkVersion': VERSION,
        'documentationRevision': REVISION, 'deliveryKind': 'binary-sdk-with-native-host-source',
        'binaryTreeSha256': tree_digest(binary),
        'preconfiguredAccountsOrServiceEnvironment': False,
        'validation': report[platform],
        'historicalBusinessValidation': {
            'date': '2026-10-27',
            'environment': 'iOS Debug simulator' if platform == 'ios' else 'Android API 35 arm64 emulator; Debug native host consuming Release SDK',
            'personalPasswordLoginConversationListDirectAndGroupTextRoundTrips': 'passed',
            'physicalDeviceAndProductionPush': 'not_tested',
        },
    }
    if platform == 'ios':
        manifest.update({'frameworksPerMode': EXPECTED_FRAMEWORKS, 'modes': ['Debug', 'Release'],
                         'releaseRebuiltOn': REVISION, 'releaseRuntimeBusinessValidation': 'not_tested'})
    else:
        manifest.update({'mavenCoordinate': f'com.imsdk:im-sdk-native:{VERSION}',
                         'sdkBinaryChangedByHandoff': False, 'publicTransitiveDependenciesRequired': True})
    (out / 'MANIFEST.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    checksums = [f'{digest(p)}  {p.relative_to(out).as_posix()}' for p in files(out) if p.name != 'SHA256SUMS']
    (out / 'SHA256SUMS').write_text('\n'.join(checksums) + '\n')
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED, compresslevel=6) as container:
        for path in files(out):
            container.write(path, f'IMSDK-{label}-{VERSION}/{path.relative_to(out).as_posix()}')
    archive_hash = digest(archive)
    archive.with_suffix('.zip.sha256').write_text(f'{archive_hash}  {archive.name}\n')
    print(json.dumps({'archive': str(archive), 'directory': str(out), 'files': len(checksums) + 1,
                      'sha256': archive_hash, 'archiveBytes': archive.stat().st_size}, ensure_ascii=False))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('stage', choices=['prepare', 'finalize'])
    parser.add_argument('--platform', choices=['ios', 'android', 'all'], default='all')
    arguments = parser.parse_args()
    for item in (['ios', 'android'] if arguments.platform == 'all' else [arguments.platform]):
        (prepare if arguments.stage == 'prepare' else finalize)(item)
