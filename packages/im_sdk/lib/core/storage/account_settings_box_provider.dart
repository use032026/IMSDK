import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Runtime override seam for account-owned preferences. The default preserves
/// no legacy fallback after the atomic runtime cutover.
final accountSettingsBoxProvider = Provider<Box<dynamic>>(
  (ref) => throw StateError(
    'Authenticated settings require an active account runtime',
  ),
);
