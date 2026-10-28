# iOS 原生接入示例

本示例仅消费交付包的二进制。保留 `sample-host/` 与 `binary/` 为同级目录，用 Xcode 打开 `IMSDKHost.xcodeproj` 并选择 `IMSDKHost` scheme。

1. 编辑 `IMSDKHost/IMSDKConfiguration.plist`，填写 `apiBaseUrl`（HTTPS 服务地址）、`serviceRealmId`（稳定的服务环境标识）、`hostPrivacyPolicyUrl`（本应用真实隐私政策的 HTTPS 地址）。该文件会作为资源复制进 App，由示例直接读取；无需改写 `Info.plist` 配置字典。
2. `hostPrivacyPolicyUrl` 仅用于示例宿主展示隐私政策，宿主会在调用 SDK 前移除它。它不是 SDK 初始化字段。空值时示例不会允许同意或初始化；其余配置项含义见交付包 `docs/INTEGRATION.md`。
3. 选择 iOS 15 及以上模拟器后运行。Debug 自动使用 `../binary/Debug/`；Release 自动使用 `../binary/Release/`。两种模式均链接完整的 35 个 XCFramework，并仅嵌入 32 个动态框架。
4. 运行后点击“阅读隐私政策”，用户主动勾选同意后点击“开始聊天”。示例调用 `initialize` 后调用 `openMessenger`，由 SDK 展示账号密码登录与会话页；登录后可在 SDK 内进入单聊和群聊。

“退出 IM 账号”调用 `logout`；“释放 SDK 资源”调用 `shutdown`。普通关闭聊天页面会保留会话及引擎，可再次进入。宿主持有事件监听器的强引用，页面只显示事件类型和错误码，不显示完整事件数据。

命令行编译模拟器样例：

```sh
xcodebuild -project IMSDKHost.xcodeproj -scheme IMSDKHost \
  -configuration Debug -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

真机运行需要接入团队设置自己的 Bundle ID、开发者团队及签名。请按自己的用途核对 `IMSDKHost/Info.plist` 的媒体权限说明。样例不包含账号、令牌或签名；包内历史验收范围见 `docs/ACCEPTANCE.md`。
