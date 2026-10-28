# IM SDK 最新交付包

原生版本 0.1.2，Web / H5 版本 0.1.5，更新日期 2026-10-28。

`main` 只提交当前版本的文档、样例源码、Web 成品与校验清单。iOS `binary/`、Android `maven/` 和完整 ZIP 通过对应 GitHub Release 分发，下载后解压可取得完整目录。`MANIFEST.json` 和 `SHA256SUMS` 校验的是完整交付包。历史版本见 [版本分支说明](../docs/VERSIONING.md)，机器可读的当前版本入口见 [versions.json](versions.json)。

| 平台 | 交付 ZIP | 接入入口 |
| --- | --- | --- |
| iOS | [IMSDK-iOS-0.1.2.zip](https://github.com/use032026/IMSDK/releases/download/ios-v0.1.2/IMSDK-iOS-0.1.2.zip) | [README](ios-native-0.1.2/README.md) |
| Android | [IMSDK-Android-0.1.2.zip](https://github.com/use032026/IMSDK/releases/download/android-v0.1.2/IMSDK-Android-0.1.2.zip) | [README](android-native-0.1.2/README.md) |
| Web / H5 | [IMSDK-Web-H5-0.1.5.zip](https://github.com/use032026/IMSDK/releases/download/web-v0.1.5/IMSDK-Web-H5-0.1.5.zip) | [README](web-h5-0.1.5/README.md) |

iOS / Android 0.1.2 示例也已预置同一真实服务，安装启动自动显示登录 / 注册，无需修改服务配置。Web 0.1.5 已连接现有真实服务，解压后双击 `web-h5-0.1.5/index.html` 即可注册或登录，已认证实例进入会话列表，无需修改配置。包内包含本次授权的服务连接信息，不含测试账号、密码或 token。各包包含完整库、接入/API/验收说明、MANIFEST 和 SHA256SUMS；ZIP 旁另有 .zip.sha256。此目录的 SHA256SUMS 校验以上三个最新 ZIP。

本轮 iOS UIKit / Android Java 新二进制宿主在专用模拟器验证新注册、自动登录、重新登录、两端好友发送及接受、单聊及两端分别建群的双向文本。两个新主要账号、一个已有专用好友辅助身份，单聊与两群共六条本轮新消息由原生 UI 操作，并由独立身份读取服务端确认。iOS 自身 Keychain 组配置已补齐，首次失败账号仅作诊断，修后新主要账号重新验证自动进入。实际通过项以各包 MANIFEST 为准。

iOS Debug / Release 各 35 框架，Swift / Objective-C 六组合及独立工程编译通过；Android 完整 Maven 仓库、Java / Kotlin 消费通过；Web 官方 npm 包的 ESM、CommonJS、类型及浏览器独立接入通过。

注册不选择空间，默认个人；服务端返回有效企业登录态时直接进入企业，同时只有一个活跃空间。本轮实际新账号进入个人空间，企业直返及强制验证码分支仅有契约回归；未执行实体设备、媒体、推送或新版 Safari / 微信验收。

历史包位于各平台版本分支及对应 Release。before / draft 工作备份不作为正式版本发布；当前移动源码为 0.1.2。原生本轮报告位于 ../logs/native-connected-20261028/validation.json；此前报告保存在 ../logs/unification-release-20261028/validation.json；Web 0.1.5 预接真实服务与本轮完整验收报告位于 ../logs/web-connected-20261028/validation.json。
