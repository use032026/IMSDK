# IM SDK Web 0.1.6

面向 H5 的独立 JavaScript / TypeScript SDK，当前源码提供手机号 / 邮箱注册、账号密码登录、好友搜索 / 申请及处理、会话列表、新建群聊、单聊/群聊文本收发、历史分页和客服排队界面。注册默认自动登录个人空间；服务端返回企业登录态时直接进入企业空间，不需要选择，同时只登录一个空间。运行包包含 SignalR 浏览器依赖，不需要 Flutter 或原生桥。

默认入口保留既有服务连接配置。完整 H5 包解压后双击根目录 `index.html` 可进入登录 / 注册，已认证宿主实例可进入会话列表；本轮验收使用隔离配置与模拟响应，没有向真实后端注册账号或发送消息。

本轮本地交付版本为 **0.1.6**，包括 `IMSDK-Web-H5-0.1.6.zip` 和 `imsdk-web-0.1.6.tgz`，纳入公共语言资源包 0.3.0 的 35 种语言选择、宿主显示同步与登录态同步。构建、语言切换及独立消费以完整包 `MANIFEST.json` 为准；没有提交、推送或远程发布。旧 0.1.5 的真实双账号业务验收仅为历史，不替代本版验收。

H5 团队建议直接使用完整交付包 **IMSDK-Web-H5-0.1.6.zip**。包内 README 是交付入口，docs/ 提供接入、API 和验收说明，examples/ 提供普通 HTML、Vue 3 和 React 示例。本文件用于 npm 库包和源码工程。

## npm 接入

将交付的 npm 包放入 H5 工程 vendor/：

```sh
npm install ./vendor/imsdk-web-0.1.6.tgz
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

0.1.6 包含宿主账号同步模式：初始化设置 `hostManagedAuth: true`，绑定 `HostSessionProvider` 后自动预热；会话列表入口、前台恢复和认证失败时会重新核对宿主账号，必要时静默获取 IM 凭证。宿主退出或换号通知会立即隐藏旧账号内容并废弃旧请求。该模式不展示 SDK 登录表单、登录弹窗或列表首屏转圈；同账号再次打开可先展示内存缓存。网络首次取票与列表请求仍有耗时，不能将无弹窗理解成任意网络下即时完成。接入契约见 [接入说明](handoff/docs/INTEGRATION.md#宿主账号自动同步源码新增)。旧 0.1.5 快照及已发布包保持原样；本次 0.1.6 为独立本地新包。

SDK 支持由宿主统一管理显示设置：初始化传 `themeMode: 'system' | 'light' | 'dark'` 和 `locale`，运行中调用 `client.updatePresentation({themeMode, locale})` 更新现有页面。默认主题跟随系统，默认语言保持简体中文；35 个可选语言标识见包内 `LOCALIZATION.json`（IIFE 交付中为 `sdk/LOCALIZATION.json`）。新 29 语中 45 个 SDK Web 文案复用已有共享译文，101 个 SDK 特有文案明确沿用既有英语；并非全部文案已完成 35 语翻译。更新不重新认证、不重建页面、不清空草稿，用户消息和昵称保持原文。

sendText(target,text,{clientMessageId}) 的网络失败不会自动重发；结果不明确时调用方重试同一份消息应沿用同一个 clientMessageId。客服 queued / unknown 不会提前打开聊天。非文本消息只显示类型占位；媒体上传/预览、通话、推送、群管理及完整离线数据库不在此版本。

## 已验证范围

0.1.6 本轮范围是 TypeScript、IIFE / ESM / CommonJS、35 语言与区域别名、既有六语保值、宿主显示状态及独立 npm / 浏览器消费。浏览器通过显式隔离连接配置与模拟后端验证，未进行当前版本真实注册、登录、好友或消息写入。

0.1.5 在 2026-10-28 运行过真实双账号注册、好友及单聊 / 群聊流程；相关记录位于历史交付包及根工程 `logs/web-connected-20261028/`。该历史结果没有被改成 0.1.6 的当前版本结论。强制验证码、审核、实际企业分配及本版真实后端联调仍需单独验收。

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

浏览器夹具检查需要已安装的 Google Chrome，不会访问真实账号。真实联调脚本仅由开发者在明确提供私有身份和核准会话后执行，不是 H5 接入的前置步骤。源码中的 handoff/ 目录存放交付说明和框架模板；0.1.6 的本地语言扩展交付由根工程 scripts/package_localization_handoff.py 组装；历史完整业务交付保留原有严格实服验收入口。

输出 dist/index.js、dist/index.cjs、dist/im-sdk.js、dist/types/ 及 THIRD_PARTY_NOTICES.txt；本次打包附加 dist/LOCALIZATION.json 覆盖说明。npm 包内的 `example/index.html` 同样保留既有获授权服务配置，可直接打开。`example/host-config.js` 只有已获授权的服务连接信息，不含账号、密码或 token。接入其他环境时仍可由宿主覆盖配置；正式宿主需取得自己的用户同意。第三方声明应随 SDK 保留。
