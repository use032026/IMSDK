import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/core/auth/token_refresh_service.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/service_realm_config.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';
import 'package:im_sdk/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_entities.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';

class _Storage extends SecureStorageService {
  final data = <String, String>{};
  @override
  Future<String?> read(String key) async => data[key];
  @override
  Future<void> write(String key, String value) async {
    data[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    data.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    data.clear();
  }
}

class _Adapter implements HttpClientAdapter {
  _Adapter(this.handler);
  final Map<String, dynamic> Function(RequestOptions) handler;
  final requests = <RequestOptions>[];
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    return ResponseBody.fromString(
        jsonEncode({'code': 'OK', 'data': handler(options)}), 200,
        headers: {
          Headers.contentTypeHeader: ['application/json']
        });
  }

  @override
  void close({bool force = false}) {}
}

Map<String, dynamic> _personal() => {
      'userId': 'personal-user',
      'platformUserId': 'platform-user',
      'accessToken': 'personal-access',
      'refreshToken': 'personal-refresh',
      'spaceContext': {'spaceType': 1},
    };

Future<void> _withAuth(Future<void> Function(ProviderContainer, _Adapter) body,
    {Map<String, dynamic>? registration,
    Map<String, dynamic>? selected,
    Map<String, dynamic>? profile}) async {
  ServiceRealmConfig.configureForSdk(
      realmId: 'registration-contract', apiBaseUrl: 'https://im.example.test');
  final adapter = _Adapter((request) {
    switch (request.path) {
      case '/api/platform/v1/auth/register':
        return registration ??
            {
              'platformToken': 'platform-token',
              'platformUserId': 'platform-user'
            };
      case '/api/platform/v1/auth/login':
        return {
          'platformToken': 'platform-token',
          'platformUserId': 'platform-user'
        };
      case '/api/platform/v1/auth/select-personal-space':
        return selected ?? _personal();
      case '/api/client/v1/tenant/features':
        return {'friendMode': 'social'};
      case '/api/client/v1/profile/me':
        return profile ??
            {'userId': 'personal-user', 'platformUserId': 'platform-user'};
      default:
        throw StateError('Unexpected ${request.path}');
    }
  });
  final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'))
    ..httpClientAdapter = adapter;
  final container = ProviderContainer(overrides: [
    externalSessionOnlyProvider.overrideWithValue(true),
    secureStorageProvider.overrideWithValue(_Storage()),
    dioProvider.overrideWithValue(dio),
  ]);
  try {
    await container.read(authProvider.future);
    await body(container, adapter);
  } finally {
    container.dispose();
    dio.close(force: true);
    TokenRefreshService.instance.stop();
  }
}

Future<void> _register(ProviderContainer container) =>
    container.read(authProvider.notifier).registerPlatform(
        displayName: 'New user',
        password: 'secret-password',
        loginType: 'email',
        email: 'new@example.test',
        verificationCode: '123456',
        useDefaultRegistrationSpace: true);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
      'registration selects personal without tenant lookup and verifies identity',
      () async {
    await _withAuth((container, adapter) async {
      await _register(container);
      final auth = container.read(authProvider).requireValue;
      expect(auth.status, AuthStatus.authenticated);
      expect(auth.currentSpace!.isPersonal, true);
      expect(auth.accountSession!.scope.spaceId, 'personal');
      expect(adapter.requests.map((r) => r.path), [
        '/api/platform/v1/auth/register',
        '/api/platform/v1/auth/select-personal-space',
        '/api/client/v1/profile/me'
      ]);
      final payload = adapter.requests.first.data as Map;
      expect(payload['email'], 'new@example.test');
      expect(payload['verificationCode'], '123456');
      expect(payload.containsKey('tenantId'), false);
      expect(payload.containsKey('tenantCode'), false);
      expect(payload.containsKey('invitationCode'), false);
    });
  });
  for (final marker in [
    {
      'spaceContext': {'spaceType': 1}
    },
    {'tenantId': legacyPersonalTenantId},
    {'spaceId': 'personal'},
  ]) {
    test(
        'direct personal registration accepts supported personal marker $marker',
        () async {
      final direct = _personal()..remove('spaceContext');
      direct.addAll(marker);
      await _withAuth((container, adapter) async {
        await _register(container);
        expect(
            container.read(authProvider).requireValue.currentSpace!.isPersonal,
            true);
        expect(adapter.requests.map((r) => r.path),
            ['/api/platform/v1/auth/register', '/api/client/v1/profile/me']);
      }, registration: direct);
    });
  }
  for (final direct in [true, false]) {
    test(
        'nested-context enterprise registration ${direct ? 'direct' : 'selected'} preserves actual space',
        () async {
      final enterprise = {
        ..._personal(),
        'userType': 1,
        'spaceContext': {'spaceType': 2, 'tenantId': 'enterprise'}
      };
      await _withAuth((container, adapter) async {
        await _register(container);
        final auth = container.read(authProvider).requireValue;
        expect(auth.currentSpace!.spaceId, 'enterprise');
        expect(auth.accountSession!.scope.spaceId, 'enterprise');
      },
          registration: direct ? enterprise : null,
          selected: direct ? null : enterprise,
          profile: {
            'userId': 'personal-user',
            'platformUserId': 'platform-user',
            'spaceContext': {'spaceType': 2, 'tenantId': 'enterprise'}
          });
    });
  }
  test(
      'enterprise registration replaces previous personal activation with one active scope',
      () async {
    await _withAuth((container, adapter) async {
      await container.read(authProvider.notifier).loginByPassword(
          'account', 'password', 'lpp_id',
          usePersonalSpace: true);
      final previous = container.read(activeAccountSessionProvider)!;
      expect(previous.scope.spaceId, 'personal');
      await _register(container);
      final current = container.read(activeAccountSessionProvider)!;
      final persisted =
          await container.read(accountSessionStoreProvider).loadActive();
      expect(current.sessionId, isNot(previous.sessionId));
      expect(current.scope.spaceId, 'enterprise');
      expect(container.read(currentSpaceProvider)!.spaceId, 'enterprise');
      expect(persisted!.session.sessionId, current.sessionId);
      expect(persisted.session.scope.spaceId, 'enterprise');
    }, registration: {
      ..._personal(),
      'tenantId': 'enterprise',
      'userType': 1,
      'spaceContext': {'spaceType': 2}
    }, profile: {
      'userId': 'personal-user',
      'platformUserId': 'platform-user',
      'tenantId': 'enterprise'
    });
  });
  for (final direct in [true, false]) {
    test(
        '${direct ? 'direct' : 'default-selection'} authenticated enterprise activates actual single space without chooser',
        () async {
      final enterprise = {
        ..._personal(),
        'tenantId': 'enterprise',
        'userType': 1,
        'spaceContext': {'spaceType': 2}
      };
      await _withAuth((container, adapter) async {
        await _register(container);
        final auth = container.read(authProvider).requireValue;
        expect(auth.status, AuthStatus.authenticated);
        expect(auth.currentSpace!.spaceId, 'enterprise');
        expect(auth.currentSpace!.isPersonal, false);
        expect(auth.accountSession!.scope.spaceId, 'enterprise');
        expect(auth.availableTenants.map((t) => t.tenantId), ['enterprise']);
        expect(
            adapter.requests
                .where((r) => r.path == '/api/platform/v1/my/tenants'),
            isEmpty);
        expect(
            adapter.requests
                .where((r) => r.path == '/api/platform/v1/auth/select-tenant'),
            isEmpty);
      },
          registration: direct ? enterprise : null,
          selected: direct ? null : enterprise,
          profile: {
            'userId': 'personal-user',
            'platformUserId': 'platform-user',
            'tenantId': 'enterprise'
          });
    });
  }
  for (final direct in [true, false]) {
    test(
        'explicit non-personal type zero is rejected for ${direct ? 'direct registration' : 'personal selection'}',
        () async {
      final invalid = {
        ..._personal(),
        'tenantId': 'personal',
        'spaceContext': {'spaceType': 0}
      };
      await _withAuth((container, adapter) async {
        await expectLater(
            _register(container),
            throwsA(predicate(
                (e) => e.toString().contains('REGISTER_LOGIN_FAILED'))));
        expect(container.read(authProvider).valueOrNull?.status,
            isNot(AuthStatus.authenticated));
      },
          registration: direct ? invalid : null,
          selected: direct ? null : invalid);
    });
  }
  test('registration profile mismatch cannot activate a session', () async {
    await _withAuth((container, adapter) async {
      await expectLater(
          _register(container),
          throwsA(predicate(
              (e) => e.toString().contains('REGISTER_LOGIN_FAILED'))));
      expect(container.read(authProvider).valueOrNull?.status,
          isNot(AuthStatus.authenticated));
    }, profile: {'userId': 'wrong-user', 'platformUserId': 'platform-user'});
  });
  test(
      'personal registration DTO cannot override authoritative profile enterprise',
      () async {
    await _withAuth((container, adapter) async {
      await expectLater(
          _register(container),
          throwsA(predicate(
              (e) => e.toString().contains('REGISTER_LOGIN_FAILED'))));
      expect(container.read(authProvider).valueOrNull?.status,
          isNot(AuthStatus.authenticated));
    }, profile: {
      'userId': 'personal-user',
      'platformUserId': 'platform-user',
      'tenantId': 'enterprise'
    });
  });
  for (final personal in [true, false]) {
    test(
        'identity-bound accepted bearer ${personal ? 'personal placeholder accepted' : 'tenant scope rejected'}',
        () async {
      final claims = {
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier':
            'personal-user',
        'platform_user_id': 'platform-user',
        'space_type': personal ? '1' : '2',
        'tenant_id': personal ? legacyPersonalTenantId : 'enterprise'
      };
      final token =
          'header.${base64Url.encode(utf8.encode(jsonEncode(claims))).replaceAll('=', '')}.signature';
      await _withAuth((container, adapter) async {
        if (personal) {
          await _register(container);
          expect(
              container
                  .read(authProvider)
                  .requireValue
                  .currentSpace!
                  .isPersonal,
              true);
        } else {
          await expectLater(
              _register(container),
              throwsA(predicate(
                  (e) => e.toString().contains('REGISTER_LOGIN_FAILED'))));
          expect(container.read(authProvider).valueOrNull?.status,
              isNot(AuthStatus.authenticated));
        }
      }, selected: {..._personal(), 'accessToken': token});
    });
  }
  test('pending approval reports account created and does not select personal',
      () async {
    await _withAuth((container, adapter) async {
      await expectLater(
          _register(container),
          throwsA(predicate(
              (e) => e.toString().contains('REGISTER_PENDING_APPROVAL'))));
      expect(adapter.requests.length, 1);
      expect(container.read(authProvider).valueOrNull?.status,
          isNot(AuthStatus.authenticated));
    }, registration: {
      'platformToken': 'platform-token',
      'platformUserId': 'platform-user',
      'pendingApproval': true
    });
  });
  for (final type in ['mobile', 'email']) {
    test('$type password login enters personal without tenant selection',
        () async {
      await _withAuth((container, adapter) async {
        await container.read(authProvider.notifier).loginByPassword(
            'identifier', 'password', type,
            usePersonalSpace: true);
        expect(
            container.read(authProvider).requireValue.currentSpace!.isPersonal,
            true);
        expect(adapter.requests.first.data['loginType'], type);
        expect(adapter.requests.map((r) => r.path), [
          '/api/platform/v1/auth/login',
          '/api/platform/v1/auth/select-personal-space'
        ]);
      });
    });
  }
  test('verification send only succeeds when server confirms sent', () async {
    final adapter = _Adapter((_) => {'sent': false});
    final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'))
      ..httpClientAdapter = adapter;
    try {
      await expectLater(
          AuthRemoteDataSourceImpl(dio).sendVerificationCode(
              identifier: 'new@example.test',
              channel: 'email',
              purpose: 'register'),
          throwsA(predicate(
              (e) => e.toString().contains('VERIFICATION_SEND_FAILED'))));
    } finally {
      dio.close(force: true);
    }
  });
}
