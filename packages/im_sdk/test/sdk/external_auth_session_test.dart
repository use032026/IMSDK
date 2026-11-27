import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/core/auth/account_session.dart';
import 'package:im_sdk/core/auth/account_session_store.dart';
import 'package:im_sdk/core/auth/token_refresh_service.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/service_realm_config.dart';
import 'package:im_sdk/core/space/account_scope.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';

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

class _CountingStore extends SecureAccountSessionStore {
  _CountingStore(super.storage);
  int restoreCalls = 0;
  int activeReads = 0;
  final expectedActivations = <String?>[];

  @override
  Future<ActiveAccountSession?> loadActiveAndMigrateV2() async {
    restoreCalls++;
    return super.loadActiveAndMigrateV2();
  }

  @override
  Future<ActiveAccountSession?> loadActive() async {
    activeReads++;
    return super.loadActive();
  }

  @override
  Future<ActiveAccountSession> provisionAndActivate({
    required AccountScope scope,
    required SessionCredentials credentials,
    required DateTime accessTokenIssuedAt,
    required DateTime accessTokenExpiresAt,
    required String? expectedActivationId,
    required int identityRevision,
    required bool Function() canCommit,
    bool restorePersonalOnRestart = false,
  }) {
    expectedActivations.add(expectedActivationId);
    return super.provisionAndActivate(
      scope: scope,
      credentials: credentials,
      accessTokenIssuedAt: accessTokenIssuedAt,
      accessTokenExpiresAt: accessTokenExpiresAt,
      expectedActivationId: expectedActivationId,
      identityRevision: identityRevision,
      canCommit: canCommit,
      restorePersonalOnRestart: restorePersonalOnRestart,
    );
  }
}

class _IdentityAdapter implements HttpClientAdapter {
  _IdentityAdapter({this.userId = 'user-new'});
  final String userId;
  final String platformId = 'platform-new';
  bool unavailable = false;
  final requests = <RequestOptions>[];
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    if (unavailable) {
      throw DioException.connectionTimeout(
        timeout: const Duration(seconds: 1),
        requestOptions: options,
      );
    }
    return ResponseBody.fromString(
      jsonEncode({
        'code': 'OK',
        'data': {'userId': userId, 'platformUserId': platformId, 'userType': 1},
      }),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json']
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final containers = <ProviderContainer>[];

  setUp(() {
    ServiceRealmConfig.configureForSdk(
        realmId: 'sdk-test', apiBaseUrl: 'https://im.example.test');
  });
  tearDown(() {
    for (final container in containers.reversed) {
      container.dispose();
    }
    containers.clear();
    TokenRefreshService.instance.stop();
  });

  AccountScope scope(String platform, String user) => AccountScope.tryCreate(
      serviceRealmId: 'sdk-test',
      platformUserId: platform,
      spaceId: 'personal',
      userId: user)!;
  const incoming = SessionCredentials(
      tenantAccessToken: 'test-access',
      tenantRefreshToken: 'test-refresh',
      adminToken: 'untrusted-admin-must-not-be-adopted');

  ProviderContainer create(
      _MemoryStorage storage, _CountingStore store, _IdentityAdapter adapter) {
    final dio = Dio(BaseOptions(baseUrl: 'https://im.example.test'))
      ..httpClientAdapter = adapter;
    final container = ProviderContainer(overrides: [
      externalSessionOnlyProvider.overrideWithValue(true),
      secureStorageProvider.overrideWithValue(storage),
      accountSessionStoreProvider.overrideWithValue(store),
      dioProvider.overrideWithValue(dio),
    ]);
    containers.add(container);
    return container;
  }

  Future<ActiveAccountSession> seed(
          _CountingStore store) =>
      store.provisionAndActivate(
          scope: scope('platform-old', 'user-old'),
          credentials: const SessionCredentials(
              tenantAccessToken: 'old-access',
              tenantRefreshToken: 'old-refresh'),
          accessTokenIssuedAt: DateTime.now().toUtc(),
          accessTokenExpiresAt:
              DateTime.now().toUtc().add(const Duration(hours: 1)),
          expectedActivationId: null,
          identityRevision: 4,
          canCommit: () => true);

  test('external host startup does not restore credentials or make requests',
      () async {
    final storage = _MemoryStorage();
    final store = _CountingStore(storage);
    await seed(store);
    final adapter = _IdentityAdapter();
    final container = create(storage, store, adapter);
    final auth = await container.read(authProvider.future);
    expect(auth.status, AuthStatus.unauthenticated);
    expect(auth.currentSpace, isNull);
    expect(store.restoreCalls, 0);
    expect(store.activeReads, 0);
    expect(adapter.requests, isEmpty);
  });

  test(
      'fresh host session replaces persisted CAS predecessor after identity verification',
      () async {
    final storage = _MemoryStorage();
    final store = _CountingStore(storage);
    final old = await seed(store);
    store.expectedActivations.clear();
    final adapter = _IdentityAdapter();
    final container = create(storage, store, adapter);
    await container.read(authProvider.future);
    await container.read(authProvider.notifier).acceptExternalSession(
        scope: scope('platform-new', 'user-new'),
        credentials: incoming,
        issuedAt: DateTime.now().toUtc(),
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)));
    final auth = container.read(authProvider).requireValue;
    expect(adapter.requests.single.path, '/api/client/v1/profile/me');
    expect(
        adapter.requests.single.headers['Authorization'], 'Bearer test-access');
    expect(store.expectedActivations, [old.activationId]);
    expect(auth.status, AuthStatus.authenticated);
    expect(auth.currentSpace!.userId, 'user-new');
    expect(auth.currentSpace!.membershipRole, 0);
    expect(auth.accountSession!.sessionId, isNot(old.activationId));
    expect((await store.loadActive())!.credentials.adminToken, isNull);
  });

  test(
      'confirmed same-scope host renewal verifies first and retains activation',
      () async {
    final storage = _MemoryStorage();
    final store = _CountingStore(storage);
    final adapter = _IdentityAdapter();
    final container = create(storage, store, adapter);
    final auth = container.read(authProvider.notifier);
    await container.read(authProvider.future);
    final accountScope = scope('platform-new', 'user-new');
    final initialIssue = DateTime.now().toUtc();
    await auth.acceptExternalSession(
      scope: accountScope,
      credentials: incoming,
      issuedAt: initialIssue,
      expiresAt: initialIssue.add(const Duration(hours: 1)),
    );
    final original = container.read(activeAccountSessionProvider)!;
    final expiry = initialIssue.add(const Duration(hours: 2));
    Future<void> renew() => auth.acceptExternalSession(
          scope: accountScope,
          credentials: const SessionCredentials(
            tenantAccessToken: 'replacement-access',
            tenantRefreshToken: 'replacement-refresh',
          ),
          issuedAt: DateTime.now().toUtc(),
          expiresAt: expiry,
          preserveActiveSession: true,
        );

    adapter.unavailable = true;
    await expectLater(renew(), throwsA(anything));
    expect(container.read(activeAccountSessionProvider), same(original));
    expect(container.read(currentSpaceProvider)!.accessToken, 'test-access');
    expect((await store.loadActive())!.credentials.tenantAccessToken,
        'test-access');

    adapter.unavailable = false;
    await renew();
    expect(container.read(activeAccountSessionProvider), same(original));
    expect(container.read(currentSpaceProvider)!.accessToken,
        'replacement-access');
    final persisted = (await store.loadActive())!;
    expect(persisted.activationId, original.sessionId);
    expect(persisted.accessTokenExpiresAt, expiry);
    expect(persisted.credentials.tenantRefreshToken, 'replacement-refresh');
    expect(store.expectedActivations, [null]);
  });

  test(
      'mismatched host identity fails closed and never commits incoming credentials',
      () async {
    final storage = _MemoryStorage();
    final store = _CountingStore(storage);
    final old = await seed(store);
    store.expectedActivations.clear();
    final container =
        create(storage, store, _IdentityAdapter(userId: 'other-user'));
    await container.read(authProvider.future);
    await expectLater(
        container.read(authProvider.notifier).acceptExternalSession(
            scope: scope('platform-new', 'user-new'),
            credentials: incoming,
            issuedAt: DateTime.now().toUtc(),
            expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1))),
        throwsA(anything));
    expect(container.read(authProvider).requireValue.status,
        AuthStatus.unauthenticated);
    expect(container.read(currentSpaceProvider), isNull);
    expect(store.expectedActivations, isEmpty);
    expect((await store.loadActive())!.activationId, old.activationId);
    expect(TokenRefreshService.instance.isRunning, isFalse);
  });
}
