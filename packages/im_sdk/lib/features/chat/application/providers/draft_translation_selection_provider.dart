import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/storage/account_settings_box_provider.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/chat/application/draft_translation_controller.dart';
import 'package:im_sdk/features/chat/data/repositories/draft_translation_selection_repository.dart';

/// One account-runtime selection owner, backed by that account's settings box.
final draftTranslationSelectionStoreProvider =
    Provider<DraftTranslationSelectionStore>((ref) {
  final session = ref.watch(activeAccountSessionProvider);
  if (session == null) return DraftTranslationSelectionStore();
  final storage = ref.watch(accountStorageContextProvider);
  if (storage != null && storage.scope != session.scope) {
    return DraftTranslationSelectionStore();
  }
  return DraftTranslationSelectionStore(
    repository: HiveDraftTranslationSelectionRepository(
      settingsBox: ref.watch(accountSettingsBoxProvider),
      writeGate: storage?.writeGate,
      operationContext: storage?.operationContext,
    ),
  );
}, dependencies: [
  activeAccountSessionProvider,
  accountStorageContextProvider,
  accountSettingsBoxProvider,
]);
