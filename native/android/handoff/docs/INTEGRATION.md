# Android SDK 接入说明

SDK：`0.1.1` · 更新：2026-10-28

## 1. 环境与工程要求

| 项目 | 接入基线 |
| --- | --- |
| JDK | 17 |
| Android | minSdk 24；compileSdk 36；示例 targetSdk 36 |
| 构建工具 | AGP 8.11.1、Gradle 8.14 |
| Java | source / target 17，开启 core library desugaring |
| desugar | `com.android.tools:desugar_jdk_libs:2.1.5` |
| SDK 坐标 | `com.imsdk:im-sdk-native:0.1.1` |

SDK 基于预编译 Flutter add-to-app 模块，接入方使用常规 Android 工具即可。宿主保留自己的 `Application`、启动 Activity、applicationId、任务栈与签名；SDK 的 `ImSdkActivity` 由库清单合并，无需让宿主继承 `FlutterActivity`。若宿主已有其他 Flutter 引擎或预编译模块，应先验证引擎、插件与依赖版本共存。

## 2. 配置仓库和依赖

将交付包的完整 `maven/` 保留在稳定位置。以下片段以包内 `sample-host/settings.gradle.kts` 的相对位置为例；放入业务工程时调整本地仓库路径：

```kotlin
dependencyResolutionManagement {
    repositories {
        maven { url = uri(file("../maven")) }
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
        maven { url = uri("https://storage.googleapis.com/download.flutter.io") }
    }
}
```

宿主模块：

```kotlin
android {
    compileSdk = 36
    defaultConfig {
        minSdk = 24
        targetSdk = 36
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }
}

dependencies {
    implementation("com.imsdk:im-sdk-native:0.1.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
```

`gradle.properties` 启用 `android.useAndroidX=true`。完整仓库包含 SDK 的 POM、模块与插件依赖关系；不要只复制一个 AAR。Google、Maven Central、JitPack、Flutter 仓库仍提供公共传递依赖，首次构建需要可用网络或已准备的缓存。示例中若配置了仓库镜像，可按团队网络策略调整。

## 3. 填写开发者配置

独立示例的操作步骤：

1. 将 `config/im_sdk_configuration.example.json` 复制到 `sample-host/app/src/main/assets/im_sdk_configuration.json`。
2. 填写 `apiBaseUrl`、`serviceRealmId` 和本应用真实的隐私政策 HTTPS 地址 `hostPrivacyPolicyUrl`。空模板不会连接服务。
3. 配置个人或固定企业登录方式，保留本应用独立的 `storageNamespace`。
4. 配置 `ANDROID_HOME` 为本机 Android SDK 位置，使用兼容 AGP 的 JDK（最低 17；本包独立编译使用 JBR 21，Java 编译目标为 17）；在 `sample-host/` 下运行 `./gradlew :app:assembleDebug`。
5. 安装生成的 Debug APK，在宿主取得隐私同意后点击“开始聊天”。示例身份、Debug 签名仅用于接入验证。

个人账号配置：

```json
{
  "apiBaseUrl": "https://im.example.com",
  "serviceRealmId": "your-service-realm",
  "storageNamespace": "your_android_app",
  "passwordLogin": {
    "space": "personal",
    "loginType": "lpp_id"
  }
}
```

以上域名和 realm 为格式示意，需由接入团队替换。企业账号将 `passwordLogin` 配置为：

```json
{
  "space": "tenant",
  "loginType": "login_name",
  "tenantCode": "your-fixed-tenant-code"
}
```

企业也可按服务端账号体系选择 `loginType: "lpp_id"`。`tenantCode` 由开发者固定，不让用户选择企业或输入租户参数。个人模式必须是 `lpp_id`，且不能传 `tenantCode`。请显式配置 `passwordLogin`，不要依赖省略时的登录路由。

| 字段 | 约束 |
| --- | --- |
| `apiBaseUrl` | 必填 HTTPS 地址，不带用户名密码、query 或 fragment |
| `serviceRealmId` | 必填稳定服务标识；不同环境应使用不同标识 |
| `privacyConsentGranted` | 运行时必填 `true`，只在宿主已取得实际同意后加入 |
| `passwordLogin` | 常规账号密码入口显式填写，见上述个人 / 企业示例 |
| `storageNamespace` | 可选，默认 `default`；1–64 位字母、数字或 `._-`，建议每个宿主固定独立值 |
| `gatewayBaseUrl` | 可选 HTTPS / WSS 地址，不带用户名密码、query 或 fragment |
| `locale` | 可选，默认 `zh_CN` |

`hostPrivacyPolicyUrl` 仅供独立示例宿主展示其隐私政策，由示例读取并移除，不传入 SDK；业务宿主采用自己的隐私流程时无需向 SDK 提供此字段。示例须先填写此 HTTPS 地址，才可勾选同意并打开聊天。

配置 JSON 不预设隐私同意。示例未勾选同意时不调用初始化；宿主应在自身隐私流程完成后，复制配置并加入 `privacyConsentGranted=true`，不能用预置勾选替代实际同意。

## 4. 打开聊天

入口类型为 `com.imsdk.nativebridge.ImSdk`。完整 Java / Kotlin 片段见 [HostIntegration.java](../examples/HostIntegration.java) 和 [HostIntegration.kt](../examples/HostIntegration.kt)。两份是同一辅助类的语言替代版本，按宿主语言选择一份即可。

```java
// configuration 为开发者配置；仅在实际取得用户同意后执行。
Map<String, Object> runtimeConfig = new LinkedHashMap<>(configuration);
runtimeConfig.put("privacyConsentGranted", true);
ImSdk.initialize(activity.getApplicationContext(), runtimeConfig, new ImSdk.Callback() {
    @Override public void onSuccess(Object value) {
        ImSdk.openMessenger(activity, resultCallback);
    }
    @Override public void onError(String code, String message, Object details) {
        resultCallback.onError(code, message, details);
    }
});
```

实际宿主需确保 Activity 在异步完成后仍有效，包内片段提供此检查。API 回调与事件均在主线程，避免在其中执行网络或耗时工作。`openMessenger` 成功表示页面入口打开，随后登录结果通过页面状态与事件体现，不等于登录成功或消息已送达。

SDK 提供注册、登录、好友搜索 / 申请处理及建群页面；登录后进入会话列表，可选择好友单聊或创建群聊。注册不选择空间，默认个人或进入服务端返回的有效企业登录态。服务地址、会话 ID、凭证 JSON 都属于接入配置或高级 API 参数，不暴露给普通用户。

## 5. 生命周期与账号

普通页面关闭保留引擎和当前账号，重新调用 `openMessenger` 可继续使用。宿主完成整个 SDK 使用周期时调用 `shutdown`；等待回调后可重新初始化。不要在每次宿主 Activity 销毁时无条件 shutdown，否则会破坏预期保留的会话。

`setEventListener` 在 SDK 中被强引用。监听器所属对象释放时调用 `setEventListener(null)`，避免监听器闭包长期引用 Activity；`shutdown` 不会代为清空监听器。退出账号使用 `logout` 并等待成功，宿主后端负责服务端凭证撤销。操作超时会销毁引擎，需重新 `initialize`；不要复用超时后的运行状态。

Android 进程被系统回收后，旧 SDK 页面可能直接结束。宿主应从自己的入口恢复配置与身份，再初始化、打开页面；页面重建不代表账号恢复成功。

## 6. 跨应用账号与高级入口

若业务希望直接使用自己的登录态，先由可信后端完成业务账号到 IM 账号 / 空间的映射，获取 IM 服务签发的短期凭证，再调用 `authenticate`。宿主登录 token、管理员密钥不能当作 IM access token。成功后可调用 `openMessenger`，或通过授权的 `conversationId` 调用 `openDirectConversation`。SDK 不会仅凭宿主账号自动完成后端打通。

客服入口使用 `openCustomerService`。当前企业入口传 `{"entry":"currentTenant"}`；品牌客服传真实 `serviceAccountId`，不能传官方账号的用户投影 ID。成功可能返回排队页面，只有 `canOpenConversation=true` 才可进入聊天，不能因返回了 `conversationId` 就绕过排队。完整数据结构见 [API](API.md)。

## 7. 媒体、推送和生产发布

保留并检查 Android 清单合并结果，按实际启用的能力配置权限。相机 / 麦克风权限在对应能力使用时申请；Android 9 及以下保存媒体需旧版写入权限；系统文档选择不要求广泛文件访问权限。自定义选择器或权限请求期间 Activity 脱离会以 `ACTIVITY_DETACHED` 结束该请求，重新附着后由用户重试。

宿主负责通知通道、推送厂商接入和通知点击路由，本包未集成厂商推送适配器。通知冷启动时先恢复业务身份，认证匹配的 IM 账号 / 空间，校验目标权限，再调用打开 API。仅有会话 ID 不足以切换账号或租户。

生产应用需使用接入方 applicationId、签名与发布配置，验证混淆、ABI、应用体积、真机权限、系统栏、后台恢复与性能。SDK 的 consumer rules 随库发布；仍需在宿主 Release 构建中验证。验收记录参见 [ACCEPTANCE.md](ACCEPTANCE.md)。
