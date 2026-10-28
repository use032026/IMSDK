import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/app/account_runtime_provider.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/features/app_update/presentation/app_update_provider.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/chat/application/services/conversation_type_resolver.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/conversation_type_remote_data_source.dart';

export 'package:im_sdk/features/chat/application/services/conversation_type_resolver.dart';

/// Safe to read from the root router as well as an authenticated search page.
/// The active runtime is the owner of storage; no root chat provider is started.
final conversationTypeResolverProvider =
    Provider<ConversationTypeResolver>((ref) {
  var disposed = false;
  ref.onDispose(() => disposed = true);
  return ConversationTypeResolver(
    groupFeaturesBlocked: () =>
        !disposed && ref.read(appUpdateGroupFeaturesBlockedProvider),
    currentRuntime: () {
      if (disposed) return null;
      final runtime = ref.read(activeAccountRuntimeProvider);
      return runtime?.storageContext == null ? null : runtime;
    },
    currentSession: () =>
        disposed ? null : ref.read(activeAccountSessionProvider),
    currentSpace: () => disposed ? null : ref.read(currentSpaceProvider),
    readLocalTypes: (runtime, spaceId, ids) {
      final storage = runtime.storageContext!;
      return ChatLocalDataSourceImpl(
        databaseProvider: (_) async => storage.database,
        databaseDeleter: (_) => throw UnsupportedError(
          'Conversation type lookups cannot delete account storage',
        ),
        writeGate: storage.writeGate,
        operationContext: storage.operationContext,
      ).getConversationTypes(spaceId, ids);
    },
    readDirectConversation: (id, token, timeout) =>
        ConversationTypeRemoteDataSource(
      ref.read(dioProvider),
    ).isDirectConversation(id, token, timeout: timeout),
  );
}, dependencies: [dioProvider]);
