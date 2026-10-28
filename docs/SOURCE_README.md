# IM SDK 独立交付工程

面向 iOS、Android、Flutter 和 Web / H5 宿主的带聊天 UI SDK。统一流程为 **注册 / 登录 → 会话列表 → 添加好友 → 单聊 / 新建群聊及群聊**。注册页面没有空间选择：默认进入个人空间；服务端返回有效企业登录态时直接进入该企业，同时只有一个活跃空间。

本轮版本为 **原生 / Flutter 0.1.1、Web 0.1.5**。真实服务业务验证、原生二进制重建、独立消费和原生模拟器宿主检查均通过；原生与完整业务验证见 `logs/unification-release-20261028/validation.json`；Web 默认入口修复见 `logs/web-connected-20261028/validation.json`，文件校验见各交付包的 `MANIFEST.json`。

Web 0.1.5 已把现有真实服务预置到默认入口：解压后双击 `dist/web-h5-0.1.5/index.html` 即可注册或登录，无需手动修改配置。已认证实例直接进入会话列表。本版使用两个新测试账号，重新验证好友申请与接受、单聊以及新建双人群的双向收发；客户端业务协议保持原有实现。

| 默认聊天能力 | iOS / Android | Web / H5 |
| --- | --- | --- |
| 手机号 / 邮箱注册、验证码及安全验证 | 共享移动 SDK 页面 | Web 页面及 API |
| 注册后自动登录一个空间 | 默认个人，兼容实际企业登录态 | 默认个人，兼容实际企业登录态 |
| 账号密码登录、会话列表 | 支持 | 支持 |
| 好友搜索、申请、接受 / 拒绝申请 | 支持 | 支持 |
| 单聊、新建群聊、群聊 | 支持 | 支持文本消息 |

iOS / Android 使用同一套移动页面。SDK 内的好友和建群入口保持相同职能，服务端仍负责联系人、会话、群成员及消息权限。Web 媒体、通话和离线数据库范围见 [Web 说明](web/README.md)。

## 接入入口

| 接入方 | 目标交付包 | 说明 |
| --- | --- | --- |
| iOS | `dist/IMSDK-iOS-0.1.1.zip` | [iOS 接入](native/ios/README.md) |
| Android | `dist/IMSDK-Android-0.1.1.zip` | [Android 接入](native/android/README.md) |
| Web / H5 | `dist/IMSDK-Web-H5-0.1.5.zip` | [Web 接入](web/README.md) |
| Flutter / 源码 | 当前工作目录为 0.1.1；`dist/flutter/` 旧归档仅作历史保留 | [Flutter 接入](docs/FLUTTER_INTEGRATION.md) |

Flutter 公开入口为 `packages/im_sdk/lib/im_sdk.dart`，使用 `ImSdkMessagingView`。原生宿主取得隐私同意后调用 `initialize → openMessenger`。Web 使用 `ImSdkClient` 和 `mountMessenger`。服务地址、环境及已有账号的个人 / 企业登录方式由接入方配置，用户无需填写 URL、token、空间 ID 或会话 ID。

新用户通过 SDK 内的手机号 / 邮箱注册入口进入聊天；可用渠道、验证码和审核要求以服务端设置为准。账号已创建但自动登录失败时返回 `REGISTER_LOGIN_FAILED`，应重试登录，避免重复注册。旧接入仍可使用可信后端签发的 IM 凭证调用 `authenticate`，并使用指定单聊或客服入口。

## 本轮验证边界

2026-10-28 使用真实 IM 服务和专用测试身份完成：

- Web SDK 实际浏览器界面的邮箱注册、自动登录及退出后重新登录。
- iOS 26.5 模拟器内的 **Flutter 源码宿主**：新账号注册、接受好友申请、会话列表、单聊、选择好友新建群聊、双向文本收发及重新登录。对端独立读取服务端消息，并核对回复在 SDK 页面显示。
- Web SDK 实际浏览器界面的好友搜索 / 申请、单聊及新建双人群双向文本收发；独立对端核对真实发送者、成员范围、持久化与页面回复。

真实环境中验证码为非必需，本轮没有发送短信或邮件验证码。强制验证码、安全验证、审核及企业空间分配分支有本地契约回归，不能据此声称这些分支已通过真实业务验收。最终源码另完成同账号真实登录后立即退出 / 释放的增量验证，清理先于运行时销毁完成，未出现迟到状态写入。92 项移动 SDK 回归通过。

源码宿主真实运行与 **重建后的原生二进制消费、原生宿主运行** 分别验收。新 iOS UIKit / Android Java 二进制宿主均在专用模拟器通过真实密码登录、已有单群原消息及回复显示、退出释放，未重复注册或发送消息。未扩大为 iOS / Android 真机、更新版 Safari、微信、生产 H5 域名、真实企业分配、媒体、推送或后台恢复通过。

脱敏开发证据位于 `logs/unification-live-20261028-6576f4b0-r2-mobile.json`、`logs/unification-web-live-20261028-6576f4b0/`、`logs/unification-web-live-20261028-6576f4b0-r2/` 及最终汇总目录。私有账号、原始响应与运行时输入仅存于 `.work/runtime-private/`，不进入交付包。

## 目录与构建

| 路径 | 用途 |
| --- | --- |
| `packages/im_sdk/` | 独立 Flutter plugin、聊天源码、资源与平台实现 |
| `module/` | 原生 add-to-app 模块，入口调用 `runImSdkNativeHost()` |
| `examples/flutter_host/` | 通过公开 Dart API 接入的源码宿主 |
| `native/{ios,android}/` | 原生封装、独立宿主与交付模板 |
| `web/` | 独立 TypeScript / JavaScript SDK 与 H5 界面 |
| `scripts/` | 依赖解析、构建、消费验证和交付组装 |
| `dist/` | 版本化交付物；保留旧版快照 |
| `logs/` | 本机验证与构建证据，不随源码包分发 |

Flutter 工具链固定为 `.flutter-version` 的 **3.41.9**。先执行 `./scripts/resolve_dependencies.sh`；依赖默认离线且保留锁文件。Android / iOS 构建、完整依赖闭包及交付校验见 [构建与产物说明](docs/BUILD.md)。Web 独立使用 Node.js 20+，不依赖 Flutter。

本工程源码、资源、平台适配与宿主样例均在 IMSDK 内；构建不读取原 App checkout 或签名。分发仅使用版本化库、独立宿主和源码归档，不直接复制包含 `.work`、日志及本机配置的开发目录。

## 账号与生命周期

其他 App 账号与 IM 账号的打通由服务端负责：建立稳定身份映射，签发、刷新 IM 凭证并校验权限。相同用户名或宿主 token 不能直接代表同一 IM 用户。SDK 不包含服务端密钥或生产签名。

移动端每个 Flutter isolate 支持一个 SDK runtime 和一个活跃账号 / 空间；Web 每个实例只有一个活跃账号 / 空间。关闭页面保留会话，退出账号与释放整个 SDK 分别调用对应 API。系统后台、终止和通知恢复仍需宿主集成，不保证后台连接常驻。

## 历史记录

`0.1.0` 原生及 `0.1.2` / `0.1.3` / `0.1.4` Web 交付目录保留为历史快照。[宿主验证](docs/HOST_VALIDATION-2026-10-27.md)、[Web 验证](docs/WEB_VALIDATION-2026-10-27.md) 和 [浏览器兼容验证](docs/WEB_BROWSER_COMPATIBILITY-2026-10-27.md) 记录的是旧版本范围，其中 Safari、旧测试计数和旧二进制结果不自动覆盖本轮交付。
