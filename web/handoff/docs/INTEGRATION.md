# Web SDK 0.1.5 接入说明

文档整理日期：2026-10-28。本文面向 H5 接入方，普通网页、Vue 和 React 均可使用。SDK 已编译，使用交付文件无需 Flutter 或原生 iOS / Android 工具链。

## 直接使用现有真实服务

完整交付包已预置现有真实 IM 服务。保留完整解压目录，双击根目录 `index.html` 即可注册或登录；用户不需要修改配置，也不需要启动本地服务。普通网页示例和 npm 包内的 `example/index.html` 使用同一份连接配置。

配置只包含本次授权的服务地址、环境标识及个人登录方式，不包含账号、密码、token 或服务端密钥。注册及登录仍由真实服务验证，注册无需选择空间。双击打开的真实服务支持情况以本版 `MANIFEST.json` 的实际验收为准。

## 接入其他环境或宿主应用

由接入方与 IM 服务端确认下列信息，再让最终用户在聊天界面注册或输入账号密码：

1. IM API 根地址及网关根地址。
2. 稳定的服务环境标识 `serviceRealmId`。
3. 个人空间或固定企业空间；企业模式还需企业码。
4. 实际 H5 域名的跨域、反向代理和 CSP 配置。
5. 宿主已实际取得的用户同意，以及可用于联调的授权账号、联系人和群。

默认入口附带本次授权的真实服务连接配置；接入其他环境时可由宿主覆盖。SDK 不附带测试账号、密码或凭证。其他应用账号与 IM 账号的映射、凭证签发、群成员及会话权限由后端负责。

## 方式一：普通 HTML / script

把 `sdk/im-sdk.js` 放入 H5 工程自己的静态资源目录。该文件已包含 SignalR 浏览器依赖，无需再引用 CDN 或单独加载 SignalR。

```html
<div id="chat" style="height: 80vh; min-height: 420px"></div>
<script src="/assets/im-sdk.js"></script>
<script>
  const client = new IMSDK.ImSdkClient();
  client.initialize({
    apiBaseUrl: 'https://your-im-api.example.com',
    serviceRealmId: 'your-stable-service-realm',
    privacyConsentGranted: true,
    passwordLogin: { space: 'personal', loginType: 'lpp_id' }
  });

  let view = IMSDK.mountMessenger(client, document.getElementById('chat'));
  // 界面内完成账号密码登录、会话选择和单聊 / 群聊。
</script>
```

`/assets/im-sdk.js` 是宿主部署后的资源路径，需要按项目实际目录调整；示例域名也需要替换。传入 `privacyConsentGranted: true` 须对应宿主已实际取得的同意。

交付包中的 [普通网页示例](../examples/plain-html/index.html) 已连接本轮真实服务，直接双击即可使用。也可按部署需要在**解压后的交付包根目录**启动静态服务：

```sh
python3 -m http.server 8080 --bind 127.0.0.1
```

然后打开 `http://127.0.0.1:8080/`。页面自动打开登录 / 注册页，已有有效 IM 会话时显示会话列表，没有配置表单或空间选择。默认连接信息位于 `examples/plain-html/host-config.js`；使用现有服务无需编辑该文件。该示例脚本路径是 `../../sdk/im-sdk.js`，不能单独移动 HTML。

换用其他服务时，接入方才需要覆盖 `window.IMSDK_HOST_CONFIG`。显式设为 `null` 可关闭默认配置，界面仍显示登录 / 注册并在操作时提示服务尚未就绪。正式部署需为实际 HTTPS 页面 Origin 配置跨域访问。

宿主也可在页面启动前通过 `window.IMSDK_HOST_CLIENT` 提供已初始化或已认证的 `ImSdkClient`；页面复用它，已有登录态直接进入会话列表。异步获得配置时调用 `window.IMSDK_HOST.configure(config)`；外部实例由宿主负责最终释放。示例不会从 URL 或浏览器持久存储读取凭证。

## 方式二：npm / TypeScript

本版本以本地 npm 安装包交付，尚未发布到公共 npm registry。npm 安装环境使用 **Node.js 20+**，与包内 `engines` 一致；普通 script 接入无需 Node.js。把交付目录放入 H5 工程的 `vendor/IMSDK-Web-H5-0.1.5/` 后，在 **H5 工程根目录**执行：

```sh
npm install ./vendor/IMSDK-Web-H5-0.1.5/npm/imsdk-web-0.1.5.tgz
```

也可将命令中的路径替换为安装包的实际位置。安装后的模块名为 `@imsdk/web`，包含 ESM、CommonJS 和 TypeScript 类型声明。

```ts
import { ImSdkClient, mountMessenger, type ImSdkConfig } from '@imsdk/web';

const config: ImSdkConfig = {
  apiBaseUrl: 'https://your-im-api.example.com',
  serviceRealmId: 'your-stable-service-realm',
  privacyConsentGranted: true,
}; // 未配置 passwordLogin 时默认个人空间 lpp_id。

const client = new ImSdkClient();
client.initialize(config);
const view = mountMessenger(client, document.getElementById('chat')!);
```

Vue / React 可参考 [Vue 组件](../examples/vue/ImChat.vue) 和 [React 组件](../examples/react/ImChat.tsx)。它们是放入既有 H5 工程的组件用法，运行环境、页面路由和业务配置由宿主提供。只在客户端组件挂载后调用 DOM 接口；不要在服务端渲染或 React 渲染函数执行阶段挂载。组件可传入 `config` 让其拥有实例，或传入 `client` 复用宿主实例；外部实例由宿主负责释放。配置对象应保持稳定，避免每次渲染都重新创建 SDK。

## 初始化配置

| 字段 | 类型 | 默认值 / 范围 | 接入约定 |
| --- | --- | --- | --- |
| `apiBaseUrl` | `string`，必填 | HTTPS 根地址 | 不含用户名、密码、查询参数或片段；SDK 在其后追加 `/api/...` |
| `gatewayBaseUrl` | `string`，可选 | 默认同 `apiBaseUrl` | HTTPS / WSS 根地址；SDK 自动追加 `/ws/client`，不要重复填写该路径 |
| `serviceRealmId` | `string`，必填 | 非空 | 由接入方为服务环境分配的稳定标识 |
| `privacyConsentGranted` | `boolean`，必填 | 必须为 `true` | 代表宿主已实际取得使用聊天服务所需的同意 |
| `passwordLogin` | 对象，可选 | 个人空间 `lpp_id` | 指定时需填写有效的 `space` 和 `loginType`，见下方配置 |
| `requestTimeoutMs` | `number`，可选 | 默认30000；100–300000毫秒 | 单次 REST 请求超时 |
| `realtime` | `boolean`，可选 | 默认启用 | 设为 `false` 可关闭 SignalR；REST 接口仍可使用 |
| `pollIntervalMs` | `number`，可选 | 默认15000；5000–300000毫秒 | 内置列表 / 聊天界面在可见时补取快照的间隔 |

个人空间：

```ts
passwordLogin: { space: 'personal', loginType: 'lpp_id' }
```

个人模式不能配置 `tenantCode`，也不能使用 `login_name`。

固定企业的企业账号登录：

```ts
passwordLogin: {
  space: 'tenant',
  loginType: 'login_name',
  tenantCode: 'YOUR_TENANT_CODE'
}
```

若使用平台账号进入指定企业，将 `loginType` 改为 `lpp_id`；SDK 只选择企业列表中与企业码精确匹配的空间。企业码由开发者固定配置，不放入最终用户登录表单。企业成员资格与登录权限仍由服务端决定。

同一实例初始化后不能变更配置，也不能重复调用 `initialize`。切换服务环境时，应释放旧实例并创建新的 `ImSdkClient`。一个实例只有一个活跃账号 / 空间，建议一个实例挂载一个聊天界面。

## 界面、账号与页面生命周期

关闭界面与退出账号是不同操作：

```ts
view.close(); // 移除当前聊天界面和界面计时器，保留本页账号及实时连接。
view = mountMessenger(client, container); // 需要时重新打开。

await client.logout(); // 宿主退出账号：清除 SDK 本地会话，已有界面回到登录页。
await client.shutdown(); // 不再使用整个实例：终止请求 / 网关并移除已挂载界面。
```

`view.close()` 可重复调用。关闭后的 view 不能继续打开会话，应重新 `mountMessenger`。`shutdown()` 后实例不可重用；需要再次接入时创建新实例。

宿主组件卸载时，至少关闭它拥有的 view。若组件同时拥有整个 SDK 实例，还应释放实例；若账号运行时由宿主上层共享管理，则由上层在账号退出或聊天模块不再使用时调用 `logout` / `shutdown`。

当前凭证仅保存在实例内存中，SDK 不写入 localStorage、sessionStorage、Cookie 或 IndexedDB。整页刷新后需要重新登录，或由宿主重新提交有效 IM 凭证。不要把页面后台连接当作常驻服务。

浏览器可能把页面冻结到返回缓存。宿主自行接管生命周期时，不要在 `pagehide.persisted === true` 时永久销毁仍需恢复的 SDK；恢复后应让界面补取快照。交付的普通网页示例已包含此处理，缓存往返会保留当前草稿。普通页面销毁时仍应释放实例。

## 使用宿主后端签发的 IM 凭证

若后端已完成账号打通，可在初始化后提交后端签发的凭证，跳过 SDK 密码表单：

```ts
import type { ImSdkCredentials } from '@imsdk/web';

async function enterWithImCredentials(credentials: ImSdkCredentials) {
  await client.authenticate(credentials);
  return mountMessenger(client, container);
}
```

示例函数的 `client` 是已经初始化的 SDK，`container` 是宿主已挂载的 DOM 容器。`credentials` 应直接来自受信宿主后端，不应由 URL 查询参数或用户手填表单拼装。

必填字段为 `platformUserId`、`userId`、`spaceId`、`accessToken`、`refreshToken`、`expiresAt`。`expiresAt` 必须是未来的 ISO 8601 时间。可选字段为 `platformToken`、`platformRefreshToken`、`deviceSessionToken`。SDK 会先用该 bearer 请求服务端资料，验证身份与空间，再激活会话。

其他业务系统的登录 token、平台管理员 token 和服务端密钥不能当作 IM accessToken。`logout()` 是客户端本地退出；后端 token 撤销仍由宿主账号系统负责。

## 需要宿主处理的事件

```ts
const unsubscribe = client.on(event => {
  if (event.type === 'authenticationRequired') {
    // 内置界面会回到登录页；宿主也应恢复正确身份或提示重新登录。
  }
  if (event.type === 'connectionChanged') {
    // 可按 event.state 更新宿主连接提示。
  }
});

// 宿主不再监听时：unsubscribe();
```

数据客户端异常可读取 `ImSdkError` 的 `code`、`message` 和可选 `status`；界面挂载失败或操作已关闭的 view 也可能抛出普通 `Error`，宿主应统一捕获。事件和异常不含完整后端响应；宿主日志也不要记录密码、token 或完整认证请求。完整接口与事件字段见 [API 参考](API.md)。

## 域名、反向代理与 CSP

- 正式 H5 使用 HTTPS，API 和网关允许实际页面 Origin。SDK 不携带跨域 Cookie，鉴权使用 bearer。
- REST 允许所需 GET / POST / OPTIONS 和 `Authorization`、`Content-Type` 请求头。跨域预检需正常返回，前端代码不能绕过服务端 CORS。
- 放通 `/api/platform/v1/...` 与 `/api/client/v1/...`。若 `apiBaseUrl` 配置路径前缀，反向代理也需对应路由该前缀后的 `/api/...`。
- 网关根地址会追加 `/ws/client`；需同时支持 negotiate 请求和 WebSocket Upgrade，避免把其返回为 H5 的 HTML 页面。按实际网关心跳与超时配置代理，服务端日志隐藏 `access_token` 查询参数。
- CSP 的 `script-src` 允许宿主加载 SDK 文件，`connect-src` 允许实际 API / 网关的 HTTPS 和 WSS 地址。保留宿主现有策略，在现有策略中合并所需来源。
- 当前内置 UI 在 Shadow DOM 内注入样式；宿主样式策略需允许该样式生效。0.1.5 没有可传入 CSP nonce 的配置项。
- 宿主提供明确容器高度，最小420px。首次接入先使用固定高度确认布局，再接入路由、抽屉或全屏容器。外层页面样式不应直接依赖 Shadow DOM 内部结构。

## 常见问题排查

| 现象 / 错误码 | 优先检查 |
| --- | --- |
| `CONSENT_REQUIRED` | 宿主完成同意流程后，再以真实结果传入配置 |
| `INVALID_CONFIG` | HTTPS / WSS 根地址、环境标识、空间与企业码组合、超时范围 |
| `CONFIG_CONFLICT` / `DISPOSED` | 是否重复初始化或复用了已经释放的实例 |
| 页面空白、聊天区过矮 | SDK 脚本路径是否200、容器是否已挂载且有高度、CSP 是否阻止脚本或样式 |
| `NETWORK_ERROR` / 请求显示跨域失败 | 实际 Origin、OPTIONS、证书、反向代理与 CSP；不要只看 API 在后端工具中是否可请求 |
| REST 正常但连接暂不可用 | `gatewayBaseUrl` 是否为根地址、negotiate / WebSocket 路径、Upgrade 及网关鉴权 |
| `REQUEST_TIMEOUT` | 服务端响应和网络；不要因发送结果不明立即创建新消息 ID 重发 |
| `AUTH_EXTERNAL_IDENTITY_MISMATCH` | 后端签发的真实用户、平台身份和空间是否与提交字段一致 |
| `AUTH_CONTEXT_REQUIRED` | 企业码是否正确、平台账号是否属于该企业；不要让前端猜测或切换到其他企业 |
| `NOT_AUTHENTICATED` / `authenticationRequired` | 恢复正确账号或重新登录；不能仅凭会话 ID 打开另一账号的聊天 |
| `SESSION_CHANGED` | 账号已切换或已退出，丢弃该旧操作结果，按当前会话重新发起 |
| `CONVERSATION_NOT_FOUND` | 服务端会话列表是否包含该会话、当前身份是否有权访问 |
| 消息发送失败后重试 | 对同一份未修改草稿复用 `clientMessageId`；内置界面已处理，数据接口调用方需自行保持该 ID |
| 客服有会话 ID 但仍排队 | 以 `status` 和 `canOpenConversation` 为准；排队状态不能提前进入聊天 |

首次部署后按 [H5 接入验收清单](ACCEPTANCE.md) 核对，不要把构建成功或本地浏览器验证直接当作正式域名、手机或微信环境已验收。
