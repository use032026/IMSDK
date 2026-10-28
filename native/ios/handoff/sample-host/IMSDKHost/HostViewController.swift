import Foundation
import UIKit
import IMSDKNative

private final class HostEventListener: NSObject, IMSDKEventListener {
  var onType: ((String) -> Void)?

  func imSdkDidReceiveEvent(_ payload: [String: Any]) {
    // Event payloads may contain private data. Display only the event type.
    onType?(payload["type"] as? String ?? "event")
  }
}

/// Native-only host. SDK owns account/password login and conversations.
final class HostViewController: UIViewController {
  // IMSDK.eventListener is weak, so the host keeps this listener alive.
  private let listener = HostEventListener()
  private let consent = UISwitch()
  private let status = UILabel()
  private let eventStatus = UILabel()
  private var configuration: [String: Any] = [:]
  private var privacyPolicyURL: URL?
  private var busy = false

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "IM SDK 接入示例"
    view.backgroundColor = .systemBackground
    loadConfiguration()
    let scroll = UIScrollView()
    let content = UIStackView()
    scroll.translatesAutoresizingMaskIntoConstraints = false
    content.translatesAutoresizingMaskIntoConstraints = false
    content.axis = .vertical
    content.spacing = 16
    view.addSubview(scroll)
    scroll.addSubview(content)
    NSLayoutConstraint.activate([
      scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20),
      content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -20),
      content.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20),
      content.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20)
    ])
    let help = UILabel()
    help.text = "配置聊天服务后，阅读本应用的隐私政策并同意，即可进入账号登录、单聊和群聊。"
    help.numberOfLines = 0
    content.addArrangedSubview(help)
    addButton("阅读隐私政策", action: #selector(readPrivacyPolicy), to: content)
    let consentRow = UIStackView()
    consentRow.axis = .horizontal
    consentRow.spacing = 12
    let consentLabel = UILabel()
    consentLabel.text = "我已阅读并同意本应用的隐私政策"
    consentLabel.numberOfLines = 0
    consent.accessibilityIdentifier = "privacyConsent"
    consent.isOn = false
    consent.isEnabled = privacyPolicyURL != nil
    consentRow.addArrangedSubview(consentLabel)
    consentRow.addArrangedSubview(consent)
    content.addArrangedSubview(consentRow)
    addButton("开始聊天", action: #selector(openMessenger), to: content)
    addButton("退出 IM 账号", action: #selector(logout), to: content)
    addButton("释放 SDK 资源", action: #selector(shutdown), to: content)
    status.numberOfLines = 0
    status.accessibilityIdentifier = "sdkStatus"
    eventStatus.numberOfLines = 0
    content.addArrangedSubview(status)
    content.addArrangedSubview(eventStatus)
    status.text = isConfigured ? "请先阅读隐私政策并同意。" : "请在 IMSDKConfiguration.plist 填写服务配置及隐私政策 HTTPS 地址。"
    listener.onType = { [weak self] type in self?.eventStatus.text = "SDK 事件：\(type)" }
    IMSDK.shared.eventListener = listener
  }

  private func loadConfiguration() {
    guard let url = Bundle.main.url(forResource: "IMSDKConfiguration", withExtension: "plist"),
          let data = try? Data(contentsOf: url),
          let supplied = (try? PropertyListSerialization.propertyList(from: data, format: nil)) as? [String: Any]
    else { return }
    configuration = supplied
    // This value belongs to the host, not to SDK initialization.
    if let text = configuration.removeValue(forKey: "hostPrivacyPolicyUrl") as? String,
       let url = URL(string: text), url.scheme?.lowercased() == "https", url.host != nil {
      privacyPolicyURL = url
    }
    configuration.removeValue(forKey: "privacyConsentGranted")
  }

  private var isConfigured: Bool {
    guard let text = configuration["apiBaseUrl"] as? String,
          let url = URL(string: text), url.scheme?.lowercased() == "https", url.host != nil,
          let realm = configuration["serviceRealmId"] as? String,
          !realm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    else { return false }
    return privacyPolicyURL != nil
  }

  private func addButton(_ title: String, action: Selector, to stack: UIStackView) {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.addTarget(self, action: action, for: .touchUpInside)
    button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
    stack.addArrangedSubview(button)
  }

  @objc private func readPrivacyPolicy() {
    guard let url = privacyPolicyURL else {
      status.text = "请先配置本应用真实的隐私政策 HTTPS 地址。"
      return
    }
    UIApplication.shared.open(url)
  }

  @objc private func openMessenger() {
    guard !busy else { return }
    guard isConfigured else {
      status.text = "请先填写 IMSDKConfiguration.plist。"
      return
    }
    guard consent.isOn else {
      status.text = "请先阅读并同意本应用的隐私政策。"
      return
    }
    busy = true
    status.text = "正在连接聊天服务…"
    var input = configuration
    input["privacyConsentGranted"] = true
    IMSDK.shared.initialize(configuration: input) { [weak self] _, error in
      guard let self else { return }
      guard error == nil else {
        self.finish("暂时无法连接聊天服务。", error: error)
        return
      }
      IMSDK.shared.openMessenger(from: self) { [weak self] _, error in
        self?.finish("已打开聊天，关闭页面后可再次进入。", error: error)
      }
    }
  }

  @objc private func logout() {
    guard !busy else { return }
    busy = true
    IMSDK.shared.logout { [weak self] _, error in self?.finish("IM 账号已退出。", error: error) }
  }

  @objc private func shutdown() {
    guard !busy else { return }
    busy = true
    IMSDK.shared.shutdown { [weak self] _, error in self?.finish("SDK 资源已释放。", error: error) }
  }

  private func finish(_ success: String, error: NSError?) {
    busy = false
    // SDK error details can contain server data. Show its stable code only.
    status.text = error.map {
      let code = $0.userInfo["code"] as? String ?? "\($0.domain) / \($0.code)"
      return "操作未完成（\(code)）。"
    } ?? success
  }
}
