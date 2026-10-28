import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:im_sdk/features/chat/domain/services/chat_attachment_policy.dart';

enum ChatAttachmentPickFailure { unsupportedType, tooLarge, unavailable }

class ChatAttachmentPickException implements Exception {
  final ChatAttachmentPickFailure failure;
  final ChatFileAttachmentRejection? rejection;
  final String extension;

  const ChatAttachmentPickException(
    this.failure, {
    this.rejection,
    this.extension = '',
  });
}

class ChatPickedLocalFile {
  final String path;
  final String name;
  final String? mimeType;
  final int sizeBytes;

  const ChatPickedLocalFile({
    required this.path,
    required this.name,
    required this.mimeType,
    required this.sizeBytes,
  });
}

abstract interface class ChatAttachmentPicker {
  Future<List<ChatPickedLocalFile>> pickMedia();

  Future<ChatPickedLocalFile?> pickFallbackImage();

  Future<ChatPickedLocalFile?> pickDocument();
}

class PlatformChatAttachmentPicker implements ChatAttachmentPicker {
  static const _androidDocumentChannel = MethodChannel(
    'im_sdk/chat_attachment_picker',
  );

  final ImagePicker _imagePicker;

  PlatformChatAttachmentPicker({ImagePicker? imagePicker})
      : _imagePicker = imagePicker ?? ImagePicker() {
    _enableAndroidSystemPhotoPicker();
  }

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  void _enableAndroidSystemPhotoPicker() {
    if (!_isAndroid) return;
    final platform = ImagePickerPlatform.instance;
    if (platform is ImagePickerAndroid) {
      platform.useAndroidPhotoPicker = true;
    }
  }

  @override
  Future<List<ChatPickedLocalFile>> pickMedia() async {
    final files = await _imagePicker.pickMultipleMedia();
    return Future.wait(files.map(_fromXFile));
  }

  @override
  Future<ChatPickedLocalFile?> pickFallbackImage() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    return file == null ? null : _fromXFile(file);
  }

  @override
  Future<ChatPickedLocalFile?> pickDocument() async {
    if (_isAndroid) return _pickAndroidDocument();
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.single;
    final path = file.path;
    if (path == null || path.trim().isEmpty) {
      throw const ChatAttachmentPickException(
        ChatAttachmentPickFailure.unavailable,
      );
    }
    final localFile = File(path);
    late final int sizeBytes;
    try {
      if (!await localFile.exists()) {
        throw const ChatAttachmentPickException(
          ChatAttachmentPickFailure.unavailable,
        );
      }
      await localFile.openRead(0, 1).drain<void>();
      sizeBytes = await localFile.length();
    } on ChatAttachmentPickException {
      rethrow;
    } catch (_) {
      throw const ChatAttachmentPickException(
        ChatAttachmentPickFailure.unavailable,
      );
    }
    final picked = ChatPickedLocalFile(
      path: path,
      name: file.name,
      mimeType: null,
      sizeBytes: sizeBytes,
    );
    _validateDocumentOrThrow(picked);
    return picked;
  }

  Future<ChatPickedLocalFile?> _pickAndroidDocument() async {
    try {
      final result = await _androidDocumentChannel
          .invokeMapMethod<String, Object?>('pickDocument', {
        'allowedExtensions': chatFileAttachmentAllowedExtensions,
        'blockedMimeTypes': chatFileAttachmentBlockedMimeTypes,
        'maxSizeBytes': chatFileAttachmentMaxSizeBytes,
      });
      if (result == null) return null;
      return ChatPickedLocalFile(
        path: result['path']! as String,
        name: result['name']! as String,
        mimeType: result['mimeType'] as String?,
        sizeBytes: (result['sizeBytes']! as num).toInt(),
      );
    } on PlatformException catch (error) {
      final failure = switch (error.code) {
        'UNSUPPORTED_FILE_TYPE' => ChatAttachmentPickFailure.unsupportedType,
        'FILE_TOO_LARGE' => ChatAttachmentPickFailure.tooLarge,
        _ => ChatAttachmentPickFailure.unavailable,
      };
      final details = error.details is Map
          ? Map<Object?, Object?>.from(error.details as Map)
          : const <Object?, Object?>{};
      final reason = switch (details['reason']) {
        'media_use_photos' => ChatFileAttachmentRejection.mediaUsePhotos,
        'unrecognized_type' => ChatFileAttachmentRejection.unrecognizedType,
        'unsupported_type' => ChatFileAttachmentRejection.unsupportedType,
        'type_mismatch' => ChatFileAttachmentRejection.typeMismatch,
        _ => null,
      };
      throw ChatAttachmentPickException(
        failure,
        rejection: reason,
        extension:
            (details['extension'] as String?)?.trim().toLowerCase() ?? '',
      );
    }
  }

  void _validateDocumentOrThrow(ChatPickedLocalFile file) {
    final validation = validateChatFileAttachment(
      fileName: file.name,
      mimeType: file.mimeType,
      sizeBytes: file.sizeBytes,
    );
    final rejection = validation.rejection;
    if (rejection == null) return;
    final failure = switch (rejection) {
      ChatFileAttachmentRejection.tooLarge =>
        ChatAttachmentPickFailure.tooLarge,
      _ => ChatAttachmentPickFailure.unsupportedType,
    };
    throw ChatAttachmentPickException(
      failure,
      rejection: rejection,
      extension: validation.extension,
    );
  }

  Future<ChatPickedLocalFile> _fromXFile(XFile file) async {
    return ChatPickedLocalFile(
      path: file.path,
      name: file.name,
      mimeType: file.mimeType,
      sizeBytes: await file.length(),
    );
  }
}
