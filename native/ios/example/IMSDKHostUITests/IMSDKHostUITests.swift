import XCTest

final class IMSDKHostUITests: XCTestCase {
  override func setUpWithError() throws { continueAfterFailure = false }

  private func tap(_ identifier: String, in app: XCUIApplication) {
    let element = app.buttons[identifier]
    XCTAssertTrue(element.waitForExistence(timeout: 15), "Button exists: \(identifier)")
    for _ in 0..<8 where !element.isHittable { app.swipeUp() }
    for _ in 0..<8 where !element.isHittable { app.swipeDown() }
    XCTAssertTrue(element.isHittable, "Button is reachable: \(identifier)")
    element.tap()
  }

  private func expectStatus(_ text: String, in app: XCUIApplication, timeout: TimeInterval = 30) {
    let status = app.staticTexts["sdkStatus"]
    let predicate = NSPredicate(format: "label == %@", text)
    expectation(for: predicate, evaluatedWith: status)
    waitForExpectations(timeout: timeout)
  }

  private func screenshot(_ name: String, app: XCUIApplication) {
    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = name
    attachment.lifetime = .keepAlways
    add(attachment)
  }

  private func waitForAX(_ element: XCUIElement, description: String, timeout: TimeInterval = 30) {
    let predicate = NSPredicate { _, _ in element.exists && element.isHittable }
    let result = XCTWaiter.wait(for: [XCTNSPredicateExpectation(predicate: predicate, object: nil)], timeout: timeout)
    XCTAssertEqual(result, .completed, description)
  }

  private func returnToNativeHost(_ app: XCUIApplication) {
    // A missing Flutter AX tree must fail. Every invocation queries the current
    // page; no position or element is retained from a previous presentation.
    let predicate = NSPredicate(format: "identifier IN %@ OR label IN %@",
      ["im_sdk.chat.back", "im_sdk.chat.close", "im_sdk.customerService.close"],
      ["返回宿主", "返回", "关闭", "Back", "Close"])
    let buttons = app.buttons.matching(predicate)
    let otherControls = app.otherElements.matching(predicate)
    var control: XCUIElement?
    let available = NSPredicate { _, _ in
      for query in [buttons, otherControls] {
        for element in query.allElementsBoundByIndex where element.exists && element.isHittable {
          control = element
          return true
        }
      }
      // The existing Flutter back GestureDetector is an unlabeled Other node.
      // Geometry selects an actual current AX element; its tap is never replaced
      // by a coordinate gesture if that element is missing.
      if let arrow = app.otherElements.allElementsBoundByIndex.first(where: { element in
        let frame = element.frame
        return element.exists && element.isHittable && frame.minX < 8 &&
          frame.minY > 40 && frame.maxY < app.frame.height * 0.18 &&
          frame.width > 0 && frame.width <= 40 && frame.height > 0 && frame.height <= 40
      }) {
        control = arrow
        return true
      }
      return false
    }
    let result = XCTWaiter.wait(for: [XCTNSPredicateExpectation(predicate: available, object: nil)], timeout: 20)
    XCTAssertEqual(result, .completed, "The current SDK page exposes a real, hittable AX return control")
    guard let control else { XCTFail("SDK return AX control is absent"); return }
    control.tap()
    let status = app.staticTexts["sdkStatus"]
    XCTAssertTrue(status.waitForExistence(timeout: 15), "The actual return action restores the native host")
    for _ in 0..<8 where !status.isHittable { app.swipeDown() }
    XCTAssertTrue(status.isHittable, "The native host is visible after returning")
  }

  private func assertChatAX(_ app: XCUIApplication, reply: String?) {
    let composerPredicate = NSPredicate(format: "label CONTAINS %@ OR placeholderValue CONTAINS %@", "输入消息", "输入消息")
    let composer = app.textFields.matching(composerPredicate).firstMatch
    waitForAX(composer, description: "A real chat composer is visible through AX")
    if let reply, !reply.isEmpty {
      let received = app.descendants(matching: .any).matching(
        NSPredicate(format: "label CONTAINS %@", reply)).firstMatch
      waitForAX(received, description: "The authorized peer's actual reply is visible through AX", timeout: 60)
    }
  }

  private func assertQueueAXAndRefresh(_ app: XCUIApplication) {
    let queued = app.staticTexts.matching(NSPredicate(format: "label == %@", "正在排队")).firstMatch
    waitForAX(queued, description: "The authoritative queued status is visible through AX")
    let refresh = app.buttons.matching(NSPredicate(format: "label == %@", "查看接待状态")).firstMatch
    waitForAX(refresh, description: "The queued page exposes its explicit refresh action")
    XCTAssertTrue(refresh.isEnabled)
    refresh.tap()
    let completed = NSPredicate { _, _ in refresh.exists && refresh.isHittable && refresh.isEnabled }
    XCTAssertEqual(XCTWaiter.wait(for: [XCTNSPredicateExpectation(predicate: completed, object: nil)], timeout: 30), .completed)
    waitForAX(queued, description: "Explicit status check retains the real queue state")
    XCTAssertFalse(app.descendants(matching: .any).matching(
      NSPredicate(format: "label CONTAINS %@", "暂时无法查看")).firstMatch.exists,
      "The queue must not hide a failed refresh")
  }

  private func openAndReturn(_ app: XCUIApplication, scenario: String, reply: String?, stage: String, message: String? = nil) {
    tap(scenario == "customer" ? "openCustomerService" : "openDirect", in: app)
    XCTAssertTrue(app.staticTexts["sdkStatus"].waitForNonExistence(timeout: 20))
    if scenario == "customer" { assertQueueAXAndRefresh(app) }
    else { assertChatAX(app, reply: nil) }
    if let message, !message.isEmpty {
      let composer = app.textFields.matching(NSPredicate(format: "label CONTAINS %@ OR placeholderValue CONTAINS %@", "输入消息", "输入消息")).firstMatch
      waitForAX(composer, description: "A writable chat composer is available")
      composer.tap()
      composer.typeText(message + "\n")
      let outgoing = app.descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS %@", message)).firstMatch
      waitForAX(outgoing, description: "The optional first-cycle outgoing marker is visible; server receipt is checked separately")
    }
    if scenario == "direct" { assertChatAX(app, reply: reply) }
    screenshot("live-\(scenario)-\(stage)-real-AX", app: app)
    returnToNativeHost(app)
  }

  private func initializeAndAuthenticate(_ app: XCUIApplication) {
    tap("initialize", in: app)
    expectStatus("初始化完成", in: app)
    XCTAssertEqual(app.staticTexts["engineState"].label, "Engine: ready")
    tap("authenticate", in: app)
    expectStatus("身份核验完成", in: app, timeout: 60)
  }

  private func reloadPrivateInput(_ app: XCUIApplication) {
    tap("reloadPrivateInput", in: app)
    expectStatus("已载入本机私有输入；尚未登录", in: app)
  }

  func testConsentAndUninitializedGuards() {
    let app = XCUIApplication()
    app.launchEnvironment["IMSDK_HOST_DIAGNOSTICS"] = "1"
    app.launch()
    XCTAssertTrue(app.buttons["initialize"].waitForExistence(timeout: 15))
    screenshot("01-native-ios-launch", app: app)
    tap("openDirect", in: app)
    expectStatus("SDK_NOT_INITIALIZED", in: app)
    tap("openCustomerService", in: app)
    expectStatus("SDK_NOT_INITIALIZED", in: app)
    tap("initialize", in: app)
    expectStatus("CONSENT_REQUIRED", in: app)
    XCTAssertEqual(app.staticTexts["engineState"].label, "Engine: not started")
    screenshot("02-consent-required-no-engine", app: app)
  }

  func testReadyAndLocalInitializationWithoutBackendIdentity() {
    let app = XCUIApplication()
    app.launchEnvironment["IMSDK_HOST_DIAGNOSTICS"] = "1"
    app.launch()
    let url = app.textFields["apiBaseURL"]
    XCTAssertTrue(url.waitForExistence(timeout: 15))
    url.tap()
    url.typeText("https://example.invalid")
    app.buttons["keyboardDone"].tap()
    let realm = app.textFields["serviceRealmID"]
    realm.tap()
    realm.typeText("local-ui-check")
    app.buttons["keyboardDone"].tap()
    app.switches["privacyConsent"].tap()
    tap("initialize", in: app)
    expectStatus("初始化完成", in: app)
    XCTAssertEqual(app.staticTexts["engineState"].label, "Engine: ready")
    screenshot("03-ready-local-initialization-no-login", app: app)
    tap("openDirect", in: app)
    expectStatus("NOT_AUTHENTICATED", in: app)
    tap("openCustomerService", in: app)
    expectStatus("NOT_AUTHENTICATED", in: app)
    screenshot("04-authentication-required", app: app)
    tap("shutdown", in: app)
    expectStatus("SDK 已释放", in: app)
    XCTAssertEqual(app.staticTexts["engineState"].label, "Engine: stopped")
  }

  func testLiveTargetsFromPrivateDevelopmentInput() throws {
    guard let path = ProcessInfo.processInfo.environment["IMSDK_HOST_PRIVATE_CONFIG_PATH"], !path.isEmpty else {
      throw XCTSkip("Real backend credentials and authorized targets must be supplied separately")
    }
    let environment = ProcessInfo.processInfo.environment
    let scenario = environment["IMSDK_HOST_LIVE_SCENARIO"] ?? "direct"
    XCTAssertTrue(["direct", "customer"].contains(scenario))
    let reply = environment["IMSDK_HOST_EXPECTED_REPLY"]
    let app = XCUIApplication()
    app.launchEnvironment["IMSDK_HOST_PRIVATE_CONFIG_PATH"] = path
    if let mode = environment["IMSDK_HOST_PRESENTATION_MODE"] {
      XCTAssertTrue(["push", "present"].contains(mode))
      app.launchEnvironment["IMSDK_HOST_PRESENTATION_MODE"] = mode
    }
    // Credentials enter only through the sandbox file. No token copy, relaunch,
    // terminate, direct callback or synthetic close is used below.
    app.launch()
    expectStatus("已载入本机私有输入；尚未登录", in: app)
    initializeAndAuthenticate(app)
    for cycle in 1...3 {
      openAndReturn(app, scenario: scenario, reply: reply, stage: "cycle-\(cycle)",
        message: cycle == 1 ? environment["IMSDK_HOST_TEST_MESSAGE"] : nil)
    }

    tap("logout", in: app)
    expectStatus("IM 账号已退出", in: app)
    tap(scenario == "customer" ? "openCustomerService" : "openDirect", in: app)
    expectStatus("NOT_AUTHENTICATED", in: app)
    reloadPrivateInput(app)
    initializeAndAuthenticate(app)
    openAndReturn(app, scenario: scenario, reply: reply, stage: "after-logout-reauth")

    tap("shutdown", in: app)
    expectStatus("SDK 已释放", in: app)
    XCTAssertEqual(app.staticTexts["engineState"].label, "Engine: stopped")
    tap(scenario == "customer" ? "openCustomerService" : "openDirect", in: app)
    expectStatus("SDK_NOT_INITIALIZED", in: app)
    reloadPrivateInput(app)
    initializeAndAuthenticate(app)
    openAndReturn(app, scenario: scenario, reply: reply, stage: "after-shutdown-new-engine")
    tap("logout", in: app)
    expectStatus("IM 账号已退出", in: app)
    tap("shutdown", in: app)
    expectStatus("SDK 已释放", in: app)
    XCTAssertEqual(app.staticTexts["engineState"].label, "Engine: stopped")
    screenshot("live-\(scenario)-finished-native-host", app: app)
  }

  /// Physical-device AX recovery only. Human VoiceOver speech/focus checks are
  /// recorded separately; this XCTest does not claim VoiceOver validation.
  func testLiveRepeatedPagesOnPhysicalDevice() throws {
    #if targetEnvironment(simulator)
    throw XCTSkip("This entry is reserved for an authorized physical device")
    #else
    let environment = ProcessInfo.processInfo.environment
    guard let path = environment["IMSDK_HOST_PRIVATE_CONFIG_PATH"], !path.isEmpty else {
      throw XCTSkip("Private device input must be supplied separately")
    }
    let scenario = environment["IMSDK_HOST_LIVE_SCENARIO"] ?? "direct"
    XCTAssertTrue(["direct", "customer"].contains(scenario))
    let reply = environment["IMSDK_HOST_EXPECTED_REPLY"]
    if scenario == "direct" {
      XCTAssertFalse(reply?.isEmpty ?? true, "Supply an existing authorized reply; this method sends no messages")
    }
    let app = XCUIApplication()
    app.launchEnvironment["IMSDK_HOST_PRIVATE_CONFIG_PATH"] = path
    if let mode = environment["IMSDK_HOST_PRESENTATION_MODE"] {
      XCTAssertTrue(["push", "present"].contains(mode))
      app.launchEnvironment["IMSDK_HOST_PRESENTATION_MODE"] = mode
    }
    app.launch()
    expectStatus("已载入本机私有输入；尚未登录", in: app)
    initializeAndAuthenticate(app)
    for cycle in 1...3 {
      openAndReturn(app, scenario: scenario, reply: reply, stage: "physical-cycle-\(cycle)")
    }
    tap("logout", in: app)
    expectStatus("IM 账号已退出", in: app)
    tap("shutdown", in: app)
    expectStatus("SDK 已释放", in: app)
    XCTAssertEqual(app.staticTexts["engineState"].label, "Engine: stopped")
    screenshot("physical-\(scenario)-finished-native-host", app: app)
    #endif
  }
}
