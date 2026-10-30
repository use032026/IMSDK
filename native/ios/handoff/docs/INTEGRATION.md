# iOS 接入说明

SDK 0.1.3 · 2026-10-29

## 1. 接入条件

- 宿主最低系统设为 iOS 15.0 或以上，使用支持交付二进制的 Xcode / iOS SDK。
- 取得后端提供的 HTTPS IM API 地址、稳定的服务域标识 `serviceRealmId`，并确定使用个人空间还是固定企业空间。
- 宿主先完成隐私告知和用户同意，再启动 SDK。
- 二进制接入只需要本包和原生开发环境；无需 Flutter 工具链、模块源码、Pods 源码或原应用。

先在 [独立 UIKit 示例](../sample-host/) 中验证。示例已预置与 Web 相同的本轮授权真实服务，编译安装后启动即可注册或登录，无需修改配置。示例只携带连接信息，不含测试账号、密码、token 或签名。嵌入其他业务宿主时再配置目标环境与自己的隐私同意流程。

## 2. 导入完整框架组

从 `binary/Debug/` 或 `binary/Release/` **选择同一组的全部 35 个 XCFramework** 添加到 App target 的 Frameworks, Libraries, and Embedded Content。不要只导入 `IMSDKNative`、`App` 和 `Flutter`，插件及其依赖也是完整运行所需。

| 框架 | 数量 | Xcode 设置 |
| --- | ---: | --- |
| `FlutterPluginRegistrant`、`flutter_webrtc`、`im_sdk` | 3 | Link，**Do Not Embed** |
| 其余全部框架，包括 `IMSDKNative`、`App`、`Flutter`、`WebRTC`、`objective_c` 及插件依赖 | 32 | Link，**Embed & Sign** |

逐项清单见 [INTEGRATION.json](../binary/INTEGRATION.json)。让 Xcode 从 XCFramework 选择平台切片，不要手动提取模拟器 `.framework` 装入设备 App。

在所有构建配置的 **Other Linker Flags** 保留继承设置并增加 `-ObjC`：

```text
$(inherited) -ObjC
```

该选项也必须应用于 Release，以保留生成的插件注册代码。不要同时引入源码方式的 IMSDK facade 和包内 `IMSDKNative`；不要通过再次安装同名 Pods 补齐本包已含的插件。

### Debug 与 Release

- **Debug**：用于调试及模拟器验证。完整 `App.xcframework` 内含 JIT 所需资源。保留 `binary/flutter_lldbinit` 与相邻的 `flutter_lldb_helper.py`，在 Xcode Scheme 的 Run / Test 中把自定义 LLDB Init File 指向该初始化文件。示例工程的相对路径可作为参考。
- **Release**：用于设备发行集成，使用 AOT 资源。宿主设置自己的 Bundle ID、开发团队、描述文件、签名和需要的 entitlements。SDK 包不提供可发布 IPA 或生产签名。
- Debug 和 Release 必须整组切换，含 facade、Flutter、App 和全部插件。模拟器上的 Release 编译 / 链接结果不能代替设备启动或业务验证。

独立示例已配置 `IMSDKHost/IMSDKHost.entitlements`，只声明自身 `$(AppIdentifierPrefix)$(PRODUCT_BUNDLE_IDENTIFIER)` 的应用标识及 Keychain 组。模拟器运行保留标准 ad-hoc 签名，SDK 才能安全保存登录态；使用 `CODE_SIGNING_ALLOWED=NO` 得到的编译结果不能作为注册 / 登录运行验收。

## 3. 默认服务与其他环境接入

[配置文件](../config/IMSDKConfiguration.example.plist) 和随包独立示例均已预置本次授权的真实服务连接。默认示例可直接运行，不需要修改地址、空间或同意开关。通用 SDK 的 `privacyConsentGranted` 校验保持不变；嵌入其他业务应用时，宿主仍应传入实际取得的用户同意结果。

打开 `sample-host/IMSDKHost.xcodeproj`，实际加载的配置资源为 `sample-host/IMSDKHost/IMSDKConfiguration.plist`。默认资源已可用，App 首次显示后自动初始化并打开聊天。仅在接入其他环境时才由开发者修改此资源或用自己的配置调用初始化；最终用户无需填写服务信息。

选择 `IMSDKHost` Scheme 的 Debug 配置可使用 `binary/Debug` 在模拟器调试；Release 配置自动使用 `binary/Release`。Scheme 的 Run 默认是 Debug，Profile / Archive 使用 Release；设备运行前设置自己的签名团队和 Bundle ID。两个配置均从交付目录内部读取对应的完整框架组。

个人账号的推荐配置如下；占位值需替换为团队环境：

```swift
let configuration: [String: Any] = [
    "apiBaseUrl": "https://your-im-api.example.com",
    "serviceRealmId": "your-service-realm",
    "storageNamespace": "your_host_app",
    "locale": "zh_CN",
    "privacyConsentGranted": true, // 仅在宿主已取得用户同意后传 true。
    "passwordLogin": ["space": "personal", "loginType": "lpp_id"]
]
```

`apiBaseUrl` 仅允许 HTTPS；可选 `gatewayBaseUrl` 允许 HTTPS / WSS。地址不能包含用户名密码、查询串或片段。`storageNamespace` 只允许 1–64 位字母、数字及 `._-`，应保持稳定。`serviceRealmId` 区分服务环境；相同宿主切换环境时应使用对应的稳定服务域值。

固定企业账号使用以下 `passwordLogin`，企业编码由宿主固定配置：

```swift
"passwordLogin": [
    "space": "tenant",
    "loginType": "login_name",
    "tenantCode": "your-tenant-code"
]
```

企业也可按后端账号约定使用 `loginType=lpp_id`。个人空间必须同时指定 `space=personal`、`loginType=lpp_id`，并省略 `tenantCode`。原生配置未提供 `passwordLogin` 时，账号密码入口会报告 `PASSWORD_LOGIN_NOT_CONFIGURED`，因此不要省略该项。

首次初始化后配置固定；相同配置可重复初始化，变更服务地址或账号空间配置需先 `shutdown`，再用新配置初始化。

## 4. 打开普通聊天入口

Swift 导入 `IMSDKNative`，Objective-C 导入 `<IMSDKNative/IMSDKNative-Swift.h>`。完整模板见 [Swift](../examples/HostIntegration.swift) 和 [Objective-C](../examples/HostIntegration.m)。核心流程如下：

Objective-C 宿主也需要启用 Swift 链接支持，因为 facade 和部分插件由 Swift 编写。纯 Objective-C 工程可添加一个空的 Swift 文件，让 Xcode 配置 Swift 工具链，并将 **Always Embed Swift Standard Libraries** 设为 `YES`；保留继承的 Swift / C++ 运行库链接设置。包内 Objective-C 示例已通过编译，并使用支持 Swift 运行库的链接器验证。

```swift
import IMSDKNative

IMSDK.shared.initialize(configuration: configuration) { _, error in
    guard error == nil else { /* 显示脱敏错误提示 */ return }
    IMSDK.shared.openMessenger(from: visibleViewController) { _, error in
        // 此回调表示入口调用结果；实际登录结果通过事件 / 页面反馈。
    }
}
```

在主线程从已经显示在窗口中的宿主控制器调用。SDK 未登录时显示账号密码页面，已有有效会话时进入会话列表；单聊、群聊入口及消息收发由 SDK 界面承载。用户不需要输入服务 URL、凭证 JSON 或会话 ID。原生 facade 当前不提供单独的群聊方法或无界面消息发送方法。

`presentationMode` 默认为 `.automatic`：宿主有导航控制器时 push，否则全屏 present。`.push` 要求有导航控制器；`.present` 使用全屏展示。不要在宿主正展示其他弹窗、控制器已离开窗口或导航转场中重复打开。

## 5. 宿主已有登录体系时

外部凭证入口为可选集成路径：

```text
宿主后端取得合法 IM 凭证
→ initialize
→ authenticate
→ openDirectConversation / openCustomerService / openMessenger
```

凭证必须由可信后端签发为 IM 凭证，包含 SDK 要求的用户、空间及有效期字段。宿主自身登录 token、管理员密钥不能替代 IM access token。跨应用账号映射、授权及凭证签发由服务端完成。字段见 [API](API.md)。

打开指定单聊需要服务端确认的真实 `conversationId`，不能用用户 ID 代替。群聊通常通过 `openMessenger` 中的会话列表打开。

客服有两种入口：当前企业传 `{"entry":"currentTenant"}`；品牌服务账号传 `{"entry":"serviceAccount","serviceAccountId":"your-service-account-id"}`。服务账号实体 ID 与客服人员用户 ID 不同。客服成功回调可能返回 `queued`，表示已排队；只有 `active` 且带有效会话的状态才能进入聊天。SDK 会显示排队 / 状态页，宿主不应把排队转换成普通单聊。

## 6. 生命周期、线程和监听

- SDK 使用单例，内部持有一个独立 Flutter engine；调用会串行执行，completion 与事件在主线程回调。回调中不要阻塞主线程。
- 宿主在主线程设置监听器与展示方式。`eventListener` 为 **weak**，须用宿主属性强引用监听对象；不要临时创建后立即丢弃。SDK 事件参数是字典，按 [API](API.md) 的 `type` 和字段处理。
- 用户正常关闭 / 返回只关闭页面，保留 SDK engine 和账号；再次 `openMessenger` 可恢复会话。SDK 为当前 engine 保留页面控制器，宿主无需另建 FlutterViewController 或管理 engine。
- `logout` 清理当前 SDK 本地登录态，成功时关闭页面；宿主账号退出时应协调调用。此方法不等同于服务端令牌撤销。
- `shutdown` 等待尚未完成的退出凭证清理，再关闭页面并释放 engine；完成后需重新初始化才能打开。即使 Dart 清理返回错误，原生也会释放 engine，宿主仍需处理错误回调。停机期间的新调用可能返回 `SDK_STOPPING`。
- 启动 ready 握手超时为 20 秒，单次桥接操作超时为 60 秒；超时会退役当前 engine，拒绝待处理操作。收到超时后处理错误并重新初始化，避免对旧页面继续调用。
- 不接管宿主的 AppDelegate、SceneDelegate 或通知代理。通知 token、推送路由和后台策略需与宿主单独联调。

## 7. 权限与发布前配置

按启用的实际能力在宿主 `Info.plist` 中填写清晰用途说明：相机 `NSCameraUsageDescription`、麦克风 `NSMicrophoneUsageDescription`、读取相册 `NSPhotoLibraryUsageDescription`、保存相册 `NSPhotoLibraryAddUsageDescription`。启用语音识别时另配置 `NSSpeechRecognitionUsageDescription`。不要为未提供的用户功能索取权限。

媒体权限拒绝 / 撤回、真机拍照录音、通知、后台恢复及无障碍仍需真实宿主验收。第三方声明随包位于 [THIRD_PARTY_NOTICES.plist](../binary/THIRD_PARTY_NOTICES.plist)，发布时按实际分发要求展示或随应用保留。

## 8. 常见接入问题

| 现象 / 错误 | 检查方式 |
| --- | --- |
| `No such module IMSDKNative` | App target 是否链接正确模式的 `IMSDKNative.xcframework`，平台 / 最低系统是否匹配 |
| `SDK_PLUGIN_REGISTRANT_MISSING`、缺插件或启动异常 | 是否导入 35 个完整框架，三项静态库已 Link，所有配置包含 `-ObjC` |
| Debug 启动失败或 JIT 调试异常 | 完整 Debug 组、App 资源及 Scheme LLDB 初始化文件是否正确，两个调试辅助文件是否相邻 |
| `CONSENT_REQUIRED` | 是否由宿主先取得真实隐私同意，再传 `privacyConsentGranted=true` |
| `PASSWORD_LOGIN_NOT_CONFIGURED` / `INVALID_CONFIG` | 是否显式配置个人或固定企业账号路由，企业是否缺少 `tenantCode` |
| `HOST_VIEW_CONTROLLER_UNAVAILABLE` / `HOST_PRESENTATION_BUSY` | 是否从可见宿主页面打开，当前是否有弹窗或转场 |
| `HOST_NAVIGATION_UNAVAILABLE` | `.push` 模式是否存在导航控制器，或改用 `.automatic` / `.present` |
| 收不到事件 | 宿主是否强引用 listener，是否正确读取 `type`；连接事件字段为 `status` |
| 认证失败 | 凭证是否为合法 IM 凭证、未过期且绑定正确服务域、用户与空间 |
| 客服成功但没有聊天页 | 先检查返回的 `status` / `canOpenConversation`，排队不代表已接入 |
| 超时后持续失败 | 按错误恢复流程重新初始化；同时核对完整框架组和脱敏网络诊断 |

排障时记录 SDK 版本、系统版本、构建模式、字符串错误码及复现步骤。不要输出密码、完整事件负载、认证字典或后端原始响应。验收记录方式见 [ACCEPTANCE.md](ACCEPTANCE.md)。
