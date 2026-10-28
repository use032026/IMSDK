# Android IM SDK 交付包

SDK 版本：`0.1.2` · 文档更新：2026-10-28

本版统一注册 / 登录、会话列表、好友申请处理、单聊和新建群聊 / 群聊。注册不选择空间：默认进入个人空间，服务端返回有效企业登录态时进入该企业，同时只有一个活跃空间。

本包用于在原生 Android 应用内接入聊天页面。随包 Java 示例已预置与 Web 相同的真实服务，安装启动后自动进入登录 / 注册，无需手动修改服务配置。已有有效 IM 登录态时直接进入会话列表；添加好友、单聊和建群均在 SDK 内完成。嵌入其他应用时，宿主仍可配置环境并调用 `initialize → openMessenger`。

## 包内文件

| 路径 | 用途 |
| --- | --- |
| `maven/` | 完整本地 Maven 仓库，包含原生门面、Flutter 模块及随包发布的插件制品 |
| `sample-host/` | 独立 Java 宿主工程，使用本包的 Maven 依赖 |
| `examples/HostIntegration.java` | Java 集成片段 |
| `examples/HostIntegration.kt` | Kotlin 集成片段 |
| `config/im_sdk_configuration.example.json` | 已预置本轮授权真实服务的配置，不含账号或凭证 |
| [docs/INTEGRATION.md](docs/INTEGRATION.md) | 环境、依赖、配置和接入步骤 |
| [docs/API.md](docs/API.md) | API、事件、错误及生命周期 |
| [docs/ACCEPTANCE.md](docs/ACCEPTANCE.md) | 已验证范围与宿主验收清单 |
| `MANIFEST.json`、`SHA256SUMS` | 交付清单与文件校验值 |

## 最快接入

使用前在交付包根目录执行 `shasum -a 256 -c SHA256SUMS`，确认文件与清单一致。

1. 使用 JDK 17、Android SDK 36；已验证基线为 minSdk 24、compileSdk / targetSdk 36、AGP 8.11.1、Gradle 8.14。
2. 保留完整 `maven/`，在宿主中声明本地仓库和公共依赖仓库，添加 `com.imsdk:im-sdk-native:0.1.2`，开启 AndroidX 与 Java 17 desugaring。
3. 默认 `sample-host/app/src/main/assets/im_sdk_configuration.json` 已配置现有真实服务，无需编辑或复制。
4. 编译安装后启动示例即自动进入聊天登录 / 注册页。嵌入其他应用时，宿主取得用户隐私同意后再初始化 SDK；通用接口校验不变。
5. 按 [验收说明](docs/ACCEPTANCE.md) 在接入方应用与真实设备完成验收。

原生消费方无需安装 Flutter，也无需原 App 源码。完整本地仓库仍依赖公共 Maven 制品，首次构建需联网下载或提前准备依赖缓存，本包不等同于完全离线构建环境。

个人账号请显式使用 `passwordLogin: {"space":"personal","loginType":"lpp_id"}`。企业账号由开发者固定 `tenantCode` 与登录方式。跨应用账号打通需接入方可信后端完成账号映射及 IM 凭证签发、刷新；生产签名与通知推送由宿主集成。

本轮以新 SDK Release AAR、原生调用层及实际 Java 示例的包内预置配置，在专用 Android 模拟器进行新账号注册、自动登录、重登、好友申请与接受、会话列表、单聊以及两端各自创建群聊的双向文本验收。iOS 原生宿主互为主要对端，辅助专用身份用于补齐两端的好友发送及接受角色；独立身份读取服务端记录核对成员、发送者、正文及序号。具体构建、原生 UI、真实服务及消费结果分别记录在 `MANIFEST.json`；模拟器结果不代表真机运行。

2026-10-27 的旧版原生宿主收发结果保留为历史；未代表本版真机媒体、通知、后台恢复、性能或生产发布通过，详见 [验证范围](docs/ACCEPTANCE.md)。
