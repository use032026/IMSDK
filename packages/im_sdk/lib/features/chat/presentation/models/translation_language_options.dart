import 'dart:ui';
import 'package:im_sdk/generated/l10n/sdk_resources.dart'
    show translationTargetNativeNames, translationNamesByDeviceLanguage;

export 'package:im_sdk/generated/l10n/sdk_resources.dart'
    show translationTargetNativeNames;

/// Native names stay stable; the name in parentheses follows the device locale.

String translationTargetNativeName(String? code) =>
    translationTargetNativeNames[code] ?? code ?? '';

String translationTargetOptionLabel(String code, Locale deviceLocale) {
  final nativeName = translationTargetNativeName(code);
  final language = deviceLocale.languageCode;
  final localeKey = language == 'zh' &&
          (deviceLocale.scriptCode == 'Hant' ||
              const {'TW', 'HK', 'MO'}.contains(deviceLocale.countryCode))
      ? 'zh-Hant'
      : language;
  final localizedName = translationNamesByDeviceLanguage[localeKey]?[code] ??
      translationNamesByDeviceLanguage['en']?[code] ??
      nativeName;
  return '$nativeName($localizedName)';
}
