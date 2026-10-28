import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/notifications/push_notification_service.dart';
import 'package:im_sdk/features/settings/data/datasources/settings_datasources.dart';
import 'package:im_sdk/features/settings/data/repositories/settings_repositories.dart';
import 'package:im_sdk/features/settings/domain/entities/settings_entities.dart';
import 'package:im_sdk/features/settings/domain/repositories/settings_repositories.dart';

// ---------------------------------------------------------------------------
// DI
// ---------------------------------------------------------------------------

final settingsRemoteDataSourceProvider =
    Provider<SettingsRemoteDataSource>((ref) {
  return SettingsRemoteDataSourceImpl(ref.watch(dioProvider));
}, dependencies: [dioProvider]);

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsRemoteDataSourceProvider));
}, dependencies: [settingsRemoteDataSourceProvider]);

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class NotificationSettingsNotifier
    extends StateNotifier<AsyncValue<NotificationSettings>> {
  final SettingsRepository _repo;

  NotificationSettingsNotifier(this._repo) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    final next = await AsyncValue.guard(() => _repo.getNotificationSettings());
    if (!mounted) {
      return;
    }
    state = next;
  }

  Future<void> update(NotificationSettings settings) async {
    final previous = state;
    // 乐观更新
    state = AsyncValue.data(settings);
    try {
      await _repo.updateNotificationSettings(settings);
    } catch (e, st) {
      if (!mounted) {
        return;
      }
      // 回滚
      state = previous;
      state = AsyncValue.error(e, st);
    }
  }

  /// 便捷方法：只更新单个字段
  Future<void> patch(
      NotificationSettings Function(NotificationSettings) fn) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await update(fn(current));
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final notificationSettingsProvider = StateNotifierProvider.family<
    NotificationSettingsNotifier,
    AsyncValue<NotificationSettings>,
    String>((ref, spaceId) {
  if (spaceId.trim().isEmpty) {
    throw ArgumentError.value(spaceId, 'spaceId', 'must not be empty');
  }
  return NotificationSettingsNotifier(ref.watch(settingsRepositoryProvider));
}, dependencies: [settingsRepositoryProvider]);

final localNotificationAuthorizationProvider =
    FutureProvider<LocalNotificationAuthorizationStatus>((ref) {
  return PushNotificationService.localNotificationAuthorizationStatus();
});
