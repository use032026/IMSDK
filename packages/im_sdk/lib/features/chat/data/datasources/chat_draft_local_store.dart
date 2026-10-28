import 'package:im_sdk/features/chat/data/datasources/conversation_deletion_boundary_store.dart';
import 'package:hive/hive.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/runtime/account_write_gate.dart';

class ChatDraftLocalStore {
  const ChatDraftLocalStore({
    required Box<dynamic> accountBox,
    required ConversationDeletionBoundaryStore deletionBoundaries,
    AccountWriteGate? writeGate,
    AccountOperationContext? operationContext,
  })  : _accountBox = accountBox,
        _deletionBoundaries = deletionBoundaries,
        _writeGate = writeGate,
        _operationContext = operationContext;

  final Box<dynamic> _accountBox;
  final ConversationDeletionBoundaryStore _deletionBoundaries;
  final AccountWriteGate? _writeGate;
  final AccountOperationContext? _operationContext;

  Future<T> _write<T>(Future<T> Function() action) {
    final gate = _writeGate;
    final context = _operationContext;
    return gate == null || context == null
        ? action()
        : gate.run(context, action);
  }

  Future<Box<dynamic>> _box(String spaceId) async => _accountBox;

  Future<void> saveDraft({
    required String spaceId,
    required String userId,
    required String conversationId,
    required String text,
  }) async {
    await _write(() async {
      final box = await _box(spaceId);
      final key = _key(userId: userId, conversationId: conversationId);
      await box.put(
        key,
        {
          'conversationId': conversationId,
          'userId': userId,
          // An explicit empty draft must outrank an older server snapshot.
          'draftText': text.trim().isEmpty ? '' : text,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    });
  }

  Future<String?> readDraft({
    required String spaceId,
    required String userId,
    required String conversationId,
  }) async {
    final box = await _box(spaceId);
    final raw = box.get(_key(userId: userId, conversationId: conversationId));
    if (raw is Map) {
      final text = raw['draftText']?.toString();
      if (text == null) return null;
      final deletedAt = await _deletionBoundaries.readExplicitDeletedAt(
        spaceId,
        conversationId,
      );
      if (deletedAt == null) return text;
      final updatedAt = DateTime.tryParse(raw['updatedAt']?.toString() ?? '');
      return updatedAt != null && !updatedAt.isBefore(deletedAt) ? text : null;
    }
    if (raw is String && raw.trim().isNotEmpty) {
      final deletedAt = await _deletionBoundaries.readExplicitDeletedAt(
        spaceId,
        conversationId,
      );
      return deletedAt == null ? raw : null;
    }
    return null;
  }

  static String _key({
    required String userId,
    required String conversationId,
  }) {
    return '$userId:$conversationId';
  }
}
