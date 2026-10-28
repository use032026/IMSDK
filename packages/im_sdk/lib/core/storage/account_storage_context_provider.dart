import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/core/space/space_manager.dart';
import 'package:im_sdk/core/storage/account_storage_context.dart';

/// The active account runtime overrides this provider. A null value preserves
/// the legacy production assembly until the atomic runtime cutover.
final accountStorageContextProvider = Provider<AccountStorageContext?>(
  (_) => null,
);

/// Root authentication projection for the currently committed Session.
/// AuthNotifier remains the only writer; account runtimes only compare it with
/// the immutable operation context captured when their storage was opened.
final currentAccountOperationContextProvider =
    NotifierProvider<CurrentAccountOperationContext, AccountOperationContext?>(
  CurrentAccountOperationContext.new,
);

class CurrentAccountOperationContext
    extends Notifier<AccountOperationContext?> {
  @override
  AccountOperationContext? build() => null;

  void setContext(AccountOperationContext context) => state = context;

  void clear() => state = null;
}

/// The current space only when it belongs to the AccountRuntime that owns the
/// active storage handle.
///
/// During an account/space transition the root identity is published before a
/// new scoped widget tree can be mounted. The retiring ProviderScope may
/// therefore observe the next identity for one frame. Account-owned data and
/// runtime services must consume this projection instead of the root space so
/// they cannot read a retired database, reuse an old cache, or connect an old
/// transport with the next account token.
final accountRuntimeCurrentSpaceProvider = Provider<SpaceContext?>((ref) {
  final space = ref.watch(currentSpaceProvider);
  final storage = ref.watch(accountStorageContextProvider);
  if (storage == null) return space;
  final activeOperation = ref.watch(currentAccountOperationContextProvider);
  final runtimeOperation = storage.operationContext;
  if (activeOperation == null ||
      activeOperation.accountScopeKey != runtimeOperation.accountScopeKey ||
      activeOperation.identityRevision != runtimeOperation.identityRevision ||
      activeOperation.sessionId != runtimeOperation.sessionId) {
    return null;
  }
  return storage.scope.ownsSpace(space) ? space : null;
}, dependencies: [
  currentSpaceProvider,
  currentAccountOperationContextProvider,
  accountStorageContextProvider,
]);
