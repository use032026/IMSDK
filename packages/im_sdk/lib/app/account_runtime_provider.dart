import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_logout_reason.dart';
import 'package:im_sdk/core/admin/admin_http_client.dart';
import 'package:im_sdk/core/auth/account_session.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/http_client.dart';
import 'package:im_sdk/core/runtime/account_runtime.dart';
import 'package:im_sdk/core/space/space_transition.dart';
import 'package:im_sdk/core/storage/account_storage_registry.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:path_provider/path_provider.dart';

final accountStorageRegistryProvider = FutureProvider<AccountStorageRegistry>(
  (ref) async {
    final documentsRoot = await getApplicationDocumentsDirectory();
    return AccountStorageRegistry(documentsRoot: documentsRoot);
  },
);

final accountRuntimeProvider =
    NotifierProvider<AccountRuntimeNotifier, AsyncValue<AccountRuntime?>>(
  AccountRuntimeNotifier.new,
);

/// The only runtime that may be installed into the authenticated widget tree.
/// AsyncValue can retain a previous value while rebuilding, so consumers must
/// use this scope-checked view instead of reading `valueOrNull` directly.
final activeAccountRuntimeProvider = Provider<AccountRuntime?>((ref) {
  final expectedSession = ref.watch(activeAccountSessionProvider);
  final candidate = ref.watch(accountRuntimeProvider).valueOrNull;
  if (expectedSession == null ||
      candidate == null ||
      candidate.lifecycle != AccountRuntimeLifecycle.active) {
    return null;
  }
  if (candidate.session.sessionId == expectedSession.sessionId &&
      candidate.session.scope == expectedSession.scope) {
    return candidate;
  }
  final transition = ref.watch(spaceTransitionProvider);
  if (transition.phase == SpaceTransitionPhase.failed &&
      candidate.session.scope == expectedSession.scope) {
    return candidate;
  }
  final samePlatformAccount = candidate.session.scope.serviceRealmId ==
          expectedSession.scope.serviceRealmId &&
      candidate.session.scope.platformUserId ==
          expectedSession.scope.platformUserId;
  return transition.isInProgress && samePlatformAccount ? candidate : null;
});

/// Owns the single authenticated runtime installed in the application.
///
/// A space change prepares its candidate while the source runtime stays
/// active, then commits exactly one revision and retires the source. Account
/// changes remain fail-closed through [activeAccountRuntimeProvider]. A
/// superseded candidate is retired immediately and is never exposed.
class AccountRuntimeNotifier extends Notifier<AsyncValue<AccountRuntime?>> {
  AccountRuntime? _active;
  AccountRuntime? _pendingRetirement;
  AccountSession? _requestedSession;
  bool _hasRequestedSession = false;
  int _transitionRevision = 0;
  Future<void> _transitionTail = Future<void>.value();

  @override
  AsyncValue<AccountRuntime?> build() {
    final initialSession = ref.read(activeAccountSessionProvider);
    _requestedSession = initialSession;
    _hasRequestedSession = true;
    ref.listen(activeAccountSessionProvider, (_, next) {
      if (_hasRequestedSession &&
          next?.sessionId == _requestedSession?.sessionId) {
        return;
      }
      _schedule(next);
    });
    ref.onDispose(() {
      _transitionRevision += 1;
      final active = _active;
      final pendingRetirement = _pendingRetirement;
      _active = null;
      _pendingRetirement = null;
      if (active != null) unawaited(active.retire());
      if (pendingRetirement != null && !identical(pendingRetirement, active)) {
        unawaited(pendingRetirement.retire());
      }
    });
    final initialRevision = ++_transitionRevision;
    _transitionTail = Future<void>.sync(
      () => _transitionTo(initialSession, initialRevision),
    );
    return const AsyncLoading();
  }

  void retry() => _schedule(ref.read(activeAccountSessionProvider));

  Future<void> retireCommittedSource(AccountRuntime installed) async {
    if (!identical(_active, installed)) return;
    final source = _pendingRetirement;
    if (source == null) return;
    _pendingRetirement = null;
    await source.retire();
  }

  void _schedule(AccountSession? session) {
    _requestedSession = session;
    _hasRequestedSession = true;
    final revision = ++_transitionRevision;
    final active = _active;
    state = active == null
        ? const AsyncLoading()
        : const AsyncLoading<AccountRuntime?>().copyWithPrevious(
            AsyncData<AccountRuntime?>(active),
          );
    _transitionTail = _transitionTail.then(
      (_) => _transitionTo(session, revision),
      onError: (_) => _transitionTo(session, revision),
    );
  }

  Future<void> _transitionTo(AccountSession? session, int revision) async {
    try {
      final previous = _active;
      if (session == null) {
        _active = null;
        final pendingRetirement = _pendingRetirement;
        _pendingRetirement = null;
        if (previous != null) await previous.retire();
        if (pendingRetirement != null &&
            !identical(pendingRetirement, previous)) {
          await pendingRetirement.retire();
        }
        if (revision != _transitionRevision) return;
        state = const AsyncData(null);
        return;
      }

      if (previous?.session.sessionId == session.sessionId &&
          previous?.session.scope == session.scope &&
          previous?.lifecycle == AccountRuntimeLifecycle.active) {
        state = AsyncData(previous);
        return;
      }

      final registry = await ref.read(accountStorageRegistryProvider.future);
      if (revision != _transitionRevision) return;

      final pendingRetirement = _pendingRetirement;
      if (pendingRetirement != null) {
        _pendingRetirement = null;
        await pendingRetirement.retire();
        if (revision != _transitionRevision) return;
      }

      // Different account-space stores can be opened while the source runtime
      // remains active. This gives space switching an atomic handoff: a target
      // open failure never tears down the source store. Re-authentication of
      // the exact same store must still retire its lease before reopening.
      final reopensSameStore = previous?.session.scope.storageKeyHash ==
          session.scope.storageKeyHash;
      if (reopensSameStore && previous != null) {
        _active = null;
        await previous.retire();
        if (revision != _transitionRevision) return;
      }
      final candidate = await _buildCandidate(
        registry: registry,
        session: session,
        revision: revision,
      );
      if (revision != _transitionRevision) {
        await candidate.retire();
        return;
      }
      await candidate.activate();
      if (revision != _transitionRevision) {
        await candidate.retire();
        return;
      }
      _active = candidate;
      state = AsyncData(candidate);
      if (!reopensSameStore && previous != null) {
        _pendingRetirement = previous;
      }
    } catch (error, stackTrace) {
      if (revision == _transitionRevision) {
        final active = _active;
        state = active == null
            ? AsyncError(error, stackTrace)
            : AsyncError<AccountRuntime?>(error, stackTrace).copyWithPrevious(
                AsyncData<AccountRuntime?>(active),
              );
      }
    }
  }

  Future<AccountRuntime> _buildCandidate({
    required AccountStorageRegistry registry,
    required AccountSession session,
    required int revision,
  }) async {
    final storage = await registry.open(session: session);
    HttpClient? accountHttpClient;
    AdminHttpClient? accountAdminHttpClient;
    try {
      bool operationIsCurrent() =>
          revision == _transitionRevision &&
          ref.read(activeAccountSessionProvider)?.sessionId ==
              session.sessionId;
      final secureStorage = ref.read(secureStorageProvider);
      accountHttpClient = HttpClient(
        diagnosticScope: () => DiagnosticScope.account(session.scope),
        storage: secureStorage,
        operationIsCurrent: operationIsCurrent,
        // Platform rotation belongs to the root account, not this activation.
        // Its durable write must complete even if a space switch retires us.
        platformSessionRefresher: () =>
            ref.read(httpClientProvider).refreshPlatformSession(),
        tokenGetter: () {
          if (!operationIsCurrent()) return null;
          return ref.read(currentSpaceProvider)?.accessToken;
        },
        activeSpaceIdGetter: () {
          if (!operationIsCurrent()) return null;
          return session.scope.spaceId;
        },
        refreshTokenGetter: () {
          if (!operationIsCurrent()) return null;
          return ref.read(currentSpaceProvider)?.refreshToken;
        },
        platformTokenGetter: () {
          if (!operationIsCurrent()) return null;
          return ref.read(authProvider).valueOrNull?.platformToken;
        },
        platformRefreshTokenGetter: () {
          if (!operationIsCurrent()) return null;
          return ref.read(authProvider.notifier).currentPlatformRefreshToken;
        },
        deviceSessionTokenGetter: () {
          if (!operationIsCurrent()) return null;
          return ref.read(authProvider.notifier).currentDeviceSessionToken;
        },
        allowLegacyCredentialFallback: false,
        persistLegacyCredentialMirror: false,
        onAuthFailed: (error) {
          if (operationIsCurrent()) {
            unawaited(ref.read(authProvider.notifier).logout(
                  reason: AuthLogoutReason.httpAuthenticationFailed,
                  serverCode: error.code,
                ));
          }
        },
        onTenantTokenRefreshed: (spaceId, token, refreshToken) {
          if (operationIsCurrent() && spaceId == session.scope.spaceId) {
            return ref.read(authProvider.notifier).updateTenantToken(
                  spaceId,
                  token,
                  newRefreshToken: refreshToken,
                );
          }
        },
      );
      accountAdminHttpClient = AdminHttpClient(
        diagnosticScope: () => DiagnosticScope.account(session.scope),
        storage: secureStorage,
        operationIsCurrent: operationIsCurrent,
        platformTokenGetter: () {
          if (!operationIsCurrent()) return null;
          return ref.read(authProvider).valueOrNull?.platformToken;
        },
        credentialOwnerGetter: () => session.scope.storageKeyHash,
        spaceGetter: () {
          if (!operationIsCurrent()) return null;
          return ref.read(currentSpaceProvider);
        },
      );
      return AccountRuntime(
        session: session,
        accountStorageContext: storage,
        providerOverrides: [
          httpClientProvider.overrideWithValue(accountHttpClient),
          dioProvider.overrideWithValue(accountHttpClient.dio),
          adminHttpClientProvider.overrideWithValue(accountAdminHttpClient),
          adminDioProvider.overrideWithValue(accountAdminHttpClient.dio),
        ],
        onRetired: () async {
          accountAdminHttpClient?.close();
          accountHttpClient?.close();
        },
      );
    } catch (_) {
      accountAdminHttpClient?.close();
      accountHttpClient?.close();
      await storage.release();
      rethrow;
    }
  }
}
