import 'package:im_sdk/features/auth/domain/entities/auth_entities.dart';

abstract class AuthRepository {
  Future<PlatformRegistrationResult> registerPlatform({
    required String displayName,
    required String password,
    required String loginType,
    String? loginName,
    String? mobile,
    String? email,
    String? verificationCode,
    String? captchaToken,
    String? captchaAnswer,
    String? tenantId,
  });

  Future<void> registerEnterprise({
    required String tenantIdOrCode,
    required String password,
    required String displayName,
    required String loginType,
    String? loginName,
    String? email,
    String? mobile,
    String? verificationCode,
    String? captchaToken,
    String? captchaAnswer,
  });

  Future<TenantIdentitySnapshot> getTenantIdentity(String accessToken);

  Future<TenantFriendMode> getTenantFriendMode(String accessToken);

  Future<int> getTenantMembershipRole({
    required String userId,
    required String accessToken,
  });

  /// 密码登录
  Future<PlatformLoginResult> platformLogin(LoginRequest request);

  /// 验证码登录
  Future<PlatformLoginResult> platformLoginByCode(LoginRequest request);

  Future<AuthVerificationSettings> getVerificationSettings();

  Future<AuthCaptchaChallenge> generateCaptcha();

  /// 发送验证码
  Future<void> sendVerificationCode({
    required String identifier,
    required String channel, // 'sms' or 'email'
    required String purpose, // 'login', 'register', 'reset_password'
    String? captchaToken,
    String? captchaAnswer,
  });

  Future<void> resetPlatformPassword({
    required String identifier,
    required String verificationCode,
    required String newPassword,
    required String loginType,
  });

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  /// 选择租户，换取租户级 Token
  Future<TenantAuthResult> selectTenant(String tenantId, String platformToken);

  /// 进入个人空间，换取客户端 Token
  Future<TenantAuthResult> selectPersonalSpace(String platformToken,
      {bool preserveReturnedSpace = false});

  /// 退出当前企业，使用退出前捕获的租户凭证。
  Future<void> leaveEnterprise(String accessToken);

  /// 刷新 Token
  Future<TenantAuthResult> refreshToken(String refreshToken);

  /// 租户内登录（微界号+密码，走 /api/client/v1/auth/login）
  Future<TenantAuthResult> tenantLogin(LoginRequest request);

  /// 退出登录
  Future<void> logout();

  /// 获取当前平台账号的租户列表（GET /api/platform/v1/my/tenants）
  Future<List<TenantSummary>> getMyTenants(String platformToken);

  /// 刷新平台 Token（POST /api/platform/v1/auth/refresh-platform-token）
  Future<PlatformLoginResult> refreshPlatformToken(String platformToken);
}
