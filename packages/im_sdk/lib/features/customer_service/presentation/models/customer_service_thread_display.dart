import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';

String customerServiceThreadSubtitle(CsThread thread) {
  final preview = thread.lastMessagePreview?.trim();
  if (preview != null && preview.isNotEmpty) return preview;

  if (thread.isQueued) {
    final queueMeta = customerServiceQueueMetaParts(thread);
    return queueMeta.isEmpty ? '暂无消息' : queueMeta.join(' · ');
  }

  return '暂无消息';
}

List<String> customerServiceQueueMetaParts(CsThread thread) {
  final parts = <String>[];
  final position = thread.queuePosition;
  if (position != null && position > 0) {
    parts.add('排队第 $position 位');
  }

  final seconds = thread.estimatedWaitSeconds;
  if (seconds == null) {
    parts.add('预计等待 --');
  } else if (seconds >= 60) {
    parts.add('预计等待 ${seconds ~/ 60} 分钟');
  } else {
    parts.add('预计等待 $seconds 秒');
  }
  return parts;
}
