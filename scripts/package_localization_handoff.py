#!/usr/bin/env python3
"""Package a local localization rebuild with explicit build/consumer evidence.

The existing full real-service release packagers retain their stricter gates.
This entry records its narrower scope and never inherits an older live result.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SDK = ROOT / 'packages/im_sdk'
LOCALIZATION_FILES = {
    'sdk_locale_manifest.json': SDK / 'assets/l10n/sdk_locale_manifest.json',
    'sdk_coverage.json': SDK / 'lib/generated/l10n/sdk_coverage.json',
    'l10n.bundle.lock.json': SDK / 'l10n.bundle.lock.json',
    'l10n.resources.lock.json': ROOT / 'l10n.resources.lock.json',
}


def digest(path):
    result = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            result.update(block)
    return result.hexdigest()


def files(root):
    for path in sorted(root.rglob('*')):
        if path.is_symlink():
            raise ValueError(f'Symlink in delivery: {path}')
        if path.is_file():
            yield path


def tree_digest(root):
    content = ''.join(f'{digest(path)}  {path.relative_to(root).as_posix()}\n' for path in files(root))
    return hashlib.sha256(content.encode()).hexdigest()


def versions():
    native = re.search(r'^version:\s*(\S+)', (SDK / 'pubspec.yaml').read_text(), re.M)[1].split('+')[0]
    return {'native': native, 'web': json.loads((ROOT / 'web/package.json').read_text())['version']}


def runtime_sources():
    return {name: tree_digest(ROOT / folder) for name, folder in {
        'mobile': 'packages/im_sdk/lib', 'module': 'module/lib',
        'nativeIos': 'native/ios/Sources', 'nativeAndroid': 'native/android/src', 'web': 'web/src',
    }.items()}


def localization():
    subprocess.run(['python3', str(ROOT / 'scripts/write_localization_manifest.py'), '--check'], check=True)
    manifest = SDK / 'assets/l10n/sdk_locale_manifest.json'
    value = json.loads(manifest.read_text())
    return {'catalogVersion': value['catalogVersion'], 'localeCount': value['localeCount'],
            'keysPerLocale': value['keysPerLocale'], 'nativeManifestSha256': digest(manifest),
            'coverageSha256': value['coverageSha256'], 'locales': [row['locale'] for row in value['locales']],
            'fallbackPolicy': value['fallbackPolicy']}


def paths(platform):
    version = versions()['web' if platform == 'web' else 'native']
    label = {'ios': 'iOS', 'android': 'Android', 'web': 'Web-H5'}[platform]
    folder = f'web-h5-{version}' if platform == 'web' else f'{platform}-native-{version}'
    return version, label, ROOT / 'dist' / folder, ROOT / 'dist' / f'IMSDK-{label}-{version}.zip'


def attach_localization(out):
    target = out / 'localization'
    target.mkdir(exist_ok=True)
    for name, source in LOCALIZATION_FILES.items():
        shutil.copy2(source, target / name)
    (target / 'README.md').write_text(
        '# 35-language resource update\n\n'
        'Catalog 0.3.0; 35 locales and1040 common ARB keys per locale. '
        'Original six-language values are retained. SDK/Web exclusive missing '
        'translations explicitly fall back to English; see sdk_coverage.json. '
        'Legal bodies keep their existing resources and fallback.\n\n'
        'Hosts can select locale at initialization or call updatePresentation '
        'with locale and/or themeMode. pt-BR and pt-PT are distinct. '
        'The SDK changes its own presentation without resetting the account or route.\n\n'
        'This package is a local localization rebuild. Build, resource integrity '
        'and independent-consumer results are in MANIFEST.json. Current-version '
        'real-backend, physical-device and all-screen visual acceptance are not claimed.\n')


def verify_attached_localization(out):
    for name, source in LOCALIZATION_FILES.items():
        staged = out / 'localization' / name
        if not staged.is_file() or digest(staged) != digest(source):
            raise ValueError(f'Staged localization attachment is stale: {name}')


def verify_web_delivery(out, result, version):
    consumer = result['consumerValidation']
    archives = list((out / 'npm').glob('*.tgz'))
    if len(archives) != 1 or archives[0].name != f'imsdk-web-{version}.tgz' or \
            consumer.get('sdkVersion') != version or \
            consumer.get('artifactSha256') != digest(archives[0]):
        raise ValueError('Web npm package differs from the independently consumed artifact')
    if consumer.get('bundleSha256') != digest(out / 'sdk/im-sdk.js'):
        raise ValueError('Web npm consumer bundle proof differs from the staged browser bundle')
    current = ROOT / 'web/dist/LOCALIZATION.json'
    metadata = json.loads(current.read_text())
    native_manifest = json.loads((SDK / 'assets/l10n/sdk_locale_manifest.json').read_text())
    if metadata.get('sdkVersion') != version or \
            metadata.get('bundleSha256') != digest(out / 'sdk/im-sdk.js') or \
            metadata.get('coverageSourceSha256') != digest(SDK / 'lib/generated/l10n/sdk_coverage.json') or \
            metadata.get('generatedCatalogSha256') != digest(ROOT / 'web/src/generated/l10n/sdk_catalog.ts') or \
            metadata.get('supportedLocales') != [row['locale'] for row in native_manifest['locales']]:
        raise ValueError('Web localization metadata is not bound to the current35-locale sources')
    for path in [out / 'LOCALIZATION.json', out / 'sdk/LOCALIZATION.json']:
        if not path.is_file() or digest(path) != digest(current):
            raise ValueError('Web localization metadata differs from the current build')


def verify_native_language_asset(platform, out):
    expected = (SDK / 'assets/l10n/sdk_locale_manifest.json').read_bytes()
    suffix = 'packages/im_sdk/assets/l10n/sdk_locale_manifest.json'
    if platform == 'ios':
        for mode in ['Debug', 'Release']:
            frameworks = list((out / 'binary' / mode).glob('*.xcframework'))
            if len(frameworks) != 35:
                raise ValueError(f'Incomplete {mode} framework set')
            manifests = list((out / 'binary' / mode / 'App.xcframework').rglob('sdk_locale_manifest.json'))
            if len(manifests) < 2 or any(not str(path).endswith(suffix) or path.read_bytes() != expected for path in manifests):
                raise ValueError(f'{mode} device/simulator language asset missing or stale')
    elif platform == 'android':
        version = versions()['native']
        archives = list((out / 'maven/com/startlink/im_sdk_module/flutter_release' / version).glob('*.aar'))
        if len(archives) != 1:
            raise ValueError('Matching Flutter Release AAR not found')
        with zipfile.ZipFile(archives[0]) as archive:
            matches = [name for name in archive.namelist() if name.endswith(suffix)]
            if len(matches) != 1 or archive.read(matches[0]) != expected:
                raise ValueError('AAR language asset missing or stale')


def prepare(platform, library):
    version, label, out, archive = paths(platform)
    if out.exists() or archive.exists():
        raise ValueError(f'Protect existing delivery: {out}')
    localization()
    source = ROOT / ('web/handoff' if platform == 'web' else f'native/{platform}/handoff')
    shutil.copytree(source, out)
    if platform == 'ios':
        for mode in ['Debug', 'Release']:
            # Both trees are local, frozen build inputs. Hard links avoid a
            # second multi-GB staging copy; the ZIP stores ordinary file bytes.
            shutil.copytree(ROOT / 'dist/ios' / mode, out / 'binary' / mode, copy_function=os.link)
        for name in ['INTEGRATION.json', 'THIRD_PARTY_NOTICES.plist', 'flutter_lldbinit', 'flutter_lldb_helper.py']:
            shutil.copy2(ROOT / 'dist/ios' / name, out / 'binary' / name)
        (out / 'config').mkdir(exist_ok=True)
        shutil.copy2(out / 'sample-host/IMSDKHost/IMSDKConfiguration.plist', out / 'config/IMSDKConfiguration.example.plist')
    elif platform == 'android':
        shutil.copytree(ROOT / 'dist/android/maven', out / 'maven', copy_function=os.link)
        (out / 'config').mkdir(exist_ok=True)
        shutil.copy2(out / 'sample-host/app/src/main/assets/im_sdk_configuration.json', out / 'config/im_sdk_configuration.example.json')
    else:
        if library is None:
            raise ValueError('--library is required for Web')
        for name in ['im-sdk.js', 'index.js', 'index.cjs', 'THIRD_PARTY_NOTICES.txt', 'LOCALIZATION.json']:
            (out / 'sdk').mkdir(exist_ok=True)
            shutil.copy2(library / name, out / 'sdk' / name)
        shutil.copytree(library / 'types', out / 'sdk/types')
        shutil.copy2(library / 'LOCALIZATION.json', out / 'LOCALIZATION.json')
        (out / 'npm').mkdir()
        subprocess.run(['npm', 'pack', '--ignore-scripts', '--pack-destination', str(out / 'npm')], cwd=ROOT / 'web', check=True)
    attach_localization(out)
    verify_native_language_asset(platform, out)
    print(json.dumps({'prepared': str(out), 'version': version}))


def finalize(platform, report_path):
    version, label, out, archive = paths(platform)
    if archive.exists() or not out.is_dir():
        raise ValueError('Prepare a new, unarchived package first')
    report = json.loads(report_path.read_text())
    if report.get('validationScope') != 'localization-rebuild' or report.get('sdkVersions') != versions():
        raise ValueError('A matching localization-rebuild report is required')
    if report.get('localization') != localization() or report.get('runtimeSourceSha256') != runtime_sources():
        raise ValueError('Localization or runtime sources differ from validated inputs')
    result = report.get('platforms', {}).get(platform, {})
    if result.get('status') != 'passed' or result.get('consumerValidation', {}).get('status') != 'passed':
        raise ValueError('Current build and independent-consumer verification must pass')
    binary = out / {'ios': 'binary', 'android': 'maven', 'web': 'sdk'}[platform]
    if result.get('binaryTreeSha256') != tree_digest(binary):
        raise ValueError('Package binaries differ from the validated consumer inputs')
    if result.get('sampleHostTreeSha256') != tree_digest(out / ('examples' if platform == 'web' else 'sample-host')):
        raise ValueError('Consumer sample sources changed after validation')
    if platform == 'web':
        entry_hashes = result.get('entryPointSha256', {})
        for name in ['index.html', 'examples/plain-html/index.html', 'examples/plain-html/host-config.js']:
            if entry_hashes.get(name) != digest(out / name):
                raise ValueError(f'Validated Web entry differs: {name}')
        verify_web_delivery(out, result, version)
    verify_attached_localization(out)
    verify_native_language_asset(platform, out)
    forbidden = {'.git', '.work', 'logs', 'build', '.gradle', 'node_modules', 'xcuserdata'}
    for path in files(out):
        if set(path.relative_to(out).parts) & forbidden or \
                path.name in {'local.properties', '.DS_Store', 'key.properties'} or \
                path.name == '.env' or path.name.startswith('.env.') or \
                path.suffix.lower() in {'.apk', '.ipa', '.keystore', '.jks', '.p12', '.mobileprovision', '.p8', '.pem', '.key'}:
            raise ValueError(f'Private/build input in handoff: {path}')
    manifest = {'product': f'IM SDK {label}', 'sdkVersion': version, 'validatedOn': report['validatedOn'],
                'validationScope': 'localization-rebuild', 'localization': report['localization'],
                'binaryTreeSha256': result['binaryTreeSha256'], 'validation': result,
                'realServiceValidation': {'status': 'not_run_for_this_rebuild'},
                'physicalDeviceValidation': 'not_run', 'remotelyPublished': False}
    if platform == 'ios':
        manifest.update({'modes': ['Debug', 'Release'], 'frameworksPerMode': 35})
    if platform == 'android':
        manifest.update({'mavenCoordinate': f'com.imsdk:im-sdk-native:{version}', 'publicTransitiveDependenciesRequired': True})
    if platform == 'web':
        manifest.update({'browserEntry': 'sdk/im-sdk.js', 'defaultUserEntry': 'index.html'})
    (out / 'MANIFEST.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    sums = ''.join(f'{digest(path)}  {path.relative_to(out).as_posix()}\n' for path in files(out) if path.name != 'SHA256SUMS')
    (out / 'SHA256SUMS').write_text(sums)
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED, compresslevel=6) as container:
        for path in files(out):
            container.write(path, f'IMSDK-{label}-{version}/{path.relative_to(out).as_posix()}')
    with zipfile.ZipFile(archive) as container:
        if container.testzip() is not None:
            raise ValueError('ZIP integrity failure')
    checksum = digest(archive)
    archive.with_suffix('.zip.sha256').write_text(f'{checksum}  {archive.name}\n')
    print(json.dumps({'archive': str(archive), 'bytes': archive.stat().st_size, 'sha256': checksum}))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('stage', choices=['prepare', 'finalize'])
    parser.add_argument('--platform', choices=['ios', 'android', 'web'], required=True)
    parser.add_argument('--library', type=Path)
    parser.add_argument('--validation-report', type=Path)
    args = parser.parse_args()
    if args.stage == 'prepare':
        prepare(args.platform, args.library)
    elif args.validation_report:
        finalize(args.platform, args.validation_report)
    else:
        parser.error('finalize requires --validation-report')


if __name__ == '__main__':
    main()
