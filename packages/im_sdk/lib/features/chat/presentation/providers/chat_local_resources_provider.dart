import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/storage/account_storage_context.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_draft_local_store.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_sync_cursor_store.dart';
import 'package:im_sdk/features/chat/data/datasources/conversation_deletion_boundary_store.dart';
import 'package:im_sdk/features/chat/data/datasources/media_local_store.dart';
import 'package:im_sdk/features/chat/data/datasources/pending_message_queue.dart';

final conversationDeletionBoundaryStoreProvider =
    Provider<ConversationDeletionBoundaryStore>((ref) {
  final storage = _requireAccountStorage(ref);
  return ConversationDeletionBoundaryStore(
    databaseProvider: (_) async => storage.database,
  );
}, dependencies: [accountStorageContextProvider]);

final chatLocalDataSourceProvider = Provider<ChatLocalDataSourceImpl>((ref) {
  final storage = _requireAccountStorage(ref);
  return ChatLocalDataSourceImpl(
    databaseProvider: (_) async => storage.database,
    databaseDeleter: (_) => throw UnsupportedError(
      'An active account store is retired by AccountRuntime, not a datasource',
    ),
    writeGate: storage.writeGate,
    operationContext: storage.operationContext,
  );
}, dependencies: [accountStorageContextProvider]);

final chatDraftLocalStoreProvider = Provider<ChatDraftLocalStore>((ref) {
  final storage = _requireAccountStorage(ref);
  return ChatDraftLocalStore(
    accountBox: storage.accountBox,
    deletionBoundaries: ref.watch(conversationDeletionBoundaryStoreProvider),
    writeGate: storage.writeGate,
    operationContext: storage.operationContext,
  );
}, dependencies: [
  accountStorageContextProvider,
  conversationDeletionBoundaryStoreProvider,
]);

final pendingMessageQueueProvider = Provider<PendingMessageQueue>((ref) {
  final storage = _requireAccountStorage(ref);
  final boundaries = ref.watch(conversationDeletionBoundaryStoreProvider);
  return PendingMessageQueue(
    accountBox: storage.accountBox,
    deletionBoundaryReader: boundaries.readExplicitDeletedAt,
    writeGate: storage.writeGate,
    operationContext: storage.operationContext,
  );
}, dependencies: [
  accountStorageContextProvider,
  conversationDeletionBoundaryStoreProvider,
]);

final chatSyncCursorStoreProvider = Provider<ChatSyncCursorStore>((ref) {
  final storage = _requireAccountStorage(ref);
  return ChatSyncCursorStore(
    accountBox: storage.accountBox,
    writeGate: storage.writeGate,
    operationContext: storage.operationContext,
  );
}, dependencies: [accountStorageContextProvider]);

final mediaLocalStoreProvider = Provider<MediaLocalStore>((ref) {
  final storage = _requireAccountStorage(ref);
  return MediaLocalStore(
    databaseProvider: (_) async => storage.database,
    writeGate: storage.writeGate,
    operationContext: storage.operationContext,
  );
}, dependencies: [accountStorageContextProvider]);

AccountStorageContext _requireAccountStorage(Ref ref) {
  final storage = ref.watch(accountStorageContextProvider);
  if (storage == null) {
    throw StateError(
        'Authenticated chat storage requires an active account runtime');
  }
  return storage;
}
