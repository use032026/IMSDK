import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/features/chat/presentation/models/translation_language_options.dart';
import 'package:im_sdk/features/settings/presentation/pages/legal_document_page.dart';
import 'package:im_sdk/generated/l10n/sdk_resources.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:im_sdk/sdk/im_sdk_presentation.dart';

Future<String> _text(
  WidgetTester tester,
  Locale locale,
  String source, {
  bool error = false,
}) async {
  String? result;
  await tester.pumpWidget(MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Builder(builder: (context) {
      result = error ? sdkErrorText(context, source) : sdkText(context, source);
      return const SizedBox.shrink();
    }),
  ));
  await tester.pumpAndSettle();
  return result!;
}

void main() {
  test('shared localization delegate loads all 35 selected locales', () async {
    const expectedLocaleTags = {
      'zh',
      'zh-TW',
      'en',
      'ja',
      'ko',
      'vi',
      'ar',
      'bg',
      'cs',
      'da',
      'de',
      'el',
      'es',
      'fi',
      'fil',
      'fr',
      'hi',
      'hr',
      'hu',
      'id',
      'it',
      'ms',
      'nb',
      'nl',
      'pl',
      'pt',
      'pt-PT',
      'ro',
      'ru',
      'si',
      'sk',
      'sv',
      'th',
      'tr',
      'uk',
    };
    expect(
      AppLocalizations.supportedLocales.map((locale) => locale.toLanguageTag()),
      unorderedEquals(expectedLocaleTags),
    );
    for (final locale in AppLocalizations.supportedLocales) {
      final text = await AppLocalizations.delegate.load(locale);
      expect(text.localeName, locale.toString(), reason: '$locale');
      expect(text.commonRetry, isNotEmpty, reason: '$locale');
      expect(
        text.chatReadCount(3),
        allOf(contains('3'), isNot(contains('{count}'))),
        reason: '$locale must format the typed count parameter',
      );
    }
  });

  testWidgets('SDK-owned wording survives extraction in all six languages',
      (tester) async {
    for (final sample in [
      (const Locale('zh'), '客服'),
      (const Locale('zh', 'TW'), '客服'),
      (const Locale('en'), 'Customer support'),
      (const Locale('ja'), 'サポート'),
      (const Locale('ko'), '고객 지원'),
      (const Locale('vi'), 'Hỗ trợ khách hàng'),
    ]) {
      expect(await _text(tester, sample.$1, '客服'), sample.$2);
    }
  });

  testWidgets('unknown SDK errors keep the existing safe localized fallback',
      (tester) async {
    const privateError = 'private backend response must not reach the UI';
    expect(await _text(tester, const Locale('zh'), privateError, error: true),
        '操作失败，请重试');
    expect(await _text(tester, const Locale('en'), privateError, error: true),
        'Unable to complete. Please try again.');
  });

  testWidgets('shared ARB aliases still take precedence over SDK source text',
      (tester) async {
    expect(await _text(tester, const Locale('en'), '正在加载…'), 'Loading...');
    expect(await _text(tester, const Locale('en'), '验证码已发送'), 'Code sent');
  });

  testWidgets('new German locale uses the reviewed shared message mapping',
      (tester) async {
    expect(await _text(tester, const Locale('de'), '登录'), 'Anmelden');
  });

  testWidgets('new German locale keeps English for unmapped SDK wording',
      (tester) async {
    expect(await _text(tester, const Locale('de'), '客服'), 'Customer support');
  });

  test('target language names retain device-language and English fallback', () {
    expect(translationTargetNativeNames.length, 11);
    expect(translationTargetOptionLabel('es', const Locale('es')),
        'Español(español)');
    expect(translationTargetOptionLabel('ja', const Locale('it')),
        '日本語(Japanese)');
    expect(translationTargetOptionLabel('zh-TW', const Locale('zh', 'HK')),
        '繁體中文(繁體中文)');
    expect(translationTargetOptionLabel('unknown', const Locale('en')),
        'unknown(unknown)');
  });

  test('file message resources preserve Simplified Chinese fallback and token',
      () {
    final messages = sdkFileAttachmentMessages['unsupportedExtension']!;
    expect(messages.containsKey('zh_TW'), isFalse);
    expect(messages['zh']!.replaceAll('{extension}', 'pdf'), '暂不支持发送 .pdf 文件');
    expect(messages['en']!.replaceAll('{extension}', 'pdf'),
        '.pdf files are not supported yet');
  });

  test('legal resources preserve platform-specific and translated documents',
      () {
    expect(termsLegalDocumentZh.appBarTitle, '用户协议');
    expect(privacyLegalDocumentAndroidZh.blocks.length, greaterThan(100));
    expect(termsLegalDocumentEn.appBarTitle, 'Terms of Service');
    expect(termsLegalDocumentZhTw.blocks.first.text, '微界使用者服務協議');
    expect(termsLegalDocumentJa.blocks, isNotEmpty);
    expect(termsLegalDocumentKo.blocks, isNotEmpty);
    expect(termsLegalDocumentVi.blocks, isNotEmpty);
    expect(officialLegalLanguageCodeForLocale(const Locale('zh', 'TW')),
        'zh-hant');
  });
}
