import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/features/chat/data/repositories/translation_repository.dart';

final messageTranslationControllerProvider =
    Provider<MessageTranslationController>(
  (ref) => MessageTranslationController(ref.watch(dioProvider)),
  dependencies: [dioProvider],
);

class MessageTranslationController {
  final TranslationRepository _repository;

  MessageTranslationController(Dio dio)
      : _repository = TranslationRepository(dio);

  Future<String?> translateMessage({
    required String messageId,
    required String targetLanguage,
    String model = 'fast',
    CancelToken? cancelToken,
  }) =>
      _repository.translateMessage(
        messageId: messageId,
        targetLanguage: targetLanguage,
        model: model,
        cancelToken: cancelToken,
      );
}
