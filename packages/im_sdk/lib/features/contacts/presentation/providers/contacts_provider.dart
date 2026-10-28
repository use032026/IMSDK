import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/storage/account_profile_box_provider.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/core/media/authenticated_image_cache.dart';
import 'package:im_sdk/features/contacts/data/datasources/contacts_remote_datasource.dart';
import 'package:im_sdk/features/contacts/data/datasources/contacts_directory_local_datasource.dart';
import 'package:im_sdk/features/contacts/data/datasources/friend_profile_extra_local_datasource.dart';
import 'package:im_sdk/features/contacts/data/datasources/friend_invite_qr_api.dart';
import 'package:im_sdk/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/contacts/domain/entities/friend_profile_extra.dart';
import 'package:im_sdk/features/contacts/domain/repositories/contacts_repository.dart';

// ---------------------------------------------------------------------------
// Repository Provider
// ---------------------------------------------------------------------------

final contactsRepositoryProvider = Provider<ContactsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ContactsRepositoryImpl(ContactsRemoteDataSourceImpl(dio));
}, dependencies: [dioProvider]);

final friendInviteQrApiProvider = Provider<FriendInviteQrApi>(
  (ref) => FriendInviteQrApi(ref.watch(dioProvider)),
  dependencies: [dioProvider],
);

final contactsDirectoryLocalDataSourceProvider =
    Provider<ContactsDirectoryLocalDataSource>((ref) {
  return ContactsDirectoryLocalDataSource(
    profileBoxResolver: ref.watch(accountProfileBoxResolverProvider),
  );
}, dependencies: [accountProfileBoxResolverProvider]);

/// 空间切换后清空通讯录相关的内存状态。
///
/// 通讯录数据虽然有按 spaceId 写入本地缓存，但这些 provider 是全局入口。
/// 主动 invalidate 可以避免切换空间后短暂展示上一空间的联系人。
void invalidateContactScopedProviders(Ref ref) {
  ref.invalidate(friendsProvider);
  ref.invalidate(tenantMembersProvider);
  ref.invalidate(departmentTreeProvider);
  ref.invalidate(departmentMembersProvider);
  ref.invalidate(pendingJoinRequestsCountProvider);
  ref.invalidate(assignedStaffProvider);
  ref.invalidate(friendRequestsProvider);
  ref.invalidate(pendingFriendRequestsProvider);
  ref.invalidate(friendProfileExtraProvider);
  ref.invalidate(blocklistProvider);
}

class FriendProfileScope {
  final String spaceId;
  final String ownerUserId;
  final String friendUserId;

  const FriendProfileScope({
    required this.spaceId,
    required this.ownerUserId,
    required this.friendUserId,
  });

  @override
  bool operator ==(Object other) =>
      other is FriendProfileScope &&
      other.spaceId == spaceId &&
      other.ownerUserId == ownerUserId &&
      other.friendUserId == friendUserId;

  @override
  int get hashCode => Object.hash(spaceId, ownerUserId, friendUserId);
}

final friendProfileExtraLocalDataSourceProvider =
    Provider<FriendProfileExtraLocalDataSource>(
  (ref) => FriendProfileExtraLocalDataSource(
    profileBoxResolver: ref.watch(accountProfileBoxResolverProvider),
  ),
  dependencies: [accountProfileBoxResolverProvider],
);

class FriendProfileExtraNotifier
    extends FamilyAsyncNotifier<FriendProfileExtra, FriendProfileScope> {
  late FriendProfileScope _scope;
  int _revision = 0;
  Future<void> _mutationTail = Future<void>.value();

  @override
  Future<FriendProfileExtra> build(FriendProfileScope arg) async {
    _scope = arg;
    final local = ref.read(friendProfileExtraLocalDataSourceProvider);
    final cached = await local.load(
      arg.spaceId,
      arg.friendUserId,
      ownerUserId: arg.ownerUserId,
    );
    if (!_isCurrentScope) {
      throw StateError('账号身份已切换');
    }
    if (cached != null) {
      state = AsyncData(cached);
      unawaited(_refreshRemote(silent: true));
      return cached;
    }
    return _fetchAndCache();
  }

  Future<FriendProfileExtra> _fetchAndCache() async {
    final profile = await _fetchRemote();
    if (!_isCurrentScope) throw StateError('账号身份已切换');
    await ref.read(friendProfileExtraLocalDataSourceProvider).save(
          _scope.spaceId,
          profile,
          ownerUserId: _scope.ownerUserId,
        );
    if (!_isCurrentScope) throw StateError('账号身份已切换');
    return profile;
  }

  bool get _isCurrentScope {
    final current = ref.read(accountRuntimeCurrentSpaceProvider);
    return current?.spaceId == _scope.spaceId &&
        current?.userId == _scope.ownerUserId;
  }

  Future<FriendProfileExtra> _fetchRemote() => ref
      .read(contactsRepositoryProvider)
      .getFriendProfileExtra(_scope.friendUserId);

  Future<void> _refreshRemote({required bool silent}) async {
    final revision = _revision;
    try {
      final remote = await _fetchRemote();
      if (revision != _revision || !_isCurrentScope) return;
      final current = state.valueOrNull;
      final fresh =
          !remote.remarkGenderProvided && current?.remarkGenderProvided == true
              ? remote.withRemarkGenderSnapshot(
                  current!.remarkGender,
                  provided: true,
                )
              : remote;
      await ref.read(friendProfileExtraLocalDataSourceProvider).save(
            _scope.spaceId,
            fresh,
            ownerUserId: _scope.ownerUserId,
          );
      if (revision != _revision || !_isCurrentScope) return;
      state = AsyncData(fresh);
    } catch (error, stackTrace) {
      if (!silent && state.valueOrNull == null) {
        state = AsyncError(error, stackTrace);
      }
    }
  }

  Future<void> refresh() => _refreshRemote(silent: state.valueOrNull != null);

  Future<T> _serializeMutation<T>(Future<T> Function() operation) {
    final completer = Completer<T>();
    _mutationTail = _mutationTail.then((_) async {
      try {
        completer.complete(await operation());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }

  Future<FriendProfileExtra> saveRemark(FriendRemarkDraft input) {
    _revision++;
    return _serializeMutation(() async {
      if (!_isCurrentScope) throw StateError('账号身份已切换');
      final draft = input.normalized();
      final current = state.valueOrNull ??
          FriendProfileExtra(friendUserId: _scope.friendUserId);
      await ref.read(contactsRepositoryProvider).updateFriend(
            _scope.friendUserId,
            remark: draft.remarkName,
            tags: draft.tags,
            note: draft.note,
          );
      if (!_isCurrentScope) throw StateError('账号身份已切换');
      final updated = current.copyWith(
        remarkName: draft.remarkName,
        tags: draft.tags,
        note: draft.note,
        syncedAt: DateTime.now(),
      );
      await ref.read(friendProfileExtraLocalDataSourceProvider).save(
            _scope.spaceId,
            updated,
            ownerUserId: _scope.ownerUserId,
          );
      if (!_isCurrentScope) throw StateError('账号身份已切换');
      state = AsyncData(updated);
      ref.invalidate(friendsProvider);
      return updated;
    });
  }

  Future<FriendProfileExtra> saveGender(String? gender) {
    _revision++;
    return _serializeMutation(() async {
      if (!_isCurrentScope) throw StateError('账号身份已切换');
      final normalized = normalizeFriendGender(gender);
      await ref.read(contactsRepositoryProvider).updateFriend(
            _scope.friendUserId,
            remarkGenderValue: friendGenderWireValue(normalized),
          );
      if (!_isCurrentScope) throw StateError('账号身份已切换');
      final updated = await ref
          .read(contactsRepositoryProvider)
          .getFriendProfileExtra(_scope.friendUserId);
      if (!_isCurrentScope) throw StateError('账号身份已切换');
      if (!updated.remarkGenderProvided || updated.remarkGender != normalized) {
        throw StateError('服务端未保存好友性别');
      }
      final fresh = updated.copyWith(syncedAt: DateTime.now());
      await ref.read(friendProfileExtraLocalDataSourceProvider).save(
            _scope.spaceId,
            fresh,
            ownerUserId: _scope.ownerUserId,
          );
      if (!_isCurrentScope) throw StateError('账号身份已切换');
      state = AsyncData(fresh);
      return fresh;
    });
  }

  Future<void> deleteCache() async {
    await ref.read(friendProfileExtraLocalDataSourceProvider).delete(
          _scope.spaceId,
          _scope.friendUserId,
          ownerUserId: _scope.ownerUserId,
        );
  }
}

final friendProfileExtraProvider = AsyncNotifierProvider.family<
    FriendProfileExtraNotifier, FriendProfileExtra, FriendProfileScope>(
  FriendProfileExtraNotifier.new,
  dependencies: [
    accountRuntimeCurrentSpaceProvider,
    friendProfileExtraLocalDataSourceProvider,
    contactsRepositoryProvider,
    friendsProvider,
  ],
);

final blocklistProvider = FutureProvider<List<BlockedUser>>((ref) async {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || space.accessToken.isEmpty) return const [];
  return ref.read(contactsRepositoryProvider).getBlocklist();
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  contactsRepositoryProvider,
]);

// ---------------------------------------------------------------------------
// Friends list — 本地优先缓存，后台异步刷新（微信做法）
// ---------------------------------------------------------------------------

class FriendsNotifier extends StateNotifier<AsyncValue<List<Contact>>> {
  final Ref _ref;

  FriendsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadWithCache();
  }

  bool _isStillCurrentIdentity(String spaceId, String userId) {
    if (!mounted) return false;
    final current = _ref.read(accountRuntimeCurrentSpaceProvider);
    return current?.spaceId == spaceId && current?.userId == userId;
  }

  Future<void> _loadWithCache() async {
    if (!mounted) return;
    final space = _ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null || space.accessToken.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    // 1. 先读本地缓存立即显示；头像后台预热，避免联系人首屏被头像 I/O 拖慢。
    final cached = await _loadFromCache(space.spaceId, space.userId);
    if (cached != null) {
      if (!_isStillCurrentIdentity(space.spaceId, space.userId)) return;
      state = AsyncValue.data(cached);
      Future.microtask(() => _prefetchAvatars(cached));
      // 2. 后台静默刷新
      _syncFromRemote(space.spaceId, space.userId);
      return;
    }

    // 3. 无缓存：走网络
    await _fetchAndCache(space.spaceId, space.userId);
  }

  Future<List<Contact>?> _loadFromCache(String spaceId, String userId) async {
    try {
      return _ref
          .read(contactsDirectoryLocalDataSourceProvider)
          .loadFriends(spaceId, userId);
    } catch (error) {
      AppDiagnostics.instance.warning(
        'contacts.friends.cache_read',
        'friend cache read failed before remote refresh',
        context: {
          'spaceId': spaceId,
          'errorType': error.runtimeType.toString(),
        },
      );
      return null;
    }
  }

  Future<void> _saveToCache(
      String spaceId, String userId, List<Contact> contacts) async {
    try {
      await _ref
          .read(contactsDirectoryLocalDataSourceProvider)
          .saveFriends(spaceId, userId, contacts);
    } catch (error) {
      AppDiagnostics.instance.warning(
        'contacts.friends.cache_write',
        'friend cache write failed after remote refresh',
        context: {
          'spaceId': spaceId,
          'errorType': error.runtimeType.toString(),
        },
      );
    }
  }

  Future<void> _fetchAndCache(String spaceId, String userId) async {
    if (!mounted) return;
    try {
      final repo = _ref.read(contactsRepositoryProvider);
      final friends = await repo.getFriends();
      if (!_isStillCurrentIdentity(spaceId, userId)) return;
      await _saveToCache(spaceId, userId, friends);
      if (!_isStillCurrentIdentity(spaceId, userId)) return;
      final current = state.valueOrNull;
      if (!_listEquals(current, friends)) {
        state = AsyncValue.data(friends);
      }
      Future.microtask(() => _prefetchAvatars(friends));
    } catch (e, st) {
      if (!_isStillCurrentIdentity(spaceId, userId)) return;
      // 401：token 过期，静默处理
      if (e.toString().contains('401')) return;
      if (state.valueOrNull == null) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  /// 比较两个好友列表是否内容相同（按 userId + avatarUrl + name + remark）
  static bool _listEquals(List<Contact>? a, List<Contact>? b) {
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      final x = a[i], y = b[i];
      if (x.userId != y.userId ||
          x.avatarUrl != y.avatarUrl ||
          x.name != y.name ||
          x.remark != y.remark) {
        return false;
      }
    }
    return true;
  }

  /// 预热好友头像到内存缓存
  Future<void> _prefetchAvatars(List<Contact> friends) async {
    final avatarUrls = friends
        .map((friend) => friend.avatarUrl)
        .where((url) => url?.isNotEmpty == true)
        .toList(growable: false);
    if (avatarUrls.isEmpty) return;
    await prefetchAvatarUrls(
      avatarUrls,
      cacheManager: _ref.read(accountAuthCacheManagerProvider),
    );
  }

  void _syncFromRemote(String spaceId, String userId) {
    Future.microtask(() => _fetchAndCache(spaceId, userId));
  }

  /// 手动刷新（下拉刷新时调用）
  Future<void> refresh() async {
    final space = _ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null) return;
    await _fetchAndCache(space.spaceId, space.userId);
  }

  /// 好友关系刚完成时，Gateway/接口响应可能早于好友快照收敛。
  /// 只在明确知道目标用户时做短暂有界重读，避免依赖用户手动下拉。
  Future<bool> refreshUntilContains(
    String friendUserId, {
    int maxAttempts = 3,
    Duration retryDelay = const Duration(milliseconds: 250),
  }) async {
    final normalizedUserId = friendUserId.trim();
    if (normalizedUserId.isEmpty || maxAttempts <= 0) {
      await refresh();
      return normalizedUserId.isEmpty;
    }
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      await refresh();
      final containsFriend = state.valueOrNull?.any(
            (friend) => friend.userId == normalizedUserId,
          ) ==
          true;
      if (containsFriend) return true;
      if (attempt + 1 < maxAttempts) await Future<void>.delayed(retryDelay);
    }
    return false;
  }
}

/// keepAlive：好友列表缓存，不随页面销毁（微信做法）
final friendsProvider =
    StateNotifierProvider<FriendsNotifier, AsyncValue<List<Contact>>>((ref) {
  // 好友列表是按空间隔离的数据。这里订阅当前空间，避免切换到个人空间时
  // 继续展示企业空间缓存的客服/官方账号，或旧请求返回后写回旧数据。
  ref.watch(accountRuntimeCurrentSpaceProvider);
  ref.keepAlive();
  return FriendsNotifier(ref);
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  contactsRepositoryProvider,
  contactsDirectoryLocalDataSourceProvider,
  accountAuthCacheManagerProvider,
]);

/// 当前空间好友中的客户联系人投影。
///
/// 这是现有 `/api/client/v1/friends` 能力的只读派生，不拥有第二份缓存，
/// 也不等同于客服分配关系。客服端在服务端尚未提供“当前分配客户”client
/// endpoint 前，只能展示这个可访问的客户联系人集合；管理员客户池必须走
/// admin customer-management 能力，不能复用此投影推算。
List<Contact> projectCustomerContacts(List<Contact> friends) =>
    friends.where((contact) => contact.isCustomer).toList(growable: false);

final customerContactsProvider = Provider<AsyncValue<List<Contact>>>((ref) {
  return ref.watch(friendsProvider).whenData(projectCustomerContacts);
}, dependencies: [friendsProvider]);

// ---------------------------------------------------------------------------
// Tenant members — 本地优先缓存，后台异步刷新
// ---------------------------------------------------------------------------

class TenantMembersNotifier extends StateNotifier<AsyncValue<List<Contact>>> {
  final Ref _ref;

  TenantMembersNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadWithCache();
  }

  bool _isStillCurrentIdentity(String spaceId, String userId) {
    if (!mounted) return false;
    final current = _ref.read(accountRuntimeCurrentSpaceProvider);
    return current?.spaceId == spaceId && current?.userId == userId;
  }

  Future<void> _loadWithCache() async {
    if (!mounted) return;
    final space = _ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null || space.accessToken.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    final cached = await _loadFromCache(space.spaceId, space.userId);
    if (cached != null) {
      if (!_isStillCurrentIdentity(space.spaceId, space.userId)) return;
      state = AsyncValue.data(cached);
      _syncFromRemote(space.spaceId, space.userId);
      return;
    }
    await _fetchAndCache(space.spaceId, space.userId);
  }

  Future<List<Contact>?> _loadFromCache(String spaceId, String userId) async {
    try {
      return _ref
          .read(contactsDirectoryLocalDataSourceProvider)
          .loadTenantMembers(spaceId, userId);
    } catch (error) {
      AppDiagnostics.instance.warning(
        'contacts.tenant_members.cache_read',
        'tenant member cache read failed before remote refresh',
        context: {
          'spaceId': spaceId,
          'errorType': error.runtimeType.toString(),
        },
      );
      return null;
    }
  }

  Future<void> _saveToCache(
      String spaceId, String userId, List<Contact> contacts) async {
    try {
      await _ref
          .read(contactsDirectoryLocalDataSourceProvider)
          .saveTenantMembers(spaceId, userId, contacts);
    } catch (error) {
      AppDiagnostics.instance.warning(
        'contacts.tenant_members.cache_write',
        'tenant member cache write failed after remote refresh',
        context: {
          'spaceId': spaceId,
          'errorType': error.runtimeType.toString(),
        },
      );
    }
  }

  Future<void> _fetchAndCache(String spaceId, String userId) async {
    if (!mounted) return;
    try {
      final repo = _ref.read(contactsRepositoryProvider);
      final members = await repo.getTenantMembers();
      if (!_isStillCurrentIdentity(spaceId, userId)) return;
      await _saveToCache(spaceId, userId, members);
      // 检查 provider 是否已被销毁
      if (!_isStillCurrentIdentity(spaceId, userId)) return;
      final current = state.valueOrNull;
      if (!FriendsNotifier._listEquals(current, members)) {
        state = AsyncValue.data(members);
      }
    } catch (e, st) {
      if (!_isStillCurrentIdentity(spaceId, userId)) return;
      // 403 TENANT_MEMBER_LIST_FORBIDDEN：客户无权访问，静默返回空列表
      // 401：token 过期，静默处理，不覆盖现有状态
      final isPermissionError = e is ServerError &&
          (e.code == 'TENANT_MEMBER_LIST_FORBIDDEN' || e.statusCode == 403);
      final isAuthError = e.toString().contains('401');
      if (isPermissionError) {
        state = const AsyncValue.data([]);
      } else if (!isAuthError && state.valueOrNull == null) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  void _syncFromRemote(String spaceId, String userId) {
    Future.microtask(() => _fetchAndCache(spaceId, userId));
  }

  Future<void> refresh() async {
    final space = _ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null) return;
    await _fetchAndCache(space.spaceId, space.userId);
  }
}

final tenantMembersProvider =
    StateNotifierProvider<TenantMembersNotifier, AsyncValue<List<Contact>>>(
        (ref) {
  // 企业成员列表也是空间级缓存；切换空间时必须重建，防止企业成员串到个人空间。
  ref.watch(accountRuntimeCurrentSpaceProvider);
  ref.keepAlive();
  return TenantMembersNotifier(ref);
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  contactsRepositoryProvider,
  contactsDirectoryLocalDataSourceProvider,
]);

// ---------------------------------------------------------------------------
// Department tree — 本地优先缓存，后台异步刷新
// ---------------------------------------------------------------------------

class DepartmentTreeNotifier
    extends StateNotifier<AsyncValue<List<Department>>> {
  final Ref _ref;

  DepartmentTreeNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadWithCache();
  }

  bool _isStillCurrentIdentity(String spaceId, String userId) {
    if (!mounted) return false;
    final current = _ref.read(accountRuntimeCurrentSpaceProvider);
    return current?.spaceId == spaceId && current?.userId == userId;
  }

  Future<void> _loadWithCache() async {
    if (!mounted) return;
    final space = _ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null || space.accessToken.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    final cached = await _loadFromCache(space.spaceId, space.userId);
    if (cached != null) {
      if (!_isStillCurrentIdentity(space.spaceId, space.userId)) return;
      state = AsyncValue.data(cached);
      _syncFromRemote(space.spaceId, space.userId);
      return;
    }
    await _fetchAndCache(space.spaceId, space.userId);
  }

  Future<List<Department>?> _loadFromCache(
      String spaceId, String userId) async {
    try {
      return _ref
          .read(contactsDirectoryLocalDataSourceProvider)
          .loadDepartmentTree(spaceId, userId);
    } catch (error) {
      AppDiagnostics.instance.warning(
        'contacts.department_tree.cache_read',
        'department cache read failed before remote refresh',
        context: {
          'spaceId': spaceId,
          'errorType': error.runtimeType.toString(),
        },
      );
      return null;
    }
  }

  Future<void> _saveToCache(
      String spaceId, String userId, List<Department> tree) async {
    try {
      await _ref
          .read(contactsDirectoryLocalDataSourceProvider)
          .saveDepartmentTree(spaceId, userId, tree);
    } catch (error) {
      AppDiagnostics.instance.warning(
        'contacts.department_tree.cache_write',
        'department cache write failed after remote refresh',
        context: {
          'spaceId': spaceId,
          'errorType': error.runtimeType.toString(),
        },
      );
    }
  }

  Future<void> _fetchAndCache(String spaceId, String userId) async {
    if (!mounted) return;
    try {
      final repo = _ref.read(contactsRepositoryProvider);
      final tree = await repo.getDepartmentTree();
      if (!_isStillCurrentIdentity(spaceId, userId)) return;
      await _saveToCache(spaceId, userId, tree);
      if (!_isStillCurrentIdentity(spaceId, userId)) return;
      state = AsyncValue.data(tree);
    } catch (e, st) {
      if (!_isStillCurrentIdentity(spaceId, userId)) return;
      if (state.valueOrNull == null) state = AsyncValue.error(e, st);
    }
  }

  void _syncFromRemote(String spaceId, String userId) {
    Future.microtask(() => _fetchAndCache(spaceId, userId));
  }

  Future<void> refresh() async {
    final space = _ref.read(accountRuntimeCurrentSpaceProvider);
    if (space == null) return;
    await _fetchAndCache(space.spaceId, space.userId);
  }
}

final departmentTreeProvider =
    StateNotifierProvider<DepartmentTreeNotifier, AsyncValue<List<Department>>>(
        (ref) {
  // 监听 Runtime 拥有的当前空间，切换时重建且不读旧账号缓存。
  ref.watch(accountRuntimeCurrentSpaceProvider);
  return DepartmentTreeNotifier(ref);
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  contactsRepositoryProvider,
  contactsDirectoryLocalDataSourceProvider,
]);

// ---------------------------------------------------------------------------
// Department members — 按 departmentId 缓存
// ---------------------------------------------------------------------------

final departmentMembersProvider =
    FutureProvider.family<List<DepartmentMember>, String>(
        (ref, departmentId) async {
  ref.keepAlive();
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || space.accessToken.isEmpty) return [];
  final repo = ref.watch(contactsRepositoryProvider);
  return repo.getDepartmentMembers(departmentId);
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  contactsRepositoryProvider,
]);

// ---------------------------------------------------------------------------
// User search — 搜索结果不缓存（每次输入都是新查询）
// ---------------------------------------------------------------------------

final userSearchProvider =
    FutureProvider.family<List<Contact>, String>((ref, keyword) async {
  if (keyword.trim().isEmpty) return [];
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || space.accessToken.isEmpty) return [];
  final repo = ref.watch(contactsRepositoryProvider);
  return repo.searchUsers(keyword);
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  contactsRepositoryProvider,
]);

// ---------------------------------------------------------------------------
// 待审批加入申请数量（员工端「新的申请」badge 动态化）
// ---------------------------------------------------------------------------

final pendingJoinRequestsCountProvider =
    FutureProvider.autoDispose<int>((ref) async {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || !space.isAdminOrAbove) return 0;
  try {
    final dio = ref.read(dioProvider);
    final resp = await dio.get<Map<String, dynamic>>(
      '/api/client/v1/tenant/join-requests',
    );
    final list = resp.data?['data'] as List<dynamic>? ?? [];
    // 只统计 pending 状态（status=0）
    return list.where((e) => (e as Map<String, dynamic>)['status'] == 0).length;
  } catch (_) {
    return 0;
  }
}, dependencies: [accountRuntimeCurrentSpaceProvider, dioProvider]);

// ---------------------------------------------------------------------------
// 客户端：获取分配给我的客服信息（用于「我的专属顾问」跳转）
// 从通讯录联系人中找到带客服标识的联系人
// ---------------------------------------------------------------------------

class AssignedStaffInfo {
  final String userId;
  final String displayName;
  final String? avatarUrl;

  const AssignedStaffInfo({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
  });
}

final assignedStaffProvider =
    FutureProvider.autoDispose<AssignedStaffInfo?>((ref) async {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || !space.isCustomer) return null;
  try {
    final dio = ref.read(dioProvider);
    final resp = await dio.get<Map<String, dynamic>>(
      '/api/client/v1/profile/me/assigned-staff',
    );
    final data = resp.data?['data'] as Map<String, dynamic>?;
    if (data == null) return null;
    final userId = data['userId'] as String?;
    if (userId == null || userId.isEmpty) return null;
    return AssignedStaffInfo(
      userId: userId,
      displayName: data['displayName'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String?,
    );
  } catch (_) {
    return null;
  }
}, dependencies: [accountRuntimeCurrentSpaceProvider, dioProvider]);

// ---------------------------------------------------------------------------
// 好友申请列表
// ---------------------------------------------------------------------------

final friendRequestsProvider =
    FutureProvider.autoDispose<List<FriendRequest>>((ref) async {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || space.accessToken.isEmpty) return [];
  final repo = ref.read(contactsRepositoryProvider);
  return repo.getFriendRequests();
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  contactsRepositoryProvider,
]);

// 待处理角标先由服务端过滤状态，再只展示当前账号收到的申请。
final pendingFriendRequestsProvider =
    FutureProvider.autoDispose<List<FriendRequest>>((ref) async {
  final space = ref.watch(accountRuntimeCurrentSpaceProvider);
  if (space == null || space.accessToken.isEmpty) return [];
  final repo = ref.read(contactsRepositoryProvider);
  final requests =
      await repo.getFriendRequests(status: FriendRequestStatus.pending);
  return requests
      .where((request) => request.isPendingIncomingFor(space.userId))
      .toList();
}, dependencies: [
  accountRuntimeCurrentSpaceProvider,
  contactsRepositoryProvider,
]);
