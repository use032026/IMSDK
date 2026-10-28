import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/repositories/chat_repository.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_failure.dart';
import 'package:im_sdk/features/chat/domain/services/media_reference_policy.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_lifecycle.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_policy.dart';
import 'package:im_sdk/features/chat/domain/services/outgoing_message_policy.dart';

typedef OnOptimisticInsert = void Function(Message message);
typedef OnMessageUpdate = FutureOr<void> Function(
  String clientMsgId,
  Message updated,
);
typedef OnPendingEnqueue = Future<void> Function({
  required String clientMsgId,
  required String conversationId,
  required bool isGroup,
  required MessageType type,
  required MessageBody body,
  List<Mention>? mentions,
});

class _PostSendPersistenceFailure implements Exception {
  final Object cause;

  const _PostSendPersistenceFailure(this.cause);

  @override
  String toString() => '消息已发送，但本地会话状态保存失败：$cause';
}

class SendMessageUseCase {
  final ChatRepository _repository;
  final String currentUserId;
  final OnPendingEnqueue? _onPendingEnqueue;
  final MessageSendFailureMapper _failureMapper;
  final MessageSendPolicy _sendPolicy;

  static const int _maxRetries = 3;
  static const _uuid = Uuid();

  SendMessageUseCase({
    required ChatRepository repository,
    required this.currentUserId,
    OnPendingEnqueue? onPendingEnqueue,
    MessageSendFailureMapper? failureMapper,
    MessageSendPolicy sendPolicy = MessageSendPolicy.allowAll,
  })  : _repository = repository,
        _onPendingEnqueue = onPendingEnqueue,
        _failureMapper = failureMapper ?? defaultMessageSendFailureMapper,
        _sendPolicy = sendPolicy;

  /// 发送消息
  ///
  /// [onOptimisticInsert] — 乐观插入回调（status: sending）
  /// [onMessageUpdate]    — 状态更新回调（sent / failed / rejected）
  Future<Message> execute({
    required String conversationId,
    required bool isGroup,
    required MessageType type,
    required MessageBody body,
    String? clientMsgId,
    String? replyToMessageId,
    List<Mention>? mentions,
    OnOptimisticInsert? onOptimisticInsert,
    OnMessageUpdate? onMessageUpdate,
  }) async {
    // 1. 生成 clientMsgId
    final effectiveClientMsgId = clientMsgId?.trim().isNotEmpty == true
        ? clientMsgId!.trim()
        : _uuid.v4();

    var updateTail = Future<void>.value();
    Future<void> enqueueMessageUpdate(Message updated) {
      final previous = updateTail;
      final current = (() async {
        try {
          await previous;
        } catch (_) {
          // A failed progress write must not block a later terminal state.
        }
        await onMessageUpdate?.call(effectiveClientMsgId, updated);
      })();
      updateTail = current;
      return current;
    }

    final policyFailure = _sendPolicy.validate(type: type, body: body);
    if (policyFailure != null) {
      final failed = Message(
        messageId: effectiveClientMsgId,
        clientMsgId: effectiveClientMsgId,
        conversationId: conversationId,
        conversationSeq: 0,
        senderUserId: currentUserId,
        type: type,
        body: body,
        sentAt: DateTime.now(),
        replyToMessageId: replyToMessageId,
        mentions: mentions,
        status: MessageStatus.failed,
        failureReason: _failureReason(policyFailure),
        isSelf: true,
      );
      onOptimisticInsert?.call(failed);
      await enqueueMessageUpdate(failed);
      MessageSendLifecycle.failed(
        failed,
        isGroup: isGroup,
        stage: 'policy',
        error: policyFailure,
      );
      throw policyFailure;
    }

    final localPath = _isMediaType(type) ? _extractLocalPath(body, type) : null;

    // 2. 乐观插入（status: sending）
    final optimistic = Message(
      messageId: effectiveClientMsgId, // 临时用 clientMsgId 作为 messageId
      clientMsgId: effectiveClientMsgId,
      conversationId: conversationId,
      conversationSeq: 0,
      senderUserId: currentUserId,
      type: type,
      body: body,
      sentAt: DateTime.now(),
      replyToMessageId: replyToMessageId,
      mentions: mentions,
      status: MessageStatus.sending,
      isSelf: true,
    );
    MessageSendLifecycle.queued(optimistic, isGroup: isGroup);
    onOptimisticInsert?.call(optimistic);

    // 3. 媒体消息先上传
    MessageBody resolvedBody = body;
    Message sendBase = optimistic;
    var uploadAttemptRevision = 0;
    if (_isMediaType(type)) {
      if (localPath != null) {
        final attemptRevision = ++uploadAttemptRevision;
        var acceptsProgress = true;
        try {
          final preparing = optimistic.copyWith(
            localUploadState: const MessageLocalUploadState(
              status: MessageLocalUploadStatus.uploading,
              phase: MessageLocalUploadPhase.preparing,
              progress: 0,
            ),
          );
          await enqueueMessageUpdate(preparing);
          MessageSendLifecycle.uploadStarted(
            optimistic,
            isGroup: isGroup,
            localPath: localPath,
          );
          final fallbackTotalBytes = _mediaSizeBytes(body, type);
          final resource = await _repository.uploadMedia(
            localPath,
            mediaKind: _mediaKind(type),
            onProgress: (event) {
              if (!acceptsProgress ||
                  attemptRevision != uploadAttemptRevision) {
                return;
              }
              final progress = mediaUploadProgressPercent(
                event,
                fallbackTotalBytes: fallbackTotalBytes,
              );
              unawaited(enqueueMessageUpdate(
                optimistic.copyWith(
                  localUploadState: MessageLocalUploadState(
                    status: MessageLocalUploadStatus.uploading,
                    phase: MessageLocalUploadPhase.uploadingMedia,
                    progress: progress,
                  ),
                ),
              ).catchError((_) {}));
            },
          );
          acceptsProgress = false;
          resolvedBody = await _replaceMediaResource(body, type, resource);
          sendBase = optimistic.copyWith(
            body: resolvedBody,
            localUploadState: const MessageLocalUploadState(
              status: MessageLocalUploadStatus.sending,
              phase: MessageLocalUploadPhase.sending,
              progress: 95,
            ),
          );
          await enqueueMessageUpdate(sendBase);
          MessageSendLifecycle.uploadSucceeded(optimistic, isGroup: isGroup);
        } catch (e) {
          acceptsProgress = false;
          final failure = _failureMapper(e);
          final failed = optimistic.copyWith(
            status: failure.awaitsServerReplay
                ? MessageStatus.awaitingApproval
                : MessageStatus.failed,
            failureReason: _failureReason(failure),
            localUploadState: failure.awaitsServerReplay
                ? null
                : MessageLocalUploadState(
                    status: MessageLocalUploadStatus.failed,
                    phase: MessageLocalUploadPhase.failed,
                    error: _failureReason(failure),
                  ),
            clearLocalUploadState: failure.awaitsServerReplay,
          );
          await enqueueMessageUpdate(failed);
          if (failure.awaitsServerReplay) {
            MessageSendLifecycle.awaitingApproval(
              failed,
              isGroup: isGroup,
              stage: 'upload',
              reason: failure,
            );
          } else {
            MessageSendLifecycle.failed(
              failed,
              isGroup: isGroup,
              stage: 'upload',
              error: e,
            );
          }
          final pendingEnqueue = _onPendingEnqueue;
          if (failure.shouldEnqueuePending && pendingEnqueue != null) {
            await pendingEnqueue(
              clientMsgId: effectiveClientMsgId,
              conversationId: conversationId,
              isGroup: isGroup,
              type: type,
              body: body,
              mentions: isGroup ? mentions : null,
            );
          }
          rethrow;
        }
      }
    }

    // 4. 调用 REST 发送接口（最多重试 3 次）
    Object? lastError;
    MessageSendFailure? lastFailure;
    var failureRecorded = false;
    Message? terminalFailure;
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        MessageSendLifecycle.sending(
          sendBase,
          isGroup: isGroup,
          attempt: attempt + 1,
        );
        final sent = await _repository.sendMessage(
          conversationId: conversationId,
          isGroup: isGroup,
          clientMsgId: effectiveClientMsgId,
          type: type,
          body: resolvedBody,
          replyToMessageId: replyToMessageId,
          mentions: isGroup ? mentions : null,
        );
        // 5a. 成功 → 更新状态为 sent
        final confirmed = OutgoingMessagePolicy.confirm(
          message: sent,
          clientMsgId: effectiveClientMsgId,
          currentUserId: currentUserId,
          mentions: mentions,
        );
        try {
          await enqueueMessageUpdate(confirmed);
        } catch (error) {
          throw _PostSendPersistenceFailure(error);
        }
        MessageSendLifecycle.sent(confirmed, isGroup: isGroup);
        return confirmed;
      } catch (e) {
        if (e is _PostSendPersistenceFailure) rethrow;
        final failure = _failureMapper(e);
        // MSG_DUPLICATE_CLIENT_MSG_ID → 视为成功
        if (failure.isDuplicateClientMsgId) {
          final confirmed = OutgoingMessagePolicy.confirm(
            message: optimistic.copyWith(body: resolvedBody),
            clientMsgId: effectiveClientMsgId,
            currentUserId: currentUserId,
            mentions: mentions,
          );
          try {
            await enqueueMessageUpdate(confirmed);
          } catch (error) {
            throw _PostSendPersistenceFailure(error);
          }
          MessageSendLifecycle.sent(
            confirmed,
            isGroup: isGroup,
            idempotent: true,
          );
          return confirmed;
        }
        lastError = e;
        lastFailure = failure;
        // 服务端明确拒绝（权限不足、禁言、参数不合法等）不重试，标记为 rejected。
        if (!failure.shouldRetry) {
          final rejected = optimistic.copyWith(
            status: failure.awaitsServerReplay
                ? MessageStatus.awaitingApproval
                : failure.shouldMarkRejected
                    ? MessageStatus.rejected
                    : MessageStatus.failed,
            body: resolvedBody,
            failureReason: _failureReason(failure),
            localUploadState: failure.awaitsServerReplay
                ? null
                : _localUploadFailureState(type, failure),
            clearLocalUploadState: failure.awaitsServerReplay,
          );
          terminalFailure = rejected;
          if (failure.awaitsServerReplay) {
            MessageSendLifecycle.awaitingApproval(
              rejected,
              isGroup: isGroup,
              stage: 'send',
              attempt: attempt + 1,
              reason: failure,
            );
          } else {
            MessageSendLifecycle.failed(
              rejected,
              isGroup: isGroup,
              stage: 'send',
              attempt: attempt + 1,
              error: failure,
            );
          }
          failureRecorded = true;
          break;
        }
        // 最后一次重试不等待
        if (attempt < _maxRetries - 1) {
          await Future<void>.delayed(
              Duration(milliseconds: 500 * (attempt + 1)));
        }
      }
    }

    // 5b. 超限或服务端拒绝后标记终态
    final terminal = terminalFailure ??
        optimistic.copyWith(
          status: MessageStatus.failed,
          body: resolvedBody,
          failureReason: _failureReason(
            lastFailure ?? const MessageSendFailure.network('发送失败'),
          ),
          localUploadState: _localUploadFailureState(
            type,
            lastFailure ?? const MessageSendFailure.network('发送失败'),
          ),
        );
    await enqueueMessageUpdate(terminal);
    final pendingEnqueue = _onPendingEnqueue;
    if (terminal.status == MessageStatus.failed &&
        lastFailure?.shouldEnqueuePending == true &&
        pendingEnqueue != null) {
      await pendingEnqueue(
        clientMsgId: effectiveClientMsgId,
        conversationId: conversationId,
        isGroup: isGroup,
        type: type,
        body: resolvedBody,
        mentions: isGroup ? mentions : null,
      );
    }
    if (!failureRecorded) {
      MessageSendLifecycle.failed(
        terminal,
        isGroup: isGroup,
        stage: 'send',
        error: lastFailure ?? const MessageSendFailure.network('发送失败'),
      );
    }
    throw lastError ?? const MessageSendFailure.network('发送失败');
  }

  bool _isMediaType(MessageType type) {
    return type == MessageType.image ||
        type == MessageType.video ||
        type == MessageType.voice ||
        type == MessageType.file;
  }

  int? _mediaSizeBytes(MessageBody body, MessageType type) {
    switch (type) {
      case MessageType.image:
        return body.image?.sizeBytes;
      case MessageType.video:
        return body.video?.sizeBytes;
      case MessageType.voice:
        return body.voice?.sizeBytes;
      case MessageType.file:
        return body.file?.sizeBytes;
      default:
        return null;
    }
  }

  String _mediaKind(MessageType type) {
    switch (type) {
      case MessageType.image:
        return 'image';
      case MessageType.video:
        return 'video';
      case MessageType.voice:
        return 'voice';
      case MessageType.file:
        return 'file';
      default:
        return 'file';
    }
  }

  MessageLocalUploadState? _localUploadFailureState(
    MessageType type,
    MessageSendFailure failure,
  ) {
    if (!_isMediaType(type)) return null;
    return MessageLocalUploadState(
      status: MessageLocalUploadStatus.failed,
      phase: MessageLocalUploadPhase.failed,
      error: _failureReason(failure),
    );
  }

  String? _extractLocalPath(MessageBody body, MessageType type) {
    switch (type) {
      case MessageType.image:
        return _localMediaPath(body.image?.url);
      case MessageType.video:
        return _localMediaPath(body.video?.url);
      case MessageType.voice:
        return _localMediaPath(body.voice?.url);
      case MessageType.file:
        return _localMediaPath(body.file?.url);
      default:
        return null;
    }
  }

  String? _localMediaPath(String? value) {
    return localMediaPath(value);
  }

  Future<MessageBody> _replaceMediaResource(
      MessageBody body, MessageType type, MediaResource resource) async {
    switch (type) {
      case MessageType.image:
        final image = _preserveLocalMediaPreview(
          uploaded: resource,
          local: body.image,
        );
        return MessageBody(
            text: body.text,
            image: image,
            video: body.video,
            voice: body.voice,
            file: body.file);
      case MessageType.video:
        final video = await _videoResourceWithRemotePoster(
          uploaded: resource,
          local: body.video,
        );
        return MessageBody(
            text: body.text,
            image: body.image,
            video: video,
            voice: body.voice,
            file: body.file);
      case MessageType.voice:
        final localVoice = body.voice;
        final voice = localVoice == null
            ? resource
            : resource.copyWith(
                fileName: localVoice.fileName,
                mimeType: localVoice.mimeType,
                sizeBytes: localVoice.sizeBytes,
                durationSeconds: localVoice.durationSeconds,
              );
        return MessageBody(
            text: body.text,
            image: body.image,
            video: body.video,
            voice: voice,
            file: body.file);
      case MessageType.file:
        final file = _preserveLocalMediaPreview(
          uploaded: resource,
          local: body.file,
        );
        return MessageBody(
            text: body.text,
            image: body.image,
            video: body.video,
            voice: body.voice,
            file: file);
      default:
        return body;
    }
  }

  MediaResource _preserveLocalMediaPreview({
    required MediaResource uploaded,
    required MediaResource? local,
  }) {
    if (local == null) return uploaded;
    final localUrl = _isLocalUrl(local.url) ? local.url : null;
    return uploaded.copyWith(
      width: local.width,
      height: local.height,
      localPreviewUrl: local.localPreviewUrl ?? localUrl,
      localPosterUrl: local.localPosterUrl,
    );
  }

  Future<MediaResource> _videoResourceWithRemotePoster({
    required MediaResource uploaded,
    required MediaResource? local,
  }) async {
    final merged = _preserveLocalMediaPreview(uploaded: uploaded, local: local);
    final posterPath = _localMediaPath(local?.localPosterUrl);
    if (posterPath == null) return merged;
    try {
      final poster = await _repository.uploadMedia(
        posterPath,
        mediaKind: 'image',
      );
      return merged.copyWith(thumbnailUrl: poster.url);
    } catch (_) {
      return merged;
    }
  }

  bool _isLocalUrl(String url) {
    return isLocalMediaReference(url);
  }

  String _failureReason(MessageSendFailure failure) {
    final code = failure.code;
    if (code != null && code.isNotEmpty) {
      if (isModerationBlockedCode(code)) {
        return moderationBlockMessage(code, failure.message) ?? '内容不符合规范，已禁止发送';
      }
      if (code == 'MSG_AT_ALL_NOT_ALLOWED') {
        return '当前群不允许普通成员 @所有人';
      }
      return code;
    }
    return failure.message;
  }
}
