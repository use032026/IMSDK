import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/contacts/application/friend_acceptance_conversation_service.dart';
import 'package:im_sdk/features/contacts/data/services/friend_acceptance_conversation_adapters.dart';

final friendAcceptanceConversationServiceProvider =
    Provider<FriendAcceptanceConversationService>((ref) {
  return FriendAcceptanceConversationService(
    gateway: DioFriendAcceptanceConversationGateway(ref.watch(dioProvider)),
    store: ChatLocalFriendAcceptanceConversationStore(
      ref.watch(chatLocalDataSourceProvider),
    ),
  );
}, dependencies: [dioProvider, chatLocalDataSourceProvider]);

Future<void> ensureFriendAcceptanceConversation(
  WidgetRef ref,
  FriendAcceptanceConversationDraft draft,
) async {
  await _ensureFriendAcceptanceConversation(
    space: ref.read(accountRuntimeCurrentSpaceProvider),
    service: ref.read(friendAcceptanceConversationServiceProvider),
    invalidateConversationState: (spaceId, conversationId) {
      ref.invalidate(conversationsProvider(spaceId));
      ref.invalidate(chatProvider((spaceId, conversationId, false)));
    },
    draft: draft,
  );
}

Future<void> ensureFriendAcceptanceConversationFromProvider(
  Ref ref,
  FriendAcceptanceConversationDraft draft, {
  String? expectedSpaceId,
  String? expectedUserId,
}) async {
  final space = ref.read(accountRuntimeCurrentSpaceProvider);
  if (expectedSpaceId != null && space?.spaceId != expectedSpaceId) return;
  if (expectedUserId != null && space?.userId != expectedUserId) return;
  await _ensureFriendAcceptanceConversation(
    space: space,
    service: ref.read(friendAcceptanceConversationServiceProvider),
    invalidateConversationState: (spaceId, conversationId) {
      ref.invalidate(conversationsProvider(spaceId));
      ref.invalidate(chatProvider((spaceId, conversationId, false)));
    },
    draft: draft,
  );
}

Future<void> _ensureFriendAcceptanceConversation({
  required SpaceContext? space,
  required FriendAcceptanceConversationService service,
  required void Function(String spaceId, String conversationId)
      invalidateConversationState,
  required FriendAcceptanceConversationDraft draft,
}) async {
  if (space == null) return;

  final result = await service.ensureConversation(
    spaceId: space.spaceId,
    currentUserId: space.userId,
    draft: draft,
  );
  if (result == null) return;

  invalidateConversationState(space.spaceId, result.conversationId);
}
