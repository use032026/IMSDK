import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/chat/application/complaint_submission_controller.dart';
import 'package:im_sdk/features/profile/presentation/providers/profile_providers.dart';

final complaintSubmissionControllerProvider =
    Provider<ComplaintSubmissionController>((ref) {
  return ComplaintSubmissionController(ref.watch(profileRepositoryProvider));
}, dependencies: [profileRepositoryProvider]);
