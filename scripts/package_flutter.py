#!/usr/bin/env python3
"""Archive the SDK tree only; the original App repository is never read."""
from hashlib import sha256
from pathlib import Path
import fnmatch
import gzip
import io
import json
import re
import tarfile

root = Path(__file__).resolve().parents[1]
output = root / 'dist/flutter'
required = [
    'packages/im_sdk/pubspec.yaml', 'packages/im_sdk/pubspec.lock',
    'packages/im_sdk/lib/im_sdk.dart', 'packages/im_sdk/l10n.yaml',
    'packages/im_sdk/android/src/main/AndroidManifest.xml',
    'packages/im_sdk/ios/im_sdk.podspec',
    'module/pubspec.yaml', 'module/pubspec.lock', 'module/lib/main.dart',
    'examples/flutter_host/pubspec.yaml', 'examples/flutter_host/lib/main.dart',
    'l10n.resources.json', 'l10n.resources.lock.json',
    'scripts/build_android.sh', 'scripts/build_ios.sh',
    'scripts/resolve_dependencies.sh', 'README.md', '.flutter-version',
]
missing = [item for item in required if not (root / item).is_file()]
if missing:
    raise SystemExit('Source delivery is incomplete: ' + ', '.join(missing))

version = re.search(r'^version:\s*(\S+)', (root / 'packages/im_sdk/pubspec.yaml').read_text(), re.M)[1]
for relative in ('packages/im_sdk/pubspec.yaml', 'module/pubspec.yaml', 'examples/flutter_host/pubspec.yaml'):
    text = (root / relative).read_text()
    for value in re.findall(r'^[ ]{4}path:[ \t]*[\'\"]?([^\r\n\'\"]+)', text, re.M):
        destination = ((root / relative).parent / value.strip()).resolve()
        if not destination.is_relative_to(root):
            raise SystemExit(f'External path dependency in {relative}; archive would not be self-contained.')

excluded_dirs = {'.git', '.dart_tool', '.gradle', '.idea', '.android', '.ios', '.symlinks', 'build', 'Pods', 'dist', 'logs', '__pycache__'}
excluded_files = {'.packages', '.flutter-plugins', '.flutter-plugins-dependencies', 'local.properties', 'key.properties', 'Generated.xcconfig', 'flutter_export_environment.sh', 'pubspec_overrides.yaml', 'google-services.json', 'GoogleService-Info.plist', '.DS_Store'}
excluded_patterns = ('*.iml', '.env', '.env.*', '*.jks', '*.keystore', '*.p12', '*.pfx', '*.mobileprovision', '*.p8', '*.pem', '*.key', '*.cer', '*.crt')
roots = ('packages', 'module', 'native', 'examples', 'scripts', 'docs', 'test', 'README.md', '.gitignore', '.flutter-version', 'l10n.resources.json', 'l10n.resources.lock.json')
files = []
for entry in roots:
    start = root / entry
    if not start.exists():
        continue
    candidates = [start] if start.is_file() else list(start.rglob('*'))
    for path in candidates:
        relative = path.relative_to(root)
        if set(relative.parts[:-1]) & excluded_dirs or path.name in excluded_files:
            continue
        if any(fnmatch.fnmatch(path.name, pattern) for pattern in excluded_patterns):
            continue
        if path.is_symlink():
            raise SystemExit(f'Source archive refuses symlinks: {relative}')
        if path.is_file():
            files.append(path)
files = sorted(set(files))
manifest = {
    'sdk': 'im_sdk', 'version': version,
    'flutterVersion': (root / '.flutter-version').read_text().strip(),
    'delivery': 'source', 'files': [],
    'exclusions': 'Build/cache outputs, machine paths, signing material, private vendor configuration and credentials are not delivered.',
    'verification': 'Archive integrity only; backend, native host build and device acceptance require separate evidence.',
}
for path in files:
    content = path.read_bytes()
    manifest['files'].append({'path': path.relative_to(root).as_posix(), 'bytes': len(content), 'sha256': sha256(content).hexdigest()})
manifest_bytes = (json.dumps(manifest, ensure_ascii=False, indent=2) + '\n').encode()
output.mkdir(parents=True, exist_ok=True)
archive = output / f'im_sdk_source_{version}.tar.gz'
with archive.open('wb') as raw:
    with gzip.GzipFile(filename='', mode='wb', fileobj=raw, mtime=0) as zipped:
        with tarfile.open(fileobj=zipped, mode='w') as handle:
            for path in files:
                info = handle.gettarinfo(str(path), arcname='IMSDK/' + path.relative_to(root).as_posix())
                info.uid = info.gid = 0
                info.uname = info.gname = ''
                info.mtime = 0
                with path.open('rb') as content:
                    handle.addfile(info, content)
            info = tarfile.TarInfo('IMSDK/SOURCE_MANIFEST.json')
            info.size = len(manifest_bytes)
            info.mtime = 0
            handle.addfile(info, io.BytesIO(manifest_bytes))
(output / 'SOURCE_MANIFEST.json').write_bytes(manifest_bytes)
with tarfile.open(archive, 'r:gz') as handle:
    for item in manifest['files']:
        content = handle.extractfile('IMSDK/' + item['path']).read()
        if sha256(content).hexdigest() != item['sha256']:
            raise SystemExit('Archive integrity failure: ' + item['path'])
print(f'Archived {len(files)} source files: {archive}')
