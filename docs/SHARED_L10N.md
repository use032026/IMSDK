# Shared language resources

The private `im_l10n_catalog` package owns the SDK's versioned translation
sources. `l10n.resources.json` selects version 0.3.0 and the SDK renderer;
`packages/im_sdk/l10n.bundle.json` preserves the Flutter language/key subset.
The generated resources remain in this repository and source deliveries.

Maintainers regenerate explicitly:

```sh
python3 scripts/sync_l10n.py --catalog-root /path/to/im_l10n_catalog
python3 scripts/sync_l10n.py --catalog-root /path/to/im_l10n_catalog --check
```

`IM_L10N_CATALOG_ROOT` can supply the package checkout instead. Normal Flutter,
native and Web builds consume the retained generated files; they do not need
Ln18 or an external path dependency. The SDK public version and presentation API
are retained. The locale selection now accepts the shared catalog's 35 locales,
including separate Brazilian and European Portuguese resources.

The generated supplementary files contain SDK-owned source-text messages,
Web UI messages, target-language names, translation examples, file validation
messages and legal-document constants. Existing translation and fallback
functions continue to own lookup behavior. In particular, Traditional Chinese
file validation still falls back to the previous Simplified Chinese text.
Legal documents retain all original text, language and platform selection;
this operation does not amend agreements or add translations.

The Flutter profile still selects exactly 1040 keys per locale. Its original
six translations, metadata and 30 wording overrides are retained. New locales
reuse the shared ARB source. Supplementary SDK/Web strings reuse shared keys
only when meaning and parameters agree; missing exclusive translations fall
back explicitly to English and are listed in the generated coverage report.
This is not a claim that every historical screen or legal document is fully
translated into 35 languages. Message translation service targets are separate
from interface language support.

Do not edit generated Dart/TypeScript or ARB files directly. Update the pinned
catalog source or the consumer's explicit override, regenerate and verify the
result. Generated resources are shipped so consuming hosts never need the
generator or the full catalog.
