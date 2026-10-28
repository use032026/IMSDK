import 'package:im_sdk/core/storage/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kLocaleKey = 'app_locale';

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => resolveInitialLocale(
        WidgetsBinding.instance.platformDispatcher.locale,
      );

  Future<void> setLocale(Locale locale) async {
    final supportedLocale = supportedLocaleOrFallback(locale);
    state = supportedLocale;
    try {
      final box = HiveStorage.settingsBox;
      final key = supportedLocale.countryCode != null &&
              supportedLocale.countryCode!.isNotEmpty
          ? '${supportedLocale.languageCode}_${supportedLocale.countryCode}'
          : supportedLocale.languageCode;
      await box.put(_kLocaleKey, key);
    } catch (_) {}
  }
}

/// Resolves the device-wide locale from the persisted setting when available.
///
/// This synchronous resolver is also used by the pre-consent privacy shell, so
/// that shell and the authorized application cannot start in different
/// languages. The caller may invoke it before Hive is available; in that case
/// it safely falls back to the supported platform locale.
Locale resolveInitialLocale(Locale platformLocale) {
  try {
    final box = HiveStorage.settingsBox;
    final savedLocale = supportedLocaleFromTag(box.get(_kLocaleKey));
    if (savedLocale != null) return savedLocale;
  } catch (_) {}
  return supportedLocaleOrFallback(platformLocale);
}

/// 支持的语言列表
const kSupportedLocales = [
  (Locale('zh', 'CN'), '简体中文'),
  (Locale('zh', 'TW'), '繁體中文'),
  (Locale('en'), 'English'),
  (Locale('ja'), '日本語'),
  (Locale('ko'), '한국어'),
  (Locale('vi'), 'Tiếng Việt'),
];

const _simplifiedChineseLocale = Locale('zh', 'CN');
const _traditionalChineseLocale = Locale('zh', 'TW');

Locale? supportedLocaleFromTag(String? value) {
  final normalized = value?.trim().replaceAll('-', '_');
  if (normalized == null || normalized.isEmpty) return null;
  final parts = normalized.split('_');
  if (parts.length > 2 || parts.first.isEmpty) return null;
  return normalizedSupportedLocale(
    Locale(parts.first, parts.length == 2 ? parts.last : null),
  );
}

Locale supportedLocaleOrFallback(Locale locale) {
  return normalizedSupportedLocale(locale) ?? _simplifiedChineseLocale;
}

Locale? normalizedSupportedLocale(Locale locale) {
  final languageCode = locale.languageCode.trim().toLowerCase();
  final countryCode = locale.countryCode?.trim().toUpperCase();
  final scriptCode = locale.scriptCode?.trim().toLowerCase();
  if (languageCode == 'zh') {
    if (scriptCode == 'hant') return _traditionalChineseLocale;
    if (scriptCode == 'hans') return _simplifiedChineseLocale;
    return switch (countryCode) {
      'TW' || 'HK' || 'MO' => _traditionalChineseLocale,
      null || '' || 'CN' || 'SG' => _simplifiedChineseLocale,
      _ => null,
    };
  }
  return switch (languageCode) {
    'en' => const Locale('en'),
    'ja' => const Locale('ja'),
    'ko' => const Locale('ko'),
    'vi' => const Locale('vi'),
    _ => null,
  };
}

String translationTargetLanguageForLocale(Locale locale) {
  final languageCode = locale.languageCode.toLowerCase();
  final countryCode = locale.countryCode?.toUpperCase();
  if (languageCode == 'zh') {
    return switch (countryCode) {
      'TW' || 'HK' || 'MO' => 'zh-TW',
      _ => 'zh-CN',
    };
  }
  if (const {'en', 'ja', 'ko', 'vi'}.contains(languageCode)) {
    return languageCode;
  }
  return 'zh-CN';
}
