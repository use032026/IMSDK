import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/media/media_request_context.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_media_message_refresher.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';
import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';
import 'package:im_sdk/features/customer_service/domain/customer_service_role_capabilities.dart';
import 'package:im_sdk/features/customer_service/presentation/providers/customer_service_providers.dart';

final chatMediaUrlRefreshProvider = Provider<MediaUrlRefresh>((ref) {
  final storage = ref.watch(accountStorageContextProvider);
  ref.watch(accountRuntimeCurrentSpaceProvider.select(
    (space) => (space?.spaceId, space?.userId, space?.membershipRole),
  ));
  final space = ref.read(accountRuntimeCurrentSpaceProvider);
  if (storage == null || !storage.scope.ownsSpace(space)) {
    return (_, __) async => null;
  }
  var active = true;
  ref.onDispose(() => active = false);
  final refresher = ChatMediaMessageRefresher(
    spaceId: storage.scope.spaceId,
    local: ref.watch(chatLocalDataSourceProvider),
    remote: ChatRemoteDataSourceImpl(ref.watch(dioProvider)),
    customerService: ref.watch(customerServiceRepositoryProvider),
    threadForConversation: (conversationId) =>
        _threadForConversation(ref, conversationId),
    isCurrent: () =>
        active &&
        identical(ref.read(accountStorageContextProvider), storage) &&
        storage.scope.ownsSpace(ref.read(accountRuntimeCurrentSpaceProvider)),
  );
  return refresher.refresh;
}, dependencies: [
  accountStorageContextProvider,
  accountRuntimeCurrentSpaceProvider,
  chatLocalDataSourceProvider,
  dioProvider,
  customerServiceRepositoryProvider,
  customerServiceThreadsProvider,
  customerServiceThreadIdentityIndexProvider,
]);

CsThread? _threadForConversation(Ref ref, String conversationId) {
  final space = ref.read(accountRuntimeCurrentSpaceProvider);
  if (space == null ||
      !customerServiceRoleCapabilities(membershipRole: space.membershipRole)
          .canUseStaffEndpoints) {
    return null;
  }
  final data = ref.read(customerServiceThreadsProvider).valueOrNull;
  for (final thread in [...?data?.queueItems, ...?data?.activeItems]) {
    if (thread.conversationId == conversationId && thread.threadId.isNotEmpty) {
      return thread;
    }
  }
  final index = ref.read(customerServiceThreadIdentityIndexProvider(
      customerServiceReminderScopeKey(
          spaceId: space.spaceId, userId: space.userId)));
  for (final identity in index.identities.reversed) {
    if (identity.conversationId != conversationId ||
        identity.threadId.isEmpty) {
      continue;
    }
    return CsThread(
        threadType: identity.threadType,
        threadId: identity.threadId,
        conversationId: identity.conversationId,
        handoffMode: identity.handoffMode ?? 'separate_dm',
        officialUserId: identity.officialUserId,
        assignedStaffUserId: identity.assignedStaffUserId,
        status: 'active',
        title: '');
  }
  return null;
}
