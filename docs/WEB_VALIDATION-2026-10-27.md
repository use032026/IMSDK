# Web / H5 SDK 验证记录 · 2026-10-27

当前交付为 **0.1.2**。macOS Safari 26.6.2 真实登录与单群双向收发、兼容修复及尚未完成的微信/iPhone 范围见 [浏览器兼容验证](WEB_BROWSER_COMPATIBILITY-2026-10-27.md)。以下保留0.1.1及0.1.0的历史证据。

## 真实服务追加验收（当前交付 0.1.1）

2026-10-27 18:34（Asia/Shanghai）已使用现有 IM 服务和此前联调的两个个人测试账号，在真实 Chrome 中完成登录、单聊与群聊双向收发。未拦截请求、模拟后端响应或关闭浏览器安全校验。复用了既有单聊和已核准的精确双成员测试群，未新建群、添加成员或更改权限。

| 验证项 | 真实结果 |
| --- | --- |
| 密码登录 | 从 Web 登录表单提交；平台登录、个人空间选择、profile/me 均 HTTP 200；实际用户/平台身份匹配 |
| 浏览器跨域 | 实际 Origin `http://127.0.0.1:58754`，服务端允许该 Origin；不是生产 H5 域名验收 |
| SignalR | 真实 negotiate / WebSocket 连接成功，观测到两条 `msg.new`；未使用网络夹具 |
| 单聊 | Web UI 发送唯一标记，独立对端读回确认一条；发送 seq12、回复 seq13 均持久化，回复出现在 Web 界面 |
| 群聊 | 先核对群 owner 与精确双成员名单，再从 Web UI 发送；发送 seq5、回复 seq6 均由独立对端读回确认，回复出现在 Web 界面 |
| 关闭/重开、退出及释放 | 同页重开仍有会话；退出回到登录页，最终释放浏览器、连接与本地验证服务 |
| 回归 | 修复后31项接口回归通过，原 Chrome 桌面/手机宽度协议夹具流程仍通过 |

本次原始结果为 `logs/web-live-20261027/roundtrip/report.json`，精简结果为 `summary.json`；截图为 `roundtrip/direct-roundtrip.png`、`roundtrip/group-roundtrip.png`。登录前探测的错误证据保留在 `probe/report.json`，未发送消息。日志不保存密码、token、认证请求体或 WebSocket 查询参数。

真实联调发现并修复：服务端接受的个人 JWT 使用 `space_type: "1"`，同时保留一个内部 `tenant_id` 占位值；0.1.0 错把后者与 `personal` 比较而拒绝登录。0.1.1 先让 profile/me 接受 bearer 并绑定 JWT subject，显式 profile 空间优先，缺失时才用已绑定的 `space_type` 识别个人空间。新增5项回归覆盖个人字符串/数字类型、企业空间拒绝、subject 不匹配拒绝及显式空间优先。

双向收发证据由“独立对端持久化读回”和“浏览器实际显示”共同构成。测试把页面轮询设为5分钟，回复在数秒内显示；网关有真实消息事件，但本轮保存的事件摘要未逐条关联回复 ID，因此不扩大表述为逐条实时事件因果验证。退出时仍在途的群已读/会话列表读取被取消，未完成已读状态的独立服务端验收；没有完成的 HTTP 错误响应。

最终 `dist/web` 更新为 0.1.1，压缩包 `im_sdk_web_0.1.1.zip`、npm 包 `imsdk-web-0.1.1.tgz`。交付 JS 与真实联调使用的 JS 字节一致，SHA-256 为 `4581fa85ed03d0d6b989b108c35c32f4f1075a8d36b8ffdcd5b25007c2576a2c`。旧0.1.0包保留在 `dist/web-before-real-validation-20261027`。

拆包后的 ESM / CommonJS 与类型声明消费、15项交付校验和、源码白名单及账号/密码排除检查均通过，证据为 `logs/web-live-20261027/delivery-check.log`。真实验证浏览器和本地服务均已退出，预览后实际删除本次 `.codex-build/web-live-package-20261027`，约348 KiB（356,352字节估算）；1,308个受保护源文件、依赖和交付文件在清理前后哈希一致，报告为 `cleanup-apply.json` / `cleanup-verification.json`。其余原生缓存、依赖和交付快照保留。

待验收范围仍包括生产 H5 Origin、Safari / 微信真机、企业账号登录、人工客服接管、媒体/通话/推送、离线与性能。下面保留0.1.0初始夹具验收记录作为历史。

## 交付结果

新增独立 `web/` TypeScript 工程，复用现有 IM REST / SignalR 协议，保持现有 Flutter、iOS 和 Android 实现。普通 H5 可加载全量 `im-sdk.js`；工程接入可安装 `imsdk-web-0.1.0.tgz` 并取得 ESM / CommonJS 与类型声明。根工程目前不是 Git checkout，本次未执行提交或推送。

当前能力包括账号密码登录、个人/固定企业空间、验证码、外部 IM 凭证验证、好友选择发起单聊、分页会话/历史、单群文本收发、已读提交、网关实时刷新、断线重连、客服排队门禁、关闭重开、退出及释放。凭证仅保存在实例内存中，不内置真实账号或服务配置。

交付位置：

- `dist/web/im_sdk_web_0.1.0.zip`：可交接的完整 Web 包。
- `dist/web/im-sdk.js`：含 SignalR 的独立 script 包。
- `dist/web/index.js`、`index.cjs`、`types/`：ESM / CommonJS 和类型声明。
- `dist/web/imsdk-web-0.1.0.tgz`：本地 npm 安装包，未发布公共 registry。
- `dist/web/im_sdk_web_source_0.1.0.tar.gz`：含 lockfile 的独立 Web 源码归档。
- `dist/web/example/index.html`：只由宿主填写开发配置，无内置业务账号。
- `dist/web/SHA256SUMS`：15个交付文件校验；已逐项重新计算一致。

`dist/web-draft-before-review-20261027` 与 `dist/web-draft-before-contacts-20261027` 为本任务先前打包快照，最终接入使用 `dist/web`。

## 验证证据

| 验证 | 结果 | 证据 |
| --- | --- | --- |
| TypeScript strict 类型检查 | 通过 | `logs/web-sdk-20261027/typecheck.log` |
| 浏览器 / ESM / CommonJS 构建及声明生成 | 通过 | `logs/web-sdk-20261027/build.log` |
| Node 接口合约回归 | 26项全部通过 | `logs/web-sdk-20261027/unit-tests.log` |
| Chrome 浏览器业务流程夹具 | 1280×900、390×844两个视口通过 | `logs/web-sdk-20261027/browser-report.json`、`browser-tests.log` |
| npm 拆包后 ESM 导入、CommonJS main 消费 | 无外部运行时文件仍通过 | `logs/web-sdk-20261027/package-consumer.log` |
| 拆包后类型声明消费编译 | 通过 | 同上；检查源码保存为 `package-types-check.mts` |
| 源码归档白名单与交付副本一致性 | 无 node_modules / 私有配置 / logs 混入，构建副本完全一致 | 同上 |
| 清理前后保护校验 | 1,306个源文件、依赖和交付文件哈希不变 | `cleanup-protected-before.json`、`cleanup-verification.json` |

Chrome 使用已安装版本 `156.0.8078.48`。两个视口均验证：开发示例配置、密码登录、SignalR 握手、会话列表、真实好友列表选择、单聊/群聊文本发送、文本按纯文字呈现以防 XSS、网络失败复用发送 ID、网关触发 REST 更新、撤回隐藏原文且保留草稿、断线重连、关闭重开、安全事件清屏、退出、客服排队禁止打开消息页、释放及无未处理浏览器错误。截图为 `chat-1280.png`、`chat-390.png`。

26项接口测试包含 HTTPS/隐私配置、服务端身份绑定、账号/实例隔离、个人和两种企业登录路由、验证码、401单次重试及并发刷新、临时网络失败保留账号、注销废弃旧请求、单群路径、分页参数、发送上下文及幂等 ID、两种客服状态字段、正文格式、撤回隐藏、身份切换立即失效、刷新拒绝身份变化和超时错误脱敏。

浏览器夹具模拟了 REST 与真实 SignalR JavaScript 客户端的服务端响应，并未连接实际业务服务或使用真实账号。没有把浏览器构建、协议夹具或手机宽度截图视作线上、真机或真实跨域验收。

## 审查修复

独立审查后已修复账号切换时旧界面残留、撤回显示原文、较早历史失效、正文空白被裁剪、刷新间隔未生效，以及消息刷新重建输入框造成草稿丢失。浏览器测试增加撤回时保留草稿、网关重连和安全退出验证。发起单聊使用好友选择，不要求用户填写内部用户 ID。

## 待接入验收

- 目标 H5 的真实 Origin、API CORS、网关 negotiate / WebSocket 鉴权和反向代理策略。
- 真实个人/企业账号、目标服务端版本、真实群权限、真实双端消息收发及人工客服接管。
- Safari / iOS WebView / 微信内置浏览器、真实软键盘、安全区、弱网及页面挂起恢复。
- 媒体上传/预览、音视频通话、推送、群管理、离线数据库和跨端持久游标同步不在此基础 Web 版本。
- 此次未部署网站、发布 npm 或重新构建移动端交付物。

## 清理

构建输出直接写入需保留的 `web/dist` 和 `dist/web`，依赖保留在 `web/node_modules`。浏览器验证进程已正常结束。确认无文件占用后，按 `post-build-cleanup` 技能先预览再删除本次拆包验证目录 `.codex-build/web-package-20261027`，约 **1.02 MiB**（脚本估算1,069,056字节）。实际删除和保护校验均通过；其他任务的 iOS / Android 缓存和仍在运行的原生模拟器未操作。
