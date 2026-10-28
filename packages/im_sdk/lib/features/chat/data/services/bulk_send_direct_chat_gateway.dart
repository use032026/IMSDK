import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/error_handler.dart';

class BulkSendDirectChatGateway {
  final Dio _dio;

  const BulkSendDirectChatGateway(this._dio);

  Future<String> createOrReuse(String peerUserId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/client/v1/direct-chats',
      data: {'peerUserId': peerUserId},
    );
    final data = response.data?['data'];
    if (data is Map<String, dynamic>) {
      final conversationId =
          data['conversationId'] as String? ?? data['chatId'] as String?;
      if (conversationId != null && conversationId.isNotEmpty) {
        return conversationId;
      }
    }
    throw const ServerError(
      code: 'DIRECT_CHAT_MISSING',
      message: '无法创建会话',
    );
  }
}
