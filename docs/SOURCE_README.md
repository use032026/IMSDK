# IM SDK 独立交付工程

面向 Flutter、原生 Android、原生 iOS 和 Web / H5 宿主的带聊天 UI SDK。三端统一流程为：**注册 / 登录 → 会话列表 → 添加好友 → 单聊 / 新建群聊及群聊**。注册使用手机号或邮箱验证，默认登录个人空间；服务端直接返回企业登录态时进入企业空间，同时只登录一个空间。用户无需选择空间，也不需要填写服务地址、凭证 JSON 或会话 ID。

Flutter/原生公开入口为 `packages/im_sdk/lib/im_sdk.dart`。Flutter 使用 `ImSdkMessagingView`，原生宿主初始化后调用 `openMessenger`；Web 使用 `web/src/index.ts` 导出的 `ImSdkClient` / `mountMessenger`。服务地址和已有账号的个人/企业登录方式由接入方配置；新用户注册默认进入个人空间，服务端直接返回企业登录态时进入该企业空间；任一时刻仅有一个活跃空间。底层外部凭证认证和客服接口保留供已有接入使用，不属于默认聊天流程。

本次能力统一针对源码。已有 `dist/IMSDK-iOS-0.1.0.zip`、`dist/IMSDK-Android-0.1.0.zip` 和 `dist/IMSDK-Web-H5-0.1.2.zip` 是本次修改前的交付快照，尚未包含新增注册和好友入口；原生消费方须重新构建 SDK 后接入。

| 默认聊天能力 | iOS | Android | Web / H5 |
| --- | --- | --- | --- |
| 手机号 / 邮箱注册、验证码及安全验证 | 共享移动 SDK 页面 | 共享移动 SDK 页面 | Web 页面及 API |
| 注册后自动登录一个空间（默认个人，兼容服务端返回企业） | 支持 | 支持 | 支持 |
| 账号密码登录、会话列表 | 支持 | 支持 | 支持 |
| 好友搜索、申请、接受 / 拒绝申请 | 支持 | 支持 | 支持 |
| 单聊、新建群聊、群聊 | 支持 | 支持 | 支持（文本） |

这里统一的是默认聊天职能；Web 的媒体、通话和离线数据库能力范围仍见 [Web 说明](web/README.md)。

本次源码验证：共享移动 SDK 85 项测试、Web 50 项接口测试通过；Web 类型检查及构建通过，1280px / 390px 浏览器夹具覆盖默认个人注册、服务端返回企业登录态、单一活跃空间、好友申请和建群。移动端分析无错误 / 警告，保留 10 条原有格式提示。本次未重建原生交付包，也未执行新增流程的真实服务端或真机验收。证据保存于 `logs/unification-*-20261028*`。

本工程以原移动端 547 个 Dart 文件的独立镜像为起点，并在副本中加入 SDK 运行时、公开接口及平台适配。原 App 源码不由本工程构建脚本读取或修改。移动、复制或解压整个 `IMSDK` 目录后，内部相对路径仍然有效。

对外分发使用 `dist` 内的库、示例和源码归档。开发目录的 `.work/runtime-private` 与 `logs` 包含本机联调配置或证据，不随源码归档分发，也不应将整个开发工作目录直接交给接入方。

## 目录

| 路径 | 用途 |
| --- | --- |
| `packages/im_sdk/` | Flutter plugin、消息/会话源码、媒体资源与 Android/iOS 平台实现 |
| `module/` | Flutter 3.41.9 生成的 add-to-app module；入口调用 `runImSdkNativeHost()` |
| `examples/flutter_host/` | 仅通过公开 Dart API 接入的 Flutter 宿主；无内置账号、会话或假消息 |
| `native/android/`、`native/ios/` | 原生封装、独立宿主示例与平台接入说明 |
| `web/` | 独立 TypeScript / JavaScript Web SDK、H5 聊天界面及浏览器接入示例 |
| `dist/web/` | Web 全量 JS、ESM/CommonJS、类型声明、npm 包及源码归档 |
| `scripts/` | 离线优先依赖解析、AAR/Framework 构建、源码归档与校验 |
| `dist/android/maven/` | 构建成功后保存的完整 Android Maven 仓库 |
| `dist/ios/` | 构建成功后保存的 iOS XCFramework 集合 |
| `dist/flutter/` | Flutter/source SDK 完整归档、文件 manifest 和 SHA256SUMS |
| `logs/` | 本工程构建、依赖解析和归档日志；不随源码包交付 |

## 最小接入

1. 接入方配置 IM 服务地址、环境标识和聊天空间（默认个人空间，企业模式需固定企业码），并取得所需用户同意。
2. 打开聊天模块，已有账号输入账号和密码；新用户选择注册，完成手机号或邮箱验证。注册页面不提供企业、邀请码或空间选择。
3. 注册成功默认进入个人会话列表；服务端直接返回企业登录态时进入企业会话列表，同时只登录一个空间；已有账号按宿主配置登录。通过添加好友和好友申请建立联系后，可发起单聊或选择好友新建群聊，也可打开已有会话。
4. 宿主退出账号时退出 SDK；停止使用整个 SDK 时释放运行时。

详见 [Flutter 接入](docs/FLUTTER_INTEGRATION.md)、[Android 接入](native/android/README.md)、[iOS 接入](native/ios/README.md) 和 [Web / H5 接入](web/README.md)。Web 端当前提供文本聊天基础能力，媒体与原生能力范围见独立接入说明。

## 账号及服务端边界

SDK 负责注册、登录、好友、IM 会话和消息 UI。**其他 App 账号与 IM 账号的打通由服务端负责**：从已认证用户建立稳定的 IM 身份映射，签发和刷新 IM 凭证，并校验联系人、会话和群成员权限。客户端不能仅凭相同用户名就认定为同一用户，也不能把其他 App 的登录 token 或服务端密钥直接当作 IM accessToken。

当前注册和账号密码入口复用已有 IM 认证协议，不代表其他 App 账户系统已经打通。接入其他 App 的账号前，需要相应后端完成认证对接；也可继续使用 `authenticate` 接收受信后端签发的 IM 凭证。找回密码、企业管理和客服工作台不放入默认聊天入口。服务端负责验证码发送、注册审核和权限校验；账号创建成功但自动登录失败时，应先尝试使用已注册联系方式登录。

当前 SDK 公开边界按单 Flutter isolate 中的一个 SDK runtime、一个活跃账号/空间实现。UI 关闭与退出账号分别处理；系统挂起或终止后仍需宿主推送及回前台恢复，不能据此保证后台连接常驻。宿主已有其他 Flutter module、独占平台插件或全局存储时，应先验证共存。

## 开始构建

Web SDK 使用独立的 Node.js 20+ 工具链，不需要 Flutter：执行 `./scripts/build_web.sh` 生成 `dist/web`，浏览器协议验证执行 `(cd web && npm run test:browser)`。验证范围见 [Web 验证记录](docs/WEB_VALIDATION-2026-10-27.md)。

构建工具固定为 `.flutter-version` 中的 Flutter **3.41.9**。需要本机已安装 Flutter、对应 Android/iOS 工具链及依赖。原生二进制接入方使用已构建的交付物；从源码重新构建的团队需要相应工具链。

```sh
# 在 IMSDK 根目录执行。也可先设置 FLUTTER_BIN 指向已安装的固定版本。
./scripts/resolve_dependencies.sh
./scripts/build_android.sh release
# 构建 Android 原生调用层（需设置 JAVA_HOME / ANDROID_HOME）
(cd native/android && ./gradlew publishReleasePublicationToMavenRepository)
./scripts/build_ios.sh release
python3 scripts/build_ios_facade.py --mode Release
python3 scripts/verify_ios_consumers.py
# iOS 模拟器使用完整 Debug 组
./scripts/build_ios.sh debug
python3 scripts/build_ios_facade.py --mode Debug
./scripts/package_flutter.sh
```

依赖解析默认 `--offline --enforce-lockfile`。缓存缺失时会明确失败；只有准备好网络并允许下载时，才使用 `./scripts/resolve_dependencies.sh --online`。Android Gradle、iOS CocoaPods/Flutter 原生依赖同样需要预先就绪或在获准网络环境准备。脚本不会自动上传、发布或修改宿主签名。

`dist/android/maven` 已使用 Flutter 3.41.9 重新构建 Release AAR 完整依赖仓库及原生调用层；`dist/android/example/im-sdk-native-host-debug.apk` 为此前真实服务联调的纯 Java Debug 示例。`dist/ios/Debug` 和 iOS 模拟器示例也已包含账号密码与会话列表入口。2026-10-28 曾完整重建本次能力统一前的 iOS Release 框架与 facade，并通过独立宿主无签名设备编译及 Swift / Objective-C 消费链接验证；Release 真机业务运行另行验收。既有 Flutter 源码归档仍是之前的交付快照，后续需要源码交付时须单独刷新。

构建细节见 [构建与产物说明](docs/BUILD.md)。[宿主集成验证](docs/HOST_VALIDATION-2026-10-27.md) 已追加简化聊天入口的本次验收；[初始验证记录](docs/VALIDATION-2026-10-27.md) 保留先前凭证接入流程的证据。构建、密码登录、会话列表、消息收发、群权限和真机能力分别验收。


2026-10-27 已重新构建并运行原生 iOS Debug 示例，个人空间的密码登录、会话列表、单聊及双账号群聊真实收发通过，SDK 64 项回归测试通过。含安全区修复的最终 Android 原生示例也已完成真实密码登录、会话列表、单聊和群聊收发：独立对端核验消息及回复持久化，两条回复均在 Android SDK 页面显示并保存截图，最后返回会话列表保留运行。iOS 模拟器包位于 `dist/ios/example/IMSDKHost-messenger-simulator-20261027.zip`；各平台验证范围见 [宿主集成验证](docs/HOST_VALIDATION-2026-10-27.md)。

同日 Web 0.1.1 已追加真实服务验证：个人账号密码登录、既有单聊与双成员测试群双向文本收发通过，独立对端确认持久化，回复实际显示在 Web 界面；本机浏览器跨域请求与 SignalR 连接通过。真实联调发现的个人 JWT 空间兼容问题已修复，31项接口回归通过。交付包为 `dist/web/im_sdk_web_0.1.1.zip`，生产 H5 域名、Safari / 微信真机另行验收。

Web 当前交付更新为 `dist/web/im_sdk_web_0.1.2.zip`：已通过 macOS Safari 26.6.2 实际窗口的真实登录和单群双向收发，并修复旧 Safari 快捷发送及示例缓存返回状态。微信因客户端需要扫码登录尚未完成；iPhone Safari 和软键盘验收也未据此扩大。详见 [浏览器兼容验证](docs/WEB_BROWSER_COMPATIBILITY-2026-10-27.md)。

2026-10-28 已将 H5 消费接入整理为单独交付包 `dist/IMSDK-Web-H5-0.1.2.zip`，解压后的入口为 `README.md`，包含普通 HTML、Vue、React 模板、npm 包、配置/API/验收说明和校验清单。H5 说明源文件位于 `web/handoff/`，用 `python3 scripts/package_web_handoff.py` 组装；SDK 运行文件沿用已验证的0.1.2。微信按当前用户安排暂不验证，不作为本次交付前置条件。

同日原生团队交付整理为 [iOS 接入包](dist/ios-native-0.1.0/README.md) 与 [Android 接入包](dist/android-native-0.1.0/README.md)，对应 ZIP 为 `dist/IMSDK-iOS-0.1.0.zip`、`dist/IMSDK-Android-0.1.0.zip`。每包含完整二进制、独立空配置宿主源码、两种原生语言示例、接入/API/验收说明、MANIFEST 与 SHA256SUMS。独立 UIKit Debug 模拟器 / Release 设备编译、Java 宿主 assembleDebug、四种语言片段编译验证通过；本轮没有重复真实账号收发或真机运行。打包源位于 `native/{ios,android}/handoff/`，生成独立工程用 `scripts/generate_native_handoff_samples.py`，组装 / 完成校验用 `scripts/package_native_handoff.py prepare|finalize`。
