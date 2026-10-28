import 'dart:convert';
import 'dart:async';

import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/runtime/account_write_gate.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/repositories/chat_repository.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_failure.dart';
import 'package:im_sdk/features/chat/domain/services/media_reference_policy.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_policy.dart';
import 'package:hive/hive.dart';

typedef PendingRepositoryResolver = ChatRepository Function(
    PendingMessage message);
typedef PendingMessageResentCallback = FutureOr<void> Function(
  PendingMessage pending,
  Message sent,
);
typedef PendingMessageAttemptStartedCallback = FutureOr<void> Function(
  PendingMessage pending,
);
typedef PendingMessageAttemptFailedCallback = FutureOr<void> Function(
  PendingMessage pending,
  Object error,
  bool exhausted,
);
typedef PendingMessageReconciliationFailedCallback = FutureOr<void> Function(
  PendingMessage pending,
  Message sent,
  Object error,
);
typedef PendingMessageConfirmationReader = Future<bool> Function(
  PendingMessage pending,
);
typedef PendingLocalFileExists = Future<bool> Function(String path);
typedef PendingDeletionBoundaryReader = Future<DateTime?> Function(
  String spaceId,
  String conversationId,
);

// ---------------------------------------------------------------------------
// PendingMessage 模型
// ---------------------------------------------------------------------------

class PendingMessage {
  final String spaceId;
  final String userId;
  final String clientMsgId;
  final String conversationId;
  final bool isGroup;
  final String messageType;
  final Map<String, dynamic> body;
  final List<Mention>? mentions;
  final String? threadType;
  final String? threadId;
  final int retryCount;
  final DateTime createdAt;

  const PendingMessage({
    required this.spaceId,
    required this.userId,
    required this.clientMsgId,
    required this.conversationId,
    required this.isGroup,
    required this.messageType,
    required this.body,
    this.mentions,
    this.threadType,
    this.threadId,
    this.retryCount = 0,
    required this.createdAt,
  });

  PendingMessage copyWith({
    String? spaceId,
    String? userId,
    String? clientMsgId,
    String? conversationId,
    bool? isGroup,
    String? messageType,
    Map<String, dynamic>? body,
    List<Mention>? mentions,
    String? threadType,
    String? threadId,
    int? retryCount,
    DateTime? createdAt,
  }) {
    return PendingMessage(
      spaceId: spaceId ?? this.spaceId,
      userId: userId ?? this.userId,
      clientMsgId: clientMsgId ?? this.clientMsgId,
      conversationId: conversationId ?? this.conversationId,
      isGroup: isGroup ?? this.isGroup,
      messageType: messageType ?? this.messageType,
      body: body ?? this.body,
      mentions: mentions ?? this.mentions,
      threadType: threadType ?? this.threadType,
      threadId: threadId ?? this.threadId,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'spaceId': spaceId,
        'userId': userId,
        'clientMsgId': clientMsgId,
        'conversationId': conversationId,
        'isGroup': isGroup,
        'messageType': messageType,
        'body': body,
        'mentions': mentions?.map((mention) => mention.toJson()).toList(),
        if (threadType != null) 'threadType': threadType,
        if (threadId != null) 'threadId': threadId,
        'retryCount': retryCount,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PendingMessage.fromJson(Map<String, dynamic> json) => PendingMessage(
        spaceId: json['spaceId'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        clientMsgId: json['clientMsgId'] as String,
        conversationId: json['conversationId'] as String,
        isGroup: json['isGroup'] as bool? ?? false,
        messageType: json['messageType'] as String? ?? 'text',
        body: Map<String, dynamic>.from(json['body'] as Map? ?? {}),
        mentions: (json['mentions'] as List<dynamic>?)
            ?.map((e) => Mention.fromJson(e as Map<String, dynamic>))
            .toList(),
        threadType: json['threadType'] as String?,
        threadId: json['threadId'] as String?,
        retryCount: json['retryCount'] as int? ?? 0,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

// ---------------------------------------------------------------------------
// PendingMessageQueue
// ---------------------------------------------------------------------------

/// 离线消息队列
///
/// 使用 Hive `pending_messages` Box 持久化待发消息。
/// 网络断开时写入，网络恢复后按序重发。
class PendingMessageQueue {
  PendingMessageQueue({
    required Box<dynamic> accountBox,
    required PendingDeletionBoundaryReader deletionBoundaryReader,
    AccountWriteGate? writeGate,
    AccountOperationContext? operationContext,
  })  : _accountBox = accountBox,
        _deletionBoundaryReader = deletionBoundaryReader,
        _writeGate = writeGate,
        _operationContext = operationContext;

  static const int _maxRetries = 3;
  final Box<dynamic> _accountBox;
  final PendingDeletionBoundaryReader _deletionBoundaryReader;
  final AccountWriteGate? _writeGate;
  final AccountOperationContext? _operationContext;

  Future<T> _write<T>(Future<T> Function() action) {
    final gate = _writeGate;
    final context = _operationContext;
    return gate == null || context == null
        ? action()
        : gate.run(context, action);
  }

  Box<dynamic> get _box => _accountBox;

  Future<DateTime?> _readDeletionBoundary(
    String spaceId,
    String conversationId,
  ) =>
      _deletionBoundaryReader(spaceId, conversationId);

  /// 写入待发消息（网络断开时调用）
  Future<void> enqueue(PendingMessage message) async {
    await _write(() async {
      final box = _box;
      final encoded = jsonEncode(message.toJson());
      await box.put(_keyFor(message), encoded);
    });
    AppDiagnostics.instance.info(
      'chat.pending',
      'enqueued',
      context: {
        'spaceId': message.spaceId,
        'userId': message.userId,
        'conversationId': message.conversationId,
        'clientMsgId': message.clientMsgId,
        'messageType': message.messageType,
      },
    );
  }

  /// 获取所有待发消息（按创建时间升序）
  Future<List<PendingMessage>> getAll({
    String? spaceId,
    String? userId,
  }) async {
    final box = _box;
    final messages = <PendingMessage>[];
    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw == null) continue;
      try {
        final json = jsonDecode(raw as String) as Map<String, dynamic>;
        final message = PendingMessage.fromJson(json);
        if (!_matchesIdentity(message, spaceId: spaceId, userId: userId)) {
          continue;
        }
        messages.add(message);
      } catch (_) {
        // 跳过损坏的记录
      }
    }
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return messages;
  }

  /// 删除已发送消息
  Future<void> remove(
    String clientMsgId, {
    String? spaceId,
    String? userId,
  }) async {
    await _write(() async {
      final box = _box;
      if (spaceId != null && userId != null) {
        await box.delete(_storageKey(spaceId, userId, clientMsgId));
        return;
      }
      await box.delete(clientMsgId);
    });
  }

  Future<void> removeConversation({
    required String spaceId,
    required String userId,
    required String conversationId,
  }) async {
    await _write(() async {
      final box = _box;
      final keys = <dynamic>[];
      for (final key in box.keys) {
        final raw = box.get(key);
        if (raw is! String) continue;
        try {
          final message = PendingMessage.fromJson(
            jsonDecode(raw) as Map<String, dynamic>,
          );
          if (message.spaceId == spaceId &&
              message.userId == userId &&
              message.conversationId == conversationId) {
            keys.add(key);
          }
        } catch (_) {
          // A malformed entry is unrelated to the requested conversation.
        }
      }
      await box.deleteAll(keys);
    });
  }

  /// 网络恢复后按序重发所有待发消息
  ///
  /// 发送成功后从队列移除；超过最大重试次数后也移除（避免无限积压）。
  Future<void> flushAll(
    ChatRepository repository, {
    required String spaceId,
    required String userId,
    PendingRepositoryResolver? repositoryForMessage,
    PendingMessageResentCallback? onMessageResent,
    PendingMessageAttemptStartedCallback? onAttemptStarted,
    PendingMessageAttemptFailedCallback? onAttemptFailed,
    PendingMessageReconciliationFailedCallback? onReconciliationFailed,
    PendingMessageConfirmationReader? isAlreadyConfirmed,
    MessageSendFailureMapper? failureMapper,
    PendingLocalFileExists? localFileExists,
  }) async {
    final pending = await getAll(spaceId: spaceId, userId: userId);
    for (final message in pending) {
      try {
        final deletedAt = await _readDeletionBoundary(
          message.spaceId,
          message.conversationId,
        );
        if (deletedAt != null && !message.createdAt.isAfter(deletedAt)) {
          await _remove(message);
          continue;
        }
        if (await isAlreadyConfirmed?.call(message) == true) {
          await _remove(message);
          continue;
        }
        final type = _parseMessageType(message.messageType);
        if (type == MessageType.callLog) {
          await onAttemptFailed?.call(
            message,
            MessageSendPolicy.callLogReadOnlyFailure,
            true,
          );
          await _remove(message);
          AppDiagnostics.instance.warning(
            'chat.pending',
            'dropped read-only call log',
            context: {
              'spaceId': message.spaceId,
              'userId': message.userId,
              'conversationId': message.conversationId,
              'clientMsgId': message.clientMsgId,
            },
          );
          continue;
        }
        await onAttemptStarted?.call(message);
        final messageRepository =
            repositoryForMessage?.call(message) ?? repository;
        final body = await _resolvePendingMediaBody(
          messageRepository,
          type,
          MessageBody.fromJson(message.body),
          localFileExists: localFileExists,
        );

        final latestDeletedAt = await _readDeletionBoundary(
          message.spaceId,
          message.conversationId,
        );
        if (latestDeletedAt != null &&
            !message.createdAt.isAfter(latestDeletedAt)) {
          await _remove(message);
          continue;
        }

        late final Message sent;
        try {
          sent = await messageRepository.sendMessage(
            conversationId: message.conversationId,
            isGroup: message.isGroup,
            clientMsgId: message.clientMsgId,
            type: type,
            body: body,
            mentions: message.isGroup ? message.mentions : null,
          );
        } catch (error) {
          final failure = failureMapper?.call(error);
          if (failure?.isDuplicateClientMsgId != true) rethrow;
          sent = _idempotentConfirmedMessage(message, type, body);
        }
        await _completeAcceptedMessage(
          message,
          sent,
          onMessageResent: onMessageResent,
          onReconciliationFailed: onReconciliationFailed,
        );
        AppDiagnostics.instance.info(
          'chat.pending',
          'resent',
          context: {
            'spaceId': message.spaceId,
            'userId': message.userId,
            'conversationId': message.conversationId,
            'clientMsgId': message.clientMsgId,
          },
        );
      } catch (error) {
        // 发送失败，更新重试次数
        final updated = message.copyWith(retryCount: message.retryCount + 1);
        final failure = failureMapper?.call(error);
        final exhausted =
            failure?.shouldRetry == false || updated.retryCount >= _maxRetries;
        await onAttemptFailed?.call(message, error, exhausted);
        if (exhausted) {
          // 超过最大重试次数，移除（标记为失败由上层处理）
          await _remove(message);
          AppDiagnostics.instance.warning(
            'chat.pending',
            'dropped',
            context: {
              'spaceId': message.spaceId,
              'userId': message.userId,
              'conversationId': message.conversationId,
              'clientMsgId': message.clientMsgId,
              'retryCount': updated.retryCount,
            },
          );
        } else {
          await enqueue(updated);
        }
      }
    }
  }

  Future<void> _completeAcceptedMessage(
    PendingMessage pending,
    Message sent, {
    PendingMessageResentCallback? onMessageResent,
    PendingMessageReconciliationFailedCallback? onReconciliationFailed,
  }) async {
    Object? reconciliationError;
    try {
      await onMessageResent?.call(pending, sent);
    } catch (error) {
      reconciliationError = error;
    }

    try {
      await _remove(pending);
    } catch (error) {
      AppDiagnostics.instance.warning(
        'chat.pending',
        'confirmed_remove_failed',
        context: {
          'spaceId': pending.spaceId,
          'userId': pending.userId,
          'conversationId': pending.conversationId,
          'clientMsgId': pending.clientMsgId,
          'error': error.toString(),
        },
      );
    }

    if (reconciliationError != null) {
      try {
        await onReconciliationFailed?.call(
          pending,
          sent,
          _PendingConfirmationPersistenceFailure(reconciliationError),
        );
      } catch (_) {
        // The transport is already confirmed. Never re-enqueue it because a
        // best-effort local failure marker could not be persisted.
      }
      AppDiagnostics.instance.warning(
        'chat.pending',
        'confirmed_reconciliation_failed',
        context: {
          'spaceId': pending.spaceId,
          'userId': pending.userId,
          'conversationId': pending.conversationId,
          'clientMsgId': pending.clientMsgId,
          'error': reconciliationError.toString(),
        },
      );
    }
  }

  Message _idempotentConfirmedMessage(
    PendingMessage pending,
    MessageType type,
    MessageBody body,
  ) {
    return Message(
      messageId: pending.clientMsgId,
      clientMsgId: pending.clientMsgId,
      conversationId: pending.conversationId,
      conversationSeq: 0,
      senderUserId: pending.userId,
      type: type,
      body: body,
      sentAt: pending.createdAt,
      status: MessageStatus.sent,
      isSelf: true,
      mentions: pending.mentions,
    );
  }

  Future<void> _remove(PendingMessage message) {
    return remove(
      message.clientMsgId,
      spaceId: message.spaceId,
      userId: message.userId,
    );
  }

  static bool _matchesIdentity(
    PendingMessage message, {
    String? spaceId,
    String? userId,
  }) {
    if (spaceId == null && userId == null) return true;
    return message.spaceId == spaceId && message.userId == userId;
  }

  static String _keyFor(PendingMessage message) =>
      _storageKey(message.spaceId, message.userId, message.clientMsgId);

  static String _storageKey(
          String spaceId, String userId, String clientMsgId) =>
      '$spaceId:$userId:$clientMsgId';

  static MessageType _parseMessageType(String raw) {
    switch (raw) {
      case 'markdown':
        return MessageType.markdown;
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'voice':
        return MessageType.voice;
      case 'file':
        return MessageType.file;
      case 'event':
        return MessageType.event;
      case 'contact_card':
        return MessageType.contactCard;
      case 'call_log':
        return MessageType.callLog;
      case 'location':
        return MessageType.location;
      case 'link':
        return MessageType.link;
      default:
        return MessageType.text;
    }
  }

  static Future<MessageBody> _resolvePendingMediaBody(
    ChatRepository repository,
    MessageType type,
    MessageBody body, {
    PendingLocalFileExists? localFileExists,
  }) async {
    final localPath = _localMediaPath(_mediaResourceForType(type, body)?.url);
    if (localPath == null) return body;
    if (localFileExists != null && !await localFileExists(localPath)) {
      throw const MessageSendFailure.serverRejected(
        message: 'local media file is missing',
        code: 'LOCAL_MEDIA_FILE_MISSING',
      );
    }
    final uploaded = await repository.uploadMedia(
      localPath,
      mediaKind: _mediaKind(type),
    );
    final localResource = _mediaResourceForType(type, body);
    final resolved = _preservePendingMediaMetadata(
      uploaded: uploaded,
      local: localResource,
      type: type,
    );
    if (type == MessageType.video) {
      final localVideo = body.video;
      final posterPath = _localMediaPath(localVideo?.localPosterUrl);
      if (posterPath != null) {
        try {
          final poster = await repository.uploadMedia(
            posterPath,
            mediaKind: 'image',
          );
          return _replaceMediaResource(
            body,
            type,
            resolved.copyWith(
              thumbnailUrl: poster.url,
            ),
          );
        } catch (_) {
          return _replaceMediaResource(body, type, resolved);
        }
      }
    }
    return _replaceMediaResource(body, type, resolved);
  }

  static MediaResource _preservePendingMediaMetadata({
    required MediaResource uploaded,
    required MediaResource? local,
    required MessageType type,
  }) {
    if (local == null) return uploaded;
    if (type == MessageType.voice) {
      return uploaded.copyWith(
        fileName: local.fileName,
        mimeType: local.mimeType,
        sizeBytes: local.sizeBytes,
        durationSeconds: local.durationSeconds,
      );
    }
    return uploaded.copyWith(
      width: local.width,
      height: local.height,
      localPreviewUrl: local.localPreviewUrl ??
          (isLocalMediaReference(local.url) ? local.url : null),
      localPosterUrl: local.localPosterUrl,
    );
  }

  static MediaResource? _mediaResourceForType(
      MessageType type, MessageBody body) {
    switch (type) {
      case MessageType.image:
        return body.image;
      case MessageType.video:
        return body.video;
      case MessageType.voice:
        return body.voice;
      case MessageType.file:
        return body.file;
      default:
        return null;
    }
  }

  static MessageBody _replaceMediaResource(
    MessageBody body,
    MessageType type,
    MediaResource resource,
  ) {
    switch (type) {
      case MessageType.image:
        return MessageBody(
          text: body.text,
          image: resource,
          video: body.video,
          voice: body.voice,
          file: body.file,
        );
      case MessageType.video:
        return MessageBody(
          text: body.text,
          image: body.image,
          video: resource,
          voice: body.voice,
          file: body.file,
        );
      case MessageType.voice:
        return MessageBody(
          text: body.text,
          image: body.image,
          video: body.video,
          voice: resource,
          file: body.file,
        );
      case MessageType.file:
        return MessageBody(
          text: body.text,
          image: body.image,
          video: body.video,
          voice: body.voice,
          file: resource,
        );
      default:
        return body;
    }
  }

  static String _mediaKind(MessageType type) {
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

  static String? _localMediaPath(String? value) {
    return localMediaPath(value);
  }
}

class _PendingConfirmationPersistenceFailure implements Exception {
  final Object cause;

  const _PendingConfirmationPersistenceFailure(this.cause);

  @override
  String toString() => 'Pending confirmation persistence failed: $cause';
}
