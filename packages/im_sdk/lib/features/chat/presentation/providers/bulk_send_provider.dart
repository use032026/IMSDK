import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/permissions/app_permissions.dart';
import 'package:im_sdk/features/chat/application/bulk_send_controller.dart';
import 'package:im_sdk/features/chat/data/services/bulk_send_direct_chat_gateway.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_provider.dart';
import 'package:im_sdk/features/auth/presentation/providers/effective_space_provider.dart';

final bulkSendControllerProvider = Provider<BulkSendController>((ref) {
  final directChats = BulkSendDirectChatGateway(ref.watch(dioProvider));

  return BulkSendController(
    sendTarget: (target, content) async {
      final space = ref.read(effectiveCurrentSpaceProvider);
      if (space == null || space.spaceId.isEmpty) {
        throw const AuthError('AUTH_REQUIRED');
      }
      if (!AppPermissions.broadcast(space).canUseClientBulkSend) {
        throw const AuthError('BULK_SEND_FORBIDDEN');
      }
      final conversationId = target.isGroup
          ? target.conversationId
          : await directChats.createOrReuse(target.userId ?? '');
      if (conversationId == null || conversationId.isEmpty) {
        throw const ServerError(
          code: 'BULK_SEND_TARGET_INVALID',
          message: '群发对象无效',
        );
      }
      await ref
          .read(sendMessageUseCaseProvider(
            (space.spaceId, conversationId, target.isGroup),
          ))
          .execute(
            conversationId: conversationId,
            isGroup: target.isGroup,
            type: MessageType.text,
            body: MessageBody(text: content),
          );
    },
    errorText: _bulkSendErrorText,
  );
}, dependencies: [dioProvider]);

String _bulkSendErrorText(Object error) {
  if (error is AppError) {
    return switch (error) {
      NetworkError(:final message) => message,
      ServerError(:final message) => message,
      AuthError(:final code) =>
        code == 'BULK_SEND_FORBIDDEN' ? '当前身份没有群发权限' : '登录状态已失效',
    };
  }
  if (error is DioException) {
    return _bulkSendErrorText(ErrorHandler.fromDioException(error));
  }
  return '发送失败';
}
