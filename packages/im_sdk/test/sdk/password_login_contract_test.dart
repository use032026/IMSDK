import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/auth/token_refresh_service.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/service_realm_config.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';
import 'package:im_sdk/features/auth/data/stores/platform_tenant_directory_store.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_entities.dart';
import 'package:im_sdk/sdk/im_sdk_client.dart';
import 'package:im_sdk/sdk/im_sdk_models.dart';

class _MemoryStorage extends SecureStorageService {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async => values[key] = value;
  @override
  Future<void> delete(String key) async => values.remove(key);
  @override
  Future<void> deleteAll() async => values.clear();
}

class _UnavailableEnterpriseDirectory extends PlatformTenantDirectoryStore {
  _UnavailableEnterpriseDirectory(super.storage);
  int historyReads = 0;
  int directoryWrites = 0;
  @override
  Future<String?> readLastActiveSpace({
    required String serviceRealmId,
    required String platformUserId,
  }) async {
    historyReads++;
    throw StateError(
        'Enterprise history must not control explicit personal login');
  }

  @override
  Future<void> replace({
    required String serviceRealmId,
    required String platformUserId,
    required List<TenantSummary> tenants,
    DateTime? validatedAt,
  }) async {
    directoryWrites++;
    throw StateError(
        'An unfetched enterprise directory must not be overwritten');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('fixed tenant configuration is required for tenant account login', () {
    for (final config in [
      const ImSdkPasswordLoginConfig(),
      const ImSdkPasswordLoginConfig(tenantCode: '   '),
      const ImSdkPasswordLoginConfig(loginType: 'unexpected', tenantCode: 'a'),
      const ImSdkPasswordLoginConfig(loginType: 'auto'),
      const ImSdkPasswordLoginConfig(loginType: 'lpp_id'),
    ]) {
      expect(config.validate, throwsA(isA<ImSdkException>()));
    }
    expect(const ImSdkPasswordLoginConfig(tenantCode: 'fixed-tenant').validate,
        returnsNormally);
    expect(
        const ImSdkPasswordLoginConfig(
                loginType: 'lpp_id', tenantCode: 'fixed-tenant')
            .validate,
        returnsNormally);
  });

  test('password login routing survives native serialization and conflicts',
      () {
    const config = ImSdkConfig(
      apiBaseUrl: 'https://im.example.test',
      serviceRealmId: 'realm',
      privacyConsentGranted: true,
      passwordLogin: ImSdkPasswordLoginConfig(tenantCode: 'fixed-tenant'),
    );
    expect(
        ImSdkConfig.fromMap(Map<String, dynamic>.from(config.toMap())), config);
    const changed = ImSdkConfig(
      apiBaseUrl: 'https://im.example.test',
      serviceRealmId: 'realm',
      privacyConsentGranted: true,
      passwordLogin: ImSdkPasswordLoginConfig(tenantCode: 'another-tenant'),
    );
    expect(changed, isNot(config));
    for (final malformed in [
      true,
      'tenant',
      <String, Object>{'tenantCode': 9}
    ]) {
      expect(() => ImSdkPasswordLoginConfig.fromMap(malformed),
          throwsA(isA<ImSdkException>()));
    }
  });

  test('personal scope is explicit and roundtrips without a tenant', () {
    const personal = ImSdkPasswordLoginConfig.personal();
    expect(personal.validate, returnsNormally);
    expect(personal.usePersonalSpace, true);
    expect(personal.loginType, 'lpp_id');
    expect(personal.tenantCode, isNull);
    expect(personal.toMap().containsKey('tenantCode'), false);
    expect(ImSdkPasswordLoginConfig.fromMap(personal.toMap()), personal);
    const config = ImSdkConfig(
      apiBaseUrl: 'https://im.example.test',
      serviceRealmId: 'realm',
      privacyConsentGranted: true,
      passwordLogin: personal,
    );
    expect(
        ImSdkConfig.fromMap(Map<String, dynamic>.from(config.toMap())), config);
    final tenant = ImSdkPasswordLoginConfig.fromMap({
      'loginType': 'lpp_id',
      'tenantCode': 'fixed-tenant',
    });
    expect(tenant.validate, returnsNormally);
    expect(tenant.space, 'tenant');
    expect(tenant.usePersonalSpace, false);
    expect(tenant, isNot(personal));
    expect(tenant.toMap()['tenantCode'], 'fixed-tenant');
    expect(tenant.toMap().containsKey('space'), false);
  });

  test(
      'unknown or conflicting personal contexts fail instead of choosing a space',
      () {
    for (final fields in [
      {'space': 'unexpected', 'loginType': 'lpp_id'},
      {'space': 'personal', 'loginType': 'login_name'},
      {
        'space': 'personal',
        'loginType': 'lpp_id',
        'tenantCode': 'fixed-tenant'
      },
      {'space': 'personal', 'loginType': 'lpp_id', 'tenantCode': ''},
      {'space': 'tenant', 'loginType': 'lpp_id'},
    ]) {
      expect(ImSdkPasswordLoginConfig.fromMap(fields).validate,
          throwsA(isA<ImSdkException>()));
    }
    expect(() => ImSdkPasswordLoginConfig.fromMap({'space': true}),
        throwsA(isA<ImSdkException>()));
  });

  test(
      'explicit personal login ignores enterprise suggestions and unavailable history',
      () async {
    ServiceRealmConfig.configureForSdk(
        realmId: 'personal-sdk-test', apiBaseUrl: 'https://im.example.test');
    final storage = _MemoryStorage();
    final directory = _UnavailableEnterpriseDirectory(storage);
    final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'));
    final paths = <String>[];
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      paths.add(options.path);
      if (options.path == '/api/platform/v1/auth/login') {
        handler
            .resolve(Response(requestOptions: options, statusCode: 200, data: {
          'code': 'OK',
          'data': {
            'platformToken': 'fixture-platform-token',
            'platformUserId': 'fixture-platform-user',
            'platformRefreshToken': 'fixture-platform-refresh',
            'spaceContext': {
              'spaceType': 2,
              'tenantId': 'suggested-enterprise'
            },
            'tenants': [
              {'tenantId': 'suggested-enterprise', 'tenantName': 'Suggested'},
              {'tenantId': 'another-enterprise', 'tenantName': 'Another'},
            ],
          },
        }));
      } else if (options.path ==
          '/api/platform/v1/auth/select-personal-space') {
        handler
            .resolve(Response(requestOptions: options, statusCode: 200, data: {
          'code': 'OK',
          'data': {
            'userId': 'fixture-personal-user',
            'platformUserId': 'fixture-platform-user',
            'accessToken': 'fixture-personal-access',
            'refreshToken': 'fixture-personal-refresh',
            'spaceContext': {'spaceType': 1},
          },
        }));
      } else {
        handler.reject(DioException(
            requestOptions: options,
            error: StateError(
                'Explicit personal login must not require enterprise lookup or selection')));
      }
    }));
    final container = ProviderContainer(overrides: [
      externalSessionOnlyProvider.overrideWithValue(true),
      secureStorageProvider.overrideWithValue(storage),
      platformTenantDirectoryStoreProvider.overrideWithValue(directory),
      dioProvider.overrideWithValue(dio),
    ]);
    try {
      await container.read(authProvider.future);
      await container.read(authProvider.notifier).loginByPassword(
          'fixture-account', 'fixture-password', 'lpp_id',
          usePersonalSpace: true);
      final auth = container.read(authProvider).requireValue;
      expect(auth.status, AuthStatus.authenticated);
      expect(auth.currentSpace!.spaceId, 'personal');
      expect(auth.currentSpace!.userId, 'fixture-personal-user');
      expect(auth.accountSession!.scope.spaceId, 'personal');
      expect(paths, [
        '/api/platform/v1/auth/login',
        '/api/platform/v1/auth/select-personal-space',
      ]);
      expect(directory.historyReads, 0);
      expect(directory.directoryWrites, 0);
    } finally {
      container.dispose();
      dio.close(force: true);
      TokenRefreshService.instance.stop();
    }
  });

  test('auth errors never expose backend messages, unknown codes or secrets',
      () {
    const sensitive = 'raw-user-password-token';
    for (final error in <Object>[
      const ServerError(code: 'AUTH_INVALID_CREDENTIALS', message: sensitive),
      const ServerError(code: 'AUTH_CAPTCHA_REQUIRED', message: sensitive),
      const ServerError(code: sensitive, message: sensitive),
      const NetworkError(sensitive),
      Exception(sensitive),
    ]) {
      final failure = imSdkPasswordLoginFailure(error);
      expect(failure.toString(), isNot(contains(sensitive)));
    }
    expect(
        imSdkPasswordLoginFailure(const ServerError(
                code: 'AUTH_CAPTCHA_REQUIRED', message: sensitive))
            .code,
        'AUTH_CAPTCHA_REQUIRED');
    expect(
        imSdkPasswordLoginFailure(const AuthError('AUTH_INVALID_CREDENTIALS'))
            .message,
        '账号或密码错误');
  });

  test('tenant password requests skip session injection and diagnostic logging',
      () async {
    const tenantId = '22222222-2222-2222-2222-222222222222';
    final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'));
    late RequestOptions captured;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      captured = options;
      handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'code': 'AUTH_INVALID_CREDENTIALS',
          'message': 'backend private details',
        },
      ));
    }));
    try {
      await expectLater(
        AuthRemoteDataSourceImpl(dio).tenantLogin(const LoginRequest(
          identifier: 'fixture-account',
          password: ' fixture-password ',
          loginType: 'login_name',
          isCodeLogin: false,
          tenantCode: tenantId,
        )),
        throwsA(isA<AuthError>()),
      );
      expect(captured.path, '/api/client/v1/auth/login');
      expect(captured.extra['publicAuthRequest'], true);
      expect(captured.extra['skipDiagnosticsLog'], true);
      expect(captured.headers['X-Tenant-Id'], tenantId);
      expect((captured.data as Map)['password'], ' fixture-password ');
    } finally {
      dio.close(force: true);
    }
  });

  test('one fuzzy tenant search result cannot override the fixed tenant code',
      () async {
    const unrelatedTenant = '33333333-3333-3333-3333-333333333333';
    final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'));
    late RequestOptions loginRequest;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (options.path == '/api/platform/v1/tenants/search') {
        handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'code': 'OK',
            'data': [
              {
                'tenantId': unrelatedTenant,
                'tenantCode': 'fixed-tenant-other',
                'tenantName': 'Unrelated enterprise',
              },
            ],
          },
        ));
        return;
      }
      loginRequest = options;
      handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {'code': 'AUTH_INVALID_CREDENTIALS', 'message': 'fixture'},
      ));
    }));
    try {
      await expectLater(
        AuthRemoteDataSourceImpl(dio).tenantLogin(const LoginRequest(
          identifier: 'fixture-account',
          password: 'fixture-password',
          loginType: 'login_name',
          isCodeLogin: false,
          tenantCode: 'fixed-tenant',
        )),
        throwsA(isA<AuthError>()),
      );
      expect(loginRequest.path, '/api/client/v1/auth/login');
      expect(loginRequest.headers.containsKey('X-Tenant-Id'), false);
      expect((loginRequest.data as Map).containsKey('tenantId'), false);
      expect((loginRequest.data as Map)['tenantCode'], 'fixed-tenant');
    } finally {
      dio.close(force: true);
    }
  });

  test('unauthorized public tenant lookup continues with the original code',
      () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'));
    late RequestOptions searchRequest;
    late RequestOptions loginRequest;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (options.path == '/api/platform/v1/tenants/search') {
        searchRequest = options;
        handler.reject(DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: 401,
            data: {'code': 'AUTH_INVALID_TOKEN', 'message': 'fixture'},
          ),
        ));
        return;
      }
      loginRequest = options;
      handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {'code': 'AUTH_INVALID_CREDENTIALS', 'message': 'fixture'},
      ));
    }));
    try {
      await expectLater(
        AuthRemoteDataSourceImpl(dio).tenantLogin(const LoginRequest(
          identifier: 'fixture-account',
          password: 'fixture-password',
          loginType: 'login_name',
          isCodeLogin: false,
          tenantCode: 'fixed-tenant',
        )),
        throwsA(isA<AuthError>()),
      );
      expect(searchRequest.extra['publicAuthRequest'], true);
      expect(searchRequest.extra['skipDiagnosticsLog'], true);
      expect(loginRequest.path, '/api/client/v1/auth/login');
      expect(loginRequest.headers.containsKey('X-Tenant-Id'), false);
      expect((loginRequest.data as Map).containsKey('tenantId'), false);
      expect((loginRequest.data as Map)['tenantCode'], 'fixed-tenant');
    } finally {
      dio.close(force: true);
    }
  });
}
