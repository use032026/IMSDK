#!/usr/bin/env python3
"""Build the Swift/Objective-C facade against the delivered Flutter engine.

The Flutter business/plugin XCFrameworks are built separately by build_ios.sh.
No source or configuration from the original App is read.
"""
from pathlib import Path
import argparse
import plistlib
import shutil
import subprocess

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--mode', choices=('Debug', 'Profile', 'Release'), default='Release')
mode = parser.parse_args().mode
release = root / 'dist/ios' / mode
engine = release / 'Flutter.xcframework'
if not engine.is_dir():
    raise SystemExit(f'Build scripts/build_ios.sh {mode.lower()} before the native facade.')
metadata = plistlib.loads((engine / 'Info.plist').read_bytes())
work = root / 'native/ios/build/facade' / mode
work.mkdir(parents=True, exist_ok=True)
sources = root / 'native/ios/Sources'

def run(*args):
    subprocess.run([str(a) for a in args], check=True)

def sdk_path(name):
    return subprocess.check_output(['xcrun', '--sdk', name, '--show-sdk-path'], text=True).strip()

def engine_slice(simulator, arch):
    for entry in metadata['AvailableLibraries']:
        if entry.get('SupportedPlatform') != 'ios':
            continue
        if (entry.get('SupportedPlatformVariant') == 'simulator') != simulator:
            continue
        if arch in entry['SupportedArchitectures']:
            return engine / entry['LibraryIdentifier']
    raise SystemExit(f'Missing Flutter engine slice: simulator={simulator} arch={arch}')

frameworks = []
for simulator, arches in ((False, ['arm64']), (True, ['arm64', 'x86_64'])):
    label = 'simulator' if simulator else 'device'
    directory = work / label
    framework = directory / 'IMSDKNative.framework'
    headers = framework / 'Headers'
    modules = framework / 'Modules'
    swiftmodules = modules / 'IMSDKNative.swiftmodule'
    for path in (headers, swiftmodules):
        path.mkdir(parents=True, exist_ok=True)
    shutil.copy2(sources / 'IMSDKPluginRegistration.h', headers)
    (headers / 'IMSDKNative.h').write_text('#import <Foundation/Foundation.h>\n#import "IMSDKPluginRegistration.h"\n')
    (modules / 'module.modulemap').write_text('framework module IMSDKNative {\n  umbrella header "IMSDKNative.h"\n  export *\n  module * { export * }\n}\n')
    sdk = sdk_path('iphonesimulator' if simulator else 'iphoneos')
    libraries = []
    for arch in arches:
        target = f'{arch}-apple-ios15.0' + ('-simulator' if simulator else '')
        triple = f'{arch}-apple-ios' + ('-simulator' if simulator else '')
        search = engine_slice(simulator, arch)
        object_file = directory / f'IMSDKPluginRegistration-{arch}.o'
        library = directory / f'IMSDKNative-{arch}'
        run('xcrun', 'clang', '-target', target, '-isysroot', sdk,
            '-fobjc-arc', '-fmodules', '-F', search, '-I', headers,
            '-c', sources / 'IMSDKPluginRegistration.m', '-o', object_file)
        run('xcrun', 'swiftc', '-swift-version', '5', '-target', target, '-sdk', sdk,
            '-F', search, '-F', directory, '-import-underlying-module',
            '-module-name', 'IMSDKNative', '-enable-library-evolution',
            '-emit-library', '-emit-module', '-emit-module-path', swiftmodules / f'{triple}.swiftmodule',
            '-emit-module-interface-path', swiftmodules / f'{triple}.swiftinterface',
            '-emit-objc-header-path', headers / 'IMSDKNative-Swift.h',
            '-Xlinker', '-install_name', '-Xlinker', '@rpath/IMSDKNative.framework/IMSDKNative',
            '-framework', 'Flutter', '-framework', 'UIKit', '-framework', 'Foundation',
            sources / 'IMSDK.swift', object_file, '-o', library)
        libraries.append(library)
    if len(libraries) == 1:
        shutil.copy2(libraries[0], framework / 'IMSDKNative')
    else:
        run('xcrun', 'lipo', '-create', *libraries, '-output', framework / 'IMSDKNative')
    info = {'CFBundleIdentifier': 'com.imsdk.nativebridge', 'CFBundleName': 'IMSDKNative',
            'CFBundleExecutable': 'IMSDKNative', 'CFBundlePackageType': 'FMWK',
            'CFBundleShortVersionString': '0.1.0', 'CFBundleVersion': '1',
            'MinimumOSVersion': '15.0', 'CFBundleSupportedPlatforms': ['iPhoneSimulator' if simulator else 'iPhoneOS']}
    (framework / 'Info.plist').write_bytes(plistlib.dumps(info))
    frameworks.append(framework)

destination = release / 'IMSDKNative.xcframework'
if destination.exists():
    raise SystemExit('Native facade output already exists; preserve/archive it before rebuilding.')
arguments = ['xcodebuild', '-create-xcframework']
for framework in frameworks:
    arguments += ['-framework', str(framework)]
arguments += ['-output', str(destination)]
run(*arguments)
print(f'Built native Swift/Objective-C facade: {destination}')
