# Pure Android host example

This Java App consumes the delivered Maven SDK. It has no Flutter source or Flutter Gradle plugin dependency. Build from `native/android` with `./gradlew -p example :app:assembleDebug`; the local SDK Maven repository and public dependencies must already be available for `--offline`.

The default screen shows consent and **开始聊天**. It initializes the SDK internally, then calls `openMessenger`, which owns account/password login, the conversation list and single/group chats. Users do not enter service URLs, credentials JSON or conversation IDs. Without integration configuration the screen shows **接入方尚未配置聊天服务**.

Copy `app/src/main/assets/im_sdk_configuration.example.json` to `app/src/main/assets/im_sdk_configuration.json`, then fill the empty service address, stable service realm with authorized deployment values. The template selects personal messaging with `space: personal` and `loginType: lpp_id`, without enterprise membership. Enterprise mode uses a fixed `tenantCode`; these values are developer configuration, not user fields. Bundle no passwords, tokens, accounts or server secrets in that file. The host must connect its consent UI to its real policy display and consent handling.

The host backend connects the other app's users with the IM account system. External-credential APIs remain available for that future integration. Rebuild and republish the changed Dart module and native facade first: the previously delivered Maven library/APK does not automatically contain `openMessenger`.

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
