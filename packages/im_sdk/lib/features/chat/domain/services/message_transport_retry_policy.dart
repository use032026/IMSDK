import 'package:im_sdk/features/chat/domain/entities/message.dart';

const localConfirmationPendingFailureReason = 'LOCAL_CONFIRMATION_PENDING';

bool canRetryMessageTransport(Message message) {
  return message.status.isSendFailure &&
      message.failureReason != localConfirmationPendingFailureReason;
}
