# IM SDK Web 0.1.5

面向 H5 的独立 JavaScript / TypeScript SDK，当前源码提供手机号 / 邮箱注册、账号密码登录、好友搜索 / 申请及处理、会话列表、新建群聊、单聊/群聊文本收发、历史分页和客服排队界面。注册默认自动登录个人空间；服务端返回企业登录态时直接进入企业空间，不需要选择，同时只登录一个空间。运行包包含 SignalR 浏览器依赖，不需要 Flutter 或原生桥。

0.1.5 已把现有真实 IM 服务预置到默认入口。完整 H5 包解压后双击根目录 `index.html` 即可注册或登录，无需修改配置、启动本地服务或填写服务地址。已有有效 IM 登录态时显示会话列表。

本轮交付版本为 0.1.5，包括 `IMSDK-Web-H5-0.1.5.zip` 和 `imsdk-web-0.1.5.tgz`。本版两个新测试账号通过实际默认页面进行完整真实服务验收，结果与文件摘要见完整交付包的 `MANIFEST.json`。旧 0.1.2 / 0.1.3 / 0.1.4 目录保留为历史快照。

H5 团队建议直接使用完整交付包 **IMSDK-Web-H5-0.1.5.zip**。包内 README 是交付入口，docs/ 提供接入、API 和验收说明，examples/ 提供普通 HTML、Vue 3 和 React 示例。本文件用于 npm 库包和源码工程。

## npm 接入

将交付的 npm 包放入 H5 工程 vendor/：

```sh
npm install ./vendor/imsdk-web-0.1.5.tgz
```

```ts
import { ImSdkClient, mountMessenger } from '@imsdk/web';

const client = new ImSdkClient();
client.initialize({
  apiBaseUrl: 'https://your-im-api.example.com',
  serviceRealmId: 'your-stable-realm',
  privacyConsentGranted: true,
  passwordLogin: { space: 'personal', loginType: 'lpp_id' }
});
const view = mountMessenger(client, containerElement);
// 容器需有明确高度，例如 height: 80vh; min-height: 420px。
// 组件卸载时 view.close(); await client.shutdown();
```

服务地址、环境和企业登录配置由宿主提供；已有用户输入 IM 账号密码，新用户在注册入口完成手机号 / 邮箱验证。privacyConsentGranted 应对应宿主已实际取得的用户同意。企业登录使用固定的 `{space:'tenant',loginType:'login_name',tenantCode:'YOUR_CODE'}`；个人登录默认 lpp_id。注册不携带企业或邀请码，默认进入个人空间；服务端直接返回企业登录态时进入该企业空间，同时只保留一个活跃空间。网关可选，默认沿用 API 根地址，SDK 自动追加 /ws/client。

普通 H5 加载完整交付包中的 sdk/im-sdk.js，通过全局 IMSDK 使用同一接口。API / Gateway 使用 HTTPS / WSS，正式 H5 以 HTTPS 部署，服务端需允许实际 H5 Origin、Authorization 和 Content-Type。SDK 不携带跨域 Cookie，也不持久化密码或 token。

view.close() 只关闭界面；logout() 清理当前账号；shutdown() 释放实例、请求和连接，之后需创建新实例。一个实例只有一个活跃账号/空间。外部认证用 authenticate(credentials)，必须由受信后端签发 IM 凭证，并由 profile/me 验证身份。其他系统账号的打通由后端负责。

源码新增宿主账号同步模式：初始化设置 `hostManagedAuth: true`，绑定 `HostSessionProvider` 后自动预热；会话列表入口、前台恢复和认证失败时会重新核对宿主账号，必要时静默获取 IM 凭证。宿主退出或换号通知会立即隐藏旧账号内容并废弃旧请求。该模式不展示 SDK 登录表单、登录弹窗或列表首屏转圈；同账号再次打开可先展示内存缓存。网络首次取票与列表请求仍有耗时，不能将无弹窗理解成任意网络下即时完成。接入契约见 [接入说明](handoff/docs/INTEGRATION.md#宿主账号自动同步源码新增)。现有版本化 `dist` 快照及已发布包需重新构建发布后才包含这些新增接口。

源码也支持由宿主统一管理显示设置：初始化传 `themeMode: 'system' | 'light' | 'dark'` 和 `locale`，运行中调用 `client.updatePresentation({themeMode, locale})` 即可更新现有页面。默认主题跟随系统，默认语言保持简体中文；支持简体中文、繁体中文、英语、日语、韩语和越南语，`locale: 'system'` 跟随浏览器语言。更新不重新认证、不重建页面、不清空输入草稿；消息、昵称和后端内容保持原文。详见 [显示设置接入](handoff/docs/INTEGRATION.md#宿主统一管理主题和语言源码新增)。

sendText(target,text,{clientMessageId}) 的网络失败不会自动重发；结果不明确时调用方重试同一份消息应沿用同一个 clientMessageId。客服 queued / unknown 不会提前打开聊天。非文本消息只显示类型占位；媒体上传/预览、通话、推送、群管理及完整离线数据库不在此版本。

## 已验证范围

本版验证对象是随包交付的真实服务入口，直接使用 `file://` 打开；服务连接配置来自包内文件，没有测试时注入配置或模拟 API。两名新测试用户注册、自动登录、重新登录、好友申请与接受、单聊双向收发、新建双人群及群聊双向收发分别记录，并以独立身份读回确认发送者、成员和持久化。当前结论以 `MANIFEST.json` 及本轮报告为准。

实际服务验证码非必需，没有发送短信或邮件验证码。强制验证码、安全验证及企业分配仅有契约回归。0.1.5 的构建、打包与独立消费结果见根工程 `logs/web-connected-20261028/validation.json` 和完整交付包的 `MANIFEST.json`。

更新版 macOS Safari、iPhone Safari、微信、手机软键盘、真实企业分配、生产 H5 Origin 和人工客服接管未验收。2026-10-27 的 Safari 0.1.2 记录保留为历史，不自动覆盖本版。

## 源码构建

Node.js 20+，在 IMSDK 工程的 `web/` 目录或独立 Web 源码包根目录执行：

```sh
npm ci
npm run typecheck
npm run build
npm test
npm run test:browser
```

浏览器夹具检查需要已安装的 Google Chrome，不会访问真实账号。真实联调脚本仅由开发者在明确提供私有身份和核准会话后执行，不是 H5 接入的前置步骤。源码中的 handoff/ 目录存放交付说明和框架模板；它们由根工程 scripts/package_web_handoff.py 组装为独立交付包。

输出 dist/index.js、dist/index.cjs、dist/im-sdk.js、dist/types/ 及 THIRD_PARTY_NOTICES.txt。npm 包内的 `example/index.html` 同样预置本轮真实服务，可直接打开。`example/host-config.js` 只有已获授权的服务连接信息，不含账号、密码或 token。接入其他环境时仍可由宿主覆盖配置；正式宿主需取得自己的用户同意。第三方声明应随 SDK 保留。
