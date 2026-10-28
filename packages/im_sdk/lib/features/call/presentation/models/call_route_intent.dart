import 'package:im_sdk/features/call/presentation/providers/call_provider.dart';

const freshOutgoingCallIntentKey = 'freshOutgoingCallIntent';

bool shouldStartOutgoingCallFromRoute({
  required Map<String, dynamic>? extra,
  required CallStatus currentStatus,
}) =>
    extra?[freshOutgoingCallIntentKey] == true &&
    (currentStatus == CallStatus.idle || currentStatus == CallStatus.ended);
