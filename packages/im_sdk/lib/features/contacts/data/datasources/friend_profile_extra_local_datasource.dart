import 'dart:convert';

import 'package:im_sdk/core/storage/account_profile_box_provider.dart';
import 'package:im_sdk/features/contacts/domain/entities/friend_profile_extra.dart';

class FriendProfileExtraLocalDataSource {
  static const _keyPrefix = 'friend_profile_extra_';
  static const _scopedKeyPrefix = 'friend_profile_extra_v2_';

  FriendProfileExtraLocalDataSource({
    required AccountProfileBoxResolver profileBoxResolver,
  }) : _profileBoxResolver = profileBoxResolver;

  final AccountProfileBoxResolver _profileBoxResolver;

  Future<FriendProfileExtra?> load(
    String spaceId,
    String friendUserId, {
    required String ownerUserId,
  }) async {
    try {
      final box = await _profileBoxResolver(spaceId);
      await box.delete('$_keyPrefix$friendUserId');
      final raw = box.get(_key(ownerUserId, friendUserId));
      if (raw is! String) return null;
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return FriendProfileExtra(
        friendUserId: friendUserId,
        remarkName: _text(map['remarkName']),
        tags: _strings(map['tags']),
        note: _text(map['note']),
        mobile: _nullableText(map['mobile'] ?? map['phone']),
        gender: normalizeFriendGender(map['gender']),
        remarkGender: normalizeFriendGender(map['remarkGender']),
        remarkGenderProvided: map['remarkGenderProvided'] == true,
        region: _nullableText(map['region']),
        signature: _nullableText(map['signature']),
        source: _nullableText(map['source']),
        addedAt: _nullableText(map['addedAt']),
        commonGroupCount: map['commonGroupCount'] as int? ?? 0,
        syncedAt: DateTime.tryParse(_text(map['syncedAt'])),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> save(
    String spaceId,
    FriendProfileExtra profile, {
    required String ownerUserId,
  }) async {
    final box = await _profileBoxResolver(spaceId);
    await box.put(
      _key(ownerUserId, profile.friendUserId),
      jsonEncode({
        'remarkName': profile.remarkName,
        'tags': profile.tags,
        'note': profile.note,
        'mobile': profile.mobile,
        'gender': profile.gender,
        'remarkGender': profile.remarkGender,
        'remarkGenderProvided': profile.remarkGenderProvided,
        'region': profile.region,
        'signature': profile.signature,
        'source': profile.source,
        'addedAt': profile.addedAt,
        'commonGroupCount': profile.commonGroupCount,
        'syncedAt': (profile.syncedAt ?? DateTime.now()).toIso8601String(),
      }),
    );
  }

  Future<void> delete(
    String spaceId,
    String friendUserId, {
    required String ownerUserId,
  }) async {
    final box = await _profileBoxResolver(spaceId);
    await box.delete(_key(ownerUserId, friendUserId));
    await box.delete('$_keyPrefix$friendUserId');
  }

  String _key(String ownerUserId, String friendUserId) =>
      '$_scopedKeyPrefix${_safe(ownerUserId)}_${_safe(friendUserId)}';

  String _safe(String value) =>
      value.trim().replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
}

String _text(Object? value) => value?.toString().trim() ?? '';

String? _nullableText(Object? value) {
  final text = _text(value);
  return text.isEmpty ? null : text;
}

List<String> _strings(Object? value) {
  if (value is! List) return const [];
  return value
      .map(_text)
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
}
