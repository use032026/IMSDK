# 宿主管理主题与语言

宿主在初始化配置中设置 `themeMode` 和 `locale`，随后通过 `updatePresentation` 更新已打开的 SDK。该能力独立于登录同步，不需要 IM 换票后端。本文对应本次修改后的源码；已发布原生包及版本化 Web 交付快照尚未重建。

## 配置语义

| 字段 | 可用值 | 行为 |
| --- | --- | --- |
| `themeMode` | `light`、`dark`、`system` | 浅色、深色、跟随平台外观；默认 `system` |
| `locale` | `zh-CN`、`zh-TW`、`en`、`ja`、`ko`、`vi`、`system` | 简中、繁中、英语、日语、韩语、越南语、跟随平台语言；默认简中 |

支持语言区域 / 脚本别名与历史下划线写法，例如 `en-US` → `en`、`zh_Hans_CN` → `zh-CN`、`zh-Hant-HK` → `zh-TW`。显式不支持的语言或主题返回 `INVALID_PRESENTATION`，整次更新不应用。系统语言没有支持项时回退简中。

宿主有自己的语言策略时，应传其最终选择的语言。宿主的“自动语言”可能还包含业务地区规则，此时不能用 SDK 的 `system` 替代宿主已解析结果。系统事件只影响对应设置为 `system` 的字段，显式宿主设置优先。

## 调用方式

以下运行时接口在 SDK 初始化成功后调用；同名字段也可直接放入初始化配置。仅传一个字段时保留另一个字段。

Flutter：

```dart
await client.updatePresentation(themeMode: 'dark', locale: 'en-US');
await client.updatePresentation(locale: 'zh-Hant');
```

iOS / Swift：

```swift
IMSDK.shared.updatePresentation(settings: [
    "themeMode": "dark", "locale": "en-US"
]) { _, error in
    // 由宿主统一处理错误。
}
```

Objective-C：

```objc
[[IMSDK shared] updatePresentationWithSettings:@{
  @"themeMode": @"dark", @"locale": @"en-US"
} completion:^(id value, NSError *error) {}];
```

Android 使用 `ImSdk.updatePresentation(settings, callback)`，Map 字段同上。Web 使用：

```javascript
client.updatePresentation({ themeMode: 'dark', locale: 'en-US' });
```

更新后公开配置反映当前设置，并产生 `presentationChanged` 事件；不改变认证代际或释放账号运行时。主题、语言变化无需关闭重开 SDK，也不重新认证。

## 页面与宿主边界

SDK 登录 / 注册、宿主状态页、会话列表、单聊和客服使用统一呈现设置。用户输入、消息正文、昵称和服务端内容保持原文；SDK 控件、提示、校验错误和可访问性标签采用对应界面语言。运行时更新应保留路由和输入草稿。

Web 使用 Shadow DOM 内的主题与文案绑定，不修改宿主网页根语言或样式。iOS 只设置 SDK 自有控制器的外观，不修改宿主 window；Android 不调用全应用夜间模式或全局 locale 切换。

宿主应在自己的偏好变化后调用更新接口。MediaServiceClient 的可选参考适配仅位于 IMSDK 示例目录，读取宿主权威主题偏好与已解析语言，通过现有通知、前台恢复和状态采样同步，不修改或注入真实宿主。

## 验证边界

验证首次配置、运行时切换、六种语言、系统变化、非法值原子拒绝、保留路由 / 草稿及账号状态。原生接口编译、模拟宿主和浏览器检查分别记录；真实第三方宿主与实体设备仍需实际接入后验收。
