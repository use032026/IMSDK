# IM SDK Web 0.1.4

面向 H5 的独立 JavaScript / TypeScript SDK，当前源码提供手机号 / 邮箱注册、账号密码登录、好友搜索 / 申请及处理、会话列表、新建群聊、单聊/群聊文本收发、历史分页和客服排队界面。注册默认自动登录个人空间；服务端返回企业登录态时直接进入企业空间，不需要选择，同时只登录一个空间。运行包包含 SignalR 浏览器依赖，不需要 Flutter 或原生桥。

0.1.4 修复默认入口：打开就显示登录 / 注册，已有有效 IM 登录态则显示会话列表，不再让用户填写服务地址、环境、空间或同意开关。服务配置由宿主代码提供。

本轮交付版本为 0.1.4，包括 `IMSDK-Web-H5-0.1.4.zip` 和 `imsdk-web-0.1.4.tgz`。完整真实服务流程及当前入口增量验证的范围见完整交付包的 `MANIFEST.json`。旧 0.1.2 / 0.1.3 目录保留为历史快照。

H5 团队建议直接使用完整交付包 **IMSDK-Web-H5-0.1.4.zip**。包内 README 是交付入口，docs/ 提供接入、API 和验收说明，examples/ 提供普通 HTML、Vue 3 和 React 示例。本文件用于 npm 库包和源码工程。

## npm 接入

将交付的 npm 包放入 H5 工程 vendor/：

```sh
npm install ./vendor/imsdk-web-0.1.4.tgz
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

sendText(target,text,{clientMessageId}) 的网络失败不会自动重发；结果不明确时调用方重试同一份消息应沿用同一个 clientMessageId。客服 queued / unknown 不会提前打开聊天。非文本消息只显示类型占位；媒体上传/预览、通话、推送、群管理及完整离线数据库不在此版本。

## 已验证范围

2026-10-28：Web 0.1.3 在 Chrome 实际界面完成真实邮箱注册、自动个人登录、退出后重新登录、好友搜索 / 申请、单聊及选择好友新建双人群双向文本收发。独立移动端 / 对端读取服务端消息，核对真实发送者、群成员与持久化，回复在 SDK 页面显示。0.1.4 只调整默认入口和界面就绪处理，当前入口真实登录 / 会话列表 / 退出及接口和浏览器回归记录见本轮报告。

实际服务验证码非必需，没有发送短信或邮件验证码。强制验证码、安全验证及企业分配仅有契约回归。0.1.4 的构建、打包与独立消费结果见根工程 `logs/web-entry-20261028/validation.json` 和完整交付包的 `MANIFEST.json`。

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

输出 dist/index.js、dist/index.cjs、dist/im-sdk.js、dist/types/ 及 THIRD_PARTY_NOTICES.txt。npm 包内的 `example/index.html` 可从该 npm 包根目录通过本地 HTTP 服务打开；配置由接入方在 `example/host-config.js` 中提供。打开页面会自动显示登录 / 注册或当前账号的会话列表，用户无需填写技术配置。未配置时界面仍可查看，提交会提示服务尚未就绪。正式宿主需取得自己的用户同意并完成服务配置。第三方声明应随 SDK 保留。
