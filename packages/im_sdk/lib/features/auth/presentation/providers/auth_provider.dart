import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/auth/token_refresh_service.dart';
import 'package:im_sdk/core/auth/account_session.dart';
import 'package:im_sdk/core/auth/account_session_store.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/network/service_realm_config.dart';
import 'package:im_sdk/core/platform/app_platform.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/core/space/account_scope.dart';
import 'package:im_sdk/core/space/space_transition.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';
import 'package:im_sdk/features/auth/application/logout_guard.dart';
import 'package:im_sdk/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:im_sdk/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:im_sdk/features/auth/data/stores/platform_tenant_directory_store.dart';
import 'package:im_sdk/features/auth/application/login_identifier_cache.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_entities.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_logout_reason.dart';
import 'package:im_sdk/features/auth/domain/repositories/auth_repository.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/chat/data/repositories/draft_translation_selection_repository.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/space/data/datasources/platform_tenant_datasource.dart';
import 'package:im_sdk/features/space/data/models/enterprise_join_models.dart';
import 'package:im_sdk/features/space/presentation/providers/spaces_provider.dart';

// ---------------------------------------------------------------------------
// Auth Status
// ---------------------------------------------------------------------------

enum AuthStatus { unknown, authenticated, unauthenticated }

enum _IdentityRefreshResult { applied, failed, superseded }

bool _spaceTypeConflictsWithMembershipRole(
  SpaceContext space,
  int membershipRole,
) =>
    // role=0 不能单独区分普通员工和企业客户，必须重新读取当前租户的
    // userType；不能沿用上一轮 SpaceType 参与权限判断。
    membershipRole == 0 || !space.isEmployee;

bool _isEmployeeTenantIdentity({
  required int membershipRole,
  required int? userType,
}) =>
    membershipRole > 0 || userType == 2;

// ---------------------------------------------------------------------------
// Auth State
// ---------------------------------------------------------------------------

class AuthState {
  final AuthStatus status;
  final SpaceContext? currentSpace;
  final List<TenantSummary> availableTenants;
  final String? platformToken;
  final String? platformUserId;
  final AuthPresentationFailure? error;
  final AccountSession? accountSession;

  /// 账号处于注销冷静期（7天内可撤销）
  final bool isPendingDeactivation;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.currentSpace,
    this.availableTenants = const [],
    this.platformToken,
    this.platformUserId,
    this.error,
    this.accountSession,
    this.isPendingDeactivation = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    SpaceContext? currentSpace,
    List<TenantSummary>? availableTenants,
    String? platformToken,
    String? platformUserId,
    AuthPresentationFailure? error,
    bool clearError = false,
    AccountSession? accountSession,
    bool clearAccountSession = false,
    bool clearCurrentSpace = false,
    bool clearPlatformToken = false,
    bool clearPlatformUserId = false,
    bool? isPendingDeactivation,
  }) {
    return AuthState(
      status: status ?? this.status,
      currentSpace:
          clearCurrentSpace ? null : (currentSpace ?? this.currentSpace),
      availableTenants: availableTenants ?? this.availableTenants,
      platformToken:
          clearPlatformToken ? null : (platformToken ?? this.platformToken),
      platformUserId:
          clearPlatformUserId ? null : (platformUserId ?? this.platformUserId),
      error: clearError ? null : (error ?? this.error),
      accountSession:
          clearAccountSession ? null : (accountSession ?? this.accountSession),
      isPendingDeactivation:
          isPendingDeactivation ?? this.isPendingDeactivation,
    );
  }
}

enum AuthPresentationFailure {
  spaceIdentityValidation,
  personalSpaceRestore,
  joinEnterprise,
  tenantDirectory,
  spaceSwitch,
}

class _ReusableSpaceRefreshFailed implements Exception {
  const _ReusableSpaceRefreshFailed(this.cause);
  final Object cause;
}

AccountScope? accountScopeFromAuthState(
  AuthState state, {
  required String serviceRealmId,
}) {
  if (state.status != AuthStatus.authenticated) return null;
  final space = state.currentSpace;
  final platformUserId = state.platformUserId;
  if (space == null || platformUserId == null) return null;
  return AccountScope.tryFromSpace(
    serviceRealmId: serviceRealmId,
    platformUserId: platformUserId,
    space: space,
  );
}

bool authStateNeedsSpaceSelection(AuthState state) {
  return state.status == AuthStatus.unauthenticated &&
      state.platformToken != null &&
      state.currentSpace == null;
}

AccountSession? activeAccountSessionFromAuthState(AuthState state) {
  if (state.status != AuthStatus.authenticated) return null;
  final session = state.accountSession;
  final space = state.currentSpace;
  if (session == null ||
      space == null ||
      session.scope.spaceId != space.spaceId ||
      session.scope.userId != space.userId ||
      session.scope.platformUserId != state.platformUserId) {
    return null;
  }
  return session;
}

/// Selects a tenant only when the authenticated account currently belongs to it.
String? resolveAuthorizedTenantId({
  required List<TenantSummary> tenants,
  String? rememberedSpaceId,
  int spaceType = 0,
  String? suggestedTenantId,
}) {
  final tenantIds = tenants.map((tenant) => tenant.tenantId).toSet();
  if (rememberedSpaceId != null && tenantIds.contains(rememberedSpaceId)) {
    return rememberedSpaceId;
  }
  if (spaceType == 2 &&
      suggestedTenantId != null &&
      tenantIds.contains(suggestedTenantId)) {
    return suggestedTenantId;
  }
  return tenants.isEmpty ? null : tenants.first.tenantId;
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final _authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final dataSource = AuthRemoteDataSourceImpl(dio);
  return AuthRepositoryImpl(dataSource);
});

/// SDK hosts supply a fresh verified session explicitly. Keep legacy App
/// restoration available only when this owner is used outside the SDK host.
final externalSessionOnlyProvider = Provider<bool>((ref) => false);

final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final accountSessionStoreProvider = Provider<SecureAccountSessionStore>(
  (ref) => SecureAccountSessionStore(ref.watch(secureStorageProvider)),
);

final platformTenantDirectoryStoreProvider =
    Provider<PlatformTenantDirectoryStore>(
  (ref) => PlatformTenantDirectoryStore(ref.watch(secureStorageProvider)),
);

final activeAccountSessionProvider = Provider<AccountSession?>((ref) {
  final state = ref.watch(authProvider).valueOrNull;
  return state == null ? null : activeAccountSessionFromAuthState(state);
});

final accountScopeProvider = Provider<AccountScope?>((ref) {
  return ref.watch(activeAccountSessionProvider)?.scope;
});

// ---------------------------------------------------------------------------
// AuthNotifier
// ---------------------------------------------------------------------------

class AuthNotifier extends AsyncNotifier<AuthState> {
  /// Application flows may outlive the source space's ProviderScope while
  /// Auth remains the root owner of the committed identity.
  AuthState? get snapshot => state.valueOrNull;

  static const _startupStorageTimeout = Duration(seconds: 4);

  AuthRepository get _repo => ref.read(_authRepositoryProvider);
  SecureStorageService get _storage => ref.read(secureStorageProvider);
  SecureAccountSessionStore get _sessionStore =>
      ref.read(accountSessionStoreProvider);
  PlatformTenantDirectoryStore get _tenantDirectoryStore =>
      ref.read(platformTenantDirectoryStoreProvider);

  Future<void>? _logoutCleanupFuture;
  Future<void>? _logoutTransitionFuture;
  Future<void>? _platformRefreshFuture;
  String? _platformRefreshSessionId;
  Future<void>? _spaceSelectionFuture;
  Future<void>? _leaveEnterpriseFuture;
  Future<bool>? _officialConversationReturnFuture;
  String? _officialConversationActivationId;
  String? _returningOfficialActivationId;
  String? _spaceSelectionTarget;
  Future<void> _authMutationTail = Future<void>.value();
  Future<void> _lastActiveSpaceWriteTail = Future<void>.value();
  AccountSession? _committedSession;
  SessionCredentials? _committedCredentials;
  String? _pendingPlatformRefreshToken;
  String? _pendingDeviceSessionToken;
  int _identityRevision = 0;
  int _authOperationGeneration = 0;
  int _tenantDirectoryRefreshGeneration = 0;
  AuthState? _spaceTransitionRollbackState;
  int? _activeSpaceTransitionRevision;

  void _installIdentityProjection(
    SpaceContext? nextSpace,
    AccountSession? nextSession,
  ) {
    final operationManager =
        ref.read(currentAccountOperationContextProvider.notifier);
    final currentOperation = ref.read(currentAccountOperationContextProvider);
    final nextOperation = nextSession == null
        ? null
        : AccountOperationContext(
            accountScopeKey: nextSession.scope.scopeKey,
            identityRevision: nextSession.identityRevision,
            sessionId: nextSession.sessionId,
          );
    final sameOperation = currentOperation != null &&
        nextOperation != null &&
        currentOperation.accountScopeKey == nextOperation.accountScopeKey &&
        currentOperation.identityRevision == nextOperation.identityRevision &&
        currentOperation.sessionId == nextOperation.sessionId;
    if (!sameOperation) operationManager.clear();

    final manager = ref.read(currentSpaceProvider.notifier);
    if (nextSpace == null) {
      manager.clearSpace();
    } else {
      manager.setSpace(nextSpace);
    }
    if (nextOperation != null && !sameOperation) {
      operationManager.setContext(nextOperation);
    }
  }

  void _publishAuthState(AuthState next) {
    final nextSession = activeAccountSessionFromAuthState(next);
    if (nextSession?.sessionId != _officialConversationActivationId) {
      _officialConversationActivationId = null;
    }
    if (next.status == AuthStatus.authenticated && nextSession == null) {
      throw StateError(
        'Authenticated state requires one matching account session and space',
      );
    }
    if (next.status != AuthStatus.authenticated &&
        (next.currentSpace != null || next.accountSession != null)) {
      throw StateError(
        'Restricted auth state cannot retain an account session or space',
      );
    }
    final transition = ref.read(spaceTransitionProvider);
    if (transition.isInProgress &&
        transition.targetSpaceId == next.currentSpace?.spaceId) {
      ref
          .read(spaceTransitionProvider.notifier)
          .markActivating(transition.revision);
    }
    _installIdentityProjection(next.currentSpace, nextSession);
    state = AsyncData(next);
  }

  Future<int?> _beginSpaceTransition(
    String targetSpaceId,
    AuthState? current,
    int authOperation,
  ) async {
    if (current?.status != AuthStatus.authenticated ||
        current?.accountSession == null ||
        current?.currentSpace == null) {
      await _beginIdentityTransition(authOperation);
      return null;
    }
    final authenticatedCurrent = current!;
    final revision =
        ref.read(spaceTransitionProvider.notifier).begin(targetSpaceId);
    _spaceTransitionRollbackState = authenticatedCurrent;
    _activeSpaceTransitionRevision = revision;
    final leavingCredentialOwner =
        authenticatedCurrent.accountSession!.scope.storageKeyHash;
    TokenRefreshService.instance.stop();
    state = const AsyncLoading<AuthState>().copyWithPrevious(
      AsyncData<AuthState>(authenticatedCurrent),
    );
    await _storage.clearAdminCredentialsForOwner(leavingCredentialOwner);
    _ensureAuthOperationCurrent(authOperation);
    return revision;
  }

  void _failSpaceTransition(
    AuthState previous,
    int? revision,
    Object error,
    StackTrace stackTrace,
  ) {
    if (revision == null) {
      state = AsyncError(error, stackTrace);
      return;
    }
    _publishAuthState(
      previous.copyWith(error: AuthPresentationFailure.spaceSwitch),
    );
    _startTokenRefresh();
    ref.read(spaceTransitionProvider.notifier).fail(revision, error);
    _spaceTransitionRollbackState = null;
    _activeSpaceTransitionRevision = null;
  }

  void completeSpaceTransition(int revision) {
    if (_activeSpaceTransitionRevision != revision) return;
    ref.read(spaceTransitionProvider.notifier).complete(revision);
    _spaceTransitionRollbackState = null;
    _activeSpaceTransitionRevision = null;
  }

  Future<void> rollbackSpaceTransition(Object error) async {
    final transition = ref.read(spaceTransitionProvider);
    final previous = _spaceTransitionRollbackState;
    if (!transition.isInProgress || previous == null) return;
    final previousSpace = previous.currentSpace;
    final platformUserId = previous.platformUserId;
    if (previousSpace == null || platformUserId == null) return;
    final authOperation = _authOperationGeneration;
    final expectedActivationId = _committedSession?.sessionId;
    bool isCurrent() =>
        _isAuthOperationCurrent(authOperation) &&
        _activeSpaceTransitionRevision == transition.revision &&
        ref.read(spaceTransitionProvider).revision == transition.revision &&
        ref.read(spaceTransitionProvider).isInProgress;

    try {
      final stored = await _sessionStore.loadReusableSpace(
        platformAccount: PlatformAccountScope(
          serviceRealmId: ServiceRealmConfig.current.realmId,
          platformUserId: platformUserId,
        ),
        spaceId: previousSpace.spaceId,
      );
      if (!isCurrent()) return;
      if (stored == null) throw StateError('来源空间会话不可恢复');
      final restored = await _sessionStore.activateStoredSpace(
        target: stored,
        expectedActivationId: expectedActivationId,
        identityRevision: previous.accountSession!.identityRevision,
        activationId: previous.accountSession!.sessionId,
        canCommit: isCurrent,
        restorePersonalOnRestart: previous.accountSession?.sessionId ==
            _returningOfficialActivationId,
      );
      if (!isCurrent()) return;
      _committedSession = restored.session;
      _committedCredentials = restored.credentials;
      _publishAuthState(previous.copyWith(
        currentSpace: SpaceContext(
          spaceId: previousSpace.spaceId,
          accessToken: restored.credentials.tenantAccessToken,
          refreshToken: restored.credentials.tenantRefreshToken,
          userId: previousSpace.userId,
          type: previousSpace.type,
          membershipRole: previousSpace.membershipRole,
        ),
        accountSession: restored.session,
        platformToken: restored.credentials.platformAccessToken,
        error: AuthPresentationFailure.spaceSwitch,
      ));
      if (previous.accountSession?.sessionId ==
          _returningOfficialActivationId) {
        _officialConversationActivationId = restored.activationId;
      }
      _startTokenRefresh();
    } catch (_) {
      if (isCurrent()) rethrow;
    } finally {
      if (isCurrent()) {
        ref
            .read(spaceTransitionProvider.notifier)
            .fail(transition.revision, error);
        _spaceTransitionRollbackState = null;
        _activeSpaceTransitionRevision = null;
      }
    }
  }

  Future<void> _beginIdentityTransition(int authOperation) async {
    ref.read(spaceTransitionProvider.notifier).cancel();
    _spaceTransitionRollbackState = null;
    _activeSpaceTransitionRevision = null;
    final leavingCredentialOwner = _committedSession?.scope.storageKeyHash;
    TokenRefreshService.instance.stop();
    _installIdentityProjection(null, null);
    state = const AsyncLoading();
    if (leavingCredentialOwner != null && leavingCredentialOwner.isNotEmpty) {
      await _storage.clearAdminCredentialsForOwner(leavingCredentialOwner);
    }
    _ensureAuthOperationCurrent(authOperation);
  }

  bool _isCaptchaError(Object e) {
    if (e is ServerError) {
      final code = e.code.toUpperCase();
      final message = e.message.toLowerCase();
      return code == 'AUTH_CAPTCHA_REQUIRED' ||
          code == 'AUTH_CAPTCHA_INVALID' ||
          message.contains('captcha') ||
          message.contains('图形验证码') ||
          message.contains('安全验证');
    }
    final text = e.toString().toLowerCase();
    return text.contains('auth_captcha_required') ||
        text.contains('auth_captcha_invalid') ||
        text.contains('captcha verification is required') ||
        text.contains('captcha') ||
        text.contains('图形验证码') ||
        text.contains('安全验证');
  }

  @override
  Future<AuthState> build() async {
    final transitionNotifier = ref.read(spaceTransitionProvider.notifier);
    ref.onDispose(() {
      transitionNotifier.cancel();
      ++_authOperationGeneration;
      TokenRefreshService.instance.stop();
    });
    final externalSessionOnly = ref.watch(externalSessionOnlyProvider);
    try {
      if (LogoutGuard.isPending) {
        await _recoverInterruptedLogout().timeout(_startupStorageTimeout);
        return const AuthState(status: AuthStatus.unauthenticated);
      }

      if (externalSessionOnly) {
        // A persisted activation is only a compare-and-set predecessor. It is
        // never restored or used for a request before the host authenticates.
        _committedSession = null;
        _committedCredentials = null;
        // A new SDK container already has null identity projections. Writing
        // another provider synchronously during build violates Riverpod's
        // initialization boundary.
        return const AuthState(status: AuthStatus.unauthenticated);
      }

      // V3 activation 是当前恢复入口；完整 V2 Session 仅作为一次性迁移源。
      // 更旧的 active_space_id/space token 不能创建业务 Runtime。
      // iOS Keychain/Android Keystore 异常不能让启动页永久等待；
      // 超时或读取失败统一降级到未登录态。
      var active = await _sessionStore
          .loadActiveAndMigrateV2()
          .timeout(_startupStorageTimeout);
      if (active == null) {
        return const AuthState(status: AuthStatus.unauthenticated);
      }
      active = await _normalizeLegacyPersonalSession(
        active,
      ).timeout(_startupStorageTimeout);
      final session = active.session;
      final credentials = active.credentials;
      final spaceId = session.scope.spaceId;
      _committedSession = session;
      _committedCredentials = credentials;
      _identityRevision = session.identityRevision;

      // 本地角色只用于空间列表展示。权限必须等待服务端重新确认，避免冷启动
      // 或账号切换时短暂恢复上一轮管理员能力。
      final restoredType = spaceId == 'personal'
          ? SpaceType.personal
          : SpaceType.customerRestricted;
      const restoredRole = 0;
      final space = SpaceContext(
        spaceId: spaceId,
        accessToken: credentials.tenantAccessToken,
        refreshToken: credentials.tenantRefreshToken,
        userId: session.scope.userId,
        type: restoredType,
        membershipRole: restoredRole,
      );

      final directory = await _tenantDirectoryStore
          .load(
            serviceRealmId: session.scope.serviceRealmId,
            platformUserId: session.scope.platformUserId,
          )
          .timeout(_startupStorageTimeout);
      var restoredTenants = directory?.tenants ?? const <TenantSummary>[];
      await _tenantDirectoryStore
          .retireLegacyGlobalDirectory()
          .timeout(_startupStorageTimeout);

      if (spaceId != 'personal' &&
          !restoredTenants.any((tenant) => tenant.tenantId == spaceId)) {
        final platformToken = credentials.platformAccessToken;
        if (platformToken == null || platformToken.isEmpty) {
          throw StateError('未验证企业空间缺少平台凭证');
        }
        late final List<TenantSummary> authoritativeTenants;
        try {
          authoritativeTenants = await _repo
              .getMyTenants(platformToken)
              .timeout(_startupStorageTimeout);
        } catch (_) {
          return AuthState(
            status: AuthStatus.unauthenticated,
            availableTenants: const [],
            platformToken: platformToken,
            platformUserId: session.scope.platformUserId,
            error: AuthPresentationFailure.spaceIdentityValidation,
          );
        }
        await _tenantDirectoryStore
            .replace(
              serviceRealmId: session.scope.serviceRealmId,
              platformUserId: session.scope.platformUserId,
              tenants: authoritativeTenants,
            )
            .timeout(_startupStorageTimeout);
        restoredTenants = authoritativeTenants;
        if (!authoritativeTenants.any((tenant) => tenant.tenantId == spaceId)) {
          late final TenantAuthResult personalResult;
          try {
            personalResult = await _repo
                .selectPersonalSpace(platformToken)
                .timeout(_startupStorageTimeout);
          } catch (_) {
            return AuthState(
              status: AuthStatus.unauthenticated,
              availableTenants: authoritativeTenants,
              platformToken: platformToken,
              platformUserId: session.scope.platformUserId,
              error: AuthPresentationFailure.personalSpaceRestore,
            );
          }
          final personalSpace = SpaceContext(
            spaceId: 'personal',
            accessToken: personalResult.accessToken,
            refreshToken: personalResult.refreshToken,
            userId: personalResult.userId,
            type: SpaceType.personal,
          );
          final personalSession = await _commitAccountSession(
            result: personalResult,
            space: personalSpace,
            platformToken: platformToken,
            platformUserId:
                personalResult.platformUserId ?? session.scope.platformUserId,
            authOperation: null,
          ).timeout(_startupStorageTimeout);
          await _tenantDirectoryStore.writeLastActiveSpace(
            serviceRealmId: personalSession.scope.serviceRealmId,
            platformUserId: personalSession.scope.platformUserId,
            spaceId: 'personal',
          );
          _installIdentityProjection(personalSpace, personalSession);
          _startTokenRefresh();
          return AuthState(
            status: AuthStatus.authenticated,
            currentSpace: personalSpace,
            availableTenants: authoritativeTenants,
            platformToken: platformToken,
            platformUserId: personalSession.scope.platformUserId,
            accountSession: personalSession,
          );
        }
      }

      // 只有完整本地恢复成功后才安装当前空间，避免半恢复状态被 Runtime
      // 或权限 Provider 消费。
      _installIdentityProjection(space, session);

      // 异步恢复租户列表（用于空间切换栏显示）
      if (credentials.platformAccessToken != null) {
        _restoreTenants(
          credentials.platformAccessToken!,
          spaceId,
          AccountOperationContext(
            accountScopeKey: session.scope.scopeKey,
            identityRevision: session.identityRevision,
            sessionId: session.sessionId,
          ),
        );
      }

      // 启动定时 token 刷新（前台 45 分钟，后台 15 分钟）
      _startTokenRefresh();
      // 等 build 提交恢复态后再后台续期，避免续期成功回调早于 state 可写。
      unawaited(
        Future<void>.delayed(Duration.zero, refreshPlatformToken),
      );
      unawaited(Future<void>.delayed(
        Duration.zero,
        () => _restoreUserId(
          spaceId,
          credentials.tenantAccessToken,
          identityRevision: session.identityRevision,
        ),
      ));

      return AuthState(
        status: AuthStatus.authenticated,
        currentSpace: ref.read(currentSpaceProvider) ?? space,
        availableTenants: restoredTenants,
        platformToken: credentials.platformAccessToken,
        platformUserId: session.scope.platformUserId,
        accountSession: session,
      );
    } catch (error, stackTrace) {
      // 本地凭证恢复失败只能降低权限，不能把启动页留在永久 loading。
      // 不自动删除持久化 Session，避免把瞬时 Keychain 故障变成数据丢失；
      // 用户重新登录成功后会由 Session owner 原子替换旧会话。
      _identityRevision += 1;
      _committedSession = null;
      _committedCredentials = null;
      _pendingPlatformRefreshToken = null;
      _pendingDeviceSessionToken = null;
      TokenRefreshService.instance.stop();
      _installIdentityProjection(null, null);
      AppDiagnostics.instance.error(
        'auth.startup_restore_failed',
        'Local account restore failed; continuing signed out',
        context: {
          'errorType': error.runtimeType.toString(),
          'stack': stackTrace.toString(),
        },
      );
      return const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Invalidates a pending external login immediately, before queued teardown.
  /// It cannot grant or restore an identity.
  void invalidateExternalSessionOperation() {
    if (ref.read(externalSessionOnlyProvider)) ++_authOperationGeneration;
  }

  /// Accepts only a server-verified identity from an authenticated SDK host.
  /// No role, admin credential or restored login is trusted from the caller.
  Future<void> acceptExternalSession({
    required AccountScope scope,
    required SessionCredentials credentials,
    required DateTime issuedAt,
    required DateTime expiresAt,
    bool Function()? externalOperationIsCurrent,
    Future<void> Function()? verifyExternalSession,
  }) async {
    if (!ref.read(externalSessionOnlyProvider)) {
      throw StateError(
          'External sessions require an SDK-owned authentication scope');
    }
    await _waitForLogoutCleanup();
    final authOperation = ++_authOperationGeneration;
    void ensureCurrent() {
      _ensureAuthOperationCurrent(authOperation);
      if (externalOperationIsCurrent?.call() == false) {
        throw const _AuthOperationSuperseded();
      }
    }

    try {
      ensureCurrent();
      await _beginIdentityTransition(authOperation);
      await _serializeAuthMutation(() async {
        ensureCurrent();
        if (scope.serviceRealmId != ServiceRealmConfig.current.realmId ||
            credentials.tenantAccessToken.trim().isEmpty ||
            credentials.tenantRefreshToken.trim().isEmpty ||
            !expiresAt.isAfter(DateTime.now()) ||
            !expiresAt.isAfter(issuedAt)) {
          throw const ServerError(
              code: 'AUTH_INVALID_EXTERNAL_SESSION', message: '宿主IM凭证或服务环境无效');
        }
        final identity =
            await _repo.getTenantIdentity(credentials.tenantAccessToken);
        ensureCurrent();
        await verifyExternalSession?.call();
        ensureCurrent();
        if (!identity.hasStableIdentity ||
            identity.userId.trim() != scope.userId ||
            identity.platformUserId.trim() != scope.platformUserId) {
          throw const ServerError(
              code: 'AUTH_EXTERNAL_IDENTITY_MISMATCH',
              message: '宿主IM身份与服务端凭证不匹配');
        }

        var membershipRole = 0;
        var spaceType = SpaceType.personal;
        if (scope.spaceId != 'personal') {
          if (identity.userType != 1) {
            membershipRole = await _resolveMembershipRoleFromTenantMembers(
              userId: identity.userId,
              accessToken: credentials.tenantAccessToken,
            );
            ensureCurrent();
            if (membershipRole < 0 || membershipRole > 4) membershipRole = 0;
          }
          if (_isEmployeeTenantIdentity(
              membershipRole: membershipRole, userType: identity.userType)) {
            spaceType = SpaceType.employee;
          } else {
            spaceType = SpaceType.customerRestricted;
            try {
              final friendMode = await _repo
                  .getTenantFriendMode(credentials.tenantAccessToken);
              ensureCurrent();
              if (friendMode == TenantFriendMode.social)
                spaceType = SpaceType.customerSocial;
            } on _AuthOperationSuperseded {
              rethrow;
            } catch (_) {
              // Unavailable optional feature metadata can only lower access.
            }
          }
        }
        ensureCurrent();
        await verifyExternalSession?.call();
        ensureCurrent();
        final predecessor = await _sessionStore.loadActive();
        ensureCurrent();
        final persistedRevision = predecessor?.session.identityRevision ?? 0;
        final nextRevision = (_identityRevision > persistedRevision
                ? _identityRevision
                : persistedRevision) +
            1;
        final safeCredentials = SessionCredentials(
          tenantAccessToken: credentials.tenantAccessToken,
          tenantRefreshToken: credentials.tenantRefreshToken,
          platformAccessToken: credentials.platformAccessToken,
          platformRefreshToken: credentials.platformRefreshToken,
          deviceSessionToken: credentials.deviceSessionToken,
        );
        final active = await _sessionStore.provisionAndActivate(
          scope: scope,
          credentials: safeCredentials,
          accessTokenIssuedAt: issuedAt.toUtc(),
          accessTokenExpiresAt: expiresAt.toUtc(),
          expectedActivationId: predecessor?.activationId,
          identityRevision: nextRevision,
          canCommit: () =>
              _isAuthOperationCurrent(authOperation) &&
              externalOperationIsCurrent?.call() != false,
        );
        ensureCurrent();
        await verifyExternalSession?.call();
        ensureCurrent();
        _identityRevision = nextRevision;
        _committedSession = active.session;
        _committedCredentials = active.credentials;
        _pendingPlatformRefreshToken = null;
        _pendingDeviceSessionToken = null;
        _publishAuthState(AuthState(
          status: AuthStatus.authenticated,
          currentSpace: SpaceContext(
              spaceId: scope.spaceId,
              accessToken: safeCredentials.tenantAccessToken,
              refreshToken: safeCredentials.tenantRefreshToken,
              userId: identity.userId,
              type: spaceType,
              membershipRole: membershipRole),
          platformUserId: identity.platformUserId,
          platformToken: safeCredentials.platformAccessToken,
          accountSession: active.session,
        ));
        _startTokenRefresh();
      });
    } catch (_) {
      if (_isAuthOperationCurrent(authOperation)) {
        TokenRefreshService.instance.stop();
        _committedSession = null;
        _committedCredentials = null;
        _pendingPlatformRefreshToken = null;
        _pendingDeviceSessionToken = null;
        _publishAuthState(const AuthState(status: AuthStatus.unauthenticated));
      }
      rethrow;
    }
  }

  Future<ActiveAccountSession> _normalizeLegacyPersonalSession(
    ActiveAccountSession active,
  ) async {
    final oldSession = active.session;
    if (!isLegacyPersonalTenantId(oldSession.scope.spaceId)) return active;

    final normalizedScope = AccountScope.tryCreate(
      serviceRealmId: oldSession.scope.serviceRealmId,
      platformUserId: oldSession.scope.platformUserId,
      spaceId: 'personal',
      userId: oldSession.scope.userId,
    );
    if (normalizedScope == null) return active;

    final migrated = await _sessionStore.provisionAndActivate(
      scope: normalizedScope,
      credentials: active.credentials,
      accessTokenIssuedAt: active.accessTokenIssuedAt ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      accessTokenExpiresAt: active.accessTokenExpiresAt ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      expectedActivationId: oldSession.sessionId,
      identityRevision: oldSession.identityRevision + 1,
      canCommit: () => true,
    );
    final oldSpaceSessionId = active.spaceSessionId;
    if (oldSpaceSessionId != null &&
        oldSpaceSessionId != migrated.spaceSessionId) {
      unawaited(_sessionStore
          .removeSpaceSession(spaceSessionId: oldSpaceSessionId)
          .catchError((_) {}));
    }
    return migrated;
  }

  /// 启动时异步从 /profile/me 补全 userId，并判断 userType（员工 vs 客户）
  Future<_IdentityRefreshResult> _restoreUserId(
    String spaceId,
    String accessToken, {
    int? authoritativeMembershipRole,
    int? identityRevision,
  }) async {
    final requestRevision = identityRevision ?? ++_identityRevision;
    try {
      final identity = await _repo.getTenantIdentity(accessToken);
      final userId = identity.userId;
      final platformUserId = identity.platformUserId;
      final profileUserType = identity.userType;
      if (identity.hasStableIdentity) {
        final currentSpace = ref.read(currentSpaceProvider);
        final currentSpaceId = currentSpace?.spaceId;
        if (currentSpaceId != spaceId ||
            currentSpace?.accessToken != accessToken) {
          return _IdentityRefreshResult.superseded;
        }

        SpaceType spaceType;
        int membershipRole = 0;

        if (spaceId == 'personal') {
          spaceType = SpaceType.personal;
        } else if (authoritativeMembershipRole == null) {
          // profile/me 只能确认账号身份，不能证明当前企业角色。冷启动时
          // 必须继续保持最低权限，等待本次 platform session 的 my/tenants
          // 或成员接口返回权威 membershipRole。
          spaceType = SpaceType.customerRestricted;
        } else {
          // membershipRole=0 同时可能是普通员工或企业客户，必须结合当前
          // 租户 profile 的 userType 判断；角色 1~4 则可直接确认是员工。
          final isEmployee = _isEmployeeTenantIdentity(
            membershipRole: authoritativeMembershipRole,
            userType: profileUserType,
          );
          if (!isEmployee) {
            // 客户：判断 social/restricted
            try {
              final friendMode = await _repo.getTenantFriendMode(accessToken);
              spaceType = friendMode == TenantFriendMode.social
                  ? SpaceType.customerSocial
                  : SpaceType.customerRestricted;
            } catch (_) {
              spaceType = SpaceType.customerRestricted;
            }
          } else {
            // 员工：从 availableTenants 获取 membershipRole
            spaceType = SpaceType.employee;
            final tenants = state.valueOrNull?.availableTenants ?? [];
            membershipRole = tenants
                    .where((t) => t.tenantId == spaceId)
                    .map((t) => t.membershipRole)
                    .firstOrNull ??
                0;
            if (membershipRole == 0) {
              membershipRole = await _resolveMembershipRoleFromTenantMembers(
                userId: userId,
                accessToken: accessToken,
              );
            }
          }
        }

        final resolvedMembershipRole = spaceId == 'personal' ||
                spaceType == SpaceType.customerSocial ||
                spaceType == SpaceType.customerRestricted
            ? 0
            : authoritativeMembershipRole ?? membershipRole;
        final updatedSpace = SpaceContext(
          spaceId: spaceId,
          accessToken: accessToken,
          refreshToken:
              _committedCredentials?.tenantRefreshToken ?? accessToken,
          userId: userId,
          type: spaceType,
          membershipRole: resolvedMembershipRole,
        );
        final latestSpace = ref.read(currentSpaceProvider);
        if (_identityRevision != requestRevision ||
            latestSpace?.spaceId != spaceId ||
            latestSpace?.accessToken != accessToken) {
          return _IdentityRefreshResult.superseded;
        }
        final current = state.valueOrNull;
        if (current != null) {
          _publishAuthState(current.copyWith(
            currentSpace: updatedSpace,
            platformUserId: platformUserId,
          ));
        }
        return _IdentityRefreshResult.applied;
      }
      return _IdentityRefreshResult.failed;
    } on AuthError {
      await _refreshCurrentTenantToken();
      final refreshedToken = _committedCredentials?.tenantAccessToken;
      if (refreshedToken == null ||
          refreshedToken.isEmpty ||
          refreshedToken == accessToken) {
        return _IdentityRefreshResult.failed;
      }
      return _restoreUserId(
        spaceId,
        refreshedToken,
        authoritativeMembershipRole: authoritativeMembershipRole,
        identityRevision: requestRevision,
      );
    } on ServerError catch (error) {
      if (error.statusCode != 401 && error.statusCode != 403) {
        return _IdentityRefreshResult.failed;
      }
      await _refreshCurrentTenantToken();
      final refreshedToken = _committedCredentials?.tenantAccessToken;
      if (refreshedToken == null ||
          refreshedToken.isEmpty ||
          refreshedToken == accessToken) {
        return _IdentityRefreshResult.failed;
      }
      return _restoreUserId(
        spaceId,
        refreshedToken,
        authoritativeMembershipRole: authoritativeMembershipRole,
        identityRevision: requestRevision,
      );
    } catch (_) {
      return _IdentityRefreshResult.failed;
    }
  }

  void _applyFailClosedMembershipRole({
    required String spaceId,
    required String originRefreshToken,
    required int authoritativeMembershipRole,
    required int identityRevision,
  }) {
    final currentSpace = ref.read(currentSpaceProvider);
    if (currentSpace == null ||
        currentSpace.spaceId != spaceId ||
        currentSpace.refreshToken != originRefreshToken ||
        _identityRevision != identityRevision) {
      return;
    }

    final restrictedSpace = authoritativeMembershipRole == 0
        ? currentSpace.copyWith(
            type: SpaceType.customerRestricted,
            membershipRole: 0,
          )
        : currentSpace.copyWith(
            type: SpaceType.employee,
            membershipRole: authoritativeMembershipRole,
          );
    final latest = state.valueOrNull;
    if (latest != null) {
      _publishAuthState(latest.copyWith(currentSpace: restrictedSpace));
    }
  }

  /// 启动时异步恢复租户列表和各空间 token
  Future<void> _restoreTenants(
    String platformToken,
    String activeSpaceId,
    AccountOperationContext operation,
  ) async {
    final directoryRefreshGeneration = ++_tenantDirectoryRefreshGeneration;
    try {
      final tenants = await _repo.getMyTenants(platformToken);
      if (directoryRefreshGeneration != _tenantDirectoryRefreshGeneration ||
          !_acceptsAccountOperation(operation)) {
        return;
      }
      final session = _committedSession;
      if (session == null || session.sessionId != operation.sessionId) return;
      final revoked = activeSpaceId != 'personal' &&
          !tenants.any((tenant) => tenant.tenantId == activeSpaceId);
      final applied = await _serializeAuthMutation(() async {
        if (directoryRefreshGeneration != _tenantDirectoryRefreshGeneration ||
            !_acceptsAccountOperation(operation)) {
          return false;
        }
        final current = state.valueOrNull;
        if (current == null) return false;
        if (revoked) {
          _publishAuthState(current.copyWith(
            status: AuthStatus.unauthenticated,
            availableTenants: tenants,
            clearCurrentSpace: true,
            clearAccountSession: true,
          ));
        } else {
          state = AsyncData(current.copyWith(availableTenants: tenants));
        }
        try {
          await _tenantDirectoryStore.replace(
            serviceRealmId: session.scope.serviceRealmId,
            platformUserId: session.scope.platformUserId,
            tenants: tenants,
          );
        } catch (_) {
          // The server snapshot remains authoritative in memory. A local
          // persistence failure must never keep a revoked Runtime mounted.
        }
        if (directoryRefreshGeneration != _tenantDirectoryRefreshGeneration ||
            _committedSession?.sessionId != session.sessionId) {
          return false;
        }
        return revoked || _acceptsAccountOperation(operation);
      });
      if (!applied) return;

      if (revoked) {
        await selectPersonalSpace();
        if (state.hasError) {
          _publishAuthState(AuthState(
            status: AuthStatus.unauthenticated,
            availableTenants: tenants,
            platformToken: platformToken,
            platformUserId: session.scope.platformUserId,
            error: AuthPresentationFailure.personalSpaceRestore,
          ));
        }
        return;
      }

      if (directoryRefreshGeneration != _tenantDirectoryRefreshGeneration ||
          !_acceptsAccountOperation(operation)) {
        return;
      }

      // 冷启动时 currentSpace 会先以 membershipRole=0 占位恢复。
      // 租户列表返回后必须立刻把当前空间角色补齐，否则所有者/管理员
      // 会被误判成普通成员，通讯录里看不到全部客户。
      final activeTenant = tenants
          .where((tenant) => tenant.tenantId == activeSpaceId)
          .firstOrNull;
      final currentSpace = ref.read(currentSpaceProvider);
      if (_acceptsAccountOperation(operation) &&
          activeTenant != null &&
          currentSpace != null &&
          currentSpace.spaceId == activeSpaceId &&
          (currentSpace.membershipRole != activeTenant.membershipRole ||
              _spaceTypeConflictsWithMembershipRole(
                currentSpace,
                activeTenant.membershipRole,
              ))) {
        final identityRevision = ++_identityRevision;
        final identityResult = await _restoreUserId(
          activeSpaceId,
          currentSpace.accessToken,
          authoritativeMembershipRole: activeTenant.membershipRole,
          identityRevision: identityRevision,
        );
        if (identityResult == _IdentityRefreshResult.failed) {
          _applyFailClosedMembershipRole(
            spaceId: activeSpaceId,
            originRefreshToken: currentSpace.refreshToken,
            authoritativeMembershipRole: activeTenant.membershipRole,
            identityRevision: identityRevision,
          );
        }
      }
    } catch (_) {}
  }

  bool _acceptsAccountOperation(AccountOperationContext operation) {
    final session = _committedSession;
    final currentAuth = state.valueOrNull;
    if (session == null ||
        currentAuth?.status != AuthStatus.authenticated ||
        currentAuth?.accountSession?.sessionId != session.sessionId) {
      return false;
    }
    return AccountOperationGuard(AccountOperationContext(
      accountScopeKey: session.scope.scopeKey,
      identityRevision: _identityRevision,
      sessionId: session.sessionId,
    )).accepts(operation);
  }

  // ---------------------------------------------------------------------------
  // 验证码登录
  // ---------------------------------------------------------------------------

  Future<void> loginByCode(
    String identifier,
    String code,
    String loginType, {
    String? captchaToken,
    String? captchaAnswer,
  }) async {
    await _waitForLogoutCleanup();
    final authOperation = ++_authOperationGeneration;
    final request = LoginRequest(
      identifier: identifier,
      verificationCode: code,
      loginType: loginType,
      isCodeLogin: true,
      captchaToken: captchaToken,
      captchaAnswer: captchaAnswer,
    );
    try {
      await _beginIdentityTransition(authOperation);
      final result = await _platformLoginByCode(request, authOperation);
      await _handlePlatformLoginResult(result, authOperation);
    } catch (e, st) {
      if (e is _AuthOperationSuperseded) return;
      if (!_isAuthOperationCurrent(authOperation)) return;
      if (_isCaptchaError(e)) {
        _publishAuthState(
          const AuthState(status: AuthStatus.unauthenticated),
        );
        rethrow;
      }
      state = AsyncError(e, st);
    }
  }

  // ---------------------------------------------------------------------------
  // 注册
  // ---------------------------------------------------------------------------

  /// 模式A：平台注册（多租户通用 APP）
  /// 注册成功后保留 platformToken，等待用户显式选择个人空间或企业空间。
  /// 支持两种响应变体：
  ///   - platform-result：返回 platformToken，进入空间选择
  ///   - tenant-result：企业绑定模式+自动审批，直接返回 accessToken
  Future<void> registerPlatform({
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
    String? tenantCode,
    String? invitationCode,
    TenantSummary? registrationTenant,
    bool useDefaultRegistrationSpace = false,
  }) async {
    if (useDefaultRegistrationSpace &&
        (tenantId != null ||
            tenantCode != null ||
            invitationCode != null ||
            registrationTenant != null)) {
      throw const ServerError(
          code: 'AUTH_CONTEXT_REQUIRED', message: '个人注册不支持企业参数');
    }
    await _waitForLogoutCleanup();
    final authOperation = ++_authOperationGeneration;
    await ref.read(httpClientProvider).invalidatePlatformSession();
    _ensureAuthOperationCurrent(authOperation);
    try {
      await _beginIdentityTransition(authOperation);
      final registration = await _repo.registerPlatform(
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
      _ensureAuthOperationCurrent(authOperation);

      if (useDefaultRegistrationSpace) {
        if (registration.pendingApproval) {
          throw const ServerError(
              code: 'REGISTER_PENDING_APPROVAL', message: '账号已创建，等待审批后请登录');
        }
        try {
          _pendingPlatformRefreshToken = registration.platformRefreshToken;
          _pendingDeviceSessionToken = registration.deviceSessionToken;
          final platformToken = registration.platformToken;
          if (platformToken != null) {
            ref.read(httpClientProvider).activatePlatformSession();
          }
          final result = registration.tenantAuth ??
              await _repo.selectPersonalSpace(platformToken!,
                  preserveReturnedSpace: true);
          _ensureAuthOperationCurrent(authOperation);
          if (result.spaceId.isEmpty ||
              (result.spaceType != null &&
                  result.spaceType != 1 &&
                  result.spaceType != 2) ||
              (result.spaceType == 2 && result.spaceId == 'personal')) {
            throw const ServerError(
                code: 'AUTH_CONTEXT_REQUIRED', message: '注册返回的空间无法确认');
          }
          final identity = await _repo.getTenantIdentity(result.accessToken);
          _ensureAuthOperationCurrent(authOperation);
          final platformUserId =
              result.platformUserId ?? registration.platformUserId;
          if (!identity.hasStableIdentity ||
              (identity.verifiedSpaceId != null &&
                  identity.verifiedSpaceId != result.spaceId) ||
              identity.userId != result.userId ||
              (platformUserId != null &&
                  platformUserId != identity.platformUserId)) {
            throw const ServerError(
                code: 'AUTH_EXTERNAL_IDENTITY_MISMATCH', message: '注册身份验证失败');
          }
          if (result.spaceId != 'personal') {
            await _applySingleTenantSession(
                result: result,
                previousState: AuthState(
                    platformToken: platformToken,
                    platformUserId: identity.platformUserId),
                authOperation: authOperation);
            return;
          }
          final space = SpaceContext(
              spaceId: 'personal',
              accessToken: result.accessToken,
              refreshToken: result.refreshToken,
              userId: identity.userId,
              type: SpaceType.personal);
          final session = await _commitAccountSession(
              result: result,
              space: space,
              platformToken: platformToken,
              platformUserId: identity.platformUserId,
              authOperation: authOperation);
          _ensureAuthOperationCurrent(authOperation);
          _publishAuthState(AuthState(
              status: AuthStatus.authenticated,
              currentSpace: space,
              platformToken: platformToken,
              platformUserId: identity.platformUserId,
              accountSession: session));
          _startTokenRefresh();
          return;
        } on _AuthOperationSuperseded {
          rethrow;
        } catch (_) {
          throw const ServerError(
              code: 'REGISTER_LOGIN_FAILED', message: '账号已创建，暂时无法进入聊天，请稍后登录');
        }
      }

      final tenantResult = registration.tenantAuth;
      if (tenantResult != null) {
        await _guardAuthOperation(
          authOperation,
          _storage.clearPlatformCredentials,
        );
        await _applySingleTenantSession(
          result: tenantResult,
          previousState: const AuthState(),
          tenantMetadata: registrationTenant,
          fallbackTenantCode: tenantCode,
          authOperation: authOperation,
        );
        return;
      }

      final platformToken = registration.platformToken!;
      final platformUserId = registration.platformUserId;
      _pendingPlatformRefreshToken = registration.platformRefreshToken;
      _pendingDeviceSessionToken = registration.deviceSessionToken;
      _ensureAuthOperationCurrent(authOperation);
      ref.read(httpClientProvider).activatePlatformSession();

      if (await _acceptRegistrationInvitation(
        invitationCode: invitationCode,
        platformToken: platformToken,
        platformUserId: platformUserId,
        authOperation: authOperation,
      )) {
        return;
      }
      _ensureAuthOperationCurrent(authOperation);

      if (await _joinRegistrationTenantByCode(
        tenantCode: tenantCode,
        platformToken: platformToken,
        platformUserId: platformUserId,
        authOperation: authOperation,
      )) {
        return;
      }
      _ensureAuthOperationCurrent(authOperation);

      await _publishRegistrationPlatformState(
        platformToken: platformToken,
        platformUserId: platformUserId,
        authOperation: authOperation,
      );
    } catch (e, st) {
      if (e is _AuthOperationSuperseded) {
        return;
      }
      if (!_isAuthOperationCurrent(authOperation)) return;
      _ensureAuthOperationCurrent(authOperation);
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<RegistrationCredentialPreview> previewRegistrationInvitation(
    String credential,
  ) {
    return PlatformTenantDataSource(ref.read(dioProvider))
        .previewRegistrationInvitation(code: credential);
  }

  Future<bool> _acceptRegistrationInvitation({
    required String? invitationCode,
    required String platformToken,
    required String? platformUserId,
    required int authOperation,
    InvitationPreview? preview,
  }) async {
    final code = invitationCode?.trim();
    if (code == null || code.isEmpty) return false;

    try {
      final dataSource = PlatformTenantDataSource(ref.read(dioProvider));
      final resolvedPreview = preview ??
          await dataSource.previewInvitation(
            platformToken: platformToken,
            code: code,
          );
      _ensureAuthOperationCurrent(authOperation);
      final joinResult = await dataSource.acceptInvitation(
        platformToken: platformToken,
        code: code,
      );
      _ensureAuthOperationCurrent(authOperation);
      if (!joinResult.isJoined || joinResult.tenantAuth == null) {
        await _publishRegistrationPlatformState(
          platformToken: platformToken,
          platformUserId: platformUserId,
          authOperation: authOperation,
        );
        return true;
      }

      final authoritativeTenants = await _registrationTenantsAfterJoin(
        platformToken: platformToken,
        fallbackTenant: resolvedPreview.toTenantSummary(),
      );
      await _applyTenantAuth(
        joinResult.tenantAuth!,
        AuthState(
          status: AuthStatus.unauthenticated,
          platformToken: platformToken,
          platformUserId: platformUserId,
          availableTenants: authoritativeTenants,
        ),
        authOperation: authOperation,
      );
      await _cacheTenantMetadata(
        authoritativeTenants,
        platformUserId: platformUserId,
        authOperation: authOperation,
      );
      return true;
    } on _AuthOperationSuperseded {
      rethrow;
    } on AppError {
      await _publishRegistrationPlatformState(
        platformToken: platformToken,
        platformUserId: platformUserId,
        authOperation: authOperation,
        error: AuthPresentationFailure.joinEnterprise,
      );
      return true;
    } catch (_) {
      await _publishRegistrationPlatformState(
        platformToken: platformToken,
        platformUserId: platformUserId,
        authOperation: authOperation,
        error: AuthPresentationFailure.joinEnterprise,
      );
      return true;
    }
  }

  Future<bool> _joinRegistrationTenantByCode({
    required String? tenantCode,
    required String platformToken,
    required String? platformUserId,
    required int authOperation,
  }) async {
    final code = tenantCode?.trim();
    if (code == null || code.isEmpty) return false;

    try {
      final dataSource = PlatformTenantDataSource(ref.read(dioProvider));
      final lookup = await dataSource.previewTenantByCode(
        platformToken: platformToken,
        code: code,
      );
      _ensureAuthOperationCurrent(authOperation);
      final joinResult = await dataSource.joinByCode(
        platformToken: platformToken,
        tenantCode: lookup.joinIdentifier,
      );
      _ensureAuthOperationCurrent(authOperation);
      if (joinResult.isJoined && joinResult.tenantAuth != null) {
        final authoritativeTenants = await _registrationTenantsAfterJoin(
          platformToken: platformToken,
          fallbackTenant:
              lookup.hasResolvedPreview ? lookup.toTenantSummary() : null,
        );
        await _applyTenantAuth(
          joinResult.tenantAuth!,
          AuthState(
            status: AuthStatus.unauthenticated,
            platformToken: platformToken,
            platformUserId: platformUserId,
            availableTenants: authoritativeTenants,
          ),
          authOperation: authOperation,
        );
        await _cacheTenantMetadata(
          authoritativeTenants,
          platformUserId: platformUserId,
          authOperation: authOperation,
        );
      } else {
        await _publishRegistrationPlatformState(
          platformToken: platformToken,
          platformUserId: platformUserId,
          authOperation: authOperation,
        );
      }
    } on _AuthOperationSuperseded {
      rethrow;
    } on AppError catch (_) {
      await _publishRegistrationPlatformState(
        platformToken: platformToken,
        platformUserId: platformUserId,
        authOperation: authOperation,
        error: AuthPresentationFailure.joinEnterprise,
      );
    } catch (_) {
      await _publishRegistrationPlatformState(
        platformToken: platformToken,
        platformUserId: platformUserId,
        authOperation: authOperation,
        error: AuthPresentationFailure.joinEnterprise,
      );
    }
    return true;
  }

  Future<void> _publishRegistrationPlatformState({
    required String platformToken,
    required String? platformUserId,
    required int authOperation,
    AuthPresentationFailure? error,
  }) async {
    try {
      final tenants = await _resolveRegistrationTenants(
        platformToken,
        authOperation,
      );
      _ensureAuthOperationCurrent(authOperation);
      _publishAuthState(AuthState(
        status: AuthStatus.unauthenticated,
        platformToken: platformToken,
        platformUserId: platformUserId,
        availableTenants: tenants,
        error: error,
      ));
      await _cacheTenantMetadata(
        tenants,
        platformUserId: platformUserId,
        authOperation: authOperation,
      );
    } on _AuthOperationSuperseded {
      rethrow;
    } catch (_) {
      _ensureAuthOperationCurrent(authOperation);
      _publishAuthState(AuthState(
        status: AuthStatus.unauthenticated,
        platformToken: platformToken,
        platformUserId: platformUserId,
        error: AuthPresentationFailure.tenantDirectory,
      ));
    }
  }

  Future<List<TenantSummary>> _registrationTenantsAfterJoin({
    required String platformToken,
    TenantSummary? fallbackTenant,
  }) async {
    try {
      return await _repo.getMyTenants(platformToken);
    } catch (_) {
      if (fallbackTenant == null) return const [];
      return [
        TenantSummary(
          tenantId: fallbackTenant.tenantId,
          tenantName: fallbackTenant.tenantName,
          tenantCode: fallbackTenant.tenantCode,
          logoUrl: fallbackTenant.logoUrl,
          membershipRole: 0,
        ),
      ];
    }
  }

  Future<List<TenantSummary>> _resolveRegistrationTenants(
    String platformToken,
    int authOperation,
  ) async {
    final tenants = await _repo.getMyTenants(platformToken);
    _ensureAuthOperationCurrent(authOperation);
    return tenants;
  }

  Future<void> retryRegistrationTenantDirectory() async {
    final current = state.valueOrNull;
    final platformToken = current?.platformToken;
    if (current == null ||
        current.status != AuthStatus.unauthenticated ||
        platformToken == null) {
      return;
    }
    final authOperation = _authOperationGeneration;
    state = const AsyncLoading<AuthState>().copyWithPrevious(
      AsyncData(current.copyWith(clearError: true)),
    );
    await _publishRegistrationPlatformState(
      platformToken: platformToken,
      platformUserId: current.platformUserId,
      authOperation: authOperation,
    );
  }

  /// 模式B：企业专属注册
  /// 支持手机/邮箱/loginName，注册后自动登录企业空间
  /// [tenantIdOrCode] 可以是 tenantId(GUID) 或 tenantCode
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
    await _waitForLogoutCleanup();
    final authOperation = ++_authOperationGeneration;
    try {
      await _beginIdentityTransition(authOperation);
      await _repo.registerEnterprise(
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
      _ensureAuthOperationCurrent(authOperation);

      // Step2: 注册成功后自动登录
      // 优先用邮箱/手机号登录（平台账号），否则用 loginName
      final String loginIdentifier;
      final String resolvedLoginType;
      if (email != null && email.isNotEmpty) {
        loginIdentifier = email;
        resolvedLoginType = 'email';
      } else if (mobile != null && mobile.isNotEmpty) {
        loginIdentifier = mobile;
        resolvedLoginType = 'mobile';
      } else {
        loginIdentifier = loginName ?? '';
        resolvedLoginType = 'login_name';
      }

      // X-Tenant-Id 接受 GUID 或 tenantCode，统一传给 tenantCode 字段
      final request = LoginRequest(
        identifier: loginIdentifier,
        password: password,
        loginType: resolvedLoginType,
        isCodeLogin: false,
        tenantCode: tenantIdOrCode,
      );
      final platformResult = await _platformLogin(request, authOperation);
      var tenants = platformResult.tenants;
      if (tenants.isEmpty) {
        try {
          tenants = await _repo.getMyTenants(platformResult.platformToken);
          _ensureAuthOperationCurrent(authOperation);
        } on _AuthOperationSuperseded {
          rethrow;
        } catch (_) {}
      }
      final matchedTenant = tenants.firstWhere(
        (tenant) =>
            tenant.tenantId == tenantIdOrCode ||
            tenant.tenantCode == tenantIdOrCode,
        orElse: () => throw const ServerError(
          code: 'TENANT_NOT_MEMBER',
          message: '当前账号不属于该租户',
        ),
      );
      final tenantResult = await _repo.selectTenant(
        matchedTenant.tenantId,
        platformResult.platformToken,
      );
      _ensureAuthOperationCurrent(authOperation);
      await _applyTenantAuth(
        tenantResult,
        AuthState(
          availableTenants: tenants,
          platformToken: platformResult.platformToken,
          platformUserId: platformResult.platformUserId,
        ),
        authOperation: authOperation,
      );
    } catch (e, st) {
      if (e is _AuthOperationSuperseded) {
        return;
      }
      _ensureAuthOperationCurrent(authOperation);
      state = AsyncError(e, st);
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 密码登录
  // ---------------------------------------------------------------------------

  Future<void> loginByPassword(
    String identifier,
    String password,
    String loginType, {
    String? captchaToken,
    String? captchaAnswer,
    String? tenantCode,
    bool usePersonalSpace = false,
  }) async {
    if (usePersonalSpace &&
        (!const ['lpp_id', 'mobile', 'email'].contains(loginType) ||
            tenantCode != null)) {
      throw const ServerError(
          code: 'AUTH_CONTEXT_REQUIRED', message: '个人空间登录配置冲突');
    }
    await _waitForLogoutCleanup();
    final authOperation = ++_authOperationGeneration;
    final request = LoginRequest(
      identifier: identifier,
      password: password,
      loginType: loginType,
      isCodeLogin: false,
      captchaToken: captchaToken,
      captchaAnswer: captchaAnswer,
      tenantCode: tenantCode,
    );
    try {
      await _beginIdentityTransition(authOperation);
      // lpp_id 登录：走平台登录流程（platform login → select-tenant）
      if (loginType == 'lpp_id' || usePersonalSpace) {
        final result = await _platformLogin(request, authOperation);
        if (usePersonalSpace) {
          await _handlePlatformLoginResult(result, authOperation,
              forcePersonal: true);
          // 平台登录成功后，根据 tenantCode 找到对应租户并进入
        } else if (tenantCode != null && tenantCode.isNotEmpty) {
          final verifiedTenants =
              await _repo.getMyTenants(result.platformToken);
          _ensureAuthOperationCurrent(authOperation);
          // 从 tenants 列表里找匹配的租户（按 tenantCode 或 tenantId 匹配）
          final matchedTenant = verifiedTenants.firstWhere(
            (t) => t.tenantCode == tenantCode || t.tenantId == tenantCode,
            orElse: () => throw ServerError(
              code: 'TENANT_NOT_FOUND',
              message: '未找到企业「$tenantCode」，请确认企业码是否正确',
            ),
          );
          // 用 platformToken 换取 tenant token
          final tenantResult = await _repo.selectTenant(
              matchedTenant.tenantId, result.platformToken);
          _ensureAuthOperationCurrent(authOperation);
          await _applyTenantAuth(
              tenantResult,
              AuthState(
                platformToken: result.platformToken,
                platformUserId: result.platformUserId,
                availableTenants: verifiedTenants,
              ),
              authOperation: authOperation);
        } else {
          await _handlePlatformLoginResult(result, authOperation);
        }
        // login_name 登录走租户内接口
      } else if (loginType == 'login_name') {
        final result = await _repo.tenantLogin(request);
        _ensureAuthOperationCurrent(authOperation);
        if (!result.hasStableIdentity) {
          throw const ServerError(
            code: 'AUTH_STABLE_IDENTITY_MISSING',
            message: '账号身份信息不完整，请重新登录',
          );
        }
        await _applySingleTenantSession(
          result: result,
          previousState: const AuthState(),
          fallbackTenantCode: tenantCode,
          authOperation: authOperation,
        );
      } else {
        final result = await _platformLogin(request, authOperation);
        await _handlePlatformLoginResult(result, authOperation);
      }
    } catch (e, st) {
      if (e is _AuthOperationSuperseded) {
        return;
      }
      _ensureAuthOperationCurrent(authOperation);
      // AUTH_CAPTCHA_REQUIRED 需要重新抛出，让 UI 层处理弹窗
      if (_isCaptchaError(e)) {
        _publishAuthState(
          const AuthState(status: AuthStatus.unauthenticated),
        );
        rethrow;
      }
      state = AsyncError(e, st);
    }
  }

  Future<int> _resolveMembershipRoleFromTenantMembers({
    required String userId,
    required String accessToken,
  }) async {
    try {
      return await _repo.getTenantMembershipRole(
        userId: userId,
        accessToken: accessToken,
      );
    } catch (_) {}
    return 0;
  }

  // ---------------------------------------------------------------------------
  // 发送验证码
  // ---------------------------------------------------------------------------

  Future<AuthVerificationSettings> getVerificationSettings() {
    return _repo.getVerificationSettings();
  }

  Future<AuthCaptchaChallenge> generateCaptcha() {
    return _repo.generateCaptcha();
  }

  Future<void> sendVerificationCode(
    String identifier,
    String channel, {
    String purpose = 'login',
    String? captchaToken,
    String? captchaAnswer,
  }) async {
    try {
      await _repo.sendVerificationCode(
        identifier: identifier,
        channel: channel,
        purpose: purpose,
        captchaToken: captchaToken,
        captchaAnswer: captchaAnswer,
      );
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _repo.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    await logout(reason: AuthLogoutReason.passwordChanged);
  }

  Future<void> resetPasswordByCode({
    required String identifier,
    required String verificationCode,
    required String newPassword,
    required AuthVerificationChannel channel,
  }) async {
    await _repo.resetPlatformPassword(
      identifier: identifier,
      verificationCode: verificationCode,
      newPassword: newPassword,
      loginType: channel.loginType,
    );
    await logout(reason: AuthLogoutReason.passwordReset);
  }

  // ---------------------------------------------------------------------------
  // 选择租户
  // ---------------------------------------------------------------------------

  Future<void> selectTenant(String tenantId) => _selectTenant(tenantId);

  /// Only a personal-space official entry opts into local return and cold-start
  /// recovery. Explicit workspace switching keeps its existing semantics.
  Future<void> selectTenantForOfficialConversation(String tenantId) =>
      _selectTenant(tenantId,
          restorePersonalOnRestart: snapshot?.currentSpace?.isPersonal == true);

  Future<void> _selectTenant(String tenantId,
      {bool restorePersonalOnRestart = false}) {
    final normalizedTenantId = tenantId.trim();
    final target = restorePersonalOnRestart
        ? 'official:$normalizedTenantId'
        : 'tenant:$normalizedTenantId';
    final inFlight = _spaceSelectionFuture;
    if (inFlight != null && _spaceSelectionTarget == target) {
      return inFlight;
    }

    late final Future<void> transition;
    transition = _selectTenantOnce(normalizedTenantId,
            restorePersonalOnRestart: restorePersonalOnRestart)
        .whenComplete(() {
      if (identical(_spaceSelectionFuture, transition)) {
        _spaceSelectionFuture = null;
        _spaceSelectionTarget = null;
      }
    });
    _spaceSelectionFuture = transition;
    _spaceSelectionTarget = target;
    return transition;
  }

  Future<void> _selectTenantOnce(String normalizedTenantId,
      {bool restorePersonalOnRestart = false}) async {
    await _waitForLogoutCleanup();
    final authOperation = ++_authOperationGeneration;
    final currentState = state.valueOrNull;
    final platformToken = currentState?.platformToken;
    if (platformToken == null) {
      state = AsyncError(
        Exception('platformToken 不存在，请重新登录'),
        StackTrace.current,
      );
      return;
    }
    final isAuthorized = normalizedTenantId.isNotEmpty &&
        currentState!.availableTenants
            .any((tenant) => tenant.tenantId == normalizedTenantId);
    if (!isAuthorized) {
      state = AsyncError(
        const ServerError(
          code: 'TENANT_NOT_MEMBER',
          message: '当前账号不属于该企业',
        ),
        StackTrace.current,
      );
      return;
    }

    int? transitionRevision;
    try {
      transitionRevision = await _beginSpaceTransition(
        normalizedTenantId,
        currentState,
        authOperation,
      );
      if (await _activateReusableSpace(
        targetSpaceId: normalizedTenantId,
        previousState: currentState,
        authOperation: authOperation,
        restorePersonalOnRestart: restorePersonalOnRestart,
      )) {
        return;
      }
      final result =
          await _repo.selectTenant(normalizedTenantId, platformToken);
      _ensureAuthOperationCurrent(authOperation);
      await _applyTenantAuth(
        result,
        currentState,
        authOperation: authOperation,
        restorePersonalOnRestart: restorePersonalOnRestart,
      );
    } catch (e, st) {
      if (e is _AuthOperationSuperseded) return;
      if (!_isAuthOperationCurrent(authOperation)) return;
      if (e is _ReusableSpaceRefreshFailed) {
        _failSpaceTransition(currentState, transitionRevision, e, st);
        return;
      }
      _failSpaceTransition(currentState, transitionRevision, e, st);
    }
  }

  /// Route exit owns no authentication rules. A failed local restore keeps the
  /// official route and its recovery marker available for another back attempt.
  Future<bool> returnFromOfficialConversation() {
    final pending = _officialConversationReturnFuture;
    if (pending != null) return pending;
    final current = snapshot;
    if (_officialConversationActivationId == null ||
        current?.accountSession?.sessionId !=
            _officialConversationActivationId ||
        _spaceSelectionFuture != null) {
      return Future.value(true);
    }
    final expectedAuthOperation = _authOperationGeneration;
    late final Future<bool> operation;
    operation = Future<bool>.microtask(
      () => _returnFromOfficialConversation(current!, expectedAuthOperation),
    ).whenComplete(() {
      if (identical(_officialConversationReturnFuture, operation)) {
        _officialConversationReturnFuture = null;
        _returningOfficialActivationId = null;
      }
    });
    _officialConversationReturnFuture = operation;
    return operation;
  }

  Future<bool> _returnFromOfficialConversation(
      AuthState source, int expectedAuthOperation) async {
    if (!_isAuthOperationCurrent(expectedAuthOperation) ||
        snapshot?.accountSession?.sessionId !=
            source.accountSession?.sessionId ||
        _spaceSelectionFuture != null) {
      return true;
    }
    final authOperation = ++_authOperationGeneration;
    _returningOfficialActivationId = source.accountSession!.sessionId;
    int? revision;
    try {
      revision = await _beginSpaceTransition('personal', source, authOperation);
      final restored = await _sessionStore.restorePersonalSpace(
        expectedActivationId: source.accountSession!.sessionId,
        identityRevision: ++_identityRevision,
        canCommit: () => _isAuthOperationCurrent(authOperation),
      );
      _ensureAuthOperationCurrent(authOperation);
      _committedSession = restored.session;
      _committedCredentials = restored.credentials;
      _publishAuthState((snapshot ?? source).copyWith(
        currentSpace: SpaceContext(
          spaceId: 'personal',
          accessToken: restored.credentials.tenantAccessToken,
          refreshToken: restored.credentials.tenantRefreshToken,
          userId: restored.session.scope.userId,
          type: SpaceType.personal,
        ),
        platformToken: restored.credentials.platformAccessToken,
        accountSession: restored.session,
        clearError: true,
      ));
      _startTokenRefresh();
      if (revision != null) {
        await ref.read(spaceTransitionProvider.notifier).waitFor(revision);
      }
      _ensureAuthOperationCurrent(authOperation);
      return snapshot?.currentSpace?.isPersonal == true;
    } catch (error, stackTrace) {
      if (!_isAuthOperationCurrent(authOperation)) return true;
      _failSpaceTransition(source, revision, error, stackTrace);
      return false;
    }
  }

  /// A successful leave revokes the source identity before personal-space
  /// activation. It must never use normal switch rollback to restore that tenant.
  Future<void> leaveEnterprise() {
    final pending = _leaveEnterpriseFuture;
    if (pending != null) return pending;
    late final Future<void> operation;
    operation = _leaveEnterpriseOnce().whenComplete(() {
      if (identical(_leaveEnterpriseFuture, operation)) {
        _leaveEnterpriseFuture = null;
      }
    });
    _leaveEnterpriseFuture = operation;
    return operation;
  }

  Future<void> _leaveEnterpriseOnce() async {
    final source = state.valueOrNull;
    final session =
        source == null ? null : activeAccountSessionFromAuthState(source);
    final space = source?.currentSpace;
    if (state.isLoading ||
        session == null ||
        space == null ||
        space.isPersonal ||
        space.membershipRole == 4) {
      throw StateError('当前空间不能退出企业');
    }
    final requestGeneration = _authOperationGeneration;
    await _repo.leaveEnterprise(space.accessToken);
    if (requestGeneration != _authOperationGeneration ||
        state.valueOrNull?.accountSession?.sessionId != session.sessionId) {
      return;
    }

    final operation = ++_authOperationGeneration;
    ++_identityRevision;
    ++_tenantDirectoryRefreshGeneration;
    final restricted = source!.copyWith(
      status: AuthStatus.unauthenticated,
      availableTenants: state.valueOrNull!.availableTenants
          .where((tenant) => tenant.tenantId != space.spaceId)
          .toList(),
      clearCurrentSpace: true,
      clearAccountSession: true,
      clearError: true,
    );
    TokenRefreshService.instance.stop();
    ref.read(spaceTransitionProvider.notifier).cancel();
    _spaceTransitionRollbackState = null;
    _activeSpaceTransitionRevision = null;
    _publishAuthState(restricted);

    try {
      await _serializeAuthMutation(() async {
        _ensureAuthOperationCurrent(operation);
        final stored = await _sessionStore.loadReusableSpace(
          platformAccount: PlatformAccountScope.fromAccountScope(session.scope),
          spaceId: space.spaceId,
        );
        _ensureAuthOperationCurrent(operation);
        if (stored != null) {
          await _sessionStore.removeSpaceSession(
              spaceSessionId: stored.spaceSessionId);
          _ensureAuthOperationCurrent(operation);
          if (_committedSession?.sessionId == session.sessionId) {
            _committedSession = null;
          }
        }
        await _storage
            .clearAdminCredentialsForOwner(session.scope.storageKeyHash);
        _ensureAuthOperationCurrent(operation);
        await _tenantDirectoryStore.replace(
          serviceRealmId: session.scope.serviceRealmId,
          platformUserId: session.scope.platformUserId,
          tenants: restricted.availableTenants,
        );
      });
      if (!_isAuthOperationCurrent(operation)) return;
      if (restricted.platformToken == null) return;
      await selectPersonalSpace();
      // Selection can report an error in state instead of throwing. Preserve
      // the platform session and retry entry, never the exited enterprise.
      if (_authOperationGeneration != operation + 1) return;
      if (state.valueOrNull?.status == AuthStatus.authenticated &&
          state.valueOrNull?.currentSpace?.isPersonal == true) {
        return;
      }
    } catch (error) {
      if (error is _AuthOperationSuperseded ||
          !_isAuthOperationCurrent(operation)) {
        return;
      }
      AppDiagnostics.instance.warning('auth.enterprise_leave',
          'Enterprise exited; local transition requires retry');
    }
    _publishAuthState(restricted.copyWith(
      error: AuthPresentationFailure.personalSpaceRestore,
    ));
  }

  // ---------------------------------------------------------------------------
  // 选择个人空间
  // ---------------------------------------------------------------------------

  Future<void> selectPersonalSpace() {
    const target = 'personal';
    final inFlight = _spaceSelectionFuture;
    if (inFlight != null && _spaceSelectionTarget == target) {
      return inFlight;
    }

    late final Future<void> transition;
    transition = _selectPersonalSpaceOnce().whenComplete(() {
      if (identical(_spaceSelectionFuture, transition)) {
        _spaceSelectionFuture = null;
        _spaceSelectionTarget = null;
      }
    });
    _spaceSelectionFuture = transition;
    _spaceSelectionTarget = target;
    return transition;
  }

  Future<void> _selectPersonalSpaceOnce() async {
    await _waitForLogoutCleanup();
    final authOperation = ++_authOperationGeneration;
    final currentState = state.valueOrNull;
    final platformToken = currentState?.platformToken;
    if (platformToken == null) {
      state = AsyncError(
        Exception('platformToken 不存在，请重新登录'),
        StackTrace.current,
      );
      return;
    }

    int? transitionRevision;
    try {
      transitionRevision = await _beginSpaceTransition(
        'personal',
        currentState,
        authOperation,
      );
      if (await _activateReusableSpace(
        targetSpaceId: 'personal',
        previousState: currentState!,
        authOperation: authOperation,
      )) {
        return;
      }
      final result = await _repo.selectPersonalSpace(platformToken);
      _ensureAuthOperationCurrent(authOperation);
      final platformUserId =
          result.platformUserId ?? currentState.platformUserId;
      final space = SpaceContext(
        spaceId: 'personal',
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        userId: result.userId,
        type: SpaceType.personal,
      );
      final accountSession = await _commitAccountSession(
        result: result,
        space: space,
        platformToken: platformToken,
        platformUserId: platformUserId,
        authOperation: authOperation,
      );
      _ensureAuthOperationCurrent(authOperation);
      _ensureAuthOperationCurrent(authOperation);
      _publishAuthState(AuthState(
        status: AuthStatus.authenticated,
        currentSpace: space,
        availableTenants: currentState.availableTenants,
        platformToken: _committedCredentials?.platformAccessToken,
        platformUserId: platformUserId,
        accountSession: accountSession,
      ));
      _rememberLastActiveSpace(
        platformUserId: platformUserId,
        spaceId: 'personal',
      );
    } catch (e, st) {
      if (e is _AuthOperationSuperseded) return;
      if (!_isAuthOperationCurrent(authOperation)) return;
      if (currentState != null && authStateNeedsSpaceSelection(currentState)) {
        _publishAuthState(currentState.copyWith(
          error: AuthPresentationFailure.personalSpaceRestore,
        ));
        return;
      }
      if (e is _ReusableSpaceRefreshFailed) {
        _failSpaceTransition(currentState!, transitionRevision, e, st);
        return;
      }
      _failSpaceTransition(currentState!, transitionRevision, e, st);
    }
  }

  Future<bool> _activateReusableSpace({
    required String targetSpaceId,
    required AuthState previousState,
    required int authOperation,
    bool restorePersonalOnRestart = false,
  }) async {
    final activationStopwatch = Stopwatch()..start();
    final platformUserId = previousState.platformUserId?.trim() ?? '';
    if (platformUserId.isEmpty) return false;
    final platformAccount = PlatformAccountScope(
      serviceRealmId: ServiceRealmConfig.current.realmId,
      platformUserId: platformUserId,
    );
    var stored = await _sessionStore.loadReusableSpace(
      platformAccount: platformAccount,
      spaceId: targetSpaceId,
    );
    _ensureAuthOperationCurrent(authOperation);
    if (stored == null) return false;
    Future<void> discardInvalidStoredSpace(
      StoredSpaceSession invalidStored,
    ) async {
      final wasActive = _committedSession?.scope == invalidStored.scope;
      await _sessionStore.removeSpaceSession(
        spaceSessionId: invalidStored.spaceSessionId,
      );
      if (wasActive) {
        _committedSession = null;
        _committedCredentials = null;
      }
    }

    final now = DateTime.now().toUtc();
    if (!stored.isReusableAt(now)) {
      try {
        final refreshed = await _repo.refreshToken(stored.refreshToken);
        _ensureAuthOperationCurrent(authOperation);
        final refreshedPlatformUserId = refreshed.platformUserId?.trim();
        final identityChanged =
            refreshed.spaceId.trim() != stored.scope.spaceId ||
                refreshed.userId.trim() != stored.scope.userId ||
                (refreshedPlatformUserId != null &&
                    refreshedPlatformUserId.isNotEmpty &&
                    refreshedPlatformUserId != stored.scope.platformUserId);
        if (identityChanged) {
          await discardInvalidStoredSpace(stored);
          _ensureAuthOperationCurrent(authOperation);
          return false;
        }
        final issuedAt = DateTime.now().toUtc();
        await _sessionStore.updateSpaceCredentials(
          spaceSessionId: stored.spaceSessionId,
          accessToken: refreshed.accessToken,
          refreshToken: refreshed.refreshToken,
          accessTokenIssuedAt: issuedAt,
          accessTokenExpiresAt:
              issuedAt.add(Duration(seconds: refreshed.expiresIn)),
        );
        stored = StoredSpaceSession(
          spaceSessionId: stored.spaceSessionId,
          scope: stored.scope,
          accessToken: refreshed.accessToken,
          refreshToken: refreshed.refreshToken,
          accessTokenIssuedAt: issuedAt,
          accessTokenExpiresAt:
              issuedAt.add(Duration(seconds: refreshed.expiresIn)),
        );
      } on AuthError {
        await discardInvalidStoredSpace(stored!);
        _ensureAuthOperationCurrent(authOperation);
        return false;
      } on ServerError catch (error) {
        if (error.statusCode != 401 && error.statusCode != 403) {
          throw _ReusableSpaceRefreshFailed(error);
        }
        await discardInvalidStoredSpace(stored!);
        _ensureAuthOperationCurrent(authOperation);
        return false;
      } catch (error) {
        throw _ReusableSpaceRefreshFailed(error);
      }
    }

    final active = await _sessionStore.activateStoredSpace(
      target: stored,
      expectedActivationId: _committedSession?.sessionId,
      identityRevision: ++_identityRevision,
      canCommit: () => _isAuthOperationCurrent(authOperation),
      restorePersonalOnRestart: restorePersonalOnRestart,
    );
    _ensureAuthOperationCurrent(authOperation);
    _committedSession = active.session;
    _committedCredentials = active.credentials;

    final isPersonal = targetSpaceId == 'personal';
    final space = SpaceContext(
      spaceId: targetSpaceId,
      accessToken: stored.accessToken,
      refreshToken: stored.refreshToken,
      userId: stored.scope.userId,
      type: isPersonal ? SpaceType.personal : SpaceType.customerRestricted,
      membershipRole: 0,
    );
    invalidateContactScopedProviders(ref);
    _publishAuthState(previousState.copyWith(
      status: AuthStatus.authenticated,
      currentSpace: space,
      platformToken:
          active.credentials.platformAccessToken ?? previousState.platformToken,
      platformUserId: stored.scope.platformUserId,
      accountSession: active.session,
      clearError: true,
    ));
    if (restorePersonalOnRestart) {
      _officialConversationActivationId = active.activationId;
    } else {
      _rememberLastActiveSpace(
        platformUserId: stored.scope.platformUserId,
        spaceId: targetSpaceId,
      );
    }
    _startTokenRefresh();
    AppDiagnostics.instance.info(
      'auth.space_warm_activation',
      'Reusable space session activated',
      context: {
        'elapsedMs': activationStopwatch.elapsedMilliseconds,
        'scopeFingerprint': stored.scope.storageKeyHash.substring(0, 12),
        'activationFingerprint':
            AccountSession.hashSessionId(active.activationId).substring(0, 12),
      },
    );
    final platformToken = active.credentials.platformAccessToken;
    if (platformToken != null && platformToken.isNotEmpty) {
      unawaited(Future<void>.delayed(
        Duration.zero,
        () => _restoreTenants(
          platformToken,
          targetSpaceId,
          AccountOperationContext(
            accountScopeKey: active.session.scope.scopeKey,
            identityRevision: active.session.identityRevision,
            sessionId: active.session.sessionId,
          ),
        ),
      ));
    }
    return true;
  }

  // ---------------------------------------------------------------------------
  // 退出登录
  // ---------------------------------------------------------------------------

  Future<void> logout({
    bool clearDraftTranslationSelections = false,
    AuthLogoutReason reason = AuthLogoutReason.userRequested,
    String? serverCode,
  }) {
    final inFlight = _logoutTransitionFuture;
    if (inFlight != null) return inFlight;
    final session = _committedSession;
    AppDiagnostics.instance.info(
      'auth.logout_requested',
      'Account logout requested',
      scope: session == null
          ? DiagnosticScope.public
          : DiagnosticScope.account(session.scope),
      context: {
        'reason': reason.name,
        if (serverCode != null) 'serverCode': serverCode,
        if (session != null)
          'scopeFingerprint': session.scope.storageKeyHash.substring(0, 12),
        if (session != null)
          'activationFingerprint':
              AccountSession.hashSessionId(session.sessionId).substring(0, 12),
      },
    );
    ++_authOperationGeneration;

    late final Future<void> transition;
    transition = _performLogoutTransition(
      clearDraftTranslationSelections: clearDraftTranslationSelections,
    ).whenComplete(() {
      if (identical(_logoutTransitionFuture, transition)) {
        _logoutTransitionFuture = null;
      }
    });
    _logoutTransitionFuture = transition;
    return transition;
  }

  Future<void> _performLogoutTransition({
    required bool clearDraftTranslationSelections,
  }) async {
    final stopwatch = Stopwatch()..start();

    // An explicit user logout clears this preference before credentials are
    // removed, so a process interruption cannot leave orphaned choices.
    if (clearDraftTranslationSelections) {
      final currentState = state.valueOrNull;
      final session = currentState == null
          ? _committedSession
          : activeAccountSessionFromAuthState(currentState) ??
              _committedSession;
      if (session != null) {
        final spaces = await _sessionStore.loadPlatformSpaces(
          platformAccount: PlatformAccountScope.fromAccountScope(session.scope),
        );
        await HiveDraftTranslationSelectionRepository.clearForScopes([
          session.scope,
          ...spaces.map((space) => space.scope),
        ]);
      }
    }

    ref.read(spaceTransitionProvider.notifier).cancel();
    _spaceTransitionRollbackState = null;
    _activeSpaceTransitionRevision = null;

    final currentAuthState = state.valueOrNull;
    final currentSpace =
        ref.read(currentSpaceProvider) ?? currentAuthState?.currentSpace;
    final spaceId = currentSpace?.spaceId;

    // 先关闭本机推送并写入轻量退出标记，不等待网络解绑或凭据/数据库清理；
    // 若此时进程被杀，下次启动会先完成清理，不能恢复旧会话。
    // Persist the native deny state before exposing logout or clearing tokens.
    // Background/killed-process delivery cannot depend on a Flutter listener.
    await ref.read(accountPushRegistrationServiceProvider).stopDelivery();
    await LogoutGuard.arm(spaceId);

    // LogoutGuard 成功后再停止刷新并提交内存退出态。提交之后，任何后台清理
    // 失败都不能让受保护页面继续可见。
    final platformInvalidation =
        ref.read(httpClientProvider).invalidatePlatformSession();
    TokenRefreshService.instance.stop();
    _publishAuthState(
      const AuthState(status: AuthStatus.unauthenticated),
    );

    // 清除所有内存缓存，防止下次登录看到旧数据
    try {
      if (spaceId != null) {
        ref.invalidate(conversationsProvider(spaceId));
      }
      invalidateContactScopedProviders(ref);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          '[AuthLogout] memory cache invalidation failed: '
          '$error\n$stackTrace',
        );
      }
    }

    final cleanup = _completeLogoutCleanup(
      spaceId: spaceId,
      platformInvalidation: platformInvalidation,
    );
    _logoutCleanupFuture = cleanup;
    unawaited(() async {
      try {
        await cleanup;
      } catch (error, stackTrace) {
        if (kDebugMode) {
          debugPrint(
            '[AuthLogout] background cleanup failed: $error\n$stackTrace',
          );
        }
      } finally {
        if (identical(_logoutCleanupFuture, cleanup)) {
          _logoutCleanupFuture = null;
        }
      }
    }());

    if (kDebugMode) {
      debugPrint(
        '[AuthLogout] foreground logout completed in '
        '${stopwatch.elapsedMilliseconds}ms',
      );
    }

    unawaited(_repo.logout().catchError((_) {}));
  }

  Future<void> _completeLogoutCleanup({
    required String? spaceId,
    required Future<void> platformInvalidation,
  }) async {
    final stopwatch = Stopwatch()..start();
    await _serializeAuthMutation(
      () => _clearPersistedCredentials(
        spaceId: spaceId,
      ),
    );
    // 若退出时恰有平台续期写入，等待它停止后再清一次，保证旧会话不能复活。
    await platformInvalidation;
    await _serializeAuthMutation(_storage.clearPlatformCredentials);

    await LogoutGuard.disarm();

    if (kDebugMode) {
      debugPrint(
        '[AuthLogout] background cleanup completed in '
        '${stopwatch.elapsedMilliseconds}ms',
      );
    }
  }

  Future<void> _clearPersistedCredentials({
    required String? spaceId,
  }) async {
    // Logout owns an exclusive auth transition. Clear whichever v2 Session is
    // active at cleanup time so a login that committed just before logout
    // cannot survive, while no other account Store is scanned or deleted.
    final active = await _sessionStore.loadActive();
    if (active != null) {
      if (active.spaceSessionId != null) {
        await _sessionStore.clearPlatformAccountSessions(
          platformAccount:
              PlatformAccountScope.fromAccountScope(active.session.scope),
          expectedActivationId: active.activationId,
        );
      } else {
        await _storage.clearAdminCredentialsForOwner(
          active.session.scope.storageKeyHash,
        );
        await _sessionStore.clearActiveSession(
          expectedCurrentSessionId: active.session.sessionId,
        );
      }
      _committedSession = null;
      _committedCredentials = null;
      _pendingPlatformRefreshToken = null;
      _pendingDeviceSessionToken = null;
    }
    await Future.wait([
      _storage.delete(SecureStorageService.activeSpaceIdKey),
      _storage.clearPlatformCredentials(),
      LoginIdentifierCache.clear(_storage),
      if (spaceId != null && spaceId.isNotEmpty) _storage.clearTokens(spaceId),
      if (spaceId != null && spaceId.isNotEmpty)
        _storage.clearAdminTokens(spaceId),
    ]);
  }

  Future<void> _recoverInterruptedLogout() async {
    final spaceId = LogoutGuard.pendingSpaceId;
    try {
      await _serializeAuthMutation(
        () => _clearPersistedCredentials(
          spaceId: spaceId,
        ),
      );
      await LogoutGuard.disarm();
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          '[AuthLogout] interrupted cleanup recovery failed: '
          '$error\n$stackTrace',
        );
      }
    }
  }

  /// Runtime owners must drain credential cleanup before disposing this scope.
  /// This does not initiate logout or restore any previous account.
  Future<void> waitForLogoutCleanup() async {
    final transition = _logoutTransitionFuture;
    if (transition != null) {
      await transition;
    }
    await _waitForLogoutCleanup();
  }

  Future<void> _waitForLogoutCleanup() async {
    final cleanup = _logoutCleanupFuture;
    if (cleanup != null) {
      try {
        await cleanup;
      } catch (_) {
        await _recoverInterruptedLogout();
      }
    } else if (LogoutGuard.isPending) {
      await _recoverInterruptedLogout();
    }
    if (LogoutGuard.isPending) {
      throw StateError('退出清理尚未完成，请稍后重试');
    }
  }

  // ---------------------------------------------------------------------------
  // 内部辅助
  // ---------------------------------------------------------------------------

  Future<PlatformLoginResult> _platformLogin(
    LoginRequest request,
    int authOperation,
  ) async {
    await ref.read(httpClientProvider).invalidatePlatformSession();
    _ensureAuthOperationCurrent(authOperation);
    final prepared = await _preparePlatformLogin(request);
    _ensureAuthOperationCurrent(authOperation);
    final result = await _repo.platformLogin(prepared);
    _ensureAuthOperationCurrent(authOperation);
    await _persistPlatformSession(result, authOperation);
    return result;
  }

  Future<PlatformLoginResult> _platformLoginByCode(
    LoginRequest request,
    int authOperation,
  ) async {
    await ref.read(httpClientProvider).invalidatePlatformSession();
    _ensureAuthOperationCurrent(authOperation);
    final result = await _repo.platformLoginByCode(request);
    _ensureAuthOperationCurrent(authOperation);
    await _persistPlatformSession(result, authOperation);
    return result;
  }

  void _ensureAuthOperationCurrent(int authOperation) {
    if (authOperation != _authOperationGeneration) {
      throw const _AuthOperationSuperseded();
    }
  }

  bool _isAuthOperationCurrent(int authOperation) =>
      authOperation == _authOperationGeneration;

  void _ensureAuthOperationCurrentIfPresent(int? authOperation) {
    if (authOperation != null) {
      _ensureAuthOperationCurrent(authOperation);
    }
  }

  Future<T> _guardAuthOperation<T>(
    int? authOperation,
    Future<T> Function() action,
  ) async {
    return _serializeAuthMutation(() async {
      _ensureAuthOperationCurrentIfPresent(authOperation);
      final result = await action();
      _ensureAuthOperationCurrentIfPresent(authOperation);
      return result;
    });
  }

  Future<T> _serializeAuthMutation<T>(Future<T> Function() action) {
    final result = Completer<T>();
    final ready = _authMutationTail.then<void>(
      (_) {},
      onError: (_, __) {},
    );
    final run = ready.then<void>((_) async {
      try {
        result.complete(await action());
      } catch (error, stackTrace) {
        result.completeError(error, stackTrace);
      }
    });
    _authMutationTail = run;
    return result.future;
  }

  Future<LoginRequest> _preparePlatformLogin(LoginRequest request) async {
    final deviceId = await _storage.stableDeviceId();
    final platform = AppPlatformInfo.current.wireName;
    final platformLabel = platform.isEmpty
        ? 'Mobile'
        : '${platform[0].toUpperCase()}${platform.substring(1)}';
    return request.withTrustedDevice(
      deviceId: deviceId,
      devicePlatform: platform,
      deviceName: '微界 $platformLabel',
    );
  }

  Future<void> _persistPlatformSession(
    PlatformLoginResult result,
    int authOperation,
  ) async {
    try {
      _ensureAuthOperationCurrent(authOperation);
      _pendingPlatformRefreshToken = result.platformRefreshToken;
      _pendingDeviceSessionToken = result.deviceSessionToken;
      ref.read(httpClientProvider).activatePlatformSession();
    } on _AuthOperationSuperseded {
      rethrow;
    }
  }

  Future<void> _handlePlatformLoginResult(
    PlatformLoginResult result,
    int authOperation, {
    bool forcePersonal = false,
  }) async {
    _ensureAuthOperationCurrent(authOperation);
    final verifiedTenants = forcePersonal
        ? const <TenantSummary>[]
        : await _repo.getMyTenants(result.platformToken);
    _ensureAuthOperationCurrent(authOperation);

    final lastSpaceId = forcePersonal
        ? null
        : await _tenantDirectoryStore.readLastActiveSpace(
            serviceRealmId: ServiceRealmConfig.current.realmId,
            platformUserId: result.platformUserId,
          );
    _ensureAuthOperationCurrent(authOperation);

    // 判断上次是否是个人空间
    final lastWasPersonal = lastSpaceId == 'personal';

    // 如果上次是某个企业空间，且该企业仍在租户列表中 → 进该企业空间
    final lastTenantStillValid = lastSpaceId != null &&
        lastSpaceId != 'personal' &&
        verifiedTenants.any((t) => t.tenantId == lastSpaceId);

    // 服务端建议进入的空间（优先级：本地记忆 > 服务端建议）
    // spaceType=0：需要选择；spaceType=1：个人空间；spaceType=2：指定租户
    final serverSuggestsTenant = result.spaceType == 2 &&
        result.suggestedTenantId != null &&
        verifiedTenants
            .any((tenant) => tenant.tenantId == result.suggestedTenantId);

    // 服务端明确返回个人空间时必须保持个人空间；企业目录只描述可见性，
    // 不能覆盖本次认证响应的规范化空间身份。
    final shouldGoPersonal = forcePersonal ||
        result.spaceType == 1 ||
        lastWasPersonal ||
        verifiedTenants.isEmpty;

    // spaceType=0 且有多个租户且没有本地记忆 → 展示选择页
    final shouldShowSelection = !forcePersonal &&
        result.spaceType == 0 &&
        verifiedTenants.length > 1 &&
        !lastWasPersonal &&
        !lastTenantStillValid &&
        !serverSuggestsTenant;

    // spaceType=0 且有多个租户且没有本地记忆 → 展示选择页（不自动进入任何空间）
    if (shouldShowSelection) {
      _ensureAuthOperationCurrent(authOperation);
      _publishAuthState(AuthState(
        status: AuthStatus.unauthenticated, // 保持未认证，让 router 跳转到选择页
        availableTenants: verifiedTenants,
        platformToken: result.platformToken,
        platformUserId: result.platformUserId,
      ));
      return;
    }

    if (shouldGoPersonal) {
      try {
        // 进个人空间
        final personalResult =
            await _repo.selectPersonalSpace(result.platformToken);
        _ensureAuthOperationCurrent(authOperation);

        final space = SpaceContext(
          spaceId: 'personal',
          accessToken: personalResult.accessToken,
          refreshToken: personalResult.refreshToken,
          userId: personalResult.userId,
          type: SpaceType.personal,
        );
        final resolvedPlatformUserId =
            personalResult.platformUserId ?? result.platformUserId;
        final accountSession = await _commitAccountSession(
          result: personalResult,
          space: space,
          platformToken: result.platformToken,
          platformUserId: resolvedPlatformUserId,
          authOperation: authOperation,
        );
        _ensureAuthOperationCurrent(authOperation);
        _ensureAuthOperationCurrent(authOperation);
        _publishAuthState(AuthState(
          status: AuthStatus.authenticated,
          currentSpace: space,
          availableTenants: verifiedTenants,
          platformToken: result.platformToken,
          platformUserId: resolvedPlatformUserId,
          accountSession: accountSession,
          isPendingDeactivation: result.isPendingDeactivation,
        ));

        // Explicit personal login did not fetch an enterprise directory.
        // Keep any existing directory cache rather than writing a false empty
        // snapshot from the routing-only list above.
        if (!forcePersonal) {
          await _cacheTenantMetadata(
            verifiedTenants,
            platformUserId: resolvedPlatformUserId,
            authOperation: authOperation,
          );
        }
      } on _AuthOperationSuperseded {
        rethrow;
      }
      return;
    }

    // 确定目标企业空间：优先用上次的，其次用服务端建议的，最后用 tenants 第一个
    // 客户账户 tenants[] 可能为空，但 lastSpaceId 有值时直接用
    var targetTenantId = resolveAuthorizedTenantId(
      tenants: verifiedTenants,
      rememberedSpaceId: lastSpaceId,
      spaceType: result.spaceType,
      suggestedTenantId: result.suggestedTenantId,
    );
    if (lastTenantStillValid) {
      targetTenantId = lastSpaceId;
    } else if (result.spaceType == 2 &&
        result.suggestedTenantId != null &&
        verifiedTenants
            .any((tenant) => tenant.tenantId == result.suggestedTenantId)) {
      targetTenantId = result.suggestedTenantId!;
    } else if (verifiedTenants.isNotEmpty) {
      targetTenantId = verifiedTenants.first.tenantId;
    } else {
      throw const ServerError(
        code: 'TENANT_NOT_FOUND',
        message: '当前账号没有可进入的空间',
      );
    }

    final tenantResult =
        await _repo.selectTenant(targetTenantId, result.platformToken);
    _ensureAuthOperationCurrent(authOperation);
    await _applyTenantAuth(
      tenantResult,
      AuthState(
        availableTenants: verifiedTenants,
        platformToken: result.platformToken,
        platformUserId: result.platformUserId,
      ),
      authOperation: authOperation,
    );
    _ensureAuthOperationCurrent(authOperation);

    await _cacheTenantMetadata(
      verifiedTenants,
      platformUserId: result.platformUserId,
      authOperation: authOperation,
    );
  }

  /// Cache non-sensitive tenant presentation metadata only. Tenant
  /// credentials are issued on demand and committed into the target v2
  /// AccountSession; space-only credential prefetch would break account
  /// isolation for users sharing the same tenant.
  Future<void> _cacheTenantMetadata(
    List<TenantSummary> tenants, {
    required String? platformUserId,
    int? authOperation,
  }) async {
    try {
      await _guardAuthOperation(
        authOperation,
        () => _tenantDirectoryStore.replace(
          serviceRealmId: ServiceRealmConfig.current.realmId,
          platformUserId: platformUserId ?? '',
          tenants: tenants,
        ),
      );
    } on _AuthOperationSuperseded {
      return;
    }
    // AuthState publication rebuilds spacesProvider. Invalidating it here can
    // create a Riverpod dependency cycle while an auth transition is running.
  }

  /// Installs a tenant-only authenticated session and publishes the matching
  /// one-entry space directory as one application-layer operation.
  ///
  /// Tenant login and auto-approved registration return the same business
  /// outcome but their token responses do not consistently contain tenant
  /// presentation metadata. The already resolved tenant metadata is accepted
  /// only when its tenant id matches the authenticated result.
  Future<void> _applySingleTenantSession({
    required TenantAuthResult result,
    required AuthState previousState,
    required int authOperation,
    TenantSummary? tenantMetadata,
    String? fallbackTenantCode,
  }) async {
    final matchingMetadata =
        tenantMetadata?.tenantId == result.spaceId ? tenantMetadata : null;
    final normalizedFallbackCode = fallbackTenantCode?.trim();
    final tenantName = result.tenantName?.trim().isNotEmpty == true
        ? result.tenantName!.trim()
        : matchingMetadata?.tenantName.trim().isNotEmpty == true
            ? matchingMetadata!.tenantName.trim()
            : normalizedFallbackCode?.isNotEmpty == true
                ? normalizedFallbackCode!
                : result.spaceId;
    final provisionalTenant = TenantSummary(
      tenantId: result.spaceId,
      tenantName: tenantName,
      tenantCode: matchingMetadata?.tenantCode ??
          (normalizedFallbackCode?.isNotEmpty == true
              ? normalizedFallbackCode
              : null),
      logoUrl: matchingMetadata?.logoUrl,
      membershipRole: matchingMetadata?.membershipRole ?? 0,
    );

    await _applyTenantAuth(
      result,
      previousState.copyWith(availableTenants: [provisionalTenant]),
      authOperation: authOperation,
    );
    _ensureAuthOperationCurrent(authOperation);

    final appliedState = state.requireValue;
    final directoryTenant = TenantSummary(
      tenantId: provisionalTenant.tenantId,
      tenantName: provisionalTenant.tenantName,
      tenantCode: provisionalTenant.tenantCode,
      logoUrl: provisionalTenant.logoUrl,
      membershipRole: appliedState.currentSpace?.membershipRole ?? 0,
    );
    state = AsyncData(
      appliedState.copyWith(availableTenants: [directoryTenant]),
    );

    // Authentication is already committed. A presentation-cache failure must
    // not roll the account back or remove the verified current space.
    try {
      await _cacheTenantMetadata(
        [directoryTenant],
        platformUserId: appliedState.platformUserId,
        authOperation: authOperation,
      );
    } catch (error) {
      AppDiagnostics.instance.warning(
        'auth.tenant_directory_cache_failed',
        'Authenticated tenant directory could not be cached',
        context: {'errorType': error.runtimeType.toString()},
      );
    }
  }

  Future<void> _applyTenantAuth(
    TenantAuthResult result,
    AuthState prevState, {
    int? authOperation,
    bool restorePersonalOnRestart = false,
  }) async {
    try {
      _ensureAuthOperationCurrentIfPresent(authOperation);

      final resolvedPlatformUserId =
          result.platformUserId ?? prevState.platformUserId;
      // 构建企业空间 SpaceContext（从 availableTenants 获取 membershipRole）
      int membershipRole = prevState.availableTenants
              .where((t) => t.tenantId == result.spaceId)
              .map((t) => t.membershipRole)
              .firstOrNull ??
          0;
      if (membershipRole == 0 && result.userType != 1) {
        membershipRole = await _guardAuthOperation(
          authOperation,
          () => _resolveMembershipRoleFromTenantMembers(
            userId: result.userId,
            accessToken: result.accessToken,
          ),
        );
      }

      // membershipRole=0 同时覆盖普通员工和企业客户，需结合本次
      // select-tenant 返回的 userType 识别空间类型。
      SpaceType spaceType;
      if (_isEmployeeTenantIdentity(
        membershipRole: membershipRole,
        userType: result.userType,
      )) {
        spaceType = SpaceType.employee;
      } else {
        // membershipRole == 0：客户，进一步判断 social/restricted
        try {
          final friendMode = await _guardAuthOperation(
            authOperation,
            () => _repo.getTenantFriendMode(result.accessToken),
          );
          spaceType = friendMode == TenantFriendMode.social
              ? SpaceType.customerSocial
              : SpaceType.customerRestricted;
        } on _AuthOperationSuperseded {
          rethrow;
        } catch (_) {
          spaceType = SpaceType.customerRestricted;
        }
      }

      final space = SpaceContext(
        spaceId: result.spaceId,
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        userId: result.userId,
        type: spaceType,
        membershipRole: membershipRole,
      );

      final accountSession = await _commitAccountSession(
        result: result,
        space: space,
        platformToken: prevState.platformToken,
        platformUserId: resolvedPlatformUserId,
        authOperation: authOperation,
        restorePersonalOnRestart: restorePersonalOnRestart,
      );

      _ensureAuthOperationCurrentIfPresent(authOperation);
      _publishAuthState(AuthState(
        status: AuthStatus.authenticated,
        currentSpace: space,
        availableTenants: prevState.availableTenants,
        platformToken: _committedCredentials?.platformAccessToken,
        platformUserId: resolvedPlatformUserId,
        accountSession: accountSession,
      ));
      if (restorePersonalOnRestart) {
        _officialConversationActivationId = accountSession.sessionId;
      } else {
        _rememberLastActiveSpace(
          platformUserId: resolvedPlatformUserId,
          spaceId: result.spaceId,
        );
      }

      if (result.platformUserId?.trim().isEmpty ?? true) {
        unawaited(Future<void>.delayed(
          Duration.zero,
          () => _restoreUserId(
            result.spaceId,
            result.accessToken,
            authoritativeMembershipRole: membershipRole,
          ),
        ));
      }

      // 登录/切换空间后启动定时刷新
      _ensureAuthOperationCurrentIfPresent(authOperation);
      _startTokenRefresh();
    } on _AuthOperationSuperseded {
      rethrow;
    }
  }

  Future<AccountSession> _commitAccountSession({
    required TenantAuthResult result,
    required SpaceContext space,
    required String? platformToken,
    required String? platformUserId,
    required int? authOperation,
    bool restorePersonalOnRestart = false,
  }) =>
      _serializeAuthMutation(() async {
        final scope = AccountScope.tryFromSpace(
          serviceRealmId: ServiceRealmConfig.current.realmId,
          platformUserId: platformUserId ?? '',
          space: space,
        );
        if (scope == null) {
          throw const ServerError(
            code: 'AUTH_STABLE_IDENTITY_MISSING',
            message: '账号身份信息不完整，请重新登录',
          );
        }
        _ensureAuthOperationCurrentIfPresent(authOperation);
        final previous = _committedSession;
        // SDK startup intentionally leaves durable sessions inactive. A fresh
        // explicit login may replace that activation only as a CAS predecessor;
        // its credentials, identity and roles are never restored here.
        final predecessor =
            previous == null ? await _sessionStore.loadActive() : null;
        _ensureAuthOperationCurrentIfPresent(authOperation);
        final persistedRevision = predecessor?.session.identityRevision ?? 0;
        // A space selection may have started before a platform renewal completed.
        // Read the current account credential inside the same mutation boundary as
        // renewal writes, rather than persisting the selection's old snapshot.
        final samePlatformAccount = previous != null &&
            PlatformAccountScope.fromAccountScope(previous.scope) ==
                PlatformAccountScope.fromAccountScope(scope);
        final effectivePlatformToken = samePlatformAccount &&
                state.valueOrNull?.status == AuthStatus.authenticated
            ? _committedCredentials?.platformAccessToken ?? platformToken
            : platformToken;
        final nextRevision = (_identityRevision > persistedRevision
                ? _identityRevision
                : persistedRevision) +
            1;
        final credentials = SessionCredentials(
          tenantAccessToken: result.accessToken,
          tenantRefreshToken: result.refreshToken,
          platformAccessToken: effectivePlatformToken,
          platformRefreshToken: effectivePlatformToken == null
              ? null
              : _pendingPlatformRefreshToken ??
                  _committedCredentials?.platformRefreshToken,
          deviceSessionToken: effectivePlatformToken == null
              ? null
              : _pendingDeviceSessionToken ??
                  _committedCredentials?.deviceSessionToken,
        );
        final now = DateTime.now().toUtc();
        final active = await _sessionStore.provisionAndActivate(
          scope: scope,
          credentials: credentials,
          accessTokenIssuedAt: now,
          accessTokenExpiresAt: now.add(Duration(seconds: result.expiresIn)),
          expectedActivationId:
              previous?.sessionId ?? predecessor?.activationId,
          identityRevision: nextRevision,
          canCommit: () =>
              authOperation == null || _isAuthOperationCurrent(authOperation),
          restorePersonalOnRestart: restorePersonalOnRestart,
        );
        _identityRevision = nextRevision;
        _committedSession = active.session;
        _committedCredentials = active.credentials;
        _pendingPlatformRefreshToken = null;
        _pendingDeviceSessionToken = null;
        _ensureAuthOperationCurrentIfPresent(authOperation);
        return active.session;
      });

  void _rememberLastActiveSpace({
    required String? platformUserId,
    required String spaceId,
  }) {
    final stablePlatformUserId = platformUserId?.trim() ?? '';
    if (stablePlatformUserId.isEmpty) return;
    _lastActiveSpaceWriteTail = _lastActiveSpaceWriteTail.then((_) {
      return _tenantDirectoryStore.writeLastActiveSpace(
        serviceRealmId: ServiceRealmConfig.current.realmId,
        platformUserId: stablePlatformUserId,
        spaceId: spaceId,
      );
    }).catchError((Object error, StackTrace stackTrace) {
      AppDiagnostics.instance.warning(
        'auth.last_active_space_cache_failed',
        'Committed space could not be recorded as the last active space',
        context: {
          'errorType': error.runtimeType.toString(),
          'stack': stackTrace.toString(),
        },
      );
    });
    unawaited(_lastActiveSpaceWriteTail);
  }

  Future<void> _replaceCommittedCredentials({
    String? tenantAccessToken,
    String? tenantRefreshToken,
    String? platformAccessToken,
    String? platformRefreshToken,
  }) async {
    final expected = _committedSession;
    if (expected == null) return;
    final platform = PlatformAccountScope.fromAccountScope(expected.scope);
    bool acceptsWrite() =>
        _logoutTransitionFuture == null &&
        !LogoutGuard.isPending &&
        ref.read(currentAccountOperationContextProvider)?.sessionId ==
            _committedSession?.sessionId &&
        state.valueOrNull?.platformUserId == platform.platformUserId &&
        _committedSession != null &&
        PlatformAccountScope.fromAccountScope(_committedSession!.scope) ==
            platform;
    try {
      await _serializeAuthMutation(() async {
        if (!acceptsWrite()) return;
        final active = await _sessionStore.loadActive();
        if (!acceptsWrite() ||
            active == null ||
            PlatformAccountScope.fromAccountScope(active.session.scope) !=
                platform) {
          return;
        }
        if (active.spaceSessionId == null) {
          // V2 is retained only when the one-time V3 migration could not commit.
          if (active.session.sessionId != expected.sessionId) return;
          final current = active.credentials;
          await _sessionStore.replaceActiveCredentials(
            expectedCurrentSessionId: expected.sessionId,
            credentials: SessionCredentials(
              tenantAccessToken: tenantAccessToken ?? current.tenantAccessToken,
              tenantRefreshToken:
                  tenantRefreshToken ?? current.tenantRefreshToken,
              platformAccessToken:
                  platformAccessToken ?? current.platformAccessToken,
              platformRefreshToken:
                  platformRefreshToken ?? current.platformRefreshToken,
              deviceSessionToken: current.deviceSessionToken,
              adminToken: current.adminToken,
            ),
          );
        } else {
          if (platformAccessToken != null) {
            await _sessionStore.updatePlatformCredentials(
              platformAccount: platform,
              accessToken: platformAccessToken,
              refreshToken: platformRefreshToken ??
                  active.credentials.platformRefreshToken,
              deviceSessionToken: active.credentials.deviceSessionToken,
            );
          }
          if (tenantAccessToken != null || tenantRefreshToken != null) {
            final stored = await _sessionStore.loadReusableSpace(
              platformAccount: platform,
              spaceId: expected.scope.spaceId,
            );
            if (!acceptsWrite() ||
                stored == null ||
                stored.scope != expected.scope) {
              return;
            }
            await _sessionStore.updateSpaceCredentials(
              spaceSessionId: stored.spaceSessionId,
              accessToken: tenantAccessToken ?? stored.accessToken,
              refreshToken: tenantRefreshToken ?? stored.refreshToken,
              accessTokenIssuedAt: stored.accessTokenIssuedAt,
              accessTokenExpiresAt: stored.accessTokenExpiresAt,
            );
          }
        }
        final latest = await _sessionStore.loadActive();
        if (!acceptsWrite() ||
            latest == null ||
            latest.session.sessionId != _committedSession?.sessionId) {
          return;
        }
        _committedCredentials = latest.credentials;
        final current = state.valueOrNull;
        if (current == null ||
            current.accountSession?.sessionId != latest.session.sessionId) {
          return;
        }
        final next = current.copyWith(
          platformToken: latest.credentials.platformAccessToken,
          currentSpace: current.currentSpace?.copyWith(
            accessToken: latest.credentials.tenantAccessToken,
            refreshToken: latest.credentials.tenantRefreshToken,
          ),
        );
        // Updating credentials must not complete an in-progress space switch.
        final wasLoading = state.isLoading;
        _installIdentityProjection(next.currentSpace, next.accountSession);
        state = wasLoading
            ? const AsyncLoading<AuthState>().copyWithPrevious(AsyncData(next))
            : AsyncData(next);
      });
    } catch (error) {
      AppDiagnostics.instance.error(
        'auth.credential_write_failed',
        'Renewed credentials could not be committed',
        context: {
          'credentialDomain':
              platformAccessToken != null ? 'platform' : 'tenant',
          'errorType': error.runtimeType.toString(),
          'scopeFingerprint': expected.scope.storageKeyHash.substring(0, 12),
        },
      );
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 定时 Token 刷新
  // ---------------------------------------------------------------------------

  /// 启动定时刷新（前台 45 分钟一次，后台通过 workmanager 15 分钟一次）
  void _startTokenRefresh() {
    final expectedSessionId = _committedSession?.sessionId;
    if (expectedSessionId == null) return;
    TokenRefreshService.instance.start(
      onRefresh: () async {
        if (_committedSession?.sessionId != expectedSessionId) return;
        // Tenant-only SDK credentials are valid. Do not try platform renewal
        // without a platform credential and incorrectly revoke that session.
        if (!ref.read(externalSessionOnlyProvider) ||
            _committedCredentials?.platformAccessToken != null ||
            _committedCredentials?.platformRefreshToken != null ||
            _committedCredentials?.deviceSessionToken != null) {
          await refreshPlatformToken();
        }
        if (_committedSession?.sessionId != expectedSessionId) return;
        await _refreshCurrentTenantToken();
      },
    );
  }

  /// 刷新当前激活空间的租户 token
  Future<void> _refreshCurrentTenantToken() async {
    final currentState = state.valueOrNull;
    final platformToken = currentState?.platformToken;
    if (platformToken == null && !ref.read(externalSessionOnlyProvider)) return;

    final spaceId = currentState?.currentSpace?.spaceId;
    if (spaceId == null) return;
    final expectedSessionId = _committedSession?.sessionId;
    if (expectedSessionId == null) return;

    try {
      final currentSpace = currentState?.currentSpace;
      if (currentSpace == null) return;
      final result = await _repo.refreshToken(currentSpace.refreshToken);
      if (_committedSession?.sessionId != expectedSessionId) return;
      final active = await _sessionStore.loadActive();
      final spaceSessionId = active?.spaceSessionId;
      if (spaceSessionId != null && active?.activationId == expectedSessionId) {
        final issuedAt = DateTime.now().toUtc();
        await _sessionStore.updateSpaceCredentials(
          spaceSessionId: spaceSessionId,
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
          accessTokenIssuedAt: issuedAt,
          accessTokenExpiresAt:
              issuedAt.add(Duration(seconds: result.expiresIn)),
        );
      }
      // 更新内存状态
      await updateTenantToken(
        spaceId,
        result.accessToken,
        newRefreshToken: result.refreshToken,
      );
      debugPrint('[TokenRefresh] tenant token refreshed for $spaceId');
    } catch (e) {
      AppDiagnostics.instance.warning(
        'auth.renewal_failed',
        'Scheduled tenant credential renewal failed',
        context: {
          'credentialDomain': 'tenant',
          'endpoint': '/api/client/v1/auth/refresh',
          'errorType': e.runtimeType.toString(),
          if (e is AuthError) 'serverCode': e.code,
        },
      );
    }
  }

  // ---------------------------------------------------------------------------
  // 刷新 platformToken
  // ---------------------------------------------------------------------------

  /// TokenInterceptor 刷新 platformToken 成功后调用，同步更新内存 state
  String? get currentPlatformRefreshToken =>
      _committedCredentials?.platformRefreshToken;

  String? get currentDeviceSessionToken =>
      _committedCredentials?.deviceSessionToken;

  Future<void> updatePlatformToken(
    String newToken, {
    String? newPlatformRefreshToken,
  }) =>
      _replaceCommittedCredentials(
        platformAccessToken: newToken,
        platformRefreshToken: newPlatformRefreshToken,
      );

  /// TokenInterceptor 刷新租户 token 成功后调用，同步更新内存 state
  Future<void> updateTenantToken(
    String spaceId,
    String newAccessToken, {
    String? newRefreshToken,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;
    // 只更新当前激活空间的 accessToken
    if (current.currentSpace?.spaceId == spaceId) {
      await _replaceCommittedCredentials(
        tenantAccessToken: newAccessToken,
        tenantRefreshToken: newRefreshToken,
      );
    }
  }

  /// 主动刷新 platformToken，成功后写入 SecureStorage 并更新 state
  /// 建议在 app 进入前台时调用，或在 platformToken 即将过期时调用
  Future<void> refreshPlatformToken() {
    final sessionId = _committedSession?.sessionId;
    final inFlight = _platformRefreshFuture;
    if (inFlight != null && _platformRefreshSessionId == sessionId) {
      return inFlight;
    }

    late final Future<void> operation;
    final renewal = inFlight == null
        ? _refreshPlatformTokenOnce(sessionId)
        : inFlight.then((_) => _refreshPlatformTokenOnce(sessionId));
    operation = renewal.whenComplete(() {
      if (identical(_platformRefreshFuture, operation)) {
        _platformRefreshFuture = null;
        _platformRefreshSessionId = null;
      }
    });
    _platformRefreshFuture = operation;
    _platformRefreshSessionId = sessionId;
    return operation;
  }

  Future<void> _refreshPlatformTokenOnce(String? expectedSessionId) async {
    try {
      final newPlatformToken =
          await ref.read(httpClientProvider).refreshPlatformSession();
      final session = _committedSession;
      if (expectedSessionId == null ||
          session?.sessionId != expectedSessionId) {
        return;
      }
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData(
          current.copyWith(platformToken: newPlatformToken),
        );
      }

      final currentSpace = ref.read(currentSpaceProvider);
      if (currentSpace == null || currentSpace.isPersonal) return;
      await _restoreTenants(
        newPlatformToken,
        currentSpace.spaceId,
        AccountOperationContext(
          accountScopeKey: session!.scope.scopeKey,
          identityRevision: _identityRevision,
          sessionId: session.sessionId,
        ),
      );
    } catch (e) {
      // 只有长期凭证被服务端明确判定失效时才登出。网络错误以及升级前没有
      // 长期凭证的旧会话都保留现有租户登录态。
      final shouldLogout = e is AuthError &&
          expectedSessionId != null &&
          _committedSession?.sessionId == expectedSessionId;
      AppDiagnostics.instance.warning(
        'auth.platform_renewal_failed',
        'Platform renewal did not complete',
        context: {
          'errorType': e.runtimeType.toString(),
          if (e is AuthError) 'serverCode': e.code,
          'decision': shouldLogout ? 'logout' : 'preserveSession',
        },
      );
      if (shouldLogout) {
        await logout(
          reason: AuthLogoutReason.platformRenewalRejected,
          serverCode: e.code,
        );
      }
    }
  }

  /// 下拉刷新时调用：检查是否有新审批通过的企业空间
  /// 对比当前 availableTenants 和服务端最新列表，有新租户则预取 token 并更新 state
  Future<void> refreshTenants() => _refreshTenantDirectory();

  Future<void> _refreshTenantDirectory({String? preserveActiveSpaceId}) async {
    var platformToken = state.valueOrNull?.platformToken;
    if (platformToken == null) return;
    final directoryRefreshGeneration = ++_tenantDirectoryRefreshGeneration;
    final requestIdentityRevision = _identityRevision;

    try {
      List<TenantSummary> newTenants;
      try {
        newTenants = await _repo.getMyTenants(platformToken);
      } on AuthError {
        // platform token 过期，先刷新再重试
        await refreshPlatformToken();
        platformToken = state.valueOrNull?.platformToken;
        if (platformToken == null) return;
        newTenants = await _repo.getMyTenants(platformToken);
      }
      final current = state.valueOrNull;
      if (current == null ||
          directoryRefreshGeneration != _tenantDirectoryRefreshGeneration ||
          requestIdentityRevision != _identityRevision) {
        return;
      }
      final publishedSession = activeAccountSessionFromAuthState(current);
      final session = _committedSession ?? publishedSession;
      if (session == null ||
          publishedSession?.sessionId != session.sessionId ||
          session.scope.platformUserId != current.platformUserId) {
        return;
      }
      final activeSpaceId = ref.read(currentSpaceProvider)?.spaceId;
      final preserveJoinedSpace = preserveActiveSpaceId != null &&
          preserveActiveSpaceId == activeSpaceId;
      final activeTenantMissing = activeSpaceId != null &&
          activeSpaceId != 'personal' &&
          !newTenants.any((tenant) => tenant.tenantId == activeSpaceId);
      final preservedTenant = preserveJoinedSpace && activeTenantMissing
          ? current.availableTenants
              .where((tenant) => tenant.tenantId == activeSpaceId)
              .firstOrNull
          : null;
      final directoryTenants = preservedTenant == null
          ? newTenants
          : <TenantSummary>[...newTenants, preservedTenant];
      final revoked = activeSpaceId != null &&
          activeSpaceId != 'personal' &&
          activeTenantMissing &&
          !preserveJoinedSpace;
      bool acceptsDirectoryRefresh() {
        final latestPublished = state.valueOrNull;
        return directoryRefreshGeneration ==
                _tenantDirectoryRefreshGeneration &&
            requestIdentityRevision == _identityRevision &&
            latestPublished != null &&
            activeAccountSessionFromAuthState(latestPublished)?.sessionId ==
                session.sessionId &&
            (_committedSession == null ||
                _committedSession?.sessionId == session.sessionId);
      }

      final directoryApplied = await _serializeAuthMutation(() async {
        if (!acceptsDirectoryRefresh()) return false;
        final latestCurrent = state.valueOrNull;
        if (latestCurrent == null) return false;
        if (revoked) {
          _publishAuthState(latestCurrent.copyWith(
            status: AuthStatus.unauthenticated,
            availableTenants: directoryTenants,
            clearCurrentSpace: true,
            clearAccountSession: true,
          ));
        } else {
          state = AsyncData(
            latestCurrent.copyWith(availableTenants: directoryTenants),
          );
        }
        try {
          await _tenantDirectoryStore.replace(
            serviceRealmId: session.scope.serviceRealmId,
            platformUserId: session.scope.platformUserId,
            tenants: directoryTenants,
          );
        } catch (_) {
          // Keep the authoritative response applied in memory even when the
          // account-scoped offline projection cannot be persisted.
        }
        if (directoryRefreshGeneration != _tenantDirectoryRefreshGeneration ||
            requestIdentityRevision != _identityRevision ||
            (_committedSession != null &&
                _committedSession?.sessionId != session.sessionId)) {
          return false;
        }
        return revoked || acceptsDirectoryRefresh();
      });
      if (!directoryApplied) return;

      if (revoked) {
        await selectPersonalSpace();
        if (state.hasError) {
          _publishAuthState(AuthState(
            status: AuthStatus.unauthenticated,
            availableTenants: directoryTenants,
            platformToken: platformToken,
            platformUserId: session.scope.platformUserId,
            error: AuthPresentationFailure.personalSpaceRestore,
          ));
        }
        return;
      }
      if (!acceptsDirectoryRefresh()) return;
      final previousActiveRole = current.availableTenants
          .where((tenant) => tenant.tenantId == activeSpaceId)
          .map((tenant) => tenant.membershipRole)
          .firstOrNull;
      final refreshedActiveRole = directoryTenants
          .where((tenant) => tenant.tenantId == activeSpaceId)
          .map((tenant) => tenant.membershipRole)
          .firstOrNull;
      final activeRoleChanged = previousActiveRole != null &&
          refreshedActiveRole != null &&
          previousActiveRole != refreshedActiveRole;

      final identityRevision = activeRoleChanged ? ++_identityRevision : null;

      // 同步更新当前空间的 membershipRole（服务端可能已修改角色）
      final currentSpaceId = current.currentSpace?.spaceId;
      if (currentSpaceId != null && currentSpaceId != 'personal') {
        final updatedTenant = directoryTenants
            .where((t) => t.tenantId == currentSpaceId)
            .firstOrNull;
        if (updatedTenant != null) {
          final currentSpace = ref.read(currentSpaceProvider);
          if (currentSpace != null &&
              (activeRoleChanged ||
                  currentSpace.membershipRole != updatedTenant.membershipRole ||
                  _spaceTypeConflictsWithMembershipRole(
                    currentSpace,
                    updatedTenant.membershipRole,
                  ))) {
            final requestRevision = identityRevision ?? ++_identityRevision;
            final identityResult = await _restoreUserId(
              currentSpaceId,
              currentSpace.accessToken,
              authoritativeMembershipRole: updatedTenant.membershipRole,
              identityRevision: requestRevision,
            );
            if (identityResult == _IdentityRefreshResult.failed) {
              _applyFailClosedMembershipRole(
                spaceId: currentSpaceId,
                originRefreshToken: currentSpace.refreshToken,
                authoritativeMembershipRole: updatedTenant.membershipRole,
                identityRevision: requestRevision,
              );
            }
          }
        }
      }

      // 刷新空间列表（更新 logoUrl 显示）
      ref.invalidate(spacesProvider);
    } catch (_) {
      // refreshTenants 失败静默处理
    }
  }

  /// 企业码/邀请码自动通过时，服务端会直接返回 tenant token。
  /// 该方法用于把这类结果接入当前双层 Token/SpaceContext 状态。
  Future<void> enterTenantFromJoinResult(
    TenantAuthResult result, {
    TenantSummary? tenant,
  }) async {
    await _waitForLogoutCleanup();
    final authOperation = ++_authOperationGeneration;
    final current = state.valueOrNull;
    if (current == null || current.platformToken == null) {
      throw StateError('当前平台会话不可用，请重新登录');
    }
    final tenants = [...current.availableTenants];
    if (tenant != null && tenant.tenantId.isNotEmpty) {
      final index = tenants.indexWhere((t) => t.tenantId == tenant.tenantId);
      if (index >= 0) {
        tenants[index] = tenant;
      } else {
        tenants.add(tenant);
      }
    }
    try {
      await _beginIdentityTransition(authOperation);
      await _applyTenantAuth(
        result,
        current.copyWith(availableTenants: tenants),
        authOperation: authOperation,
      );
      _ensureAuthOperationCurrent(authOperation);
      await _refreshTenantDirectory(
        preserveActiveSpaceId: result.spaceId,
      );
    } catch (error, stackTrace) {
      if (error is _AuthOperationSuperseded) return;
      if (!_isAuthOperationCurrent(authOperation)) return;
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

class _AuthOperationSuperseded implements Exception {
  const _AuthOperationSuperseded();
}
