import 'package:im_sdk/features/kyc/domain/kyc_models.dart';

abstract interface class KycRepository {
  Future<KycConfig> getConfig();
  Future<KycProfile> getMe();
  Future<String> uploadEvidence({
    required String path,
    required String mediaType,
    required String fileExtension,
  });
  Future<KycSubmissionResult> submit({
    required String realName,
    required String idNumber,
    required int idType,
    required String clientRequestId,
    String? frontMediaId,
    String? backMediaId,
  });
}
