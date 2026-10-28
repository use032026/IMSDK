# 0.1.0 验证与后续验收记录

本页保留首次库导出时的证据快照；下方“尚未验证”属于当时状态。后续真实宿主集成、修复与最新验收范围见 [HOST_VALIDATION-2026-10-27.md](HOST_VALIDATION-2026-10-27.md)。

日期：2026-10-27。目标：普通用户私聊、已登录用户联系企业客服的现成聊天页面，可由原生 Android、原生 iOS、Flutter Android/iOS App 接入。

## 已交付范围

SDK 使用独立源码镜像，公开入口、运行时、路由、原生桥接、依赖锁和资源全部位于 IMSDK。原项目保持原状；没有将其 checkout、App 启动入口、账号配置或签名作为依赖。SDK 的持久化、Secure Storage、设置及退出标记使用自己的命名空间，账号仍由已有领域 owner 管理。

调用顺序为取得用户同意 → initialize → authenticate → 打开普通聊天或联系客服 → 关闭页面／logout／dispose。身份必须由真实 IM 服务端签发并核验。SDK 冷启动不会恢复上次账号。logout 完成本地 SDK 账号和凭证清理，服务端令牌撤销由宿主后端负责。公开版本限制为一个 isolate、一个 SDK runtime、一个活跃账号/空间。

| 交付物 | 路径 | 已完成证据 |
| --- | --- | --- |
| Android 库 | dist/android/maven | Flutter Release AAR、插件 Maven 仓库及原生 facade 编译和发布到本地目录成功 |
| Android 示例 | dist/android/example/im-sdk-native-host-debug.apk | 纯 Java 宿主编译成功，不引用 Flutter 源码或 Flutter Gradle plugin |
| iOS 库 | dist/ios/Release | 完整 35 个 XCFramework，含 IMSDKNative、WebRTC 和分平台 objective_c native asset |
| iOS 消费检查 | dist/ios/INTEGRATION.json | 设备 arm64 与模拟器 arm64/x86_64：Swift 纯二进制链接、Objective-C 调用代码编译成功 |
| Flutter SDK | dist/flutter/im_sdk_source_0.1.0.tar.gz | 完整独立源码、模块、原生封装、示例、脚本、文档、文件 manifest 和 SHA256 清单 |

## 自动检查证据

- SDK 定向测试 **20 项通过**，覆盖配置与凭证、客服 HTTP 200 业务失败、客服身份 ID 分离、运行时关闭顺序、Hive/退出标记隔离、Secure Storage 定向删除、外部身份冷启动无业务网络、持久会话 CAS 和身份不符拒绝。日志：logs/sdk-tests.jsonl。
- SDK 公开入口及 SDK 测试最终静态分析无 error/warning，保留 10 条风格类 info；Flutter 宿主示例无 error/warning，保留 1 条风格类 info。测试 fixture 的未使用参数已移除，并单独复测外部身份 3 项通过。未以此声称全镜像 lint 零问题。
- 独立性脚本通过：三个 pubspec、两个目录内部 path 依赖、资源及生成包映射闭合；无原项目包引用、源码路径依赖或交付符号链接。
- 源码归档包含 711 个文件，逐文件 SHA256 校验通过；在不同临时目录解压后重新执行独立性检查通过。Android 最终 AAR 及原生 APK 均核实包含 Cupertino 图标字体。一次联网刷新依赖因仓库 TLS 握手失败，随后使用已有依赖离线构建成功，日志分别保留。
- Android 基线 Flutter 3.41.9、Java 17 字节码、minSdk 24、compileSdk 36、desugar 2.1.5；原生示例构建使用 Android Studio 内置 JDK。iOS 基线 15.0，构建工具 Xcode/SDK 26.5，Swift facade 使用 distribution interface。
- iOS 编译有 umbrella/Swift header 和工具 sysroot 警告；三个目标的链接检查均成功。没有因此宣称其他 Xcode 版本兼容。

构建及检查日志保留在 logs；dist 下各平台 SHA256SUMS 校验交付文件。Android 示例是调试签名 APK，iOS 是供宿主签名嵌入的库集合，不是可安装 IPA。

## 构建收尾

按 post-build-cleanup 流程检查文件句柄后，实际删除 123 个测试／资源／编译中间目录，估算占用约 284.9 MiB。清理前后校验 711 个源码文件及 2274 个交付文件一致，删除目标均已消失。含框架、库、安装包、必要证据的混合构建子树，以及 Pods、依赖锁、解析配置和共享缓存均保留；未停止用户进程。明细见 logs/cleanup-applied.json。

## 尚未验证

没有连接 Android 真机，没有取得本次联调的真实账号和授权会话。未进行实际宿主启动、真实服务端登录、Gateway 收发消息、客服接待、设备媒体或推送验收。没有生产写入、上传、商店签名或远程发布。匿名访客 Widget、客服坐席工作台、通话、群聊及多账号同时在线不属于本版公开入口；为保留现有聊天依赖，镜像中仍包含部分未对外开放能力和插件，体积优化留待验收后处理。

## 责任与验收顺序

以下为联调执行顺序及完成条件，不把预计工作量冒充已完成进度。每阶段过门后再进入下一阶段，失败记录由对应 owner 修复并只复测受影响项。

| 阶段／责任方 | 具体问题与处理方式 | 完成条件／当前状态 |
| --- | --- | --- |
| 1 SDK 研发：独立导出 | 镜像代码和资源；替换包路径；独立入口、路由、配置；隔离账号、Hive 与安全存储；复用原有消息库／发送队列／未读 owner | 已完成独立性检查、20 项定向测试 |
| 2 Android／iOS 研发：库闭合 | Android 保留完整 Maven/POM 和插件依赖；iOS 补齐 WebRTC、native asset 及静态注册器；提供公开原生 API 和超时清理 | 已完成库编译、Java 宿主编译、iOS 三架构消费检查 |
| 3 宿主后端／IM 后端：身份 | 明确宿主用户到 IM platformUserId/userId/spaceId 的受信映射、票据签发与失效规则；准备真实环境、账号、已授权会话、serviceAccountId；确认现有接口可用或补服务端换票能力 | 待联调；凭证不能由客户端伪造，不能把宿主自有 token 当作 IM token |
| 4 各宿主研发：接入与退出 | 按平台说明加入库；隐私同意后初始化；串行登录和开页；关闭只退页面；换账号先退出旧会话；冷启动重新取票；保留宿主导航和通知代理 | 待真实宿主运行；打开／返回／重复打开／登录失败／重新认证／退出均可恢复 |
| 5 SDK＋IM 后端＋测试：消息 | 两个账号验证历史首屏、分页、发送／失败／重试、回执、未读、撤回；断网已有本地数据可见，重连按既有 owner 补同步；跨账号／空间不串数据 | 待真实服务端及设备；消息落地、重启恢复、未读与服务端状态核对一致 |
| 6 客服后端＋产品＋测试：客服 | 核对 serviceAccountId、threadId、conversationId 的归属；覆盖排队、接入、关闭、离线与无权限；业务失败不能进入伪会话 | 待客服场景联调；状态与服务端一致，错误可理解且可重试 |
| 7 宿主研发＋测试：媒体及通知 | 真机验证拍照、图片／视频／语音／文件、拒绝权限和中断恢复；宿主配置推送、前台展示、点击后恢复正确账号／空间再开会话 | 待 Android/iPhone 真机；前后台、冷启动、拒绝权限、切换账号无泄露或误跳 |
| 8 测试＋发布负责人：候选版本 | 核对现有宿主依赖冲突、启动耗时、内存、包体、最低系统与目标系统；固定 SDK 版本及校验和；宿主签名和灰度回滚由宿主管理 | 待实测；保留设备／环境／版本／结果／问题单，修复阻塞项后才能作为发布验收通过 |

SDK 镜像后续不会自动跟随原项目变化。SDK 维护者负责审阅同步差异、更新版本和锁文件，重复独立性／定向测试及受影响平台构建；宿主负责明确升级版本并完成自己的验收。不能把原项目功能正常运行视为 SDK 已验收。
