import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';

final chatDraftProvider =
    FutureProvider.family<String?, (String, String, String)>((ref, args) {
  final (spaceId, userId, conversationId) = args;
  if (spaceId.isEmpty || userId.isEmpty || conversationId.isEmpty) {
    return Future<String?>.value();
  }
  return ref.read(chatDraftLocalStoreProvider).readDraft(
        spaceId: spaceId,
        userId: userId,
        conversationId: conversationId,
      );
}, dependencies: [chatDraftLocalStoreProvider]);
