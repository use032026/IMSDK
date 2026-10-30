# Web SDK 0.1.6 API 参考

文档整理日期：2026-10-29。本文对应交付包中的 `@imsdk/web` 0.1.6 与 `sdk/im-sdk.js`，完整 TypeScript 声明位于 `sdk/types/`。

本版包含注册后自动登录一个空间、好友搜索 / 申请处理和新建群聊接口。完整类型以包内 TypeScript 声明为准，构建与验证记录见 `MANIFEST.json`。

ESM / npm 导入：

```ts
import {
  ImSdkClient,
  ImSdkError,
  mountMessenger,
  type ImSdkConfig,
  type ImSdkMessenger,
  type ConversationTarget,
} from '@imsdk/web';
```

普通 `<script>` 接入时，三个运行时导出分别为 `IMSDK.ImSdkClient`、`IMSDK.ImSdkError`、`IMSDK.mountMessenger`。接口类型仅供 TypeScript 使用，不是运行时构造器。

## 1. 实例与生命周期

```ts
const client = new ImSdkClient();
```

构造器无参数。一个实例只有一个活跃账号和空间；不同实例的凭证与请求相互隔离。凭证默认只在内存中保存，刷新页面后需要重新登录或由宿主重新提交 IM 凭证。

| 只读属性 | 类型 | 含义 |
| --- | --- | --- |
| `isInitialized` | `boolean` | 是否完成初始化且尚未释放 |
| `isAuthenticated` | `boolean` | 是否有活跃的本地会话；服务端仍可能在后续请求时要求重新认证 |
| `sessionRevision` | `number` | 当前账号生命周期版本；切换、退出或释放时变化，可用于废弃旧异步结果 |
| `config` | `ImSdkConfig \| undefined` | 初始化配置的副本；判断能否继续使用实例请用 `isInitialized` |
| `currentUser` | `{userId: string; platformUserId: string; spaceId: string} \| undefined` | 当前已激活的身份摘要，不返回 token |

| 方法 | 返回 | 说明 |
| --- | --- | --- |
| `initialize(config: ImSdkConfig)` | `void`，同步 | 验证并保存配置；同实例再次初始化会报配置冲突，即使传入相同配置也应复用现有实例 |
| `on(listener: (event: ImSdkEvent) => void)` | `() => void`，同步 | 注册监听，返回取消监听函数；可在初始化前注册，以接收 `ready` |
| `logout()` | `Promise<void>` | 立即清除本地身份、废弃在途请求并停止网关；内置界面回到登录页，实例仍可重新登录 |
| `shutdown()` | `Promise<void>` | 释放账号、请求、网关与监听，内置界面关闭；重复调用可安全等待释放完成 |

`shutdown()` 后不能重新初始化或登录这个实例，需要 `new ImSdkClient()`。宿主路由卸载时关闭界面，宿主账号退出时调用 `logout()`，不再使用整个 SDK 时调用 `shutdown()`。本地退出不等于服务端 token 撤销，后者由宿主后端负责。

## 2. 初始化配置

```ts
interface ImSdkConfig {
  apiBaseUrl: string;
  gatewayBaseUrl?: string;
  serviceRealmId: string;
  privacyConsentGranted: boolean;
  passwordLogin?: ImSdkPasswordLoginConfig;
  requestTimeoutMs?: number;
  realtime?: boolean;
  pollIntervalMs?: number;
}

interface ImSdkPasswordLoginConfig {
  space: 'personal' | 'tenant';
  loginType: 'lpp_id' | 'login_name';
  tenantCode?: string;
}
```

| 字段 | 必填 / 默认值 | 约束 |
| --- | --- | --- |
| `apiBaseUrl` | 必填 | HTTPS 服务根地址；不能带用户名、密码、查询参数或片段。SDK 在该地址后追加 `/api/...` |
| `gatewayBaseUrl` | 默认同 `apiBaseUrl` | HTTPS / WSS 服务根地址，SDK 追加 `/ws/client`；不能带用户名、密码、查询参数或片段 |
| `serviceRealmId` | 必填 | 接入方分配的稳定、非空环境标识 |
| `privacyConsentGranted` | 必须为 `true` | 应对应宿主已取得的实际用户同意 |
| `passwordLogin` | `{space: 'personal', loginType: 'lpp_id'}` | 仅控制密码登录的空间和账号路由 |
| `requestTimeoutMs` | `30000` | 有限数值，范围 `100–300000` 毫秒 |
| `realtime` | 默认开启 | 设 `false` 时不建立实时网关；REST 接口仍可使用 |
| `pollIntervalMs` | `15000` | 有限数值，范围 `5000–300000` 毫秒；作用于可见的内置列表/聊天界面补取快照 |

个人空间只能使用 `space: 'personal'`、`loginType: 'lpp_id'`，且不能提供 `tenantCode`。企业空间必须提供非空的固定 `tenantCode`，`loginType` 可为 `login_name` 或 `lpp_id`；后者只选择与固定企业码精确匹配的企业。

```ts
client.initialize({
  apiBaseUrl: 'https://your-im-api.example.com',
  serviceRealmId: 'your-stable-service-realm',
  privacyConsentGranted: true,
  passwordLogin: { space: 'personal', loginType: 'lpp_id' },
});
```

## 3. 登录与外部凭证

注册接口：

```ts
getRegistrationVerificationSettings(): Promise<RegistrationVerificationSettings>
sendRegistrationCode(request: RegistrationCodeRequest): Promise<void>
registerWithPassword(request: RegistrationRequest): Promise<void>

interface RegistrationVerificationSettings {
  smsEnabled: boolean;
  emailEnabled: boolean;
  smsRequired: boolean;
  emailRequired: boolean;
}

interface RegistrationCodeRequest {
  channel: 'sms' | 'email';
  identifier: string;
  captchaToken?: string;
  captchaAnswer?: string;
}

interface RegistrationRequest extends RegistrationCodeRequest {
  displayName: string;
  password: string;
  verificationCode?: string;
}
```

注册渠道及验证码要求由服务端设置决定；需要安全验证时使用同一 `requestLoginCaptcha()`。`registerWithPassword` 不接收企业 / 邀请 / 空间参数，成功表示服务端返回的个人或企业身份已核验，并成为唯一活跃空间。平台凭证响应默认请求个人空间；直接返回企业登录态时进入该企业，不强制改成个人空间。`REGISTER_PENDING_APPROVAL` 表示账号已创建、等待审核；`REGISTER_LOGIN_FAILED` 表示账号已创建但自动登录未完成，应返回登录重试，避免重复注册。个人密码登录按输入的手机号、邮箱或平台账号选择对应登录类型；固定企业登录继续按宿主配置。

```ts
loginWithPassword(request: LoginRequest): Promise<void>
requestLoginCaptcha(): Promise<CaptchaChallenge>
authenticate(credentials: ImSdkCredentials): Promise<void>

interface LoginRequest {
  account: string;
  password: string;
  captchaToken?: string;
  captchaAnswer?: string;
}

interface CaptchaChallenge {
  token: string;
  question: string;
}

interface ImSdkCredentials {
  platformUserId: string;
  userId: string;
  spaceId: string;
  accessToken: string;
  refreshToken: string;
  expiresAt: string;
  platformToken?: string;
  platformRefreshToken?: string;
  deviceSessionToken?: string;
}
```

- `loginWithPassword` 按初始化时固定的配置登录。账号不能为空；密码保持原内容，不做去空格处理。提供验证码时，token 和答案必须同时非空。
- `requestLoginCaptcha` 返回可显示的问题和待提交的 token，不自动提交答案。
- `authenticate` 接收可信宿主后端签发的 **IM** 凭证。前六个字段必须提供，`expiresAt` 必须是未来的 ISO 8601 时间；个人空间的 `spaceId` 为 `personal`，企业空间使用对应的真实空间 ID。
- SDK 会先用收到的 bearer 请求服务端身份，再核对身份和空间，不直接把宿主声称的用户 ID 当作认证依据。开始有效的身份切换后，旧会话和旧请求会失效。
- 后续请求在凭证临近到期时尝试刷新；并发刷新合并，HTTP 401 最多刷新并重试一次。暂时的网络错误不会被当作必须清除账号的凭据。

其他系统的账号与 IM 账号映射、取票、服务端撤销由后端完成。不要将其他业务系统 token、管理员密钥或服务端密钥作为 `accessToken`。可选的平台凭证字段不代表 SDK 提供跨系统 SSO；IM 自身续期以 IM `refreshToken` 为准。0.1.6 的 `hostManagedAuth` 模式可通过宿主 provider 静默获取新 IM 凭证，契约如下；旧0.1.5包保持原样。

### 宿主显示设置 API（源码新增）

```ts
type ImSdkThemeMode = 'system' | 'light' | 'dark';
interface ImSdkPresentation { themeMode?: ImSdkThemeMode; locale?: string }
client.updatePresentation({ themeMode: 'dark', locale: 'ja-JP' }); // void
```

- `ImSdkConfig` 新增相同两字段，主题默认 `system`，语言默认 `zh-CN`。支持 LOCALIZATION.json 列出的35个语言标识（包括 `pt-BR` / `pt-PT`），另可使用 `system`。35种选择不等于每条SDK特有文案均已翻译：新增29语的45条Web文案复用共享译文，101条英语回退已逐条公开。
- 合法的语言、脚本和区域别名会规范化；`_` 兼容 `-`，中文脚本 Hans/Hant 优先于地区。示例：`zh-Hans-TW` → `zh-CN`、`zh-Hant-CN` → `zh-TW`、`en_US` → `en`。不接受非法 tag 或未支持语言；更新整体失败时返回 `INVALID_PRESENTATION`，配置和界面均保持原值。
- `system` 主题实时响应系统深浅色媒体设置；`system` 语言响应浏览器语言及 `languagechange`，无支持语言时回退 `zh-CN`。显式选择时系统变化不覆盖宿主的值。
- 更新同步生效，`config` 返回新快照；`presentationChanged` 包含完整规范化值。无实际变化时不重复发事件。身份和会话 revision 均不变，不调用认证或宿主取票。
- 已挂载界面原位更新 SDK 文案、错误提示、占位、日期及 aria 标签；保留表单、草稿、滚动和路由。消息正文、昵称、群名、好友附言及后端验证码问题维持原文。缺省名称与标题通过 SDK 标记识别，只有 SDK 生成的占位名会翻译。
- `close()` 取消该 view 的语言及显示监听。该 API 适用于独立登录和宿主账号同步两种模式；本次0.1.6包已包含这些接口；旧版本分发快照不会自动更新。

### 宿主账号同步 API（源码新增）

```ts
interface HostSession { hostUserId: string; sessionId: string }
interface HostSessionProvider {
  readSession(): Promise<HostSession | null>;
  fetchCredentials(session: HostSession): Promise<ImSdkCredentials>;
  subscribe?(onChanged: () => void): () => void;
}
// initialize({ ...configuration, hostManagedAuth: true }) 后使用：
client.bindHostSessionProvider(provider); // 注册变化订阅并静默预热
await client.synchronizeHostSession({ forceRefresh: false }); // Promise<boolean>
await client.notifyHostSessionChanged(); // Promise<boolean>，先立即废弃旧状态
```

- `hostManagedAuth` 默认 `false`。启用后账号由 provider 驱动，`authenticate`、密码登录及注册操作返回 `HOST_MANAGED_AUTH_REQUIRED`，内置界面不显示 SDK 登录表单。provider 需在已初始化且启用此模式的实例上绑定。
- `readSession` 返回 `null` 表示宿主登出；非空对象的两个字段均须为非空字符串。`sessionId` 是宿主登录代际，每次重新登录或换号须变化，不得包含宿主 token 或 IM 票据。SDK 不持久保存宿主会话或凭证。
- `fetchCredentials` 返回可信宿主后端签发的 IM 凭证。SDK 检查资料、身份及空间，并在取票与资料验证后复查宿主快照。宿主身份到 IM 账号映射由可信后端负责，不能只凭字符串相同宣称已打通。
- `subscribe` 回调应在宿主登录、登出及换号后立即触发；SDK 先废弃旧账号与请求，再静默同步。不提供订阅时，集成方需在每次账号变化完成后调用 `notifyHostSessionChanged`。会话列表入口、前台恢复及请求仍会复核快照。
- `synchronizeHostSession` 返回 `true` 表示当前宿主快照已对应有效 SDK 登录态，`false` 表示宿主已退出。`forceRefresh: true` 会要求取新票，并发普通复查不会吞掉该要求。
- provider 的快照读取与取票分别受 `requestTimeoutMs` 限制，超时返回 `HOST_SESSION_TIMEOUT` / `HOST_CREDENTIALS_TIMEOUT`，之后可以重试。退出、通知变化或释放时立即废弃 SDK 对旧调用的等待，不取消宿主自行拥有的网络任务，也不应用其迟到结果。
- `hostSessionSynchronizing` / `hostSessionSynchronized`（`authenticated: boolean`）/ `hostSessionError`（`code`）供宿主显示状态。内置界面只显示列表壳、同账号内存缓存或页面内重试，不显示登录弹窗或列表首屏转圈。
- `logout`、provider 替换和 `shutdown` 会立即使在途票据失效；`shutdown` 退订。以后显式同步仍会以宿主当前真实状态为准。`cachedConversations` 仅返回当前有效 IM 身份的内存首屏副本，账号退出及换号时清除。
- 账号系统、IM 服务器与宿主网络调用均可能失败；没有真实换票接口时只能验证 SDK 契约，不能认定真实业务已打通，也不能保证任意网络下的冷启动耗时。

## 4. 会话与联系人

好友及建群接口：

```ts
searchUsers(keyword: string): Promise<UserSearchResult[]>
sendFriendRequest(toUserId: string, message?: string): Promise<FriendRequestSubmission>
listFriendRequests(): Promise<FriendRequest[]>
handleFriendRequest(requestId: string, action: 'accept' | 'reject'): Promise<void>
createGroup(request: { title: string; memberUserIds?: string[] }): Promise<Conversation>
```

好友申请按服务端 `pending` / `accepted` 状态显示；申请发出不代表已经成为好友。处理申请后刷新申请及好友列表，接受后可选择好友发起单聊或创建群聊。返回类型的完整字段以重建后的 TypeScript 声明为准。建群、成员和聊天权限仍由服务端校验。

以下方法均要求已初始化且已认证：

```ts
listConversations(options?: PageOptions): Promise<ConversationPage>
getConversation(conversationId: string): Promise<Conversation>
listContacts(): Promise<Contact[]>
createDirectConversation(peerUserId: string): Promise<Conversation>

interface PageOptions {
  cursor?: string;
  limit?: number;
}

interface ConversationTarget {
  conversationId: string;
  type: 'direct' | 'group';
  title?: string;
}

interface Conversation extends ConversationTarget {
  title: string;
  unreadCount: number;
  peerUserId?: string;
  lastMessage?: string;
  lastMessageAt?: string;
}

interface ConversationPage {
  items: Conversation[];
  nextCursor?: string;
}

interface Contact {
  userId: string;
  displayName: string;
}
```

`limit` 默认50，必须是 `1–100` 的整数。收到 `nextCursor` 后原样传给下一页；没有游标表示没有下一页。

`listConversations` 只返回本版支持的单聊和群聊。`getConversation` 从服务端分页会话列表中查找实际会话，不使用独立详情接口；会话多时可能发起多次请求。`listContacts` 返回当前账号好友的显示名和真实用户 ID。`createDirectConversation` 创建或取得服务端允许联系的用户的单聊，不能绕过好友关系或权限校验。

`title` 等显示字段不能作为会话授权依据。不要仅凭外部通知中的 ID 切换到另一账号或空间；应先恢复并认证匹配的宿主身份。

## 5. 消息与已读

```ts
listMessages(
  target: ConversationTarget,
  options?: MessagePageOptions,
): Promise<Message[]>

sendText(
  target: ConversationTarget,
  text: string,
  options?: { clientMessageId?: string },
): Promise<Message>

markRead(target: ConversationTarget, seq: number): Promise<void>

interface MessagePageOptions {
  beforeSeq?: number;
  limit?: number;
}

interface Message {
  messageId: string;
  clientMessageId?: string;
  conversationId: string;
  senderUserId: string;
  senderName?: string;
  type: string;
  text: string;
  seq: number;
  sentAt: string;
  isSelf: boolean;
}
```

`target.type` 决定单聊或群聊请求路径，因此宿主应使用 SDK 返回的会话类型。`beforeSeq` 和已读 `seq` 必须为非负安全整数。历史 `limit` 同样默认50、范围1–100；返回消息按 `seq` 升序排列。

当前发送接口只提供文本，要求 `text.trim()` 非空且 `text.length ≤ 10000`（JavaScript 字符串长度）；发送与返回模型保留原始空格和换行。发送结果有服务端确认的消息 ID、序号及时间，SDK 补齐提交时的文本和发送者上下文。

`Message.type` 不是只包含 `text` 的枚举：历史可能包含其他类型，当前内置界面显示类型占位；撤回的消息返回 `recalled` 及撤回占位，不继续显示原文。本版没有公开媒体发送、编辑、撤回或群管理方法。

**网络失败不自动重发消息。** SDK 未传 ID 时会生成新的 `clientMessageId`。自行实现发送界面时，应为一次发送操作生成并保留 ID，在结果不明后重试同一条消息时复用它；编辑草稿或发送另一条消息再生成新 ID。HTTP 401 的认证重试沿用原请求 ID。服务端仍需按 `clientMsgId` 去重。

```ts
// 自行实现 UI 时，为一次发送操作保留这个 ID，直到成功或明确放弃。
const attempt = { text: '你好', clientMessageId: yourStableId };
const sent = await client.sendText(target, attempt.text, {
  clientMessageId: attempt.clientMessageId,
});
```

内置界面对同一聊天中未修改的失败草稿保留发送 ID；修改、关闭或切换聊天会开始新的发送操作。`markRead` 应仅用于用户实际读到的消息序号，不要将后台收到通知视作已读。

## 6. 客服状态

```ts
requestCustomerService(request: CustomerServiceRequest): Promise<CustomerServiceSession>

type CustomerServiceRequest =
  | { entry: 'currentTenant'; serviceAccountId?: never }
  | {
      entry?: 'serviceAccount';
      serviceAccountId: string;
      locale?: string;
      category?: string;
      sourceUrl?: string;
    };

interface CustomerServiceSession {
  threadId: string;
  status: 'queued' | 'active' | 'unknown';
  conversationId?: string;
  staffUserId?: string;
  staffDisplayName?: string;
  canOpenConversation: boolean;
}
```

两种入口二选一：当前企业入口不接受服务账号 ID；品牌入口必须传真实 `serviceAccountId`。品牌服务将 `pending` / `queued` 映射为排队，企业入口按其服务端状态处理，未知状态保持 `unknown`。

`canOpenConversation` 只有在 `status === 'active'` 且有真实 `conversationId` 时为 `true`。排队状态即使附带会话 ID 也不能进入聊天。`threadId`、服务账号 ID、官方用户投影 ID 与 `conversationId` 不能互换。此方法返回状态，不负责打开界面；需要界面时使用下节的 `view.openCustomerService`。

## 7. 内置聊天界面

```ts
mountMessenger(client: ImSdkClient, container: HTMLElement): ImSdkMessenger

interface ImSdkMessenger {
  openConversation(target: ConversationTarget): Promise<void>;
  openCustomerService(request: CustomerServiceRequest): Promise<CustomerServiceSession>;
  close(): void;
}
```

`mountMessenger` 同步返回界面句柄。`container` 必须是真实 `HTMLElement`，挂载发生在浏览器 DOM 可用后。未认证时直接显示登录 / 注册，已认证时显示会话列表。尚未初始化的实例也可展示登录 / 注册界面，所有联网操作仍须先完成有效配置及用户同意校验；宿主随后调用 `initialize` 时，界面会响应 `ready` 更新。容器需要由宿主设置可见高度，建议最小420px。

- `openConversation` 要求已认证，先从服务端会话列表解析实际类型再显示历史和输入框。
- `openCustomerService` 要求已认证，显示真实排队/未知状态；只有服务端状态允许时才进入客服聊天。
- `close` 同步、可重复调用，只删除这次挂载的界面、计时器和界面监听。**账号和网关仍保留**；再次调用 `mountMessenger` 可重开。
- 已 `close` 的句柄不能重新打开聊天，应重新挂载并取得新句柄。

挂载与部分界面前置条件错误使用普通 `Error` / `TypeError`；调用方不能假设所有界面错误都有 `ImSdkError.code`。界面操作中的网络错误仍会由客户端返回相应 SDK 错误。

## 8. 事件

```ts
interface ImSdkEvent {
  type: string;
  code?: string;
  [key: string]: unknown;
}

const unsubscribe = client.on(event => {
  if (event.type === 'authenticationRequired') {
    // 恢复正确宿主账号并重新认证，或允许用户重新登录。
  }
});
// 宿主不再需要这个监听时：unsubscribe();
```

| `type` | 可能附带字段 | 含义与处理 |
| --- | --- | --- |
| `ready` | 无 | 同步初始化完成；需要接收时在 `initialize` 前监听 |
| `sessionChanging` | 无 | 旧身份/请求已失效；自行实现的 UI 应清除旧账号数据并废弃旧结果 |
| `authenticated` | `spaceId: string` | 新身份激活，可加载当前账号数据 |
| `authenticationFailed` | `code: string` | 密码登录失败；调用本身仍会拒绝 Promise，不用事件代替 `try/catch` |
| `loggedOut` | 无 | 本地账号已退出 |
| `authenticationRequired` | `code: 'SESSION_EXPIRED'` | 需要重新认证，包括服务端安全退出及明确的凭证失效 |
| `connectionChanged` | `state: 'connecting' \| 'connected' \| 'reconnecting' \| 'disconnected'` | 网关状态；断开不等于历史或账号已被清空 |
| `conversationsChanged` | 无 | 当前会话快照需要刷新 |
| `messagesChanged` | `conversationId?: string`、`reset?: boolean` | 重取消息；未指定会话时按当前视图处理，`reset` 表示旧历史快照应失效 |
| `conversationDeleted` | `conversationId?: string` | 会话删除提示，刷新列表并校验当前视图 |
| `customerServiceChanged` | 可有 `CustomerServiceSession` 字段，也可能只有事件名 | 客服请求结果或网关更新提示；缺少完整状态时须重新查询，不能直接进入聊天 |
| `shutdown` | 无 | 实例释放；内置界面关闭，随后清除所有实例监听 |

事件用于更新 UI 或使 REST 快照失效，不是完整消息日志。不要把网关提示当作持久化的规范消息，也不要依赖每次提示必含消息正文或会话 ID。事件没有独立的总未读数推送，未读数来自会话快照。

监听回调异常不会中断 SDK 的生命周期，但宿主仍应自行处理回调错误。取消监听后不再接收后续事件；`shutdown` 也会清除监听。事件不包含原始凭证或完整后端认证数据。

## 9. 错误处理

```ts
class ImSdkError extends Error {
  readonly code: string;
  readonly status?: number;
}

try {
  await client.listConversations();
} catch (error) {
  if (error instanceof ImSdkError) {
    // 根据 code 选择用户提示/重登/重试；status 可能为空。
  } else {
    // 保留通用界面错误处理。
  }
}
```

`code` 适合程序分支；`message` 为简化提示，不应作为稳定协议解析。`status` 仅在存在 HTTP 响应时可能提供。不要记录密码、token 或完整认证请求。

| 常见 SDK 错误码 | 处理建议 |
| --- | --- |
| `NOT_INITIALIZED` | 先完成初始化 |
| `DISPOSED` | 创建新实例，不复用已释放实例 |
| `CONFIG_CONFLICT` | 复用现有配置，或释放后创建新实例 |
| `CONSENT_REQUIRED` | 宿主先完成真实用户同意流程 |
| `INVALID_CONFIG` | 检查 HTTPS/WSS 地址、密码空间配置、超时和轮询范围 |
| `INVALID_ARGUMENT` | 检查必填字符串、分页整数、会话类型、消息长度和消息序号 |
| `NOT_AUTHENTICATED` | 先密码登录或提交有效 IM 凭证 |
| `CREDENTIALS_EXPIRED` | 从可信后端取得未来有效期的 IM 凭证 |
| `AUTH_EXTERNAL_IDENTITY_MISMATCH` | 凭证身份/空间不匹配，停止沿用该凭证并修正后端取票 |
| `AUTH_CONTEXT_REQUIRED` | 固定企业配置或服务端空间与期望不一致 |
| `SESSION_CHANGED` | 请求属于已失效的旧账号周期，丢弃该结果，不向新账号回写 |
| `CONVERSATION_NOT_FOUND` | 会话不存在或当前账号无权访问，刷新列表 |
| `INVALID_RESPONSE` | 服务响应不符合约定，检查服务版本与后端响应格式 |
| `REQUEST_TIMEOUT` | 请求超时；消息结果不明时先确认持久化，重试同一操作须复用 ID |
| `NETWORK_ERROR` | 检查网络、CORS、代理及证书；不要据此立即清除账号 |
| `SDK_ERROR` | 通用失败，保留通用提示并检查调用流程 |

服务端业务码也可能透出为 `code`；没有可接受的业务码时使用 `HTTP_<状态码>`。验证码类业务码应引导请求验证码并重试登录；权限拒绝应由后端账号/会话权限处理，不能通过更换本地 ID 绕过。

## 10. 本版能力边界

本版公开数据接口及内置 UI 面向单聊/群聊文本基础能力。未提供媒体上传预览、音视频通话、推送、群管理、找回密码或完整离线消息数据库；非文本历史为占位显示。

0.1.6 本轮验证构建、35语言选择、既有六语保值、宿主显示同步及独立包消费，使用显式隔离配置与模拟响应，没有当前版本真实后端写入。0.1.5 在 2026-10-28 的双账号注册、好友及单聊/群聊记录属于历史。新增29语的Web专属文案中45条复用共享译文、101条明确英语回退；详细清单见本包 LOCALIZATION.json。Safari、实体设备、微信、生产Origin及所有法务正文35语翻译未据此完成。具体构建和独立消费证据见本包 MANIFEST.json。
