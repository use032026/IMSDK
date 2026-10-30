import 'package:flutter/material.dart';
import 'package:im_sdk/app/theme/theme.dart';
import 'package:im_sdk/core/providers/locale_provider.dart';
import 'package:im_sdk/core/providers/theme_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:im_sdk/generated/l10n/sdk_resources.dart'
    show sdkChromeLocales, sdkChromeTranslations;

import 'im_sdk_client.dart';
import 'im_sdk_models.dart';

/// The same root presentation scope is used before, during, and after login.
/// This widget does not own the SDK account, navigator, or host settings.
class SdkPresentationApp extends StatelessWidget {
  const SdkPresentationApp(
      {super.key,
      required this.client,
      required this.homeBuilder,
      this.configuration});
  final ImSdkClient client;
  final ImSdkConfig? configuration;
  final WidgetBuilder homeBuilder;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
      valueListenable: client.revision,
      builder: (_, __, ___) {
        final root = client.presentationContainer;
        if (root != null) {
          return _app(root.read(themeModeProvider), root.read(localeProvider));
        }
        final config = client.config ?? configuration;
        final theme = switch (config?.normalizedThemeMode ?? 'system') {
          'light' => ThemeMode.light,
          'dark' => ThemeMode.dark,
          _ => ThemeMode.system,
        };
        final tag = config?.normalizedLocale ?? 'zh-CN';
        return _app(
            theme, tag == 'system' ? null : supportedLocaleFromTag(tag));
      });

  Widget _app(ThemeMode theme, Locale? locale) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: theme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (locales, _) {
        for (final candidate in locales ?? const <Locale>[]) {
          final supported = normalizedSupportedLocale(candidate);
          if (supported != null) return supported;
        }
        return const Locale('zh', 'CN');
      },
      home: Builder(builder: homeBuilder));
}

/// Translates only SDK-owned interface strings. Host titles, message bodies and
/// server challenges are never passed through this catalog. Unknown errors use
/// a safe localized fallback rather than displaying a backend response.
String sdkText(BuildContext context, String source) {
  final locale =
      Localizations.maybeLocaleOf(context) ?? const Locale('zh', 'CN');
  final tag = switch (locale.languageCode) {
    'zh' => locale.countryCode == 'TW' || locale.scriptCode == 'Hant'
        ? 'zh_TW'
        : 'zh',
    'pt' => locale.countryCode == 'PT' ? 'pt_PT' : 'pt',
    _ => locale.languageCode,
  };
  if (tag == 'zh') return source;
  final requested = sdkChromeLocales.indexOf(tag);
  final index = requested < 0 ? sdkChromeLocales.indexOf('en') : requested;
  final common = Localizations.of<AppLocalizations>(context, AppLocalizations);
  if (common != null) {
    final reused = switch (source) {
      '确定' => common.commonConfirm,
      '取消' => common.commonCancel,
      '关闭' => common.commonClose,
      '重试' => common.commonRetry,
      '正在加载…' => common.commonLoading,
      '手机号' => common.authTabMobile,
      '邮箱' => common.authTabEmail,
      '昵称' => common.authNickname,
      '密码' => common.authPassword,
      '确认密码' => common.authConfirmPassword,
      '验证码' => common.authVerificationCode,
      '请输入昵称' => common.authErrorEmptyNickname,
      '请输入密码' => common.authErrorEmptyPassword,
      '请输入验证码' => common.authErrorEmptyCode,
      '密码至少6位' => common.authErrorPasswordTooShort,
      '搜索联系人' => common.contactsSearch,
      '验证码已发送' => common.authCodeSent,
      _ => null,
    };
    if (reused != null) return reused;
  }
  final translated = sdkChromeTranslations[source];
  if (translated != null && index >= 0 && index < translated.length) {
    return translated[index];
  }
  final fallback = sdkChromeTranslations['操作失败，请重试']!;
  return fallback[index >= 0 && index < fallback.length ? index : 1];
}

String? sdkValidationText(BuildContext context, String? value) =>
    value == null ? null : sdkText(context, value);

String sdkConversationTitle(
        BuildContext context, ImSdkDirectConversation target) =>
    target.sdkDefaultTitle == null
        ? target.title
        : sdkText(context, target.sdkDefaultTitle!);

String sdkErrorText(BuildContext context, String value) => sdkText(
    context,
    sdkChromeTranslations.containsKey(value) ||
            const {
              '请输入昵称',
              '请输入密码',
              '请输入验证码',
              '密码至少6位',
            }.contains(value)
        ? value
        : '操作失败，请重试');
