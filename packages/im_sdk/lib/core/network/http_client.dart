import 'dart:async';
import 'dart:ui' show Locale;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/diagnostics/diagnostic_http_interceptor.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/network/client_locale_header.dart';
import 'package:im_sdk/core/network/site_line_manager.dart';
import 'package:im_sdk/core/network/site_line_request_fence.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';

// ---------------------------------------------------------------------------
// HttpClient
// ---------------------------------------------------------------------------

class HttpClient {
  /// 测试环境地址
  static String get baseUrl => SiteLineManager.instance.apiBaseUrl;

  late final Dio dio;
  late final TokenInterceptor _tokenInterceptor;
  late final VoidCallback _siteLineListener;
  late final SiteLineRequestFence _siteLineFence;
  var _closed = false;

  HttpClient({
    required SecureStorageService storage,
    String? Function()? tokenGetter,
    String? Function()? activeSpaceIdGetter,
    String? Function()? refreshTokenGetter,
    String? Function()? platformTokenGetter,
    String? Function()? platformRefreshTokenGetter,
    String? Function()? deviceSessionTokenGetter,
    Future<String> Function()? platformSessionRefresher,
    Future<void> Function()? tenantSessionRefresher,
    String? Function()? tenantSessionIdGetter,
    bool allowLegacyCredentialFallback = true,
    bool persistLegacyCredentialMirror = true,
    void Function(AuthError error)? onAuthFailed,
    FutureOr<void> Function(
            String newPlatformToken, String? newPlatformRefreshToken)?
        onPlatformTokenRefreshed,

    /// 租户 token 刷新成功后的回调（用于同步更新 authProvider state）
    FutureOr<void> Function(
      String spaceId,
      String newAccessToken,
      String newRefreshToken,
      int? expiresIn,
    )? onTenantTokenRefreshed,
    bool Function()? operationIsCurrent,
    DiagnosticScope Function()? diagnosticScope,
    Locale Function()? localeGetter,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: HttpClient.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    final localeHeader =
        localeGetter == null ? null : ClientLocaleHeader(localeGetter);
    _tokenInterceptor = TokenInterceptor(
      storage: storage,
      dio: dio,
      diagnosticScope:
          diagnosticScope ?? () => AppDiagnostics.instance.activeScope,
      tokenGetter: tokenGetter,
      activeSpaceIdGetter: activeSpaceIdGetter,
      refreshTokenGetter: refreshTokenGetter,
      platformTokenGetter: platformTokenGetter,
      platformRefreshTokenGetter: platformRefreshTokenGetter,
      deviceSessionTokenGetter: deviceSessionTokenGetter,
      platformSessionRefresher: platformSessionRefresher,
      tenantSessionRefresher: tenantSessionRefresher,
      tenantSessionIdGetter: tenantSessionIdGetter,
      allowLegacyCredentialFallback: allowLegacyCredentialFallback,
      persistLegacyCredentialMirror: persistLegacyCredentialMirror,
      onAuthFailed: onAuthFailed,
      onPlatformTokenRefreshed: onPlatformTokenRefreshed,
      onTenantTokenRefreshed: onTenantTokenRefreshed,
      operationIsCurrent: operationIsCurrent,
      localeHeader: localeHeader,
    );
    _siteLineFence = SiteLineRequestFence(
      manager: SiteLineManager.instance,
      baseUrl: () => HttpClient.baseUrl,
    );
    dio.interceptors.addAll([
      DiagnosticRequestScopeInterceptor(
          diagnosticScope ?? () => AppDiagnostics.instance.activeScope),
      _siteLineFence,
      if (localeHeader != null) localeHeader,
      _tokenInterceptor,
      DiagnosticHttpInterceptor(),
    ]);
    var observedRouteRevision = SiteLineManager.instance.routeRevision;
    _siteLineListener = () {
      if (observedRouteRevision == SiteLineManager.instance.routeRevision) {
        return;
      }
      observedRouteRevision = SiteLineManager.instance.routeRevision;
      dio.options.baseUrl = HttpClient.baseUrl;
    };
    SiteLineManager.instance.addListener(_siteLineListener);
  }

  Future<String> refreshPlatformSession() =>
      _tokenInterceptor.refreshPlatformSession();

  Future<void> refreshTenantSession() =>
      _tokenInterceptor.refreshTenantSession();

  Future<void> invalidatePlatformSession() =>
      _tokenInterceptor.invalidatePlatformSession();

  void activatePlatformSession() => _tokenInterceptor.activatePlatformSession();

  void fenceInFlightRenewals() => _tokenInterceptor.fenceInFlightRenewals();

  void close() {
    if (_closed) return;
    _closed = true;
    SiteLineManager.instance.removeListener(_siteLineListener);
    unawaited(_tokenInterceptor.invalidatePlatformSession());
    dio.close(force: true);
  }
}

// ---------------------------------------------------------------------------
// TokenInterceptor
// ---------------------------------------------------------------------------

/// 负责：
/// 1. 从 SecureStorage 读取当前空间的 accessToken，注入 Authorization header
/// 2. 捕获 401 → 调用 /auth/refresh → 重放原始请求
/// Platform and tenant renewal share in-flight work within their own scopes.
class TokenInterceptor extends Interceptor {
  static const _sessionIdKey = 'authActivationId';
  static const _routeRevisionKey = 'authRouteRevision';
  static const _activeTokenKey = 'authUsesActiveToken';
  final DiagnosticScope Function()? _diagnosticScope;
  final SecureStorageService _storage;
  final Dio _dio;
  final String? Function()? _tokenGetter;
  final String? Function()? _activeSpaceIdGetter;
  final String? Function()? _refreshTokenGetter;
  final String? Function()? _platformTokenGetter;
  final String? Function()? _platformRefreshTokenGetter;
  final String? Function()? _deviceSessionTokenGetter;
  final Future<String> Function()? _platformSessionRefresher;
  final Future<void> Function()? _tenantSessionRefresher;
  final String? Function()? _tenantSessionIdGetter;
  final ClientLocaleHeader? _localeHeader;

  /// 认证彻底失败时的回调（用于触发重新登录）
  final void Function(AuthError error)? onAuthFailed;

  /// platformToken 刷新成功后的回调（用于同步更新 authProvider state）
  final FutureOr<void> Function(
          String newPlatformToken, String? newPlatformRefreshToken)?
      onPlatformTokenRefreshed;

  /// 租户 token 刷新成功后的回调（用于同步更新 authProvider state）
  final FutureOr<void> Function(
    String spaceId,
    String newAccessToken,
    String newRefreshToken,
    int? expiresIn,
  )? onTenantTokenRefreshed;
  final bool Function()? _operationIsCurrent;
  final bool _allowLegacyCredentialFallback;
  final bool _persistLegacyCredentialMirror;

  Future<void>? _tenantRefreshFuture;
  (String, int)? _tenantRefreshScope;
  int _tenantRenewalGeneration = 0;
  Future<String>? _platformRefreshFuture;
  int _platformSessionGeneration = 0;
  bool _platformSessionInvalidated = false;

  TokenInterceptor({
    required SecureStorageService storage,
    DiagnosticScope Function()? diagnosticScope,
    required Dio dio,
    String? Function()? tokenGetter,
    String? Function()? activeSpaceIdGetter,
    String? Function()? refreshTokenGetter,
    String? Function()? platformTokenGetter,
    String? Function()? platformRefreshTokenGetter,
    String? Function()? deviceSessionTokenGetter,
    Future<String> Function()? platformSessionRefresher,
    Future<void> Function()? tenantSessionRefresher,
    String? Function()? tenantSessionIdGetter,
    bool allowLegacyCredentialFallback = true,
    bool persistLegacyCredentialMirror = true,
    this.onAuthFailed,
    this.onPlatformTokenRefreshed,
    this.onTenantTokenRefreshed,
    bool Function()? operationIsCurrent,
    ClientLocaleHeader? localeHeader,
  })  : _diagnosticScope = diagnosticScope,
        _storage = storage,
        _dio = dio,
        _tokenGetter = tokenGetter,
        _activeSpaceIdGetter = activeSpaceIdGetter,
        _refreshTokenGetter = refreshTokenGetter,
        _platformTokenGetter = platformTokenGetter,
        _platformRefreshTokenGetter = platformRefreshTokenGetter,
        _deviceSessionTokenGetter = deviceSessionTokenGetter,
        _platformSessionRefresher = platformSessionRefresher,
        _tenantSessionRefresher = tenantSessionRefresher,
        _tenantSessionIdGetter = tenantSessionIdGetter,
        _localeHeader = localeHeader,
        _allowLegacyCredentialFallback = allowLegacyCredentialFallback,
        _persistLegacyCredentialMirror = persistLegacyCredentialMirror,
        _operationIsCurrent = operationIsCurrent;

  // -------------------------------------------------------------------------
  // onRequest：注入 Token
  // -------------------------------------------------------------------------

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_operationIsCurrent?.call() == false) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: AccountOperationSuperseded(),
          type: DioExceptionType.cancel,
        ),
      );
      return;
    }
    // 非 FormData 请求才注入 Content-Type: application/json
    if (options.data is! FormData) {
      options.headers['Content-Type'] = 'application/json';
    }

    if (options.extra['publicAuthRequest'] == true) {
      handler.next(options);
      return;
    }

    final sessionId = _tenantSessionIdGetter?.call();
    final routeRevision = SiteLineManager.instance.routeRevision;
    if (options.extra.containsKey(_sessionIdKey) &&
        (options.extra[_sessionIdKey] != sessionId ||
            options.extra[_routeRevisionKey] != routeRevision)) {
      handler.reject(DioException(
        requestOptions: options,
        error: AccountOperationSuperseded(),
        type: DioExceptionType.cancel,
      ));
      return;
    }
    options.extra[_sessionIdKey] = sessionId;
    options.extra[_routeRevisionKey] = routeRevision;

    // 判断是平台级 API 还是租户级 API
    final isPlatformApi = options.path.startsWith('/api/platform/v1/');
    final explicitToken = options.headers['Authorization'];
    final activeToken =
        isPlatformApi ? _platformTokenGetter?.call() : _tokenGetter?.call();
    options.extra[_activeTokenKey] = explicitToken == null ||
        (activeToken != null && explicitToken == 'Bearer $activeToken');

    if (isPlatformApi) {
      // 平台级 API：注入 platformToken（如果请求已手动设置了 Authorization，不覆盖）
      if (!options.headers.containsKey('Authorization')) {
        final platformToken = _platformTokenGetter?.call() ??
            (_allowLegacyCredentialFallback
                ? await _storage.read(SecureStorageService.platformTokenKey)
                : null);
        if (platformToken != null && platformToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $platformToken';
        }
      }
    } else {
      // 租户级 API：注入 accessToken
      // 如果请求已手动设置了 Authorization，不覆盖（用于检测 userType 等场景）
      if (!options.headers.containsKey('Authorization')) {
        // 优先从内存（currentSpaceProvider）读 token，避免 SecureStorage 时序问题
        final memToken = _tokenGetter?.call();
        if (memToken != null && memToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $memToken';
        }
      }
    }
    if (!_isRequestCurrent(options)) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: AccountOperationSuperseded(),
          type: DioExceptionType.cancel,
        ),
      );
      return;
    }
    handler.next(options);
  }

  // -------------------------------------------------------------------------
  // onError：捕获 401，触发 Token 刷新
  // -------------------------------------------------------------------------

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      _ensureOperationCurrent();
    } on AccountOperationSuperseded catch (error) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: error,
          type: DioExceptionType.cancel,
        ),
      );
      return;
    }
    final isPublicAuthRequest =
        err.requestOptions.extra['publicAuthRequest'] == true ||
            err.requestOptions.extra['skipAuthHandling'] == true;
    if (isPublicAuthRequest) {
      handler.next(err);
      return;
    }
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final options = err.requestOptions;
    if (options.extra['_isRetry'] == true ||
        options.extra[_activeTokenKey] != true ||
        options.headers['Authorization'] == null ||
        !_isRequestCurrent(options)) {
      handler.next(err);
      return;
    }

    final isPlatformApi = options.path.startsWith('/api/platform/v1/');
    try {
      final currentToken =
          isPlatformApi ? _platformTokenGetter?.call() : _tokenGetter?.call();
      final alreadyRenewed = currentToken != null &&
          options.headers['Authorization'] != null &&
          options.headers['Authorization'] != 'Bearer $currentToken';
      if (!alreadyRenewed) {
        if (isPlatformApi) {
          await refreshPlatformSession();
        } else {
          await refreshTenantSession();
        }
      }
      _ensureOperationCurrent();
      if (!_isRequestCurrent(options)) {
        throw AccountOperationSuperseded();
      }
      handler.resolve(await _retry(options));
    } catch (error) {
      if (error is CredentialRenewalError &&
          error.failure != CredentialFailure.rejected &&
          _isRequestCurrent(options)) {
        _reportAuthenticationFailure(err, error);
      }
      // Propagate the renewal failure so callers can retry a transient outage.
      if (error is DioException) {
        handler.next(error.copyWith(requestOptions: options));
      } else {
        handler.next(err.copyWith(error: error));
      }
    }
  }

  // -------------------------------------------------------------------------
  // 内部辅助方法
  // -------------------------------------------------------------------------

  Future<void> refreshTenantSession() {
    _ensureOperationCurrent();
    final sharedRefresher = _tenantSessionRefresher;
    if (sharedRefresher != null) return sharedRefresher();

    final spaceId = _activeSpaceIdGetter?.call();
    if (spaceId == null) {
      return Future.error(const AuthError('NO_ACTIVE_SPACE'));
    }
    final sessionId = _tenantSessionIdGetter?.call() ?? spaceId;
    final routeRevision = SiteLineManager.instance.routeRevision;
    final credentialGeneration = _tenantRenewalGeneration;
    final scope = (sessionId, routeRevision);
    final inFlight = _tenantRefreshFuture;
    if (inFlight != null && _tenantRefreshScope == scope) return inFlight;
    final previousRoute =
        _tenantRefreshScope?.$1 == sessionId ? inFlight : null;
    void ensureCurrent() {
      _ensureOperationCurrent();
      if ((_tenantSessionIdGetter?.call() ?? _activeSpaceIdGetter?.call()) !=
              sessionId ||
          SiteLineManager.instance.routeRevision != routeRevision) {
        throw AccountOperationSuperseded();
      }
      if (credentialGeneration != _tenantRenewalGeneration) {
        throw AccountOperationSuperseded();
      }
    }

    Future<void> renew() async {
      if (previousRoute != null) {
        try {
          await previousRoute;
        } catch (_) {
          // Serialize rotation across route changes, even if the old one failed.
        }
      }
      await _renewTenantSession(spaceId, ensureCurrent);
    }

    late final Future<void> renewal;
    renewal = renew().whenComplete(() {
      if (identical(_tenantRefreshFuture, renewal)) {
        _tenantRefreshFuture = null;
        _tenantRefreshScope = null;
      }
    });
    _tenantRefreshFuture = renewal;
    _tenantRefreshScope = scope;
    return renewal;
  }

  Future<void> _renewTenantSession(
    String spaceId,
    void Function() ensureCurrent,
  ) async {
    ensureCurrent();
    final refreshToken = _refreshTokenGetter?.call();
    var tenantCredentialRejected = true;
    Map<String, dynamic>? body;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        body = await _postCredentialRequest(
          '/api/client/v1/auth/refresh',
          domain: 'tenant',
          data: {'refreshToken': refreshToken},
        );
      } on DioException catch (error) {
        ensureCurrent();
        final rejection = _credentialRejection(error);
        if (rejection?.failure == CredentialFailure.sessionRevoked) {
          throw rejection!;
        }
        tenantCredentialRejected = rejection != null;
        if (!tenantCredentialRejected && error.response?.statusCode != 401) {
          rethrow;
        }
      }
    }
    body ??= await _reissueTenantSession(
      spaceId,
      ensureCurrent,
      tenantCredentialRejected: tenantCredentialRejected,
    );
    final data = body['data'];
    final newAccessToken = data is Map ? data['accessToken'] : null;
    final newRefreshToken = data is Map ? data['refreshToken'] : null;
    final expiresIn = data is Map ? data['expiresIn'] : null;
    if (newAccessToken is! String ||
        newAccessToken.isEmpty ||
        newRefreshToken is! String ||
        newRefreshToken.isEmpty) {
      throw const AuthError('REFRESH_INVALID_RESPONSE');
    }
    ensureCurrent();
    if (_persistLegacyCredentialMirror) {
      await _storage.writeTokenPair(
        spaceId: spaceId,
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );
    }
    ensureCurrent();
    await onTenantTokenRefreshed?.call(
      spaceId,
      newAccessToken,
      newRefreshToken,
      expiresIn is int && expiresIn > 0 ? expiresIn : null,
    );
    ensureCurrent();
  }

  Future<Map<String, dynamic>> _reissueTenantSession(
    String spaceId,
    void Function() ensureCurrent, {
    required bool tenantCredentialRejected,
  }) async {
    final endpoint = spaceId == 'personal'
        ? '/api/platform/v1/auth/select-personal-space'
        : '/api/platform/v1/auth/select-tenant';
    Future<Map<String, dynamic>> selectSpace(String token) async {
      try {
        return await _postCredentialRequest(
          endpoint,
          domain: 'tenant',
          authorizationToken: token,
          data: spaceId == 'personal' ? null : {'tenantId': spaceId},
        );
      } on DioException catch (error) {
        final rejection = _credentialRejection(error);
        if (rejection?.failure == CredentialFailure.sessionRevoked) {
          throw rejection!;
        }
        rethrow;
      }
    }

    final platformToken = _platformTokenGetter?.call() ??
        (_allowLegacyCredentialFallback
            ? await _storage.read(SecureStorageService.platformTokenKey)
            : null);
    ensureCurrent();
    if (platformToken != null && platformToken.isNotEmpty) {
      try {
        return await selectSpace(platformToken);
      } on DioException catch (error) {
        // A 403 selecting an enterprise can be scoped to that enterprise.
        if (error.response?.statusCode != 401 &&
            _credentialRejection(error) == null) {
          rethrow;
        }
      }
    }

    ensureCurrent();
    final String renewedPlatformToken;
    try {
      renewedPlatformToken = await refreshPlatformSession();
    } on CredentialRenewalError catch (error) {
      ensureCurrent();
      if (error.failure != CredentialFailure.rejected ||
          !tenantCredentialRejected) {
        rethrow;
      }
      throw CredentialRenewalError(
        error.code,
        CredentialFailure.exhausted,
        statusCode: error.statusCode,
        requestId: error.requestId,
      );
    }
    ensureCurrent();
    return selectSpace(renewedPlatformToken);
  }

  /// 平台 refresh token 每次使用后都会轮换，因此这里必须串行化，避免并发
  /// 请求复用旧 token 并触发服务端的重放保护。
  Future<String> refreshPlatformSession() {
    final sharedRefresher = _platformSessionRefresher;
    if (sharedRefresher != null) {
      _ensureOperationCurrent();
      return sharedRefresher();
    }
    if (_platformSessionInvalidated) {
      return Future<String>.error(
        const _PlatformSessionInvalidated(),
      );
    }
    final inFlight = _platformRefreshFuture;
    if (inFlight != null) return inFlight;

    late final Future<String> renewal;
    final generation = _platformSessionGeneration;
    renewal = _renewPlatformSession(generation).whenComplete(() {
      if (identical(_platformRefreshFuture, renewal)) {
        _platformRefreshFuture = null;
      }
    });
    _platformRefreshFuture = renewal;
    return renewal;
  }

  Future<void> invalidatePlatformSession() async {
    final inFlight = _platformRefreshFuture;
    _platformSessionInvalidated = true;
    _platformSessionGeneration++;
    if (inFlight != null) {
      try {
        await inFlight;
      } catch (_) {}
    }
  }

  void activatePlatformSession() {
    _platformSessionInvalidated = false;
  }

  /// A verified host-issued pair supersedes renewal replies for its old pair.
  void fenceInFlightRenewals() {
    _platformSessionGeneration++;
    _tenantRenewalGeneration++;
    _platformRefreshFuture = null;
    _tenantRefreshFuture = null;
    _tenantRefreshScope = null;
  }

  Future<String> _renewPlatformSession(int generation) async {
    final refreshToken = _platformRefreshTokenGetter?.call() ??
        (_allowLegacyCredentialFallback
            ? await _storage.read(SecureStorageService.platformRefreshTokenKey)
            : null);
    final deviceSessionToken = _deviceSessionTokenGetter?.call() ??
        (_allowLegacyCredentialFallback
            ? await _storage.read(SecureStorageService.deviceSessionTokenKey)
            : null);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        return await _renewByRefreshToken(refreshToken, generation);
      } on CredentialRenewalError catch (error) {
        if (error.failure != CredentialFailure.rejected ||
            deviceSessionToken == null ||
            deviceSessionToken.isEmpty) {
          rethrow;
        }
      }
    }

    if (deviceSessionToken != null && deviceSessionToken.isNotEmpty) {
      return _renewByDeviceSession(deviceSessionToken, generation);
    }

    // 旧账号仍可通过当前 JWT 尝试兼容续期。
    return _renewLegacyPlatformToken(generation);
  }

  Future<String> _renewByRefreshToken(
    String refreshToken,
    int generation,
  ) async {
    final data = await _postPlatformRenewal(
      '/api/platform/v1/auth/refresh-platform-token-by-refresh-token',
      data: {'platformRefreshToken': refreshToken},
    );
    return _persistDurablePlatformRenewal(data, generation);
  }

  Future<String> _renewByDeviceSession(
    String deviceSessionToken,
    int generation,
  ) async {
    final data = await _postPlatformRenewal(
      '/api/platform/v1/auth/device-session/exchange',
      data: {
        'deviceSessionToken': deviceSessionToken,
        'issueRefreshToken': true,
      },
    );
    return _persistDurablePlatformRenewal(data, generation);
  }

  Future<String> _renewLegacyPlatformToken(int generation) async {
    final platformToken = _platformTokenGetter?.call() ??
        (_allowLegacyCredentialFallback
            ? await _storage.read(SecureStorageService.platformTokenKey)
            : null);
    if (platformToken == null || platformToken.isEmpty) {
      throw const CredentialRenewalError(
        'NO_PLATFORM_CREDENTIALS',
        CredentialFailure.rejected,
      );
    }
    final data = await _postPlatformRenewal(
      '/api/platform/v1/auth/refresh-platform-token',
      authorizationToken: platformToken,
    );
    return _persistLegacyPlatformRenewal(data, generation);
  }

  Future<Map<String, dynamic>> _postPlatformRenewal(
    String path, {
    Map<String, dynamic>? data,
    String? authorizationToken,
  }) async {
    final Map<String, dynamic> body;
    try {
      body = await _postCredentialRequest(
        path,
        domain: 'platform',
        data: data,
        authorizationToken: authorizationToken,
      );
    } on DioException catch (error) {
      final rejection = _credentialRejection(error);
      if (rejection != null) throw rejection;
      rethrow;
    }
    final responseData = body['data'];
    if (responseData is Map<String, dynamic>) return responseData;
    throw const AuthError('REFRESH_INVALID_RESPONSE');
  }

  CredentialRenewalError? _credentialRejection(DioException error) {
    final status = error.response?.statusCode;
    final body = error.response?.data;
    final code = body is Map ? body['code']?.toString() : null;
    final requestId = body is Map ? body['requestId']?.toString() : null;
    final isSecurityRejection = const {
      'AUTH_SESSION_REVOKED',
      'SESSION_REVOKED',
      'REFRESH_TOKEN_REUSE_DETECTED',
      'DEVICE_SESSION_REVOKED',
      'AUTH_ACCOUNT_DISABLED',
    }.contains(code);
    final isCredentialRejection = const {
      'AUTH_INVALID_TOKEN',
      'PLATFORM_TOKEN_EXPIRED',
      'PLATFORM_SESSION_EXPIRED',
      'REFRESH_TOKEN_EXPIRED',
      'REFRESH_TOKEN_NOT_FOUND',
      'PLATFORM_REFRESH_TOKEN_EXPIRED',
      'DEVICE_SESSION_EXPIRED',
      'DEVICE_SESSION_NOT_FOUND',
    }.contains(code);
    if ((status != 401 && status != 403) ||
        !(isSecurityRejection || isCredentialRejection)) {
      return null;
    }
    return CredentialRenewalError(
      code!,
      isSecurityRejection
          ? CredentialFailure.sessionRevoked
          : CredentialFailure.rejected,
      statusCode: status,
      requestId: requestId,
    );
  }

  Future<Map<String, dynamic>> _postCredentialRequest(
    String path, {
    required String domain,
    Map<String, dynamic>? data,
    String? authorizationToken,
  }) async {
    final sourceScope = _diagnosticScope?.call();
    final traceId = AppDiagnostics.instance.nextTraceId('auth-renewal');
    final stopwatch = Stopwatch()..start();
    final renewalDio = Dio(
      BaseOptions(
        baseUrl: _dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
        followRedirects: false,
      ),
    )..httpClientAdapter = _dio.httpClientAdapter;
    final localeHeader = _localeHeader;
    if (localeHeader != null) renewalDio.interceptors.add(localeHeader);
    try {
      final response = await renewalDio.post<Map<String, dynamic>>(
        path,
        data: data,
        options: Options(
          headers: {
            'X-Client-Trace-Id': traceId,
            if (authorizationToken != null)
              'Authorization': 'Bearer $authorizationToken',
          },
          extra: {'_isRetry': true, 'publicAuthRequest': true},
        ),
      );
      final body = response.data;
      if (body == null || body['code'] != 'OK') {
        throw AuthError(
            body?['code']?.toString() ?? 'REFRESH_INVALID_RESPONSE');
      }
      return body;
    } catch (error) {
      _logRenewalFailure(
        diagnosticScope: sourceScope,
        domain: domain,
        endpoint: path,
        error: error,
        traceId: traceId,
        elapsedMs: stopwatch.elapsedMilliseconds,
      );
      rethrow;
    }
  }

  Future<String> _persistDurablePlatformRenewal(
    Map<String, dynamic> data,
    int generation,
  ) async {
    _ensurePlatformSessionCurrent(generation);
    final platformToken = data['platformToken'] as String?;
    if (platformToken == null || platformToken.isEmpty) {
      throw const AuthError('REFRESH_INVALID_RESPONSE');
    }
    final platformRefreshToken = data['platformRefreshToken'] as String?;
    if (platformRefreshToken == null || platformRefreshToken.isEmpty) {
      throw const AuthError('REFRESH_INVALID_RESPONSE');
    }
    if (_persistLegacyCredentialMirror) {
      await _storage.writePlatformRenewal(
        platformToken: platformToken,
        platformRefreshToken: platformRefreshToken,
      );
    }
    _ensurePlatformSessionCurrent(generation);
    await onPlatformTokenRefreshed?.call(platformToken, platformRefreshToken);
    _ensurePlatformSessionCurrent(generation);
    return platformToken;
  }

  Future<String> _persistLegacyPlatformRenewal(
    Map<String, dynamic> data,
    int generation,
  ) async {
    _ensurePlatformSessionCurrent(generation);
    final platformToken = data['platformToken'] as String?;
    if (platformToken == null || platformToken.isEmpty) {
      throw const AuthError('REFRESH_INVALID_RESPONSE');
    }
    if (_persistLegacyCredentialMirror) {
      await _storage.write(
        SecureStorageService.platformTokenKey,
        platformToken,
      );
    }
    _ensurePlatformSessionCurrent(generation);
    await onPlatformTokenRefreshed?.call(platformToken, null);
    _ensurePlatformSessionCurrent(generation);
    return platformToken;
  }

  void _ensurePlatformSessionCurrent(int generation) {
    _ensureOperationCurrent();
    if (generation != _platformSessionGeneration) {
      throw const _PlatformSessionInvalidated();
    }
  }

  /// 重放原始请求（注入新 Token）
  Future<Response<dynamic>> _retry(RequestOptions options) async {
    _ensureOperationCurrent();
    // 判断是平台级 API 还是租户级 API
    final isPlatformApi = options.path.startsWith('/api/platform/v1/');

    String? token;
    if (isPlatformApi) {
      // 平台级 API：使用 platformToken
      token = _platformTokenGetter?.call() ??
          (_allowLegacyCredentialFallback
              ? await _storage.read(SecureStorageService.platformTokenKey)
              : null);
    } else {
      // 租户级 API：使用 accessToken
      token = _tokenGetter?.call();
    }

    final retryOptions = Options(
      method: options.method,
      headers: {
        ...options.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      extra: {...options.extra, '_isRetry': true},
      contentType: options.contentType,
      responseType: options.responseType,
      followRedirects: options.followRedirects,
      validateStatus: options.validateStatus,
    );

    _ensureOperationCurrent();
    return _dio.request<dynamic>(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: retryOptions,
      cancelToken: options.cancelToken,
    );
  }

  void _reportAuthenticationFailure(
    DioException original,
    CredentialRenewalError cause,
  ) {
    final body = original.response?.data;
    AppDiagnostics.instance.warning(
      'auth.http_authentication_failed',
      'Credential renewal reported account invalidation evidence',
      scope: original
              .requestOptions.extra[DiagnosticRequestScopeInterceptor.scopeKey]
          as DiagnosticScope?,
      context: {
        'endpoint': original.requestOptions.uri.path,
        'method': original.requestOptions.method,
        'statusCode': original.response?.statusCode,
        'serverCode': cause.code,
        'requestId':
            cause.requestId ?? (body is Map ? body['requestId'] : null),
      },
    );
    onAuthFailed?.call(cause);
  }

  void _logRenewalFailure({
    DiagnosticScope? diagnosticScope,
    required String domain,
    required String endpoint,
    required Object error,
    String method = 'POST',
    String? traceId,
    int? elapsedMs,
  }) {
    final response = error is DioException ? error.response : null;
    final body = response?.data;
    AppDiagnostics.instance.warning(
      'auth.renewal_failed',
      'Credential renewal failed',
      scope: diagnosticScope,
      context: {
        'credentialDomain': domain,
        'endpoint': endpoint,
        'method': method,
        'statusCode': response?.statusCode,
        'serverCode': error is AuthError
            ? error.code
            : body is Map
                ? body['code']
                : null,
        'requestId': body is Map ? body['requestId'] : null,
        'errorType': error.runtimeType.toString(),
        if (error is DioException) 'networkErrorType': error.type.name,
        if (traceId != null) 'traceId': traceId,
        if (elapsedMs != null) 'elapsedMs': elapsedMs,
      },
    );
  }

  bool _isRequestCurrent(RequestOptions options) =>
      _operationIsCurrent?.call() != false &&
      options.extra[_sessionIdKey] == _tenantSessionIdGetter?.call() &&
      options.extra[_routeRevisionKey] ==
          SiteLineManager.instance.routeRevision;

  void _ensureOperationCurrent() {
    if (_operationIsCurrent?.call() == false) {
      throw AccountOperationSuperseded();
    }
  }
}

class _PlatformSessionInvalidated implements Exception {
  const _PlatformSessionInvalidated();
}
