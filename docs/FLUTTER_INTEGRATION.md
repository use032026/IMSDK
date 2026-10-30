# Flutter 宿主接入（0.1.3）

主要流程为 **注册 / 登录 → 会话列表 → 添加好友 → 单聊 / 新建群聊及群聊**。注册完成后默认登录个人空间，服务端直接返回企业登录态时进入企业空间；不显示空间选择，同时只登录一个空间。已有账号的个人/企业登录方式由接入方配置，用户不填写 token、空间 ID 或会话 ID。

## 添加依赖

将 `packages/im_sdk` 随完整 SDK 交付保存，宿主用相对 path 或团队自己的包分发方式引用，不引用原移动 App 的 lib。

```yaml
dependencies:
  im_sdk:
    path: ../IMSDK/packages/im_sdk

dependency_overrides:
  record_linux: 1.3.1
```

支持 Flutter 的 Android/iOS 移动宿主，固定工具链为 Flutter 3.41.9。宿主自身的依赖锁由宿主管理；交付保留 SDK/module/example 锁文件。集成现有 App 前检查 Flutter、Riverpod、路由、数据库和媒体插件版本是否兼容。依赖包的 `dependency_overrides` 不会传递给消费项目，宿主需要明确配置上述覆盖。

## 打开聊天模块

宿主取得所需用户同意后，初始化一次 SDK，再把聊天模块挂载到宿主页面：

```dart
import 'package:im_sdk/im_sdk.dart';

final client = ImSdkClient();
await client.initialize(ImSdkConfig(
  apiBaseUrl: hostConfiguration.imApiBaseUrl,
  serviceRealmId: hostConfiguration.imServiceRealmId,
  storageNamespace: 'my_app_im',
  privacyConsentGranted: true,
  passwordLogin: const ImSdkPasswordLoginConfig.personal(),
));

// 返回给宿主 Navigator 的 route builder。
ImSdkMessagingView(
  client: client,
  onClose: () => Navigator.of(routeContext).pop(),
);
```

`hostConfiguration` 代表接入方已有的配置来源；服务地址和环境标识不是用户输入项。`ImSdkPasswordLoginConfig.personal()` 明确使用个人聊天空间，账号无需先加入企业。需要企业内聊天时，宿主改用 `ImSdkPasswordLoginConfig(loginType: 'login_name', tenantCode: hostConfiguration.imTenantCode)`，或为平台账号配置 `loginType: 'lpp_id'` 和固定企业码。企业模式不会从历史空间或搜索模糊结果中自动选择企业。原生配置使用 `passwordLogin: {"space":"personal","loginType":"lpp_id"}` 表示个人空间。

`ImSdkMessagingView` 内部提供登录与手机号 / 邮箱注册入口。注册不传企业或邀请码，完成服务端验证后默认进入个人会话列表；服务端直接返回企业登录态时进入企业会话列表，同时只登录一个空间；已有账号按配置登录。会话页提供添加好友及处理好友申请的入口，发起聊天页可选择好友单聊或新建群聊。SDK 沿用服务端授权和现有消息运行时，登录失败不会视为认证成功，也不会用本地假会话填充列表。短信 / 邮件及安全验证码由真实服务端提供。

若宿主还未初始化，可把 `configuration` 传给 `ImSdkMessagingView`，由页面在用户同意并登录时完成初始化；示例采用此方式。宿主已经初始化时，用户同意由宿主负责。

需要自行设计登录页时可调用：

```dart
await client.loginWithPassword(account: account, password: password);
```

自定义注册页可使用以下 API；`channel` 为 `sms` 或 `email`，注册默认进入个人空间，服务端直接返回企业登录态时进入该企业空间，同时只保留一个活跃空间：

```dart
final settings = await client.getRegistrationVerificationSettings();
// 按 settings 中的 enabled / required 决定可用渠道和验证码要求。
await client.sendRegistrationCode(channel: channel, identifier: identifier);
await client.registerWithPassword(
  displayName: displayName,
  password: password,
  channel: channel,
  identifier: identifier,
  verificationCode: verificationCode,
);
```

服务端要求安全验证时，调用 `requestLoginCaptcha()`，将返回的 token 和用户答案传入发送验证码或注册方法的 `captchaToken` / `captchaAnswer`。`REGISTER_PENDING_APPROVAL` 表示账号已创建、待审核；`REGISTER_LOGIN_FAILED` 表示账号已创建但自动登录失败，应尝试登录而非重复注册。个人账号登录按手机号、邮箱或平台账号输入匹配登录类型。

不要自行保存密码，或把密码、token、完整服务端响应输出到日志。

## 账号系统与生命周期

宿主主题与语言使用初始化配置的 `themeMode` / `locale`，已打开页面通过 `client.updatePresentation(...)` 更新；详见 [主题与语言同步](HOST_PRESENTATION_SYNC.md)。

需要跟随宿主自动登录 / 退出时，按 [宿主管理登录态](HOST_SESSION_SYNC.md) 启用 `hostManagedAuth` 并绑定 `ImSdkHostSessionProvider`。该模式从宿主会话与受信后端取票，不显示 SDK 密码登录页；以下主动 `authenticate` 用法适用于默认独立登录模式。相关接口已进入 0.1.3 原生交付包；真实宿主及后端联调仍需另行验收。

其他 App 账号的打通由双方服务端完成：认证宿主用户、建立稳定 IM 身份映射、签发和刷新 IM 凭证，并校验联系人、会话及群成员权限。SDK 新增密码入口复用已有 IM 登录协议，不能据此认定其他 App 的账号已接通。

已有宿主也可继续调用 `authenticate(ImSdkCredentials(...))`，传入受信后端签发的真实 IM 凭证。SDK 会核验 IM 身份；其他 App 的登录 token、admin token 或签名密钥不能直接作为 IM accessToken。外部凭证认证、指定私聊及客服接口是兼容接入能力，不需要让终端用户手填这些字段。

一个 Flutter isolate 支持一个 SDK runtime 和一个活跃账号/空间。订阅 `client.events` 获取连接、未读和认证生命周期事件；宿主不必建立第二份发送队列、token 存储或未读账本。

- 关闭聊天页面只关闭 UI，账号仍由 SDK 管理。
- 宿主退出用户时调用 `await client.logout()`。
- 整个 SDK 不再使用时，取消事件订阅并调用 `await client.dispose()`；已释放实例不再复用。
- 重启后需要重新登录或由宿主提供新凭证，SDK 不自动恢复旧身份。

`logout` 先停用本 SDK 的本地会话并安排凭证清理；后续认证会等待清理完成，`dispose` 会等待尚未完成的退出清理再释放资源。服务端令牌撤销和宿主账号退出策略由后端负责。推送、系统通知权限和后台恢复仍需要按宿主配置接入，不能以页面能打开推断后台连接可常驻。

## 当前版本验证范围

0.1.3 包含 35 语资源，已通过构建、独立消费与逐文件校验；没有本版真实服务、原生宿主运行或实体设备验收，详见 [35 语交付说明](L10N35_DELIVERY-2026-10-29.md)。

## 运行样例与历史验证

示例仅引用公开入口 `package:im_sdk/im_sdk.dart`，通过构建配置指定服务及个人/企业聊天空间，不内置业务账号或假消息。详细运行参数见 [Flutter 示例](../examples/flutter_host/README.md)。Android/iOS 工程分别保留平台权限、Java desugaring 和 iOS 15 配置；实体 iPhone 签名由接入方配置，Android debug 签名只用于开发验证。

2026-10-28 已在 iOS 26.5 模拟器的 Flutter 源码宿主中，使用真实服务完成新账号邮箱注册、自动个人登录、接受好友申请、会话列表、单聊与新建群聊双向收发及重新登录；独立 Web 对端核对持久化和回复显示。最终源码另完成同账号真实登录后立即退出 / 释放的增量验证，未残留活跃运行时或退出清理错误。92 项移动 SDK 回归通过。

本轮服务端验证码非必需，没有发送短信 / 邮件验证码；强制验证码、安全验证及企业分配分支仅有契约回归。新 iOS / Android 0.1.2 二进制已另行通过独立消费及专用模拟器原生宿主的真实登录、已有单群历史显示和退出释放；与源码宿主完整业务验收分别记录。结果见 `logs/unification-release-20261028/validation.json`。真实企业、真机媒体、通知和其他 App 账户映射仍需相应联调。

旧 `host_runtime_test.dart`、`host_live_test.dart` 和 `run_flutter_host_validation.py` 针对原凭证联调表单；其既有结果不能用作密码登录及会话列表验收。先前记录见 [宿主集成验证](HOST_VALIDATION-2026-10-27.md)。
