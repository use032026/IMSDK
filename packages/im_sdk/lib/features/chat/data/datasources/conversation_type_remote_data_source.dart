import 'dart:async';

import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/api_response.dart';

/// A successful direct-chat detail response is authoritative for that ID.
/// The endpoint cannot classify groups or temporary sessions; those stay unknown.
class ConversationTypeRemoteDataSource {
  ConversationTypeRemoteDataSource(this._dio);

  final Dio _dio;

  Future<bool> isDirectConversation(
    String conversationId,
    String accessToken, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final cancellation = CancelToken();
    final response = await _dio
        .get<Map<String, dynamic>>(
      '/api/client/v1/direct-chats/${Uri.encodeComponent(conversationId)}',
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
        // This read belongs to a captured account. A root-client 401 retry must
        // not replay it with whichever account becomes current in the meantime.
        extra: {'skipAuthHandling': true},
        receiveTimeout: timeout,
        sendTimeout: timeout,
      ),
      cancelToken: cancellation,
    )
        .timeout(timeout, onTimeout: () {
      cancellation.cancel('Conversation type lookup timed out');
      throw TimeoutException('Conversation type lookup timed out', timeout);
    });
    final result = ApiResponse<String>.fromJson(
      response.data ?? const {},
      (data) => data is Map && data['chatId'] is String
          ? data['chatId'] as String
          : '',
    ).getDataOrThrow();
    return result == conversationId;
  }
}
