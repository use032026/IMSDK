import 'package:im_sdk/core/storage/hive_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kEnterToSendKey = 'chat_enter_to_send';

final chatEnterToSendProvider = NotifierProvider<ChatEnterToSendNotifier, bool>(
  ChatEnterToSendNotifier.new,
);

class ChatEnterToSendNotifier extends Notifier<bool> {
  @override
  bool build() {
    try {
      final box = HiveStorage.settingsBox;
      return box.get(_kEnterToSendKey, defaultValue: 'false') == 'true';
    } catch (_) {
      return false;
    }
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    try {
      final box = HiveStorage.settingsBox;
      await box.put(_kEnterToSendKey, enabled ? 'true' : 'false');
    } catch (_) {}
  }
}
