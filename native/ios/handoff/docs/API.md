# iOS 原生 API

`openMessenger` 页面承载注册 / 登录、会话列表、添加好友及申请处理、单聊和新建群聊 / 群聊。注册使用手机号或邮箱验证，默认进入个人空间；服务端直接返回企业登录态时进入该企业空间，无需选择，同时仅登录一个空间；原生调用签名保持不变。本包构建及消费验证结果见 `MANIFEST.json`。

SDK 0.1.1 · 2026-10-28 · 模块 `IMSDKNative`

## 调用约定

Swift 使用 `IMSDK.shared`，Objective-C 使用 `[IMSDK shared]`。异步 completion 的 Swift 类型为 `(Any?, NSError?) -> Void`；无错误时 `error == nil`，成功返回值可以为 `nil`。各操作 completion 最多回调一次；所有 completion 和事件在主线程，SDK 内部串行调度操作。公开字典使用字符串键和 Flutter 标准通道可编码值，不传入自定义对象。

## 方法

| Swift | Objective-C selector | 前置条件 / 结果 |
| --- | --- | --- |
| `initialize(configuration:completion:)` | `initializeWithConfiguration:completion:` | 宿主已取得隐私同意；创建运行时，成功后才能打开入口 |
| `openMessenger(from:completion:)` | `openMessengerFromViewController:completion:` | 已初始化；打开账号密码页或会话列表；无需预先 `authenticate` |
| `authenticate(credentials:completion:)` | `authenticateWithCredentials:completion:` | 已初始化；提交后端签发的 IM 凭证 |
| `openDirectConversation(from:target:completion:)` | `openDirectConversationFromViewController:target:completion:` | 已初始化并认证；打开服务端已存在的指定会话 |
| `openCustomerService(from:target:completion:)` | `openCustomerServiceFromViewController:target:completion:` | 已初始化并认证；请求客服并展示状态页 / 可用聊天；返回客服状态字典 |
| `logout(completion:)` | `logoutWithCompletion:` | 已初始化；清理本地登录态，成功后关闭页面 |
| `shutdown(completion:)` | `shutdownWithCompletion:` | 清理并释放运行时，无 engine 时可直接成功；完成后重新初始化 |

`open...` 的 presenter 必须是当前窗口内可见的 `UIViewController`。completion 成功表示操作及原生展示请求完成，不表示用户已登录、消息已送达或客服已接入。单聊 / 群聊消息收发通过 SDK 页面完成，原生 facade 没有额外的 `sendMessage` 或独立群聊 API。

## 属性与监听

| Swift 属性 | 类型 / 说明 |
| --- | --- |
| `eventListener` | `IMSDKEventListener?`，**weak**；宿主须强持有对象 |
| `presentationMode` | `IMSDKPresentationMode`，默认 `.automatic`；可选 `.push`、`.present` |

监听协议为 `func imSdkDidReceiveEvent(_ payload: [String: Any])`；Objective-C 为 `- (void)imSdkDidReceiveEvent:(NSDictionary<NSString *, id> *)payload`。属性赋值和宿主 UIKit 调用在主线程执行。

`.automatic` 在可用导航控制器上 push，否则全屏 present；`.push` 无导航控制器时返回错误。页面关闭发出 `pageClosed`，保留账号与 engine；目前没有单独公开的 `close` 方法。彻底释放使用 `shutdown`。

## configuration

| 字段 | 要求 | 说明 |
| --- | --- | --- |
| `apiBaseUrl` | 必填字符串 | HTTPS IM API 地址，无用户信息、查询串或片段 |
| `serviceRealmId` | 必填非空字符串 | 服务环境的稳定标识，参与存储隔离 |
| `privacyConsentGranted` | 必填 `true` | 由宿主真实同意流程提供；启动 engine 前校验 |
| `gatewayBaseUrl` | 可选字符串 | HTTPS / WSS 地址，无用户信息、查询串或片段 |
| `storageNamespace` | 可选字符串 | 默认 `default`；1–64 位字母、数字及 `._-` |
| `locale` | 可选字符串 | 默认 `zh_CN` |
| `passwordLogin` | 账号密码入口必填字典 | 由宿主固定账号路由，见下表 |

| 登录场景 | `passwordLogin` |
| --- | --- |
| 个人账号 | `{"space":"personal","loginType":"lpp_id"}`，不传 `tenantCode` |
| 固定企业 | `{"space":"tenant","loginType":"login_name","tenantCode":"your-tenant-code"}`；按服务端约定也可用 `lpp_id` |

`passwordLogin` 未填写时，外部凭证路径仍可用；账号密码页请求验证码 / 登录会报告 `PASSWORD_LOGIN_NOT_CONFIGURED`。企业模式必须有 `tenantCode`。初始化后不能直接切换配置，先 `shutdown` 再初始化。

## credentials：仅外部凭证认证需要

| 字段 | 要求 | 说明 |
| --- | --- | --- |
| `platformUserId` | 必填非空字符串 | IM 平台用户身份 |
| `userId` | 必填非空字符串 | 当前 IM 用户身份 |
| `spaceId` | 必填非空字符串 | 个人空间用 `personal`；企业用后端返回的真实空间 ID |
| `accessToken` | 必填非空字符串 | IM 访问令牌 |
| `refreshToken` | 必填非空字符串 | IM 刷新令牌 |
| `expiresAt` | 必填字符串 | ISO 8601 时间，必须晚于当前时间 |
| `platformToken` | 可选字符串 | 后端签发的平台令牌 |
| `platformRefreshToken` | 可选字符串 | 对应平台刷新令牌 |
| `deviceSessionToken` | 可选字符串 | 后端签发的设备会话令牌 |

这些值来自可信宿主后端，并需通过真实 IM 服务校验身份 / 空间。不要把宿主自己的业务 token 或服务端管理密钥放入这些字段。普通账号密码入口由 SDK 自行完成登录，不需要宿主收集本字典。

## target：指定单聊

| 字段 | 要求 | 说明 |
| --- | --- | --- |
| `conversationId` | 必填非空字符串 | 已存在且当前账号获准访问的真实会话 ID |
| `title` | 可选字符串 | 默认 `聊天` |
| `peerUserId` | 可选字符串 | 对端用户 ID，不能替代 `conversationId` |
| `avatarUrl` | 可选字符串 | 对端头像 URL |
| `serviceThreadId` | 可选字符串 | 仅合法客服会话上下文使用，不用于绕过排队状态 |

此方法不按用户 ID 自动创建单聊，也不授予服务端未允许的会话访问权限。

## target：客服

当前企业入口：

```json
{"entry": "currentTenant"}
```

品牌服务账号入口：

```json
{
  "entry": "serviceAccount",
  "serviceAccountId": "your-service-account-id"
}
```

品牌入口可选 `locale`、`category`、`sourceUrl`，省略 `entry` 时按品牌入口解析。当前企业入口不传 `serviceAccountId`。品牌入口的 `serviceAccountId` 必须是服务账号实体 ID，不能使用客服人员用户 ID 或展示账号投影。

成功返回值和 `customerServiceChanged` 事件包含：

| 字段 | 类型 / 含义 |
| --- | --- |
| `threadId` | 客服线程标识 |
| `status` | `queued`、`active`、`unknown` |
| `conversationId` | 可为空；底层聊天会话 ID |
| `staffUserId`、`staffDisplayName` | 可为空；已分配客服信息 |
| `canOpenConversation` | 仅线程非空、`status=active` 且会话非空时为 `true` |

`queued` 表示等待接入；`unknown` 不授予聊天入口。宿主展示状态时应保留这一差异。不能把成功 completion 或非空 `threadId` 当作客服已接入。

## 事件

payload 顶层以 `type` 区分事件，其余字段也在顶层。事件是状态通知，不是原生消息送达回执；不要用 `unreadChanged` 推导某条消息已发送成功。

| `type` | 附加字段 | 处理建议 |
| --- | --- | --- |
| `ready` | 无 | 内部运行时桥接就绪；业务入口仍等 `initialize` completion |
| `initialized` | 无 | SDK 业务运行时已初始化 |
| `authenticationRequired` | 无 | 当前需要认证；普通聊天入口可呈现账号密码页 |
| `authenticated` | `spaceId` | 当前空间已认证 |
| `authenticationFailed` | `code` | 登录失败，按脱敏错误处理 |
| `connectionChanged` | `status` | 连接状态通知，字段名为 `status` |
| `unreadChanged` | `count`、`spaceId` | 当前空间未读数；按空间更新宿主角标 |
| `customerServiceChanged` | 客服状态字段 | 排队 / 接入状态变更 |
| `loggedOut` | 无 | SDK 本地已退出 |
| `pageClosed` | 无 | SDK 页面已关闭，engine 和账号可能仍存在 |
| `runtimeError` | `code` | 例如本地恢复失败，记录脱敏错误用于排查 |

监听器需容忍未知事件和新增字段，避免依赖登录过程中事件与 completion 的相对先后顺序。

## 错误

NSError 的 `domain` 为 `IMSDK`，数值 `code` 为通用值；**业务判断使用 `error.userInfo["code"]` 中的字符串**。`localizedDescription` 可用于提示；不要输出包含凭证的上下文、原始响应或完整 details。

| 字符串码 | 建议处理 |
| --- | --- |
| `CONSENT_REQUIRED` | 完成宿主隐私同意流程 |
| `INVALID_CONFIG`、`CONFIG_CONFLICT` | 核对环境 / 登录路由；更换配置前 shutdown |
| `PASSWORD_LOGIN_NOT_CONFIGURED` | 提供明确的 `passwordLogin` |
| `INVALID_ARGUMENT`、`CREDENTIALS_EXPIRED` | 校验参数或向可信后端重取凭证 |
| `SDK_NOT_INITIALIZED`、`NOT_INITIALIZED` | 先初始化成功再调用 |
| `NOT_AUTHENTICATED`、`authenticationRequired` 事件 | 重新登录 / 认证 |
| `SDK_START_FAILED`、`SDK_PLUGIN_REGISTRANT_MISSING`、`SDK_METHOD_UNAVAILABLE` | 检查完整框架组、版本、链接和嵌入设置 |
| `HOST_VIEW_CONTROLLER_UNAVAILABLE`、`HOST_PRESENTATION_BUSY`、`HOST_NAVIGATION_UNAVAILABLE` | 修正可见宿主控制器和展示方式 |
| `SDK_READY_TIMEOUT`、`SDK_OPERATION_TIMEOUT` | 当前 engine 已退役；处理失败后重新初始化 |
| `SDK_STOPPING`、`SDK_RETIRED`、`SDK_SHUTDOWN` | 等待停机完成，丢弃旧会话的操作 |
| `SESSION_CHANGED` | 本次操作账号上下文已改变，重新确认当前账号 |

后端 / SDK 还可能返回认证、网络或业务错误码。保留字符串码和复现步骤，避免仅按上述列表断言全部错误。
