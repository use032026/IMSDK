import Foundation
import UIKit
import IMSDKNative

/// The host supplies integration configuration; SDK owns login and conversations.
final class HostViewController: UIViewController, IMSDKEventListener {
  private let scroll = UIScrollView()
  private let stack = UIStackView()
  private let status = UILabel()
  private let engineStatus = UILabel()
  private var isOpeningMessenger = false
  private var diagnosticsEnabled: Bool {
    #if DEBUG
    let environment = ProcessInfo.processInfo.environment
    return environment["IMSDK_HOST_DIAGNOSTICS"] == "1" ||
      !(environment["IMSDK_HOST_PRIVATE_CONFIG_PATH"] ?? "").isEmpty
    #else
    return false
    #endif
  }
  private let apiURL = UITextField()
  private let realm = UITextField()
  private let consent = UISwitch()
  private let credentialsJSON = UITextView()
  private let directConversation = UITextField()
  private let serviceAccount = UITextField()
  private let serviceEntry = UISegmentedControl(items: ["当前企业客服", "指定服务账号"])
  private var serviceAccountCaption: UILabel?
  private var suppliedConfiguration: [String: Any] = [:]
  private var suppliedDirectTarget: [String: Any] = [:]
  private var suppliedServiceTarget: [String: Any] = [:]
  #if DEBUG
  private var voiceOverProbe: IMSDKVoiceOverProbe?
  #endif

  override func viewDidLoad() {
    super.viewDidLoad()
    title = diagnosticsEnabled ? "IM SDK 联调" : "聊天"
    view.backgroundColor = .systemBackground
    scroll.translatesAutoresizingMaskIntoConstraints = false
    scroll.keyboardDismissMode = .interactive
    view.addSubview(scroll)
    stack.axis = .vertical
    stack.spacing = 12
    stack.translatesAutoresizingMaskIntoConstraints = false
    scroll.addSubview(stack)
    NSLayoutConstraint.activate([
      scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 16),
      stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
      stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -16)
    ])
    if diagnosticsEnabled { buildDiagnosticsContent() }
    else { buildMessengerContent() }
    IMSDK.shared.eventListener = self
    if diagnosticsEnabled { loadDevelopmentInputIfPresent() }
    #if DEBUG
    if ProcessInfo.processInfo.environment["IMSDK_HOST_VOICEOVER_EVIDENCE"] == "1" {
      voiceOverProbe = IMSDKVoiceOverProbe()
    }
    #endif
    NSLog("IMSDKHost: native host launched; no credentials are bundled")
  }

  private func buildMessengerContent() {
    status.numberOfLines = 0
    status.font = .preferredFont(forTextStyle: .body)
    status.accessibilityIdentifier = "sdkStatus"
    stack.addArrangedSubview(status)
    suppliedConfiguration = Bundle.main.object(forInfoDictionaryKey: "IMSDKConfiguration") as? [String: Any] ?? [:]
    let configured = !(suppliedConfiguration["apiBaseUrl"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
      !(suppliedConfiguration["serviceRealmId"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    status.text = configured ? "登录后即可查看会话，与联系人或群组聊天。" : "接入方尚未配置聊天服务"
    guard configured else { return }
    let consentRow = UIStackView()
    consentRow.axis = .horizontal
    consentRow.spacing = 12
    let consentLabel = UILabel()
    consentLabel.text = "我已阅读并同意本应用的隐私政策"
    consentLabel.numberOfLines = 0
    consent.accessibilityIdentifier = "privacyConsent"
    consentRow.addArrangedSubview(consentLabel)
    consentRow.addArrangedSubview(consent)
    stack.addArrangedSubview(consentRow)
    button("开始聊天", identifier: "openMessenger", action: #selector(openMessenger))
  }

  @objc private func openMessenger() {
    guard !isOpeningMessenger else { return }
    guard consent.isOn else {
      status.text = "请先阅读并同意本应用的隐私政策"
      return
    }
    isOpeningMessenger = true
    var configuration = suppliedConfiguration
    configuration["privacyConsentGranted"] = true
    if configuration["storageNamespace"] == nil { configuration["storageNamespace"] = "native_ios_example" }
    status.text = "正在连接聊天服务…"
    IMSDK.shared.initialize(configuration: configuration) { [weak self] _, failure in
      guard let self else { return }
      guard failure == nil else {
        self.isOpeningMessenger = false
        self.status.text = "暂时无法连接聊天服务，请稍后重试"
        return
      }
      IMSDK.shared.openMessenger(from: self) { [weak self] _, failure in
        self?.isOpeningMessenger = false
        self?.status.text = failure == nil ? "点击开始聊天可继续会话" : "暂时无法打开聊天，请稍后重试"
      }
    }
  }

  private func buildDiagnosticsContent() {
    status.numberOfLines = 0
    status.font = .preferredFont(forTextStyle: .headline)
    status.accessibilityIdentifier = "sdkStatus"
    status.text = "尚未初始化"
    engineStatus.accessibilityIdentifier = "engineState"
    engineStatus.text = "Engine: not started"
    stack.addArrangedSubview(status)
    stack.addArrangedSubview(engineStatus)
    label("此宿主仅链接已交付的二进制 SDK。请由宿主提供获授权的真实 IM 凭证。")

    field(apiURL, identifier: "apiBaseURL", title: "API HTTPS 地址", placeholder: "apiBaseUrl")
    apiURL.keyboardType = .URL
    field(realm, identifier: "serviceRealmID", title: "服务环境标识", placeholder: "serviceRealmId")
    let consentRow = UIStackView()
    consentRow.axis = .horizontal
    consentRow.spacing = 12
    let consentLabel = UILabel()
    consentLabel.text = "已取得必要隐私同意"
    consentLabel.numberOfLines = 0
    consent.accessibilityIdentifier = "privacyConsent"
    consentRow.addArrangedSubview(consentLabel)
    consentRow.addArrangedSubview(consent)
    stack.addArrangedSubview(consentRow)
    button("初始化 SDK", identifier: "initialize", action: #selector(initializeSDK))

    label("IM 凭证 JSON：platformUserId、userId、spaceId、accessToken、refreshToken、expiresAt。凭证仅保留在内存，交接成功后清空表单。")
    credentialsJSON.accessibilityIdentifier = "credentialsJSON"
    credentialsJSON.accessibilityLabel = "IM 凭证 JSON（隐藏）"
    credentialsJSON.accessibilityValue = "未载入凭证"
    credentialsJSON.isSecureTextEntry = true
    credentialsJSON.autocorrectionType = .no
    credentialsJSON.autocapitalizationType = .none
    credentialsJSON.smartQuotesType = .no
    credentialsJSON.smartDashesType = .no
    credentialsJSON.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
    credentialsJSON.layer.borderWidth = 1
    credentialsJSON.layer.borderColor = UIColor.separator.cgColor
    credentialsJSON.layer.cornerRadius = 8
    credentialsJSON.heightAnchor.constraint(equalToConstant: 128).isActive = true
    credentialsJSON.inputAccessoryView = keyboardToolbar()
    stack.addArrangedSubview(credentialsJSON)
    button("提交 IM 凭证", identifier: "authenticate", action: #selector(authenticateSDK))

    field(directConversation, identifier: "conversationID", title: "普通聊天会话", placeholder: "conversationId")
    button("打开普通聊天", identifier: "openDirect", action: #selector(openDirect))
    label("企业客服入口")
    serviceEntry.accessibilityIdentifier = "serviceEntryMode"
    serviceEntry.selectedSegmentIndex = 0
    serviceEntry.addTarget(self, action: #selector(serviceEntryChanged), for: .valueChanged)
    stack.addArrangedSubview(serviceEntry)
    serviceAccountCaption = field(serviceAccount, identifier: "serviceAccountID", title: "指定服务账号", placeholder: "serviceAccountId")
    serviceEntryChanged()
    button("联系企业客服", identifier: "openCustomerService", action: #selector(openService))
    button("退出 IM 账号", identifier: "logout", action: #selector(logoutSDK))
    button("释放 SDK", identifier: "shutdown", action: #selector(shutdownSDK))
    #if DEBUG
    if let path = ProcessInfo.processInfo.environment["IMSDK_HOST_PRIVATE_CONFIG_PATH"], !path.isEmpty {
      button("重新载入本机输入", identifier: "reloadPrivateInput", action: #selector(reloadPrivateInput))
    }
    #endif
  }

  @discardableResult private func label(_ text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = .preferredFont(forTextStyle: .subheadline)
    label.numberOfLines = 0
    label.textColor = .secondaryLabel
    stack.addArrangedSubview(label)
    return label
  }

  @discardableResult private func field(_ input: UITextField, identifier: String, title: String, placeholder: String) -> UILabel {
    let caption = label(title)
    input.accessibilityIdentifier = identifier
    input.placeholder = placeholder
    input.borderStyle = .roundedRect
    input.autocorrectionType = .no
    input.autocapitalizationType = .none
    input.smartQuotesType = .no
    input.smartDashesType = .no
    let height = input.heightAnchor.constraint(equalToConstant: 42)
    height.priority = UILayoutPriority(999)
    height.isActive = true
    input.inputAccessoryView = keyboardToolbar()
    stack.addArrangedSubview(input)
    return caption
  }

  private func button(_ title: String, identifier: String, action: Selector) {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.accessibilityIdentifier = identifier
    button.contentHorizontalAlignment = .leading
    button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
    button.heightAnchor.constraint(greaterThanOrEqualToConstant: 42).isActive = true
    button.addTarget(self, action: action, for: .touchUpInside)
    stack.addArrangedSubview(button)
  }

  private func keyboardToolbar() -> UIToolbar {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let done = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(dismissKeyboard))
    done.accessibilityIdentifier = "keyboardDone"
    toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), done]
    return toolbar
  }

  @objc private func dismissKeyboard() { view.endEditing(true) }

  @objc private func initializeSDK() {
    dismissKeyboard()
    var configuration = suppliedConfiguration
    configuration["apiBaseUrl"] = apiURL.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    configuration["serviceRealmId"] = realm.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    configuration["privacyConsentGranted"] = consent.isOn
    if configuration["storageNamespace"] == nil { configuration["storageNamespace"] = "native_ios_example" }
    status.text = "正在初始化…"
    IMSDK.shared.initialize(configuration: configuration, completion: completion("初始化完成"))
  }

  @objc private func authenticateSDK() {
    dismissKeyboard()
    guard let data = credentialsJSON.text.data(using: .utf8),
          let credentials = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
      status.text = "FORM_JSON_INVALID"
      return
    }
    status.text = "正在核验 IM 身份…"
    IMSDK.shared.authenticate(credentials: credentials) { [weak self] _, failure in
      guard let self else { return }
      self.record(failure, success: "身份核验完成")
      if failure == nil {
        self.credentialsJSON.text = ""
        self.credentialsJSON.accessibilityValue = "凭证已交由 SDK 管理"
      }
    }
  }

  @objc private func openDirect() {
    dismissKeyboard()
    var target = suppliedDirectTarget
    target["conversationId"] = directConversation.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    IMSDK.shared.openDirectConversation(from: self, target: target, completion: completion("普通聊天已打开"))
  }

  @objc private func openService() {
    dismissKeyboard()
    var target: [String: Any]
    if serviceEntry.selectedSegmentIndex == 0 {
      target = ["entry": "currentTenant"]
    } else {
      target = suppliedServiceTarget
      target.removeValue(forKey: "entry")
      target["serviceAccountId"] = serviceAccount.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    IMSDK.shared.openCustomerService(from: self, target: target, completion: completion("企业客服已打开"))
  }

  @objc private func serviceEntryChanged() {
    let currentTenant = serviceEntry.selectedSegmentIndex == 0
    serviceAccount.isHidden = currentTenant
    serviceAccountCaption?.isHidden = currentTenant
  }

  @objc private func logoutSDK() { IMSDK.shared.logout(completion: completion("IM 账号已退出")) }

  @objc private func shutdownSDK() {
    IMSDK.shared.shutdown { [weak self] _, failure in
      self?.engineStatus.text = "Engine: stopped"
      self?.record(failure, success: "SDK 已释放")
    }
  }

  private func completion(_ success: String) -> IMSDK.Completion {
    { [weak self] _, failure in self?.record(failure, success: success) }
  }

  private func record(_ failure: NSError?, success: String) {
    if let failure {
      let code = failure.userInfo["code"] as? String ?? "SDK_ERROR"
      status.text = code
      NSLog("IMSDKHost: operation failed with code %@", code)
    } else {
      status.text = success
      NSLog("IMSDKHost: operation completed")
    }
  }

  func imSdkDidReceiveEvent(_ payload: [String: Any]) {
    guard let type = payload["type"] as? String else { return }
    if type == "ready" { engineStatus.text = "Engine: ready" }
    NSLog("IMSDKHost: SDK event %@", type)
  }

  /// Development-only input transfer. The launch argument is a path, never a token.
  #if DEBUG
  @objc private func reloadPrivateInput() {
    dismissKeyboard()
    loadDevelopmentInputIfPresent()
  }
  #endif

  private func loadDevelopmentInputIfPresent(attempt: Int = 0) {
    #if DEBUG
    guard let path = ProcessInfo.processInfo.environment["IMSDK_HOST_PRIVATE_CONFIG_PATH"] else { return }
    let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).standardizedFileURL
    let file = path.contains("/") ? URL(fileURLWithPath: path).standardizedFileURL
      : temporaryURL.appendingPathComponent(path).standardizedFileURL
    guard file.path.hasPrefix(temporaryURL.path + "/") else { status.text = "PRIVATE_INPUT_PATH_REJECTED"; return }
    if !FileManager.default.fileExists(atPath: file.path), attempt < 100 {
      status.text = "等待本机私有输入…"
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
        self?.loadDevelopmentInputIfPresent(attempt: attempt + 1)
      }
      return
    }
    defer { try? FileManager.default.removeItem(at: file) }
    guard let bytes = try? Data(contentsOf: file),
          let input = (try? JSONSerialization.jsonObject(with: bytes)) as? [String: Any],
          let configuration = input["configuration"] as? [String: Any],
          let credentials = input["credentials"] as? [String: Any],
          let encoded = try? JSONSerialization.data(withJSONObject: credentials),
          let json = String(data: encoded, encoding: .utf8) else {
      status.text = "PRIVATE_INPUT_INVALID"
      return
    }
    suppliedConfiguration = configuration
    apiURL.text = configuration["apiBaseUrl"] as? String
    realm.text = configuration["serviceRealmId"] as? String
    consent.isOn = configuration["privacyConsentGranted"] as? Bool == true
    credentialsJSON.text = json
    credentialsJSON.accessibilityValue = "已载入宿主凭证（隐藏）"
    suppliedDirectTarget = input["directTarget"] as? [String: Any] ?? [:]
    suppliedServiceTarget = input["customerServiceTarget"] as? [String: Any] ?? [:]
    directConversation.text = suppliedDirectTarget["conversationId"] as? String
    serviceAccount.text = suppliedServiceTarget["serviceAccountId"] as? String
    serviceEntry.selectedSegmentIndex = suppliedServiceTarget["entry"] as? String == "currentTenant" ? 0 : 1
    serviceEntryChanged()
    switch ProcessInfo.processInfo.environment["IMSDK_HOST_PRESENTATION_MODE"] {
    case "push": IMSDK.shared.presentationMode = .push
    case "present": IMSDK.shared.presentationMode = .present
    default: break
    }
    status.text = "已载入本机私有输入；尚未登录"
    #endif
  }
}

#if DEBUG
/// Records public, read-only VoiceOver state for an explicit manual test.
/// Does not move focus, post accessibility notifications or retain spoken text.
private final class IMSDKVoiceOverProbe {
  private var observers: [NSObjectProtocol] = []
  private var events: [[String: Any]] = []
  private let file = URL(fileURLWithPath: NSTemporaryDirectory())
    .appendingPathComponent("imsdk-voiceover-evidence.json")

  init() {
    for name in [UIAccessibility.voiceOverStatusDidChangeNotification,
                 UIAccessibility.elementFocusedNotification,
                 UIApplication.didBecomeActiveNotification] {
      observers.append(NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { [weak self] note in
        self?.record(note.name == UIAccessibility.elementFocusedNotification ? "focus" : "state")
      })
    }
    record("start")
  }

  deinit { observers.forEach(NotificationCenter.default.removeObserver) }

  private func record(_ kind: String) {
    let running = UIAccessibility.isVoiceOverRunning
    if kind == "focus" && !running { return }
    let focused = UIAccessibility.focusedElement(using: .notificationVoiceOver) as? NSObject
    let label = focused?.accessibilityLabel ?? ""
    // Only fixed, public control names are categorized; messages/form data stay out.
    let category: String
    if ["返回宿主", "返回", "Back"].contains(label) { category = "return" }
    else if label == "正在排队" { category = "queue" }
    else if label == "查看接待状态" { category = "refresh" }
    else if label.contains("输入消息") { category = "composer" }
    else { category = "other" }
    events.append(["time": Date().timeIntervalSince1970, "kind": kind,
      "voiceOverRunning": running, "hasFocusedElement": focused != nil,
      "hasLabel": !label.isEmpty, "category": category,
      "buttonTrait": focused?.accessibilityTraits.contains(.button) ?? false])
    if events.count > 200 { events.removeFirst(events.count - 200) }
    guard let data = try? JSONSerialization.data(withJSONObject: ["events": events], options: [.sortedKeys]) else { return }
    try? data.write(to: file, options: .atomic)
    try? FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: file.path)
  }
}
#endif
