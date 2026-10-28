#!/usr/bin/env python3
from hashlib import sha256
from pathlib import Path
import sys

root = Path(sys.argv[1]).resolve()
if not root.is_dir():
    raise SystemExit(f'Output directory not found: {root}')
lines = []
for path in sorted(root.rglob('*')):
    if not path.is_file() or path.name == 'SHA256SUMS':
        continue
    if path.is_symlink():
        raise SystemExit(f'Refusing a symlink in output: {path}')
    digest = sha256()
    with path.open('rb') as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b''):
            digest.update(block)
    lines.append(f'{digest.hexdigest()}  {path.relative_to(root).as_posix()}')
(root / 'SHA256SUMS').write_text('\n'.join(lines) + '\n')
print(f'Checksums saved for {len(lines)} files in {root}')
