# IM SDK 最新交付包

iOS / Android / Flutter **0.1.4**，Web / H5 **0.1.7**。公共词库 **0.3.15** 包含 35 种语言，每种 1044 个词条。

| 平台 | 完整交付 | 接入资料 |
| --- | --- | --- |
| iOS | [IMSDK-iOS-0.1.4.zip](https://github.com/use032026/IMSDK/releases/download/ios-v0.1.4/IMSDK-iOS-0.1.4.zip) | [README](ios-native-0.1.4/README.md) |
| Android | [IMSDK-Android-0.1.4.zip](https://github.com/use032026/IMSDK/releases/download/android-v0.1.4/IMSDK-Android-0.1.4.zip) | [README](android-native-0.1.4/README.md) |
| Flutter | [im_sdk_source_0.1.4.tar.gz](https://github.com/use032026/IMSDK/releases/download/flutter-v0.1.4/im_sdk_source_0.1.4.tar.gz) | [接入说明](../docs/FLUTTER_INTEGRATION.md) |
| Web / H5 | [IMSDK-Web-H5-0.1.7.zip](https://github.com/use032026/IMSDK/releases/download/web-v0.1.7/IMSDK-Web-H5-0.1.7.zip) | [README](web-h5-0.1.7/README.md) |

下载索引见 [versions.json](versions.json)，四个附件的摘要见 [SHA256SUMS](SHA256SUMS)。仓库中的原生交付目录保存接入文档、样例源码和清单。完整 XCFramework、Maven 仓库和归档从对应 Release 下载。

## 本版验收

- iOS 构建 Debug 和 Release XCFramework，验证 Swift / Objective-C 消费、设备及模拟器架构，并在 iPhone 17 Pro / iOS 26.5 模拟器运行两项离线 UIKit 测试。
- Android 构建完整 Release Maven 仓库，验证独立 Java 宿主、Java / Kotlin 接入和三种 Flutter ABI。Android API 35 arm64 模拟器断网验证首次打开、返回宿主与重开。
- Flutter 从解压后的源包解析锁定依赖，构建样例 Android Debug APK，完成 132 项 SDK 回归。另核验归档中的 889 个源码和配置文件及离线词库生成一致性。
- Web 的 64 项 Node 测试、独立 npm ESM / CJS / TypeScript 消费、Chrome 桌面与移动视口夹具、35 语切换及逐文件完整性检查通过。

本版的接入方真实后端业务、实体设备和生产环境验收待完成。各平台详情见包内清单。真实服务示例配置只含公开连接信息。
