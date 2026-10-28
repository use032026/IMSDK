# MediaServiceClient 宿主登录态参考适配

本文及 `native/ios/Examples/MediaServiceClientHostSessionAdapter.{h,m}` 只保存在 IMSDK 工程。它们不会修改、注入、构建或启动 MediaServiceClient，也不包含任何账号或业务凭证。适配文件不属于 SDK 的 `Sources/`，不会被 SDK 的 podspec 自动编译；需要接入时由宿主选择加入 App target，并链接 STCore 和重新构建的 IMSDKNative。

## 已核对的宿主事实

本次只读参照路径是 `/Users/starburst/Documents/Work/MediaServiceClient`，`dev/dev_chat` 分支，提交 `1f67b4347`。该宿主当前使用 H5 客服，没有发现本独立 IMSDK 的接入调用。下列事实以该版本源码为准：

| 对接内容 | 当前来源 |
| --- | --- |
| 是否正常登录 | `STLoginManager.isLogin`；游客不算正常登录，不能用有 token 代替 |
| 稳定业务身份 | `STLoginManager.sharedLoginManager.infoModel.userId` 与 `STSDKUtility.requestHeaderPkgName` |
| 业务凭证 | `infoModel.token / refreshToken / expAt`；它们是宿主业务凭证，不是 IM 凭证 |
| 登录 / 续期通知 | `STLoginPreSuccessNotification`、`STLoginSuccessNotification`、`STAnonymousLoginSuccessNotification`、`STAuthRefreshSuccessNotification` |
| 退出通知 | `STLogoutSuccessNotification` 在匿名登录网络请求完成后才发；实际本地状态在 `clearLoginInfo` 中已先清空 |
| 单一登录回调 | `loginStateChangeCallback` 已由 AppDelegate 用于推送；参考适配不会覆盖或包装该回调 |

代码入口为 `STCore/Classes/Base/STLoginManager.m` 的 `getLoginState / isLogin / clearLoginInfo / logoutWithCompletion:`，以及 `STCore/Classes/Models/Login/STLoginInfoModel.{h,m}`。现有业务状态刷新可能同时改变 `userId`，因此适配同时复核身份与会话摘要。

## 仍缺少真实 IM 换票契约

已发现的 `GET violet/api/user/customer_service/entry` 返回 `enabled` 和带签名的客服 URL，`GET violet/api/user/customer_service/unread` 返回未读数。它们均未提供本 SDK 认证要求的完整 IM 凭证。`peony/v3/ilive/login` 是直播 token 路径，也不能当作本 SDK 的 IM 换票接口。

不得根据客服 URL、相同用户名、宿主 `userId` 或业务 token 推导 IM 的 `platformUserId / userId / spaceId / accessToken / refreshToken / expiresAt`。需要受信后端明确业务账号到 IM 账号 / 空间的映射及签发权限。没有该契约时，本例的 `credentialExchange` 保持 nil，SDK 返回 `HOST_CREDENTIALS_UNAVAILABLE`，不会弹出 SDK 账号密码登录页面，也不会假造认证成功。

## 可选接入方式

下面是接入方将来可采用的代码，不能作为当前宿主已经集成或真实 SSO 已通过的证据。`configuration` 来自已核准的 SDK 配置，隐私同意必须由宿主实际取得。主线程创建、配置并长期持有适配器；不能把它放在临时局部变量中。

```objc
#import <IMSDKNative/IMSDKNative-Swift.h>
#import "MediaServiceClientHostSessionAdapter.h"

// 由宿主长期持有：
@property (nonatomic, strong) IMSDKMediaServiceClientHostSessionAdapter *imSessionAdapter;

// 在宿主完成隐私同意后：
self.imSessionAdapter = [[IMSDKMediaServiceClientHostSessionAdapter alloc] init];

// 后端契约确定前保持 nil。确定后注入自己的受信换票实现：
// adapter.credentialExchange = ^(NSDictionary *hostSession,
//                               IMSDKHostCredentialsCompletion completion) {
//   读取当前业务身份，用已约定的宿主后端接口获取完整 IM 凭证；
//   不在参数、日志或 UI 中输出 token，并通过 completion 返回结果。
// };

[IMSDK shared].hostSessionProvider = self.imSessionAdapter;
NSMutableDictionary *managedConfig = [configuration mutableCopy];
managedConfig[@"hostManagedAuth"] = @YES;
[[IMSDK shared] initializeWithConfiguration:managedConfig completion:^(id value, NSError *error) {
  if (error) return; // 交给宿主现有错误展示策略，不打开 SDK 登录页。
  [self.imSessionAdapter start];
  // openMessenger 内部先校验宿主会话。换票失败时回调错误，不弹登录页。
  [[IMSDK shared] openMessengerFromViewController:visiblePresenter
                                     completion:^(id result, NSError *failure) {
    // 入口完成不等于消息已同步；不要打印原始错误详情或凭证。
  }];
}];
```

可在预计进入聊天前调用 `synchronizeHostSessionWithCompletion:` 预热。登录态变化调用 `notifyHostSessionChangedWithCompletion:`，SDK 会使旧的异步认证结果失效；普通页面关闭保留 SDK 引擎。`hostManagedAuth=true` 的身份来源是 provider，宿主自己的登录页面仍由宿主决定何时展示。

结束使用时先 `[self.imSessionAdapter stop]`，按需要调用 SDK 的 `logoutWithCompletion:` 或 `shutdownWithCompletion:` 并等待完成，再清空 `[IMSDK shared].hostSessionProvider` 与宿主的适配器属性。`stop` 仅移除适配器的监听与定时采样，不修改宿主登录状态，也不代替 SDK 退出。

## 同步时序和延迟边界

适配器默认不启动、不自动设置 SDK provider。`start` 后监听现有身份通知；App 处于 active 时额外每 1 秒读取一次本地状态，补偿退出通知等待匿名请求完成的时间差。进入非 active / 后台时停止定时器，重新 active 时立即采样并通知 SDK；`stop` 和释放都会移除相应监听和定时器。

正常前台且主线程可调度时，未收到退出通知的状态变化会在下一次约 1 秒采样时被发现；之后还需 SDK 调度及本地清理时间。主线程阻塞、App 挂起或进程终止时不能保证这个时限。采样间隔内发生退出并用完全相同的凭证重新进入，也不能由轮询完整重建中间事件。严格要求退出瞬间即同步时，应由宿主在真正清理本地身份时直接向 SDK 通知变化，或提供可靠的状态流；不能靠覆盖宿主现有 callback 实现。

`hostUserId` 使用 `package|userId`；`sessionId` 是对长度明确的 JSON 数组 `[package, userId, token, refreshToken]` 做 SHA-256 后的摘要。原始业务 token 不会传给 SDK provider 调用方；摘要也不应输出到日志。业务 token 续期会改变摘要，并触发安全重校，可能产生一次新的 IM 凭证请求。凭证返回前再次对比 snapshot，退出、换号或续期期间返回的旧凭证会以 `HOST_SESSION_CHANGED` 拒绝。后端换票实现必须允许安全重试，SDK 会独立验证 IM 凭证。

该机制支持避免登录弹窗；“秒开”还取决于提前初始化 / 同步、网络耗时、缓存和引擎状态，必须单独测量首帧与可交互耗时，不能用无登录弹窗替代性能验收。

## 验证边界

可以在 IMSDK 内用假 STCore 状态与假 provider 验证正常 / 游客状态、续期、登出、迟到凭证及监听清理，不需要启动真实宿主。真实后端换票、MediaServiceClient 实际接入、真机前后台恢复与页面性能需在接入授权和后端契约具备后另行验收。现有原生分发二进制不会因源码示例新增而自动获得这些接口；消费前须重新构建对应 SDK 二进制。
