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
  private let status = UILabel()
  private var configuration: [String: Any] = [:]
  private var busy = false
  private var initialized = false
  private var didAttemptAutomaticOpen = false

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "聊天"
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
    addButton("打开聊天", identifier: "openMessenger", action: #selector(openMessenger), to: content)
    addButton("退出登录", identifier: "logout", action: #selector(logout), to: content)
    addButton("关闭聊天服务", identifier: "shutdown", action: #selector(shutdown), to: content)
    status.numberOfLines = 0
    status.accessibilityIdentifier = "sdkStatus"
    content.addArrangedSubview(status)
    status.text = "正在打开聊天…"
    listener.onType = { [weak self] type in
      if type == "pageClosed" { self?.status.text = "聊天已关闭，可再次打开。" }
      if type == "shutdown" { self?.initialized = false }
    }
    IMSDK.shared.eventListener = listener
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard !didAttemptAutomaticOpen else { return }
    didAttemptAutomaticOpen = true
    openMessenger()
  }

  private func loadConfiguration() {
    guard let url = Bundle.main.url(forResource: "IMSDKConfiguration", withExtension: "plist"),
          let data = try? Data(contentsOf: url),
          let supplied = (try? PropertyListSerialization.propertyList(from: data, format: nil)) as? [String: Any]
    else { return }
    configuration = supplied
  }

  private var isConfigured: Bool {
    guard let text = configuration["apiBaseUrl"] as? String,
          let url = URL(string: text), url.scheme?.lowercased() == "https", url.host != nil,
          let realm = configuration["serviceRealmId"] as? String,
          !realm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    else { return false }
    return true
  }

  private func addButton(_ title: String, identifier: String, action: Selector, to stack: UIStackView) {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.accessibilityIdentifier = identifier
    button.addTarget(self, action: action, for: .touchUpInside)
    button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
    stack.addArrangedSubview(button)
  }

  @objc private func openMessenger() {
    guard !busy else { return }
    guard isConfigured else {
      status.text = "聊天服务暂未就绪，请稍后重试。"
      return
    }
    busy = true
    status.text = "正在连接聊天服务…"
    if initialized { presentMessenger(); return }
    // The bundled profile contains only this delivery's already authorized public connection.
    // Generic SDK initialization still validates the supplied consent value.
    IMSDK.shared.initialize(configuration: configuration) { [weak self] _, error in
      guard let self else { return }
      guard error == nil else {
        self.finish("暂时无法连接聊天服务。", error: error)
        return
      }
      self.initialized = true
      self.presentMessenger()
    }
  }

  private func presentMessenger() {
    IMSDK.shared.openMessenger(from: self) { [weak self] _, error in
      self?.finish("聊天已打开，关闭页面后可再次进入。", error: error)
    }
  }

  @objc private func logout() {
    guard !busy else { return }
    busy = true
    IMSDK.shared.logout { [weak self] _, error in self?.finish("已退出登录。", error: error) }
  }

  @objc private func shutdown() {
    guard !busy else { return }
    busy = true
    IMSDK.shared.shutdown { [weak self] _, error in
      self?.initialized = false
      self?.finish("聊天服务已关闭。", error: error)
    }
  }

  private func finish(_ success: String, error: NSError?) {
    busy = false
    status.text = error == nil ? success : "聊天暂不可用，请稍后重试。"
  }
}
