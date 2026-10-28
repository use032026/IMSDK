import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:im_sdk/features/chat/domain/services/message_link_access_policy.dart';

/// Tenant-scoped link whitelist used only for customer-side link messages.
///
/// A family key prevents a whitelist from leaking across switched spaces. The
/// non-auto-disposed provider also deduplicates requests while the app process
/// remains alive.
final messageLinkWhitelistProvider =
    FutureProvider.family<MessageLinkWhitelist, String>((ref, spaceId) {
  final dio = ref.watch(dioProvider);
  return ChatRemoteDataSourceImpl(dio).getLinkWhitelist();
}, dependencies: [dioProvider]);
