# IM SDK 独立交付工程

面向 iOS、Android、Flutter 和 Web / H5 宿主的带聊天 UI SDK。统一流程为 **注册 / 登录 → 会话列表 → 添加好友 → 单聊 / 新建群聊及群聊**。注册默认进入个人空间；服务端返回有效企业登录态时直接进入企业，同时只有一个活跃空间。

当前版本为 **原生 / Flutter 0.1.3、Web 0.1.6**，包含公共语言资源 **0.3.0** 的 **35 种语言**，每语 1040 个公共词条。宿主可统一管理登录态、主题与语言；SDK / Web 专属缺译明确回退英语，法律正文保留原选择和回退逻辑，见 [语言资源](docs/SHARED_L10N.md)。

本轮交付验证范围为 `localization-rebuild`：构建、资源清单、独立消费和文件校验通过，详见 [35 语言交付说明](docs/L10N35_DELIVERY-2026-10-29.md)。没有本版原生宿主运行、真实后端或实体设备验收；历史版本的实服结果不替代本版结果。

| 默认聊天能力 | iOS / Android | Web / H5 |
| --- | --- | --- |
| 手机号 / 邮箱注册、验证码及安全验证 | 共享移动 SDK 页面 | Web 页面及 API |
| 注册后自动登录一个空间 | 默认个人，兼容实际企业登录态 | 默认个人，兼容实际企业登录态 |
| 账号密码登录、会话列表 | 支持 | 支持 |
| 好友搜索、申请、接受 / 拒绝申请 | 支持 | 支持 |
| 单聊、新建群聊、群聊 | 支持 | 支持文本消息 |

iOS / Android 使用同一套移动页面。SDK 内的好友和建群入口保持相同职能，服务端仍负责联系人、会话、群成员及消息权限。Web 媒体、通话和离线数据库范围见 [Web 说明](web/README.md)。

## Git 版本管理

默认分支 `main` 只维护各 SDK 最新版：iOS / Android / Flutter **0.1.3**、Web **0.1.6**。历史版本分别保存在 `ios/v<版本>`、`android/v<版本>`、`flutter/v<版本>`、`web/v<版本>` 分支，完整目录见 [版本分支说明](docs/VERSIONING.md)。

原生二进制完整依赖包和版本源码包可从 [GitHub Releases](https://github.com/use032026/IMSDK/releases) 下载。Git 中的 `dist` 只提交当前版的接入资料、示例源码、Web 成品和校验清单；iOS 框架、Android Maven 仓库及大 ZIP 从对应 Release 获取并按原目录解压。`MANIFEST.json` / `SHA256SUMS` 对应完整交付包，不能用省略二进制的 Git 目录单独校验全包。

## 接入入口

| 接入方 | 目标交付包 | 说明 |
| --- | --- | --- |
| iOS | [IMSDK-iOS-0.1.3.zip](https://github.com/use032026/IMSDK/releases/download/ios-v0.1.3/IMSDK-iOS-0.1.3.zip) | [iOS 接入](native/ios/README.md) |
| Android | [IMSDK-Android-0.1.3.zip](https://github.com/use032026/IMSDK/releases/download/android-v0.1.3/IMSDK-Android-0.1.3.zip) | [Android 接入](native/android/README.md) |
| Web / H5 | [IMSDK-Web-H5-0.1.6.zip](https://github.com/use032026/IMSDK/releases/download/web-v0.1.6/IMSDK-Web-H5-0.1.6.zip) | [Web 接入](web/README.md) |
| Flutter / 源码 | 当前工作目录为 0.1.3；历史源码见 `flutter/v<版本>` 分支 | [Flutter 接入](docs/FLUTTER_INTEGRATION.md) |

Flutter 公开入口为 `packages/im_sdk/lib/im_sdk.dart`，使用 `ImSdkMessagingView`。原生宿主取得隐私同意后调用 `initialize → openMessenger`。Web 使用 `ImSdkClient` 和 `mountMessenger`。服务地址、环境及已有账号的个人 / 企业登录方式由接入方配置，用户无需填写 URL、token、空间 ID 或会话 ID。

新用户通过 SDK 内的手机号 / 邮箱注册入口进入聊天；可用渠道、验证码和审核要求以服务端设置为准。账号已创建但自动登录失败时返回 `REGISTER_LOGIN_FAILED`，应重试登录，避免重复注册。旧接入仍可使用可信后端签发的 IM 凭证调用 `authenticate`，并使用指定单聊或客服入口。

## 本轮验证边界

- iOS：Debug / Release 框架及 35 语资源一致；六组 Swift / ObjC 消费、UIKit 模拟器和未签名设备编译通过，原生宿主未启动。
- Android：独立 Maven 宿主、Java / Kotlin 公开 API 编译、三 ABI 符号剥离复现，以及 AAR / APK 语言清单一致性通过；未执行本版业务运行或实体设备验证。
- Web：35 语浏览器隔离夹具、npm ESM / CommonJS / 类型消费及逐文件校验通过；不访问真实后端写入业务。

证据见各完整交付包的 `MANIFEST.json`、`localization/` 和本机 `logs/l10n35-handoff-20261029/validation.json`。公共词条完整性不代表所有历史页面、字体、译文质量或法务正文均完成 35 语验收。私有账号、原始响应与运行时输入不随包分发。此前 0.1.2 原生和 0.1.5 Web 的实服记录仅作为历史证据保留。

## 目录与构建

| 路径 | 用途 |
| --- | --- |
| `packages/im_sdk/` | 独立 Flutter plugin、聊天源码、资源与平台实现 |
| `module/` | 原生 add-to-app 模块，入口调用 `runImSdkNativeHost()` |
| `examples/flutter_host/` | 通过公开 Dart API 接入的源码宿主 |
| `native/{ios,android}/` | 原生封装、独立宿主与交付模板 |
| `web/` | 独立 TypeScript / JavaScript SDK 与 H5 界面 |
| `scripts/` | 依赖解析、构建、消费验证和交付组装 |
| `dist/` | 仅保留各 SDK 最新版交付资料；二进制见 Releases |
| `logs/` | 本机验证与构建证据，不随源码包分发 |

Flutter 工具链固定为 `.flutter-version` 的 **3.41.9**。先执行 `./scripts/resolve_dependencies.sh`；依赖默认离线且保留锁文件。Android / iOS 构建、完整依赖闭包及交付校验见 [构建与产物说明](docs/BUILD.md)。Web 独立使用 Node.js 20+，不依赖 Flutter。

本工程源码、资源、平台适配与宿主样例均在 IMSDK 内；构建不读取原 App checkout 或签名。分发仅使用版本化库、独立宿主和源码归档，不直接复制包含 `.work`、日志及本机配置的开发目录。

## 账号与生命周期

SDK 主题和语言可由宿主统一配置并运行时更新，支持深浅 / 系统主题与35 种语言 / 系统语言（专属缺译显式回退英语），见 [宿主管理主题与语言](docs/HOST_PRESENTATION_SYNC.md)。该能力独立于登录同步，无需重新认证。

宿主自动同步登录态的新增源码接入使用 `hostManagedAuth: true` 和宿主 session provider，见 [宿主管理登录态](docs/HOST_SESSION_SYNC.md)；[MediaServiceClient 参考适配](docs/MEDIASERVICECLIENT_HOST_SESSION.md) 仅位于本 SDK 内，尚未集成到真实宿主。0.1.3 原生与 0.1.6 Web 已包含相关接口；真实静默登录仍需后端 IM 换票契约和实际宿主联调。

其他 App 账号与 IM 账号的打通由服务端负责：建立稳定身份映射，签发、刷新 IM 凭证并校验权限。相同用户名或宿主 token 不能直接代表同一 IM 用户。SDK 不包含服务端密钥或生产签名。

移动端每个 Flutter isolate 支持一个 SDK runtime 和一个活跃账号 / 空间；Web 每个实例只有一个活跃账号 / 空间。关闭页面保留会话，退出账号与释放整个 SDK 分别调用对应 API。系统后台、终止和通知恢复仍需宿主集成，不保证后台连接常驻。

## 历史记录

`0.1.0`～`0.1.2` 原生及 `0.1.0`～`0.1.5` Web 历史版本已分离至各平台版本分支和 Release，不放入 `main`。[宿主验证](docs/HOST_VALIDATION-2026-10-27.md)、[Web 验证](docs/WEB_VALIDATION-2026-10-27.md) 和 [浏览器兼容验证](docs/WEB_BROWSER_COMPATIBILITY-2026-10-27.md) 记录的是旧版本范围，其中 Safari、旧测试计数和旧二进制结果不自动覆盖本轮交付。
