import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/settings/domain/entities/settings_entities.dart';
import 'package:im_sdk/features/settings/domain/repositories/settings_repositories.dart';
import 'package:im_sdk/features/settings/presentation/providers/settings_providers.dart';

class _DelayedRepository implements SettingsRepository {
  final load = Completer<NotificationSettings>();
  final update = Completer<void>();
  @override
  Future<NotificationSettings> getNotificationSettings() => load.future;
  @override
  Future<void> updateNotificationSettings(NotificationSettings settings) =>
      update.future;
}

void main() {
  for (final rejected in [false, true]) {
    test(
        'pending notification load ${rejected ? 'rejection' : 'success'} does not publish after disposal',
        () async {
      final repository = _DelayedRepository();
      final notifier = NotificationSettingsNotifier(repository);
      notifier.dispose();
      if (rejected) {
        repository.load.completeError(StateError('Canceled account request'));
      } else {
        repository.load.complete(const NotificationSettings());
      }
      // The test zone reports an uncaught late state assignment as a failure.
      await Future<void>.delayed(Duration.zero);
    });
  }
  test('pending update rejection does not roll back into a disposed notifier',
      () async {
    final repository = _DelayedRepository();
    final notifier = NotificationSettingsNotifier(repository);
    repository.load.complete(const NotificationSettings());
    await Future<void>.delayed(Duration.zero);
    final operation =
        notifier.update(const NotificationSettings(globalMute: true));
    notifier.dispose();
    repository.update.completeError(StateError('Canceled account update'));
    await operation;
  });
  test('active notification load and update behavior is preserved', () async {
    final repository = _DelayedRepository();
    final notifier = NotificationSettingsNotifier(repository);
    repository.load.complete(const NotificationSettings());
    await Future<void>.delayed(Duration.zero);
    expect(notifier.state.requireValue.globalMute, false);
    final operation =
        notifier.update(const NotificationSettings(globalMute: true));
    expect(notifier.state.requireValue.globalMute, true);
    repository.update.complete();
    await operation;
    expect(notifier.state.requireValue.globalMute, true);
    notifier.dispose();
  });
}
