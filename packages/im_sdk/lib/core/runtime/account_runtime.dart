import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/auth/account_session.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/runtime/account_write_gate.dart';
import 'package:im_sdk/core/storage/account_settings_box_provider.dart';
import 'package:im_sdk/core/storage/account_storage_context.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';

enum AccountRuntimeLifecycle { dormant, active, retiring, retired }

class AccountRuntimeStateError implements Exception {
  const AccountRuntimeStateError(this.message);
  final String message;
}

class AccountRuntime {
  AccountRuntime({
    required this.session,
    List<Override> providerOverrides = const [],
    AccountStorageContext? accountStorageContext,
    AccountWriteGate? writeGate,
    Future<void> Function()? onActivate,
    Future<void> Function()? onRetired,
  })  : storageContext = accountStorageContext,
        providerOverrides = List.unmodifiable([
          if (accountStorageContext != null)
            accountStorageContextProvider.overrideWithValue(
              accountStorageContext,
            ),
          if (accountStorageContext != null)
            accountSettingsBoxProvider.overrideWithValue(
              accountStorageContext.settingsBox,
            ),
          ...providerOverrides,
        ]),
        _onActivate = onActivate,
        _onRetired = _composeRetirement(accountStorageContext, onRetired),
        operationContext = AccountOperationContext(
          accountScopeKey: session.scope.scopeKey,
          identityRevision: session.identityRevision,
          sessionId: session.sessionId,
        ) {
    this.writeGate = writeGate ??
        accountStorageContext?.writeGate ??
        ScopedAccountWriteGate(operationContext);
  }

  final AccountSession session;
  final List<Override> providerOverrides;
  final AccountStorageContext? storageContext;
  final Future<void> Function()? _onActivate;
  final Future<void> Function()? _onRetired;
  final AccountOperationContext operationContext;
  late final AccountWriteGate writeGate;
  AccountRuntimeLifecycle _lifecycle = AccountRuntimeLifecycle.dormant;
  final Map<Object, Object?> _memoryCache = <Object, Object?>{};

  AccountRuntimeLifecycle get lifecycle => _lifecycle;

  T? readMemory<T>(Object key) => _lifecycle == AccountRuntimeLifecycle.active
      ? _memoryCache[key] as T?
      : null;

  void writeMemory(Object key, Object? value) {
    if (_lifecycle != AccountRuntimeLifecycle.active) {
      throw const AccountRuntimeStateError('runtime cache is not active');
    }
    _memoryCache[key] = value;
  }

  Future<void> activate() async {
    if (_lifecycle != AccountRuntimeLifecycle.dormant) {
      throw const AccountRuntimeStateError(
          'only a dormant runtime can be activated');
    }
    await _onActivate?.call();
    _lifecycle = AccountRuntimeLifecycle.active;
  }

  Future<void> retire({Duration timeout = const Duration(seconds: 10)}) async {
    if (_lifecycle == AccountRuntimeLifecycle.retired) return;
    if (_lifecycle == AccountRuntimeLifecycle.retiring) {
      await writeGate.retire(timeout: timeout);
    } else {
      _lifecycle = AccountRuntimeLifecycle.retiring;
      await writeGate.retire(timeout: timeout);
    }
    try {
      await _onRetired?.call();
    } finally {
      _memoryCache.clear();
      _lifecycle = AccountRuntimeLifecycle.retired;
    }
  }
}

Future<void> Function()? _composeRetirement(
  AccountStorageContext? storageContext,
  Future<void> Function()? callback,
) {
  if (storageContext == null) return callback;
  return () async {
    try {
      await callback?.call();
    } finally {
      await storageContext.release();
    }
  };
}
