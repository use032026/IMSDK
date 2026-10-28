import 'package:flutter/material.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/providers/locale_provider.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: null,
      appBar: buildSettingsAppBar(context, l10n.settingsLanguage),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SettingGroup(
            children: kSupportedLocales.map((lang) {
              final locale = lang.$1;
              final label = lang.$2;
              final isSelected =
                  currentLocale.languageCode == locale.languageCode &&
                      currentLocale.countryCode == locale.countryCode;
              return InkWell(
                onTap: () async {
                  await ref.read(localeProvider.notifier).setLocale(locale);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 15,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
