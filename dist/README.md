# IM SDK 最新交付包

iOS / Android / Flutter **0.1.3**，Web / H5 **0.1.6**；公共语言资源 **0.3.0**，35 种语言。构建与验收日期 2026-10-29，远程发布日期 2026-10-30。

| 平台 | 完整交付 | 接入资料 |
| --- | --- | --- |
| iOS | [IMSDK-iOS-0.1.3.zip](https://github.com/use032026/IMSDK/releases/download/ios-v0.1.3/IMSDK-iOS-0.1.3.zip) | [README](ios-native-0.1.3/README.md) |
| Android | [IMSDK-Android-0.1.3.zip](https://github.com/use032026/IMSDK/releases/download/android-v0.1.3/IMSDK-Android-0.1.3.zip) | [README](android-native-0.1.3/README.md) |
| Web / H5 | [IMSDK-Web-H5-0.1.6.zip](https://github.com/use032026/IMSDK/releases/download/web-v0.1.6/IMSDK-Web-H5-0.1.6.zip) | [README](web-h5-0.1.6/README.md) |
| Flutter / 源码 | [版本源码归档](https://github.com/use032026/IMSDK/archive/refs/tags/flutter-v0.1.3.tar.gz) | [接入说明](../docs/FLUTTER_INTEGRATION.md) |

Git 只保留当前版接入资料、样例源码、语言清单与 Web 成品。原生 `binary/`、`maven/` 和完整 ZIP 从 Release 获取；旧版本由对应平台分支和 Release 保留。下载索引见 [versions.json](versions.json)，最新三个 ZIP 的摘要见 [SHA256SUMS](SHA256SUMS)。

本轮范围为 `localization-rebuild`：35 种语言、每语 1040 个公共词条、资源与包内清单一致，独立二进制消费和逐文件校验通过。SDK / Web 专属缺译明确回退英语；法律正文沿用原选择和回退策略。详见 [35 语言交付与验证范围](../docs/L10N35_DELIVERY-2026-10-29.md)。

iOS 验证覆盖六组 Swift / ObjC 消费及 UIKit 模拟器、未签名设备编译；Android 覆盖独立 Maven 宿主、Java / Kotlin 编译和三 ABI 符号剥离复现；Web 覆盖 35 语隔离浏览器与 npm ESM / CJS / 类型消费。原生宿主未运行，本版没有真实后端、实体设备或生产业务验收；旧版实服报告不代表本版通过。

`MANIFEST.json` / 包内 `SHA256SUMS` 对应完整 Release 包，不能对省略原生二进制的 Git 目录直接宣称全包校验通过。包内远程发布字段记录打包时状态；当前远程状态见本索引与对应 Release。服务连接配置沿用已授权公开的内容，不包含测试账号或 token。
