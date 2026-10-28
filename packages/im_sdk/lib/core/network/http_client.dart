import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/diagnostics/diagnostic_http_interceptor.dart';
import 'package:im_sdk/core/network/error_handler.dart';
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
    )? onTenantTokenRefreshed,
    bool Function()? operationIsCurrent,
    DiagnosticScope Function()? diagnosticScope,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: HttpClient.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

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
      allowLegacyCredentialFallback: allowLegacyCredentialFallback,
      persistLegacyCredentialMirror: persistLegacyCredentialMirror,
      onAuthFailed: onAuthFailed,
      onPlatformTokenRefreshed: onPlatformTokenRefreshed,
      onTenantTokenRefreshed: onTenantTokenRefreshed,
      operationIsCurrent: operationIsCurrent,
    );
    _siteLineFence = SiteLineRequestFence(
      manager: SiteLineManager.instance,
      baseUrl: () => HttpClient.baseUrl,
    );
    dio.interceptors.addAll([
      DiagnosticRequestScopeInterceptor(
          diagnosticScope ?? () => AppDiagnostics.instance.activeScope),
      _siteLineFence,
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

  Future<void> invalidatePlatformSession() =>
      _tokenInterceptor.invalidatePlatformSession();

  void activatePlatformSession() => _tokenInterceptor.activatePlatformSession();

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
/// 3. refresh 失败 → 清除 Token，抛出 AuthError
///
/// 并发安全：使用 [Completer] 队列化刷新期间的其他请求，避免多次并发刷新。
class TokenInterceptor extends Interceptor {
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
  )? onTenantTokenRefreshed;
  final bool Function()? _operationIsCurrent;
  final bool _allowLegacyCredentialFallback;
  final bool _persistLegacyCredentialMirror;

  bool _isRefreshing = false;
  Future<String>? _platformRefreshFuture;
  int _platformSessionGeneration = 0;
  bool _platformSessionInvalidated = false;
  final List<_PendingRequest> _pendingQueue = [];

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
    bool allowLegacyCredentialFallback = true,
    bool persistLegacyCredentialMirror = true,
    this.onAuthFailed,
    this.onPlatformTokenRefreshed,
    this.onTenantTokenRefreshed,
    bool Function()? operationIsCurrent,
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

    // 判断是平台级 API 还是租户级 API
    final isPlatformApi = options.path.startsWith('/api/platform/v1/');

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

    // 防止刷新请求本身触发无限循环
    if (options.extra['_isRetry'] == true) {
      await _clearTokensAndFail(handler, err);
      return;
    }

    // 判断是平台级 API 还是租户级 API
    final isPlatformApi = options.path.startsWith('/api/platform/v1/');

    if (_isRefreshing) {
      // 已有刷新在进行中，将当前请求加入等待队列
      final completer = Completer<Response<dynamic>>();
      _pendingQueue
          .add(_PendingRequest(options: options, completer: completer));
      try {
        final response = await completer.future;
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
      return;
    }

    _isRefreshing = true;

    try {
      if (isPlatformApi) {
        // 刷新 platformToken
        await _refreshPlatformToken();
      } else {
        // 刷新 accessToken
        await _refreshToken();
      }
      // 刷新成功，重放原始请求
      final response = await _retry(options);
      // 通知队列中的等待请求
      _resolveQueue();
      handler.resolve(response);
    } catch (e) {
      _rejectQueue();
      _logRenewalFailure(
        diagnosticScope:
            options.extra[DiagnosticRequestScopeInterceptor.scopeKey]
                as DiagnosticScope?,
        domain: isPlatformApi ? 'platform' : 'tenant',
        endpoint: options.path,
        method: options.method,
        error: e,
      );
      // 只有 AuthError（refreshToken 真正失效）才清除 token 并踢回登录页
      // 网络错误等情况不清除 token，避免误踢用户
      if (e is AuthError) {
        await _clearTokensAndFail(handler, err, failure: e);
      } else {
        // 网络问题：直接把原始错误传递下去，不清除 token
        handler.next(err);
      }
    } finally {
      _isRefreshing = false;
    }
  }

  // -------------------------------------------------------------------------
  // 内部辅助方法
  // -------------------------------------------------------------------------

  /// 调用 /auth/refresh 换取新 Token，并写入 SecureStorage
  Future<void> _refreshToken() async {
    final sourceScope = _diagnosticScope?.call();
    _ensureOperationCurrent();
    final spaceId = _activeSpaceIdGetter?.call();
    if (spaceId == null) throw const AuthError('NO_ACTIVE_SPACE');

    final refreshToken = _refreshTokenGetter?.call();
    if (refreshToken == null) throw const AuthError('NO_REFRESH_TOKEN');

    // 使用独立 Dio 实例（不带拦截器）避免循环；继承 adapter 以支持测试注入
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: _dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    )..httpClientAdapter = _dio.httpClientAdapter;

    Response<Map<String, dynamic>> response;
    try {
      response = await refreshDio.post<Map<String, dynamic>>(
        '/api/client/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'_isRetry': true}),
      );
    } on DioException catch (e) {
      _logRenewalFailure(
        diagnosticScope: sourceScope,
        domain: 'tenant',
        endpoint: '/api/client/v1/auth/refresh',
        error: e,
      );
      // 只有服务端明确返回 401/403 才认为 refreshToken 失效
      // 网络超时、连接失败等不清除 token，避免误踢用户
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        // 降级：尝试用 platformToken 重新换取租户 token pair
        await _fallbackWithPlatformToken(spaceId);
        return; // 降级成功，正常返回
      }
      // 网络问题：抛出普通异常，不触发 onAuthFailed
      throw Exception('网络错误，刷新 token 失败');
    }

    final body = response.data;
    if (body == null) throw const AuthError('REFRESH_EMPTY_RESPONSE');

    final newAccessToken = body['data']?['accessToken'] as String?;
    final newRefreshToken = body['data']?['refreshToken'] as String?;

    if (newAccessToken == null || newRefreshToken == null) {
      throw const AuthError('REFRESH_INVALID_RESPONSE');
    }

    _ensureOperationCurrent();
    if (_persistLegacyCredentialMirror) {
      await _storage.writeTokenPair(
        spaceId: spaceId,
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );
    }

    _ensureOperationCurrent();
    await onTenantTokenRefreshed?.call(
      spaceId,
      newAccessToken,
      newRefreshToken,
    );
  }

  /// 使用 platformToken 调用 selectTenant 降级换取新的租户 token pair
  ///
  /// 当 refreshToken 失效（401/403）时调用此方法作为降级路径。
  /// 成功后写入当前 Session 凭证并通知认证 Owner，调用方正常返回。
  /// 失败时抛 AuthError，触发登出流程。
  Future<void> _fallbackWithPlatformToken(String spaceId) async {
    _ensureOperationCurrent();
    final platformToken = _platformTokenGetter?.call() ??
        (_allowLegacyCredentialFallback
            ? await _storage.read(SecureStorageService.platformTokenKey)
            : null);
    if (platformToken == null || platformToken.isEmpty) {
      throw const AuthError('NO_PLATFORM_TOKEN');
    }

    final fallbackDio = Dio(
      BaseOptions(
        baseUrl: _dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    )..httpClientAdapter = _dio.httpClientAdapter;

    try {
      final String endpoint;
      final Map<String, dynamic> requestData;

      if (spaceId == 'personal') {
        // 个人空间用 select-personal-space，不需要 tenantId
        endpoint = '/api/platform/v1/auth/select-personal-space';
        requestData = {};
      } else {
        // 租户空间用 select-tenant
        endpoint = '/api/platform/v1/auth/select-tenant';
        requestData = {'tenantId': spaceId};
      }

      final response = await fallbackDio.post<Map<String, dynamic>>(
        endpoint,
        data: requestData.isEmpty ? null : requestData,
        options: Options(
          headers: {'Authorization': 'Bearer $platformToken'},
          extra: {'_isRetry': true},
        ),
      );

      final body = response.data;
      final newAccessToken = body?['data']?['accessToken'] as String?;
      final newRefreshToken = body?['data']?['refreshToken'] as String?;

      if (newAccessToken == null || newRefreshToken == null) {
        throw const AuthError('PLATFORM_TOKEN_EXPIRED');
      }

      _ensureOperationCurrent();
      if (_persistLegacyCredentialMirror) {
        await _storage.writeTokenPair(
          spaceId: spaceId,
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
      }
      _ensureOperationCurrent();
      await onTenantTokenRefreshed?.call(
        spaceId,
        newAccessToken,
        newRefreshToken,
      );
    } catch (e) {
      if (e is AuthError) rethrow;
      throw const AuthError('PLATFORM_TOKEN_EXPIRED');
    }
  }

  Future<void> _refreshPlatformToken() async {
    await refreshPlatformSession();
  }

  /// 续期平台会话。
  ///
  /// 顺序固定为轮换 refresh token → 可信设备会话 → 旧版 JWT 兼容接口。
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

  Future<String> _renewPlatformSession(int generation) async {
    final refreshToken = _platformRefreshTokenGetter?.call() ??
        (_allowLegacyCredentialFallback
            ? await _storage.read(SecureStorageService.platformRefreshTokenKey)
            : null);
    final deviceSessionToken = _deviceSessionTokenGetter?.call() ??
        (_allowLegacyCredentialFallback
            ? await _storage.read(SecureStorageService.deviceSessionTokenKey)
            : null);
    final hasDurableCredential = (refreshToken?.isNotEmpty ?? false) ||
        (deviceSessionToken?.isNotEmpty ?? false);

    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        return await _renewByRefreshToken(refreshToken, generation);
      } on AuthError catch (error) {
        if (error.code == 'REFRESH_TOKEN_REUSE_DETECTED') {
          rethrow;
        }
        // Refresh token 被撤销或过期时，继续使用可信设备会话恢复。
      }
    }

    if (deviceSessionToken != null && deviceSessionToken.isNotEmpty) {
      return _renewByDeviceSession(deviceSessionToken, generation);
    }

    if (hasDurableCredential) {
      throw const AuthError('PLATFORM_SESSION_EXPIRED');
    }

    // 升级前创建的旧会话没有长期凭证。JWT 仍有效时沿用兼容接口；JWT 已
    // 过期时仅让平台请求失败，不清除仍可刷新的租户会话。
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
      throw const _LegacyPlatformSessionExpired();
    }
    try {
      final data = await _postPlatformRenewal(
        '/api/platform/v1/auth/refresh-platform-token',
        authorizationToken: platformToken,
      );
      return _persistLegacyPlatformRenewal(data, generation);
    } on AuthError {
      throw const _LegacyPlatformSessionExpired();
    }
  }

  Future<Map<String, dynamic>> _postPlatformRenewal(
    String path, {
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
      ),
    )..httpClientAdapter = _dio.httpClientAdapter;

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
      final responseData = body?['data'];
      if (responseData is Map<String, dynamic>) return responseData;
      final code = body?['code']?.toString() ?? 'REFRESH_INVALID_RESPONSE';
      throw AuthError(code);
    } catch (error) {
      _logRenewalFailure(
        diagnosticScope: sourceScope,
        domain: 'platform',
        endpoint: path,
        error: error,
        traceId: traceId,
        elapsedMs: stopwatch.elapsedMilliseconds,
      );
      if (error is! DioException) rethrow;
      if (error.response?.statusCode == 401 ||
          error.response?.statusCode == 403) {
        final body = error.response?.data;
        final code =
            body is Map<String, dynamic> ? body['code']?.toString() : null;
        throw AuthError(code ?? 'PLATFORM_SESSION_EXPIRED');
      }
      throw Exception('网络错误，平台会话续期失败');
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
    );
  }

  /// 刷新成功后，重放队列中所有等待的请求
  void _resolveQueue() {
    for (final pending in _pendingQueue) {
      _retry(pending.options).then(
        (response) => pending.completer.complete(response),
        onError: (e) => pending.completer.completeError(e),
      );
    }
    _pendingQueue.clear();
  }

  /// 刷新失败后，拒绝队列中所有等待的请求
  void _rejectQueue() {
    for (final pending in _pendingQueue) {
      pending.completer.completeError(
        const AuthError('TOKEN_REFRESH_FAILED'),
      );
    }
    _pendingQueue.clear();
  }

  /// 清除当前空间 Token 并将错误传递给 handler
  Future<void> _clearTokensAndFail(
    ErrorInterceptorHandler handler,
    DioException original, {
    AuthError? failure,
  }) async {
    _ensureOperationCurrent();
    final cause = failure ?? const AuthError('AUTH_RETRY_UNAUTHORIZED');
    final body = original.response?.data;
    AppDiagnostics.instance.warning(
      'auth.http_authentication_failed',
      'HTTP authentication failure requested account logout',
      scope: original
              .requestOptions.extra[DiagnosticRequestScopeInterceptor.scopeKey]
          as DiagnosticScope?,
      context: {
        'endpoint': original.requestOptions.uri.path,
        'method': original.requestOptions.method,
        'statusCode': original.response?.statusCode,
        'serverCode': cause.code,
        'requestId': body is Map ? body['requestId'] : null,
      },
    );
    // 通知 app 认证失败，触发重新登录
    onAuthFailed?.call(cause);
    handler.next(
      DioException(
        requestOptions: original.requestOptions,
        error: const AuthError('AUTH_INVALID_TOKEN'),
        type: DioExceptionType.badResponse,
        response: original.response,
      ),
    );
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

  void _ensureOperationCurrent() {
    if (_operationIsCurrent?.call() == false) {
      throw AccountOperationSuperseded();
    }
  }
}

// ---------------------------------------------------------------------------
// 内部数据结构
// ---------------------------------------------------------------------------

class _PendingRequest {
  final RequestOptions options;
  final Completer<Response<dynamic>> completer;

  const _PendingRequest({required this.options, required this.completer});
}

class _LegacyPlatformSessionExpired implements Exception {
  const _LegacyPlatformSessionExpired();
}

class _PlatformSessionInvalidated implements Exception {
  const _PlatformSessionInvalidated();
}
