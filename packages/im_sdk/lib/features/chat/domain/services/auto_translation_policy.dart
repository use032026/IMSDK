import 'package:im_sdk/features/chat/domain/entities/message.dart';

/// Domain rules shared by manual and automatic message translation.
class AutoTranslationPolicy {
  const AutoTranslationPolicy();

  static const supportedTargetLanguages = <String>{
    'zh-CN',
    'zh-TW',
    'en',
    'ja',
    'ko',
    'vi',
    'es',
    'fr',
    'de',
    'ru',
    'ar',
  };

  String normalizeTargetLanguage(String value, {String fallback = 'zh-CN'}) {
    final normalized = value.trim();
    return supportedTargetLanguages.contains(normalized)
        ? normalized
        : fallback;
  }

  bool isTranslatable(Message message) {
    return message.type == MessageType.text ||
        message.type == MessageType.markdown;
  }

  bool hasTranslationForTarget(Message message, String targetLanguage) {
    return message.translation?.trim().isNotEmpty == true &&
        message.translationLanguage == normalizeTargetLanguage(targetLanguage);
  }

  bool shouldTranslate({
    required Message message,
    required String targetLanguage,
    required String currentUserId,
  }) {
    if (message.messageId.trim().isEmpty ||
        !isTranslatable(message) ||
        message.status == MessageStatus.deletedLocal ||
        message.isRecalled ||
        message.isTranslating ||
        message.isSelf ||
        (currentUserId.isNotEmpty &&
            message.senderUserId.trim() == currentUserId.trim())) {
      return false;
    }
    return !hasTranslationForTarget(message, targetLanguage);
  }
}
