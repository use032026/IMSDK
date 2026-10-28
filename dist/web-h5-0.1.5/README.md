# IM SDK Web / H5 交付包

SDK **0.1.5** · 文档整理日期 **2026-10-28**

本版默认入口已预置现有真实 IM 服务。解压后直接双击根目录 `index.html`，即可注册或登录，无需手动修改配置。已认证的宿主实例直接显示会话列表。注册不选择空间：默认进入个人空间，服务端返回有效企业登录态时进入该企业，同时只保留一个活跃空间。

把整个压缩包交给 H5 团队即可。SDK 提供注册 / 登录、好友搜索 / 申请及选择、会话列表、单聊/群聊文本收发、历史分页和客服排队界面；也可通过 TypeScript API 自行实现界面。

## 从这里开始

1. 直接打开 [聊天入口](index.html)，新用户注册，已有用户输入 IM 账号密码登录。
2. 登录后从会话列表添加好友、发起单聊或选择好友新建群聊。
3. 将 SDK 嵌入其他 H5 工程时，普通网页使用 `sdk/im-sdk.js`，Vue / React / TypeScript 工程安装 `npm/imsdk-web-0.1.5.tgz`；按 [接入说明](docs/INTEGRATION.md) 使用或覆盖服务配置。

已有用户在 SDK 界面输入 IM 账号和密码，新用户可注册；好友与会话操作均在 SDK 内完成。包内包含本次授权的真实服务连接信息，不包含测试账号、密码或 token。

## 文件索引

| 路径 | 用途 |
| --- | --- |
| [index.html](index.html) | 解压后双击即打开已连接真实服务的聊天页 |
| `sdk/im-sdk.js` | 普通 `<script>` 全量包，包含 SignalR 浏览器依赖 |
| `sdk/index.js` / `sdk/index.cjs` / `sdk/types/` | ESM / CommonJS / TypeScript 声明 |
| `sdk/THIRD_PARTY_NOTICES.txt` | 第三方声明，随 SDK 保留 |
| `npm/imsdk-web-0.1.5.tgz` | 本地 npm 安装包，未发布公共 npm registry |
| [普通 HTML 示例](examples/plain-html/index.html) | 自动进入登录 / 会话列表的聊天页面 |
| [Vue 示例](examples/vue/ImChat.vue) | Vue 3 生命周期挂载模板 |
| [React 示例](examples/react/ImChat.tsx) | React hooks 生命周期挂载模板 |
| [接入说明](docs/INTEGRATION.md) | 最小接入、配置、认证、跨域及排错 |
| [API 参考](docs/API.md) | 方法、类型、事件与错误处理 |
| [接入验收](docs/ACCEPTANCE.md) | 可执行检查项、已验证和未验证范围 |
| `MANIFEST.json` / `SHA256SUMS` | SDK 版本、JS 校验值和包内文件校验 |

## 打开 HTML 示例

保留完整解压目录，直接双击根目录 `index.html`，或打开 `examples/plain-html/index.html`。默认服务已配置，可立即注册、登录和聊天。无需安装 Flutter、Xcode、Android 或 Node.js。

也可按需要在**解压后的交付包根目录**运行：

```sh
python3 -m http.server 8080 --bind 127.0.0.1
```

然后访问 `http://127.0.0.1:8080/`。两种打开方式都使用包内 `examples/plain-html/host-config.js` 的现有真实服务配置。最终用户只填写账号信息。正式 H5 部署仍使用 HTTPS，并为正式页面配置服务端 Origin。

## npm 工程安装

工程的 npm 安装环境需要 **Node.js 20+**（与包内 `engines` 一致）。普通 `<script>` 接入不需要 Node.js。把交付包中的 `.tgz` 放入 H5 工程，例如 `vendor/`，然后执行：

```sh
npm install ./vendor/imsdk-web-0.1.5.tgz
```

```ts
import { ImSdkClient, mountMessenger } from '@imsdk/web';

const client = new ImSdkClient();
client.initialize({
  apiBaseUrl: 'https://your-im-api.example.com',
  serviceRealmId: 'your-stable-realm',
  privacyConsentGranted: true, // 对应宿主已经实际取得的同意
  passwordLogin: { space: 'personal', loginType: 'lpp_id' }
});
const view = mountMessenger(client, document.getElementById('chat')!);
// 容器需有明确高度，建议 height: 80vh; min-height: 420px。
// 组件卸载：view.close(); await client.shutdown();
```

## 当前验收范围

本版从实际默认页面直接连接真实服务进行新账号注册、登录、好友申请与接受、单聊和新建双人群的双向文本收发。使用两个新测试账号及唯一消息标记，独立身份读回核对发送者、群成员和持久化；没有借用旧消息替代本轮收发。本版真实验收、构建、独立消费与文件摘要见 `MANIFEST.json`。

本轮服务端验证码非必需，没有发送短信 / 邮件验证码。强制验证码、安全验证及企业分配只有契约回归；真实企业分配、更新版 Safari、微信、手机软键盘和生产 H5 域名均未据此验收。2026-10-27 的旧版 Safari 结果仅为历史。

媒体上传 / 预览、音视频通话、推送、群管理和完整离线数据库不在本版 Web 能力范围。接入方按 [接入验收](docs/ACCEPTANCE.md) 验证实际投放环境。
