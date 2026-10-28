# IMSDK iOS 交付包

SDK 版本：**0.1.0** · 文档日期：**2026-10-28** · 最低系统：**iOS 15.0**

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

此前 Debug UIKit 宿主已在 iOS 模拟器通过真实个人账号密码登录、会话列表、单聊和群聊双向文本收发，以及关闭后重新进入的验证。本包 Release 的重建与独立宿主编译结果以 MANIFEST 为准；编译通过不代表 Release 真机业务验收通过。

真机媒体、通知、后台恢复、VoiceOver、性能以及与其他 Flutter 模块共存，仍需按 [验收说明](docs/ACCEPTANCE.md) 验证。宿主负责设备签名、权限用途说明、业务环境和账号授权；包内不提供账号、令牌、生产签名或已配置测试环境的 App。
