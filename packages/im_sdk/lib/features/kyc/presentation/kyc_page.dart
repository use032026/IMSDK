import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/di/injector.dart' show currentSpaceProvider;
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/kyc/application/kyc_submission_service.dart';
import 'package:im_sdk/features/kyc/domain/kyc_models.dart';
import 'package:im_sdk/features/kyc/infrastructure/kyc_photo_picker.dart';
import 'package:im_sdk/features/kyc/presentation/kyc_providers.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class KycPage extends ConsumerStatefulWidget {
  const KycPage({super.key});

  @override
  ConsumerState<KycPage> createState() => _KycPageState();
}

class _KycPageState extends ConsumerState<KycPage> {
  late final KycPhotoPicker _photoPicker;
  final _name = TextEditingController();
  final _number = TextEditingController();
  int? _selectedType;
  KycPhoto? _front;
  KycPhoto? _back;
  bool _agreed = false;
  bool _submitting = false;
  String? _feedback;
  bool _hasLoadedOnEntry = false;
  int _draftVersion = 0;
  BuildContext? _previewContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedOnEntry) return;
    _hasLoadedOnEntry = true;
    _photoPicker = ref.read(kycPhotoPickerProvider);
    // Config is deliberately refreshed every time this route is opened.
    ref.invalidate(kycConfigProvider);
    ref.invalidate(kycSnapshotProvider);
  }

  @override
  void dispose() {
    _releasePhoto(_front);
    _releasePhoto(_back);
    _name.dispose();
    _number.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto({required bool front}) async {
    final l10n = AppLocalizations.of(context);
    final draftVersion = _draftVersion;
    final source = await showModalBottomSheet<KycPhotoSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.kycCamera),
              onTap: () => Navigator.pop(sheetContext, KycPhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.kycGallery),
              onTap: () => Navigator.pop(sheetContext, KycPhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    try {
      final photo = await _photoPicker.pick(source);
      if (photo == null) return;
      if (!mounted || draftVersion != _draftVersion) {
        _releasePhoto(photo);
        return;
      }
      final maxBytes =
          ref.read(kycSnapshotProvider).valueOrNull?.config.maxImageBytes;
      if (maxBytes != null && photo.sizeBytes > maxBytes) {
        _releasePhoto(photo);
        _showMessage(l10n.kycPhotoTooLarge);
        return;
      }
      final previous = front ? _front : _back;
      if (previous?.path != photo.path) {
        _releasePhoto(previous);
      }
      setState(() {
        if (front) {
          _front = photo;
        } else {
          _back = photo;
        }
        _feedback = null;
      });
    } catch (_) {
      if (!mounted) return;
      _showMessage(l10n.kycPhotoInvalid);
    }
  }

  void _releasePhoto(KycPhoto? photo) {
    if (photo == null) return;
    unawaited(FileImage(File(photo.path)).evict());
    unawaited(_photoPicker.discard(photo));
  }

  Future<void> _showDocumentTypes(
    List<KycIdType> types,
    int? selectedType,
    AppLocalizations l10n,
  ) async {
    final draftVersion = _draftVersion;
    final value = await showCupertinoModalPopup<int>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(l10n.kycIdType),
        actions: [
          for (final type in types)
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(sheetContext, type.idType),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text(type.name)),
                  if (type.idType == selectedType) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, size: 18),
                  ],
                ],
              ),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(sheetContext),
          child: Text(l10n.commonCancel),
        ),
      ),
    );
    if (!mounted ||
        draftVersion != _draftVersion ||
        value == null ||
        value == selectedType) {
      return;
    }
    _changeType(value);
  }

  Future<void> _previewPhoto(
    KycPhoto photo,
    String label,
    AppLocalizations l10n,
  ) async {
    BuildContext? dialogContext;
    await showDialog<void>(
      context: context,
      builder: (context) {
        dialogContext = context;
        _previewContext = context;
        return Dialog.fullscreen(
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(label),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              leading: IconButton(
                tooltip: l10n.commonClose,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.file(
                  File(photo.path),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Text(
                    l10n.kycPhotoInvalid,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    if (_previewContext == dialogContext) _previewContext = null;
  }

  void _closePreview() {
    final previewContext = _previewContext;
    if (previewContext == null || !previewContext.mounted) return;
    final route = ModalRoute.of(previewContext);
    if (route != null) Navigator.of(previewContext).removeRoute(route);
    _previewContext = null;
  }

  void _removePhoto({required bool front}) {
    final photo = front ? _front : _back;
    if (photo == null || _submitting) return;
    _draftVersion++;
    setState(() {
      if (front) {
        _front = null;
      } else {
        _back = null;
      }
      _feedback = null;
    });
    _releasePhoto(photo);
  }

  Future<void> _submit(KycSnapshot snapshot) async {
    if (_submitting) return;
    final profile = snapshot.profile;
    final l10n = AppLocalizations.of(context);
    if (!_agreed) {
      _showMessage(l10n.kycConsentRequired);
      return;
    }
    if (profile?.reviewState == KycReviewState.pending) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AppAlertDialog(
          title: Text(l10n.kycResubmitTitle),
          content: Text(l10n.kycResubmitWarning),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.commonConfirm),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    setState(() {
      _submitting = true;
      _feedback = null;
    });
    try {
      final result = await ref.read(kycSubmissionServiceProvider).submit(
            snapshot.config,
            KycSubmitDraft(
              realName: _name.text,
              idNumber: _number.text,
              idType: _selectedType ??
                  snapshot.config.supportedIdTypes.first.idType,
              frontPhoto: _front,
              backPhoto: _back,
            ),
          );
      if (!mounted) return;
      setState(() => _feedback = _resultText(result, l10n));
      if (result.reviewState == KycReviewState.rejected) {
        setState(() => _agreed = false);
      } else {
        _name.clear();
        _number.clear();
        _draftVersion++;
        _releasePhoto(_front);
        _releasePhoto(_back);
        setState(() {
          _front = null;
          _back = null;
          _agreed = false;
        });
      }
      ref.invalidate(kycSnapshotProvider);
    } catch (error) {
      if (!mounted) return;
      setState(() => _feedback = _errorText(error, l10n));
      if (error is ServerError &&
          const {
            'KYC_DISABLED',
            'KYC_ID_TYPE_UNSUPPORTED',
            'KYC_FRONT_IMAGE_REQUIRED',
            'KYC_BACK_IMAGE_REQUIRED',
            'KYC_MEDIA_TOO_LARGE',
          }.contains(error.code)) {
        ref.invalidate(kycConfigProvider);
      }
      if (error is ServerError && error.code == 'KYC_ID_TYPE_UNSUPPORTED') {
        _draftVersion++;
        _releasePhoto(_front);
        _releasePhoto(_back);
        setState(() {
          _selectedType = null;
          _front = null;
          _back = null;
        });
      }
      if (error is ServerError && error.code == 'KYC_MEDIA_NOT_FOUND') {
        _draftVersion++;
        _releasePhoto(_front);
        _releasePhoto(_back);
        setState(() {
          _front = null;
          _back = null;
          _feedback = l10n.kycMediaNotFound;
        });
      }
      // A timeout or failed response may follow a successful server write.
      // Refresh before allowing a new draft to become a new request key.
      if (error is AppError) {
        ref.invalidate(kycSnapshotProvider);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _changeType(int? value) {
    if (value == null || value == _selectedType) return;
    _draftVersion++;
    _releasePhoto(_front);
    _releasePhoto(_back);
    setState(() {
      _selectedType = value;
      _front = null;
      _back = null;
      _feedback = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(activeAccountSessionProvider, (previous, next) {
      if (previous?.sessionId == next?.sessionId) return;
      _clearDraft();
    });
    ref.listen(currentSpaceProvider, (previous, next) {
      if (previous?.spaceId == next?.spaceId) return;
      _clearDraft();
    });
    // Keep the attempt owner alive for this page, including explicit retries.
    ref.watch(kycSubmissionServiceProvider);
    final snapshot = ref.watch(kycSnapshotProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.kycTitle)),
      body: snapshot.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: TextButton(
            onPressed: () {
              ref.invalidate(kycConfigProvider);
              ref.invalidate(kycSnapshotProvider);
            },
            child: Text('${l10n.commonLoadFailed} · ${l10n.commonRetry}'),
          ),
        ),
        data: (value) => _content(value, l10n),
      ),
    );
  }

  void _clearDraft() {
    _closePreview();
    _draftVersion++;
    _releasePhoto(_front);
    _releasePhoto(_back);
    _name.clear();
    _number.clear();
    setState(() {
      _selectedType = null;
      _front = null;
      _back = null;
      _agreed = false;
      _feedback = null;
    });
  }

  Widget _content(KycSnapshot snapshot, AppLocalizations l10n) {
    final config = snapshot.config;
    final profile = snapshot.profile;
    if (!config.enabled || profile?.notRequired == true) {
      return Center(child: Text(l10n.kycNotRequired));
    }
    final canSubmit =
        profile?.canSubmit == true && config.supportedIdTypes.isNotEmpty;
    final selectedType = config.supportedIdTypes.any(
      (type) => type.idType == _selectedType,
    )
        ? _selectedType!
        : config.supportedIdTypes.firstOrNull?.idType;
    final type = config.supportedIdTypes
        .where((item) => item.idType == selectedType)
        .firstOrNull;
    final color = Theme.of(context).colorScheme;
    final declared = profile?.reviewState == KycReviewState.declared;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (profile != null && profile.reviewState != KycReviewState.none) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _statusText(profile, l10n),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (profile.realNameMasked != null) ...[
                    const SizedBox(height: 8),
                    Text('${l10n.kycRealName}: ${profile.realNameMasked}'),
                  ],
                  if (profile.idTypeName != null)
                    Text('${l10n.kycIdType}: ${profile.idTypeName}'),
                  if (profile.idNumberMasked != null)
                    Text('${l10n.kycIdNumber}: ${profile.idNumberMasked}'),
                  if (profile.reviewNote != null) ...[
                    const SizedBox(height: 8),
                    Text(profile.reviewNote!),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (_feedback != null &&
            !(declared && _feedback == l10n.kycDeclared)) ...[
          Text(_feedback!, style: TextStyle(color: color.primary)),
          const SizedBox(height: 12),
        ],
        if (!canSubmit) ...[
          if (!(declared && profile?.cannotSubmitReason == 'already_approved'))
            Text(_cannotSubmitText(profile, config, l10n)),
        ] else ...[
          Text(l10n.kycApplicability,
              style: TextStyle(color: color.onSurfaceVariant)),
          const SizedBox(height: 18),
          InkWell(
            onTap: _submitting
                ? null
                : () => _showDocumentTypes(
                      config.supportedIdTypes,
                      selectedType,
                      l10n,
                    ),
            borderRadius: BorderRadius.circular(4),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.kycIdType,
                border: const OutlineInputBorder(),
                enabled: !_submitting,
              ),
              child: Row(
                children: [
                  Expanded(
                    child:
                        Text(type?.name ?? '', overflow: TextOverflow.ellipsis),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _name,
            enabled: !_submitting,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n.kycRealName,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _number,
            enabled: !_submitting,
            keyboardType: TextInputType.visiblePassword,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: l10n.kycIdNumber,
              hintText: type?.placeholder,
              border: const OutlineInputBorder(),
            ),
          ),
          if (config.requireFrontImage) ...[
            const SizedBox(height: 12),
            _photoTile(
              label: _frontLabel(type, l10n),
              photo: _front,
              onPressed: () => _pickPhoto(front: true),
              onRemove: () => _removePhoto(front: true),
              l10n: l10n,
            ),
          ],
          if (config.requireBackImage) ...[
            const SizedBox(height: 12),
            _photoTile(
              label: _backLabel(type, l10n),
              photo: _back,
              onPressed: () => _pickPhoto(front: false),
              onRemove: () => _removePhoto(front: false),
              l10n: l10n,
            ),
          ],
          if (config.requireFrontImage || config.requireBackImage) ...[
            const SizedBox(height: 6),
            Text(
              '${l10n.kycPhotoLimit} ${config.maxImageBytes ~/ (1024 * 1024)} MB',
              style: TextStyle(color: color.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 14),
          Text(l10n.kycDisclosure,
              style: TextStyle(color: color.onSurfaceVariant)),
          TextButton(
            onPressed: () => context.push('/privacy'),
            child: Text(l10n.privacyPolicyTitle),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _agreed,
            onChanged: _submitting
                ? null
                : (value) => setState(() => _agreed = value == true),
            title: Text(l10n.kycConsent),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _submitting ? null : () => _submit(snapshot),
            child: Text(_submitting ? l10n.kycSubmitting : l10n.commonSubmit),
          ),
        ],
      ],
    );
  }

  Widget _photoTile({
    required String label,
    required KycPhoto? photo,
    required VoidCallback onPressed,
    required VoidCallback onRemove,
    required AppLocalizations l10n,
  }) {
    if (photo == null) {
      return OutlinedButton.icon(
        onPressed: _submitting ? null : onPressed,
        icon: const Icon(Icons.add_a_photo_outlined),
        label: Text('$label · ${l10n.kycSelectPhoto}'),
      );
    }
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Image.file(
          File(photo.path),
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.image_outlined),
        ),
        title: Text(label),
        subtitle: Text(l10n.kycViewPhoto),
        onTap: _submitting ? null : () => _previewPhoto(photo, label, l10n),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: l10n.kycReplacePhoto,
              onPressed: _submitting ? null : onPressed,
              icon: const Icon(Icons.autorenew),
            ),
            IconButton(
              tooltip: '${l10n.commonDelete} $label',
              onPressed: _submitting ? null : onRemove,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }

  String _statusText(KycProfile profile, AppLocalizations l10n) =>
      switch (profile.reviewState) {
        KycReviewState.verified => l10n.kycVerified,
        KycReviewState.declared => l10n.kycDeclared,
        KycReviewState.pending => l10n.kycPending,
        KycReviewState.rejected => l10n.kycRejected,
        KycReviewState.superseded => l10n.kycSuperseded,
        KycReviewState.none => l10n.kycNone,
        _ => l10n.kycStatusUnknown,
      };

  String _resultText(KycSubmissionResult result, AppLocalizations l10n) =>
      switch (result.reviewState) {
        KycReviewState.verified => l10n.kycVerified,
        KycReviewState.declared => l10n.kycDeclared,
        KycReviewState.pending => l10n.kycPending,
        KycReviewState.rejected => result.reviewNote ?? l10n.kycRejected,
        KycReviewState.superseded => l10n.kycSuperseded,
        _ => l10n.kycStatusUnknown,
      };

  String _cannotSubmitText(
    KycProfile? profile,
    KycConfig config,
    AppLocalizations l10n,
  ) {
    if (config.supportedIdTypes.isEmpty) return l10n.kycTypeUnavailable;
    return switch (profile?.cannotSubmitReason) {
      'kyc_disabled' => l10n.kycNotRequired,
      'already_approved' => _statusText(profile!, l10n),
      'resubmit_not_allowed' => l10n.kycResubmitNotAllowed,
      'daily_limit_reached' => l10n.kycDailyLimit,
      _ => l10n.kycSubmitUnavailable,
    };
  }

  String _errorText(Object error, AppLocalizations l10n) {
    if (error is KycInputError) {
      return switch (error.problem) {
        KycInputProblem.disabled => l10n.kycNotRequired,
        KycInputProblem.invalidName => l10n.kycNameInvalid,
        KycInputProblem.missingNumber => l10n.kycNumberRequired,
        KycInputProblem.unsupportedType => l10n.kycTypeUnavailable,
        KycInputProblem.missingFront => l10n.kycFrontRequired,
        KycInputProblem.missingBack => l10n.kycBackRequired,
        KycInputProblem.imageTooLarge => l10n.kycPhotoTooLarge,
        KycInputProblem.accountChanged => l10n.kycAccountChanged,
        KycInputProblem.busy => l10n.kycSubmitting,
      };
    }
    if (error is ServerError) {
      return error.code == 'KYC_INVALID_RESPONSE'
          ? l10n.kycSubmitFailed
          : error.message;
    }
    if (error is AppError) return ErrorHandler.localizedMessage(error, l10n);
    return l10n.kycSubmitFailed;
  }

  String _frontLabel(KycIdType? type, AppLocalizations l10n) =>
      switch (type?.code) {
        'mainland_id' || 'residence_permit' => l10n.kycPortraitSide,
        'passport' => l10n.kycPassportDataPage,
        _ => l10n.kycFront,
      };

  String _backLabel(KycIdType? type, AppLocalizations l10n) =>
      switch (type?.code) {
        'mainland_id' || 'residence_permit' => l10n.kycEmblemSide,
        'passport' => l10n.kycPassportOtherPage,
        _ => l10n.kycBack,
      };
}
