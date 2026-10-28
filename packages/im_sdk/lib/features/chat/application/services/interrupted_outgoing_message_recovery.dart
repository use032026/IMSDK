import 'package:im_sdk/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:im_sdk/features/chat/data/datasources/pending_message_queue.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_policy.dart';
import 'package:im_sdk/features/chat/domain/services/media_reference_policy.dart';

typedef LocalMediaFileExists = Future<bool> Function(String path);

class InterruptedRecoveryResult {
  final int failedCount;
  final int enqueuedCount;

  const InterruptedRecoveryResult({
    required this.failedCount,
    required this.enqueuedCount,
  });
}

class InterruptedOutgoingMessageRecovery {
  final ChatLocalDataSource local;
  final PendingMessageQueue pending;
  final LocalMediaFileExists fileExists;
  final MessageSendPolicy sendPolicy;

  const InterruptedOutgoingMessageRecovery({
    required this.local,
    required this.pending,
    required this.fileExists,
    this.sendPolicy = MessageSendPolicy.allowAll,
  });

  Future<InterruptedRecoveryResult> recover({
    required String spaceId,
    required String userId,
    required DateTime startedBefore,
  }) async {
    final interrupted = await local.getInterruptedOutgoingMessages(
      spaceId,
      currentUserId: userId,
      sentBefore: startedBefore,
    );
    final existingPending = {
      for (final item in await pending.getAll(
        spaceId: spaceId,
        userId: userId,
      ))
        item.clientMsgId: item,
    };
    var failedCount = 0;
    var enqueuedCount = 0;
    for (final candidate in interrupted) {
      final message = candidate.message;
      final failed = message.copyWith(
        status: MessageStatus.failed,
        failureReason: 'LOCAL_SEND_INTERRUPTED',
        localUploadState: const MessageLocalUploadState(
          status: MessageLocalUploadStatus.failed,
          phase: MessageLocalUploadPhase.failed,
          error: 'LOCAL_SEND_INTERRUPTED',
        ),
      );
      await local.upsertMessage(
        spaceId,
        message.conversationId,
        failed,
      );
      failedCount += 1;

      final clientMsgId = message.clientMsgId?.trim();
      if (clientMsgId == null || clientMsgId.isEmpty) continue;

      final recoverableBody = await _recoverableBody(message);
      final policyFailure = recoverableBody == null
          ? null
          : sendPolicy.validate(type: message.type, body: recoverableBody);
      if (policyFailure != null || recoverableBody == null) {
        await pending.remove(
          clientMsgId,
          spaceId: spaceId,
          userId: userId,
        );
        continue;
      }
      if (existingPending.containsKey(clientMsgId)) {
        continue;
      }
      if (candidate.conversationType == null ||
          candidate.conversationType == ConversationType.tempSession) {
        continue;
      }
      await pending.enqueue(PendingMessage(
        spaceId: spaceId,
        userId: userId,
        clientMsgId: clientMsgId,
        conversationId: message.conversationId,
        isGroup: candidate.conversationType == ConversationType.group,
        messageType: _messageTypeToApiString(message.type),
        body: recoverableBody.toLocalJson(),
        mentions: message.mentions,
        createdAt: message.sentAt,
      ));
      enqueuedCount += 1;
    }
    return InterruptedRecoveryResult(
      failedCount: failedCount,
      enqueuedCount: enqueuedCount,
    );
  }

  Future<MessageBody?> _recoverableBody(Message message) async {
    final resource = switch (message.type) {
      MessageType.image => message.body.image,
      MessageType.video => message.body.video,
      MessageType.voice => message.body.voice,
      MessageType.file => message.body.file,
      _ => null,
    };
    if (resource == null) return null;
    if (isRemoteMediaReference(resource.url)) return message.body;
    final primaryPath = localMediaPath(resource.url);
    if (primaryPath != null && await fileExists(primaryPath)) {
      return message.body;
    }
    final candidates = <String?>[resource.localPreviewUrl];
    for (final candidate in candidates) {
      final path = localMediaPath(candidate);
      if (path != null && await fileExists(path)) {
        return _replaceResourceUrl(
          message.body,
          message.type,
          resource.copyWith(url: path),
        );
      }
    }
    return null;
  }

  MessageBody _replaceResourceUrl(
    MessageBody body,
    MessageType type,
    MediaResource resource,
  ) {
    return switch (type) {
      MessageType.image => MessageBody(
          text: body.text,
          image: resource,
          video: body.video,
          voice: body.voice,
          file: body.file,
        ),
      MessageType.video => MessageBody(
          text: body.text,
          image: body.image,
          video: resource,
          voice: body.voice,
          file: body.file,
        ),
      MessageType.voice => MessageBody(
          text: body.text,
          image: body.image,
          video: body.video,
          voice: resource,
          file: body.file,
        ),
      MessageType.file => MessageBody(
          text: body.text,
          image: body.image,
          video: body.video,
          voice: body.voice,
          file: resource,
        ),
      _ => body,
    };
  }

  String _messageTypeToApiString(MessageType type) {
    return switch (type) {
      MessageType.text => 'text',
      MessageType.markdown => 'markdown',
      MessageType.image => 'image',
      MessageType.video => 'video',
      MessageType.voice => 'voice',
      MessageType.file => 'file',
      MessageType.event => 'event',
      MessageType.contactCard => 'contact_card',
      MessageType.callLog => 'call_log',
      MessageType.location => 'location',
      MessageType.link => 'text',
    };
  }
}
