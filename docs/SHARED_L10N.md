# Shared language resources

The `im_l10n_catalog` package in the remote Ln18 repository owns the SDK's versioned translation
sources. `l10n.resources.json` selects version 0.3.0 and the SDK renderer;
`packages/im_sdk/l10n.bundle.json` preserves the Flutter language/key subset.
The generated resources remain in this repository and source deliveries.

`l10n.source.json` pins the GitHub repository, a full commit revision, the
0.3.0 archive and its SHA256. The maintenance command downloads only that
language package into the ignored `.l10n-cache/`; no desktop Ln18 checkout is
required. It validates the archive and cached source before running its generator.
The Flutter toolchain must match `.flutter-version` (or set `FLUTTER_BIN` /
`--flutter` to that version).

Maintainers regenerate explicitly; normal sync also runs `flutter gen-l10n`:

```sh
python3 scripts/sync_l10n.py
python3 scripts/sync_l10n.py --check
# Reuse an existing verified package and locally available Dart dependencies:
python3 scripts/sync_l10n.py --offline --check
```

`--check` does not regenerate SDK outputs; a cold cache may download the pinned
archive and resolve the generator's locked Dart dependencies. `--offline` fails
if those inputs are not already available. The cache can be removed and fetched
again at the next maintenance run. Corrupt or mismatched sources fail without
falling back to `main` or a desktop directory. `--cache-dir` selects a separate
cache for CI. To test unpublished catalog edits, explicitly pass
`--catalog-root /path/to/im_l10n_catalog` or set `IM_L10N_CATALOG_ROOT`.
Normal Flutter,
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

## Local update automation

Use `l10n.changes.json` for pending SDK words. Each entry has `module`, `key`,
`values` keyed by locale, and optional ARB `metadata`. New words require every
catalog locale; existing words may specify only changed locales. Translations
and placeholder metadata are explicit inputs, never guessed.

```sh
python3 scripts/l10n_update.py prepare --consumer-root .
# Codex presents the prepared changes and waits for user confirmation;
# after approval, Codex commits/pushes Ln18, verifies the remote SHA, then continues:
python3 scripts/l10n_update.py adopt --plan /path/from/prepare/plan.json
python3 scripts/l10n_update.py check --consumer-root . --offline
```

Prepare chooses the next patch version by default and handles catalog keys,
SDK profile metadata, archive and plan. Pending work stays in the ignored
`.work/l10n-updates/` directory; retain it until its source changes are published
and adopted. Adopt verifies the archive from a fresh remote download before
updating pins and generating/checking resources. It clears the matching draft
only after every target succeeds, and restores language-owned files/configs on
failure without changing Git's index or unrelated code. These low-level commands do not commit or push. Codex presents the prepared
changes, validation results, repositories and publication scope, then pauses for
explicit user confirmation. After confirmation, Codex handles Git publication,
verifies the remote revision and continues adoption/checks; the user does not
operate Git. Subsequent consumer commits/pushes stay within that confirmed scope.
Do not ask again for the same scope; obtain confirmation for added scope. Neither
a plan file nor successful preparation is publication approval. `--dry-run` preflights adoption; `--revision` pins a specific full remote
commit instead of discovering remote HEAD.

Drafts and local generated-resource drift block ordinary sync/check. The source
independence check also rejects unpublished drafts without adding network access
to normal builds. Existing SDK-specific override entries require explicit source
maintenance; an input that would be swallowed by an override is rejected.

For a mobile-led change that the SDK needs, run prepare from chat-im-cs with
`--sdk-root`, marking new shared words `sdk: true`. Updates to shared words already
selected by the SDK also require including that target, so they cannot silently
be omitted. This does not import entire App modules into the SDK.

## Adding features and adopting a catalog update

New chat-im-cs features can be developed in that repository while their new
language keys are added to Ln18's module ARB files, module index and
`chat_mobile` profile. When the SDK adopts a module or needs the same wording,
also add the relevant keys to the `im_sdk` profile and its selected modules;
retain SDK-specific overrides and supplementary datasets. A mobile feature does
not automatically expand the SDK's selected key set. PC uses its separate JSON
dataset in Ln18.

Create and verify a new catalog version/archive, then have Codex obtain user
confirmation for the concrete change and repository scope before publishing it
to Ln18. Codex verifies the remote revision before continuing consumer adoption. Update `l10n.source.json` with that exact commit,
archive path and SHA256; update `catalogVersion` in both `l10n.resources.json`
and `packages/im_sdk/l10n.bundle.json`. Run sync and check, then test the affected
SDK interfaces and commit the generated ARB/Dart/Web files and both receipts
with the source pin. Published archives remain unchanged. The initial remote
pin deliberately uses the existing 0.3.0 archive and changes no translations.
