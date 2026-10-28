import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';

typedef AccountProfileBoxResolver = Future<Box<dynamic>> Function(
  String spaceId,
);

/// Construction seam for profile/contact/group caches.
final accountProfileBoxResolverProvider = Provider<AccountProfileBoxResolver>(
  (ref) {
    final storage = ref.watch(accountStorageContextProvider);
    if (storage == null) {
      throw StateError(
        'Authenticated profile storage requires an active account runtime',
      );
    }
    return (_) async => storage.accountBox;
  },
  dependencies: [accountStorageContextProvider],
);
