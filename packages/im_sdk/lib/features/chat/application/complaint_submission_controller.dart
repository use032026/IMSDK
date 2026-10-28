import 'package:im_sdk/features/profile/domain/entities/profile_entities.dart';
import 'package:im_sdk/features/profile/domain/repositories/profile_repositories.dart';

class ComplaintSubmissionController {
  ComplaintSubmissionController(this._repository);

  final ProfileRepository _repository;

  Future<FeedbackResult> submit({
    required String reason,
    String? subjectType,
    String? subjectId,
  }) {
    final normalizedReason = reason.trim();
    if (normalizedReason.isEmpty) {
      throw ArgumentError.value(reason, 'reason', 'must not be empty');
    }

    final normalizedType = subjectType?.trim() ?? '';
    final normalizedId = subjectId?.trim() ?? '';
    final content = <String>[
      '投诉原因：$normalizedReason',
      if (normalizedType.isNotEmpty) '投诉对象类型：$normalizedType',
      if (normalizedId.isNotEmpty) '投诉对象ID：$normalizedId',
    ].join('\n');

    return _repository.submitFeedback(
      FeedbackRequest(type: 'complaint', content: content),
    );
  }
}
