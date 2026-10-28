import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/chat/data/mappers/message_send_failure_mapper.dart';
import 'package:im_sdk/features/chat/domain/services/message_send_failure.dart';
import 'package:im_sdk/features/teen_mode/application/teen_mode_action_executor.dart';

MessageSendFailure mapTeenModeAwareMessageSendFailure(Object error) {
  const classifier = TeenModeServerActionClassifier();
  final action = classifier.classify(error);
  if (action?.awaitsServerReplay == true && error is ServerError) {
    return MessageSendFailure.serverReplayPending(
      message: error.message,
      code: error.code,
      statusCode: error.statusCode,
      requestId: error.requestId,
    );
  }
  return mapAppErrorToMessageSendFailure(error);
}
