import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';
import 'package:im_sdk/features/chat/application/providers/auto_translate_preferences_provider.dart';
import 'package:im_sdk/features/chat/presentation/models/translation_language_options.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:im_sdk/generated/l10n/sdk_resources.dart'
    show translationExampleMessages;

class AutoTranslatePage extends ConsumerWidget {
  const AutoTranslatePage({super.key});

  String _translatedExample(String targetLanguage) =>
      translationExampleMessages[targetLanguage] ??
      translationExampleMessages['zh-CN']!;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final globalAutoTranslate = ref.watch(autoTranslateGlobalProvider);
    final enabled = globalAutoTranslate.enabled;
    final targetLanguage = globalAutoTranslate.targetLanguage;
    final targetLabel = translationTargetNativeName(targetLanguage);
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    return Scaffold(
      backgroundColor: null,
      appBar: buildSettingsAppBar(context, l10n.autoTranslateTitle),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SettingGroup(
            children: [
              SettingSwitchTile(
                label: l10n.autoTranslateEnabled,
                description: enabled
                    ? '${l10n.autoTranslateLanguage}：$targetLabel'
                    : null,
                value: enabled,
                onChanged: (v) => ref
                    .read(autoTranslateGlobalProvider.notifier)
                    .setEnabled(v),
              ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: 16),
            // Example
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('翻译示例',
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              colorScheme.onSurface.withValues(alpha: 0.55))),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('原文（英语）',
                            style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.55))),
                        const SizedBox(height: 4),
                        Text(translationExampleMessages['en']!,
                            style: TextStyle(
                                fontSize: 14, color: colorScheme.onSurface)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B27A).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('译文（$targetLabel）',
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF00B27A))),
                        const SizedBox(height: 4),
                        Text(_translatedExample(targetLanguage),
                            style: TextStyle(
                                fontSize: 14, color: colorScheme.onSurface)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Text('目标语言',
                  style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface.withValues(alpha: 0.55))),
            ),
            SettingGroup(
              children: translationTargetNativeNames.entries.map((lang) {
                return InkWell(
                  onTap: () => ref
                      .read(autoTranslateGlobalProvider.notifier)
                      .setTargetLanguage(lang.key),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                              translationTargetOptionLabel(
                                  lang.key, deviceLocale),
                              style: TextStyle(
                                  fontSize: 15, color: colorScheme.onSurface)),
                        ),
                        if (targetLanguage == lang.key)
                          const Icon(Icons.check,
                              color: Color(0xFF00B27A), size: 20),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '提示：\n• 自动翻译功能由 AI 提供支持\n• 翻译结果仅供参考，可能存在误差\n• 原文和译文都会显示在聊天界面中\n• 可在聊天界面长按消息选择"显示原文"',
              style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                  height: 1.6),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
