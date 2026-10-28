import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/api_response.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/platform/app_platform.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_entities.dart';

abstract class AuthRemoteDataSource {
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
  Future<PlatformLoginResult> login(LoginRequest request);
  Future<PlatformLoginResult> loginByCode(LoginRequest request);
  Future<AuthVerificationSettings> getVerificationSettings();
  Future<AuthCaptchaChallenge> generateCaptcha();
  Future<void> sendVerificationCode({
    required String identifier,
    required String channel,
    required String purpose,
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
  Future<TenantAuthResult> selectTenant(String tenantId, String platformToken);
  Future<TenantAuthResult> selectPersonalSpace(String platformToken,
      {bool preserveReturnedSpace = false});
  Future<void> leaveEnterprise(String accessToken);
  Future<TenantAuthResult> refreshToken(String refreshToken);
  Future<TenantAuthResult> tenantLogin(LoginRequest request);

  /// GET /api/platform/v1/my/tenants
  Future<List<TenantSummary>> getMyTenants(String platformToken);

  /// POST /api/platform/v1/auth/refresh-platform-token
  Future<PlatformLoginResult> refreshPlatformToken(String platformToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

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
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/platform/v1/auth/register',
        data: {
          'displayName': displayName,
          'password': password,
          'loginType': loginType,
          if (loginName?.isNotEmpty == true) 'loginName': loginName,
          if (mobile != null) 'mobile': mobile,
          if (email != null) 'email': email,
          if (verificationCode != null) 'verificationCode': verificationCode,
          if (captchaToken != null) 'captchaToken': captchaToken,
          if (captchaAnswer != null) 'captchaAnswer': captchaAnswer,
          if (tenantId?.isNotEmpty == true) 'tenantId': tenantId,
        },
        options: Options(extra: const {'publicAuthRequest': true}),
      );
      final envelope = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data!,
        (json) => Map<String, dynamic>.from(json as Map),
      );
      final data = envelope.getDataOrThrow();
      if (data.containsKey('accessToken')) {
        final context = data['spaceContext'] as Map<String, dynamic>?;
        final type = context?['spaceType'];
        final personal = type == 1 ||
            (type == null &&
                (data['spaceId'] == 'personal' ||
                    data['tenantId'] == 'personal' ||
                    isLegacyPersonalTenantId(data['tenantId'] as String?)));
        return PlatformRegistrationResult.tenant(
          _parseTenantAuthResult(
              data,
              data['tenantId'] as String? ??
                  data['spaceId'] as String? ??
                  context?['tenantId'] as String? ??
                  '',
              forcePersonal: personal),
          pendingApproval: data['pendingApproval'] as bool? ?? false,
        );
      }
      final platformToken = data['platformToken'] as String?;
      if (platformToken == null || platformToken.trim().isEmpty) {
        throw ServerError(
          code: 'REGISTER_PLATFORM_TOKEN_MISSING',
          message: '注册失败：未返回平台凭证',
          requestId: envelope.requestId,
        );
      }
      final deviceSession = data['deviceSession'] as Map<String, dynamic>?;
      return PlatformRegistrationResult.platform(
        platformToken: platformToken,
        platformUserId: data['platformUserId'] as String?,
        platformRefreshToken: data['platformRefreshToken'] as String?,
        deviceSessionToken: deviceSession?['deviceSessionToken'] as String?,
        pendingApproval: data['pendingApproval'] as bool? ?? false,
      );
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

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
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/auth/register',
        options: Options(headers: {'X-Tenant-Id': tenantIdOrCode}),
        data: {
          if (loginName?.isNotEmpty == true) 'loginName': loginName,
          'password': password,
          'displayName': displayName,
          'loginType': loginType,
          if (email != null) 'email': email,
          if (mobile != null) 'mobile': mobile,
          if (verificationCode != null) 'verificationCode': verificationCode,
          if (captchaToken != null) 'captchaToken': captchaToken,
          if (captchaAnswer != null) 'captchaAnswer': captchaAnswer,
        },
      );
      ApiResponse<Map<String, dynamic>>.fromJson(
        response.data!,
        (json) => Map<String, dynamic>.from(json as Map),
      ).getDataOrThrow();
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  @override
  Future<TenantIdentitySnapshot> getTenantIdentity(String accessToken) async {
    try {
      final client = Dio(BaseOptions(
        baseUrl: _dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
      client.httpClientAdapter = _dio.httpClientAdapter;
      final response = await client.get<Map<String, dynamic>>(
        '/api/client/v1/profile/me',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        }),
      );
      final envelope = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data!,
        (json) => Map<String, dynamic>.from(json as Map),
      );
      final data = envelope.getDataOrThrow();
      return TenantIdentitySnapshot(
        userId: data['userId'] as String? ?? '',
        platformUserId: _authenticatedPlatformUserId(data, accessToken),
        verifiedSpaceId: _authenticatedSpaceId(data, accessToken),
        userType: data['userType'] as int?,
      );
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  static String? _authenticatedSpaceId(
      Map<String, dynamic> profile, String serverAcceptedToken) {
    String text(Object? value) => value is String ? value.trim() : '';
    final context = profile['spaceContext'] is Map
        ? profile['spaceContext'] as Map
        : const {};
    final type = context['spaceType'];
    if (type != null && type.toString() == '1') return 'personal';
    final profileSpace = text(profile['spaceId']).isNotEmpty
        ? text(profile['spaceId'])
        : text(profile['tenantId']).isNotEmpty
            ? text(profile['tenantId'])
            : text(context['tenantId']);
    if (type != null && profileSpace == 'personal') {
      return '__contradictory_space__';
    }
    if (profileSpace.isNotEmpty) return profileSpace;
    if (type != null) return '__unresolved_nonpersonal_space__';
    try {
      final parts = serverAcceptedToken.split('.');
      if (parts.length != 3) return null;
      final claims = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      if (claims is! Map<String, dynamic>) return null;
      final claimType = claims['space_type'];
      final tenant = text(claims['tenant_id']);
      if (claimType == null && tenant.isEmpty) return null;
      final subject = text(claims[
          'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']);
      if (subject.isEmpty || subject != text(profile['userId'])) {
        return '__unbound_bearer_space__';
      }
      if (claimType?.toString() == '1') return 'personal';
      if (claimType != null && tenant == 'personal') {
        return '__contradictory_space__';
      }
      return tenant.isNotEmpty ? tenant : '__unresolved_nonpersonal_space__';
    } catch (_) {
      return null;
    }
  }

  /// The live profile contract omits platformUserId. Only after the server has
  /// accepted this exact bearer token may its identity claims fill that gap.
  /// Binding the token's user claim to profile/me prevents a host-provided ID
  /// from becoming an alternative identity authority. Opaque tokens remain
  /// supported when the authoritative profile supplies both identity fields.
  static String _authenticatedPlatformUserId(
      Map<String, dynamic> profile, String serverAcceptedToken) {
    final explicitId = (profile['platformUserId'] as String?)?.trim() ?? '';
    if (explicitId.isNotEmpty) return explicitId;
    try {
      final parts = serverAcceptedToken.split('.');
      if (parts.length != 3) throw const FormatException();
      final claims = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      if (claims is! Map<String, dynamic>) throw const FormatException();
      final userId = claims[
          'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
      final platformId = claims['platform_user_id'];
      if (userId is String &&
          userId.isNotEmpty &&
          userId == profile['userId'] &&
          platformId is String &&
          platformId.trim().isNotEmpty) {
        return platformId.trim();
      }
    } catch (_) {
      // Do not include the token or decoded claims in diagnostics/errors.
    }
    throw const ServerError(
        code: 'AUTH_EXTERNAL_IDENTITY_MISMATCH', message: '服务端身份响应与已认证凭证无法关联');
  }

  @override
  Future<TenantFriendMode> getTenantFriendMode(String accessToken) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/tenant/features',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final data = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data!,
        (json) => Map<String, dynamic>.from(json as Map),
      ).getDataOrThrow();
      final mode = data['friendMode'] as String?;
      return mode == 'social'
          ? TenantFriendMode.social
          : TenantFriendMode.isolation;
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  @override
  Future<int> getTenantMembershipRole({
    required String userId,
    required String accessToken,
  }) async {
    if (userId.isEmpty || accessToken.isEmpty) return 0;
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/tenant/members',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final members = ApiResponse<List<dynamic>>.fromJson(
        response.data!,
        (json) => List<dynamic>.from(json as List),
      ).getDataOrThrow();
      for (final item in members.whereType<Map<String, dynamic>>()) {
        if (item['userId'] == userId) {
          return item['membershipRole'] as int? ?? 0;
        }
      }
      return 0;
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  @override
  Future<PlatformLoginResult> login(LoginRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/platform/v1/auth/login',
        options: Options(extra: const {
          'publicAuthRequest': true,
          'skipDiagnosticsLog': true,
        }),
        data: {
          'identifier': request.identifier,
          'password': request.password,
          'loginType': request.loginType,
          if (request.captchaToken != null)
            'captchaToken': request.captchaToken,
          if (request.captchaAnswer != null)
            'captchaAnswer': request.captchaAnswer,
          ..._durableSessionRequestData(request),
        },
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => _parsePlatformLoginResult(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<PlatformLoginResult> loginByCode(LoginRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/platform/v1/auth/login-by-code',
        options: Options(extra: const {
          'publicAuthRequest': true,
          'skipDiagnosticsLog': true,
        }),
        data: {
          'identifier': request.identifier,
          'verificationCode': request.verificationCode,
          'loginType': request.loginType,
          if (request.captchaToken != null)
            'captchaToken': request.captchaToken,
          if (request.captchaAnswer != null)
            'captchaAnswer': request.captchaAnswer,
        },
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => _parsePlatformLoginResult(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<AuthVerificationSettings> getVerificationSettings() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/platform/v1/auth/verification/settings',
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) {
          final data = json as Map<String, dynamic>;
          return AuthVerificationSettings(
            smsEnabled: data['smsEnabled'] as bool? ?? false,
            emailEnabled: data['emailEnabled'] as bool? ?? false,
            smsRequired: data['smsRequired'] as bool? ?? false,
            emailRequired: data['emailRequired'] as bool? ?? false,
          );
        },
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<AuthCaptchaChallenge> generateCaptcha() async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/auth/captcha/generate',
        options: Options(extra: const {'publicAuthRequest': true}),
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data!,
        (json) => Map<String, dynamic>.from(json as Map),
      );
      final data = apiResponse.getDataOrThrow();
      final token = (data['token'] as String?)?.trim() ?? '';
      final question = ((data['question'] as String?) ??
              (data['captchaQuestion'] as String?))
          ?.trim();
      if (token.isEmpty || question == null || question.isEmpty) {
        throw ServerError(
          code: 'AUTH_CAPTCHA_CHALLENGE_INVALID',
          message: '图形验证码数据无效',
          requestId: apiResponse.requestId,
        );
      }
      return AuthCaptchaChallenge(token: token, question: question);
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> sendVerificationCode({
    required String identifier,
    required String channel,
    required String purpose,
    String? captchaToken,
    String? captchaAnswer,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/platform/v1/auth/verification/send',
        data: {
          'identifier': identifier,
          'channel': channel,
          'purpose': purpose,
          if (captchaToken != null) 'captchaToken': captchaToken,
          if (captchaAnswer != null) 'captchaAnswer': captchaAnswer,
        },
      );
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data!,
        (json) => Map<String, dynamic>.from(json as Map),
      );
      if (!apiResponse.isSuccess) {
        throw ErrorHandler.fromServerCode(
          apiResponse.code,
          apiResponse.message,
          requestId: apiResponse.requestId,
        );
      }
      final result = apiResponse.data;
      if (result == null || result['sent'] != true) {
        throw ServerError(
          code: 'VERIFICATION_SEND_FAILED',
          message: result?['error'] as String? ?? '验证码发送失败，请稍后重试',
          requestId: apiResponse.requestId,
        );
      }
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> resetPlatformPassword({
    required String identifier,
    required String verificationCode,
    required String newPassword,
    required String loginType,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/auth/reset-password',
        data: {
          'identifier': identifier.trim(),
          'verificationCode': verificationCode.trim(),
          'newPassword': newPassword,
          'loginType': loginType,
        },
      );
      ApiResponse<Map<String, dynamic>>.fromJson(
        response.data!,
        (json) => Map<String, dynamic>.from(json as Map),
      ).getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/auth/change-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );
      ApiResponse<Map<String, dynamic>>.fromJson(
        response.data!,
        (json) => Map<String, dynamic>.from(json as Map),
      ).getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> leaveEnterprise(String accessToken) async {
    try {
      await _dio.post<void>(
        '/api/client/v1/tenant/leave',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<TenantAuthResult> selectPersonalSpace(String platformToken,
      {bool preserveReturnedSpace = false}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/platform/v1/auth/select-personal-space',
        options: Options(
          headers: {'Authorization': 'Bearer $platformToken'},
        ),
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) {
          final data = json as Map<String, dynamic>;
          if (!preserveReturnedSpace) {
            return _parseTenantAuthResult(data, 'personal',
                forcePersonal: true);
          }
          final context = data['spaceContext'] as Map<String, dynamic>?;
          final type = context?['spaceType'];
          final personal = type == 1 ||
              (type == null &&
                  (data['spaceId'] == 'personal' ||
                      data['tenantId'] == 'personal' ||
                      isLegacyPersonalTenantId(data['tenantId'] as String?)));
          return _parseTenantAuthResult(
              data,
              data['spaceId'] as String? ??
                  context?['tenantId'] as String? ??
                  (type == 2 ? '' : 'personal'),
              forcePersonal: personal);
        },
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<TenantAuthResult> selectTenant(
      String tenantId, String platformToken) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/platform/v1/auth/select-tenant',
        data: {'tenantId': tenantId},
        options: Options(
          headers: {'Authorization': 'Bearer $platformToken'},
        ),
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) =>
            _parseTenantAuthResult(json as Map<String, dynamic>, tenantId),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<TenantAuthResult> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/auth/refresh',
        // The switching owner handles an invalid stored-space ticket. It must
        // not renew or log out the currently active space through an interceptor.
        options: Options(extra: const {
          'publicAuthRequest': true,
          'skipDiagnosticsLog': true,
        }),
        data: {'refreshToken': refreshToken},
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) =>
            _parseTenantAuthResultFromRefresh(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Parsers
  // ---------------------------------------------------------------------------

  PlatformLoginResult _parsePlatformLoginResult(Map<String, dynamic> json) {
    final tenantsList = (json['tenants'] as List<dynamic>? ?? [])
        .map((t) => t as Map<String, dynamic>)
        .where((tenant) =>
            !isLegacyPersonalTenantId(tenant['tenantId'] as String?))
        .map(_parseTenantSummary)
        .toList();

    // 解析 spaceContext（对照 API 文档 PlatformSpaceContextDto）
    final spaceCtx = json['spaceContext'] as Map<String, dynamic>?;
    final spaceType = spaceCtx?['spaceType'] as int? ?? 0;
    final suggestedTenantId = spaceCtx?['tenantId'] as String?;
    final deviceSession = json['deviceSession'] as Map<String, dynamic>?;

    return PlatformLoginResult(
      platformToken: json['platformToken'] as String,
      platformUserId: json['platformUserId'] as String,
      lppId: json['lppId'] as String?,
      displayName: json['displayName'] as String?,
      userType: json['userType'] as int?,
      expiresIn: json['expiresIn'] as int? ?? 3600,
      tenants: tenantsList,
      platformRefreshToken: json['platformRefreshToken'] as String?,
      platformRefreshTokenExpiresAt:
          json['platformRefreshTokenExpiresAt'] as String?,
      deviceSessionToken: deviceSession?['deviceSessionToken'] as String?,
      deviceSessionInactiveExpiresAt:
          deviceSession?['inactiveExpiresAt'] as String?,
      spaceType: spaceType,
      suggestedTenantId: suggestedTenantId,
      pendingApproval: json['pendingApproval'] as bool? ?? false,
      accountStatus: json['accountStatus'] as String? ?? 'active',
    );
  }

  TenantSummary _parseTenantSummary(Map<String, dynamic> json) {
    return TenantSummary(
      tenantId: json['tenantId'] as String,
      tenantName: json['tenantName'] as String,
      tenantCode: json['tenantCode'] as String?,
      logoUrl: (json['logoUrl'] as String?)?.isNotEmpty == true
          ? json['logoUrl'] as String
          : null,
      membershipRole: json['membershipRole'] as int? ?? 0,
    );
  }

  TenantAuthResult _parseTenantAuthResult(
    Map<String, dynamic> json,
    String fallbackTenantId, {
    bool forcePersonal = false,
  }) {
    final spaceCtx = json['spaceContext'] as Map<String, dynamic>?;
    final spaceType = spaceCtx?['spaceType'] as int?;
    final rawTenantId = json['tenantId'] as String? ?? fallbackTenantId;
    final spaceId =
        forcePersonal || spaceType == 1 ? 'personal' : rawTenantId.trim();
    return TenantAuthResult(
      spaceId: spaceId,
      userId: json['userId'] as String? ?? '',
      platformUserId: json['platformUserId'] as String?,
      lppId: json['lppId'] as String?,
      displayName: json['displayName'] as String?,
      tenantName: json['tenantName'] as String?,
      userType: json['userType'] as int?,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int? ?? 3600,
      spaceType: spaceType,
    );
  }

  TenantAuthResult _parseTenantAuthResultFromRefresh(
    Map<String, dynamic> json, {
    String? fallbackTenantName,
  }) {
    final responseTenantName = (json['tenantName'] as String?)?.trim();
    return TenantAuthResult(
      spaceId:
          (json['spaceContext'] as Map<String, dynamic>?)?['spaceType'] == 1
              ? 'personal'
              : json['tenantId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      platformUserId: json['platformUserId'] as String?,
      lppId: json['lppId'] as String?,
      displayName: json['displayName'] as String?,
      tenantName: responseTenantName?.isNotEmpty == true
          ? responseTenantName
          : fallbackTenantName,
      userType: json['userType'] as int?,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: json['expiresIn'] as int? ?? 3600,
      spaceType:
          (json['spaceContext'] as Map<String, dynamic>?)?['spaceType'] as int?,
    );
  }

  @override
  Future<TenantAuthResult> tenantLogin(LoginRequest request) async {
    try {
      // ztId/login_name/lpp_id 租户登录需要显式租户上下文。
      // 服务端同时支持 header X-Tenant-Id、body.tenantId、body.tenantCode；
      // 未登录场景下 tenants/search 可能 401，所以必须保留原始 tenantCode 到 body。
      final rawTenant = request.tenantCode?.trim();
      String? headerTenantId;
      String? tenantIdForBody;
      String? tenantCodeForBody;
      String? resolvedTenantName;
      if (rawTenant != null && rawTenant.isNotEmpty) {
        final isGuid = RegExp(
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
        ).hasMatch(rawTenant);
        if (isGuid) {
          tenantIdForBody = rawTenant;
          headerTenantId = rawTenant;
        } else {
          tenantCodeForBody = rawTenant;
        }
        if (!isGuid) {
          // 是 tenantCode，搜索对应的 tenantId
          try {
            final searchResp = await _dio.get<Map<String, dynamic>>(
              '/api/platform/v1/tenants/search',
              queryParameters: {'keyword': rawTenant},
              options: Options(extra: const {
                'publicAuthRequest': true,
                'skipDiagnosticsLog': true,
              }),
            );
            final list = searchResp.data?['data'] as List<dynamic>? ?? [];
            final normalizedTenant = rawTenant.toLowerCase();
            final candidates =
                list.whereType<Map<String, dynamic>>().toList(growable: false);
            final exactMatches = candidates.where((tenant) {
              final code =
                  (tenant['tenantCode'] as String? ?? '').trim().toLowerCase();
              return code == normalizedTenant;
            }).toList(growable: false);
            // A fuzzy search result cannot change the host's fixed tenant.
            // Without one exact match, let login resolve the original code.
            final match = exactMatches.length == 1 ? exactMatches.single : null;
            if (match != null) {
              tenantIdForBody = match['tenantId'] as String?;
              headerTenantId = tenantIdForBody;
              final tenantName = (match['tenantName'] as String?)?.trim();
              if (tenantName != null && tenantName.isNotEmpty) {
                resolvedTenantName = tenantName;
              }
            }
          } catch (_) {
            // 搜索失败，继续用原值
          }
        }
      }

      final extraHeaders = headerTenantId != null && headerTenantId.isNotEmpty
          ? {'X-Tenant-Id': headerTenantId}
          : <String, String>{};
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/auth/login',
        options: Options(headers: extraHeaders, extra: const {
          'publicAuthRequest': true,
          'skipDiagnosticsLog': true,
        }),
        data: {
          'loginName': request.identifier,
          'password': request.password,
          'loginType': request.loginType,
          'deviceType': _clientDeviceType(),
          if (tenantIdForBody != null && tenantIdForBody.isNotEmpty)
            'tenantId': tenantIdForBody,
          if (tenantCodeForBody != null && tenantCodeForBody.isNotEmpty)
            'tenantCode': tenantCodeForBody,
          if (request.captchaToken != null)
            'captchaToken': request.captchaToken,
          if (request.captchaAnswer != null)
            'captchaAnswer': request.captchaAnswer,
        },
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => _parseTenantAuthResultFromRefresh(
          json as Map<String, dynamic>,
          fallbackTenantName: resolvedTenantName,
        ),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<List<TenantSummary>> getMyTenants(String platformToken) async {
    // 直接用主 Dio 实例，TokenInterceptor 会自动处理 platformToken 注入和刷新
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/platform/v1/my/tenants',
        options: Options(headers: {
          'Authorization': 'Bearer $platformToken',
        }),
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) {
          final list = json as List<dynamic>;
          return list
              .map((t) => t as Map<String, dynamic>)
              .where((tenant) =>
                  !isLegacyPersonalTenantId(tenant['tenantId'] as String?))
              .map(_parseTenantSummary)
              .toList();
        },
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<PlatformLoginResult> refreshPlatformToken(String platformToken) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/platform/v1/auth/refresh-platform-token',
        options: Options(headers: {'Authorization': 'Bearer $platformToken'}),
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) {
          final j = json as Map<String, dynamic>;
          // refresh-platform-token 只返回 platformToken 相关字段，不含 tenants
          return PlatformLoginResult(
            platformToken: j['platformToken'] as String,
            platformUserId: j['platformUserId'] as String? ?? '',
            lppId: j['lppId'] as String?,
            displayName: j['displayName'] as String?,
            expiresIn: j['expiresIn'] as int? ?? 3600,
            tenants: const [],
            spaceType: 0,
          );
        },
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  static String _clientDeviceType() => AppPlatformInfo.clientDeviceType;

  static Map<String, dynamic> _durableSessionRequestData(
    LoginRequest request,
  ) {
    return {
      if (request.issueRefreshToken) 'issueRefreshToken': true,
      if (request.trustDevice) 'trustDevice': true,
      if (request.deviceId != null) 'deviceId': request.deviceId,
      if (request.deviceName != null) 'deviceName': request.deviceName,
      if (request.devicePlatform != null)
        'devicePlatform': request.devicePlatform,
      if (request.deviceModel != null) 'deviceModel': request.deviceModel,
      if (request.appVersion != null) 'appVersion': request.appVersion,
    };
  }
}
