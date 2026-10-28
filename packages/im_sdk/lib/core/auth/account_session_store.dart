import 'dart:convert';

import 'package:im_sdk/core/auth/account_session.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/space/account_scope.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';
import 'package:im_sdk/core/utils/async_lock.dart';
import 'package:uuid/uuid.dart';

abstract interface class AccountSessionStore {
  Future<List<StoredSpaceSession>> loadPlatformSpaces({
    required PlatformAccountScope platformAccount,
  });
  Future<StoredSpaceSession?> loadReusableSpace({
    required PlatformAccountScope platformAccount,
    required String spaceId,
  });
  Future<ActiveAccountSession> provisionAndActivate({
    required AccountScope scope,
    required SessionCredentials credentials,
    required DateTime accessTokenIssuedAt,
    required DateTime accessTokenExpiresAt,
    required String? expectedActivationId,
    required int identityRevision,
    required bool Function() canCommit,
    bool restorePersonalOnRestart = false,
  });
  Future<ActiveAccountSession> activateStoredSpace({
    required StoredSpaceSession target,
    required String? expectedActivationId,
    required int identityRevision,
    required bool Function() canCommit,
    String? activationId,
    bool restorePersonalOnRestart = false,
  });
  Future<void> updateSpaceCredentials({
    required String spaceSessionId,
    required String accessToken,
    required String refreshToken,
    required DateTime accessTokenIssuedAt,
    required DateTime accessTokenExpiresAt,
  });
  Future<void> updatePlatformCredentials({
    required PlatformAccountScope platformAccount,
    required String accessToken,
    required String? refreshToken,
    required String? deviceSessionToken,
  });
  Future<void> removeSpaceSession({required String spaceSessionId});
  Future<void> clearPlatformAccountSessions({
    required PlatformAccountScope platformAccount,
    required String? expectedActivationId,
  });
  Future<AccountSession> stageCandidate({
    required AccountSession candidate,
    required SessionCredentials credentials,
  });
  Future<void> commitActiveSession({
    required String? expectedCurrentSessionId,
    required String candidateSessionId,
    bool Function()? canCommit,
  });
  Future<void> discardCandidate(String candidateSessionId);
  Future<void> clearActiveSession({required String expectedCurrentSessionId});
  Future<ActiveAccountSession?> loadActive();
  Future<void> replaceActiveCredentials({
    required String expectedCurrentSessionId,
    required SessionCredentials credentials,
  });
}

enum AccountSessionRecoveryState { empty, activeV2, legacyOnly, invalidV2 }

class ActiveSessionConflict implements Exception {}

class ActiveCandidateDiscarded implements Exception {}

class CandidateSessionNotFound implements Exception {}

class SecureAccountSessionStore implements AccountSessionStore {
  SecureAccountSessionStore(this._storage);

  static const activeSessionIdKey = 'active_session_id_v2';
  static const activeActivationV3Key = 'active_activation_v3';
  final SecureStorageService _storage;
  final AsyncLock _lock = AsyncLock();
  // Positive-only, process-local projections of the encrypted V3 registry.
  // The durable active activation is intentionally never cached: every switch
  // must still perform the persisted compare-and-set boundary.
  final Map<String, StoredSpaceSession> _storedSpaceCache = {};
  final Map<String, _PlatformCredentialsV3> _platformCredentialCache = {};
  final Map<String, String> _spaceLookupCache = {};

  Future<ActiveAccountSession?> loadActiveAndMigrateV2() =>
      _lock.synchronized(() async {
        final activation = await _readActiveActivationV3();
        if (activation != null) {
          if (activation.restorePersonalOnRestart) {
            return _restorePersonalSpaceUnlocked(
              activation,
              identityRevision: activation.identityRevision + 1,
              canCommit: () => true,
            );
          }
          return _composeActiveV3(activation);
        }
        final legacyId = await _storage.read(activeSessionIdKey);
        if (legacyId == null || legacyId.isEmpty) return null;
        final legacySession = await _readSession(legacyId);
        if (legacySession == null) return null;
        final legacyCredentials = await _readCredentials(legacySession);
        if (legacyCredentials == null) return null;

        final platform = PlatformAccountScope.fromAccountScope(
          legacySession.scope,
        );
        final stored = StoredSpaceSession(
          spaceSessionId: const Uuid().v4(),
          scope: legacySession.scope,
          accessToken: legacyCredentials.tenantAccessToken,
          refreshToken: legacyCredentials.tenantRefreshToken,
          // V2 没有可信 expiry。迁移后立即视为临期，下一次切换必须刷新，
          // 不能猜测旧 token 仍可快速复用。
          accessTokenIssuedAt:
              DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
          accessTokenExpiresAt:
              DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        );
        final spaceKey = _spaceSessionV3Key(stored.scope);
        final indexKey = _platformSpaceIndexV3Key(platform);
        final indexed = await _readStringList(indexKey);
        final migratedActivation = AccountActivation(
          activationId: legacySession.sessionId,
          spaceSessionId: stored.spaceSessionId,
          scope: stored.scope,
          identityRevision: legacySession.identityRevision,
        );
        try {
          await _storage.write(
            _platformCredentialV3Key(platform),
            jsonEncode(<String, Object?>{
              'platformAccessToken': legacyCredentials.platformAccessToken,
              'platformRefreshToken': legacyCredentials.platformRefreshToken,
              'deviceSessionToken': legacyCredentials.deviceSessionToken,
            }),
          );
          await _storage.write(spaceKey, jsonEncode(stored.toJson()));
          await _storage.write(
            _spaceSessionIdIndexV3Key(stored.spaceSessionId),
            spaceKey,
          );
          await _storage.write(
            _spaceLookupV3Key(platform, stored.scope.spaceId),
            spaceKey,
          );
          if (!indexed.contains(spaceKey)) {
            await _storage.write(
              indexKey,
              jsonEncode(<String>[...indexed, spaceKey]),
            );
          }
          await _storage.write(
            activeActivationV3Key,
            jsonEncode(migratedActivation.toJson()),
          );
          _platformCredentialCache[_platformCredentialV3Key(platform)] =
              _PlatformCredentialsV3(
            accessToken: legacyCredentials.platformAccessToken,
            refreshToken: legacyCredentials.platformRefreshToken,
            deviceSessionToken: legacyCredentials.deviceSessionToken,
          );
          _storedSpaceCache[spaceKey] = stored;
          _spaceLookupCache[_spaceLookupV3Key(platform, stored.scope.spaceId)] =
              spaceKey;
        } catch (_) {
          // active activation 未提交时 V2 仍是权威恢复来源。
          return ActiveAccountSession(
            session: legacySession,
            credentials: legacyCredentials,
          );
        }
        try {
          await _storage.delete(activeSessionIdKey);
        } catch (_) {}
        return _composeActiveV3(migratedActivation);
      });

  @override
  Future<List<StoredSpaceSession>> loadPlatformSpaces({
    required PlatformAccountScope platformAccount,
  }) =>
      _lock.synchronized(() async {
        final recordKeys = await _readStringList(
          _platformSpaceIndexV3Key(platformAccount),
        );
        final spaces = <StoredSpaceSession>[];
        final seenSpaceIds = <String>{};
        for (final recordKey in recordKeys) {
          final stored = await _readStoredSpace(recordKey);
          if (stored == null ||
              stored.scope.serviceRealmId != platformAccount.serviceRealmId ||
              stored.scope.platformUserId != platformAccount.platformUserId ||
              !seenSpaceIds.add(stored.scope.spaceId)) {
            continue;
          }
          spaces.add(stored);
        }
        return List<StoredSpaceSession>.unmodifiable(spaces);
      });

  @override
  Future<StoredSpaceSession?> loadReusableSpace({
    required PlatformAccountScope platformAccount,
    required String spaceId,
  }) =>
      _lock.synchronized(
        () => _loadReusableSpaceUnlocked(
          platformAccount: platformAccount,
          spaceId: spaceId,
        ),
      );

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
  }) =>
      _lock.synchronized(() async {
        _validateCredentials(credentials);
        final platformAccount = PlatformAccountScope.fromAccountScope(scope);
        final existing = await _loadReusableSpaceUnlocked(
          platformAccount: platformAccount,
          spaceId: scope.spaceId,
        );
        final stored = StoredSpaceSession(
          spaceSessionId: existing?.spaceSessionId ?? const Uuid().v4(),
          scope: scope,
          accessToken: credentials.tenantAccessToken,
          refreshToken: credentials.tenantRefreshToken,
          accessTokenIssuedAt: accessTokenIssuedAt.toUtc(),
          accessTokenExpiresAt: accessTokenExpiresAt.toUtc(),
        );
        final platformKey = _platformCredentialV3Key(platformAccount);
        final spaceKey = _spaceSessionV3Key(scope);
        final lookupKey = _spaceLookupV3Key(platformAccount, scope.spaceId);
        final indexKey = _platformSpaceIndexV3Key(platformAccount);
        final indexed = await _readStringList(indexKey);

        // V3 的 active activation 是唯一提交边界。凭证与索引先写完，
        // 中途失败时旧 activation 仍保持可恢复。
        await _storage.write(
          platformKey,
          jsonEncode(<String, Object?>{
            'platformAccessToken': credentials.platformAccessToken,
            'platformRefreshToken': credentials.platformRefreshToken,
            'deviceSessionToken': credentials.deviceSessionToken,
          }),
        );
        await _storage.write(spaceKey, jsonEncode(stored.toJson()));
        await _storage.write(
          _spaceSessionIdIndexV3Key(stored.spaceSessionId),
          spaceKey,
        );
        await _storage.write(lookupKey, spaceKey);
        _platformCredentialCache[platformKey] = _PlatformCredentialsV3(
          accessToken: credentials.platformAccessToken,
          refreshToken: credentials.platformRefreshToken,
          deviceSessionToken: credentials.deviceSessionToken,
        );
        _storedSpaceCache[spaceKey] = stored;
        _spaceLookupCache[lookupKey] = spaceKey;
        if (!indexed.contains(spaceKey)) {
          await _storage.write(
              indexKey, jsonEncode(<String>[...indexed, spaceKey]));
        }
        return _activateStoredSpaceUnlocked(
          target: stored,
          expectedActivationId: expectedActivationId,
          identityRevision: identityRevision,
          canCommit: canCommit,
          restorePersonalOnRestart: restorePersonalOnRestart,
        );
      });

  @override
  Future<ActiveAccountSession> activateStoredSpace({
    required StoredSpaceSession target,
    required String? expectedActivationId,
    required int identityRevision,
    required bool Function() canCommit,
    String? activationId,
    bool restorePersonalOnRestart = false,
  }) =>
      _lock.synchronized(
        () => _activateStoredSpaceUnlocked(
          target: target,
          expectedActivationId: expectedActivationId,
          identityRevision: identityRevision,
          canCommit: canCommit,
          activationId: activationId,
          restorePersonalOnRestart: restorePersonalOnRestart,
        ),
      );

  /// Returns locally, including offline. Tenant credentials and message stores
  /// remain intact; only the existing active activation pointer is replaced.
  Future<ActiveAccountSession> restorePersonalSpace({
    required String expectedActivationId,
    required int identityRevision,
    required bool Function() canCommit,
  }) =>
      _lock.synchronized(() async {
        final current = await _readActiveActivationV3();
        if (current?.activationId != expectedActivationId ||
            current?.restorePersonalOnRestart != true) {
          throw ActiveSessionConflict();
        }
        return _restorePersonalSpaceUnlocked(current!,
            identityRevision: identityRevision, canCommit: canCommit);
      });

  Future<ActiveAccountSession> _restorePersonalSpaceUnlocked(
    AccountActivation current, {
    required int identityRevision,
    required bool Function() canCommit,
  }) async {
    final personal = await _loadReusableSpaceUnlocked(
      platformAccount: PlatformAccountScope.fromAccountScope(current.scope),
      spaceId: 'personal',
    );
    if (personal == null) throw CandidateSessionNotFound();
    return _activateStoredSpaceUnlocked(
      target: personal,
      expectedActivationId: current.activationId,
      identityRevision: identityRevision,
      canCommit: canCommit,
    );
  }

  @override
  Future<void> updateSpaceCredentials({
    required String spaceSessionId,
    required String accessToken,
    required String refreshToken,
    required DateTime accessTokenIssuedAt,
    required DateTime accessTokenExpiresAt,
  }) =>
      _lock.synchronized(() async {
        final key = await _storage.read(
          _spaceSessionIdIndexV3Key(spaceSessionId),
        );
        if (key == null || key.isEmpty) throw CandidateSessionNotFound();
        final stored = await _readStoredSpace(key);
        if (stored == null || stored.spaceSessionId != spaceSessionId) {
          throw CandidateSessionNotFound();
        }
        if (accessToken.trim().isEmpty || refreshToken.trim().isEmpty) {
          throw ArgumentError('space credentials must not be empty');
        }
        final updated = StoredSpaceSession(
          spaceSessionId: stored.spaceSessionId,
          scope: stored.scope,
          accessToken: accessToken,
          refreshToken: refreshToken,
          accessTokenIssuedAt: accessTokenIssuedAt.toUtc(),
          accessTokenExpiresAt: accessTokenExpiresAt.toUtc(),
        );
        await _storage.write(key, jsonEncode(updated.toJson()));
        _storedSpaceCache[key] = updated;
      });

  @override
  Future<void> updatePlatformCredentials({
    required PlatformAccountScope platformAccount,
    required String accessToken,
    required String? refreshToken,
    required String? deviceSessionToken,
  }) =>
      _lock.synchronized(() async {
        if (accessToken.trim().isEmpty) {
          throw ArgumentError.value(accessToken, 'accessToken');
        }
        final key = _platformCredentialV3Key(platformAccount);
        await _storage.write(
          key,
          jsonEncode(<String, Object?>{
            'platformAccessToken': accessToken,
            'platformRefreshToken': refreshToken,
            'deviceSessionToken': deviceSessionToken,
          }),
        );
        _platformCredentialCache[key] = _PlatformCredentialsV3(
          accessToken: accessToken,
          refreshToken: refreshToken,
          deviceSessionToken: deviceSessionToken,
        );
      });

  @override
  Future<void> removeSpaceSession({required String spaceSessionId}) =>
      _lock.synchronized(() async {
        final idKey = _spaceSessionIdIndexV3Key(spaceSessionId);
        final recordKey = await _storage.read(idKey);
        if (recordKey == null || recordKey.isEmpty) return;
        final stored = await _readStoredSpace(recordKey);
        if (stored == null) {
          await _storage.delete(idKey);
          _storedSpaceCache.remove(recordKey);
          return;
        }
        final active = await _readActiveActivationV3();
        if (active?.spaceSessionId == spaceSessionId) {
          await _storage.delete(activeActivationV3Key);
        }
        final platform = PlatformAccountScope.fromAccountScope(stored.scope);
        final indexKey = _platformSpaceIndexV3Key(platform);
        final indexed = await _readStringList(indexKey);
        await _storage.delete(recordKey);
        _storedSpaceCache.remove(recordKey);
        await _storage.delete(idKey);
        final lookupKey = _spaceLookupV3Key(platform, stored.scope.spaceId);
        await _storage.delete(lookupKey);
        _spaceLookupCache.remove(lookupKey);
        await _storage.write(
          indexKey,
          jsonEncode(indexed.where((key) => key != recordKey).toList()),
        );
      });

  @override
  Future<void> clearPlatformAccountSessions({
    required PlatformAccountScope platformAccount,
    required String? expectedActivationId,
  }) =>
      _lock.synchronized(() async {
        final active = await _readActiveActivationV3();
        if (active?.activationId != expectedActivationId) {
          throw ActiveSessionConflict();
        }
        final activePlatform = active == null
            ? null
            : PlatformAccountScope.fromAccountScope(active.scope);
        if (activePlatform != null && activePlatform != platformAccount) {
          throw ActiveSessionConflict();
        }
        final indexKey = _platformSpaceIndexV3Key(platformAccount);
        final spaceKeys = await _readStringList(indexKey);
        for (final key in spaceKeys) {
          final stored = await _readStoredSpace(key);
          if (stored != null) {
            // Admin credentials use the complete account-scope owner, not the
            // public spaceId. Keep logout aligned with this registry owner.
            await _storage.clearAdminCredentialsForOwner(
              stored.scope.storageKeyHash,
            );
            await _storage.delete(
              _spaceLookupV3Key(platformAccount, stored.scope.spaceId),
            );
            _spaceLookupCache.remove(
              _spaceLookupV3Key(platformAccount, stored.scope.spaceId),
            );
            await _storage.delete(
              _spaceSessionIdIndexV3Key(stored.spaceSessionId),
            );
          }
          await _storage.delete(key);
          _storedSpaceCache.remove(key);
        }
        await _storage.delete(indexKey);
        final platformKey = _platformCredentialV3Key(platformAccount);
        await _storage.delete(platformKey);
        _platformCredentialCache.remove(platformKey);
        if (active != null) await _storage.delete(activeActivationV3Key);
      });

  @override
  Future<AccountSession> stageCandidate({
    required AccountSession candidate,
    required SessionCredentials credentials,
  }) =>
      _lock.synchronized(() async {
        if (credentials.tenantAccessToken.trim().isEmpty) {
          throw ArgumentError.value(
            credentials.tenantAccessToken,
            'tenantAccessToken',
            'must not be empty',
          );
        }
        if (credentials.tenantRefreshToken.trim().isEmpty) {
          throw ArgumentError.value(
            credentials.tenantRefreshToken,
            'tenantRefreshToken',
            'must not be empty',
          );
        }
        final effective = AccountSession(
          scope: candidate.scope,
          identityRevision: candidate.identityRevision,
          sessionId: candidate.sessionId,
          hasPlatformCredential:
              credentials.platformAccessToken?.trim().isNotEmpty == true,
          hasAdminCredential: credentials.adminToken?.trim().isNotEmpty == true,
        );
        final existing = await Future.wait<String?>([
          _storage.read(effective.descriptorKey),
          _storage.read(_candidateIndexKey(effective.sessionId)),
        ]);
        if (existing.any((value) => value != null)) {
          throw StateError('candidate session already exists');
        }
        final records = <String, String>{
          effective.tenantCredentialKey: jsonEncode(credentials.toJson()),
          effective.descriptorKey: jsonEncode(effective),
          if (effective.platformCredentialKey case final String key)
            key: jsonEncode(<String, Object?>{
              'platformAccessToken': credentials.platformAccessToken,
              'platformRefreshToken': credentials.platformRefreshToken,
              'deviceSessionToken': credentials.deviceSessionToken,
            }),
          if (effective.adminCredentialKey case final String key)
            key: credentials.adminToken!,
        };
        final indexKey = _candidateIndexKey(effective.sessionId);
        try {
          // The index is the visibility boundary. Independent encrypted
          // records can be persisted concurrently, then the index is written
          // last so a reader never observes a partially staged candidate.
          await Future.wait(
            records.entries.map(
              (entry) => _storage.write(entry.key, entry.value),
            ),
          );
          await _storage.write(indexKey, effective.descriptorKey);
          return effective;
        } catch (error, stackTrace) {
          final cleanupFailures = <String>[];
          await Future.wait(
            <String>[indexKey, ...records.keys].map((key) async {
              try {
                await _storage.delete(key);
              } catch (cleanupError) {
                cleanupFailures.add(
                  '${_recordCategory(key)}:${cleanupError.runtimeType}',
                );
              }
            }),
          );
          if (cleanupFailures.isNotEmpty) {
            AppDiagnostics.instance.warning(
              'auth.session_stage_rollback_failed',
              'Candidate session rollback did not remove every record',
              context: {
                'failedRecords': cleanupFailures,
                'originalErrorType': error.runtimeType.toString(),
              },
            );
          }
          Error.throwWithStackTrace(error, stackTrace);
        }
      });

  @override
  Future<void> commitActiveSession({
    required String? expectedCurrentSessionId,
    required String candidateSessionId,
    bool Function()? canCommit,
  }) =>
      _lock.synchronized(() async {
        final reads = await Future.wait<Object?>([
          _storage.read(activeSessionIdKey),
          _readSession(candidateSessionId),
        ]);
        final current = reads[0] as String?;
        if (current != expectedCurrentSessionId) throw ActiveSessionConflict();
        final candidate = reads[1] as AccountSession?;
        if (candidate == null) throw CandidateSessionNotFound();
        if (canCommit != null && !canCommit()) {
          throw ActiveCandidateDiscarded();
        }
        await _storage.write(activeSessionIdKey, candidate.sessionId);
      });

  Future<AccountSession?> loadActiveSession() => _lock.synchronized(() async {
        final sessionId = await _storage.read(activeSessionIdKey);
        if (sessionId == null || sessionId.isEmpty) return null;
        return _readSession(sessionId);
      });

  @override
  Future<ActiveAccountSession?> loadActive() => _lock.synchronized(() async {
        final activation = await _readActiveActivationV3();
        if (activation != null) {
          return _composeActiveV3(activation);
        }
        final sessionId = await _storage.read(activeSessionIdKey);
        if (sessionId == null || sessionId.isEmpty) return null;
        final session = await _readSession(sessionId);
        if (session == null) return null;
        final credentials = await _readCredentials(session);
        if (credentials == null) return null;
        return ActiveAccountSession(
          session: session,
          credentials: credentials,
        );
      });

  @override
  Future<void> replaceActiveCredentials({
    required String expectedCurrentSessionId,
    required SessionCredentials credentials,
  }) =>
      _lock.synchronized(() async {
        final activation = await _readActiveActivationV3();
        if (activation != null) {
          if (activation.activationId != expectedCurrentSessionId) {
            throw ActiveSessionConflict();
          }
          _validateCredentials(credentials);
          final storedKey = _spaceSessionV3Key(activation.scope);
          final stored = await _readStoredSpace(storedKey);
          if (stored == null ||
              stored.spaceSessionId != activation.spaceSessionId) {
            throw CandidateSessionNotFound();
          }
          final updated = StoredSpaceSession(
            spaceSessionId: stored.spaceSessionId,
            scope: stored.scope,
            accessToken: credentials.tenantAccessToken,
            refreshToken: credentials.tenantRefreshToken,
            accessTokenIssuedAt: stored.accessTokenIssuedAt,
            accessTokenExpiresAt: stored.accessTokenExpiresAt,
          );
          await _storage.write(storedKey, jsonEncode(updated.toJson()));
          _storedSpaceCache[storedKey] = updated;
          final platformKey = _platformCredentialV3Key(
            PlatformAccountScope.fromAccountScope(activation.scope),
          );
          await _storage.write(
            platformKey,
            jsonEncode(<String, Object?>{
              'platformAccessToken': credentials.platformAccessToken,
              'platformRefreshToken': credentials.platformRefreshToken,
              'deviceSessionToken': credentials.deviceSessionToken,
            }),
          );
          _platformCredentialCache[platformKey] = _PlatformCredentialsV3(
            accessToken: credentials.platformAccessToken,
            refreshToken: credentials.platformRefreshToken,
            deviceSessionToken: credentials.deviceSessionToken,
          );
          return;
        }
        final current = await _storage.read(activeSessionIdKey);
        if (current != expectedCurrentSessionId) {
          throw ActiveSessionConflict();
        }
        final session = await _readSession(expectedCurrentSessionId);
        if (session == null) throw CandidateSessionNotFound();
        await _storage.write(
          session.tenantCredentialKey,
          jsonEncode(credentials.toJson()),
        );
        if (session.platformCredentialKey case final key?) {
          await _storage.write(
            key,
            jsonEncode(<String, Object?>{
              'platformAccessToken': credentials.platformAccessToken,
              'platformRefreshToken': credentials.platformRefreshToken,
              'deviceSessionToken': credentials.deviceSessionToken,
            }),
          );
        }
      });

  Future<StoredSpaceSession?> _loadReusableSpaceUnlocked({
    required PlatformAccountScope platformAccount,
    required String spaceId,
  }) async {
    final normalizedSpaceId = spaceId.trim();
    if (normalizedSpaceId.isEmpty) return null;
    final lookupKey = _spaceLookupV3Key(platformAccount, normalizedSpaceId);
    final recordKey =
        _spaceLookupCache[lookupKey] ?? await _storage.read(lookupKey);
    if (recordKey == null || recordKey.isEmpty) return null;
    _spaceLookupCache[lookupKey] = recordKey;
    final stored = await _readStoredSpace(recordKey);
    if (stored == null ||
        stored.scope.serviceRealmId != platformAccount.serviceRealmId ||
        stored.scope.platformUserId != platformAccount.platformUserId ||
        stored.scope.spaceId != normalizedSpaceId) {
      return null;
    }
    return stored;
  }

  Future<ActiveAccountSession> _activateStoredSpaceUnlocked({
    required StoredSpaceSession target,
    required String? expectedActivationId,
    required int identityRevision,
    required bool Function() canCommit,
    String? activationId,
    bool restorePersonalOnRestart = false,
  }) async {
    final current = await _readActiveActivationV3();
    final legacyActiveId =
        current == null ? await _storage.read(activeSessionIdKey) : null;
    final currentActivationId = current?.activationId ?? legacyActiveId;
    if (currentActivationId != expectedActivationId) {
      throw ActiveSessionConflict();
    }
    if (restorePersonalOnRestart &&
        (current?.scope.spaceId != 'personal' ||
            current?.scope.serviceRealmId != target.scope.serviceRealmId ||
            current?.scope.platformUserId != target.scope.platformUserId)) {
      throw ActiveSessionConflict();
    }
    final stored = await _readStoredSpace(_spaceSessionV3Key(target.scope));
    if (stored == null || stored.spaceSessionId != target.spaceSessionId) {
      throw CandidateSessionNotFound();
    }
    if (!canCommit()) throw ActiveCandidateDiscarded();
    final activation = AccountActivation(
      activationId: activationId,
      spaceSessionId: stored.spaceSessionId,
      scope: stored.scope,
      identityRevision: identityRevision,
      restorePersonalOnRestart: restorePersonalOnRestart,
    );
    await _storage.write(
      activeActivationV3Key,
      jsonEncode(activation.toJson()),
    );
    if (legacyActiveId != null) {
      try {
        await _storage.delete(activeSessionIdKey);
      } catch (error) {
        AppDiagnostics.instance.warning(
          'auth.v2_pointer_cleanup_failed',
          'V3 activation committed but legacy pointer cleanup failed',
          context: {'errorType': error.runtimeType.toString()},
        );
      }
    }
    final composed = await _composeActiveV3(activation);
    if (!canCommit()) {
      // The store lock still owns the activation pointer. If a newer auth
      // operation began during secure storage I/O, restore the previous CAS
      // value before allowing its activation to run.
      if (current == null) {
        await _storage.delete(activeActivationV3Key);
      } else {
        await _storage.write(
            activeActivationV3Key, jsonEncode(current.toJson()));
      }
      if (legacyActiveId != null) {
        await _storage.write(activeSessionIdKey, legacyActiveId);
      }
      throw ActiveCandidateDiscarded();
    }
    if (composed == null) throw CandidateSessionNotFound();
    return composed;
  }

  Future<AccountActivation?> _readActiveActivationV3() async {
    final raw = await _storage.read(activeActivationV3Key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return AccountActivation.tryFromJson(jsonDecode(raw));
    } on FormatException {
      return null;
    }
  }

  Future<ActiveAccountSession?> _composeActiveV3(
    AccountActivation activation,
  ) async {
    final stored = await _readStoredSpace(_spaceSessionV3Key(activation.scope));
    if (stored == null || stored.spaceSessionId != activation.spaceSessionId) {
      return null;
    }
    final platform = await _readPlatformCredentials(
      PlatformAccountScope.fromAccountScope(activation.scope),
    );
    final session = AccountSession(
      scope: activation.scope,
      identityRevision: activation.identityRevision,
      sessionId: activation.activationId,
      hasPlatformCredential: platform?.accessToken?.isNotEmpty == true,
    );
    return ActiveAccountSession(
      session: session,
      credentials: SessionCredentials(
        tenantAccessToken: stored.accessToken,
        tenantRefreshToken: stored.refreshToken,
        platformAccessToken: platform?.accessToken,
        platformRefreshToken: platform?.refreshToken,
        deviceSessionToken: platform?.deviceSessionToken,
      ),
      spaceSessionId: stored.spaceSessionId,
      accessTokenIssuedAt: stored.accessTokenIssuedAt,
      accessTokenExpiresAt: stored.accessTokenExpiresAt,
    );
  }

  Future<StoredSpaceSession?> _readStoredSpace(String key) async {
    final cached = _storedSpaceCache[key];
    if (cached != null) return cached;
    final raw = await _storage.read(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final stored = StoredSpaceSession.tryFromJson(jsonDecode(raw));
      if (stored != null) _storedSpaceCache[key] = stored;
      return stored;
    } on FormatException {
      return null;
    }
  }

  Future<_PlatformCredentialsV3?> _readPlatformCredentials(
    PlatformAccountScope account,
  ) async {
    final key = _platformCredentialV3Key(account);
    final cached = _platformCredentialCache[key];
    if (cached != null) return cached;
    final raw = await _storage.read(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      final credentials = _PlatformCredentialsV3(
        accessToken: decoded['platformAccessToken'] as String?,
        refreshToken: decoded['platformRefreshToken'] as String?,
        deviceSessionToken: decoded['deviceSessionToken'] as String?,
      );
      _platformCredentialCache[key] = credentials;
      return credentials;
    } on FormatException {
      return null;
    }
  }

  Future<List<String>> _readStringList(String key) async {
    final raw = await _storage.read(key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<String>()
          .where((value) => value.isNotEmpty)
          .toList();
    } on FormatException {
      return const [];
    }
  }

  static void _validateCredentials(SessionCredentials credentials) {
    if (credentials.tenantAccessToken.trim().isEmpty ||
        credentials.tenantRefreshToken.trim().isEmpty) {
      throw ArgumentError('tenant credentials must not be empty');
    }
  }

  static String _platformCredentialV3Key(PlatformAccountScope account) =>
      'platform_credentials_v3_${account.storageKeyHash}';

  static String _platformSpaceIndexV3Key(PlatformAccountScope account) =>
      'space_session_index_v3_${account.storageKeyHash}';

  static String _spaceLookupV3Key(
    PlatformAccountScope account,
    String spaceId,
  ) =>
      'space_session_lookup_v3_${account.storageKeyHash}_${AccountSession.hashSessionId(spaceId.trim())}';

  static String _spaceSessionV3Key(AccountScope scope) =>
      'space_session_v3_${scope.storageKeyHash}';

  static String _spaceSessionIdIndexV3Key(String spaceSessionId) =>
      'space_session_id_v3_${AccountSession.hashSessionId(spaceSessionId)}';

  @override
  Future<void> discardCandidate(String candidateSessionId) =>
      _lock.synchronized(() async {
        if (await _storage.read(activeSessionIdKey) == candidateSessionId) {
          throw ActiveCandidateDiscarded();
        }
        final candidate = await _readSession(candidateSessionId);
        if (candidate == null) return;
        await _deleteSession(candidate);
      });

  @override
  Future<void> clearActiveSession({
    required String expectedCurrentSessionId,
  }) =>
      _lock.synchronized(() async {
        final current = await _storage.read(activeSessionIdKey);
        if (current != expectedCurrentSessionId) throw ActiveSessionConflict();
        final active = await _readSession(expectedCurrentSessionId);
        await _storage.delete(activeSessionIdKey);
        if (active != null) await _deleteSession(active);
      });

  Future<AccountSessionRecoveryState> recoveryState() =>
      _lock.synchronized(() async {
        final activeId = await _storage.read(activeSessionIdKey);
        if (activeId != null && activeId.isNotEmpty) {
          return await _readSession(activeId) == null
              ? AccountSessionRecoveryState.invalidV2
              : AccountSessionRecoveryState.activeV2;
        }
        final legacySpace =
            await _storage.read(SecureStorageService.activeSpaceIdKey);
        final legacyPlatform =
            await _storage.read(SecureStorageService.platformTokenKey);
        return (legacySpace?.isNotEmpty == true ||
                legacyPlatform?.isNotEmpty == true)
            ? AccountSessionRecoveryState.legacyOnly
            : AccountSessionRecoveryState.empty;
      });

  Future<AccountSession?> _readSession(String sessionId) async {
    final indexKey = _candidateIndexKey(sessionId);
    final descriptorKey = await _storage.read(indexKey);
    if (descriptorKey == null) return null;
    final raw = await _storage.read(descriptorKey);
    if (raw == null) return null;
    try {
      return AccountSession.tryFromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  Future<SessionCredentials?> _readCredentials(AccountSession session) async {
    final tenantRaw = await _storage.read(session.tenantCredentialKey);
    if (tenantRaw == null) return null;
    try {
      final tenant = SessionCredentials.tryFromJson(jsonDecode(tenantRaw));
      if (tenant == null) return null;
      if (!session.hasPlatformCredential) return tenant;
      final platformKey = session.platformCredentialKey;
      if (platformKey == null) return null;
      final platformRaw = await _storage.read(platformKey);
      if (platformRaw == null) return null;
      final platform = jsonDecode(platformRaw);
      if (platform is! Map<String, dynamic>) return null;
      return SessionCredentials(
        tenantAccessToken: tenant.tenantAccessToken,
        tenantRefreshToken: tenant.tenantRefreshToken,
        platformAccessToken: platform['platformAccessToken'] as String?,
        platformRefreshToken: platform['platformRefreshToken'] as String?,
        deviceSessionToken: platform['deviceSessionToken'] as String?,
        adminToken: tenant.adminToken,
      );
    } on FormatException {
      return null;
    }
  }

  Future<void> _deleteSession(AccountSession session) async {
    await Future.wait([
      _storage.delete(session.descriptorKey),
      _storage.delete(session.tenantCredentialKey),
      if (session.platformCredentialKey case final key?) _storage.delete(key),
      if (session.adminCredentialKey case final key?) _storage.delete(key),
      _storage.delete(_candidateIndexKey(session.sessionId)),
    ]);
  }

  static String _candidateIndexKey(String sessionId) =>
      'session_descriptor_index_v2_${AccountSession.hashSessionId(sessionId)}';

  static String _recordCategory(String key) {
    if (key.startsWith('session_descriptor_index_v2_')) return 'index';
    if (key.startsWith('session_descriptor_v2_')) return 'descriptor';
    if (key.startsWith('tenant_credential_v2_')) {
      return 'tenant_credentials';
    }
    if (key.startsWith('platform_credential_v2_')) {
      return 'platform_credentials';
    }
    if (key.startsWith('admin_credential_v2_')) {
      return 'admin_credentials';
    }
    return 'unknown';
  }
}

final class _PlatformCredentialsV3 {
  const _PlatformCredentialsV3({
    required this.accessToken,
    required this.refreshToken,
    required this.deviceSessionToken,
  });

  final String? accessToken;
  final String? refreshToken;
  final String? deviceSessionToken;
}
