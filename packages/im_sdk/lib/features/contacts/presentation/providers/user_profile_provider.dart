import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/storage/account_profile_box_provider.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/contacts/data/models/user_profile.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
export 'package:im_sdk/features/contacts/data/models/user_profile.dart';

// ---------------------------------------------------------------------------
// Provider — 本地优先缓存，后台异步刷新
// ---------------------------------------------------------------------------

const _kUserProfileCachePrefix = 'user_profile_';

class UserProfileNotifier extends FamilyAsyncNotifier<UserProfile, String> {
  int _revision = 0;

  @override
  Future<UserProfile> build(String arg) async {
    final revision = ++_revision;
    ref.onDispose(() => _revision++);
    final space = ref.watch(accountRuntimeCurrentSpaceProvider);
    if (space == null) {
      return UserProfile(userId: arg, name: '用户', bubbleId: arg);
    }

    // 1. 先读本地缓存，立即显示（只有有头像的缓存才用）
    final cached = await _loadFromCache(space.spaceId, arg);
    if (!_isCurrent(revision, space.spaceId, space.userId)) {
      throw StateError('Profile identity changed');
    }
    if (cached != null &&
        (cached.avatarUrl != null || cached.officialAccount != null)) {
      state = AsyncData(cached);
      // 2. 后台静默刷新
      _syncFromRemote(space.spaceId, arg, revision, space.userId);
      return cached;
    }

    // 3. 无缓存或缓存无头像：走网络获取完整数据
    return _fetchAndCache(space.spaceId, arg, revision, space.userId);
  }

  bool _isCurrent(int revision, String spaceId, String ownerUserId) {
    if (_revision != revision) return false;
    final space = ref.read(accountRuntimeCurrentSpaceProvider);
    return space?.spaceId == spaceId && space?.userId == ownerUserId;
  }

  Future<UserProfile?> _loadFromCache(String spaceId, String userId) async {
    try {
      final box = await ref.read(accountProfileBoxResolverProvider)(spaceId);
      final raw = box.get('$_kUserProfileCachePrefix$userId');
      if (raw == null) return null;
      final m = jsonDecode(raw as String) as Map<String, dynamic>;
      return UserProfile.fromJson({...m, 'userId': m['userId'] ?? userId});
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToCache(String spaceId, UserProfile p,
      {bool Function()? isCurrent}) async {
    try {
      final box = await ref.read(accountProfileBoxResolverProvider)(spaceId);
      if (isCurrent != null && !isCurrent()) return;
      await box.put(
          '$_kUserProfileCachePrefix${p.userId}', jsonEncode(p.toCache()));
    } catch (_) {}
  }

  Future<UserProfile> _fetchAndCache(
      String spaceId, String userId, int revision, String ownerUserId) async {
    void checkIdentity() {
      if (!_isCurrent(revision, spaceId, ownerUserId)) {
        throw StateError('Profile identity changed');
      }
    }

    checkIdentity();
    final dio = ref.read(dioProvider);
    Map<String, dynamic> data;
    try {
      final resp = await dio.get('/api/client/v1/users/$userId/profile');
      data = resp.data['data'] as Map<String, dynamic>;
    } catch (_) {
      checkIdentity();
      final fallback = _profileFromContacts(userId);
      if (fallback != null) return fallback;
      rethrow;
    }
    checkIdentity();

    String? avatarUrl = data['avatarUrl'] as String?;
    if (avatarUrl?.isEmpty == true) avatarUrl = null;

    final profile = UserProfile.fromJson({
      ...data,
      'userId': data['userId'] ?? userId,
      'avatarUrl': avatarUrl,
      'gender': _genderLabel(data['gender'] as String?),
    });
    await _saveToCache(spaceId, profile,
        isCurrent: () => _isCurrent(revision, spaceId, ownerUserId));
    checkIdentity();
    return profile;
  }

  UserProfile? _profileFromContacts(String userId) {
    final contacts = [
      ...?ref.read(tenantMembersProvider).valueOrNull,
      ...?ref.read(friendsProvider).valueOrNull,
    ];
    for (final contact in contacts) {
      if (contact.userId != userId) continue;
      return UserProfile(
        userId: contact.userId,
        name: contact.displayName,
        avatarUrl: contact.avatarUrl,
        bubbleId: contact.userId,
        isFriend: true,
        userType: contact.isCustomer ? 1 : 2,
        officialAccount: contact.officialAccount,
      );
    }
    return null;
  }

  void _syncFromRemote(
      String spaceId, String userId, int revision, String ownerUserId) {
    Future.microtask(() async {
      try {
        final fresh =
            await _fetchAndCache(spaceId, userId, revision, ownerUserId);
        state = AsyncData(fresh);
      } catch (_) {}
    });
  }

  Future<void> updateRemark(String remarkName) async {
    final space = ref.read(currentSpaceProvider);
    if (space == null) return;
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = UserProfile(
      userId: current.userId,
      name: current.name,
      avatarUrl: current.avatarUrl,
      bubbleId: current.bubbleId,
      gender: current.gender,
      region: current.region,
      signature: current.signature,
      mobile: current.mobile,
      tags: current.tags,
      remarkName: remarkName,
      isFriend: current.isFriend,
      userType: current.userType,
      isOfficial: current.isOfficial,
      officialAccount: current.officialAccount,
    );
    state = AsyncData(updated);
    await _saveToCache(space.spaceId, updated);
  }
}

final userProfileProvider =
    AsyncNotifierProvider.family<UserProfileNotifier, UserProfile, String>(
  UserProfileNotifier.new,
  dependencies: [
    dioProvider,
    accountProfileBoxResolverProvider,
    friendsProvider,
    tenantMembersProvider,
    accountRuntimeCurrentSpaceProvider,
  ],
);

String? _genderLabel(String? gender) {
  switch (gender) {
    case 'male':
      return '男';
    case 'female':
      return '女';
    case 'other':
      return '其他';
    default:
      return null;
  }
}
