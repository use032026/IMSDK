import 'package:hive_flutter/hive_flutter.dart';
import 'package:im_sdk/core/storage/hive_storage.dart';

/// Crash-safe logout marker.
///
/// Logout becomes visible before encrypted credential cleanup finishes. If the
/// process is killed in that window, the next startup must finish cleanup
/// instead of restoring the old active session.
class LogoutGuard {
  static String get _boxName => HiveStorage.boxName('app_settings');
  static const _pendingKey = 'auth_logout_pending_v1';
  static const _unknownSpace = '__unknown__';

  const LogoutGuard._();

  static bool get isPending {
    if (!Hive.isBoxOpen(_boxName)) return false;
    return Hive.box<String>(_boxName).containsKey(_pendingKey);
  }

  static String? get pendingSpaceId {
    if (!Hive.isBoxOpen(_boxName)) return null;
    final value = Hive.box<String>(_boxName).get(_pendingKey);
    if (value == null || value.isEmpty || value == _unknownSpace) return null;
    return value;
  }

  static Future<void> arm(String? spaceId) async {
    if (!Hive.isBoxOpen(_boxName)) return;
    await Hive.box<String>(_boxName).put(
      _pendingKey,
      spaceId == null || spaceId.isEmpty ? _unknownSpace : spaceId,
    );
  }

  static Future<void> disarm() async {
    if (!Hive.isBoxOpen(_boxName)) return;
    await Hive.box<String>(_boxName).delete(_pendingKey);
  }
}
