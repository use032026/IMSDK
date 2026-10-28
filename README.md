# IM SDK 独立交付工程

面向 iOS、Android、Flutter 和 Web / H5 宿主的带聊天 UI SDK。统一流程为 **注册 / 登录 → 会话列表 → 添加好友 → 单聊 / 新建群聊及群聊**。注册页面没有空间选择：默认进入个人空间；服务端返回有效企业登录态时直接进入该企业，同时只有一个活跃空间。

本轮版本为 **原生 / Flutter 0.1.2、Web 0.1.5**。真实服务业务验证、原生二进制重建、独立消费和原生模拟器宿主检查均通过；本轮原生预接真实服务与完整 UI 验收见 `logs/native-connected-20261028/validation.json`；Web 验收见 `logs/web-connected-20261028/validation.json`，文件校验见各交付包的 `MANIFEST.json`。

iOS / Android 0.1.2 的原生示例也已预置同一真实服务，启动自动打开登录 / 注册，无需手动修改配置。原生二进制验收使用两个新的主要测试账号，覆盖两端好友发送及接受、单聊、两端分别建群及双向文本；额外辅助身份仅用于好友角色，所有主要消息和建群均由原生界面操作。

Web 0.1.5 已把现有真实服务预置到默认入口：解压后双击 `dist/web-h5-0.1.5/index.html` 即可注册或登录，无需手动修改配置。已认证实例直接进入会话列表。本版使用两个新测试账号，重新验证好友申请与接受、单聊以及新建双人群的双向收发；客户端业务协议保持原有实现。

| 默认聊天能力 | iOS / Android | Web / H5 |
| --- | --- | --- |
| 手机号 / 邮箱注册、验证码及安全验证 | 共享移动 SDK 页面 | Web 页面及 API |
| 注册后自动登录一个空间 | 默认个人，兼容实际企业登录态 | 默认个人，兼容实际企业登录态 |
| 账号密码登录、会话列表 | 支持 | 支持 |
| 好友搜索、申请、接受 / 拒绝申请 | 支持 | 支持 |
| 单聊、新建群聊、群聊 | 支持 | 支持文本消息 |

iOS / Android 使用同一套移动页面。SDK 内的好友和建群入口保持相同职能，服务端仍负责联系人、会话、群成员及消息权限。Web 媒体、通话和离线数据库范围见 [Web 说明](web/README.md)。

## Git 版本管理

默认分支 `main` 只维护各 SDK 最新版：iOS / Android / Flutter **0.1.2**、Web **0.1.5**。历史版本分别保存在 `ios/v<版本>`、`android/v<版本>`、`flutter/v<版本>`、`web/v<版本>` 分支，完整目录见 [版本分支说明](docs/VERSIONING.md)。

原生二进制完整依赖包和版本源码包可从 [GitHub Releases](https://github.com/use032026/IMSDK/releases) 下载。Git 中的 `dist` 只提交当前版的接入资料、示例源码、Web 成品和校验清单；iOS 框架、Android Maven 仓库及大 ZIP 从对应 Release 获取并按原目录解压。`MANIFEST.json` / `SHA256SUMS` 对应完整交付包，不能用省略二进制的 Git 目录单独校验全包。

## 接入入口

| 接入方 | 目标交付包 | 说明 |
| --- | --- | --- |
| iOS | [IMSDK-iOS-0.1.2.zip](https://github.com/use032026/IMSDK/releases/download/ios-v0.1.2/IMSDK-iOS-0.1.2.zip) | [iOS 接入](native/ios/README.md) |
| Android | [IMSDK-Android-0.1.2.zip](https://github.com/use032026/IMSDK/releases/download/android-v0.1.2/IMSDK-Android-0.1.2.zip) | [Android 接入](native/android/README.md) |
| Web / H5 | [IMSDK-Web-H5-0.1.5.zip](https://github.com/use032026/IMSDK/releases/download/web-v0.1.5/IMSDK-Web-H5-0.1.5.zip) | [Web 接入](web/README.md) |
| Flutter / 源码 | 当前工作目录为 0.1.2；历史源码见 `flutter/v<版本>` 分支 | [Flutter 接入](docs/FLUTTER_INTEGRATION.md) |

Flutter 公开入口为 `packages/im_sdk/lib/im_sdk.dart`，使用 `ImSdkMessagingView`。原生宿主取得隐私同意后调用 `initialize → openMessenger`。Web 使用 `ImSdkClient` 和 `mountMessenger`。服务地址、环境及已有账号的个人 / 企业登录方式由接入方配置，用户无需填写 URL、token、空间 ID 或会话 ID。

新用户通过 SDK 内的手机号 / 邮箱注册入口进入聊天；可用渠道、验证码和审核要求以服务端设置为准。账号已创建但自动登录失败时返回 `REGISTER_LOGIN_FAILED`，应重试登录，避免重复注册。旧接入仍可使用可信后端签发的 IM 凭证调用 `authenticate`，并使用指定单聊或客服入口。

## 本轮验证边界

原生 0.1.2 的完整业务验证运行于专用 iOS 26.5 / Android API 35 模拟器中的 UIKit / Java 原生宿主，使用新 SDK 二进制及实际交付的示例源码和预置服务配置。两个主要账号完成新注册、自动登录、重新登录、好友搜索 / 申请 / 接受、会话列表、单聊以及两端分别创建双人群并双向收发；独立身份直接读取服务端记录，逐项核对正文、发送者、序号及群的精确成员。按本轮单聊两条、两个群各两条共六条唯一消息验收，当前状态以 `logs/native-connected-20261028/validation.json` 为准。

iOS 样例在真实验证中发现并修复了模拟器宿主 Keychain 权限不足：公开工程已声明仅自身应用标识的 Keychain 组。最初创建但自动进入失败的账号仅保留诊断证据；修后使用新的 iOS 主要账号补验注册自动进入，未用独立 REST 登录替代原生 UI。

Web 0.1.5 已另用两个新账号，从实际预置服务的 file 入口完成完整真实流程，记录在 `logs/web-connected-20261028/validation.json`。此前 0.1.1 原生 / Flutter 源码及历史二进制检查保存在 `logs/unification-release-20261028/validation.json`，不替代本轮新原生流程。

移动 SDK 本轮 92 项回归已通过。构建、原生 UI、真实服务、独立消费及 Release 设备编译分别记录；模拟器结果不代表 iOS / Android 真机、媒体、推送、后台恢复或生产发布已完成。强制验证码、审核及真实企业分配仍以实际覆盖记录为准；注册始终无空间选择，同时只保留一个实际空间。

私有账号、原始响应与运行时输入仅存于 `.work/runtime-private/`；交付包只含本轮已授权公开的连接配置及代码，不含测试账号、密码或 token。

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

其他 App 账号与 IM 账号的打通由服务端负责：建立稳定身份映射，签发、刷新 IM 凭证并校验权限。相同用户名或宿主 token 不能直接代表同一 IM 用户。SDK 不包含服务端密钥或生产签名。

移动端每个 Flutter isolate 支持一个 SDK runtime 和一个活跃账号 / 空间；Web 每个实例只有一个活跃账号 / 空间。关闭页面保留会话，退出账号与释放整个 SDK 分别调用对应 API。系统后台、终止和通知恢复仍需宿主集成，不保证后台连接常驻。

## 历史记录

`0.1.0` / `0.1.1` 原生及 `0.1.0`～`0.1.4` Web 历史版本已分离至各平台版本分支和 Release，不放入 `main`。[宿主验证](docs/HOST_VALIDATION-2026-10-27.md)、[Web 验证](docs/WEB_VALIDATION-2026-10-27.md) 和 [浏览器兼容验证](docs/WEB_BROWSER_COMPATIBILITY-2026-10-27.md) 记录的是旧版本范围，其中 Safari、旧测试计数和旧二进制结果不自动覆盖本轮交付。
