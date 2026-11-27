import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';

typedef GroupInvitationNotice = ({
  String spaceId,
  String conversationId,
  String messageId,
});

final groupInvitationNoticeProvider =
    NotifierProvider<GroupInvitationNoticeNotifier, GroupInvitationNotice?>(
  GroupInvitationNoticeNotifier.new,
  dependencies: [accountStorageContextProvider],
);

class GroupInvitationNoticeNotifier extends Notifier<GroupInvitationNotice?> {
  final _seen = <(String, String)>{};

  @override
  GroupInvitationNotice? build() {
    ref.watch(accountStorageContextProvider);
    _seen.clear();
    return null;
  }

  void receiveLiveMessage({
    required String spaceId,
    required String userId,
    required ConversationType type,
    required Message message,
  }) {
    final owner = ref.read(accountStorageContextProvider)?.scope;
    final messageId = message.messageId.trim();
    if (owner?.spaceId != spaceId ||
        owner?.userId != userId ||
        type != ConversationType.group ||
        messageId.isEmpty ||
        message.type != MessageType.event ||
        message.isRecalled ||
        message.body.eventData?.addsUser(userId.trim()) != true ||
        !_seen.add((message.conversationId, messageId))) {
      return;
    }
    state = (
      spaceId: spaceId,
      conversationId: message.conversationId,
      messageId: messageId,
    );
  }
}
