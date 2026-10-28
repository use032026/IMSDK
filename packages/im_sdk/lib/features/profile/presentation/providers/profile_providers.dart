import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/core/storage/account_profile_box_provider.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/profile/data/datasources/profile_datasources.dart';
import 'package:im_sdk/features/profile/data/repositories/profile_repositories.dart';
import 'package:im_sdk/features/profile/domain/entities/profile_entities.dart'
    as entities;
import 'package:im_sdk/features/profile/domain/repositories/profile_repositories.dart';

// ---------------------------------------------------------------------------
// DI
// ---------------------------------------------------------------------------

final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSourceImpl(ref.watch(dioProvider));
}, dependencies: [dioProvider]);

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  return HiveProfileLocalDataSource(
    profileBoxResolver: ref.watch(accountProfileBoxResolverProvider),
  );
}, dependencies: [accountProfileBoxResolverProvider]);

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    ref.watch(profileRemoteDataSourceProvider),
    ref.watch(profileLocalDataSourceProvider),
  );
}, dependencies: [
  profileRemoteDataSourceProvider,
  profileLocalDataSourceProvider,
]);

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class ProfileState {
  final entities.UserProfile? profile;
  final bool isLoading;
  final bool isRefreshing;
  final Object? error;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  ProfileState copyWith({
    entities.UserProfile? profile,
    bool? isLoading,
    bool? isRefreshing,
    Object? error,
  }) =>
      ProfileState(
        profile: profile ?? this.profile,
        isLoading: isLoading ?? this.isLoading,
        isRefreshing: isRefreshing ?? this.isRefreshing,
        error: error,
      );

  bool get hasInitialError => profile == null && error != null;
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

typedef _ProfileScope = ({String spaceId, String userId});

class ProfileNotifier extends Notifier<ProfileState> {
  late ProfileRepository _repo;
  _ProfileScope? _scope;
  int _requestVersion = 0;
  Future<void> _profileUpdateTail = Future<void>.value();

  @override
  ProfileState build() {
    _repo = ref.watch(profileRepositoryProvider);
    final space = ref.watch(accountRuntimeCurrentSpaceProvider);
    final scopeKey = (
      spaceId: space?.spaceId ?? '',
      userId: space?.userId ?? '',
      hasToken: space?.accessToken.isNotEmpty == true,
    );
    final nextScope = scopeKey.hasToken &&
            scopeKey.spaceId.isNotEmpty &&
            scopeKey.userId.isNotEmpty
        ? (spaceId: scopeKey.spaceId, userId: scopeKey.userId)
        : null;
    _scope = nextScope;
    _requestVersion += 1;

    if (nextScope == null) return const ProfileState();

    final version = _requestVersion;
    Future<void>.microtask(
      () => _load(nextScope, version: version, readCache: true),
    );
    return const ProfileState(isLoading: true);
  }

  Future<void> loadProfile() => refresh();

  Future<void> refresh() async {
    final scope = _scopeFrom(ref.read(accountRuntimeCurrentSpaceProvider));
    if (scope == null) return;
    _scope = scope;
    final version = ++_requestVersion;
    await _load(
      scope,
      version: version,
      readCache: state.profile == null,
    );
  }

  Future<void> _load(
    _ProfileScope scope, {
    required int version,
    required bool readCache,
  }) async {
    final existing = state.profile;
    if (existing == null) {
      state = const ProfileState(isLoading: true);
    } else {
      state = state.copyWith(isRefreshing: true, error: null);
    }

    try {
      entities.UserProfile? cached;
      if (readCache) {
        try {
          cached = await _repo.getCachedMyProfile(
            spaceId: scope.spaceId,
            userId: scope.userId,
          );
        } catch (error) {
          AppDiagnostics.instance.warning(
            'profile.cache.read_failed',
            'Current profile cache read failed',
            context: {
              'scopeHash':
                  Object.hash(scope.spaceId, scope.userId).toRadixString(16),
              'errorType': error.runtimeType.toString(),
            },
          );
        }
        if (_canCommit(scope, version) && cached != null) {
          state = ProfileState(profile: cached, isRefreshing: true);
        }
      }

      final fresh = await _repo.refreshMyProfile(
        spaceId: scope.spaceId,
        userId: scope.userId,
      );
      if (!_canCommit(scope, version)) return;
      state = ProfileState(profile: fresh);
    } catch (error) {
      if (!_canCommit(scope, version)) return;
      final retained = state.profile ?? existing;
      state = ProfileState(profile: retained, error: error);
      _recordFailure(
        action: 'load',
        scope: scope,
        error: error,
        retainedCache: retained != null,
      );
    }
  }

  Future<bool> updateProfile(entities.UpdateProfileRequest request) async {
    final requestedScope =
        _scopeFrom(ref.read(accountRuntimeCurrentSpaceProvider));
    if (requestedScope == null) return false;
    final operation = _profileUpdateTail.then(
      (_) => _updateProfileNow(request, requestedScope),
    );
    _profileUpdateTail = operation.then<void>(
      (_) {},
      onError: (_, __) {},
    );
    return operation;
  }

  Future<bool> _updateProfileNow(
    entities.UpdateProfileRequest request,
    _ProfileScope requestedScope,
  ) async {
    final scope = _scopeFrom(ref.read(accountRuntimeCurrentSpaceProvider));
    if (scope == null || scope != requestedScope || _scope != requestedScope) {
      return false;
    }
    final version = ++_requestVersion;
    state = state.copyWith(isRefreshing: true, error: null);
    try {
      final updated = await _repo.updateMyProfile(
        request,
        spaceId: scope.spaceId,
        userId: scope.userId,
        currentProfile: state.profile,
      );
      if (!_canCommit(scope, version)) return false;
      state = ProfileState(profile: updated);
      return true;
    } catch (error) {
      if (_canCommit(scope, version)) {
        state = ProfileState(profile: state.profile, error: error);
        _recordFailure(
          action: 'update',
          scope: scope,
          error: error,
          retainedCache: state.profile != null,
        );
      }
      return false;
    }
  }

  Future<bool> updateLppId(String newLppId) async {
    final scope = _scopeFrom(ref.read(accountRuntimeCurrentSpaceProvider));
    if (scope == null) return false;
    final version = ++_requestVersion;
    state = state.copyWith(isRefreshing: true, error: null);
    try {
      final updated = await _repo.updateMyLppId(
        newLppId,
        spaceId: scope.spaceId,
        userId: scope.userId,
      );
      if (!_canCommit(scope, version)) return false;
      state = ProfileState(profile: updated);
      return true;
    } catch (error) {
      if (_canCommit(scope, version)) {
        state = ProfileState(profile: state.profile, error: error);
        _recordFailure(
          action: 'update_lpp_id',
          scope: scope,
          error: error,
          retainedCache: state.profile != null,
        );
      }
      return false;
    }
  }

  _ProfileScope? _scopeFrom(SpaceContext? space) {
    if (space == null ||
        space.accessToken.isEmpty ||
        space.spaceId.isEmpty ||
        space.userId.isEmpty) {
      return null;
    }
    return (spaceId: space.spaceId, userId: space.userId);
  }

  bool _canCommit(_ProfileScope scope, int version) =>
      version == _requestVersion && _scope == scope;

  void _recordFailure({
    required String action,
    required _ProfileScope scope,
    required Object error,
    required bool retainedCache,
  }) {
    AppDiagnostics.instance.error(
      'profile.current.failed',
      'Current profile operation failed',
      context: {
        'action': action,
        'scopeHash': Object.hash(scope.spaceId, scope.userId).toRadixString(16),
        'errorType': error.runtimeType.toString(),
        'retainedCache': retainedCache,
      },
    );
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
  dependencies: [
    dioProvider,
    accountRuntimeCurrentSpaceProvider,
    accountStorageContextProvider,
    profileRepositoryProvider,
  ],
);

/// 便捷 provider：直接获取 UserProfile（可为 null），使用不同名称避免与 my_profile_page 冲突
final currentUserProfileProvider = Provider<entities.UserProfile?>((ref) {
  if (ref.watch(accountScopeProvider) == null) return null;
  return ref.watch(profileProvider).profile;
}, dependencies: [accountScopeProvider, profileProvider]);
