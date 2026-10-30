#!/usr/bin/env python3
"""Bind the generated language resources to an asset carried by native builds."""
import argparse
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SDK = ROOT / 'packages/im_sdk'
OUTPUT = SDK / 'assets/l10n/sdk_locale_manifest.json'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def generate():
    bundle = json.loads((SDK / 'l10n.bundle.lock.json').read_text())
    coverage = json.loads((SDK / 'lib/generated/l10n/sdk_coverage.json').read_text())
    assert bundle['catalogVersion'] == coverage['catalogVersion']
    assert len(bundle['locales']) == coverage['localeCount'] == 35
    assert len(bundle['keys']) == 1040
    entries = []
    for locale in bundle['locales']:
        file = SDK / f'lib/l10n/app_{locale}.arb'
        arb = json.loads(file.read_text())
        assert [key for key in arb if not key.startswith('@')] == bundle['keys']
        tag = {'zh': 'zh-CN', 'zh_TW': 'zh-TW', 'pt': 'pt-BR', 'pt_PT': 'pt-PT'}.get(locale, locale)
        entries.append({'locale': tag, 'resourceLocale': locale, 'arbSha256': sha(file)})
    sources = [SDK / 'lib/l10n/app_localizations.dart']
    sources += sorted((SDK / 'lib/l10n').glob('app_localizations_*.dart'))
    sources += sorted((SDK / 'lib/generated/l10n').glob('*'))
    return {
        'generatedBy': 'scripts/write_localization_manifest.py',
        'schemaVersion': 1, 'catalogVersion': bundle['catalogVersion'],
        'localeCount': len(entries), 'keysPerLocale': len(bundle['keys']),
        'locales': entries,
        'generatedSourceSha256': {str(path.relative_to(SDK)): sha(path) for path in sources},
        'bundleReceiptSha256': sha(SDK / 'l10n.bundle.lock.json'),
        'fallbackPolicy': 'SDK/Web exclusive missing translations use English. Existing legal bodies retain their original selection and fallback.',
        'coverageSha256': sha(SDK / 'lib/generated/l10n/sdk_coverage.json'),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    data = (json.dumps(generate(), ensure_ascii=False, indent=2) + '\n').encode()
    if args.check:
        if not OUTPUT.is_file() or OUTPUT.read_bytes() != data:
            raise SystemExit('Native language manifest is stale; regenerate before building.')
        print('Verified native manifest: 35 locales, catalog0.3.0.')
    else:
        OUTPUT.parent.mkdir(parents=True, exist_ok=True)
        OUTPUT.write_bytes(data)
        print(f'Generated {OUTPUT.relative_to(ROOT)}')


if __name__ == '__main__':
    main()
