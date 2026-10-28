import 'package:im_sdk/features/chat/domain/entities/bulk_send.dart';

typedef BulkSendTargetCommand = Future<void> Function(
  BulkSendTarget target,
  String content,
);
typedef BulkSendErrorText = String Function(Object error);
typedef BulkSendResultListener = void Function(BulkSendItemResult result);

class BulkSendController {
  final BulkSendTargetCommand _sendTarget;
  final BulkSendErrorText _errorText;

  const BulkSendController({
    required BulkSendTargetCommand sendTarget,
    required BulkSendErrorText errorText,
  })  : _sendTarget = sendTarget,
        _errorText = errorText;

  Future<BulkSendSummary> send({
    required List<BulkSendTarget> targets,
    required String content,
    BulkSendResultListener? onResult,
  }) async {
    final normalizedContent = content.trim();
    if (normalizedContent.isEmpty) {
      throw ArgumentError.value(content, 'content', '请输入群发内容');
    }
    if (targets.isEmpty) {
      throw ArgumentError.value(targets, 'targets', '请选择群发对象');
    }

    var successCount = 0;
    var failedCount = 0;
    for (final target in targets) {
      onResult?.call(BulkSendItemResult(
        targetId: target.id,
        status: BulkSendStatus.sending,
      ));
      try {
        await _sendTarget(target, normalizedContent);
        successCount += 1;
        onResult?.call(BulkSendItemResult(
          targetId: target.id,
          status: BulkSendStatus.success,
          message: '已发送',
        ));
      } catch (error) {
        failedCount += 1;
        onResult?.call(BulkSendItemResult(
          targetId: target.id,
          status: BulkSendStatus.failed,
          message: _errorText(error),
        ));
      }
    }
    return BulkSendSummary(
      successCount: successCount,
      failedCount: failedCount,
    );
  }

  List<BulkSendTarget> failedTargets(
    List<BulkSendTarget> targets,
    Map<String, BulkSendItemResult> results,
  ) {
    return targets
        .where((target) => results[target.id]?.status == BulkSendStatus.failed)
        .toList(growable: false);
  }
}
