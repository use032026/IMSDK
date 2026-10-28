import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/features/chat/application/auto_translation_coordinator.dart';

final translationRepositoryProvider = Provider<TranslationRepository>(
  (ref) => TranslationRepository(ref.watch(dioProvider)),
  dependencies: [dioProvider],
);

/// HTTP and response boundary shared by received-message and draft translation.
class TranslationRepository {
  const TranslationRepository(this._dio);

  final Dio _dio;

  Future<String?> translateMessage({
    required String messageId,
    required String targetLanguage,
    String model = 'fast',
    CancelToken? cancelToken,
  }) =>
      _translate(
        '/api/client/v1/translate/message',
        {
          'messageId': messageId,
          'targetLanguage': targetLanguage,
          'model': model,
        },
        cancelToken,
        allowLegacyResult: true,
      );

  Future<String?> translateDraft({
    required String content,
    required String targetLanguage,
    required AutoTranslationCancellation cancellation,
  }) {
    final cancelToken = CancelToken();
    cancellation.onCancel(() => cancelToken.cancel());
    return _translate(
      '/api/client/v1/translate/text',
      {
        'content': content,
        'targetLanguage': targetLanguage,
        'model': 'fast',
      },
      cancelToken,
    );
  }

  Future<String?> _translate(
    String path,
    Map<String, String> payload,
    CancelToken? cancelToken, {
    bool allowLegacyResult = false,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: payload,
      cancelToken: cancelToken,
    );
    final body = response.data;
    if (body == null) throw StateError('EMPTY_RESPONSE: Empty API response');
    final code = body['code'];
    if (code is String && code.isNotEmpty && code != 'OK') {
      throw StateError('$code: ${body['message'] ?? code}');
    }
    final data = body['data'];
    if (!allowLegacyResult &&
        (data is! Map || data['translatedText'] is! String)) {
      throw StateError('TRANSLATION_CONTRACT_MISSING_TEXT');
    }
    Object? value = data is Map ? data['translatedText'] : null;
    if (allowLegacyResult) {
      if (data is Map) {
        value ??= data['translation'] ??
            data['text'] ??
            data['content'] ??
            data['result'];
      } else if (data is String) {
        value = data;
      }
      value ??= body['translatedText'] ??
          body['translation'] ??
          body['text'] ??
          body['content'] ??
          body['result'];
    }
    if (value is! String) return null;
    final text = value.trim();
    return text.isEmpty ? null : text;
  }
}
