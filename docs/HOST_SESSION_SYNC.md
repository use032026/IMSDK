# 宿主管理登录态（源码接入）

此能力通过 `hostManagedAuth: true` 显式启用。默认独立登录模式保持兼容。相关接口已包含在 0.1.3 原生 Release 和 Web 0.1.6 中；旧 0.1.2 / 0.1.5 包未改写，真实宿主 SSO 仍需后端换票与联调。

## 接入责任

宿主 provider 提供两个操作：

- `readSession`：读取当前宿主账号，已退出返回 null；正常登录返回 `{hostUserId, sessionId}`。
- `fetchCredentials`：为该宿主会话获取受信后端签发的完整 IM 凭证。SDK 仍通过 IM 服务核验身份。

`hostUserId` 是稳定业务身份，需包含必要的应用 / 环境作用域；`sessionId` 区分同一账号的不同登录周期。退出后重新登录或切换账号应改变该值。不要把业务 token 明文当作任一字段，也不要将宿主业务 token 当作 IM accessToken。IM 凭证中的账号、空间与宿主账号的映射由受信后端保证，客户端无法仅凭相同用户名建立映射。

状态变化通知用于及时同步，SDK 在进入会话列表、恢复前台及异步认证提交前后还会重新读取宿主状态。退出或换号通知应在本地身份发生变化后立即发送；SDK 会先作废旧认证，再处理后续请求。未收到通知时，入口复查仍可发现状态变化；SDK 无法在宿主未提供通知、查询或采样机制的情况下观察其内存变量。

## Flutter

实现 `ImSdkHostSessionProvider`：`readSession()` 返回 `Future<ImSdkHostSession?>`，`fetchCredentials(session)` 返回 `Future<ImSdkCredentials>`；可通过 `changes` 提供状态变化流。先绑定 provider，再初始化 SDK：

```dart
client.bindHostSessionProvider(hostSessionProvider);
await client.initialize(const ImSdkConfig(
  apiBaseUrl: 'https://your-im-api.example.com',
  serviceRealmId: 'your-service-realm',
  storageNamespace: 'your_host_app',
  privacyConsentGranted: true, // 必须已实际取得用户同意。
  hostManagedAuth: true,
));

// 可在预计进入聊天前预热，不打开任何登录页面。
await client.synchronizeHostSession();

// 页面挂载后会进行入口复查；关闭页面不退出账号。
ImSdkMessagingView(client: client, onClose: closeHostRoute);

// 未提供 changes 流时，在宿主登录、退出或换号后主动通知：
await client.notifyHostSessionChanged();
```

该模式不渲染 SDK 密码登录页或登录加载弹窗。未登录或取票失败时显示安全占位 / 页面内重试，不假造登录成功。显式 `authenticate` 和密码登录入口不能绕过 provider；仍可调用 `logout` 停用当前 SDK 会话，完整结束使用调用 `dispose`。

## iOS / Objective-C / Swift

实现公开的 `IMSDKHostSessionProvider`，设置 `IMSDK.shared.hostSessionProvider`，再使用包含 `hostManagedAuth: true` 的配置初始化。协议方法为：

- `imSdkReadHostSessionWithCompletion:`：返回宿主会话字典或 nil。
- `imSdkFetchCredentialsForHostSession:completion:`：返回完整 IM 凭证字典。

Swift 对应 `imSdkReadHostSession(completion:)`、`imSdkFetchCredentials(forHostSession:completion:)`。provider 被 facade 持有，回调可异步完成；入口请求、结果和对接回调都交回主线程。错误只通过公开白名单码传递，消息和 details 脱敏。提供方应保证每次回调仅完成一次；桥接同时防御重复、超时、旧引擎和 provider 替换后的结果。

`synchronizeHostSessionWithCompletion:` 用于提前准备；`openMessengerFromViewController:completion:` 在实际呈现前等待会话复查，未登录或认证失败会回调错误而不打开 SDK 登录页面。`notifyHostSessionChangedWithCompletion:`、宿主管理模式下的 `logout` / `shutdown` 通过优先通道作废在途操作，不排在旧认证后等待。

MediaServiceClient 的实际字段、通知延迟、可选适配代码和模拟宿主验证范围见 [专用参考](MEDIASERVICECLIENT_HOST_SESSION.md)。适配示例只位于 IMSDK，不会注入或修改宿主。

## Android

实现 `ImSdk.HostSessionProvider` 的 `readSession(callback)` 与 `fetchCredentials(session, callback)`，在初始化前调用 `ImSdk.setHostSessionProvider(provider)`，再传 `hostManagedAuth=true` 初始化。成功时使用 `callback.onSuccess(map)`，已退出的状态查询使用 `onSuccess(null)`，失败通过 `onError` 返回脱敏错误码。

调用 `ImSdk.synchronizeHostSession(callback)` 预热、`ImSdk.notifyHostSessionChanged(callback)` 通知状态变化。会话列表仍使用 `openMessenger(activity, callback)`；错误时保持宿主页面，由宿主决定重试方式。SDK 不自行打开宿主登录页。所有 provider 调用与回调结果通过主线程协调。

## Web

Web 使用同样的快照与配置语义，`client.initialize({..., hostManagedAuth: true})` 后绑定 `HostSessionProvider`。`subscribe(onChanged)` 可选；无订阅时由宿主调用 `notifyHostSessionChanged()`。详见 [Web 接入说明](../web/handoff/docs/INTEGRATION.md)。Web 凭证仍仅在实例内存中保存，整页刷新后通过 provider 重新建立会话。

## 性能和验收边界

无登录弹窗并不表示首次认证没有网络等待。推荐在宿主登录完成或预计进入聊天前初始化、同步并预热；同账号列表优先使用缓存，后台更新。无缓存时使用稳定列表壳，不用登录弹窗阻塞入口。真实换票、IM 身份校验、磁盘打开、引擎启动和网络均影响冷启动耗时，需要分别测量首帧与首屏可交互时间。

验收应覆盖：宿主有效而 IM accessToken 过期、IM refresh 凭证失效后的重新取票、宿主退出与换号、取票 / profile 请求进行中退出、漏通知入口复查、provider 超时及恢复、重复回调、SDK 释放，以及默认独立登录模式。真实后台撤销、真机恢复和首次页面耗时需在真实后端及宿主具备后另外验证。
