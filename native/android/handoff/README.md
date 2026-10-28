# Android IM SDK 交付包

SDK 版本：`0.1.1` · 文档更新：2026-10-28

本版统一注册 / 登录、会话列表、好友申请处理、单聊和新建群聊 / 群聊。注册不选择空间：默认进入个人空间，服务端返回有效企业登录态时进入该企业，同时只有一个活跃空间。

本包用于在原生 Android 应用内接入聊天页面。宿主调用 `initialize`，成功后调用 `openMessenger`，用户即可注册或使用账号、密码登录，进入会话列表并添加好友，收发单聊和群聊消息。服务地址、账号空间等由接入团队配置，用户无需填写 URL、凭证 JSON 或会话 ID。

## 包内文件

| 路径 | 用途 |
| --- | --- |
| `maven/` | 完整本地 Maven 仓库，包含原生门面、Flutter 模块及随包发布的插件制品 |
| `sample-host/` | 独立 Java 宿主工程，使用本包的 Maven 依赖 |
| `examples/HostIntegration.java` | Java 集成片段 |
| `examples/HostIntegration.kt` | Kotlin 集成片段 |
| `config/im_sdk_configuration.example.json` | 空服务配置模板 |
| [docs/INTEGRATION.md](docs/INTEGRATION.md) | 环境、依赖、配置和接入步骤 |
| [docs/API.md](docs/API.md) | API、事件、错误及生命周期 |
| [docs/ACCEPTANCE.md](docs/ACCEPTANCE.md) | 已验证范围与宿主验收清单 |
| `MANIFEST.json`、`SHA256SUMS` | 交付清单与文件校验值 |

## 最快接入

使用前在交付包根目录执行 `shasum -a 256 -c SHA256SUMS`，确认文件与清单一致。

1. 使用 JDK 17、Android SDK 36；已验证基线为 minSdk 24、compileSdk / targetSdk 36、AGP 8.11.1、Gradle 8.14。
2. 保留完整 `maven/`，在宿主中声明本地仓库和公共依赖仓库，添加 `com.imsdk:im-sdk-native:0.1.1`，开启 AndroidX 与 Java 17 desugaring。
3. 参照 [接入说明](docs/INTEGRATION.md) 填写服务配置。示例工程需将配置模板复制为 `sample-host/app/src/main/assets/im_sdk_configuration.json`。
4. 宿主取得用户隐私同意后，再向 `initialize` 传入 `privacyConsentGranted=true`；初始化成功后调用 `openMessenger`。
5. 按 [验收说明](docs/ACCEPTANCE.md) 在接入方应用与真实设备完成验收。

原生消费方无需安装 Flutter，也无需原 App 源码。完整本地仓库仍依赖公共 Maven 制品，首次构建需联网下载或提前准备依赖缓存，本包不等同于完全离线构建环境。

个人账号请显式使用 `passwordLogin: {"space":"personal","loginType":"lpp_id"}`。企业账号由开发者固定 `tenantCode` 与登录方式。跨应用账号打通需接入方可信后端完成账号映射及 IM 凭证签发、刷新；生产签名与通知推送由宿主集成。

2026-10-28，共享移动源码已在 iOS 26.5 模拟器的 Flutter 源码宿主中通过真实邮箱注册、自动登录、接受好友申请、会话列表、单聊和新建群聊双向文本收发及重新登录；独立 Web 对端核对持久化和回复显示。最终源码退出 / 立即释放增量验证已通过。Android 0.1.1 的 Release AAR、原生调用层、独立 Java 宿主及 Java / Kotlin 示例编译通过；新二进制在 API 35 模拟器完成真实密码登录、已有单聊和群聊原消息 / 回复显示及退出释放。原生运行检查未新增注册或发送消息。摘要及校验以 `MANIFEST.json` 为准，真机范围另行验收。

2026-10-27 的旧版原生宿主收发结果保留为历史；未代表本版真机媒体、通知、后台恢复、性能或生产发布通过，详见 [验证范围](docs/ACCEPTANCE.md)。
