# Android 原生接入示例

本示例通过 Maven 坐标 `com.imsdk:im-sdk-native:0.1.3` 消费交付包。保留 `sample-host/` 与 `maven/` 为同级目录，用 Android Studio 打开此目录；不需要父 IMSDK 仓库或 Flutter 工程。

1. 默认 `app/src/main/assets/im_sdk_configuration.json` 已预置与 Web 相同、已获本轮授权的真实服务连接，不含测试账号、密码或 token。使用现有服务无需编辑或复制配置。
2. 示例直接读取该资源。接入其他环境时才需要由宿主修改服务配置并接入自己的隐私同意流程；SDK 的同意及身份校验保持不变。
3. 使用 JDK 17 或兼容的较新 JDK、Android SDK 36。项目 Java 源码目标为 17，运行要求 Android 7.0/API 24 及以上。命令行构建前将环境变量 `ANDROID_HOME` 指向本机 Android SDK；无需在交付包写入本机路径或 `local.properties`。
4. 安装并启动后自动调用 `initialize → openMessenger`，未登录直接显示登录 / 注册，已有有效登录态则显示会话列表；可添加好友、单聊或选择好友新建群聊。无需先操作配置页或“开始聊天”按钮。

命令行编译：

```sh
./gradlew :app:assembleDebug
```

产物为 `app/build/outputs/apk/debug/app-debug.apk`。Gradle wrapper 已独立提供；Maven 本地仓库 `../maven` 优先于公开仓库，构建所需公开传递依赖首次使用时可能需要联网下载。

“退出 IM 账号”调用 `logout`；“释放 SDK 资源”调用 `shutdown`。普通关闭聊天页面会保留会话及引擎，可再次进入。页面只显示事件类型和错误码，不显示完整事件数据。发布时使用接入团队自己的应用 ID 与签名；样例不包含账号、令牌或私有配置。包内历史验收范围见 `docs/ACCEPTANCE.md`。
