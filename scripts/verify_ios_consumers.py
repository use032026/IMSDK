#!/usr/bin/env python3
"""Compile/link binary-only Swift and Objective-C iOS consumer probes."""
from pathlib import Path
import json
import plistlib
import subprocess

root=Path(__file__).resolve().parents[1]
release=root/'dist/ios/Release'
work=root/'native/ios/build/consumer-check'
work.mkdir(parents=True,exist_ok=True)
packages=sorted(release.glob('*.xcframework'))

def run(*args):
    subprocess.run([str(a) for a in args],check=True)

def select(package,simulator,arch):
    info=plistlib.loads((package/'Info.plist').read_bytes())
    for library in info['AvailableLibraries']:
        if library.get('SupportedPlatform')=='ios' and \
           (library.get('SupportedPlatformVariant')=='simulator')==simulator and \
           arch in library['SupportedArchitectures']:
            framework=package/library['LibraryIdentifier']/library['LibraryPath']
            return framework
    raise SystemExit(f'Missing slice in {package.name}: simulator={simulator} arch={arch}')

swift=work/'BinaryConsumer.swift'
swift.write_text('import UIKit\nimport IMSDKNative\npublic func resolveSDK() -> IMSDK { IMSDK.shared }\n')
manifest=[]
for package in packages:
    framework=select(package,False,'arm64')
    binary=framework/framework.stem
    kind='static' if binary.read_bytes()[:8]==b'!<arch>\n' else 'dynamic'
    manifest.append({'framework':package.name,'kind':kind,
      'xcodeEmbed': 'Do Not Embed' if kind=='static' else 'Embed & Sign'})
(root/'dist/ios/INTEGRATION.json').write_text(json.dumps(manifest,indent=2)+'\n')

for simulator,arch in [(False,'arm64'),(True,'arm64'),(True,'x86_64')]:
    mode='simulator' if simulator else 'device'
    sdk=subprocess.check_output(['xcrun','--sdk','iphonesimulator' if simulator else 'iphoneos','--show-sdk-path'],text=True).strip()
    target=f'{arch}-apple-ios15.0'+('-simulator' if simulator else '')
    flags=[]
    for package in packages:
        framework=select(package,simulator,arch)
        flags += ['-F',str(framework.parent),'-framework',framework.stem]
    # This intentionally links the full registry/plugin set from dist, without
    # a Flutter source project, CocoaPods sources or original App checkout.
    run('xcrun','swiftc','-target',target,'-sdk',sdk,'-emit-library',
        '-Xlinker','-ObjC',*flags,swift,'-o',work/f'consumer-{mode}-{arch}.dylib')
    run('xcrun','clang','-target',target,'-isysroot',sdk,'-fobjc-arc','-fmodules',
        *[value for i,value in enumerate(flags) if value!='-framework' and (i==0 or flags[i-1]!='-framework')],
        '-c',root/'native/ios/Examples/HostIntegration.m',
        '-o',work/f'objc-consumer-{mode}-{arch}.o')
print(f'Binary-only Swift link and Objective-C compile passed for device and both simulator architectures ({len(packages)} XCFrameworks).')
