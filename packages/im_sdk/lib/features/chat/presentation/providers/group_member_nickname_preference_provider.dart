import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/storage/account_settings_box_provider.dart';

const _groupMemberNicknamePreferencePrefix = 'group_member_nickname_visible';

String groupMemberNicknamePreferenceScopeKey({
  required String spaceId,
  required String conversationId,
}) {
  return '${spaceId.trim()}:${conversationId.trim()}';
}

class GroupMemberNicknamePreferenceNotifier
    extends FamilyNotifier<bool, String> {
  @override
  bool build(String arg) {
    final stored = ref.watch(accountSettingsBoxProvider).get(_key(arg));
    return stored is bool ? stored : true;
  }

  Future<void> setEnabled(bool enabled) async {
    final previous = state;
    state = enabled;
    try {
      await ref.read(accountSettingsBoxProvider).put(_key(arg), enabled);
    } catch (_) {
      state = previous;
      rethrow;
    }
  }

  String _key(String scopeKey) {
    return '$_groupMemberNicknamePreferencePrefix:${scopeKey.trim()}';
  }
}

final groupMemberNicknamePreferenceProvider = NotifierProvider.family<
    GroupMemberNicknamePreferenceNotifier, bool, String>(
  GroupMemberNicknamePreferenceNotifier.new,
  dependencies: [accountSettingsBoxProvider],
);
