# Android 原生接入示例

本示例通过 Maven 坐标 `com.imsdk:im-sdk-native:0.1.0` 消费交付包。保留 `sample-host/` 与 `maven/` 为同级目录，用 Android Studio 打开此目录；不需要父 IMSDK 仓库或 Flutter 工程。

1. 编辑 `app/src/main/assets/im_sdk_configuration.json`，填写 `apiBaseUrl`（HTTPS 服务地址）、`serviceRealmId`（稳定的服务环境标识）、`hostPrivacyPolicyUrl`（本应用真实隐私政策的 HTTPS 地址）。示例会直接读取这个资源文件。
2. `hostPrivacyPolicyUrl` 仅用于示例宿主展示隐私政策，宿主会在调用 SDK 前移除它。它不是 SDK 初始化字段。空值时示例不会允许同意或初始化；其余配置项含义见交付包 `docs/INTEGRATION.md`。
3. 使用 JDK 17 或兼容的较新 JDK、Android SDK 36。项目 Java 源码目标为 17，运行要求 Android 7.0/API 24 及以上。命令行构建前将环境变量 `ANDROID_HOME` 指向本机 Android SDK；无需在交付包写入本机路径或 `local.properties`。
4. 运行后点击“阅读隐私政策”，用户主动勾选同意后点击“开始聊天”。示例调用 `initialize` 后调用 `openMessenger`，由 SDK 展示账号密码登录与会话页；登录后可在 SDK 内进入单聊和群聊。

命令行编译：

```sh
./gradlew :app:assembleDebug
```

产物为 `app/build/outputs/apk/debug/app-debug.apk`。Gradle wrapper 已独立提供；Maven 本地仓库 `../maven` 优先于公开仓库，构建所需公开传递依赖首次使用时可能需要联网下载。

“退出 IM 账号”调用 `logout`；“释放 SDK 资源”调用 `shutdown`。普通关闭聊天页面会保留会话及引擎，可再次进入。页面只显示事件类型和错误码，不显示完整事件数据。发布时使用接入团队自己的应用 ID 与签名；样例不包含账号、令牌或私有配置。包内历史验收范围见 `docs/ACCEPTANCE.md`。
