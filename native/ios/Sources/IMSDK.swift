import Flutter
import UIKit

@objc public protocol IMSDKEventListener: AnyObject {
  func imSdkDidReceiveEvent(_ payload: [String: Any])
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
      if self.engine == nil, let failure = self.createEngine() {
        completion(nil, failure)
        return
      }
      self.enqueue(Operation("initialize", arguments: configuration, completion: completion,
        didSucceed: { self.initialized = true }))
    }
  }

  @objc(authenticateWithCredentials:completion:)
  public func authenticate(credentials: [String: Any], completion: @escaping Completion) {
    onMain {
      self.enqueueInitialized(Operation("authenticate", arguments: credentials, completion: completion))
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
      self.enqueueInitialized(Operation("logout", arguments: nil, completion: completion,
        didSucceed: { self.closePage() }))
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
      result(nil)
      eventListener?.imSdkDidReceiveEvent(payload)
    case "ready":
      markReady()
      result(nil)
    case "close":
      result(nil)
      closePage()
    default:
      result(FlutterMethodNotImplemented)
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
