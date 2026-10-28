# IM SDK Web / H5 交付包

SDK **0.1.3** · 文档整理日期 **2026-10-28**

本版统一注册 / 登录、好友搜索 / 申请及处理、会话列表和单聊 / 新建群聊。注册不选择空间：默认进入个人空间，服务端返回有效企业登录态时进入该企业，同时只保留一个活跃空间。

把整个压缩包交给 H5 团队即可。SDK 提供注册 / 登录、好友搜索 / 申请及选择、会话列表、单聊/群聊文本收发、历史分页和客服排队界面；也可通过 TypeScript API 自行实现界面。

## 从这里开始

1. 先确认接入方提供的 IM API / Gateway 地址、稳定环境标识、个人或企业空间配置，以及正式 H5 域名的跨域白名单。
2. 普通 H5 使用 `sdk/im-sdk.js`；Vue / React / TypeScript 工程安装 `npm/imsdk-web-0.1.3.tgz`。
3. 按 [接入说明](docs/INTEGRATION.md) 完成初始化和界面挂载，再按 [接入验收](docs/ACCEPTANCE.md) 检查登录与消息收发。

已有用户在 SDK 界面输入 IM 账号和密码，新用户可注册；好友与会话操作均在 SDK 内完成，服务配置由接入方提供。示例不包含真实服务地址、账号、密码或 token。

## 文件索引

| 路径 | 用途 |
| --- | --- |
| `sdk/im-sdk.js` | 普通 `<script>` 全量包，包含 SignalR 浏览器依赖 |
| `sdk/index.js` / `sdk/index.cjs` / `sdk/types/` | ESM / CommonJS / TypeScript 声明 |
| `sdk/THIRD_PARTY_NOTICES.txt` | 第三方声明，随 SDK 保留 |
| `npm/imsdk-web-0.1.3.tgz` | 本地 npm 安装包，未发布公共 npm registry |
| [普通 HTML 示例](examples/plain-html/index.html) | 可直接通过本地 HTTP 服务打开的配置和聊天示例 |
| [Vue 示例](examples/vue/ImChat.vue) | Vue 3 生命周期挂载模板 |
| [React 示例](examples/react/ImChat.tsx) | React hooks 生命周期挂载模板 |
| [接入说明](docs/INTEGRATION.md) | 最小接入、配置、认证、跨域及排错 |
| [API 参考](docs/API.md) | 方法、类型、事件与错误处理 |
| [接入验收](docs/ACCEPTANCE.md) | 可执行检查项、已验证和未验证范围 |
| `MANIFEST.json` / `SHA256SUMS` | SDK 版本、JS 校验值和包内文件校验 |

## 打开 HTML 示例

在**解压后的交付包根目录**运行：

```sh
python3 -m http.server 8080 --bind 127.0.0.1
```

浏览器访问 `http://127.0.0.1:8080/examples/plain-html/`，填入接入方确认的 HTTPS 服务地址和环境标识。正式页面以 HTTPS 部署，并在服务端允许正式页面 Origin。本地示例不需要 Flutter、Xcode 或 Android 工具链。

## npm 工程安装

工程的 npm 安装环境需要 **Node.js 20+**（与包内 `engines` 一致）。普通 `<script>` 接入不需要 Node.js。把交付包中的 `.tgz` 放入 H5 工程，例如 `vendor/`，然后执行：

```sh
npm install ./vendor/imsdk-web-0.1.3.tgz
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

当前 Web 源码已在 Chrome 实际界面通过真实邮箱注册、自动个人登录、重新登录、好友搜索 / 申请、会话列表、单聊及新建双人群双向文本收发；独立对端确认真实发送者、成员及消息持久化，并核对页面回复。50 项接口回归及桌面 / 窄屏模拟接口流程通过。本版构建、独立消费与文件摘要见 `MANIFEST.json`。

本轮服务端验证码非必需，没有发送短信 / 邮件验证码。强制验证码、安全验证及企业分配只有契约回归；真实企业分配、更新版 Safari、微信、手机软键盘和生产 H5 域名均未据此验收。2026-10-27 的旧版 Safari 结果仅为历史。

媒体上传 / 预览、音视频通话、推送、群管理和完整离线数据库不在本版 Web 能力范围。接入方按 [接入验收](docs/ACCEPTANCE.md) 验证实际投放环境。
