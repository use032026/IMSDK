import 'package:im_sdk/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_entities.dart';
import 'package:im_sdk/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
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
  }) =>
      _remoteDataSource.registerPlatform(
        displayName: displayName,
        password: password,
        loginType: loginType,
        loginName: loginName,
        mobile: mobile,
        email: email,
        verificationCode: verificationCode,
        captchaToken: captchaToken,
        captchaAnswer: captchaAnswer,
        tenantId: tenantId,
      );

  @override
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
  }) =>
      _remoteDataSource.registerEnterprise(
        tenantIdOrCode: tenantIdOrCode,
        password: password,
        displayName: displayName,
        loginType: loginType,
        loginName: loginName,
        email: email,
        mobile: mobile,
        verificationCode: verificationCode,
        captchaToken: captchaToken,
        captchaAnswer: captchaAnswer,
      );

  @override
  Future<TenantIdentitySnapshot> getTenantIdentity(String accessToken) =>
      _remoteDataSource.getTenantIdentity(accessToken);

  @override
  Future<TenantFriendMode> getTenantFriendMode(String accessToken) =>
      _remoteDataSource.getTenantFriendMode(accessToken);

  @override
  Future<int> getTenantMembershipRole({
    required String userId,
    required String accessToken,
  }) =>
      _remoteDataSource.getTenantMembershipRole(
        userId: userId,
        accessToken: accessToken,
      );

  @override
  Future<PlatformLoginResult> platformLogin(LoginRequest request) {
    return _remoteDataSource.login(request);
  }

  @override
  Future<PlatformLoginResult> platformLoginByCode(LoginRequest request) {
    return _remoteDataSource.loginByCode(request);
  }

  @override
  Future<AuthVerificationSettings> getVerificationSettings() {
    return _remoteDataSource.getVerificationSettings();
  }

  @override
  Future<AuthCaptchaChallenge> generateCaptcha() {
    return _remoteDataSource.generateCaptcha();
  }

  @override
  Future<void> sendVerificationCode({
    required String identifier,
    required String channel,
    required String purpose,
    String? captchaToken,
    String? captchaAnswer,
  }) {
    return _remoteDataSource.sendVerificationCode(
      identifier: identifier,
      channel: channel,
      purpose: purpose,
      captchaToken: captchaToken,
      captchaAnswer: captchaAnswer,
    );
  }

  @override
  Future<void> resetPlatformPassword({
    required String identifier,
    required String verificationCode,
    required String newPassword,
    required String loginType,
  }) {
    return _remoteDataSource.resetPlatformPassword(
      identifier: identifier,
      verificationCode: verificationCode,
      newPassword: newPassword,
      loginType: loginType,
    );
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return _remoteDataSource.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<TenantAuthResult> selectTenant(String tenantId, String platformToken) {
    return _remoteDataSource.selectTenant(tenantId, platformToken);
  }

  @override
  Future<TenantAuthResult> selectPersonalSpace(String platformToken,
      {bool preserveReturnedSpace = false}) {
    return _remoteDataSource.selectPersonalSpace(platformToken,
        preserveReturnedSpace: preserveReturnedSpace);
  }

  @override
  Future<void> leaveEnterprise(String accessToken) =>
      _remoteDataSource.leaveEnterprise(accessToken);

  @override
  Future<TenantAuthResult> refreshToken(String refreshToken) {
    return _remoteDataSource.refreshToken(refreshToken);
  }

  @override
  Future<TenantAuthResult> tenantLogin(LoginRequest request) {
    return _remoteDataSource.tenantLogin(request);
  }

  @override
  Future<void> logout() async {
    // 本地清理由 AuthNotifier 负责（清除 SecureStorage）
    // 如有服务端登出接口，可在此调用
  }

  @override
  Future<List<TenantSummary>> getMyTenants(String platformToken) {
    return _remoteDataSource.getMyTenants(platformToken);
  }

  @override
  Future<PlatformLoginResult> refreshPlatformToken(String platformToken) {
    return _remoteDataSource.refreshPlatformToken(platformToken);
  }
}
