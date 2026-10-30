# MediaServiceClient 主题与语言参考适配

`native/ios/Examples/MediaServiceClientPresentationAdapter.{h,m}` 是可选宿主示例，独立于登录态适配器。它不属于 SDK 的 `Sources/`，不会自动注入，也不会修改、构建或启动 MediaServiceClient。接入方选择使用时，将这两个文件加入自己的 App target，链接 STCore、DarkMode 和具有 `updatePresentationWithSettings:completion:` 的新版 IMSDKNative。

## 以宿主实际设置为准

本例只读参照 `/Users/starburst/Documents/Work/MediaServiceClient` 的 `dev/dev_chat`、提交 `1f67b4347`：

- 主题使用 `STDarkModeTool.getAppDarkMode`。`UIUserInterfaceStyleLight / Dark / Unspecified` 分别映射 `light / dark / system`。宿主没有保存过偏好时默认 **light**，不是 system。
- 主题通知为 `STDarkModelDidChangedNotification`。该通知由宿主 root controller 的 trait 变化触发，因此从手动主题切成 Auto、但当前实际颜色没变化时，通知可能不出现。
- 语言读取 `STBundle.sharedInstance.languageCode` 的已解析值。宿主自动语言还受开放国家、IP、B 面配置等规则影响，并非单纯系统语言；本例不会因用户未手动选择就传 `locale=system`。
- 监听实际的 `STLanguageDidChangedNotification` 和 `STCountryManagerLanguagesDidChangeNotification`，不覆盖宿主的语言重建回调。普通语言设置和自动语言调整均可被重新读取。

对应源码为 `Local/DarkMode/classes/STDarkModeTool.m` 的 `getSavedValue / updateTheme:`，`STTradeUI/Classes/Modules/MainPage/STRootViewController.m` 的 `traitCollectionDidChange:`，以及 `STCore/Classes/Base/Foundation/NSBundle/STBundle.m` 的 `languageCode / selectLanguageCode:languageName: / applyAutomaticLanguageWithCountryKeys:ipCountry:`。本例不会调用这些设置方法，也不会改宿主 window 或 UserDefaults。

SDK 当前六种资源的映射如下。大小写和 `_` / `-` 均接受；中文文字脚本优先于地区：

| 宿主语言 | 传给 SDK |
| --- | --- |
| `zh`、`zh-Hans`、`zh-CN`、`zh-SG` | `zh-CN` |
| `zh-Hant`、`zh-TW`、`zh-HK`、`zh-MO` | `zh-TW` |
| `en` 及其地区变体 | `en` |
| `ja` 及其地区变体 | `ja` |
| `ko` 及其地区变体 | `ko` |
| `vi` 及其地区变体 | `vi` |
| `pt`、`pt-BR`、`ptBR` | `pt-BR` |
| `pt-PT`、`ptPT` | `pt-PT` |
| 其余公共词库支持的语言及地区变体 | 对应35语中的规范语言码；`no`→`nb`、`tl`→`fil`、`in`→`id` |
| 未支持的语言或空值 | `en`（本参考适配器的明确回退） |

语言码接受能力不代表SDK专属或法务内容已经全部翻译，专属缺译明确回退英语，法律正文沿用原选择逻辑。直接使用通用 SDK API 时，可按 SDK 的接口契约选择 `locale=system`；本例的职责是匹配宿主已经解析的实际语言。

## 在初始化和页面进入前使用

以下是可选接入代码，不代表真实宿主已经修改或完成验收。所有方法与属性变更在主线程进行。适配器不需要宿主登录、IM provider、后端换票或任何 token；SDK 的隐私同意仍由接入方实际取得。

```objc
#import <IMSDKNative/IMSDKNative-Swift.h>
#import "MediaServiceClientPresentationAdapter.h"

// 宿主持有，不使用临时局部对象。
@property (nonatomic, strong) IMSDKMediaServiceClientPresentationAdapter *imPresentation;

self.imPresentation = [[IMSDKMediaServiceClientPresentationAdapter alloc] init];
NSMutableDictionary *sdkConfiguration = [configuration mutableCopy];
[sdkConfiguration addEntriesFromDictionary:[self.imPresentation currentPresentationSettings]];
[[IMSDK shared] initializeWithConfiguration:sdkConfiguration completion:^(id value, NSError *error) {
  if (error) return;
  [self.imPresentation start]; // 未登录也可以启动；不操作账号。
}];

// 若进入页面前需要立即重读，等待呈现设置更新后再调用原有入口。
[[IMSDK shared] updatePresentationWithSettings:[self.imPresentation currentPresentationSettings]
                                   completion:^(id value, NSError *error) {
  if (error) return;
  [[IMSDK shared] openMessengerFromViewController:visiblePresenter
                                     completion:entryCompletion];
}];
```

初始化时先合并快照，可避免 SDK 首次打开使用错误的默认主题或语言。`start` 必须在初始化成功后显式调用；它既不会初始化 SDK，也不会设置登录态 provider。停止 SDK 使用前调用 `[self.imPresentation stop]`，然后按原有流程释放 SDK；`stop` 只移除这个适配器自己的观察者和定时器。

## 变更、合并与延迟

App active 时每秒只读一次主题和语言，补偿通知遗漏；非 active / 后台停止定时采样，重新 active 时立即读取。已应用的相同设置不会重复发送。一个更新仍在途时，只保留最新的快照：例如 A 更新未完成时连续收到 B、C，A 完成后提交 C。失败且设置未变时等待下一次采样重试，不形成即时循环。`stop` 后迟到的回调不能重新启动采样或提交更新。

定时采样的发现延迟通常为下一次约 1 秒的前台采样，再加 SDK 更新调度时间；主线程阻塞或 App 挂起时不承诺此时限。已经提交给 SDK 的更新不能由适配器的 `stop` 撤销，SDK 仍按自身生命周期处理。适配器只同步主题和语言，不重置账号、聊天导航或后端业务状态。

## 验证边界

可以在 IMSDK 内使用假 STBundle、STDarkModeTool 和 SDK 桥接，验证35种语言映射、Light/Dark/Auto、通知遗漏后的采样、更新合并、失败重试和停止清理。此类验证不代表真实 MediaServiceClient 已接入，也不代替新原生二进制、真实宿主、多场景窗口或真机的呈现验收。

公共词库0.3.0对应的SDK参考适配现支持宿主35种语言，pt-BR/pt-PT分别映射；未知语言仍回退英语。这里只更新SDK示例文件，真实MediaServiceClient项目未接入或修改。SDK/Web专属缺译可回退英语，不能把语言码接受能力视为所有内容已经翻译完毕。
