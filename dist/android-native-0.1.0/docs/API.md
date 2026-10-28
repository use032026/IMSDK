# Android SDK API

SDK：`0.1.0` · 更新：2026-10-28 · 入口：`com.imsdk.nativebridge.ImSdk`

## 调用约定

所有方法均可从 Java 静态调用；Kotlin 使用 `ImSdk.method(...)`。异步结果通过 `ImSdk.Callback` 返回：

```kotlin
interface Callback {
    fun onSuccess(value: Any?)
    fun onError(code: String, message: String?, details: Any?)
}
fun interface EventListener {
    fun onEvent(event: Map<String, Any?>)
}
```

回调和事件在 Android 主线程执行。方法在 SDK 内串行处理，每次调用最多完成一次。页面打开回调表示页面已打开，不代表登录、客服接入或消息收发完成。业务不应解析错误文案作逻辑判断，也不应记录原始凭证、接口响应或错误详情。

## 方法

| 方法 | 前置条件与结果 |
| --- | --- |
| `initialize(context, configuration, callback)` | 宿主先取得隐私同意；配置见接入说明。成功后可调用页面 API；使用 application context 创建运行时 |
| `openMessenger(activity, callback)` | 已初始化；未登录显示账号密码页，已登录显示会话列表；成功值通常为 `null` |
| `authenticate(credentials, callback)` | 已初始化；使用可信后端签发的 IM 凭证建立账号会话；成功值通常为 `null` |
| `openDirectConversation(activity, target, callback)` | 已认证且目标属于当前账号授权范围；打开指定会话；成功值通常为 `null` |
| `openCustomerService(activity, target, callback)` | 已认证；发起真实客服请求，展示排队 / 接入页面；返回客服会话 map |
| `setEventListener(listener)` | 设置单个事件监听器；传 `null` 清除，SDK 强持有监听器 |
| `logout(callback)` | 已初始化；完成本地账号清理，成功后关闭 SDK 页面；不代替宿主后端撤销 token |
| `shutdown(callback)` | 结束 Dart 运行时后释放引擎；成功或错误均会收尾释放，之后允许重新 `initialize`；尚无引擎时直接成功 |

参数类型：`context: Context`、`activity: Activity`、配置 / 凭证 / target 为 `Map<String, Any?>`（Java 可用 `Map<String, Object>`），callback 为 `ImSdk.Callback`。

## 初始化配置

完整约束和仓库配置见 [INTEGRATION.md](INTEGRATION.md)。必须传 `apiBaseUrl`、`serviceRealmId`、`privacyConsentGranted=true`。账号密码入口显式传 `passwordLogin`：

```json
{"space":"personal","loginType":"lpp_id"}
```

企业模式为 `{"space":"tenant","loginType":"login_name","tenantCode":"your-fixed-tenant-code"}`，也可按后端账号体系选择企业 `lpp_id`。个人模式禁止传 `tenantCode`；企业模式要求固定非空 `tenantCode`。

## 外部凭证

`authenticate` 只接受 IM 服务凭证，所有必填字符串非空：

| 字段 | 类型 / 含义 |
| --- | --- |
| `platformUserId` | 必填 String，IM 平台用户 ID |
| `userId` | 必填 String，当前空间用户 ID |
| `spaceId` | 必填 String，当前空间 ID |
| `accessToken` | 必填 String，IM 空间访问 token |
| `refreshToken` | 必填 String，IM 空间刷新 token |
| `expiresAt` | 必填 String，未来时间的 ISO 8601 时间戳，建议 UTC |
| `platformToken` | 可选 String，平台访问 token |
| `platformRefreshToken` | 可选 String，平台刷新 token |
| `deviceSessionToken` | 可选 String，设备会话 token |

接入方后端负责映射宿主业务账号、授权对应 IM 空间、签发和刷新凭证。不要把业务登录 token 或服务端管理密钥传入此接口。

## 指定会话

`openDirectConversation` 的 `target`：

| 字段 | 含义 |
| --- | --- |
| `conversationId` | 必填 String，后端授权的真实会话 ID |
| `title` | 可选 String，默认“聊天” |
| `peerUserId` | 可选 String，对端展示信息 |
| `avatarUrl` | 可选 String，展示头像 |
| `serviceThreadId` | 可选 String，客服线程标识；仅使用后端确认的客服会话信息 |

普通聊天优先从 `openMessenger` 的会话列表进入，用户不需要提供上述参数。客服应通过客服入口取得状态，不能用此方法绕过排队。

## 客服请求与状态

企业入口：

```json
{"entry":"currentTenant"}
```

品牌入口：

```json
{"entry":"serviceAccount","serviceAccountId":"backend-authorized-service-account-id"}
```

品牌入口可附带 `locale`、`category`、`sourceUrl`。省略 `entry` 时按品牌入口处理，仍要求 `serviceAccountId`；当前企业入口不得同时指定服务账号。`serviceAccountId` 是服务账号 ID，不是官方账号用户投影 ID。

成功值包含 `threadId`、`status`、`conversationId`、`staffUserId`、`staffDisplayName`、`canOpenConversation`，部分字段可为 `null`。`status` 为 `queued`、`active` 或 `unknown`。仅当线程 ID 非空、状态 `active`、会话 ID 非空时，`canOpenConversation=true`。`queued` / `unknown` 即使带有会话 ID，也不能打开聊天。成功请求不代表已有客服接待。

## 事件

监听器接收 map，事件名位于 `type`；业务字段位于同一层，无额外 `data` 包装。未识别事件请忽略。

| `type` | 字段 / 含义 |
| --- | --- |
| `ready` | 内部引擎准备完成信号，不代替 initialize 成功 |
| `initialized` | 配置初始化成功 |
| `authenticationRequired` | 需要重新认证 |
| `authenticated` | `spaceId`，认证成功 |
| `authenticationFailed` | `code`，SDK 账号密码登录失败 |
| `connectionChanged` | `status`，连接状态 |
| `unreadChanged` | `count`、`spaceId`，当前空间未读数 |
| `customerServiceChanged` | 客服会话状态字段，与客服结果同结构 |
| `loggedOut` | 已退出账号 |
| `pageClosed` | SDK 页面关闭；配置变化导致的重建不会按普通关闭上报 |
| `runtimeError` | `code`，如恢复任务失败 |

不要将事件当作逐条消息投递回执。UI 内的文本收发能力已联调，但本门面不提供原生逐消息发送、拉取或送达回执 API。

## 生命周期与错误

引擎启动等待 Dart ready 信号，最长 20 秒；已实际调用的单次操作最长 60 秒，排队等待不计入该操作执行时长。普通页面关闭保留引擎和账号。打开页面需使用有效且未销毁的 Activity；重复打开复用 / 调整已有 SDK 页面。进程死亡后的旧页面安全结束，宿主需重新进入自己的恢复流程。

| 错误码 | 接入处理 |
| --- | --- |
| `CONSENT_REQUIRED` | 完成宿主隐私同意流程后再初始化 |
| `INVALID_CONFIG` / `INVALID_ARGUMENT` | 修正开发者配置或调用参数 |
| `SDK_NOT_INITIALIZED` / `NOT_INITIALIZED` | 等待 initialize 成功后调用 |
| `NOT_AUTHENTICATED` / `CREDENTIALS_EXPIRED` | 建立或刷新匹配账号的 IM 会话 |
| `SDK_START_FAILED` / `SDK_READY_TIMEOUT` | 引擎未能启动，确认环境后重新初始化 |
| `SDK_OPERATION_TIMEOUT` | 当前引擎被释放，待重新初始化成功再重试 |
| `SDK_STOPPING` | 等待 shutdown 回调，之后重新初始化 |
| `HOST_ACTIVITY_UNAVAILABLE` | 当前 Activity 不再有效，从有效页面重试 |
| `SDK_PAGE_OPEN_FAILED` | 检查宿主页面启动与清单合并 |
| `SDK_METHOD_UNAVAILABLE` | 检查原生门面和模块是否来自同一完整交付版本 |
| `SERVICE_QUEUED` / `SERVICE_NOT_READY` | 保持排队 / 未就绪状态，不打开聊天 |
| `SESSION_CHANGED` | 请求期间账号变化；使用当前匹配身份重新请求 |
| `ACTIVITY_DETACHED` | 待页面重新附着后重试选择器或权限操作 |

其他 Dart 业务错误会继续传递给宿主。shutdown 或超时释放引擎时，未完成操作也会收到结束错误。不要无限自动重试登录或页面打开；让宿主根据错误码和用户操作决定恢复。
