# iOS 原生接入示例

本示例仅消费交付包的二进制。保留 `sample-host/` 与 `binary/` 为同级目录，用 Xcode 打开 `IMSDKHost.xcodeproj` 并选择 `IMSDKHost` scheme。

1. 默认 `IMSDKHost/IMSDKConfiguration.plist` 已预置与 Web 相同、已获本轮授权的真实服务连接，不含测试账号、密码或 token。使用现有服务无需编辑配置。
2. 配置资源会复制进 App，由示例直接读取；无需改写 `Info.plist`。接入其他环境时才需要由宿主修改服务配置并接入自己的隐私同意流程；SDK 的同意及身份校验保持不变。
3. 选择 iOS 15 及以上模拟器后运行。Debug 自动使用 `../binary/Debug/`；Release 自动使用 `../binary/Release/`。两种模式均链接完整的 35 个 XCFramework，并仅嵌入 32 个动态框架。
4. App 启动后自动调用 `initialize → openMessenger`，未登录直接显示登录 / 注册，已有有效登录态则显示会话列表；可添加好友、单聊或选择好友新建群聊。无需先操作配置页或“开始聊天”按钮。

“退出 IM 账号”调用 `logout`；“释放 SDK 资源”调用 `shutdown`。普通关闭聊天页面会保留会话及引擎，可再次进入。宿主持有事件监听器的强引用，页面只显示事件类型和错误码，不显示完整事件数据。

命令行编译模拟器样例：

```sh
xcodebuild -project IMSDKHost.xcodeproj -scheme IMSDKHost \
  -configuration Debug -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=YES CODE_SIGN_IDENTITY=- build
```

工程已配置只属于自身应用标识的 Keychain entitlement，供 SDK 保存登录态。模拟器运行使用标准 ad-hoc 签名；关闭签名只适用于单独的编译检查，不能据此验收注册 / 登录。真机运行需要接入团队设置自己的 Bundle ID、开发者团队及签名。请按自己的用途核对 `IMSDKHost/Info.plist` 的媒体权限说明。样例不包含账号、令牌或生产签名；验收范围见 `docs/ACCEPTANCE.md`。
