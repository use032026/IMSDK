# IMSDK iOS 交付包

SDK 版本：**0.1.1** · 文档日期：**2026-10-28** · 最低系统：**iOS 15.0**

本版统一注册 / 登录、会话列表、好友申请处理、单聊和新建群聊 / 群聊。注册不选择空间：默认进入个人空间，服务端返回有效企业登录态时进入该企业，同时只有一个活跃空间。

此包供 UIKit / Swift / Objective-C 宿主集成完整聊天界面。常规入口为宿主取得隐私同意后 `initialize → openMessenger`：用户在 SDK 内输入账号、密码，进入会话列表并收发单聊、群聊消息。服务地址和账号空间由宿主配置。

## 先看这三项

1. 按 [接入说明](docs/INTEGRATION.md) 导入一种构建模式的 **35 个 XCFramework 全集**，其中 32 个动态库选择 **Embed & Sign**，3 个静态库选择 **Do Not Embed**；不要混合 Debug / Release。
2. 使用 [配置模板](config/IMSDKConfiguration.example.plist) 填写环境配置，在运行时加入真实的隐私同意结果；默认推荐显式个人空间 `space=personal, loginType=lpp_id`。固定企业配置见接入说明。
3. 打开 `sample-host/` 中的独立 UIKit Xcode 工程，参考 [Swift](examples/HostIntegration.swift) 或 [Objective-C](examples/HostIntegration.m) 接入。二进制接入无需安装 Flutter，无需引用 SDK 源码仓库或原应用工程。

## 包内容

```text
binary/
  Debug/                      35 个 XCFramework，供调试使用
  Release/                    35 个 XCFramework，供设备发行集成
  INTEGRATION.json             每个框架的链接 / 嵌入方式
  THIRD_PARTY_NOTICES.plist     第三方声明
  flutter_lldbinit             Debug 调试初始化文件
  flutter_lldb_helper.py       与上项保持相邻
sample-host/                  独立 UIKit 示例工程及说明
examples/HostIntegration.swift
examples/HostIntegration.m
config/IMSDKConfiguration.example.plist
docs/INTEGRATION.md            工程配置、登录方式、生命周期、常见问题
docs/API.md                    原生接口、参数、事件与错误
docs/ACCEPTANCE.md             验证范围及原生团队验收清单
MANIFEST.json                 本包构建与验证信息
SHA256SUMS                    文件校验清单
```

解压后可在包根目录执行 `shasum -a 256 -c SHA256SUMS` 核对交付完整性。以 [MANIFEST.json](MANIFEST.json) 记录的构建模式、产物及验证结果为准；不要将另一版交付物覆盖进本包。

## 验证边界

2026-10-28，共享移动源码已在 iOS 26.5 模拟器的 Flutter 源码宿主中通过真实邮箱注册、自动登录、接受好友申请、会话列表、单聊和新建群聊双向文本收发及重新登录；独立 Web 对端核对持久化和回复显示。退出 / 立即释放增量验证通过。iOS 0.1.1 已重建完整 Debug / Release 框架，通过 Swift / Objective-C 六组合消费和独立 UIKit Debug 模拟器 / Release 无签名设备编译；新二进制在 iOS 26.5 模拟器完成真实密码登录、已有单聊和群聊原消息 / 回复显示及退出释放，未新增注册或发送消息。摘要以 `MANIFEST.json` 为准，Release 真机运行另行验收。

2026-10-27 的旧版原生宿主收发结果保留为历史；未代表本版真机媒体、通知、后台恢复、性能或生产发布通过，详见 [验证范围](docs/ACCEPTANCE.md)。
