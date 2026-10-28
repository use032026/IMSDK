import 'package:hive/hive.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/runtime/account_write_gate.dart';
import 'package:im_sdk/core/space/account_scope.dart';
import 'package:im_sdk/core/storage/account_storage_registry.dart';
import 'package:im_sdk/features/chat/application/draft_translation_controller.dart';
import 'package:im_sdk/features/chat/domain/services/auto_translation_policy.dart';

/// Only target-language choices are durable; draft text and translations keep
/// their existing owners.
class HiveDraftTranslationSelectionRepository
    implements DraftTranslationSelectionRepository {
  HiveDraftTranslationSelectionRepository({
    required Box<dynamic> settingsBox,
    AccountWriteGate? writeGate,
    AccountOperationContext? operationContext,
  })  : _box = settingsBox,
        _writeGate = writeGate,
        _operationContext = operationContext;

  static const settingsKey = 'draft_translation_targets_v1';

  final Box<dynamic> _box;
  final AccountWriteGate? _writeGate;
  final AccountOperationContext? _operationContext;

  @override
  Map<String, String> load() {
    final stored = _box.get(settingsKey);
    if (stored is! Map) return <String, String>{};
    return <String, String>{
      for (final entry in stored.entries)
        if (entry.key is String &&
            (entry.key as String).isNotEmpty &&
            entry.value is String &&
            AutoTranslationPolicy.supportedTargetLanguages
                .contains(entry.value))
          entry.key as String: entry.value as String,
    };
  }

  @override
  Future<void> save(Map<String, String> selections) {
    Future<void> write() => selections.isEmpty
        ? _box.delete(settingsKey)
        : _box.put(settingsKey, Map<String, String>.from(selections));
    final gate = _writeGate;
    final context = _operationContext;
    return gate == null || context == null ? write() : gate.run(context, write);
  }

  static Future<void> clearForScopes(Iterable<AccountScope> scopes) async {
    final cleared = <String>{};
    for (final scope in scopes) {
      if (!cleared.add(scope.storageKeyHash)) continue;
      await AccountStorageRegistry.deleteSettingForScope(
        scope: scope,
        key: settingsKey,
      );
    }
  }
}
