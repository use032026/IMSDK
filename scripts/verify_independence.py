#!/usr/bin/env python3
"""Check local SDK source closure without importing or building the original App."""
from pathlib import Path
import fnmatch
import json
import re
import sys

sys.dont_write_bytecode = True
from l10n_pending import PendingChangeError, check_pending

root = Path(__file__).resolve().parents[1]
original = Path('/Users/starburst') / 'chat-im-cs'
errors = []
checked = {'pubspecs': 0, 'local_dependencies': 0, 'dart_files': 0, 'assets': 0, 'symlinks': 0}
excluded = {'.git', '.dart_tool', '.gradle', '.idea', '.android', '.ios', 'build', 'Pods', '.symlinks', 'dist', 'logs', '__pycache__', '.work', '.local', '.l10n-cache'}
try:
    check_pending(root)
except PendingChangeError as error:
    errors.append(str(error))


def internal(path, label, *, must_exist=True):
    resolved = path.resolve()
    if not resolved.is_relative_to(root):
        errors.append(f'{label}: local path leaves IMSDK ({path})')
    elif must_exist and not resolved.exists():
        errors.append(f'{label}: missing {path.relative_to(root)}')


for spec in sorted(root.rglob('pubspec.yaml')):
    relative = spec.relative_to(root)
    if set(relative.parts[:-1]) & excluded:
        continue
    checked['pubspecs'] += 1
    text = spec.read_text()
    # Only a nested dependency descriptor has a local path. The ordinary
    # package named `path: 1.9.1` is at dependency-name indentation.
    section = None
    for line in text.splitlines():
        heading = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):', line)
        if heading:
            section = heading[1]
        match = re.match(r"^[ ]{4}path:[ \t]*([^#\r\n]+)$", line)
        if section not in {'dependencies', 'dev_dependencies', 'dependency_overrides'} or not match:
            continue
        value = match[1].strip().strip("'\"")
        dependency = Path(value)
        if dependency.is_absolute():
            errors.append(f'{relative}: absolute path dependency is not relocatable')
        internal(spec.parent / dependency, str(relative))
        checked['local_dependencies'] += 1
    in_assets = False
    asset_indent = 0
    for line in text.splitlines():
        match = re.match(r'^(\s+)assets:\s*$', line)
        if match:
            in_assets, asset_indent = True, len(match[1])
            continue
        if in_assets:
            entry = re.match(r'^\s*-\s*[\'\"]?([^\n\'\"]+)', line)
            if entry:
                internal(spec.parent / entry[1].strip(), f'{relative} asset')
                checked['assets'] += 1
            elif line.strip() and len(line) - len(line.lstrip()) <= asset_indent:
                in_assets = False

for lock in sorted(root.rglob('pubspec.lock')):
    if set(lock.relative_to(root).parts[:-1]) & excluded:
        continue
    # Lock descriptions contain path at six-space indentation; anchored
    # horizontal whitespace must not consume the next YAML field or package.
    for line in lock.read_text().splitlines():
        match = re.match(r"^[ ]{6}path:[ \t]*([^#\r\n]+)$", line)
        if match:
            value = match[1].strip().strip("'\"")
            internal(lock.parent / value, f'{lock.relative_to(root)} lock dependency')

# Generated wrapper/configuration paths may point to the Flutter SDK or public
# package cache. They must still never point back to the original App checkout.
for path in root.rglob('*'):
    relative = path.relative_to(root)
    if any(part in {'.git', 'build', 'dist', 'logs', '.work', '.local', '.l10n-cache'} for part in relative.parts[:-1]):
        continue
    if path.is_symlink() and path.resolve().is_relative_to(original):
        errors.append(f'{relative}: symlink points into original App checkout')
    if path.is_file() and path.name in {'package_config.json', '.flutter-plugins-dependencies', 'pubspec_overrides.yaml'}:
        if str(original) in path.read_text():
            errors.append(f'{relative}: generated package mapping points into original App checkout')

for directory in ('packages', 'module', 'native', 'examples', 'scripts'):
    start = root / directory
    if not start.exists():
        errors.append(f'Missing SDK directory: {directory}')
        continue
    for path in start.rglob('*'):
        relative = path.relative_to(root)
        if set(relative.parts[:-1]) & excluded:
            continue
        if path.is_symlink():
            checked['symlinks'] += 1
            internal(path, f'{relative} symlink')
            continue
        if not path.is_file():
            continue
        try:
            text = path.read_text()
        except (UnicodeDecodeError, OSError):
            continue
        # README and docs may describe provenance; they are not runtime paths.
        if path.suffix.lower() not in {'.md', '.txt'} and str(original) in text:
            errors.append(f'{relative}: contains an original-checkout absolute path')
        if path.suffix == '.dart':
            checked['dart_files'] += 1
            if 'package:lpp_mobile/' in text:
                errors.append(f'{relative}: imports the original App package')
            for uri in re.findall(r"^[ \t]*(?:import|export|part(?:[ \t]+of)?)[ \t]+['\"]([^'\"]+)['\"]", text, re.M):
                if uri.startswith('package:im_sdk/'):
                    internal(root / 'packages/im_sdk/lib' / uri[len('package:im_sdk/'):], f'{relative} import')
                elif ':' not in uri:
                    internal(path.parent / uri, f'{relative} import')
        if path.name in {'build.gradle', 'build.gradle.kts'}:
            for value in re.findall(r'\bfiles\(\s*[\'\"]([^\'\"]+)[\'\"]\s*\)', text):
                if '$' not in value:
                    internal(path.parent / value, f'{relative} local Gradle dependency')

quick_accounts = root / 'packages/im_sdk/lib/features/auth/presentation/pages/login_page_quick_accounts.dart'
if quick_accounts.exists() and re.search(r'_QuickLoginAccount\s*\(', quick_accounts.read_text()):
    errors.append('SDK mirror contains App-only built-in quick-login accounts')
for arb in (root / 'packages/im_sdk/lib/l10n').glob('app_*.arb'):
    try:
        summary = json.loads(arb.read_text()).get('authQuickLoginSummary', '')
        if re.search(r'\d{6,}', summary):
            errors.append(f'{arb.relative_to(root)}: built-in credential value in quick-login copy')
    except (ValueError, OSError):
        errors.append(f'{arb.relative_to(root)}: invalid localization source')

required = [
    'packages/im_sdk/lib/im_sdk.dart', 'packages/im_sdk/l10n.yaml',
    'packages/im_sdk/lib/l10n/app_zh.arb',
    'packages/im_sdk/lib/l10n/app_localizations.dart',
    'packages/im_sdk/android/src/main/AndroidManifest.xml',
    'packages/im_sdk/android/src/main/kotlin/com/imsdk/flutter/ImSdkPlugin.kt',
    'packages/im_sdk/ios/Classes/ImSdkPlugin.swift',
    'packages/im_sdk/ios/im_sdk.podspec',
    'module/lib/main.dart', 'module/.metadata',
    'examples/flutter_host/lib/main.dart',
]
for value in required:
    internal(root / value, 'required source')
metadata = root / 'module/.metadata'
if metadata.exists() and not re.search(r'^project_type:\s*module\s*$', metadata.read_text(), re.M):
    errors.append('module/.metadata is not a Flutter module')
module_entry = root / 'module/lib/main.dart'
if module_entry.exists() and 'runImSdkNativeHost()' not in module_entry.read_text():
    errors.append('module entrypoint does not invoke the SDK native host')

result = {'root': str(root), 'status': 'failed' if errors else 'passed', 'checked': checked, 'errors': errors,
          'scope': 'Source closure, assets, local dependencies and original-App independence only; not a backend/device/native-build acceptance.'}
print(json.dumps(result, ensure_ascii=False, indent=2))
if errors:
    sys.exit(1)
