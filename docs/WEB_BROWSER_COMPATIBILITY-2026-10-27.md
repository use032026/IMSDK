# Web SDK 浏览器兼容验证 · 2026-10-27

2026-10-28 更新：用户明确要求微信先不验证，现保留为未验收，不再以扫码登录作为当前交付前置条件。H5 接入交付已单独整理为 `dist/IMSDK-Web-H5-0.1.2.zip`，入口为包内 README。下面保留原验证环境和结果。

当前交付为 `dist/web/im_sdk_web_0.1.2.zip`。本轮 macOS Safari 的真实服务验收已完成；微信客户端未完成扫码登录，微信内置浏览器及手机 Safari 验收仍待继续。

## 实际环境与边界

| 环境 | 本轮结果 |
| --- | --- |
| macOS Safari 26.6.2（21624.5.1.11.3） | 实际 Safari 窗口登录、网关连接、既有单聊与双成员群双向收发通过 |
| Chrome 156.0.8078.48 | 原桌面/手机宽度流程及新增兼容夹具回归通过 |
| macOS 微信 4.1.9 | 客户端停在“扫码登录”；已请求用户完成登录，尚未进入真实内置浏览器 |
| iPhone Safari | WebDriver 发现的设备未开启 Web Inspector，未更改系统设置，未完成设备验证 |
| Safari 14–15 / 微信 UA 模拟 | 未将模拟 UA 或功能屏蔽测试当成真实设备验收 |

Safari 测试驱动提示需要开启远程自动化，因此改用正常 Safari 窗口打开回环联调页；未开启远程自动化、忽略证书错误、修改系统安全设置或拦截网络响应。联调页程序填值并触发 SDK 原有表单提交处理器，由 Safari 的真实 JavaScript / 网络 / DOM 实现执行。该过程不证明人工输入、手机软键盘、安全区或 iPhone WKWebView 行为。

## 修复版 Safari 真实收发

最终复验于 Asia/Shanghai 18:53–18:55 执行。继续使用此前用户提供的两个个人测试身份及已核准范围；写入前核对双方身份、既有单聊对端、群 owner 和精确双成员名单。未建群、增加成员或修改权限。

| 步骤 | 结果 |
| --- | --- |
| 密码登录 | 由 Safari 中的 SDK 表单处理器提交；服务端身份与预期一致，个人空间正常 |
| 网关 | 真实 SignalR 连接成功；页面补取轮询为5分钟，收到当前会话的消息更新通知 |
| 单聊 | 浏览器发送持久化 seq16；独立对端回复持久化 seq17，真实页面显示该唯一回复 |
| 群聊 | 浏览器发送持久化 seq9；独立对端回复持久化 seq10，真实页面显示该唯一回复 |
| 业务错误 | 最终复验报告 `passed=true`、`errors=[]` |

证据为 `logs/web-compat-20261027/safari-final/report.json`、`direct-roundtrip.png`、`group-roundtrip.png`。报告记录了实际 Safari UA，截图保留原生 Safari 窗口；没有仅凭脚本 label 判断浏览器。通知证据关联当前 conversationId，持久化证据关联唯一正文、真实发送者、消息 ID 和序号。

未修复前的0.1.1基础流程也通过，保留在 `safari-original/`。其报告另有一条测试服务器误把 favicon GET 作为非法请求的诊断，随后修正为正常404；最终复验无此诊断。它不是 IM API 错误。

## 已修复兼容问题

1. 快捷发送原来无条件调用 `form.requestSubmit()`。Safari 16 才加入该 API；现在存在则正常调用，缺失时点击原发送按钮，仍走同一提交、发送中互斥及草稿幂等 ID 逻辑。没有改用绕过监听器的 `form.submit()`。[Apple Safari 16 发布说明](https://developer.apple.com/documentation/safari-release-notes/safari-16-release-notes)
2. 示例原来在所有 `pagehide` 事件中释放 SDK，缓存恢复时却仍持有已释放实例、禁用初始化按钮。现在对 `event.persisted` 保留运行时和草稿；`pageshow.persisted` 只恢复状态并补取快照，普通离开仍释放并清引用。页面缓存语义见 [WebKit Page Cache](https://webkit.org/blog/516/webkit-page-cache-ii-the-unload-event/)。

修复后的31项接口回归通过。Chrome 两个视口中新增回归确认：屏蔽 `requestSubmit` 后 Ctrl+Enter 仍恰好提交一条消息；缓存生命周期事件后不重登、不重复连接，草稿保留且不自动发送。这里采用合成 `PageTransitionEvent` 验证生命周期合同，没有证明 Safari 实际将该页存入再恢复页面缓存。

## 尚未完成与后续入口

微信已安装，但本机当前没有已登录会话，正常登录入口转至扫码界面。证据为 `logs/web-compat-20261027/wechat-login-state.txt`。用户完成扫码登录后可继续从真实微信内置浏览器运行相同真实服务流程；现有 Safari 结果不能替代微信结果。

Safari/iOS 驱动探测证据为 `safari-driver-probe.json`、`ios-safari-driver-probe.json`。未启用远程自动化或设备 Web Inspector。手机 Safari、微信真机软键盘与连续发送、弱网/后台恢复、生产 H5 Origin 仍未验收。未依据静态推测修改键盘高度或媒体/权限流程。

本轮测试源码为 `web/scripts/native-browser-live.mjs`；只监听回环地址，使用随机页面路径、Origin 校验和一次性私有配置响应。账号、密码与 token 只在测试进程/页面内存中，不写入源码、交付包或公开报告。对端每类回复仅调用一次，网络失败不自动重发。

## 交付校验与清理

0.1.2 交付 JS 与修复版 Safari 复验完全相同，SHA-256 为 `ebc80d3ff4c2e725823f3ac92d81287c58b97d4171b8e14283c14b446c7e48af`。拆包后的 ESM / CommonJS、类型声明、15项交付校验和、归档白名单与真实账号/密码排除检查均通过，见 `logs/web-compat-20261027/delivery-check.log`。旧0.1.1交付保留在 `dist/web-before-safari-validation-20261027`。

截图保存后已关闭本次 Safari 测试标签页；只停止本任务启动的两台回环联调服务和 safaridriver，没有关闭用户其他 Safari 标签、微信或模拟器。确认无文件占用后，按 `post-build-cleanup` 预览并实际删除 `.codex-build/web-browser-compat-20261027`，约348 KiB（356,352字节估算）。1,311个源文件、依赖和交付文件清理前后哈希一致。清理证据为 `cleanup-apply.json`、`cleanup-verification.json`，依赖、截图、报告及交付物保留。
