# Web / H5 IM SDK 0.1.1

独立的 TypeScript SDK，提供可嵌入 H5 的账号密码登录、会话列表、单聊/群聊文本聊天界面。与 iOS / Android SDK 使用同一套 IM 服务协议，无需 Flutter、原生桥或前端框架。也可只调用数据接口，自行实现 UI。

## 普通 H5 接入

交付目录 `dist/web` 中的 `im-sdk.js` 已包含 SignalR 浏览器依赖，可由宿主自己的静态资源服务加载。SDK 不访问公共 CDN，不自动上传或发布。

```html
<div id="im-chat" style="height: 80dvh; min-height: 420px"></div>
<script src="/your-assets/im-sdk.js"></script>
<script>
  const im = new IMSDK.ImSdkClient();
  // 由宿主提供配置；用户只在 SDK 页面输入账号密码。
  im.initialize({
    apiBaseUrl: 'https://your-im-api.example.com',
    gatewayBaseUrl: 'https://your-im-gateway.example.com', // 可选，默认同 API
    serviceRealmId: 'your-stable-service-realm',
    privacyConsentGranted: true, // 对应宿主已实际取得的用户同意
    passwordLogin: { space: 'personal', loginType: 'lpp_id' }
  });
  let view = IMSDK.mountMessenger(im, document.getElementById('im-chat'));
  // view.close();                 // 关闭界面，保留本页账号和连接
  // view = IMSDK.mountMessenger(im, container); // 重开
  // await im.logout();            // 退出账号并立即清空 SDK 界面
  // await im.shutdown();          // 不再使用整个 SDK 时释放实例
</script>
```

实际接入时替换示例域名。网关配置服务根地址，SDK 自动追加 `/ws/client`，支持 HTTPS / WSS；API 只支持 HTTPS。地址不能带用户名、密码、查询参数或片段。API 根地址带路径时，SDK 在该路径后追加 `/api/...`。

企业空间使用 `passwordLogin: {space: 'tenant', loginType: 'login_name', tenantCode: 'YOUR_TENANT_CODE'}`；企业内的平台账号登录使用 `loginType: 'lpp_id'`，SDK 只选择企业列表中与固定企业码精确匹配的空间。企业码由接入方配置，后端负责企业成员资格和会话权限校验。未配置 passwordLogin 时默认个人空间 lpp_id。

## npm / TypeScript / Vue / React

将交付的 npm 包安装到 H5 工程；目前没有发布到公共 npm registry：

```sh
npm install ./imsdk-web-0.1.1.tgz
```

```ts
import { ImSdkClient, mountMessenger, ImSdkError } from '@imsdk/web';
const im = new ImSdkClient();
im.initialize({
  apiBaseUrl: 'https://your-im-api.example.com',
  serviceRealmId: 'your-stable-service-realm',
  privacyConsentGranted: true
});
const unsubscribe = im.on(event => {
  if (event.type === 'authenticationRequired') { /* 恢复正确账号或重新登录 */ }
});
const view = mountMessenger(im, containerElement);
// 组件卸载先 view.close()；整个宿主会话结束时 unsubscribe(); await im.shutdown();
```

React effect / Vue onMounted 中挂载；不要在 React 渲染或服务端渲染阶段调用 DOM 接口。一个实例只有一个活跃账号/空间；多个实例的凭证和请求相互隔离。建议一个实例挂载一个聊天界面。

## 公开接口

| 方法 | 用途 |
| --- | --- |
| `initialize(config)` | 验证配置；同实例不能更换配置，释放后创建新实例 |
| `loginWithPassword({account,password,captchaToken?,captchaAnswer?})` | 密码登录并验证服务端身份 |
| `requestLoginCaptcha()` | 返回 `{token,question}`，界面支持按需验证 |
| `authenticate(credentials)` | 接受受信宿主后端签发的 IM 凭证，先验证 `profile/me` |
| `listConversations({cursor?,limit?})` | `{items,nextCursor?}`，默认50条，最多100条 |
| `getConversation(conversationId)` | 从服务端分页列表解析会话和实际类型 |
| `createDirectConversation(peerUserId)` | 创建有权联系的用户的单聊 |
| `listContacts()` | 取得当前账号好友；内置界面通过联系人选择发起单聊 |
| `listMessages(target,{beforeSeq?,limit?})` | 历史按序号升序返回；非文本显示类型占位 |
| `sendText(target,text,{clientMessageId?})` | 发送文本，返回补全上下文后的服务端确认消息 |
| `markRead(target,seq)` | 提交已经实际阅读的消息序号 |
| `requestCustomerService(request)` | 返回真实排队/接入状态 |
| `on(listener)` | 监听事件，返回取消监听函数 |
| `logout()` / `shutdown()` | 本地退出 / 释放实例、连接、请求和界面 |

`target` 形式为 `{conversationId: '真实会话ID', type: 'direct' | 'group', title?: '显示名'}`。`view.openConversation(target)` 会先解析服务端类型；服务端权限始终为最终依据。

```ts
const page = await im.listConversations();
const target = page.items[0];
if (target) {
  const history = await im.listMessages(target);
  // 用户发送时调用；结果不明后重试须复用同一个 ID。
  const clientMessageId = crypto.randomUUID();
  const sent = await im.sendText(target, '你好', { clientMessageId });
}
```

SDK 不自动重发网络失败的消息。内置界面对同一会话的同一份未修改草稿重试时复用 ID；编辑草稿、关闭或切换聊天会创建新的发送操作。服务端需按 `clientMsgId` 去重。HTTP 401 合并刷新请求并最多重试一次，刷新身份变化时拒绝激活；暂时的网络错误保留会话供重试。

外部凭证必填 `platformUserId,userId,spaceId,accessToken,refreshToken,expiresAt`，`expiresAt` 为未来的 ISO 8601 时间；可选 `platformToken,platformRefreshToken,deviceSessionToken`。其他 App 账号的打通、IM 凭证签发和服务端 token 撤销由后端负责。不要把服务端密钥或其他业务系统 token 当作 IM accessToken。SDK 默认不写 localStorage、sessionStorage、Cookie 或 IndexedDB；刷新页面后由宿主恢复登录，或重新输入账号密码。

## 客服

```ts
const session = await view.openCustomerService({serviceAccountId: '真实品牌服务账号ID'});
// 企业当前客服：await view.openCustomerService({entry: 'currentTenant'});
```

品牌接口使用 `threadStatus`，当前企业接口使用 `status`。`queued` / `unknown` 显示排队或未接入状态；即使有 `conversationId` 也不可提前进入。只有 `active` 且有真实会话 ID 时才能打开。`threadId`、服务账号 ID、官方用户投影 ID 和会话 ID 不可互换。当前客服状态通过按钮重查，网关分配事件会提示更新。

## 实时与部署

SignalR 处理消息更新、会话删除、客服分配及安全退出事件；事件触发 REST 重取，断线和初次连接失败都会重试。可见的列表/聊天页每15秒补取快照，回前台也补取。`pollIntervalMs` 可配5000–300000毫秒；`realtime:false` 可关闭网关。`requestTimeoutMs` 默认30000毫秒，可配100–300000。关闭界面清理界面计时器；退出/释放终止请求和网关。`shutdown` 后实例不可重用。

宿主接入配置：

- H5 以 HTTPS 部署，API 和网关允许实际 H5 Origin；客户端不能绕过 CORS。
- REST 允许 GET/POST/OPTIONS 和 `Authorization,Content-Type` 请求头；SDK 不携带跨域 Cookie。
- negotiate 和 WebSocket 路径可达，网关按浏览器协议接受 token；服务端日志隐藏 `access_token`。
- CSP 允许 SDK 脚本及服务的 `connect-src https://… wss://…`；Shadow DOM 内置样式需要被宿主样式策略允许。
- 不依赖后台页面常驻；微信内置浏览器、Safari / iOS WebView、软键盘和真实跨域策略应在目标 H5 环境验收。

基础实现使用 Fetch、AbortController、Web Crypto、Shadow DOM、ES2020。已验证安装的 Chrome 中1280px与390px视口，不代表 iPhone / 微信真机验证。宿主容器提供高度，最小420px。

当前范围是文本聊天、会话/历史分页、已读提交及客服状态。图片/文件/音视频消息显示占位；媒体上传预览、音视频通话、推送、注册/找回密码、群管理、离线数据库和跨端持久游标同步未加入这个 Web 版本。较早历史未收到通知的跨端修改可能需要重进聊天取得；收到更新/撤回通知会废弃旧历史视图。

事件包括 `ready,sessionChanging,authenticated,authenticationFailed,loggedOut,authenticationRequired,connectionChanged,conversationsChanged,messagesChanged,conversationDeleted,customerServiceChanged,shutdown`。连接事件带 `state`；消息事件可带 `conversationId` / `reset`。事件不含原始凭证或完整后端数据。宿主不要记录密码、token 或认证请求。

## 构建验证

Node.js 20+：

```sh
cd web
npm ci
npm run typecheck
npm run build
npm test
npm run test:browser # 已安装 Google Chrome；协议夹具，无真实账号
python3 -m http.server 8080 --bind 127.0.0.1
# 打开 http://127.0.0.1:8080/example/
```

`dist/index.js` 为 ESM，`dist/index.cjs` 为 CommonJS，`dist/im-sdk.js` 为普通 script 全量包，`dist/types/` 为类型声明。构建不依赖原 App 或其他工程。根工程执行 `./scripts/build_web.sh` 可生成独立交付包；源码归档只含 Web 白名单文件。

2026-10-27 已追加真实服务联调：Chrome 中通过账号密码登录、既有单聊与双成员群各一组双向文本收发，独立对端确认消息持久化，回复在 Web 界面显示；真实 SignalR 已连接并观测到消息事件。本机 H5 Origin 的 REST / negotiate 跨域请求通过，未拦截请求或绕过浏览器安全策略。0.1.1 修复真实个人 JWT 的 `space_type: "1"` 被误判为企业空间的问题，补齐到31项接口回归。

验证记录见根工程 `docs/WEB_VALIDATION-2026-10-27.md`；实时联调脚本为 `scripts/verify-live.mjs`，必须显式提供私有账号及已核准会话文件，真实请求会发送带唯一标记的测试消息。凭证文件和真实服务配置不随 SDK 分发。实际生产 H5 域名、人工客服接管、Safari / 微信真机和线上发布仍待验收。
