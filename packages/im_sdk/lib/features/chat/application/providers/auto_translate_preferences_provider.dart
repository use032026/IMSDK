import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:im_sdk/core/storage/account_settings_box_provider.dart';
import 'package:im_sdk/features/chat/domain/services/auto_translation_policy.dart';

const _globalAutoTranslateKey = 'auto_translate_global_enabled';
const _autoTranslateTargetLanguageKey = 'auto_translate_target_language';
const _conversationAutoTranslatePrefix = 'auto_translate_conversation';

enum ConversationAutoTranslatePreference {
  inherit,
  enabled,
  disabled,
}

class AutoTranslateGlobalSetting {
  final bool enabled;
  final String targetLanguage;

  const AutoTranslateGlobalSetting({
    required this.enabled,
    required this.targetLanguage,
  });
}

class AutoTranslateEffectiveSetting {
  final ConversationAutoTranslatePreference preference;
  final bool globalEnabled;
  final String targetLanguage;

  const AutoTranslateEffectiveSetting({
    required this.preference,
    required this.globalEnabled,
    required this.targetLanguage,
  });

  bool get enabled {
    return switch (preference) {
      ConversationAutoTranslatePreference.inherit => globalEnabled,
      ConversationAutoTranslatePreference.enabled => true,
      ConversationAutoTranslatePreference.disabled => false,
    };
  }

  String get statusLabel {
    return switch (preference) {
      ConversationAutoTranslatePreference.inherit =>
        '跟随全局（${globalEnabled ? '已开启' : '已关闭'}）',
      ConversationAutoTranslatePreference.enabled => '本会话（已开启）',
      ConversationAutoTranslatePreference.disabled => '本会话（已关闭）',
    };
  }
}

class AutoTranslateGlobalNotifier
    extends StateNotifier<AutoTranslateGlobalSetting> {
  AutoTranslateGlobalNotifier(this._box)
      : super(
          AutoTranslateGlobalSetting(
            enabled: _box.get(_globalAutoTranslateKey) == 'true',
            targetLanguage:
                const AutoTranslationPolicy().normalizeTargetLanguage(
              _box.get(_autoTranslateTargetLanguageKey)?.toString() ?? '',
            ),
          ),
        );

  final Box<dynamic> _box;

  void setEnabled(bool enabled) {
    state = AutoTranslateGlobalSetting(
      enabled: enabled,
      targetLanguage: state.targetLanguage,
    );
    _box.put(_globalAutoTranslateKey, enabled ? 'true' : 'false');
  }

  void setTargetLanguage(String targetLanguage) {
    final normalized =
        const AutoTranslationPolicy().normalizeTargetLanguage(targetLanguage);
    state = AutoTranslateGlobalSetting(
      enabled: state.enabled,
      targetLanguage: normalized,
    );
    _box.put(_autoTranslateTargetLanguageKey, normalized);
  }
}

class ConversationAutoTranslateNotifier
    extends FamilyNotifier<ConversationAutoTranslatePreference, String> {
  @override
  ConversationAutoTranslatePreference build(String arg) {
    return _decode(ref.watch(accountSettingsBoxProvider).get(_key(arg)));
  }

  void setPreference(ConversationAutoTranslatePreference preference) {
    state = preference;
    ref.read(accountSettingsBoxProvider).put(_key(arg), _encode(preference));
  }

  String _key(String conversationScopeKey) {
    return '$_conversationAutoTranslatePrefix:${conversationScopeKey.trim()}';
  }

  ConversationAutoTranslatePreference _decode(String? value) {
    return switch (value) {
      'enabled' => ConversationAutoTranslatePreference.enabled,
      'disabled' => ConversationAutoTranslatePreference.disabled,
      _ => ConversationAutoTranslatePreference.inherit,
    };
  }

  String _encode(ConversationAutoTranslatePreference preference) {
    return switch (preference) {
      ConversationAutoTranslatePreference.inherit => 'inherit',
      ConversationAutoTranslatePreference.enabled => 'enabled',
      ConversationAutoTranslatePreference.disabled => 'disabled',
    };
  }
}

final autoTranslateGlobalProvider = StateNotifierProvider<
    AutoTranslateGlobalNotifier, AutoTranslateGlobalSetting>((ref) {
  return AutoTranslateGlobalNotifier(ref.watch(accountSettingsBoxProvider));
}, dependencies: [accountSettingsBoxProvider]);

final conversationAutoTranslatePreferenceProvider = NotifierProvider.family<
    ConversationAutoTranslateNotifier,
    ConversationAutoTranslatePreference,
    String>(
  ConversationAutoTranslateNotifier.new,
  dependencies: [accountSettingsBoxProvider],
);

final autoTranslateEffectiveProvider =
    Provider.family<AutoTranslateEffectiveSetting, String>((ref, scopeKey) {
  final global = ref.watch(autoTranslateGlobalProvider);
  final preference = ref.watch(
    conversationAutoTranslatePreferenceProvider(scopeKey),
  );
  return AutoTranslateEffectiveSetting(
    preference: preference,
    globalEnabled: global.enabled,
    targetLanguage: global.targetLanguage,
  );
}, dependencies: [
  autoTranslateGlobalProvider,
  conversationAutoTranslatePreferenceProvider,
]);

String conversationAutoTranslateScopeKey({
  required String spaceId,
  required String conversationId,
}) {
  return '${spaceId.trim()}:${conversationId.trim()}';
}
