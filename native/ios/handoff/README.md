# IMSDK iOS 交付包

SDK 版本：**0.1.3** · 文档日期：**2026-10-29** · 最低系统：**iOS 15.0**

本版统一注册 / 登录、会话列表、好友申请处理、单聊和新建群聊 / 群聊。注册不选择空间：默认进入个人空间，服务端返回有效企业登录态时进入该企业，同时只有一个活跃空间。

此包供 UIKit / Swift / Objective-C 宿主集成完整聊天界面。随包 UIKit 示例已预置与 Web 相同的真实服务，启动后自动进入登录 / 注册，无需手动修改服务配置。已有有效 IM 登录态时直接进入会话列表。嵌入其他应用时仍由宿主完成配置与隐私同意，再调用 `initialize → openMessenger`。

## 先看这三项

1. 按 [接入说明](docs/INTEGRATION.md) 导入一种构建模式的 **35 个 XCFramework 全集**，其中 32 个动态库选择 **Embed & Sign**，3 个静态库选择 **Do Not Embed**；不要混合 Debug / Release。
2. 默认示例和 [配置文件](config/IMSDKConfiguration.example.plist) 已连接本轮授权的真实服务，直接运行即可注册或登录。配置只包含服务连接信息，不含测试账号、密码或 token；切换其他环境的接入方式见接入说明。
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


## 35语本地重编范围

本包从当前35语源码重新编译，包含公共词库0.3.0。宿主可在初始化设置locale，或调用updatePresentation更新主题/语言；支持的35种语言及专属缺译英语回退见 `localization/`。原六语值保持一致；葡语区分pt-BR与pt-PT。

本轮验证实际二进制构建、资源清单与独立消费，详见MANIFEST.json。0.1.2的真实服务注册、好友和单/群聊结果属于历史，未重做本版真实后端或真机验收；35语全部页面的翻译质量、字体及视觉矩阵仍需接入方验收。包内服务配置沿用已有示例，不包含账号密码或Token。
