# IM SDK Web / H5 交付包

SDK **0.1.2** · 文档整理日期 **2026-10-28**

源码更新说明：默认入口新增手机号 / 邮箱注册、好友搜索 / 申请及处理、新建群聊；注册后默认进入个人空间，服务端直接返回企业登录态时进入该企业空间，同时仅登录一个空间，与 iOS、Android 的聊天职能统一。本文件是交付模板，现存 0.1.2 ZIP 尚未包含这些更新，需重新构建并生成交付包。

把整个压缩包交给 H5 团队即可。SDK 提供账号密码登录、好友选择、会话列表、单聊/群聊文本收发、历史分页和客服排队界面；也可通过 TypeScript API 自行实现界面。

## 从这里开始

1. 先确认接入方提供的 IM API / Gateway 地址、稳定环境标识、个人或企业空间配置，以及正式 H5 域名的跨域白名单。
2. 普通 H5 使用 `sdk/im-sdk.js`；Vue / React / TypeScript 工程安装 `npm/imsdk-web-0.1.2.tgz`。
3. 按 [接入说明](docs/INTEGRATION.md) 完成初始化和界面挂载，再按 [接入验收](docs/ACCEPTANCE.md) 检查登录与消息收发。

用户在 SDK 界面只需输入 IM 账号和密码，服务配置由接入方提供。示例不包含真实服务地址、账号、密码或 token。

## 文件索引

| 路径 | 用途 |
| --- | --- |
| `sdk/im-sdk.js` | 普通 `<script>` 全量包，包含 SignalR 浏览器依赖 |
| `sdk/index.js` / `sdk/index.cjs` / `sdk/types/` | ESM / CommonJS / TypeScript 声明 |
| `sdk/THIRD_PARTY_NOTICES.txt` | 第三方声明，随 SDK 保留 |
| `npm/imsdk-web-0.1.2.tgz` | 本地 npm 安装包，未发布公共 npm registry |
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
npm install ./vendor/imsdk-web-0.1.2.tgz
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

Chrome 与 **macOS Safari 26.6.2** 已通过真实个人账号登录、单聊和双成员群双向文本收发；服务端持久化和浏览器实际显示均有核验。31 项接口回归及快捷发送、缓存生命周期兼容检查通过。

**微信本次按交付范围暂不验证，状态为未验收。** iPhone Safari、手机软键盘、生产 H5 域名、真实企业登录和人工客服接管仍需接入方验收。界面中的非文本消息显示类型占位；媒体上传/预览、音视频通话、推送、群管理和完整离线数据库不在这个版本中。

SDK 运行文件沿用已验证的0.1.2版本；本次整理交付结构和说明，没有新增真实服务测试消息。源码重建和内部验证工具另见独立源码包，不是 H5 消费接入的前置步骤。
