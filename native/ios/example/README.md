# Pure native iOS host

This Xcode project contains UIKit/Swift host code and UI tests only. It uses the SDK's public `IMSDKNative` interface and the delivered XCFramework set. It does not import Flutter source, use a Flutter build plugin or podhelper, read the original App's cache, or embed test accounts/messages.

## Normal account/password flow

The default screen shows a consent control and **开始聊天**. It initializes the SDK internally, then calls `openMessenger`; SDK pages own account/password login, the conversation list, and single/group chats. Users do not enter a server URL, credentials JSON or conversation ID. If the host has not supplied integration configuration, it shows **接入方尚未配置聊天服务**.

`IMSDKConfiguration.example.plist` is the configuration template. Fill its empty values with the real service address and stable service realm. In the host target's `Info.plist`, add a Dictionary key named `IMSDKConfiguration` and paste the template dictionary's entries beneath that key. The configuration contains no password, account, token or server secret and requires no extra bundle resource or project generator step. `passwordLogin.space` is `personal` with platform login (`lpp_id`) in the template; enterprise mode uses a fixed `passwordLogin.tenantCode` as developer integration context. For production, connect the consent control to the host's actual policy display and consent handling.

The host backend is responsible for connecting its users with the IM account system. Existing external-credential APIs remain available for that integration; the normal user screen does not expose them.

Changes to the Dart SDK and facade source require rebuilt matching SDK binaries before building this example. The existing `dist` binaries and installed app retain their previously built behavior until rebuilt.

## Explicit Debug diagnostics

The previous technical form remains for integration checks only. In a Debug launch, set `IMSDK_HOST_DIAGNOSTICS=1`, or explicitly supply `IMSDK_HOST_PRIVATE_CONFIG_PATH` as documented below. Normal launches and Release builds do not show that form. Existing non-live UI tests targeting technical controls should set `app.launchEnvironment["IMSDK_HOST_DIAGNOSTICS"] = "1"` before launch.

## Build and run

From the IMSDK root, generate/build the host with:

```sh
IMSDK_IOS_FRAMEWORK_MODE=Debug ./scripts/build_ios_host_example.sh build
```

The generator reads `dist/ios/INTEGRATION.json`, links the complete binary set and embeds only frameworks classified as dynamic. The three static frameworks remain link-only. Set `IMSDK_IOS_FRAMEWORK_MODE` to the already built SDK mode: `Debug`, `Profile`, or `Release`. The current Flutter toolchain's simulator app uses a debug/JIT bundle, so simulator runtime validation must use a complete, matching Debug set containing `kernel_blob.bin`. Release device framework/link validation is a separate evidence type.

Run/Test actions use the delivered `dist/ios/flutter_lldbinit` and its adjacent helper, following the pinned Flutter toolchain's scheme template. This avoids dependence on a local Flutter source checkout for native-host debug integration. Keep both delivered helper files together when moving the SDK.

Choose a dedicated simulator and set `IMSDK_IOS_SIMULATOR_UDID` before testing:

```sh
IMSDK_IOS_FRAMEWORK_MODE=Debug IMSDK_IOS_SIMULATOR_UDID=<dedicated-device-udid> \
  ./scripts/build_ios_host_example.sh test
```

Build intermediates default to `native/ios/example/build/DerivedData`. Both the build script and live-test driver accept `--derived-data <task-directory>` or `IMSDK_IOS_HOST_DERIVED_DATA`. Use a fresh task directory for validation; build with `--no-copy` to validate before replacing the delivered example. The installable simulator app is otherwise copied to `dist/ios/example/IMSDKHost.app`; logs and test results are saved as `logs/host-ios-*`. No production signing identity or provisioning profile is included.

The Debug diagnostics UI accepts configuration, credentials and targets supplied by the host. All diagnostic fields start empty and consent starts off. Credentials are hidden, are not persisted by this form, are not printed, and are cleared after a successful handoff to the SDK. SDK errors show stable codes only.

The customer-service form explicitly selects the current enterprise or the legacy service-account entry. Current-enterprise mode sends only `{"entry":"currentTenant"}` and uses the authenticated tenant's existing contract. It does not append a service-account ID or fall back to the other entry. The legacy branch retains the caller's explicit service-account target.

## Checks without a backend identity

The local UI tests cover uninitialized private-chat/customer-service opens, consent refusal before engine startup, Dart/native ready handshake, local initialization without authentication, unauthenticated target rejection, and engine shutdown. The test-only `https://example.invalid` configuration is non-resolving and is not a real service, account, conversation or message. A local initialization pass does not prove network, identity, message delivery or customer-service availability.

## Authorized live input

The Debug host can load an explicitly supplied private JSON file from its own `tmp` directory. It never reads arbitrary host files or the original App's cache. First stage an already prepared local private input file:

```sh
python3 scripts/stage_ios_host_private_input.py \
  --device <dedicated-device-udid> --input <private-json-path>
```

The script prints only the destination path. It copies a strict whitelist of configuration, SDK credentials and authorized targets; peer credentials, raw responses, passwords and discovery/evidence fields are excluded. Launch the example with `IMSDK_HOST_PRIVATE_CONFIG_PATH` set to that sandbox path. The host consumes and deletes the file, pre-fills the form, and still waits for explicit Initialize/Authenticate/Open actions. The path is the only launch-environment value; credentials never appear in arguments, source, test bundle or logs.

The live-test driver uses a basename resolved within the app's current `tmp` directory. During the bounded test it atomically re-stages consumed input or handles XCTest reinstalling into another data container. A Debug-only reload button, available only with an explicit private input path, lets the same process receive fresh host input after logout/shutdown; credentials are still cleared after each successful handoff. The driver removes any remaining staged files when the test ends. This avoids broadening host file access or putting credentials into the launch environment.

The accepted top-level keys are `configuration` (or the staging helper's `config` alias), `credentials`, optional `directTarget`, and optional `customerServiceTarget`. These contain the public SDK fields documented in `native/ios/README.md`.

`testLiveTargetsFromPrivateDevelopmentInput` skips when no private path is supplied. It requires a real authorized identity and target. The test-runner environment `IMSDK_HOST_LIVE_SCENARIO` selects `direct` or `customer`; optional `IMSDK_HOST_TEST_MESSAGE` types a real test message through the SDK composer, and `IMSDK_HOST_EXPECTED_REPLY` waits for the participating peer's actual reply. These are explicit test markers, not credentials. Inject private file paths and these markers into a local generated `.xctestrun` environment for a live test; never put credentials in the project or test bundle.

Opening an actual chat is distinct from sending, peer receipt, reconnect recovery, and customer-service reception. An optimistic outgoing bubble alone does not prove server receipt; correlate the marker with server/peer evidence. Never infer those results from a locally generated page or mocked server response. Keep customer-service busy/paused settings unchanged; a test-specific thread claim requires its own authorized server operation.

The live regression opens/closes the selected page three times, then repeats after logout/reauthentication and after shutdown/new-engine initialization in the same app process. Every cycle requires current AX content and a real `XCUIElement.tap()` return action; there is no cached-position or coordinate fallback. Pass an existing `--expected-reply` marker to verify real chat history on every opening. `--presentation-mode push|present` selects the existing native SDK mode for this Debug test. The queue test explicitly checks status after each manual refresh; it never changes staff reception settings or claims a thread.

## Physical device and VoiceOver

For an authorized physical device, generate the host against the complete Release SDK framework group, then build the native host/UI tests with the iPhoneOS SDK, a fresh task-local DerivedData directory, the device UDID and the host's development team. The host can use its Debug configuration with the Release SDK binaries, so its private development-input loader is available without a Flutter JIT dependency. Keep signing/provisioning data and device-specific outputs outside the distributable source archive. The generator does not assign a development team; the host owns that choice. Regenerate against Debug before returning to simulator validation.

The staging helper and live driver accept `--platform device`; the default remains `simulator`. For a physical run, the driver stages one whitelisted JSON file into this SDK example's app container, uses `testLiveRepeatedPagesOnPhysicalDevice`, and verifies that the host consumed the file. The test opens/returns three times, then logs out and shuts down; it does not send messages or run the simulator method's credential-reload cycles. Use the same physical DerivedData directory that produced its signed test bundle:

```sh
python3 scripts/run_ios_host_live_test.py --platform device \
  --device <physical-device-udid> --derived-data <physical-derived-data> \
  --input <private-json-path> --scenario direct --presentation-mode push \
  --expected-reply <existing-authorized-reply-marker>
```

For queued service use `--scenario customer --presentation-mode present`. A failed XCTest runner handshake means no business test executed; it must not be counted as a failed or passed SDK workflow. Manual device observations are separate evidence.

For a manual VoiceOver session, explicitly launch the Debug host with `IMSDK_HOST_VOICEOVER_EVIDENCE=1` in addition to the private-input filename and optional presentation mode. The example then observes public UIKit VoiceOver state and samples the current VoiceOver-focused element on notifications/activation. It writes at most 200 samples to its own `tmp/imsdk-voiceover-evidence.json`, with permissions requested as 0600. Samples contain time, booleans, a fixed control category and button trait; they contain no labels, messages, credentials or audio. The observer does not move focus, post accessibility events or enable VoiceOver. Check the actual device file metadata before asserting its permissions.

The operator must verify actual spoken names, swipe focus, double-tap activation and repeated return/open behavior on the phone. Probe samples do not prove speech or the source of a gesture; Accessibility Audit and XCUI taps are not substitutes. Preserve the operator's reported result separately, and restore the original VoiceOver setting after the session. Finish with logout/shutdown and a normal launch without private input; consumed-file absence alone does not prove that a form or process has cleared its in-memory credentials.
