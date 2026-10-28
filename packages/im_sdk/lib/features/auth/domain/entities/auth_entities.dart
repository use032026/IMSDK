import 'package:flutter/foundation.dart';

/// Legacy server-side tenant identifier used to represent personal space.
///
/// It is an authentication compatibility detail, not an enterprise tenant,
/// and must never be exposed through the enterprise-space directory.
const legacyPersonalTenantId = '11111111-1111-1111-1111-111111111111';

bool isLegacyPersonalTenantId(String? tenantId) =>
    tenantId?.trim().toLowerCase() == legacyPersonalTenantId;

enum AuthVerificationChannel {
  sms(apiValue: 'sms', loginType: 'mobile'),
  email(apiValue: 'email', loginType: 'email');

  const AuthVerificationChannel({
    required this.apiValue,
    required this.loginType,
  });

  final String apiValue;
  final String loginType;
}

@immutable
class AuthVerificationSettings {
  const AuthVerificationSettings({
    required this.smsEnabled,
    required this.emailEnabled,
    required this.smsRequired,
    required this.emailRequired,
  });

  final bool smsEnabled;
  final bool emailEnabled;
  final bool smsRequired;
  final bool emailRequired;

  bool isEnabled(AuthVerificationChannel channel) => switch (channel) {
        AuthVerificationChannel.sms => smsEnabled,
        AuthVerificationChannel.email => emailEnabled,
      };
}

@immutable
class AuthCaptchaChallenge {
  const AuthCaptchaChallenge({
    required this.token,
    required this.question,
  });

  final String token;
  final String question;
}

@immutable
class PlatformRegistrationResult {
  const PlatformRegistrationResult.tenant(this.tenantAuth,
      {this.pendingApproval = false})
      : platformToken = null,
        platformUserId = null,
        platformRefreshToken = null,
        deviceSessionToken = null;

  const PlatformRegistrationResult.platform({
    required this.platformToken,
    required this.platformUserId,
    this.platformRefreshToken,
    this.deviceSessionToken,
    this.pendingApproval = false,
  }) : tenantAuth = null;

  final TenantAuthResult? tenantAuth;
  final String? platformToken;
  final String? platformUserId;
  final String? platformRefreshToken;
  final String? deviceSessionToken;
  final bool pendingApproval;

  bool get hasTenantSession => tenantAuth != null;
}

@immutable
class TenantIdentitySnapshot {
  const TenantIdentitySnapshot({
    required this.userId,
    required this.platformUserId,
    required this.userType,
    this.verifiedSpaceId,
  });

  final String userId;
  final String platformUserId;
  final int? userType;

  /// Space supplied by the accepted profile or its identity-bound bearer.
  /// Null means the service did not expose a verifiable space hint.
  final String? verifiedSpaceId;

  bool get hasStableIdentity =>
      userId.trim().isNotEmpty && platformUserId.trim().isNotEmpty;
}

enum TenantFriendMode { social, isolation }

/// 登录请求
@immutable
class LoginRequest {
  final String identifier; // 手机号或邮箱
  final String? password;
  final String? verificationCode;
  final String loginType; // 'mobile', 'email', 'login_name', 'auto', 'lpp_id'
  final bool isCodeLogin; // true=验证码登录, false=密码登录
  final String? captchaToken; // 图形验证码 token
  final String? captchaAnswer; // 图形验证码答案
  final String? tenantCode; // 企业码（ztId/login_name 登录时必填）
  final bool issueRefreshToken;
  final bool trustDevice;
  final String? deviceId;
  final String? deviceName;
  final String? devicePlatform;
  final String? deviceModel;
  final String? appVersion;

  const LoginRequest({
    required this.identifier,
    this.password,
    this.verificationCode,
    required this.loginType,
    required this.isCodeLogin,
    this.captchaToken,
    this.captchaAnswer,
    this.tenantCode,
    this.issueRefreshToken = false,
    this.trustDevice = false,
    this.deviceId,
    this.deviceName,
    this.devicePlatform,
    this.deviceModel,
    this.appVersion,
  });

  LoginRequest withTrustedDevice({
    required String deviceId,
    required String devicePlatform,
    String? deviceName,
    String? deviceModel,
    String? appVersion,
  }) {
    return LoginRequest(
      identifier: identifier,
      password: password,
      verificationCode: verificationCode,
      loginType: loginType,
      isCodeLogin: isCodeLogin,
      captchaToken: captchaToken,
      captchaAnswer: captchaAnswer,
      tenantCode: tenantCode,
      issueRefreshToken: true,
      trustDevice: true,
      deviceId: deviceId,
      deviceName: deviceName,
      devicePlatform: devicePlatform,
      deviceModel: deviceModel,
      appVersion: appVersion,
    );
  }
}

/// 租户摘要
@immutable
class TenantSummary {
  final String tenantId;
  final String tenantName;
  final String? tenantCode;
  final String? logoUrl;
  final int membershipRole; // 0=普通成员, 1=技术支持, 2=客服, 3=管理员, 4=所有者

  const TenantSummary({
    required this.tenantId,
    required this.tenantName,
    this.tenantCode,
    this.logoUrl,
    required this.membershipRole,
  });

  String get roleLabel {
    switch (membershipRole) {
      case 4:
        return '所有者';
      case 3:
        return '管理员';
      case 2:
        return '客服';
      case 1:
        return '技术支持';
      default:
        return '成员';
    }
  }
}

/// 平台登录结果
@immutable
class PlatformLoginResult {
  final String platformToken;
  final String platformUserId;
  final String? lppId;
  final String? displayName;
  final int? userType;
  final int expiresIn;
  final List<TenantSummary> tenants;
  final String? platformRefreshToken;
  final String? platformRefreshTokenExpiresAt;
  final String? deviceSessionToken;
  final String? deviceSessionInactiveExpiresAt;

  /// spaceContext.spaceType: 0=需选择, 1=个人空间, 2=租户空间
  final int spaceType;
  final String? suggestedTenantId;

  /// 注册 platform-result 在企业绑定 + 人工审批时返回 true。
  final bool pendingApproval;

  /// 账号状态：'active' | 'deactivating'（注销冷静期）
  final String accountStatus;

  const PlatformLoginResult({
    required this.platformToken,
    required this.platformUserId,
    this.lppId,
    this.displayName,
    this.userType,
    required this.expiresIn,
    required this.tenants,
    this.platformRefreshToken,
    this.platformRefreshTokenExpiresAt,
    this.deviceSessionToken,
    this.deviceSessionInactiveExpiresAt,
    this.spaceType = 0,
    this.suggestedTenantId,
    this.pendingApproval = false,
    this.accountStatus = 'active',
  });

  bool get isPendingDeactivation => accountStatus == 'deactivating';
}

/// 租户认证结果
@immutable
class TenantAuthResult {
  /// Canonical application space identity. Personal space is always
  /// `personal`; enterprise space uses the authoritative tenantId.
  final String spaceId;
  final String userId;
  final String? platformUserId;
  final String? lppId;
  final String? displayName;
  final String? tenantName;
  final int? userType;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  /// spaceContext.spaceType: 1=个人空间, 2=租户空间
  final int? spaceType;

  const TenantAuthResult({
    required this.spaceId,
    required this.userId,
    this.platformUserId,
    this.lppId,
    this.displayName,
    this.tenantName,
    this.userType,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.spaceType,
  });

  bool get hasStableIdentity =>
      spaceId.trim().isNotEmpty &&
      userId.trim().isNotEmpty &&
      (platformUserId?.trim().isNotEmpty ?? false);
}
