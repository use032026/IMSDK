# 构建与交付

本轮版本为原生 / Flutter **0.1.1**、Web **0.1.5**。源码真实服务注册、好友、会话及单 / 群聊流程与退出 / 立即释放增量验证通过；新二进制独立消费及 iOS / Android 专用模拟器宿主登录、已有单群历史显示与退出释放亦通过。具体构建、运行和真机边界分别记录，见交付包 MANIFEST 和 `logs/unification-release-20261028/validation.json`。

## 自包含边界

源码、资源、平台适配、模块入口和宿主样例均位于 IMSDK 内，路径依赖只指向本目录内的 `packages/im_sdk`。构建不读取原 App checkout、签名配置、JPush/厂商私有参数或其应用身份。

自包含源码交付仍需已安装的 Flutter 3.41.9、Android SDK/JDK/Gradle、iOS Xcode/CocoaPods 及公开依赖。它不包含整份开发工具链或全局 Pub/Maven/CocoaPods 缓存。已构建原生 SDK 须连同完整依赖一起交付，不能只复制单个 App.framework 或 AAR。

## 依赖与本地化

`packages/im_sdk/pubspec.yaml` 的原有直接依赖按导出时 `pubspec.lock` 中的实际版本固定；各入口保留锁文件。不要在本次接入中顺带升级 Flutter、WebRTC、媒体、数据库或其他插件。

运行：

```sh
./scripts/resolve_dependencies.sh
```

脚本依次解析 SDK、module 和 Flutter 样例，默认离线并强制锁文件，生成 SDK 自己的本地化代码，并配置本次 module 的生成 wrapper。缺少缓存时，先记录缺项；允许联网后显式使用 `--online`，不要删除锁文件规避冲突。

`prepare_module.py` 只配置 `module/.android` 与 `module/.ios` 生成内容：Android Java API desugaring 使用 2.1.5；iOS 最低版本为 15.0、Swift 5.0，并去掉生成工程可能带入的开发团队。module/Podfile.lock 保存实际原生依赖锁，生成 wrapper 缺少锁文件时恢复。原 App、平台插件和用户宿主工程不在其修改范围。

## Android

```sh
./scripts/build_android.sh release
# 需要调试交付物时：
./scripts/build_android.sh debug
# 需要全部构建类型时：
./scripts/build_android.sh all
```

构建使用 `module/lib/main.dart`，AAR Maven 版本取 SDK pubspec 的版本。Flutter 中间产物位于 `module/build/sdk-aar/host/outputs/repo`，成功后复制完整仓库到 `dist/android/maven` 并写 `dist/android/SHA256SUMS`。构建日志保存在 `logs/android-*.log`。

接入方须使用对应构建类型的 Maven 坐标，并保留生成 POM 指定的 Flutter/插件/Android 原生依赖。架构、最低 Android 版本、R8、Java desugaring、媒体权限及宿主导航需要用真实宿主验证。脚本不包含商店签名、厂商 push 参数或 APK 上传步骤。

继续生成原生 Kotlin/Java 公开调用层和纯 Java 宿主：

```sh
cd native/android
./gradlew publishReleasePublicationToMavenRepository --console=plain
./gradlew -p example :app:assembleDebug --console=plain
```

设置本机 `JAVA_HOME`（支持 Java 17+）和 `ANDROID_HOME`。原生调用层坐标为 `com.imsdk:im-sdk-native:0.1.1`，依赖 module 坐标 `com.startlink.im_sdk_module:flutter_release:0.1.1`。示例 APK 在 `native/android/example/app/build/outputs/apk/debug/app-debug.apk`；交付时复制到 `dist/android/example` 后重新计算 Android 校验清单。当前基线 minSdk 24、compileSdk 36、desugar 2.1.5。

## iOS

```sh
./scripts/build_ios.sh release
python3 scripts/build_ios_facade.py --mode Release
python3 scripts/verify_ios_consumers.py
./scripts/build_ios.sh debug
python3 scripts/build_ios_facade.py --mode Debug
python3 scripts/write_checksums.py dist/ios
```

使用锁定工具链的 `flutter build ios-framework`，输出在 `dist/ios/<构建类型>`。脚本补齐 Flutter 导出未包含的 vendored WebRTC，按设备和模拟器的 hook 输出生成 objective_c.xcframework，避免把模拟器 native asset 嵌入真机。其后单独编译 IMSDKNative 原生 facade。完整模式导出会替换该模式目录，所以必须在每次导出后再构建 facade。

当前工具链的模拟器使用 debug/JIT bundle；Release 模式导出的模拟器 App 不含运行所需的 kernel_blob.bin。模拟器运行必须用完整 Debug 组及交付的 flutter_lldbinit/相邻 helper，不能把 Release 的编译/链接通过当作模拟器可运行。Release 的设备及两种模拟器架构仅做二进制消费编译/链接；本轮实际 iOS 运行使用 Debug、iOS 26.5。详见 native/ios/example/README.md。

完整原生 iOS 示例（没有 Flutter 源码或 podhelper 依赖）：

```sh
IMSDK_IOS_FRAMEWORK_MODE=Debug ./scripts/build_ios_host_example.sh build
IMSDK_IOS_FRAMEWORK_MODE=Debug IMSDK_IOS_SIMULATOR_UDID=<专用模拟器> \
  ./scripts/build_ios_host_example.sh test
```

产物为 dist/ios/example/IMSDKHost.app，默认中间目录为 native/ios/example/build/DerivedData。构建脚本与 live runner 均支持 `--derived-data <任务目录>`（或 `IMSDK_IOS_HOST_DERIVED_DATA`），用于本轮独立缓存；构建时加 `--no-copy` 可先验证再更新交付示例。真实票据用 scripts/run_ios_host_live_test.py / stage_ios_host_private_input.py 运行时注入 App 私有 tmp，不进入项目或二进制；XCTest 重装更换容器时按当前容器重新 stage，禁止引用旧的绝对沙盒路径。

`verify_ios_consumers.py` 对设备 arm64、模拟器 arm64/x86_64 执行纯二进制 Swift 链接与 Objective-C 编译，并输出 `dist/ios/INTEGRATION.json`。接入方按此清单区分静态框架仅链接与动态框架 Embed & Sign。第三方声明保存在 `dist/ios/THIRD_PARTY_NOTICES.plist`。真实设备签名、Bundle ID、APNs 和宿主通知代理归宿主所有，不由此构建写入。

不要将不同 Flutter 构建类型的 App/Flutter/插件框架混装。先在普通原生宿主验证完整依赖，再接入真实宿主。构建 Framework 本身不证明推送、联系客服、权限和恢复已通过真机验收。

## 独立性检查

```sh
python3 scripts/verify_independence.py
```

检查本地 path 依赖、lib 导入、声明资源、原生 plugin 入口、符号链接和生成包映射。原 App checkout 不得作为运行时依赖；Flutter 工具链和公开包缓存的正常路径不因此被误判。该检查不会读取原 App，也不访问服务端或运行构建。源码归档前会自动执行。

## Flutter/source SDK 归档

```sh
./scripts/package_flutter.sh
```

归档包含 `packages`、`module`、`native`、`examples`、`scripts`、`docs`、可用的 `test`、根 README 和工具链版本；保留 lib、assets、原生平台源码及依赖锁。归档按文件逐项计算并验证 SHA256，输出：

- `dist/flutter/im_sdk_source_<版本>.tar.gz`
- `dist/flutter/SOURCE_MANIFEST.json`
- `dist/flutter/SHA256SUMS`

包内根目录为 IMSDK。机器专用路径文件、构建缓存、`.dart_tool`、生成 `.android/.ios`、Pods、日志、`.idea/.iml`、签名材料和私有配置不会进入源码归档。原生生成 wrapper 可由固定 Flutter 版本和 module 源码重新生成。完整源码归档在所有并行修改结束后再执行，避免交付半成品。

## 组装版本化交付包

先保存旧交付目录，再生成新版本，禁止混装不同版本的框架或 Maven 制品。版本来自 `packages/im_sdk/pubspec.yaml` 与 `web/package.json`；原生 facade、module、样例依赖和 npm lockfile 须同步。

原生验证使用 `logs/unification-release-20261028/validation.json`；Web 0.1.5 预接真实服务及两个新账号完整业务验证使用 `logs/web-connected-20261028/validation.json`，分别记录真实服务检查、源码摘要、各平台构建 / 消费结果及二进制摘要。组装器要求完整真实服务门槛已通过，且当前运行时代码与已验证源码一致、交付二进制与已验证消费输入一致；Web 同时绑定根入口、聊天 HTML 和已预置的服务配置文件摘要。

```sh
python3 scripts/generate_native_handoff_samples.py
python3 scripts/package_native_handoff.py prepare --platform all
# 对 prepare 后的新版本独立工程完成实际消费验证，再填写平台结果。
python3 scripts/verify_native_handoff_ios.py --package dist/ios-native-0.1.1
python3 scripts/package_native_handoff.py finalize --platform all --validation-report logs/unification-release-20261028/validation.json
python3 scripts/package_web_handoff.py --validation-report logs/web-connected-20261028/validation.json
```

目标输出为 `dist/IMSDK-iOS-0.1.1.zip`、`dist/IMSDK-Android-0.1.1.zip` 和 `dist/IMSDK-Web-H5-0.1.5.zip`。先核对 `MANIFEST.json`、包内 `SHA256SUMS` 与 ZIP 外部校验值，再交付。真实账号、运行时输入、原始响应及开发日志不加入包中。

## 验证及清理

Web 独立构建与打包：`./scripts/build_web.sh`。内部使用 `web/package-lock.json` 安装固定依赖、检查类型、打包浏览器/ESM/CommonJS、运行接口测试，并将产物和仅含 Web 白名单文件的源码归档写入 `dist/web`。浏览器夹具检查另执行 `(cd web && npm run test:browser)`，需要已安装 Google Chrome。已存在的 `dist/web` 会被保护，重打包前先另存旧交付目录。未发布公共 npm 或线上站点。

先保存日志、失败诊断和交付副本，再清理确认不再被使用的本任务中间目录。`dist` 为持久交付物，`logs` 为必要证据，锁文件、依赖与签名不得按构建缓存删除。脚本不自动清空全局共享缓存，也不自动终止用户的 IDE 或其他构建进程。
