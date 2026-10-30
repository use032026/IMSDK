# SDK 版本与分支

2026-10-30 已将 35 语更新发布为 iOS / Android / Flutter 0.1.3、Web 0.1.6。构建与验证范围见 [35 语交付说明](L10N35_DELIVERY-2026-10-29.md)；当前下载索引已更新，历史分支和 Release 保留。

默认分支为 `main`，只维护各平台最新源码和当前版交付资料。本地开发目录保持检出 `main` 并跟踪 `origin/main`。旧版分支独立保存恢复的历史源码，不合并到 `main`；`before-*` / `draft-*` 工作备份不作为额外语义版本。

| 平台 | main 当前版本 | 版本分支 | Release 标签 |
| --- | --- | --- | --- |
| Web / H5 | 0.1.6 | `web/v0.1.0`～`web/v0.1.6` | `web-v0.1.0`～`web-v0.1.6` |
| iOS | 0.1.3 | `ios/v0.1.0`～`ios/v0.1.3` | `ios-v0.1.0`～`ios-v0.1.3` |
| Android | 0.1.3 | `android/v0.1.0`～`android/v0.1.3` | `android-v0.1.0`～`android-v0.1.3` |
| Flutter | 0.1.3 | `flutter/v0.1.0`～`flutter/v0.1.3` | `flutter-v0.1.0`～`flutter-v0.1.3` |

分支入口：[Web](https://github.com/use032026/IMSDK/branches/all?query=web%2F)、[iOS](https://github.com/use032026/IMSDK/branches/all?query=ios%2F)、[Android](https://github.com/use032026/IMSDK/branches/all?query=android%2F)、[Flutter](https://github.com/use032026/IMSDK/branches/all?query=flutter%2F)。各最新版分支在首次导入时与 `main` 指向同一提交，因此都能取得当前完整独立工程；旧移动版本保留共享 Dart 和原生适配源码，旧 Web 分支只保留该版 Web 内容。

## 取得完整 SDK

从 [GitHub Releases](https://github.com/use032026/IMSDK/releases) 选择对应平台和版本。原生二进制 ZIP 包含完整 iOS 框架或 Android Maven 依赖、宿主示例、API / 接入说明、MANIFEST 与 SHA256SUMS。Flutter 0.1.3 通过对应标签的 GitHub Source code 提供源码归档（旧版 Release 附件保留）；Web ZIP 包含浏览器成品、npm 包及示例。

Git 中保留源码、锁文件、工具链版本、当前交付文档和 Web 成品。iOS `binary/`、Android `maven/`、安装包及完整 ZIP 通过 Release 分发，不写入 Git 大文件。`dist/*/SHA256SUMS` 和 MANIFEST 校验的是完整 Release 包；仅克隆源码时缺少原生二进制属于预期情况，不能对 Git 目录直接宣称全包校验通过。

当前下载索引为 [dist/versions.json](../dist/versions.json)。在源码目录自行构建见 [BUILD.md](BUILD.md)。构建所需的公开依赖由固定锁文件解析；本机缓存、任务输入、私有账号、签名和验证原始日志不提交。

## 历史源码来源

Web 0.1.0 / 0.1.1 / 0.1.3 / 0.1.4 使用当时保存的对应版本源码归档，Web 0.1.2 使用移动 0.1.0 完整源码备份中的 `web/`。各分支 `VERSION.json` 记录来源。

移动 0.1.0 使用当时完整源码备份；移动 0.1.1 以该备份为基线，叠加升级至 0.1.2 前保存的 0.1.1 快照。0.1.1 的全部 Dart lib、iOS 原生 Sources 和 Android 原生 src 已与当时验证报告的目录摘要逐项核对一致，未变化的资源和工程辅助文件沿用基线，两个 podspec 仅对齐该版版本号。恢复没有回填当前新增运行时代码。原始说明保存在各移动历史分支 `docs/SOURCE_README.md`，二进制以该版本 Release 为准。

本次仓库整理执行版本、源码摘要、包完整性和远程提交核对，没有重新执行构建、模拟器或真机验收。历史 MANIFEST 中的结果仅代表各包原先记录的验证范围。

## 后续发版约定

1. 在 `main` 开发并同步修改相关版本声明、锁文件、原生 facade / module / 样例坐标。
2. 完成对应平台实际构建与验收后，从发布提交建立 `<平台>/v<版本>` 分支和 `<平台>-v<版本>` 标签。
3. 为该标签创建 Release，上传完整交付包及 SHA256 校验文件；保护旧版 Release 和版本分支。
4. 更新 `dist/versions.json`、README、当前交付资料及 `.gitignore` 的版本白名单，把旧交付目录移出 `main`；其他平台保持各自最新版。
5. 推送 `main` 与版本分支 / 标签，核对远程提交后，本地继续保持 `main` 与 `origin/main` 同步。


## 推送完成后的本地保留策略

远程分支提交与 Release 附件 SHA256 核验通过后，直接清理无需保留的本地 ZIP / tar.gz、上传暂存副本、重复的原生分发二进制，以及已结束且确认闲置的宿主安装包、构建输出与缓存。不把这些内容搬到桌面另存一份。需要时从对应版本分支和 Release 恢复；锁文件、依赖、源码、签名、私有输入和必要验证证据继续保留。活动数据、唯一且未上传的交付物或源码备份不删除。具体步骤见根目录 [AGENTS.md](../AGENTS.md)。
