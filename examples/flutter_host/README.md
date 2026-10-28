# Flutter 聊天示例

只引用公开入口 `package:im_sdk/im_sdk.dart`。用户流程为 **账号密码登录 → 会话列表 → 单聊 / 群聊**，没有手填凭证或会话 ID 的步骤，也不内置测试账号或假消息。

接入方通过构建参数配置真实 IM 服务，默认使用个人聊天空间：

```sh
# 先在 IMSDK 根目录完成 ./scripts/resolve_dependencies.sh
cd examples/flutter_host
flutter run \
  --dart-define=IMSDK_API_BASE_URL='<真实HTTPS服务地址>' \
  --dart-define=IMSDK_SERVICE_REALM_ID='<环境标识>'
```

将尖括号参数替换成接入配置后执行；不传账号、密码或 token。个人空间使用平台账号密码登录，无需企业成员身份。企业内聊天需额外设置 `IMSDK_LOGIN_SPACE=tenant`、`IMSDK_TENANT_CODE` 和相应的 `IMSDK_LOGIN_TYPE`（`lpp_id` 或 `login_name`）。`IMSDK_GATEWAY_BASE_URL` 为可选地址。未配置服务时，示例提示接入方完成配置，不让用户输入技术参数。

固定工具链为 Flutter 3.41.9。iPhone 开发签名由接入方配置。详见 [Flutter 接入说明](../../docs/FLUTTER_INTEGRATION.md)。

其他 App 账号与 IM 身份的映射、认证和凭证签发由服务端接通；这个示例本身不实现跨 App 账户系统。现存 `dist` 安装包和旧凭证联调测试不证明新流程已通过验收，源码变更后须重新构建验证。
