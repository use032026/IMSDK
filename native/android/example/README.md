# Pure Android host example

This Java App consumes the delivered Maven SDK. It has no Flutter source or Flutter Gradle plugin dependency. Build from `native/android` with `./gradlew -p example :app:assembleDebug`; the local SDK Maven repository and public dependencies must already be available for `--offline`.

The default launch automatically initializes the SDK and opens login/registration, or conversations for an authenticated instance. No configuration screen, consent switch or Start button is required for this authorized demo. SDK pages own registration, login, friend requests and direct/group chats.

`app/src/main/assets/im_sdk_configuration.json` is already present and contains the same authorized live service connection as Web. No manual edit or copy is needed. It selects personal messaging and contains no account, password, token or server secret. Other applications may override the environment and supply their actual consent result; the SDK's general consent and accepted-identity checks remain enabled.

The host backend connects other applications' users with the IM account system. External-credential APIs remain available. Changes to SDK source require rebuilt matching binaries before consuming them; the current example uses the 0.1.2 Maven SDK.

## Explicit Debug diagnostics

The former JSON form is available only in a Debug build launched with the `IMSDK_HOST_DIAGNOSTICS` string Intent extra set to `1` (an explicit `IMSDK_HOST_PRIVATE_CONFIG_PATH` extra also selects it). For example:

```sh
adb shell am start -n com.example.imsdkhost/.MainActivity \
  --es IMSDK_HOST_DIAGNOSTICS 1
```

This form retains the initialization, external authentication, direct chat, customer service, logout and shutdown buttons. It keeps input in memory, disables saved/autofill state for JSON fields, masks credential input, and clears it after authentication. Operation results and SDK events have separate status lines.

## Debug-only private QA input

First launch the explicit Debug diagnostics screen described above. Long JSON input can be staged without simulated keyboard typing. This route is compiled behind `BuildConfig.DEBUG` and only fills the existing host fields; it does not initialize, authenticate, navigate, send a message or grant privacy consent.

Prepare an owner-only (`0600`) local JSON file with `configuration`, `credentials` and exactly one of `directTarget` / `customerServiceTarget`. Keep it outside source and delivery archives. The helper also accepts an operator file containing unrelated metadata, but explicitly copies only these SDK input objects; `peer`, account labels, passwords and other root fields are never transferred.

```sh
python3 import_qa_input.py /private/path/qa-input.json \
  --kind direct --serial emulator-5554
```

The helper passes data through standard input to `adb run-as`, creates only `files/im-sdk-qa-input.json` in this debug App's private directory, and prints no payload. Use `--kind customer` for the customer-service target. `--dry-run` checks the local file without touching a device; `--adb` selects the installed adb executable.

Tap **Import private QA input**. The App resolves the fixed filename against `getFilesDir()`, checks its canonical parent, limits input to 64 KiB, deletes the file after reading, and rejects root keys outside the four allowed fields. It accepts exactly one target. External files, global paths and URL/Intent credential imports are unsupported. Continue through the visible consent checkbox and public SDK action buttons. Never capture a credential input screen or commit the private file.
