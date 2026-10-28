# 独立 SDK 宿主集成验证

日期：2026-10-27，Asia/Shanghai。SDK：0.1.0。本文前部保留原凭证接入、客服及原生生命周期验证历史；末尾追加简化聊天入口的当前验证。不同入口、平台和产物的证据分别适用。SDK 源码、资源和构建位于 IMSDK 内，原 App 未修改。

## iOS 重复打开无障碍修复与复验

本次仅修改独立 SDK 的 Swift facade、iOS 示例/测试及构建测试脚本，没有改动 Flutter 聊天领域、账号 scope/key、原项目或客服接待设置。原问题是普通关闭时解绑控制器，销毁 Flutter 原生 AX bridge，而 Dart semantics 仍为 enabled；再次绑定新控制器无法靠 true→true 状态变化重建 bridge。正确 owner 是原生引擎/控制器生命周期，不能用测试坐标或自建 AX 树掩盖。

修复为同一引擎强持有一个 FlutterViewController，普通返回只结束 UIKit 展示；每次 Dart 页面仍使用既有 presentationRevision 新建路由。shutdown/超时退休等待页面关闭完成后才解绑和销毁引擎，并清理控制器。导航栏状态每次展示重新记录。Debug/Release facade 均重新编译；Release 设备 arm64、模拟器 arm64/x86_64 的纯二进制 Swift 链接及 Objective-C 编译通过。

专用 iOS 26.5 模拟器上的新回归全部通过：

| 场景 | 展示方式 | 实际检查 |
| --- | --- | --- |
| 普通聊天 | push | 连续打开/返回 3 次；logout→重登后 1 次；shutdown→同进程新引擎后 1 次。每次当前 AX 树都有真实输入框及既有对端 reply，实际 AX 元素 tap 返回宿主 |
| 当前企业客服 | full-screen present | 同样 5 次打开；每轮真实“正在排队”、手动刷新按钮可操作、页面无刷新错误，实际“返回宿主”AX 按钮可返回 |
| 本地保护 | 普通宿主启动 | 隐私拒绝不启动引擎、未初始化/未认证禁止打开、ready 与本地初始化、shutdown；2 项测试零失败 |

测试不缓存上一轮按钮/位置，没有 app.coordinate 点击兜底。聊天原有无标签返回 Other 节点仍由当前 AX 查询识别并 element.tap；本次没有把它改成新语义控件，因此不等同于 VoiceOver 朗读与焦点顺序专项通过。普通聊天复用已有真实 reply，本轮不发新消息；后端只读复核确认该 reply 仍为最新 seq24。客服前后均为 busy / queueAcceptEnabled=false，原线程详情仍为 403 / CUSTOMER_SERVICE_DIRECT_NOT_ASSIGNED，没有 claim、坐席回复或接待设置写入。

刷新验收是用户操作和页面状态证据；按钮恢复 enabled 没有单独证明每个刷新 HTTP 请求的开始/完成，不把它写成逐请求 HTTP 追踪通过。实际排队来自打开入口的真实服务端响应，未造会话或假排队。

本次证据：

- `logs/host-ios-live-direct-20261027-135812-209007.log/.xcresult`：普通聊天 5 轮。
- `logs/host-ios-live-customer-20261027-140054-651394.log/.xcresult`：客服排队 5 轮。
- `logs/host-ios-ax-{guards,direct,customer}-summary.json`：机器可读结果；`host-ios-ax-*-attachments/` 保留截图。
- `logs/host-ios-ax-direct-second-open.png`、`host-ios-ax-customer-second-open.png`：第二次打开的实际画面。
- `logs/host-ios-ax-release-consumers.log`：Release 三架构二进制消费；`host-ios-ax-facade-{debug,release}.log`：两组原生桥接库构建。
- `logs/host-backend-ios-ax-postflight.jsonl`：接待状态、权限及现有消息只读核对。
- `logs/host-ios-ax-delivery-check.json`：最终源码/交付闭包、原项目边界及隐私检查。

本次验证结束后，按清理技能实际删除 12 个闲置的编译/索引缓存目录，估算 156.24 MiB；源码及 iOS 交付物共 3770 个文件在清理前后校验一致。Products、含动态库的混合子树、依赖和必要证据保留，专用模拟器继续运行，当前为未初始化、空凭证、未勾选同意的普通宿主页。明细见 `logs/host-ios-ax-cleanup-summary.json`。

后文三端收发和初次接入记录保留为此前验证证据，本次只重建与复验 iOS 原生生命周期。

## 本轮范围与结果

| 宿主 | 实际运行环境 | 普通聊天 | 当前企业客服 |
| --- | --- | --- | --- |
| 原生 Android Java | Pixel_7_API_35 / Android API 35 / arm64，emulator-5554；宿主仅消费 Maven 二进制 SDK | 真实认证、发出落地、对端回复入站；最终库回归返回、同引擎重开、历史可见、logout/shutdown 通过 | 真实 queued、手动查看仍排队、返回/重开、logout 通过 |
| 原生 iOS UIKit/Swift | 专用 IMSDK Integration iPhone / iPhone 17 Pro / iOS 26.5；完整 Debug 二进制库 | UI 发送及服务端保存 seq18、对端回复 seq19、UI 实际可见；最新库回归返回/同会话重开/logout/退出后拒绝打开通过 | 真实 queued、手动查看状态、返回/重开、logout/退出后拒绝打开通过 |
| Flutter 宿主 | Flutter 3.41.9 / Android API 35 / arm64；通过公开 Dart API 消费独立 plugin | 最终 integration_test 真实发送、服务端保存、对端实时入站、实际返回箭头、重开保留、logout 全部通过 | 最终 integration_test 真实 queued、手动查看、返回/重开、logout 全部通过 |

普通消息的测试对端使用另一个已授权账号的真实 HTTP 接口收取/回复；没有模拟服务器或注入假消息。发送方必须先在服务端查到本次唯一 marker，随后对端实际回复并在 SDK 页面出现，才记为双向通过。本地乐观气泡不算送达。原生最终回归复用已落地的真实回复，避免反复制造测试消息；首次收发证据与最终生命周期证据分别保留。

用户明确要求保持客服“忙碌、关闭接待”。本轮没有修改接待、角色、企业或权限设置。真实客服请求返回 queued，并存在真实 conversationId；SDK 仍显示排队，不把有会话 ID 当成已接待。返回的坐席不属于提供的四个账号，给定客服查询此线程详情得到 HTTP 403 / CUSTOMER_SERVICE_DIRECT_NOT_ASSIGNED；这是详情读取拒绝，未执行 claim，也不能写成 claim 被拒绝。人工接管和人工回复不在本次已通过范围内。

## 真实入口与使用方式

- 当前企业客服：`ImSdkCustomerServiceRequest.currentTenant()`；原生参数 `{"entry":"currentTenant"}`。调用既有 `POST /api/client/v1/official-account/contact-service`，由已认证企业决定服务账号。
- 指定品牌：必须提供真实 serviceAccountId。officialUserId 是用户投影 ID，不可替代服务实体 ID；两个入口不自动回退。
- `requestCustomerService` 返回 `ImSdkCustomerServiceSession`，保留 threadId、status、可空 conversationId 及服务端提供的坐席信息。
- `ImSdkCustomerServiceView` 显示真实排队，只有 active 且真实 thread/conversation 完整时才进入聊天。无会话时不拿 threadId 造聊天 ID。查看状态只由按钮触发，不自动轮询，不调用坐席或管理员接口。
- 原 `contactCustomerService` 保留签名；不能返回聊天目标时，queued 报 SERVICE_QUEUED，未知/缺失会话报 SERVICE_NOT_READY。

账号验证由真正接受当前 bearer 的 profile/me 与同一已认证租户票据的身份声明相互绑定；不以宿主自行提交的平台 ID 作兜底。logout 是 SDK 本地退出和凭证清理，服务端票据撤销仍属于宿主后端。

## 本轮发现并修复的问题

| 问题 | 正确 owner 与修复 | 验证 |
| --- | --- | --- |
| profile/me 未返回平台 ID，最初封装拒绝真实账号 | SDK Auth 数据适配器：服务端认证成功后，将票据的 user claim 与 profile.userId 绑定，再提取平台 claim；不信任宿主自称身份 | 身份适配及既有外部会话 9 项测试、三宿主真实认证 |
| iOS engine 尚未 run 就安装 channel handler，初始化断言崩溃 | Swift facade：run 成功后在同一主线程安装 handler 并注册插件 | iOS ready/初始化及真实业务运行 |
| 用 Release 导出的模拟器切片启动缺 kernel_blob.bin | 构建/宿主模式 owner：模拟器使用完整 Debug 组和交付 LLDB helper；Release 设备库独立编译/链接验证 | Debug 真正启动；Release 三架构消费检查 |
| Android logout 调用已禁用的 App 专用推送通道 | SDK DI：只有 SDK 实际支持移动推送时才注入 AndroidPushSession；没有吞 MissingPluginException 冒充停推成功 | Android 能力边界单测、最终原生/Flutter logout |
| 返回检测监听 delegate 却读取另一路由通知源，漏掉根路径 | SDK ChatView 读取 RouterDelegate 当前配置 | 三宿主实际箭头返回 |
| cached engine 跳过关闭的 null 帧，同会话重开复用旧 router | Native presentation owner 每次成功 open 使用新 presentationRevision，保留账号 sessionRevision 隔离 | Android/iOS 同引擎重开实际截图/断言 |
| Debug 实时已读事件缺 Riverpod scoped dependency 声明 | Gateway Provider 声明 officialReceptionThreadProvider 依赖，不改事件归约/账本/数据 owner | 最终 Flutter 实时收发和已读事件无该断言 |
| 客服标识混用、queued 有会话即被当可聊天 | 分开品牌 DTO.threadStatus 与当前企业 Handoff.status；统一 Session.canOpenConversation，新增排队 View | 入口/状态/空 ID/账号 fence Widget 测试和三宿主真实排队 |
| 示例事件覆盖操作结果、长 JSON 键盘输入被截断 | 示例 owner 分开操作/事件状态；仅 Debug 测试输入经 App 私有文件白名单读取后删除，凭证交接成功后清空 | 示例实际运行和私有输入删除证据 |

全部修复发生在 SDK 镜像和 SDK 示例中；本轮未改变原项目代码、原项目 scope/key、数据库结构或服务端合同，也未创建新账号、好友关系或额外企业。

## 证据索引

完整日志/截图保存在本机 IMSDK/logs，不打入源码归档；私有凭证和原始发现响应保存在 owner-only 的 .work/runtime-private，不进入源码/二进制交付物。

| 证据 | 文件 |
| --- | --- |
| 最终 SDK 46 项定向测试全部通过 | logs/host-sdk-final-contract-tests.jsonl |
| Flutter 启动/同意/未登录/无效地址门禁通过 | logs/host-flutter-runtime-smoke-passed.log |
| Flutter 真实两流程 | logs/host-flutter-live-direct-result.json、host-flutter-live-customer-result.json；相同前缀 .log/.png；带时间戳的日志保留各轮尝试 |
| Android 最终 20 步，无失败 | logs/host-android-final-results.json、host-android-final-logcat.txt |
| Android 普通/排队同引擎重开 | logs/host-android-final-direct-same-engine-reopened.png、host-android-final-customer-same-engine-reopened-queued.png |
| iOS 实际收发及后端关联 | logs/host-ios-direct-reply-verified.png、host-backend-peer-ios-direct-20261027T113949.jsonl |
| iOS 最终普通生命周期 | logs/host-ios-live-direct-20261027-122357.log/.xcresult |
| iOS 最终客服生命周期 | logs/host-ios-live-customer-20261027-122733.log/.xcresult |
| iOS 汇总、交付一致性 | logs/host-ios-runtime-summary.json、host-ios-final-artifact-consistency.json |
| iOS 最终排队、当前空白宿主表单 | logs/host-ios-final-06-live-customer-queued-after-manual-refresh.png、host-ios-final-native-form.png |
| 最终 Release 纯二进制 Swift 链接/ObjC 编译 | logs/host-ios-release-consumers-delivery.log；设备 arm64、模拟器 arm64/x86_64 |
| 真实排队与权限边界 | logs/host-backend-customer-current-tenant-contact.jsonl、host-backend-customer-thread-detail.jsonl |
| 原项目工作区边界 | logs/host-original-mobile-status.txt：main 下仍是任务前七个已有修改/未跟踪路径 |

公开 SDK 入口/相关测试分析无 error/warning，保留既有风格 info；Flutter 宿主及 integration_test 分析也只有风格 info。早期测试驱动的输入/选择器错误、旧二进制失败、网络未完成尝试保留为历史证据，不当作最终通过结果，也不把无法重现的临时失败宣称为已证明代码根因。

打包检查发现初次镜像保留了未公开 App 登录页的快捷测试账号列表和默认密码文案，已仅在 SDK 副本清空列表、改为宿主提供凭证的本地化文案并重新生成。独立性检查新增防止快捷账号数据回流的门禁。此收尾不改任何已验证的 SDK 业务/页面流程；数据剔除后重新构建业务库与示例、核对产物并启动空表单，不重复制造后端测试消息。未公开登录页空 DTO 的 unused 可选参数警告保留在专门分析日志，未为消警告添加假账号或扩大重构。

## 当前交付与运行现场

- Android：dist/android/maven，及 dist/android/example/im-sdk-native-host-debug.apk。
- iOS：dist/ios/Release、dist/ios/Debug，各完整 35 个 XCFramework；dist/ios/example/IMSDKHost.app 为模拟器示例。
- Flutter：dist/flutter/im_sdk_source_0.1.0.tar.gz；dist/flutter/example/im-sdk-flutter-host-debug.apk 为正常 main 入口示例，不是测试 runner。
- Android 模拟器保留；原生示例已退出 SDK，Flutter 正常示例保留运行，未自动登录。专用 iOS 模拟器 E1FC412D-DA84-4A6E-9330-9F6CE0320BE7 保留运行，普通启动的原生表单无账号/凭证、隐私开关关闭。
- dist 各平台 SHA256SUMS、SOURCE_MANIFEST.json 在最终归档后重新生成。后续可单独移动 SDK 并重新检查源码闭包，不读取原 App。

## 明确未覆盖与责任

| 后续项 | 责任与本轮边界 |
| --- | --- |
| 人工客服接管/回复 | 当前 assignee 在授权账号之外；需提供该坐席的测试身份或另一个明确可接入的测试线程后继续。保持既有 busy/停接，不越权接管 |
| 指定品牌入口真实运行 | 未取得真实服务实体 ID；本轮只做 DTO 字段/字符串状态合同测试。合同将 threadStatus 标 short 却无权威数值表，数字/未知值继续 fail closed，不猜 0/1 |
| iOS 无障碍专项范围 | 重复打开 AX 节点缺失已修复，以上新回归移除了坐标兜底；VoiceOver 实际朗读、焦点顺序、动态字体和物理设备仍需专项 |
| 设备、媒体、推送、性能 | 本轮是模拟器和文本链路；真机媒体/权限、APNs/厂商通知、后台/弱网长时恢复、包体/启动/内存、最低系统及现有宿主插件共存仍需专项。无生产签名、IPA/商店上传或远程发布 |
| 服务端与宿主身份 | 宿主后端维护用户映射、取票/撤销策略；SDK 不实现第三方 SSO，不将平台/用户/管理员令牌混用 |
| SDK 后续维护 | SDK 研发审阅原项目变化后显式同步镜像、更新版本和锁文件；宿主研发按明确 SDK 版本回归。镜像不会自动跟随原 App |

收尾实际删除 1045 个未使用的构建中间目录，估算约 1989.8 MiB（约 1.94 GiB）。清理前后 734 个当时的源码文件、3846 个当时的交付文件及原项目七个已有改动文件校验一致；模拟器和已安装示例保留。含框架/安装包的混合子树、依赖、私有输入及必要证据保留，未清全局缓存。最后仅调整源码归档排除规则，进一步剔除机器生成的插件依赖映射，再生成最终归档与校验清单；不触发业务重测。明细见 logs/host-cleanup-applied.json、host-cleanup-summary.json。


## 简化聊天入口：原生 iOS 重新打包验证

2026-10-27，使用 Flutter 3.41.9 重建 Debug App.xcframework、原生调用层和 UIKit 示例，在 IMSDK Integration iPhone（iPhone 17 Pro / iOS 26.5）安装并通过界面操作验证。本节交付为 iOS 模拟器 App；iOS Release 组未因本次验证而重建，Android 后续验证见下一节。

- 正常入口：同意后显示账号密码登录，没有 URL、凭证 JSON 或会话 ID 表单。
- 显式个人空间：两个非客服平台账号通过真实密码登录，直接显示真实会话列表；无需企业成员身份。企业模式仍使用固定企业上下文。
- 单聊：SDK 界面发送精确测试标记，独立对端确认真实发送者、消息 ID 和序号后回复；回复入库并显示在 SDK。
- 群聊：界面创建仅含这两个账号的新群，发送测试标记；对端核对群所有者及完整双成员名单后回复，回复入库并显示在 SDK。
- 关闭并重新打开聊天模块：回到同一账号的会话列表，无需再次输入凭证。
- SDK 回归测试：64 项通过；个人空间行为测试证明企业建议和历史记录不能覆盖显式个人范围。
- 选人成员行：长名称和身份标签限制宽度，重新运行后无原有溢出条纹。

为验证建立了这两个指定测试账号的好友关系，并保留测试群及测试消息供体验；未更改角色、青少年模式、接待配置或群权限策略。先前企业账号的建群限制是真实服务端策略，未作绕过。

构建与收发证据保存在开发目录 logs/messenger-ios-20261027/、logs/messenger-ios-personal-peer-validation.json 和 logs/messenger-ios-personal-backend-summary-20261027.json；这些开发证据不随源码包分发。可运行示例为 dist/ios/example/IMSDKHost.app，压缩包为 dist/ios/example/IMSDKHost-messenger-simulator-20261027.zip。截图证明页面与消息显示，独立服务端证据证明消息持久化；本次未作真机、媒体、通知或性能验收。

## 简化聊天入口：原生 Android 重新打包与界面验证

2026-10-27，使用 Flutter 3.41.9 从最新 SDK 源码重建 Release AAR 完整 Maven 依赖仓库、Android 原生调用层和纯 Java Debug 示例。交付路径为 `dist/android/maven/` 与 `dist/android/example/im-sdk-native-host-debug.apk`；Debug 示例使用开发签名，不是生产发行包。

本次新建专用 `IMSDK_UI_20261027` 模拟器，Android API 35 / arm64，设备标识 `emulator-5556`，在 Android Studio 的 Running Devices 中可见。原有 `emulator-5554` 及 iOS 模拟器保持运行。

- 通过普通用户界面输入账号和密码完成真实登录，直接进入会话列表；用户无需填写服务地址、凭证 JSON 或会话 ID。
- 会话列表只提供关闭与新聊天操作，没有退出账号或“更多”弹出菜单。
- 已打开与管理员的单聊和双成员测试群，真实历史消息可见。
- 界面发出的单聊 `android1` 与群聊 `android2` 均由独立对端核验真实发送者、消息 ID 和会话序号，服务端均持久化为 seq3。对端指定回复均持久化为 seq4；单聊网络重试沿用同一幂等键，持久化回复仅一条。
- 最终 APK 从正常入口重新输入账号密码登录后，单聊页面显示 `ANDROID-DIRECT-REPLY-20261027`，群聊页面显示 `ANDROID-GROUP-REPLY-20261027`，分别对应上述源端消息；两页均已保存截图。随后通过界面返回会话列表，右上角只有新聊天，无退出入口。
- 对端核验同时确认双方身份、单聊参与者及测试群精确双成员名单。本轮未通过辅助脚本代替源端发送，也未新建群或改动成员、权限。
- 含安全区布局补丁的最终 Java 宿主已重建、重装；入口页截图已保存并复核。arm64-v8a、armeabi-v7a、x86_64 三种 ABI 的 AAR→合并→剥离→APK 打包链检查已刷新。

本次构建日志为 `logs/android-ui-aar-offline-20261027.log`、`logs/android-ui-native-20261027.log` 和 `logs/android-ui-host-final-20261027.log`；最终产物检查记录为 `logs/android-ui-artifact-audit-20261027.json`，APK SHA-256 为 `fd8a15a51215a15a726e3af634c14b1421ccea6cefad1358c853b3ebb8013ccd`。后端核验报告为 `logs/android-ui-peer-validation-20261027.json`。截图保存在 `logs/android-ui-20261027/`：`01-login-empty.png`、`02-conversations.png`、`03-direct-roundtrip.png`、`04-group-roundtrip.png`、`05-host-insets-final.png`、`06-conversations-final.png`，分别记录登录、列表、单聊回复、群聊回复、宿主安全区和最终列表。

Android Studio 独立 Running Devices 窗口的点击问题已通过恢复默认停靠布局排除，后续界面验收均已完成，没有修改或再次构建安装包，最终 hash 不变。当前最终 App 停留在会话列表，`emulator-5556` 继续运行，供后续体验与检查。

收尾清理了 80 个本任务已确认可再生的精确中间目录，共 266,964,992 字节（约 267 MB / 255 MiB）；2,300 个受保护文件校验未变。SDK/Maven/APK/AOT 产物、依赖和运行中的 Android/iOS 模拟器均保留。清理明细见 `logs/android-ui-cleanup-summary-20261027.json` 及同前缀的范围、占用、预览和实际删除记录。

其他 App 账户映射仍需服务端接通；本轮模拟器界面验证不覆盖 Android 真机、媒体、通知、后台恢复、性能或生产发布。
