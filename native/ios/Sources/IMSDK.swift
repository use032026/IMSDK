import Flutter
import UIKit

@objc public protocol IMSDKEventListener: AnyObject {
  func imSdkDidReceiveEvent(_ payload: [String: Any])
}

/// Supplies host identity and IM credentials from a trusted host backend.
/// A nil session means signed out. Never return a host bearer as an IM bearer.
@objc public protocol IMSDKHostSessionProvider: AnyObject {
  @objc(imSdkReadHostSessionWithCompletion:)
  func imSdkReadHostSession(completion: @escaping ([String: Any]?, NSError?) -> Void)

  @objc(imSdkFetchCredentialsForHostSession:completion:)
  func imSdkFetchCredentials(forHostSession session: [String: Any],
                            completion: @escaping ([String: Any]?, NSError?) -> Void)
}

@objc public enum IMSDKPresentationMode: Int {
  case automatic
  case push
  case present
}

/// Native facade. Keeps one SDK engine and delivers completions/events on the main queue.
@objc(IMSDK) public final class IMSDK: NSObject {
  public typealias Completion = (Any?, NSError?) -> Void
  @objc public static let shared = IMSDK()
  @objc public weak var eventListener: IMSDKEventListener?
  @objc public var presentationMode: IMSDKPresentationMode = .automatic
  /// Set before initializing with hostManagedAuth=true. Provider callbacks run on main.
  @objc public var hostSessionProvider: IMSDKHostSessionProvider? {
    get { sessionProvider }
    set {
      onMain {
        self.sessionProvider = newValue
        self.providerRevision += 1
        if self.initialized && self.hostManagedAuth {
          self.notifyHostSessionChanged { _, _ in }
        }
      }
    }
  }

  private var sessionProvider: IMSDKHostSessionProvider?
  private var providerRevision = 0
  private var hostManagedAuth = false
  private var sdkInterfaceStyle: UIUserInterfaceStyle = .unspecified
  private var engine: FlutterEngine?
  private var channel: FlutterMethodChannel?
  private var ready = false
  private var initialized = false
  private var stopping = false
  private var generation = 0
  // The controller owns Flutter's native accessibility bridge. Keep it attached
  // for this engine's lifetime, including while the SDK page is not presented.
  private var enginePage: IMSDKChatViewController?
  private weak var page: IMSDKChatViewController?
  private var startupTimeout: DispatchWorkItem?
  private var operationTimeout: DispatchWorkItem?
  private var pending: [Operation] = []
  private var active: Operation?

  private final class Operation {
    let method: String
    let arguments: [String: Any]?
    let completion: Completion
    let didSucceed: (() -> Void)?
    let didFinish: ((@escaping () -> Void) -> Void)?
    var completed = false

    init(_ method: String, arguments: [String: Any]?, completion: @escaping Completion,
         didSucceed: (() -> Void)? = nil,
         didFinish: ((@escaping () -> Void) -> Void)? = nil) {
      self.method = method
      self.arguments = arguments
      self.completion = completion
      self.didSucceed = didSucceed
      self.didFinish = didFinish
    }
  }

  private override init() { super.init() }

  @objc(initializeWithConfiguration:completion:)
  public func initialize(configuration: [String: Any], completion: @escaping Completion) {
    onMain {
      guard configuration["privacyConsentGranted"] as? Bool == true else {
        completion(nil, self.error("CONSENT_REQUIRED", "The host must obtain privacy consent before starting the SDK"))
        return
      }
      guard !self.stopping else {
        completion(nil, self.error("SDK_STOPPING", "SDK shutdown is in progress"))
        return
      }
      if configuration["hostManagedAuth"] as? Bool == true && self.sessionProvider == nil {
        completion(nil, self.error("HOST_SESSION_PROVIDER_REQUIRED", "Bind a host session provider first"))
        return
      }
      if self.engine == nil, let failure = self.createEngine() {
        completion(nil, failure)
        return
      }
      self.enqueue(Operation("initialize", arguments: configuration, completion: completion,
        didSucceed: {
          let firstInitialization = !self.initialized
          self.initialized = true
          self.hostManagedAuth = configuration["hostManagedAuth"] as? Bool == true
          if firstInitialization {
            self.applySDKTheme(configuration["themeMode"] as? String ?? "system")
          }
        }))
    }
  }

  @objc(authenticateWithCredentials:completion:)
  public func authenticate(credentials: [String: Any], completion: @escaping Completion) {
    onMain {
      self.enqueueInitialized(Operation("authenticate", arguments: credentials, completion: completion))
    }
  }

  /// Updates the SDK's own UI without changing the host window or login session.
  @objc(updatePresentationWithSettings:completion:)
  public func updatePresentation(settings: [String: Any], completion: @escaping Completion) {
    onMain {
      self.invokePriority("updatePresentation", arguments: settings, completion: completion)
    }
  }

  /// Prepares the session before a page is opened. Does not present any UI.
  @objc(synchronizeHostSessionWithCompletion:)
  public func synchronizeHostSession(completion: @escaping Completion) {
    onMain {
      self.enqueueInitialized(Operation("synchronizeHostSession", arguments: nil, completion: completion))
    }
  }

  /// Bypasses the normal operation queue so an in-flight authentication is invalidated now.
  @objc(notifyHostSessionChangedWithCompletion:)
  public func notifyHostSessionChanged(completion: @escaping Completion) {
    onMain { self.invokePriority("notifyHostSessionChanged", completion: completion) }
  }

  private func invokePriority(_ method: String, arguments: [String: Any]? = nil,
                              closeOnSuccess: Bool = false,
                              completion: @escaping Completion) {
    guard self.ready, self.initialized, !self.stopping, let channel = self.channel else {
      completion(nil, self.error("SDK_NOT_INITIALIZED", "Initialize the SDK first"))
      return
    }
    let expectedGeneration = self.generation
    if method == "shutdown" { self.stopping = true }
    var finished = false
    let finish: Completion = { value, failure in
      guard !finished else { return }
      finished = true
      if failure == nil && closeOnSuccess { self.closePage() }
      completion(value, failure)
    }
    let timeout = DispatchWorkItem {
      let code = method == "updatePresentation" ? "SDK_OPERATION_TIMEOUT" : "HOST_SESSION_TIMEOUT"
      finish(nil, self.error(code, "SDK operation timed out"))
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: timeout)
    channel.invokeMethod(method, arguments: arguments) { value in
      self.onMain {
        timeout.cancel()
        guard self.generation == expectedGeneration else {
          finish(nil, self.error("SDK_RETIRED", "This SDK engine is retired"))
          return
        }
        if let failure = value as? FlutterError {
          finish(nil, self.error(failure.code, "SDK operation failed"))
        } else if let marker = value as? NSObject, marker === FlutterMethodNotImplemented {
          finish(nil, self.error("SDK_METHOD_UNAVAILABLE", "SDK method is unavailable"))
        } else { finish(value, nil) }
      }
    }
  }

  /// Opens the account/password screen, or conversations for an active session.
  @objc(openMessengerFromViewController:completion:)
  public func openMessenger(from presenter: UIViewController, completion: @escaping Completion) {
    open(from: presenter, method: "openMessenger", target: [:], completion: completion)
  }

  @objc(openDirectConversationFromViewController:target:completion:)
  public func openDirectConversation(from presenter: UIViewController, target: [String: Any],
                                     completion: @escaping Completion) {
    open(from: presenter, method: "openDirectConversation", target: target, completion: completion)
  }

  @objc(openCustomerServiceFromViewController:target:completion:)
  public func openCustomerService(from presenter: UIViewController, target: [String: Any],
                                  completion: @escaping Completion) {
    open(from: presenter, method: "openCustomerService", target: target, completion: completion)
  }

  @objc(logoutWithCompletion:)
  public func logout(completion: @escaping Completion) {
    onMain {
      if self.hostManagedAuth {
        self.invokePriority("logout", closeOnSuccess: true, completion: completion)
      } else {
        self.enqueueInitialized(Operation("logout", arguments: nil, completion: completion,
          didSucceed: { self.closePage() }))
      }
    }
  }

  /// Runs Dart shutdown before releasing its engine, including on a Dart error/timeout.
  @objc(shutdownWithCompletion:)
  public func shutdown(completion: @escaping Completion) {
    onMain {
      guard !self.stopping else {
        completion(nil, self.error("SDK_STOPPING", "SDK shutdown is already in progress"))
        return
      }
      guard self.engine != nil else { completion(nil, nil); return }
      if self.hostManagedAuth && self.ready && self.initialized {
        self.invokePriority("shutdown") { value, failure in
          self.disposeEngine(reason: "SDK_SHUTDOWN") { completion(value, failure) }
        }
        return
      }
      self.stopping = true
      self.enqueue(Operation("shutdown", arguments: nil, completion: completion,
        didFinish: { finished in self.disposeEngine(reason: "SDK_SHUTDOWN", completion: finished) }))
    }
  }

  private func createEngine() -> NSError? {
    generation += 1
    let expectedGeneration = generation
    let created = FlutterEngine(name: "im_sdk_engine", project: nil, allowHeadlessExecution: true)
    engine = created
    ready = false
    initialized = false
    // iOS rejects message-handler registration before run. The main queue cannot
    // deliver Dart's ready callback until this synchronous setup returns.
    guard created.run(withEntrypoint: "main") else {
      disposeEngine(reason: "SDK_START_FAILED")
      return error("SDK_START_FAILED", "Unable to start the SDK engine")
    }
    let control = FlutterMethodChannel(name: "im_sdk/control", binaryMessenger: created.binaryMessenger)
    channel = control
    control.setMethodCallHandler { [weak self] call, result in
      guard let self, self.generation == expectedGeneration else {
        result(FlutterError(code: "SDK_RETIRED", message: "This SDK engine is retired", details: nil))
        return
      }
      self.handleDartCall(call, result: result)
    }
    guard IMSDKPluginRegistration.registerGeneratedPlugins(with: created) else {
      disposeEngine(reason: "SDK_PLUGIN_REGISTRANT_MISSING")
      return error("SDK_PLUGIN_REGISTRANT_MISSING", "Link the add-to-app module's generated plugin registry")
    }
    let timeout = DispatchWorkItem { [weak self] in
      guard let self, self.generation == expectedGeneration, !self.ready else { return }
      self.disposeEngine(reason: "SDK_READY_TIMEOUT")
    }
    startupTimeout = timeout
    DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: timeout)
    return nil
  }

  private func handleDartCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "event":
      let payload = call.arguments as? [String: Any] ?? [:]
      if payload["type"] as? String == "ready" { markReady() }
      if payload["type"] as? String == "presentationChanged" {
        let settings = payload["data"] as? [String: Any] ?? payload
        if let mode = settings["themeMode"] as? String { applySDKTheme(mode) }
      }
      result(nil)
      eventListener?.imSdkDidReceiveEvent(payload)
    case "ready":
      markReady()
      result(nil)
    case "close":
      result(nil)
      closePage()
    case "readHostSession", "fetchHostCredentials":
      forwardHostSessionCall(call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func applySDKTheme(_ mode: String) {
    switch mode.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
    case "light": sdkInterfaceStyle = .light
    case "dark": sdkInterfaceStyle = .dark
    case "system": sdkInterfaceStyle = .unspecified
    default: return
    }
    enginePage?.overrideUserInterfaceStyle = sdkInterfaceStyle
  }

  private func forwardHostSessionCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let provider = sessionProvider else {
      result(FlutterError(code: "HOST_SESSION_PROVIDER_REQUIRED", message: "Bind a host session provider first", details: nil))
      return
    }
    let expectedGeneration = generation
    let expectedProvider = providerRevision
    var finished = false
    var timeout: DispatchWorkItem?
    let complete: ([String: Any]?, NSError?) -> Void = { value, failure in
      self.onMain {
        guard !finished else { return }
        finished = true
        timeout?.cancel()
        guard self.generation == expectedGeneration, self.providerRevision == expectedProvider else {
          result(FlutterError(code: "HOST_SESSION_CHANGED", message: "Host session changed", details: nil))
          return
        }
        if failure != nil {
          let requestedCode = failure?.userInfo["code"] as? String ?? failure?.domain ?? ""
          let allowedCodes = ["HOST_SESSION_CHANGED", "HOST_CREDENTIALS_UNAVAILABLE",
                              "HOST_SESSION_UNAVAILABLE", "HOST_SESSION_TIMEOUT"]
          let code = allowedCodes.contains(requestedCode) ? requestedCode : "HOST_SESSION_UNAVAILABLE"
          result(FlutterError(code: code, message: "Host session provider failed", details: nil))
        } else if call.method == "fetchHostCredentials" && value == nil {
          result(FlutterError(code: "HOST_CREDENTIALS_UNAVAILABLE", message: "IM credentials are unavailable", details: nil))
        } else { result(value) }
      }
    }
    let deadline = DispatchWorkItem {
      guard !finished else { return }
      finished = true
      result(FlutterError(code: "HOST_SESSION_TIMEOUT", message: "Host session provider timed out", details: nil))
    }
    timeout = deadline
    DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: deadline)
    if call.method == "readHostSession" {
      provider.imSdkReadHostSession(completion: complete)
    } else {
      guard let snapshot = call.arguments as? [String: Any] else {
        complete(nil, error("INVALID_ARGUMENT", "A host session snapshot is required"))
        return
      }
      provider.imSdkFetchCredentials(forHostSession: snapshot, completion: complete)
    }
  }

  private func markReady() {
    guard !ready else { return }
    ready = true
    startupTimeout?.cancel()
    startupTimeout = nil
    drain()
  }

  private func enqueueInitialized(_ operation: Operation) {
    guard engine != nil,
          initialized || active?.method == "initialize" || pending.contains(where: { $0.method == "initialize" })
    else {
      operation.completion(nil, error("SDK_NOT_INITIALIZED", "Initialize the SDK first"))
      return
    }
    guard !stopping else {
      operation.completion(nil, error("SDK_STOPPING", "SDK shutdown is in progress"))
      return
    }
    enqueue(operation)
  }

  private func enqueue(_ operation: Operation) {
    pending.append(operation)
    drain()
  }

  private func drain() {
    guard ready, engine != nil, active == nil, !pending.isEmpty else { return }
    let operation = pending.removeFirst()
    active = operation
    let timeout = DispatchWorkItem { [weak self, weak operation] in
      guard let self, let operation else { return }
      self.finish(operation, failure: self.error("SDK_OPERATION_TIMEOUT", "SDK operation timed out"),
                  retireEngine: true)
    }
    operationTimeout = timeout
    DispatchQueue.main.asyncAfter(deadline: .now() + 60, execute: timeout)
    channel?.invokeMethod(operation.method, arguments: operation.arguments) { [weak self, weak operation] value in
      guard let self, let operation else { return }
      self.onMain {
        if let failure = value as? FlutterError {
          self.finish(operation, failure: self.error(failure.code, failure.message ?? "SDK operation failed",
                                                      details: failure.details))
        } else if let marker = value as? NSObject, marker === FlutterMethodNotImplemented {
          self.finish(operation, failure: self.error("SDK_METHOD_UNAVAILABLE", "SDK method is unavailable"))
        } else {
          self.finish(operation, value: value)
        }
      }
    }
  }

  private func finish(_ operation: Operation, value: Any? = nil, failure: NSError? = nil,
                      retireEngine: Bool = false) {
    guard !operation.completed, active === operation else { return }
    operation.completed = true
    operationTimeout?.cancel()
    operationTimeout = nil
    active = nil
    if failure == nil { operation.didSucceed?() }
    let complete = {
      operation.completion(value, failure)
      self.drain()
    }
    if retireEngine {
      disposeEngine(reason: "SDK_OPERATION_TIMEOUT", completion: complete)
    } else if let didFinish = operation.didFinish {
      didFinish(complete)
    } else {
      complete()
    }
  }

  private func open(from presenter: UIViewController, method: String, target: [String: Any],
                    completion: @escaping Completion) {
    onMain {
      self.enqueueInitialized(Operation(method, arguments: target,
        completion: { [weak self, weak presenter] value, failure in
          guard let self else { completion(nil, failure); return }
          guard failure == nil else { completion(nil, failure); return }
          guard let presenter else {
            completion(nil, self.error("HOST_VIEW_CONTROLLER_UNAVAILABLE", "The host view controller is unavailable"))
            return
          }
          if let failure = self.showPage(from: presenter) { completion(nil, failure) }
          else { completion(value, nil) }
        }))
    }
  }

  private func showPage(from presenter: UIViewController) -> NSError? {
    if let existing = page {
      if let navigation = existing.navigationController,
         navigation.viewControllers.contains(where: { $0 === existing }) {
        navigation.popToViewController(existing, animated: true)
      } else if existing.viewIfLoaded?.window == nil || existing.presentedViewController != nil {
        return error("HOST_PRESENTATION_BUSY", "The existing SDK page is covered by another presentation")
      }
      return nil
    }
    guard presenter.viewIfLoaded?.window != nil else {
      return error("HOST_VIEW_CONTROLLER_UNAVAILABLE", "Present from a visible host view controller")
    }
    guard let engine else { return error("SDK_NOT_INITIALIZED", "Initialize the SDK first") }
    let navigation = (presenter as? UINavigationController) ?? presenter.navigationController
    let shouldPush = presentationMode == .push || (presentationMode == .automatic && navigation != nil)
    if shouldPush && navigation == nil {
      return error("HOST_NAVIGATION_UNAVAILABLE", "Push mode requires a navigation controller")
    }
    if !shouldPush && presenter.presentedViewController != nil {
      return error("HOST_PRESENTATION_BUSY", "The host is already presenting another view controller")
    }
    let controller: IMSDKChatViewController
    if let retained = enginePage {
      controller = retained
    } else {
      controller = IMSDKChatViewController(engine: engine)
      controller.didClose = { [weak self, weak controller] in
        guard let self, let controller else { return }
        self.pageDidClose(controller)
      }
      enginePage = controller
    }
    controller.modalPresentationStyle = .fullScreen
    controller.overrideUserInterfaceStyle = sdkInterfaceStyle
    page = controller
    if shouldPush { navigation?.pushViewController(controller, animated: true) }
    else { presenter.present(controller, animated: true) }
    return nil
  }

  private func closePage(completion: @escaping () -> Void = {}) {
    guard let controller = page else { completion(); return }
    if let navigation = controller.navigationController,
       navigation.viewControllers.contains(where: { $0 === controller }) {
      if navigation.topViewController === controller && navigation.viewControllers.count > 1 {
        navigation.popViewController(animated: false)
      } else {
        navigation.setViewControllers(navigation.viewControllers.filter { $0 !== controller }, animated: false)
      }
      pageDidClose(controller)
      completion()
    } else {
      controller.dismiss(animated: false) { [weak self] in
        self?.pageDidClose(controller)
        completion()
      }
    }
  }

  private func pageDidClose(_ controller: IMSDKChatViewController) {
    guard page === controller else { return }
    page = nil
    eventListener?.imSdkDidReceiveEvent(["type": "pageClosed"])
  }

  private func disposeEngine(reason: String, completion: @escaping () -> Void = {}) {
    stopping = true
    generation += 1
    startupTimeout?.cancel()
    operationTimeout?.cancel()
    startupTimeout = nil
    operationTimeout = nil
    ready = false
    initialized = false
    hostManagedAuth = false
    channel?.setMethodCallHandler(nil)
    channel = nil
    let retiredEngine = engine
    engine = nil
    let rejected = (active.map { [$0] } ?? []) + pending
    active = nil
    pending.removeAll()
    closePage {
      // UIKit must finish removing the page before its Flutter bridge is retired.
      self.enginePage?.didClose = nil
      retiredEngine?.viewController = nil
      self.enginePage = nil
      retiredEngine?.destroyContext()
      self.stopping = false
      for operation in rejected where !operation.completed {
        operation.completed = true
        operation.completion(nil, self.error(reason, "SDK engine stopped"))
      }
      completion()
    }
  }

  private func error(_ code: String, _ message: String, details: Any? = nil) -> NSError {
    var information: [String: Any] = [NSLocalizedDescriptionKey: message, "code": code]
    if let details { information["details"] = details }
    return NSError(domain: "IMSDK", code: -1, userInfo: information)
  }

  private func onMain(_ action: @escaping () -> Void) {
    if Thread.isMainThread { action() } else { DispatchQueue.main.async(execute: action) }
  }
}

private final class IMSDKChatViewController: FlutterViewController {
  var didClose: (() -> Void)?
  private var hostNavigationBarWasHidden: Bool?

  init(engine: FlutterEngine) { super.init(engine: engine, nibName: nil, bundle: nil) }

  @available(*, unavailable)
  required init(coder: NSCoder) { fatalError("Use the SDK native API") }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let navigation = navigationController {
      if hostNavigationBarWasHidden == nil { hostNavigationBarWasHidden = navigation.isNavigationBarHidden }
      navigation.setNavigationBarHidden(true, animated: animated)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    if let hidden = hostNavigationBarWasHidden {
      navigationController?.setNavigationBarHidden(hidden, animated: animated)
    }
    super.viewWillDisappear(animated)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    hostNavigationBarWasHidden = nil
    if isMovingFromParent || isBeingDismissed || navigationController?.isBeingDismissed == true {
      didClose?()
    }
  }
}
