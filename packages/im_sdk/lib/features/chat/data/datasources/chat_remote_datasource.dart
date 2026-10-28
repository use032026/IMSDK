import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/api_response.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/chat/data/models/conversation_model.dart';
import 'package:im_sdk/features/chat/data/models/message_model.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation_page.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation_clear_watermark.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/entities/read_receipt.dart';
import 'package:im_sdk/features/chat/domain/entities/scheduled_message.dart';
import 'package:im_sdk/features/chat/domain/services/message_link_access_policy.dart';

class ScheduledMessageDto {
  final String scheduledMessageId;
  final String conversationId;
  final bool isGroup;
  final String messageType;
  final Map<String, dynamic> rawBody;
  final DateTime scheduledAt;
  final int status;
  final String? failureReason;

  const ScheduledMessageDto({
    required this.scheduledMessageId,
    required this.conversationId,
    required this.isGroup,
    required this.messageType,
    required this.rawBody,
    required this.scheduledAt,
    this.status = 0,
    this.failureReason,
  });

  factory ScheduledMessageDto.fromJson(Map<String, dynamic> json) {
    final messageType = json['messageType'] as String? ?? 'text';
    final rawBody = Map<String, dynamic>.from(json['body'] as Map? ?? const {});
    return ScheduledMessageDto(
      scheduledMessageId: json['scheduledMessageId'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      isGroup: json['isGroup'] as bool? ?? false,
      messageType: messageType,
      rawBody: rawBody,
      scheduledAt: DateTime.tryParse(json['scheduledAt'] as String? ?? '') ??
          DateTime.now(),
      status: json['status'] as int? ?? 0,
      failureReason: json['failureReason'] as String?,
    );
  }

  ScheduledMessage toDomain() {
    final body = MessageBody.fromJson(rawBody);
    return ScheduledMessage(
      scheduledMessageId: scheduledMessageId,
      conversationId: conversationId,
      isGroup: isGroup,
      type: MessageModel.fromApiType(messageType, body: body),
      body: body,
      scheduledAt: scheduledAt,
      status: status,
      failureReason: failureReason,
    );
  }
}

abstract class ChatRemoteDataSource {
  Future<ConversationsPage> getConversations({String? cursor, int limit = 50});
  Future<ConversationDeletionResult> deleteConversation(
    String conversationId,
  );
  Future<MessageLinkWhitelist> getLinkWhitelist();
  Future<void> pinDirectChat(String chatId, bool pinned);
  Future<void> pinGroup(String groupId, bool pinned);
  Future<void> muteDirectChat(String chatId, bool muted);

  /// PUT /api/client/v1/groups/{groupId}/mute
  Future<void> muteGroup(String groupId, bool muted);

  /// GET /api/client/v1/direct-chats/{chatId}/messages
  Future<List<Message>> getDirectChatMessages(
    String chatId, {
    int? beforeSeq,
    int limit = 50,
  });

  /// GET /api/client/v1/groups/{groupId}/messages
  Future<List<Message>> getGroupMessages(
    String groupId, {
    int? beforeSeq,
    int limit = 50,
  });

  /// POST /api/client/v1/direct-chats/{chatId}/messages
  Future<Message> sendDirectChatMessage({
    required String chatId,
    required String clientMsgId,
    required MessageType type,
    required MessageBody body,
    String? replyToMessageId,
  });

  /// POST /api/client/v1/groups/{groupId}/messages
  Future<Message> sendGroupMessage({
    required String groupId,
    required String clientMsgId,
    required MessageType type,
    required MessageBody body,
    String? replyToMessageId,
    List<Mention>? mentions,
  });

  /// POST /api/client/v1/scheduled-messages
  Future<ScheduledMessageDto> createScheduledMessage({
    required String conversationId,
    required bool isGroup,
    required MessageType type,
    required MessageBody body,
    required DateTime scheduledAt,
    String? replyToMessageId,
  });

  /// GET /api/client/v1/conversations/{conversationId}/scheduled-messages
  Future<List<ScheduledMessageDto>> getScheduledMessages(String conversationId);

  /// DELETE /api/client/v1/scheduled-messages/{scheduledMessageId}
  Future<void> cancelScheduledMessage(String scheduledMessageId);

  /// PUT /api/client/v1/scheduled-messages/{scheduledMessageId}
  Future<ScheduledMessageDto> updateScheduledMessage({
    required String scheduledMessageId,
    MessageBody? body,
    DateTime? scheduledAt,
  });

  /// POST /api/client/v1/media/upload
  Future<MediaResource> uploadMedia(
    String filePath, {
    String? mediaKind,
    MediaUploadProgressCallback? onProgress,
  });

  /// POST /api/client/v1/messages/{messageId}/recall
  Future<void> recallMessage(String messageId);

  /// POST /api/client/v1/direct-chats/{chatId}/read
  Future<void> markDirectChatRead(String chatId, int readSeq);

  /// GET /api/client/v1/direct-chats/{chatId}/read-status
  Future<PeerReadStatus> getDirectReadStatus(String chatId);

  /// POST /api/client/v1/groups/{groupId}/read
  Future<void> markGroupRead(String groupId, int readSeq);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  static const _defaultMediaUploadNoProgressTimeout = Duration(seconds: 30);
  static final Expando<_MediaUploadConcurrencyGate> _uploadGates =
      Expando<_MediaUploadConcurrencyGate>('chat-media-upload-gate');

  final Dio _dio;
  final String? Function()? _accessTokenGetter;
  final Duration _mediaUploadNoProgressTimeout;
  final _MediaUploadConcurrencyGate _uploadGate;

  ChatRemoteDataSourceImpl(
    Dio dio, {
    String? Function()? accessTokenGetter,
    Duration mediaUploadNoProgressTimeout =
        _defaultMediaUploadNoProgressTimeout,
  })  : _dio = dio,
        _accessTokenGetter = accessTokenGetter,
        _mediaUploadNoProgressTimeout = mediaUploadNoProgressTimeout,
        _uploadGate =
            _uploadGates[dio] ??= _MediaUploadConcurrencyGate(maxConcurrent: 2);

  @override
  Future<MessageLinkWhitelist> getLinkWhitelist() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/client/v1/messages/link-whitelist',
      options: _tenantAuthOptions(),
    );
    final apiResponse = ApiResponse.fromJson(
      response.data!,
      (json) => MessageLinkWhitelist.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
    return apiResponse.getDataOrThrow();
  }

  @override
  Future<ConversationsPage> getConversations({
    String? cursor,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/conversations',
        queryParameters: {
          if (cursor != null) 'cursor': cursor,
          'limit': limit,
        },
        options: _tenantAuthOptions(),
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) {
          final data = json as Map<String, dynamic>;
          final items = data['items'] as List<dynamic>? ?? [];
          final nextCursor = data['nextCursor'] as String?;
          return ConversationsPage(
            items: items
                .map((e) =>
                    ConversationModel.fromJson(e as Map<String, dynamic>))
                .toList(),
            nextCursor: nextCursor,
          );
        },
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<ConversationDeletionResult> deleteConversation(
    String conversationId,
  ) async {
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final response = await _dio.delete<Map<String, dynamic>>(
          '/api/client/v1/conversations/$conversationId',
          options: _tenantAuthOptions(),
        );
        final apiResponse = ApiResponse.fromJson(
          response.data!,
          (json) {
            final data = Map<String, dynamic>.from(json as Map);
            final returnedId = data['conversationId']?.toString() ?? '';
            final clearedSeq = (data['clearedSeq'] as num?)?.toInt() ?? -1;
            if (returnedId != conversationId || clearedSeq < 0) {
              throw const FormatException(
                  'Invalid conversation deletion result');
            }
            return ConversationDeletionResult(
              conversationId: returnedId,
              clearedSeq: clearedSeq,
            );
          },
        );
        return apiResponse.getDataOrThrow();
      } on DioException catch (e) {
        final retryable = e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError;
        if (attempt == 0 && retryable) continue;
        throw ErrorHandler.fromDioException(e);
      }
    }
    throw const NetworkError('删除会话请求失败');
  }

  Options? _tenantAuthOptions() {
    final token = _accessTokenGetter?.call()?.trim();
    if (token == null || token.isEmpty) return null;
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<void> pinDirectChat(String chatId, bool pinned) async {
    try {
      await _dio.put<Map<String, dynamic>>(
        '/api/client/v1/direct-chats/$chatId/pin',
        data: {'pinned': pinned},
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> pinGroup(String groupId, bool pinned) async {
    try {
      await _dio.put<Map<String, dynamic>>(
        '/api/client/v1/groups/$groupId/pin',
        data: {'pinned': pinned},
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> muteDirectChat(String chatId, bool muted) async {
    try {
      await _dio.put<Map<String, dynamic>>(
        '/api/client/v1/direct-chats/$chatId/mute',
        data: {'muted': muted},
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> muteGroup(String groupId, bool muted) async {
    try {
      await _dio.put<Map<String, dynamic>>(
        '/api/client/v1/groups/$groupId/mute',
        data: {'muted': muted},
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<List<Message>> getDirectChatMessages(
    String chatId, {
    int? beforeSeq,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/direct-chats/$chatId/messages',
        queryParameters: {
          if (beforeSeq != null) 'beforeSeq': beforeSeq,
          'limit': limit,
        },
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) {
          final list = json as List<dynamic>;
          return list
              .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<List<Message>> getGroupMessages(
    String groupId, {
    int? beforeSeq,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/groups/$groupId/messages',
        queryParameters: {
          if (beforeSeq != null) 'beforeSeq': beforeSeq,
          'limit': limit,
        },
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) {
          final list = json as List<dynamic>;
          return list
              .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<Message> sendDirectChatMessage({
    required String chatId,
    required String clientMsgId,
    required MessageType type,
    required MessageBody body,
    String? replyToMessageId,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/direct-chats/$chatId/messages',
        data: {
          'clientMsgId': clientMsgId,
          'messageType': MessageModel.toApiType(type),
          'body': body.toJson(),
          if (replyToMessageId != null) 'replyToMessageId': replyToMessageId,
          'mentions': <Map<String, dynamic>>[],
        },
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => MessageModel.fromSendResponse(
          json as Map<String, dynamic>,
          clientMsgId: clientMsgId,
          type: type,
          body: body,
          conversationId: chatId,
          replyToMessageId: replyToMessageId,
        ),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<Message> sendGroupMessage({
    required String groupId,
    required String clientMsgId,
    required MessageType type,
    required MessageBody body,
    String? replyToMessageId,
    List<Mention>? mentions,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/groups/$groupId/messages',
        data: {
          'clientMsgId': clientMsgId,
          'messageType': MessageModel.toApiType(type),
          'body': _messageBodyToRequestJson(body),
          if (replyToMessageId != null) 'replyToMessageId': replyToMessageId,
          'mentions': mentions?.map((mention) => mention.toJson()).toList() ??
              <Map<String, dynamic>>[],
        },
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => MessageModel.fromSendResponse(
          json as Map<String, dynamic>,
          clientMsgId: clientMsgId,
          type: type,
          body: body,
          conversationId: groupId,
          replyToMessageId: replyToMessageId,
          mentions: mentions,
        ),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<ScheduledMessageDto> createScheduledMessage({
    required String conversationId,
    required bool isGroup,
    required MessageType type,
    required MessageBody body,
    required DateTime scheduledAt,
    String? replyToMessageId,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/scheduled-messages',
        data: {
          'conversationId': conversationId,
          'isGroup': isGroup,
          'messageType': MessageModel.toApiType(type),
          'body': _messageBodyToRequestJson(body),
          if (replyToMessageId != null) 'replyToMessageId': replyToMessageId,
          'scheduledAt': scheduledAt.toUtc().toIso8601String(),
        },
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => ScheduledMessageDto.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<List<ScheduledMessageDto>> getScheduledMessages(
    String conversationId,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/conversations/$conversationId/scheduled-messages',
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) {
          final data = json;
          final items = data is Map<String, dynamic>
              ? data['items'] as List<dynamic>? ?? const []
              : data as List<dynamic>? ?? const [];
          return items
              .whereType<Map>()
              .map((item) => ScheduledMessageDto.fromJson(
                    Map<String, dynamic>.from(item),
                  ))
              .toList(growable: false);
        },
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> cancelScheduledMessage(String scheduledMessageId) async {
    try {
      await _dio.delete<Map<String, dynamic>>(
        '/api/client/v1/scheduled-messages/$scheduledMessageId',
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<ScheduledMessageDto> updateScheduledMessage({
    required String scheduledMessageId,
    MessageBody? body,
    DateTime? scheduledAt,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/client/v1/scheduled-messages/$scheduledMessageId',
        data: {
          if (body != null) 'body': _messageBodyToRequestJson(body),
          if (scheduledAt != null)
            'scheduledAt': scheduledAt.toUtc().toIso8601String(),
        },
      );
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => ScheduledMessageDto.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<MediaResource> uploadMedia(
    String filePath, {
    String? mediaKind,
    MediaUploadProgressCallback? onProgress,
  }) {
    return _uploadGate.run(
      () => _uploadMediaNow(
        filePath,
        mediaKind: mediaKind,
        onProgress: onProgress,
      ),
    );
  }

  Future<MediaResource> _uploadMediaNow(
    String filePath, {
    String? mediaKind,
    MediaUploadProgressCallback? onProgress,
  }) async {
    final cancelToken = CancelToken();
    Timer? noProgressTimer;
    var lastSentBytes = -1;

    void armNoProgressTimeout() {
      noProgressTimer?.cancel();
      noProgressTimer = Timer(_mediaUploadNoProgressTimeout, () {
        if (!cancelToken.isCancelled) {
          cancelToken.cancel('media upload made no progress');
        }
      });
    }

    try {
      final fallbackTotal = await _safeFileLength(filePath);
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        if (mediaKind != null && mediaKind.trim().isNotEmpty)
          'mediaKind': mediaKind.trim(),
      });
      armNoProgressTimeout();
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/media/upload',
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          final resolvedTotal = total > 0 ? total : fallbackTotal;
          if (sent > lastSentBytes) {
            lastSentBytes = sent;
            if (resolvedTotal != null && sent >= resolvedTotal) {
              noProgressTimer?.cancel();
              noProgressTimer = null;
            } else {
              armNoProgressTimeout();
            }
          }
          onProgress?.call(MediaUploadProgressEvent(
            loaded: sent,
            total: resolvedTotal,
          ));
        },
      );
      noProgressTimer?.cancel();
      noProgressTimer = null;
      final apiResponse = ApiResponse.fromJson(
        response.data!,
        (json) => MediaResource.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.getDataOrThrow();
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    } finally {
      noProgressTimer?.cancel();
    }
  }

  Future<int?> _safeFileLength(String filePath) async {
    try {
      return await File(filePath).length();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> recallMessage(String messageId) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/messages/$messageId/recall',
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> markDirectChatRead(String chatId, int readSeq) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/direct-chats/$chatId/read',
        data: {'readSeq': readSeq},
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<PeerReadStatus> getDirectReadStatus(String chatId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/direct-chats/$chatId/read-status',
      );
      final data = response.data?['data'] as Map<String, dynamic>? ?? {};
      return PeerReadStatus(
        peerLastReadSeq: _intValue(data['peerLastReadSeq']),
        peerLastReadAt: DateTime.tryParse(
          data['peerLastReadAt']?.toString() ?? '',
        ),
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  @override
  Future<void> markGroupRead(String groupId, int readSeq) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/groups/$groupId/read',
        data: {'readSeq': readSeq},
      );
    } on DioException catch (e) {
      throw ErrorHandler.fromDioException(e);
    }
  }

  static int _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static Map<String, dynamic> _messageBodyToRequestJson(MessageBody body) {
    return {
      if (body.text != null) 'text': body.text,
      if (body.image != null) 'image': body.image!.toJson(),
      if (body.video != null) 'video': body.video!.toJson(),
      if (body.voice != null) 'voice': body.voice!.toJson(),
      if (body.file != null) 'file': body.file!.toJson(),
      if (body.contactCard != null) 'contactCard': body.contactCard!.toJson(),
      if (body.callLog != null) 'callLog': body.callLog!.toJson(),
      if (body.location != null) 'location': body.location!.toJson(),
      if (body.link != null) 'link': body.link!.toJson(),
    };
  }
}

class _MediaUploadConcurrencyGate {
  final int maxConcurrent;
  final Queue<Completer<void>> _waiters = Queue<Completer<void>>();
  int _active = 0;

  _MediaUploadConcurrencyGate({required this.maxConcurrent});

  Future<T> run<T>(Future<T> Function() operation) async {
    if (_active >= maxConcurrent) {
      final waiter = Completer<void>();
      _waiters.addLast(waiter);
      await waiter.future;
    }
    _active += 1;
    try {
      return await operation();
    } finally {
      _active -= 1;
      if (_waiters.isNotEmpty) {
        _waiters.removeFirst().complete();
      }
    }
  }
}
