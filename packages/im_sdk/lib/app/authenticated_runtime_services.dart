import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/message_inbox_provider.dart';
import 'package:im_sdk/features/official_account/presentation/widgets/official_account_inbox_runtime.dart';
import 'package:im_sdk/features/chat/domain/services/chat_startup_recovery.dart';
import 'package:im_sdk/features/chat/presentation/controllers/media_open_controller.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/gateway_provider.dart';
import 'package:im_sdk/features/teen_mode/presentation/widgets/teen_mode_runtime_service.dart';

/// Starts account-owned background consumers inside the account ProviderScope.
/// Disposing the scope also disposes every subscription before its account
/// storage is released by the runtime owner.
class AuthenticatedRuntimeServices extends ConsumerStatefulWidget {
  const AuthenticatedRuntimeServices({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<AuthenticatedRuntimeServices> createState() =>
      _AuthenticatedRuntimeServicesState();
}

class _AuthenticatedRuntimeServicesState
    extends ConsumerState<AuthenticatedRuntimeServices> {
  ProviderSubscription<SpaceContext?>? _spaceSubscription;
  ProviderSubscription<int?>? _conversationSubscription;
  String? _spaceId;
  int? _lastBadgeCount;

  @override
  void initState() {
    super.initState();
    _spaceSubscription = ref.listenManual<SpaceContext?>(
      accountRuntimeCurrentSpaceProvider,
      (_, next) => _installSpace(next),
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _spaceSubscription?.close();
    _conversationSubscription?.close();
    super.dispose();
  }

  void _installSpace(SpaceContext? space) {
    final nextSpaceId = space?.spaceId.trim();
    if (_spaceId == nextSpaceId) return;
    _conversationSubscription?.close();
    _conversationSubscription = null;
    _spaceId = nextSpaceId;
    _lastBadgeCount = null;
    if (nextSpaceId == null || nextSpaceId.isEmpty) return;

    final recovery = ChatStartupRecovery(
      store: ref.read(mediaLocalStoreProvider),
      runtime: ref.read(mediaFileRuntimeProvider),
    );
    unawaited(
      recovery.recoverSpace(nextSpaceId).catchError((Object error) {
        // Account/space transitions dispose this account scope before old
        // recovery work necessarily completes. The retired task must never
        // escape into the root zone or keep the next runtime on its loading
        // surface.
      }),
    );
    _conversationSubscription =
        ref.listenManual<int?>(
      messageInboxBadgeCountProvider(nextSpaceId),
      (_, count) {
        if (count == null) return;
        if (_lastBadgeCount == count) return;
        _lastBadgeCount = count;
        unawaited(
            ref.read(appIconBadgeServiceProvider).updateUnreadCount(count));
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(gatewayProvider);
    return OfficialAccountInboxRuntime(
      child: TeenModeRuntimeService(child: widget.child),
    );
  }
}
