import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/diagnostics/diagnostic_http_interceptor.dart';
import 'package:im_sdk/core/network/http_client.dart';
import 'package:im_sdk/core/network/site_line_manager.dart';
import 'package:im_sdk/core/network/site_line_request_fence.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';

class AdminHttpClient {
  static String get adminBaseUrl => SiteLineManager.instance.adminBaseUrl;

  late final Dio dio;
  late final AdminTokenInterceptor _tokenInterceptor;
  late final VoidCallback _siteLineListener;
  late final SiteLineRequestFence _siteLineFence;
  var _closed = false;

  AdminHttpClient({
    required SecureStorageService storage,
    required SpaceContext? Function() spaceGetter,
    String? Function()? platformTokenGetter,
    String? Function()? credentialOwnerGetter,
    bool Function()? operationIsCurrent,
    DiagnosticScope Function()? diagnosticScope,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: AdminHttpClient.adminBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _tokenInterceptor = AdminTokenInterceptor(
      dio: dio,
      storage: storage,
      spaceGetter: spaceGetter,
      platformTokenGetter: platformTokenGetter,
      credentialOwnerGetter: credentialOwnerGetter,
      operationIsCurrent: operationIsCurrent,
    );
    _siteLineFence = SiteLineRequestFence(
      manager: SiteLineManager.instance,
      baseUrl: () => AdminHttpClient.adminBaseUrl,
    );
    dio.interceptors.add(DiagnosticRequestScopeInterceptor(
      diagnosticScope ?? () => AppDiagnostics.instance.activeScope));
    dio.interceptors.add(_siteLineFence);
    dio.interceptors.add(_tokenInterceptor);
    dio.interceptors.add(DiagnosticHttpInterceptor(prefix: 'admin_http'));
    var observedRouteRevision = SiteLineManager.instance.routeRevision;
    _siteLineListener = () {
      if (observedRouteRevision == SiteLineManager.instance.routeRevision) {
        return;
      }
      observedRouteRevision = SiteLineManager.instance.routeRevision;
      dio.options.baseUrl = AdminHttpClient.adminBaseUrl;
    };
    SiteLineManager.instance.addListener(_siteLineListener);
  }

  Future<bool> hasPermission(String permissionCode) {
    return _tokenInterceptor.hasPermission(permissionCode);
  }

  void close() {
    if (_closed) return;
    _closed = true;
    SiteLineManager.instance.removeListener(_siteLineListener);
    dio.close(force: true);
  }
}

class AdminTokenInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService storage;
  final SpaceContext? Function() spaceGetter;
  final String? Function()? platformTokenGetter;
  final String? Function()? credentialOwnerGetter;
  final bool Function()? operationIsCurrent;

  final Map<String, Completer<String>> _issueCompleters = {};

  AdminTokenInterceptor({
    required this.dio,
    required this.storage,
    required this.spaceGetter,
    this.platformTokenGetter,
    this.credentialOwnerGetter,
    this.operationIsCurrent,
  });

  Future<bool> hasPermission(String permissionCode) async {
    _assertCurrent();
    final space = _requireAdminSpace();
    await _adminAccessToken();
    final owner = _credentialOwner(space);
    final raw = await storage.read(
      SecureStorageService.adminPermissionCodesKey(owner),
    );
    return raw
            ?.split(',')
            .map((code) => code.trim())
            .where((code) => code.isNotEmpty)
            .contains(permissionCode) ??
        false;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      _assertCurrent();
      _assertRequestScope(options);
      if (!options.headers.containsKey('Authorization')) {
        final token = await _adminAccessToken();
        options.headers['Authorization'] = 'Bearer $token';
      }
      _assertRequestScope(options);
      if (!options.headers.containsKey('X-Device-Id')) {
        options.headers['X-Device-Id'] = await storage.stableDeviceId();
      }
      handler.next(options);
    } catch (error) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      _assertCurrent();
    } catch (_) {
      handler.next(err);
      return;
    }
    if (err.response?.statusCode != 401 ||
        err.requestOptions.extra['_adminRetry'] == true) {
      handler.next(err);
      return;
    }

    try {
      _assertRequestScope(err.requestOptions);
      final space = _requireAdminSpace();
      final token = await _refreshAdminToken(space.spaceId);
      _assertRequestScope(err.requestOptions);
      final retryOptions = err.requestOptions;
      retryOptions.extra['_adminRetry'] = true;
      retryOptions.headers['Authorization'] = 'Bearer $token';
      final response = await dio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }

  Future<String> _adminAccessToken() async {
    final space = _requireAdminSpace();
    final expectedScope = _tokenScope(space);
    final owner = _credentialOwner(space);
    final cached = await storage.readAdminAccessToken(owner);
    final cachedScope = await storage.readAdminTokenScope(owner);
    if (cached != null && cached.isNotEmpty && cachedScope == expectedScope) {
      return cached;
    }
    if ((cached != null && cached.isNotEmpty) || cachedScope != null) {
      await storage.clearAdminTokens(owner);
    }
    return _issueAdminToken(space);
  }

  SpaceContext _requireAdminSpace() {
    _assertCurrent();
    final space = spaceGetter();
    if (space == null || !space.isEmployee || space.spaceId.isEmpty) {
      throw StateError('当前角色不能调用管理后台接口');
    }
    return space;
  }

  Future<String> _issueAdminToken(SpaceContext space) async {
    final scope = _tokenScope(space);
    final owner = _credentialOwner(space);
    final existing = _issueCompleters[scope];
    if (existing != null) return existing.future;
    final completer = Completer<String>();
    _issueCompleters[scope] = completer;

    try {
      final platformToken = platformTokenGetter?.call();
      if (platformToken == null || platformToken.isEmpty) {
        throw StateError('缺少平台登录凭证，无法换取管理后台 Token');
      }

      final plainDio = _plainDio();
      final deviceId = await storage.stableDeviceId();
      final tokenResp = await plainDio.post<Map<String, dynamic>>(
        '/api/platform/v1/auth/admin-token',
        data: {'tenantId': space.spaceId},
        options: Options(headers: {
          'Authorization': 'Bearer $platformToken',
          'X-Device-Id': deviceId,
        }),
      );
      final data = tokenResp.data?['data'] as Map<String, dynamic>? ?? {};
      final accessToken = data['accessToken'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        throw StateError('管理后台 Token 响应缺少 accessToken 字段');
      }
      final currentSpace = _requireAdminSpace();
      if (_tokenScope(currentSpace) != scope) {
        throw StateError('管理后台 Token 签发期间账号或企业空间已切换');
      }
      _assertCurrent();
      await storage.write(
        SecureStorageService.adminAccessTokenKey(owner),
        accessToken,
      );
      final refreshToken = data['refreshToken'] as String?;
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await storage.write(
          SecureStorageService.adminRefreshTokenKey(owner),
          refreshToken,
        );
      } else {
        await storage.delete(
          SecureStorageService.adminRefreshTokenKey(owner),
        );
      }
      await storage.writeAdminTokenScope(owner, scope);
      await _writeAdminPermissionCache(owner, data);
      completer.complete(accessToken);
      return accessToken;
    } catch (e, st) {
      completer.future.catchError((_) => '');
      completer.completeError(e, st);
      rethrow;
    } finally {
      _issueCompleters.remove(scope);
    }
  }

  Future<String> _refreshAdminToken(String spaceId) async {
    final expectedSpace = _requireAdminSpace();
    if (expectedSpace.spaceId != spaceId) {
      throw StateError('管理后台 Token 刷新目标与当前企业空间不一致');
    }
    final expectedScope = _tokenScope(expectedSpace);
    final owner = _credentialOwner(expectedSpace);
    final refreshToken = await storage.readAdminRefreshToken(owner);
    if (refreshToken == null || refreshToken.isEmpty) {
      await storage.clearAdminTokens(owner);
      return _issueAdminToken(expectedSpace);
    }

    final refreshDio = _plainDio();
    final deviceId = await storage.stableDeviceId();
    try {
      final response = await refreshDio.post<Map<String, dynamic>>(
        '/api/client/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {
            'X-Tenant-Id': spaceId,
            'X-Device-Id': deviceId,
          },
          extra: {'_adminRetry': true},
        ),
      );
      final data = response.data?['data'] as Map<String, dynamic>? ?? {};
      final accessToken = data['accessToken'] as String?;
      final newRefreshToken = data['refreshToken'] as String?;
      if (accessToken == null ||
          accessToken.isEmpty ||
          newRefreshToken == null ||
          newRefreshToken.isEmpty) {
        throw StateError('管理后台刷新 Token 响应缺少 accessToken/refreshToken');
      }
      final currentSpace = _requireAdminSpace();
      if (_tokenScope(currentSpace) != expectedScope) {
        throw StateError('管理后台 Token 刷新期间账号或企业空间已切换');
      }
      _assertCurrent();
      await storage.writeAdminTokenPair(
        spaceId: owner,
        accessToken: accessToken,
        refreshToken: newRefreshToken,
      );
      await storage.writeAdminTokenScope(owner, expectedScope);
      return accessToken;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        await storage.clearAdminTokens(owner);
        return _issueAdminToken(_requireAdminSpace());
      }
      rethrow;
    }
  }

  Future<void> _writeAdminPermissionCache(
    String spaceId,
    Map<String, dynamic> data,
  ) async {
    _assertCurrent();
    final roleCodes = (data['roleCodes'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .where((code) => code.trim().isNotEmpty)
        .join(',');
    final permissionCodes =
        (data['permissionCodes'] as List<dynamic>? ?? const [])
            .whereType<String>()
            .where((code) => code.trim().isNotEmpty)
            .join(',');
    final isPlatformAdministrator =
        data['isPlatformAdministrator'] == true ? 'true' : 'false';
    _assertCurrent();
    await storage.write(
        SecureStorageService.adminRoleCodesKey(spaceId), roleCodes);
    _assertCurrent();
    await storage.write(
        SecureStorageService.adminPermissionCodesKey(spaceId), permissionCodes);
    _assertCurrent();
    await storage.write(
      SecureStorageService.adminIsPlatformAdministratorKey(spaceId),
      isPlatformAdministrator,
    );
  }

  Dio _plainDio() {
    return Dio(
      BaseOptions(
        baseUrl: HttpClient.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    )..httpClientAdapter = dio.httpClientAdapter;
  }

  String _tokenScope(SpaceContext space) =>
      '${AdminHttpClient.adminBaseUrl}|${space.spaceId}|${space.userId}';

  String _credentialOwner(SpaceContext space) =>
      credentialOwnerGetter?.call() ?? space.spaceId;

  void _assertRequestScope(RequestOptions options) {
    _assertCurrent();
    final expectedSiteId = options.extra['expectedAdminSiteId'] as String?;
    final expectedSpaceId = options.extra['expectedAdminSpaceId'] as String?;
    final expectedUserId = options.extra['expectedAdminUserId'] as String?;
    if (expectedSiteId == null &&
        expectedSpaceId == null &&
        expectedUserId == null) {
      return;
    }
    final space = _requireAdminSpace();
    if (SiteLineManager.instance.currentSite.id != expectedSiteId ||
        space.spaceId != expectedSpaceId ||
        space.userId != expectedUserId) {
      throw StateError('管理请求所属站点、企业或账号已切换');
    }
  }

  void _assertCurrent() {
    if (operationIsCurrent?.call() == false) {
      throw StateError('管理请求所属账号已切换');
    }
  }
}
