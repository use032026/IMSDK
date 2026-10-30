#!/usr/bin/env python3
"""Complete iOS binary closure, including vendored and Dart code assets."""
from pathlib import Path
import argparse
import plistlib
import shutil
import subprocess
import sys
import time

root = Path(__file__).resolve().parents[1]
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('mode', choices=['Release', 'Profile', 'Debug'], nargs='?', default='Release')
parser.add_argument('--work', type=Path, default=root / 'native/ios/build/distribution')
arguments = parser.parse_args()
mode = arguments.mode
release = root / 'dist/ios' / mode
work = arguments.work / mode
work.mkdir(parents=True, exist_ok=True)

def run(*args):
    subprocess.run([str(a) for a in args], check=True)

webrtc = root / 'module/.ios/Pods/WebRTC-SDK/WebRTC.xcframework'
destination = release / 'WebRTC.xcframework'
if not destination.exists():
    entries = plistlib.loads((webrtc / 'Info.plist').read_bytes())['AvailableLibraries']
    command = ['xcodebuild', '-create-xcframework']
    for entry in entries:
        if entry['SupportedPlatform'] == 'ios' and entry.get('SupportedPlatformVariant') in (None, 'simulator'):
            command += ['-framework', str(webrtc / entry['LibraryIdentifier'] / entry['LibraryPath'])]
    command += ['-output', str(destination)]
    run(*command)

# Flutter 3.41's framework exporter leaves the last simulator-only code-asset
# framework at the mode root. Rebuild its XCFramework using the three native
# hook outputs, so an arm64 device never embeds an arm64 simulator binary.
destination = release / 'objective_c.xcframework'
template = release / 'objective_c.framework'
if not destination.exists():
    candidates = list((root / 'module/.dart_tool/hooks_runner/shared/objective_c/build').glob('*/objective_c.dylib'))
    selected = {}
    for candidate in sorted(candidates, key=lambda p: p.stat().st_mtime):
        build = subprocess.check_output(['xcrun','vtool','-show-build',str(candidate)],text=True)
        arch = subprocess.check_output(['xcrun','lipo','-archs',str(candidate)],text=True).strip()
        if 'platform IOS\n' in build:
            selected[('device',arch)] = candidate
        elif 'platform IOSSIMULATOR\n' in build:
            selected[('simulator',arch)] = candidate
    for key in [('device','arm64'),('simulator','arm64'),('simulator','x86_64')]:
        if key not in selected:
            raise SystemExit(f'Missing native code-asset hook output: {key}')
    frameworks = []
    for mode, arches in [('device',['arm64']),('simulator',['arm64','x86_64'])]:
        framework = work / mode / 'objective_c.framework'
        shutil.copytree(template,framework,dirs_exist_ok=True)
        binary = framework / 'objective_c'
        if len(arches)==1:
            shutil.copy2(selected[(mode,arches[0])],binary)
        else:
            run('xcrun','lipo','-create',*[selected[(mode,a)] for a in arches],'-output',binary)
        run('xcrun','install_name_tool','-id','@rpath/objective_c.framework/objective_c',binary)
        info=plistlib.loads((framework/'Info.plist').read_bytes())
        info['CFBundleSupportedPlatforms']=['iPhoneOS' if mode=='device' else 'iPhoneSimulator']
        (framework/'Info.plist').write_bytes(plistlib.dumps(info))
        frameworks.append(framework)
    command=['xcodebuild','-create-xcframework']
    for framework in frameworks:
        command += ['-framework',str(framework)]
    command += ['-output',str(destination)]
    run(*command)
if template.exists():
    saved = work / f'exporter-simulator-only-{time.time_ns()}-objective_c.framework'
    shutil.move(template,saved)

acknowledgements=root/'module/.ios/Pods/Target Support Files/Pods-Runner/Pods-Runner-acknowledgements.plist'
if acknowledgements.exists():
    shutil.copy2(acknowledgements,root/'dist/ios/THIRD_PARTY_NOTICES.plist')
lock=root/'module/.ios/Podfile.lock'
if lock.exists():
    shutil.copy2(lock,root/'module/Podfile.lock')
print('Completed vendored WebRTC and per-platform Objective-C native assets.')
