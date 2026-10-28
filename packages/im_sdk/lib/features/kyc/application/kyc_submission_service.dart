import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/kyc/domain/kyc_models.dart';
import 'package:im_sdk/features/kyc/domain/kyc_repository.dart';
import 'package:uuid/uuid.dart';

class KycPhoto {
  const KycPhoto({
    required this.path,
    required this.sizeBytes,
    required this.mediaType,
    required this.fileExtension,
    this.temporary = false,
  });

  final String path;
  final int sizeBytes;
  final String mediaType;
  final String fileExtension;
  final bool temporary;
}

class KycSubmitDraft {
  const KycSubmitDraft({
    required this.realName,
    required this.idNumber,
    required this.idType,
    this.frontPhoto,
    this.backPhoto,
  });

  final String realName;
  final String idNumber;
  final int idType;
  final KycPhoto? frontPhoto;
  final KycPhoto? backPhoto;
}

enum KycInputProblem {
  disabled,
  invalidName,
  missingNumber,
  unsupportedType,
  missingFront,
  missingBack,
  imageTooLarge,
  accountChanged,
  busy,
}

class KycInputError implements Exception {
  const KycInputError(this.problem);
  final KycInputProblem problem;
}

class KycSubmissionService {
  KycSubmissionService(this._repository, this._isCurrent);

  final KycRepository _repository;
  final bool Function() _isCurrent;
  String? _draftFingerprint;
  String? _requestId;
  String? _frontMediaId;
  String? _backMediaId;
  bool _busy = false;

  Future<KycSubmissionResult> submit(
    KycConfig config,
    KycSubmitDraft draft,
  ) async {
    if (_busy) throw const KycInputError(KycInputProblem.busy);
    if (!_isCurrent()) {
      throw const KycInputError(KycInputProblem.accountChanged);
    }
    if (!config.enabled) throw const KycInputError(KycInputProblem.disabled);
    final realName = draft.realName.trim();
    final idNumber = draft.idNumber.trim();
    if (realName.runes.length < 2 || realName.runes.length > 64) {
      throw const KycInputError(KycInputProblem.invalidName);
    }
    if (idNumber.isEmpty) {
      throw const KycInputError(KycInputProblem.missingNumber);
    }
    if (!config.supportedIdTypes.any((type) => type.idType == draft.idType)) {
      throw const KycInputError(KycInputProblem.unsupportedType);
    }
    if (config.requireFrontImage && draft.frontPhoto == null) {
      throw const KycInputError(KycInputProblem.missingFront);
    }
    if (config.requireBackImage && draft.backPhoto == null) {
      throw const KycInputError(KycInputProblem.missingBack);
    }
    for (final photo in [draft.frontPhoto, draft.backPhoto]) {
      if (photo != null && photo.sizeBytes > config.maxImageBytes) {
        throw const KycInputError(KycInputProblem.imageTooLarge);
      }
    }

    final fingerprint = sha256
        .convert(utf8.encode([
          realName,
          idNumber,
          draft.idType,
          draft.frontPhoto?.path,
          draft.frontPhoto?.sizeBytes,
          draft.frontPhoto?.mediaType,
          draft.frontPhoto?.fileExtension,
          draft.backPhoto?.path,
          draft.backPhoto?.sizeBytes,
          draft.backPhoto?.mediaType,
          draft.backPhoto?.fileExtension,
        ].join('\u0000')))
        .toString();
    if (_draftFingerprint != fingerprint) {
      _draftFingerprint = fingerprint;
      _requestId = const Uuid().v4();
      _frontMediaId = null;
      _backMediaId = null;
    }

    _busy = true;
    try {
      if (draft.frontPhoto != null && _frontMediaId == null) {
        _frontMediaId = await _upload(draft.frontPhoto!);
      }
      if (draft.backPhoto != null && _backMediaId == null) {
        _backMediaId = await _upload(draft.backPhoto!);
      }
      _checkCurrent();
      Future<KycSubmissionResult> submitSameAttempt() => _repository.submit(
            realName: realName,
            idNumber: idNumber,
            idType: draft.idType,
            clientRequestId: _requestId!,
            frontMediaId: _frontMediaId,
            backMediaId: _backMediaId,
          );
      late final KycSubmissionResult result;
      try {
        result = await submitSameAttempt();
      } on ServerError catch (error) {
        if (error.code != 'DATABASE_CONFLICT') rethrow;
        _checkCurrent();
        result = await submitSameAttempt();
      }
      _checkCurrent();
      _clearAttempt();
      return result;
    } on ServerError catch (error) {
      if (error.code == 'KYC_MEDIA_NOT_FOUND') {
        // New photos change the request body; the old key must not be reused.
        _clearAttempt();
      }
      rethrow;
    } finally {
      _busy = false;
    }
  }

  Future<String> _upload(KycPhoto photo) async {
    _checkCurrent();
    final mediaId = await _repository.uploadEvidence(
      path: photo.path,
      mediaType: photo.mediaType,
      fileExtension: photo.fileExtension,
    );
    _checkCurrent();
    return mediaId;
  }

  void _checkCurrent() {
    if (!_isCurrent()) {
      throw const KycInputError(KycInputProblem.accountChanged);
    }
  }

  void _clearAttempt() {
    _draftFingerprint = null;
    _requestId = null;
    _frontMediaId = null;
    _backMediaId = null;
  }
}
