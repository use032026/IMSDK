import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:im_sdk/features/kyc/application/kyc_submission_service.dart';

enum KycPhotoSource { camera, gallery }

class KycPhotoPicker {
  KycPhotoPicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker() {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final platform = ImagePickerPlatform.instance;
      if (platform is ImagePickerAndroid) {
        platform.useAndroidPhotoPicker = true;
      }
    }
  }

  final ImagePicker _picker;

  Future<KycPhoto?> pick(KycPhotoSource source) async {
    final file = await _picker.pickImage(
      source: source == KycPhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
    );
    if (file == null) return null;
    final extension = file.name.split('.').last.toLowerCase();
    final mediaType = switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'heic' => 'image/heic',
      'heif' => 'image/heif',
      'webp' => 'image/webp',
      _ => file.mimeType,
    };
    if (mediaType == null || !mediaType.startsWith('image/')) {
      throw const KycPhotoSelectionError();
    }
    return KycPhoto(
      path: file.path,
      sizeBytes: await file.length(),
      mediaType: mediaType,
      fileExtension: extension,
      temporary: source == KycPhotoSource.camera,
    );
  }

  Future<void> discard(KycPhoto? photo) async {
    if (photo?.temporary != true) return;
    try {
      await File(photo!.path).delete();
    } on FileSystemException {
      // The picker or OS may already have removed its temporary file.
    }
  }
}

class KycPhotoSelectionError implements Exception {
  const KycPhotoSelectionError();
}
