import 'package:hive/hive.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/runtime/account_write_gate.dart';
import 'package:im_sdk/features/chat/data/datasources/gateway_service.dart';

class ChatSyncCursorStore {
  const ChatSyncCursorStore({
    required Box<dynamic> accountBox,
    AccountWriteGate? writeGate,
    AccountOperationContext? operationContext,
  })  : _accountBox = accountBox,
        _writeGate = writeGate,
        _operationContext = operationContext;

  final Box<dynamic> _accountBox;
  final AccountWriteGate? _writeGate;
  final AccountOperationContext? _operationContext;

  Box<dynamic> get _box => _accountBox;

  int? read({required String spaceId, required String userId}) {
    return _box.get(
      syncCursorStorageKey(spaceId: spaceId, userId: userId),
    ) as int?;
  }

  Future<void> write({
    required String spaceId,
    required String userId,
    required int sinceSeq,
  }) {
    Future<void> action() => _box.put(
          syncCursorStorageKey(spaceId: spaceId, userId: userId),
          sinceSeq,
        );
    final gate = _writeGate;
    final context = _operationContext;
    return gate == null || context == null
        ? action()
        : gate.run(context, action);
  }
}
