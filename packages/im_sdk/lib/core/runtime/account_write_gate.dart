import 'dart:async';

import 'package:im_sdk/core/runtime/account_operation_guard.dart';

abstract interface class AccountWriteGate {
  Future<T> run<T>(
    AccountOperationContext context,
    Future<T> Function() write,
  );
  Future<void> retire({Duration timeout = const Duration(seconds: 10)});
}

class AccountWriteRejected implements Exception {}

class AccountRuntimeRetireTimeout implements Exception {}

class ScopedAccountWriteGate implements AccountWriteGate {
  ScopedAccountWriteGate(AccountOperationContext context)
      : _guard = AccountOperationGuard(context);

  final AccountOperationGuard _guard;
  var _retiring = false;
  var _retired = false;
  var _activeWrites = 0;
  Completer<void>? _drained;

  bool get isRetiring => _retiring;
  bool get isRetired => _retired;
  int get activeWrites => _activeWrites;

  @override
  Future<T> run<T>(
    AccountOperationContext context,
    Future<T> Function() write,
  ) async {
    if (_retiring || _retired) throw AccountWriteRejected();
    _guard.verify(context);
    _activeWrites += 1;
    try {
      return await write();
    } finally {
      _activeWrites -= 1;
      if (_activeWrites == 0 && _retiring) {
        _drained?.complete();
        _drained = null;
      }
    }
  }

  @override
  Future<void> retire({Duration timeout = const Duration(seconds: 10)}) async {
    if (_retired) return;
    _retiring = true;
    if (_activeWrites > 0) {
      _drained ??= Completer<void>();
      try {
        await _drained!.future.timeout(timeout);
      } on TimeoutException {
        throw AccountRuntimeRetireTimeout();
      }
    }
    _retired = true;
  }
}
