#!/usr/bin/env python3
"""Link the actual handoff snippets against every delivered iOS platform slice."""
import json
import argparse
from pathlib import Path
import plistlib
import subprocess

ROOT = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--package', type=Path, required=True)
parser.add_argument('--work', type=Path, default=ROOT / '.codex-build/unification-release-20261028/ios-consumers')
parser.add_argument('--report', type=Path, default=ROOT / 'logs/unification-release-20261028/ios-snippet-validation.json')
arguments = parser.parse_args()
PACKAGE = arguments.package.resolve()
WORK = arguments.work.resolve()
WORK.mkdir(parents=True, exist_ok=True)
entries = json.loads((PACKAGE / 'binary/INTEGRATION.json').read_text())
assert len(entries) == 35
assert sum(e['kind'] == 'static' for e in entries) == 3
results = []

for mode in ['Debug', 'Release']:
    packages = sorted((PACKAGE / 'binary' / mode).glob('*.xcframework'))
    assert {p.name for p in packages} == {e['framework'] for e in entries}
    for simulator, arch in [(False, 'arm64'), (True, 'arm64'), (True, 'x86_64')]:
        platform = 'simulator' if simulator else 'device'
        sdk = subprocess.check_output(['xcrun', '--sdk', 'iphonesimulator' if simulator else 'iphoneos', '--show-sdk-path'], text=True).strip()
        target = f'{arch}-apple-ios15.0' + ('-simulator' if simulator else '')
        flags = []
        for package in packages:
            info = plistlib.loads((package / 'Info.plist').read_bytes())
            matches = [x for x in info['AvailableLibraries'] if x['SupportedPlatform'] == 'ios'
                       and (x.get('SupportedPlatformVariant') == 'simulator') == simulator
                       and arch in x['SupportedArchitectures']]
            assert len(matches) == 1, (package, platform, arch)
            item = matches[0]
            framework = package / item['LibraryIdentifier'] / item['LibraryPath']
            flags.extend(['-F', str(framework.parent), '-framework', framework.stem])
        name = f'{mode}-{platform}-{arch}'
        subprocess.run(['xcrun', 'swiftc', '-target', target, '-sdk', sdk,
                        '-module-cache-path', str(WORK / 'ModuleCache'), '-emit-library',
                        '-Xlinker', '-ObjC', *flags, str(PACKAGE / 'examples/HostIntegration.swift'),
                        '-o', str(WORK / f'swift-{name}.dylib')], check=True)
        objc_object = WORK / f'objc-{name}.o'
        search_flags = [v for i, v in enumerate(flags) if v != '-framework' and (i == 0 or flags[i - 1] != '-framework')]
        subprocess.run(['xcrun', 'clang', '-target', target, '-isysroot', sdk,
                        '-fobjc-arc', '-fmodules', f'-fmodules-cache-path={WORK / "ModuleCache"}',
                        *search_flags, '-c', str(PACKAGE / 'examples/HostIntegration.m'),
                        '-o', str(objc_object)], check=True)
        # A Swift-aware host linker supplies compatibility runtimes required by
        # Swift plugins. A pure Objective-C Xcode host should enable Swift support
        # as described in the integration guide (for example, an empty Swift file).
        subprocess.run(['xcrun', 'swiftc', '-target', target, '-sdk', sdk,
                        '-emit-library', '-Xlinker', '-ObjC', '-lc++', *flags,
                        str(objc_object), '-o', str(WORK / f'objc-{name}.dylib')], check=True)
        results.append({'mode': mode, 'platform': platform, 'arch': arch,
                        'swiftAndObjCHandoffSnippetsCompileAndLink': 'passed'})
report = arguments.report
report.parent.mkdir(parents=True, exist_ok=True)
report.write_text(json.dumps(results, indent=2) + '\n')
print(f'Passed actual Swift and Objective-C handoff snippets for {len(results)} mode/platform/architecture combinations.')
