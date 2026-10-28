# 原生团队交付入口

主题和语言的新增源码接入见 [宿主呈现设置同步](../../docs/HOST_PRESENTATION_SYNC.md)，公开入口为 `updatePresentation(settings:completion:)` / `updatePresentationWithSettings:completion:`。已有二进制需重新构建后使用。

当前源码的默认聊天职能已统一为注册、登录、会话列表、添加好友、单聊和新建群聊 / 群聊。`openMessenger` 内提供手机号 / 邮箱注册与好友申请处理；注册默认自动登录个人空间；服务端返回企业登录态时直接进入企业空间，无需选择，同时只登录一个空间。iOS 和 Android 使用同一套移动 SDK 页面。

本轮版本为 **0.1.2**，示例已预置与 Web 相同的真实服务，启动即可注册 / 登录，无需手动修改服务配置。新二进制的原生 UI 注册、好友发送与接受、单聊和两端分别建群的双向真实验收、构建及独立消费结果见 [独立交付包说明](handoff/README.md) 和包内 `MANIFEST.json`；旧版交付物保留为历史快照。

# Native iOS integration

The delivered `IMSDKNative.xcframework` provides the Swift facade and Objective-C-visible API. The host retains its own AppDelegate, scene delegates, notification delegate, Bundle ID, entitlements and signing.

## Integrate prebuilt binaries

Use a complete **35-XCFramework set** from `dist/ios/Release` for device Release integration or `dist/ios/Debug` for simulator/debug use, including App, Flutter, IMSDKNative, FlutterPluginRegistrant, plugin frameworks, WebRTC and objective_c. Add them to the host target's linked frameworks and follow `dist/ios/INTEGRATION.json` for each item's embedding mode:

- Dynamic frameworks: **Embed & Sign**.
- Static `FlutterPluginRegistrant`, `flutter_webrtc`, and `im_sdk`: **Do Not Embed**, link only.

Keep `-ObjC` in inherited linker flags, including Release. Xcode selects the appropriate XCFramework slice; do not copy a simulator framework into a device App. Do not mix build modes or use the exporter's standalone simulator-only `objective_c.framework` in place of the delivered `objective_c.xcframework`. Include `dist/ios/THIRD_PARTY_NOTICES.plist` in the host's acknowledgements workflow.

This binary route requires Xcode and the iOS SDK, without Flutter tools, module source, podhelper, or original App source. Binary-only Swift linking and Objective-C compilation have passed for device arm64 and simulator arm64/x86_64; this is separate from launching a signed host on a device.

Login persistence also needs a valid Keychain group belonging to the host application. The delivered sample already declares its own application identifier and Keychain group through `IMSDKHost.entitlements`; keep that file and `CODE_SIGN_ENTITLEMENTS` when running the simulator with standard ad-hoc signing. This does not share credentials with other applications.

## Optional source rebuild

Build the independent Flutter module with the root build script, then run `python3 scripts/build_ios_facade.py` and `python3 scripts/verify_ios_consumers.py` at the SDK root. The facade builder protects an existing output instead of overwriting it; move a previous facade deliverable to a retained backup before intentionally rebuilding it.

Alternatively, `IMSDKNative.podspec` provides a source facade. Add `pod 'IMSDKNative', :path => '<IMSDK>/native/ios'` to a host CocoaPods project which already installs or exposes the matching module's Flutter dependency. Do not add that source Pod alongside the prebuilt IMSDKNative framework. Source module installation uses this SDK's generated podhelper and never points to the original App repository.

The facade source may also be built into a host framework target. Include both `Sources/IMSDK.swift` and `Sources/IMSDKPluginRegistration.{h,m}` in the same mixed Swift/Objective-C target, expose the helper header to Swift, link the matching Flutter framework, and link the module's generated plugin registry plus its plugins.

The facade resolves `GeneratedPluginRegistrant` from the delivered module and registers it with its explicit engine. Keep `-ObjC` in the host's inherited linker flags, including Release; the local Podspec adds this. Missing registry produces `SDK_PLUGIN_REGISTRANT_MISSING` rather than requiring a custom host AppDelegate superclass. Do not register another unrelated module's registry in its place.

The current SDK minimum is iOS 15. The host must provide purpose strings for media capabilities it enables: `NSCameraUsageDescription`, `NSMicrophoneUsageDescription`, `NSPhotoLibraryUsageDescription`, and `NSPhotoLibraryAddUsageDescription` as applicable. Add speech-recognition disclosure only if that optional capability is intentionally enabled. Push certificates, APNs keys and vendor secrets do not belong in this client package. No APNs/JPush registration or notification delegate takeover is implemented by this facade.

## Swift and Objective-C

Import `IMSDKNative` in Swift. In Objective-C import `<IMSDKNative/IMSDKNative-Swift.h>`. `Examples/HostIntegration.swift` and `Examples/HostIntegration.m` demonstrate calls with caller-supplied configuration, credentials and real targets; they bundle no business data.

Use `IMSDK.shared` on Swift or `[IMSDK shared]` on Objective-C. For the normal chat experience call `initialize`, then `openMessenger(from:completion:)` after initialization succeeds. Objective-C uses `openMessengerFromViewController:completion:`. The SDK provides registration and account/password login, then conversations, friend requests, direct chats and group creation. The default personal configuration is `passwordLogin: ["space": "personal", "loginType": "lpp_id"]`; it does not require enterprise membership. Enterprise mode uses a fixed `tenantCode` and `loginType`. These are developer configuration, not user form fields.

The existing `authenticate` plus `openDirectConversation` / `openCustomerService` methods remain available for a host backend that already issues IM credentials. Account matching across apps belongs to that backend integration. All completions/events run on the main queue. Retain the event listener in the host; the SDK holds it weakly.

Configuration fields are `apiBaseUrl` (required HTTPS), `serviceRealmId` (required stable realm), `privacyConsentGranted` (required true), and optional `gatewayBaseUrl` (HTTPS/WSS), `storageNamespace`, `locale`. Credentials require `platformUserId`, `userId`, `spaceId`, `accessToken`, `refreshToken`, ISO 8601 `expiresAt`, with optional `platformToken`, `platformRefreshToken`, `deviceSessionToken`, `tenantName`. A direct target requires an authorized `conversationId` and optionally `title`, `peerUserId`, `avatarUrl`. A customer-service target explicitly uses `{"entry":"currentTenant"}` or a real `serviceAccountId` with optional `locale`, `category`, `sourceUrl`. Never use officialUserId as the service entity ID or supply both modes. A successful service call returns a session map and presents its actual queued/active state; only active with a real conversation opens chat.

Present from a visible UIViewController. `presentationMode` defaults to `.automatic` (push when a navigation controller exists, otherwise full-screen presentation); `.push` and `.present` explicitly select a mode. A page is created only after Dart accepts the requested SDK entry. `openMessenger` can open before authentication; direct-chat and customer-service entries require an authenticated session. Each engine retains one Flutter view controller across normal closes and reopens, preserving its native accessibility bridge; the active UIKit presentation is tracked separately. Each Dart open still creates a fresh presentation/router revision. `logout` deactivates the local session and closes the page after the Dart foreground transition; server token revocation belongs to the host backend. `shutdown` drains pending Dart logout cleanup and waits for the UIKit page to close before detaching its controller and releasing the engine, including on error. An operation timeout retires the engine and rejects queued operations; reinitialize after that error.

Startup waits for Dart's `event` with `type=ready` and has a 20-second timeout. Invoked operations have a 60-second timeout. `NSError.userInfo["code"]` holds the stable SDK/domain code. Do not log raw payloads or credentials.

## Acceptance boundaries

For a notification cold launch, the host must first restore the correct host identity, authenticate the matching SDK account/space and validate the typed target; only then should it open chat. The host owns notification transport, foreground presentation and badge policy. No notification callback is turned directly into a persisted canonical message by this facade.

The complete UIKit/Swift host project and UI tests are in `example/`; its normal screen loads host configuration and opens the login/conversation flow. The technical form requires explicit Debug launch opt-in. Its build script consumes only delivered binary frameworks. Source changes to the facade and Dart SDK require rebuilt binaries before the updated example can consume `openMessenger`; previously delivered artifacts do not acquire this API automatically. Use the complete Debug group (including kernel_blob.bin and delivered LLDB helpers) for simulator execution. Actual simulator business evidence, including repeated AX access for push chat and full-screen queued service, is in `docs/HOST_VALIDATION-2026-10-27.md`. Device signing, physical media, background notifications, VoiceOver speech/focus navigation, performance and compatibility with another Flutter module require separate acceptance. No production signing identity or installable device IPA is included.
