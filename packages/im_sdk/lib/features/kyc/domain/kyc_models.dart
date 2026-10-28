enum KycReviewState {
  none,
  pending,
  declared,
  verified,
  rejected,
  superseded,
  unknown,
}

KycReviewState _reviewState(String status, String assuranceLevel) =>
    switch (status) {
      'none' => KycReviewState.none,
      'pending' => KycReviewState.pending,
      'rejected' => KycReviewState.rejected,
      'superseded' => KycReviewState.superseded,
      'approved' when assuranceLevel == 'verified' => KycReviewState.verified,
      'approved' when assuranceLevel == 'declared' => KycReviewState.declared,
      _ => KycReviewState.unknown,
    };

class KycIdType {
  const KycIdType({
    required this.idType,
    required this.code,
    required this.name,
    required this.placeholder,
    required this.stronglyVerifiable,
  });

  final int idType;
  final String code;
  final String name;
  final String placeholder;
  final bool stronglyVerifiable;
}

class KycConfig {
  const KycConfig({
    required this.enabled,
    required this.reviewMode,
    required this.requireFrontImage,
    required this.requireBackImage,
    required this.allowResubmit,
    required this.assuranceLevel,
    required this.maxImageBytes,
    required this.supportedIdTypes,
    required this.gatedActions,
  });

  final bool enabled;
  final String reviewMode;
  final bool requireFrontImage;
  final bool requireBackImage;
  final bool allowResubmit;
  final String assuranceLevel;
  final int maxImageBytes;
  final List<KycIdType> supportedIdTypes;
  final Set<String> gatedActions;
}

class KycProfile {
  const KycProfile({
    required this.status,
    required this.notRequired,
    required this.assuranceLevel,
    required this.canSubmit,
    this.realNameMasked,
    this.idNumberMasked,
    this.decisionSource,
    this.idType,
    this.idTypeName,
    this.reviewNote,
    this.submittedAt,
    this.reviewedAt,
    this.cannotSubmitReason,
  });

  final String status;
  final bool notRequired;
  final String assuranceLevel;
  final bool canSubmit;
  final String? realNameMasked;
  final String? idNumberMasked;
  final String? decisionSource;
  final int? idType;
  final String? idTypeName;
  final String? reviewNote;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final String? cannotSubmitReason;

  KycReviewState get reviewState => _reviewState(status, assuranceLevel);
  bool get isVerified => reviewState == KycReviewState.verified;
}

class KycSubmissionResult {
  const KycSubmissionResult({
    required this.verificationId,
    required this.status,
    required this.decisionSource,
    required this.assuranceLevel,
    this.reviewNote,
  });

  final String verificationId;
  final String status;
  final String decisionSource;
  final String assuranceLevel;
  final String? reviewNote;

  KycReviewState get reviewState => _reviewState(status, assuranceLevel);
}
