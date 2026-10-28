import UIKit
import IMSDKNative

/// The host obtains configuration and credentials from its own trusted integration.
final class HostIntegration: NSObject, IMSDKEventListener {
  func openDirect(from presenter: UIViewController, configuration: [String: Any],
                  credentials: [String: Any], target: [String: Any],
                  completion: @escaping IMSDK.Completion) {
    IMSDK.shared.eventListener = self
    IMSDK.shared.initialize(configuration: configuration) { _, failure in
      guard failure == nil else { completion(nil, failure); return }
      IMSDK.shared.authenticate(credentials: credentials) { _, failure in
        guard failure == nil else { completion(nil, failure); return }
        IMSDK.shared.openDirectConversation(from: presenter, target: target, completion: completion)
      }
    }
  }

  func openCustomerService(from presenter: UIViewController, target: [String: Any],
                           completion: @escaping IMSDK.Completion) {
    IMSDK.shared.openCustomerService(from: presenter, target: target, completion: completion)
  }

  func imSdkDidReceiveEvent(_ payload: [String: Any]) {
    // Observe the documented event type and update host UI. Do not log raw payloads.
  }
}
