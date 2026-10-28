import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/kyc/application/kyc_submission_service.dart';
import 'package:im_sdk/features/kyc/data/kyc_repository_impl.dart';
import 'package:im_sdk/features/kyc/domain/kyc_models.dart';
import 'package:im_sdk/features/kyc/domain/kyc_repository.dart';
import 'package:im_sdk/features/kyc/infrastructure/kyc_photo_picker.dart';

class KycSnapshot {
  const KycSnapshot({required this.config, this.profile});

  final KycConfig config;
  final KycProfile? profile;
}

final kycRepositoryProvider = Provider<KycRepository>((ref) {
  return KycRepositoryImpl(ref.watch(dioProvider));
}, dependencies: [dioProvider]);

final kycConfigProvider = FutureProvider.autoDispose<KycConfig>((ref) async {
  final session = ref.watch(activeAccountSessionProvider);
  final spaceId = ref.watch(currentSpaceProvider)?.spaceId;
  if (session == null || spaceId == null || session.scope.spaceId != spaceId) {
    throw const KycInputError(KycInputProblem.accountChanged);
  }
  return ref.watch(kycRepositoryProvider).getConfig();
}, dependencies: [
  activeAccountSessionProvider,
  currentSpaceProvider,
  kycRepositoryProvider,
]);

final kycSnapshotProvider =
    FutureProvider.autoDispose<KycSnapshot>((ref) async {
  final config = await ref.watch(kycConfigProvider.future);
  if (!config.enabled) return KycSnapshot(config: config);
  final profile = await ref.watch(kycRepositoryProvider).getMe();
  return KycSnapshot(config: config, profile: profile);
}, dependencies: [kycConfigProvider, kycRepositoryProvider]);

final kycSubmissionServiceProvider =
    Provider.autoDispose<KycSubmissionService>((ref) {
  final session = ref.watch(activeAccountSessionProvider);
  final spaceId = ref.watch(currentSpaceProvider)?.spaceId;
  return KycSubmissionService(
    ref.watch(kycRepositoryProvider),
    () =>
        session != null &&
        spaceId != null &&
        session.scope.spaceId == spaceId &&
        ref.read(activeAccountSessionProvider)?.sessionId ==
            session.sessionId &&
        ref.read(currentSpaceProvider)?.spaceId == spaceId,
  );
}, dependencies: [
  activeAccountSessionProvider,
  currentSpaceProvider,
  kycRepositoryProvider,
]);

final kycPhotoPickerProvider = Provider<KycPhotoPicker>((ref) {
  return KycPhotoPicker();
});
