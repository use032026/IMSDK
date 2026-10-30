import 'package:im_sdk/core/storage/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/generated/l10n/sdk_resources.dart'
    show sdkSupportedLocales;

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
const kSupportedLocales = sdkSupportedLocales;

const _simplifiedChineseLocale = Locale('zh', 'CN');
const _traditionalChineseLocale = Locale('zh', 'TW');

Locale? supportedLocaleFromTag(String? value) {
  var normalized = value?.trim().replaceAll('_', '-');
  if (normalized == null || normalized.isEmpty) return null;
  // Historical host codes use ptBR/ptPT as well as BCP-47 separators.
  final compactPortuguese =
      RegExp(r'^pt(br|pt)$', caseSensitive: false).firstMatch(normalized);
  if (compactPortuguese != null) {
    normalized = 'pt-${compactPortuguese.group(1)}';
  }
  final parts = normalized.split('-');
  if (parts.length > 3 || !RegExp(r'^[a-zA-Z]{2,3}$').hasMatch(parts.first))
    return null;
  final hasScript =
      parts.length > 1 && RegExp(r'^[a-zA-Z]{4}$').hasMatch(parts[1]);
  if (parts.length == 3 && !hasScript) return null;
  final country = hasScript
      ? (parts.length == 3 ? parts[2] : null)
      : (parts.length == 2 ? parts[1] : null);
  if (country != null &&
      !RegExp(r'^(?:[a-zA-Z]{2}|[0-9]{3})$').hasMatch(country)) return null;
  return normalizedSupportedLocale(Locale.fromSubtags(
    languageCode: parts.first,
    scriptCode: hasScript ? parts[1] : null,
    countryCode: country,
  ));
}

Locale supportedLocaleOrFallback(Locale locale) =>
    normalizedSupportedLocale(locale) ?? _simplifiedChineseLocale;

Locale? normalizedSupportedLocale(Locale locale) {
  final language = switch (locale.languageCode.trim().toLowerCase()) {
    'no' => 'nb',
    'tl' => 'fil',
    'in' => 'id',
    final code => code,
  };
  final country = locale.countryCode?.trim().toUpperCase();
  final script = locale.scriptCode?.trim().toLowerCase();
  if (country != null &&
      country.isNotEmpty &&
      !RegExp(r'^(?:[A-Z]{2}|[0-9]{3})$').hasMatch(country)) return null;
  if (language == 'zh') {
    if (country != null &&
        country.isNotEmpty &&
        !const {'CN', 'SG', 'TW', 'HK', 'MO'}.contains(country)) return null;
    if (script == 'hant') return _traditionalChineseLocale;
    if (script == 'hans') return _simplifiedChineseLocale;
    if (script != null && script.isNotEmpty) return null;
    return const {'TW', 'HK', 'MO'}.contains(country)
        ? _traditionalChineseLocale
        : _simplifiedChineseLocale;
  }
  if (script != null && script.isNotEmpty) {
    const nonLatinScripts = {
      'ar': 'arab',
      'bg': 'cyrl',
      'el': 'grek',
      'hi': 'deva',
      'ja': 'jpan',
      'ko': 'kore',
      'ru': 'cyrl',
      'si': 'sinh',
      'th': 'thai',
      'uk': 'cyrl',
    };
    if (script != (nonLatinScripts[language] ?? 'latn')) return null;
  }
  if (language == 'pt') {
    final selected = country == 'PT' ? 'PT' : 'BR';
    for (final (candidate, _) in kSupportedLocales) {
      if (candidate.languageCode == 'pt' && candidate.countryCode == selected) {
        return candidate;
      }
    }
    return null;
  }
  for (final (candidate, _) in kSupportedLocales) {
    if (candidate.languageCode == language) return candidate;
  }
  return null;
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
