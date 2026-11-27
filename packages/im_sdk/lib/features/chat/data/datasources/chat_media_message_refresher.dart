import 'package:dio/dio.dart';
import 'package:im_sdk/core/media/media_request_context.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';
import 'package:im_sdk/features/customer_service/data/repositories/customer_service_repository.dart';

/// Renews a media lease through the message's existing route and local owner.
/// In-flight work is shared; the message and its access links remain in SQLite.
class ChatMediaMessageRefresher {
  ChatMediaMessageRefresher({
    required this.spaceId,
    required this.local,
    required this.remote,
    required this.isCurrent,
    this.threadForConversation,
    this.customerService,
  });

  final String spaceId;
  final ChatLocalDataSourceImpl local;
  final ChatRemoteDataSource remote;
  final bool Function() isCurrent;
  final CsThread? Function(String conversationId)? threadForConversation;
  final CustomerServiceRepository? customerService;
  final _inFlight = <(String, String), Future<Message?>>{};

  Future<String?> refresh(MediaRequestContext context, String failedUrl) async {
    _verifyCurrent();
    if (context.conversationId.isEmpty ||
        context.messageId.isEmpty ||
        !const ['image', 'video', 'voice', 'file'].contains(context.kind)) {
      return null;
    }
    final key = (context.conversationId, context.messageId);
    final existing = _inFlight[key];
    final future = existing ?? _refreshMessage(context);
    if (existing == null) _inFlight[key] = future;
    try {
      final message = await future;
      _verifyCurrent();
      if (message == null) return null;
      final resource = switch (context.kind) {
        'image' => message.body.image,
        'video' => message.body.video,
        'voice' => message.body.voice,
        'file' => message.body.file,
        _ => null,
      };
      if (resource == null) throw const MediaAccessDenied();
      if (context.variant == 'videoPoster') return resource.thumbnailUrl;
      return context.download
          ? resource.downloadSourceUrl
          : resource.displayUrl;
    } on CredentialRenewalError catch (error) {
      if (const [401, 403, 404].contains(error.statusCode)) {
        throw const MediaAccessDenied();
      }
      rethrow;
    } on ServerError catch (error) {
      if (const [401, 403, 404].contains(error.statusCode)) {
        throw const MediaAccessDenied();
      }
      rethrow;
    } on DioException catch (error) {
      if (const [401, 403, 404].contains(error.response?.statusCode)) {
        throw const MediaAccessDenied();
      }
      rethrow;
    } finally {
      if (identical(_inFlight[key], future)) _inFlight.remove(key);
    }
  }

  Future<Message?> _refreshMessage(MediaRequestContext context) async {
    if (!await local.isConversationDirectoryVisible(
        spaceId, context.conversationId)) {
      throw const MediaAccessDenied();
    }
    _verifyCurrent();
    final deletion = await local.getConversationDeletionState(
        spaceId, context.conversationId);
    _verifyCurrent();
    var sequence = context.conversationSeq;
    if (sequence <= 0) {
      final cached = await local.getMessageForMediaAccess(
          spaceId, context.conversationId, context.messageId);
      _verifyCurrent();
      if (cached != null &&
          (cached.isRecalled || !cached.status.isServerUsable)) {
        throw const MediaAccessDenied();
      }
      sequence = cached?.conversationSeq ?? 0;
      if (sequence <= 0) {
        if (deletion.deletedThroughSeq != null ||
            deletion.explicitDeletedAt != null) {
          throw const MediaAccessDenied();
        }
        return null;
      }
    }
    if (deletion.deletedThroughSeq != null &&
        sequence <= deletion.deletedThroughSeq!) {
      throw const MediaAccessDenied();
    }
    final thread = threadForConversation?.call(context.conversationId);
    List<Message> page;
    if (thread != null &&
        thread.conversationId == context.conversationId &&
        customerService != null) {
      final detail = await customerService!
          .getThread(thread, afterSeq: sequence - 1, limit: 1);
      page = detail.messages;
    } else {
      final conversation =
          await local.getConversationForAccess(spaceId, context.conversationId);
      _verifyCurrent();
      // A missing route is not permission to guess another endpoint.
      if (conversation == null) return null;
      switch (conversation.type) {
        case ConversationType.direct:
          page = await remote.getDirectChatMessages(context.conversationId,
              beforeSeq: sequence + 1, limit: 1);
          break;
        case ConversationType.group:
          page = await remote.getGroupMessages(context.conversationId,
              beforeSeq: sequence + 1, limit: 1);
          break;
        case ConversationType.tempSession:
          return null;
      }
    }
    _verifyCurrent();
    for (final snapshot in page) {
      if (snapshot.messageId != context.messageId ||
          snapshot.conversationId != context.conversationId ||
          snapshot.conversationSeq != sequence) {
        continue;
      }
      if (snapshot.isRecalled || !snapshot.status.isServerUsable) {
        throw const MediaAccessDenied();
      }
      final updated = await local.updateExistingMediaAccess(
        spaceId,
        context.conversationId,
        snapshot,
        isOperationCurrent: isCurrent,
      );
      if (updated == null) throw const MediaAccessDenied();
      return updated;
    }
    throw const MediaAccessDenied();
  }

  void _verifyCurrent() {
    if (!isCurrent()) throw AccountOperationSuperseded();
  }
}
