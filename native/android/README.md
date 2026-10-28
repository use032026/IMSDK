# 原生团队交付入口

当前源码的默认聊天职能已统一为注册、登录、会话列表、添加好友、单聊和新建群聊 / 群聊。`openMessenger` 内提供手机号 / 邮箱注册与好友申请处理；注册默认自动登录个人空间；服务端返回企业登录态时直接进入企业空间，无需选择，同时只登录一个空间。Android 和 iOS 使用同一套移动 SDK 页面。

下方 `dist/IMSDK-Android-0.1.0.zip` 是本次修改前的二进制快照。新增能力需要重新构建 Flutter AAR 并更新交付包；旧包的编译与真实收发记录不覆盖本次新增流程。


直接接入请使用 [独立 Android 交付包说明](handoff/README.md) 与 `dist/IMSDK-Android-0.1.0.zip`；该包包含完整本地 Maven 仓库、独立 Gradle 工程及 Java / Kotlin 示例。以下保留源码工程侧说明。

# Native Android integration

This directory contains the native library, a standalone pure Java host example, and a Kotlin integration example. It does not read source, signing files, credentials, or configuration from the original App repository.

## Build from local artifacts

1. Build the independent Flutter module using the root Android build script. Its full Maven repository must exist at `../../dist/android/maven` relative to this directory, including Flutter/plugin dependencies.
2. Use JDK 17, Android SDK 36 and the included Gradle wrapper. Set `ANDROID_HOME` or provide this directory's own untracked `local.properties` with `sdk.dir`.
3. In this directory run `./gradlew publishReleasePublicationToMavenRepository`. The native artifact `com.imsdk:im-sdk-native:0.1.0` is published into the same local Maven repository.
4. Build the pure native host with `./gradlew -p example :app:assembleDebug`. The example has only the Maven SDK dependency and Android code; no Flutter source or Flutter Gradle plugin is included in its host project.

If module coordinates change, use `-PimSdkFlutterArtifact=<group>:flutter_release:<version>`. If the Maven repository location changes, use `-PimSdkFlutterRepository=<directory>` when building the native facade and update the host repository declaration.

The example's `com.example.imsdkhost` is an explicit development example identity. Its debug APK is not a production release artifact and contains no bundled account, conversation, token or message.

## Host dependency

The host repositories must include the delivered Maven repository, Google's repository, Maven Central, `https://jitpack.io` (WebRTC's audioswitch dependency), and `https://storage.googleapis.com/download.flutter.io`. The host dependency is `implementation("com.imsdk:im-sdk-native:0.1.0")`. Enable AndroidX, Java 17 and core-library desugaring with `com.android.tools:desugar_jdk_libs:2.1.5`. The tested baseline is **minSdk 24 / compileSdk 36**. Repository mirrors in the example are optional network configuration; keep the dependency coordinates and versions intact.

Binary consumers need Android build tools and the delivered Maven repository plus public transitive dependencies; they do not need Flutter tools, module source or the original App checkout. Do not copy only `flutter_release.aar`, because its POM and plugin dependencies are required. The compiled example APK is `dist/android/example/im-sdk-native-host-debug.apk` at the SDK root.

The SDK library supplies its own `ImSdkActivity`. The host retains its own `Application`, launcher Activity, task, App ID, signing and push integration. No JPush or vendor push adapter is included. A host that already contains another Flutter library must complete a compatibility assessment before integrating this prebuilt module.

## Calls and data

Use `com.imsdk.nativebridge.ImSdk` from Kotlin or Java. All callbacks and events run on the main thread. For normal chat call `initialize`, then `openMessenger` after initialization succeeds. SDK pages handle account/password login and open the conversation list with single and group chats. The existing external-credential methods remain available for future host-backend account integration.

- `initialize(context, configuration, callback)`: `apiBaseUrl` (HTTPS), stable `serviceRealmId`, and `privacyConsentGranted=true` are required. `gatewayBaseUrl` (HTTPS/WSS), `storageNamespace` and `locale` are optional.
- `openMessenger(activity, callback)`: opens account/password login, or conversations when a session is already active. Use `passwordLogin` with `space: personal` and `loginType: lpp_id` for personal messaging; enterprise mode requires a fixed `tenantCode`. Users do not enter integration fields.
- `authenticate(credentials, callback)`: `platformUserId`, `userId`, `spaceId`, `accessToken`, `refreshToken`, and ISO 8601 `expiresAt` are required. Optional platform credentials use `platformToken`, `platformRefreshToken`, `deviceSessionToken`, `tenantName`.
- `openDirectConversation(activity, target, callback)`: pass an authorized `conversationId`; optional display metadata is `title`, `peerUserId`, `avatarUrl`.
- `openCustomerService(activity, target, callback)`: explicitly use `{"entry":"currentTenant"}` for the authenticated enterprise's existing customer contract, or pass a real `serviceAccountId` for the brand contract (optional `locale`, `category`, `sourceUrl`). Never substitute an official user projection ID. A successful call presents the real queued/active service state and returns its session map; it does not imply a staff member accepted. Queued or unknown states cannot open chat, even if a conversation ID exists.
- `setEventListener(listener)`: observe documented event maps. Never log raw credential or backend payloads.
- `logout(callback)`: lets Dart finish local account/credential cleanup and closes the SDK page on success. The host backend owns server-side token revocation.
- `shutdown(callback)`: lets Dart shut down, then closes the SDK page and releases the engine on success or error. Native operation timeout retires the engine and rejects pending operations; reinitialize after that error.

The engine waits for Dart's `event` with `type=ready` before invoking methods. Normal page closure preserves the engine and account runtime. Operations are serialized, completions are delivered at most once, startup times out after 20 seconds, and an invoked operation times out after 60 seconds. Native wrapper errors include `SDK_NOT_INITIALIZED`, `SDK_STOPPING`, `SDK_READY_TIMEOUT`, `SDK_OPERATION_TIMEOUT`, `HOST_ACTIVITY_UNAVAILABLE`, and `SDK_PAGE_OPEN_FAILED`. Dart domain errors are propagated without interpretation.

The pure Java example reads developer configuration from `assets/im_sdk_configuration.json`, shows consent, and opens `openMessenger`. Its former JSON form is available only after explicit Debug diagnostics opt-in; see `example/README.md`. A checked consent box must reflect consent actually obtained by the host; it does not replace the host's privacy UX. No account, token or sample conversation is bundled.

On 2026-10-27, the Release Flutter AAR repository and native facade were rebuilt from the updated source with Flutter 3.41.9. The corresponding pure Java Debug APK is `dist/android/example/im-sdk-native-host-debug.apk`. It contains the new account/password and conversation-list flow and the final host system-bar inset fix. Its SHA-256 is `fd8a15a51215a15a726e3af634c14b1421ccea6cefad1358c853b3ebb8013ccd`; the AAR-to-APK packaging audit covers arm64-v8a, armeabi-v7a and x86_64. After future source changes, rebuild and republish both the Dart module and native facade before rebuilding the example.

## Notifications and media

The host owns notification transport and click handling. On cold notification launch, restore the proper host identity, authenticate the matching SDK account/space, validate the target and only then call the typed open API. A bare conversation ID is not sufficient to restore a different account/tenant. No transport notification should be treated as a canonical local message.

Camera/microphone permissions are requested by the corresponding media capability. Saving media on Android 9 and earlier needs legacy write permission. System document selection does not require broad file-library permission. When the SDK Activity detaches while a custom picker/permission request is pending, that request fails once with `ACTIVITY_DETACHED`; the user can retry after reattachment. Host configuration changes and real device media behavior remain integration acceptance items.

The final APK was exercised on the dedicated `IMSDK_UI_20261027` API 35 arm64 emulator (`emulator-5556`): normal account/password login, conversation list, direct/group history, UI message submission and both peer replies displayed in the SDK all passed. The independent peer verified persistence of the two UI messages and its replies. Screenshots capture both reply pages and the final return to the conversation list; the list has close and new-chat actions, with no logout or More popup. The emulator remains running on that list. See `docs/HOST_VALIDATION-2026-10-27.md` for the separate UI, backend and final-package evidence.

Task-local cleanup removed 80 precise intermediate directories, approximately 267 MB (255 MiB). The 2,300 protected files were unchanged; SDK/Maven/APK outputs, dependencies and running simulators were preserved.

That document also retains older external-credential, reopening, logout and customer-service queue evidence as history. Physical-device media, notifications, performance, cross-app backend account mapping and compatibility with an existing host remain separate acceptance items.
