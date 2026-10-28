import UIKit
import IMSDKNative

/// 宿主须以属性强持有本对象，IMSDK.shared.eventListener 是 weak。
/// 在主线程创建和调用；configuration 由宿主环境与真实隐私同意结果构造。
final class SwiftIMIntegration: NSObject, IMSDKEventListener {
    var onEvent: (([String: Any]) -> Void)?

    override init() {
        super.init()
        IMSDK.shared.eventListener = self
        IMSDK.shared.presentationMode = .automatic
    }

    /// 推荐入口：SDK 内完成账号密码登录，再进入单聊 / 群聊列表。
    func openMessenger(
        from presenter: UIViewController,
        configuration: [String: Any],
        completion: @escaping IMSDK.Completion
    ) {
        IMSDK.shared.eventListener = self
        IMSDK.shared.initialize(configuration: configuration) { _, error in
            guard error == nil else { completion(nil, error); return }
            IMSDK.shared.openMessenger(from: presenter, completion: completion)
        }
    }

    /// 可选：凭证必须来自可信后端，target 使用已存在且有权限的 conversationId。
    func authenticateAndOpenDirect(
        from presenter: UIViewController,
        configuration: [String: Any],
        credentials: [String: Any],
        target: [String: Any],
        completion: @escaping IMSDK.Completion
    ) {
        IMSDK.shared.eventListener = self
        IMSDK.shared.initialize(configuration: configuration) { _, error in
            guard error == nil else { completion(nil, error); return }
            IMSDK.shared.authenticate(credentials: credentials) { _, error in
                guard error == nil else { completion(nil, error); return }
                IMSDK.shared.openDirectConversation(
                    from: presenter, target: target, completion: completion
                )
            }
        }
    }

    /// 可选：先完成 initialize 和认证，再打开客服。queued 回调成功不代表已接入。
    /// target 为 ["entry": "currentTenant"]，或使用真实服务账号实体 ID 的品牌入口。
    func openCustomerService(
        from presenter: UIViewController,
        target: [String: Any],
        completion: @escaping IMSDK.Completion
    ) {
        IMSDK.shared.eventListener = self
        IMSDK.shared.openCustomerService(
            from: presenter, target: target, completion: completion
        )
    }

    /// 宿主账号退出时协调调用；这不是服务端 token 撤销接口。
    func logout(completion: @escaping IMSDK.Completion) {
        IMSDK.shared.logout(completion: completion)
    }

    /// 不再使用 SDK 时释放；完成后如需再次进入，重新 initialize。
    func shutdown(completion: @escaping IMSDK.Completion) {
        IMSDK.shared.shutdown(completion: completion)
    }

    func imSdkDidReceiveEvent(_ payload: [String: Any]) {
        // 主线程。按 payload["type"] 处理；连接事件使用 payload["status"]。
        // 勿打印完整 payload、密码或认证字典。onEvent 的闭包需避免强引用循环。
        onEvent?(payload)
    }
}

// 宿主控制器应长期持有，例如：
// private let imIntegration = SwiftIMIntegration()
// 在用户同意后读取配置模板，填入业务环境及 privacyConsentGranted=true，
// 再从当前已显示的 UIViewController 调用 openMessenger。
