#!/usr/bin/env python3
"""Configure only the regenerated native wrappers of this SDK's Flutter module."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
module = root / 'module'
for relative in ('.android/settings.gradle', '.android/build.gradle'):
    repository_file = module / relative
    if repository_file.exists():
        repository_text = repository_file.read_text()
        if 'maven.aliyun.com/repository/public' not in repository_text:
            repository_text = repository_text.replace('google()', '''// IMSDK repository mirrors, with official repositories retained.
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/public' }
        maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
        google()''')
            repository_file.write_text(repository_text)
android = module / '.android/Flutter/build.gradle'
if android.exists():
    text = android.read_text()
    if 'coreLibraryDesugaringEnabled true' not in text:
        needle = 'compileOptions {'
        if needle not in text:
            raise SystemExit('Unexpected Flutter module Android template; inspect before changing it.')
        text = text.replace(needle, needle + '\n        coreLibraryDesugaringEnabled true', 1)
    dependency = 'coreLibraryDesugaring "com.android.tools:desugar_jdk_libs:2.1.5"'
    if dependency not in text:
        text += '\n// SDK media/notifications dependencies require Java API desugaring.\ndependencies {\n    ' + dependency + '\n}\n'
    android.write_text(text)

podfile = module / '.ios/Podfile'
native_lock = module / 'Podfile.lock'
generated_lock = module / '.ios/Podfile.lock'
if native_lock.exists() and generated_lock.parent.exists() and not generated_lock.exists():
    import shutil
    shutil.copy2(native_lock,generated_lock)
if podfile.exists():
    text = podfile.read_text()
    text = re.sub(r"platform :ios, '[^']+'", "platform :ios, '15.0'", text, count=1)
    marker = '    flutter_additional_ios_build_settings(target)'
    setting = "      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'"
    if setting not in text:
        if marker not in text:
            raise SystemExit('Unexpected Flutter module Podfile; inspect before changing it.')
        text = text.replace(marker, marker + "\n    target.build_configurations.each do |config|\n" + setting + '\n    end', 1)
    podfile.write_text(text)

for relative in ('.ios/Runner.xcodeproj/project.pbxproj', '.ios/Flutter/AppFrameworkInfo.plist'):
    path = module / relative
    if not path.exists():
        continue
    text = path.read_text()
    if path.suffix == '.pbxproj':
        text = re.sub(r'IPHONEOS_DEPLOYMENT_TARGET = [^;]+;', 'IPHONEOS_DEPLOYMENT_TARGET = 15.0;', text)
        # The Objective-C module template has no Swift setting; Swift pods
        # still require it on the integrating target before post_install.
        if 'SWIFT_VERSION = ' not in text:
            text = text.replace('buildSettings = {', 'buildSettings = {\n\t\t\t\tSWIFT_VERSION = 5.0;')
        # The build wrapper must not carry the builder's signing team into delivery.
        text = re.sub(r'^.*DEVELOPMENT_TEAM = .*;\n?', '', text, flags=re.M)
    else:
        text = re.sub(r'(<key>MinimumOSVersion</key>\s*<string>)[^<]+', r'\g<1>15.0', text)
    path.write_text(text)
print('Prepared available module wrappers: Java 17 desugaring / iOS 15; no original App files touched.')
