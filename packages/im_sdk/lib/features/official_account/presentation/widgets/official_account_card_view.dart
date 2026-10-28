import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/official_account/application/official_account_connection_service.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_card.dart';
import 'package:im_sdk/features/official_account/presentation/providers/official_account_connection_provider.dart';
import 'package:im_sdk/features/teen_mode/presentation/utils/teen_mode_ui.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

Future<void> openOfficialAccountConversation(
  BuildContext context,
  WidgetRef ref,
  OfficialAccountCard card, {
  String? qrToken,
}) async {
  final router = GoRouter.of(context);
  final service = ref.read(officialAccountConnectionProvider);
  final fromPersonalSpace = service.readActor()?.spaceId == 'personal';
  final sourceLocation = router.routeInformationProvider.value.uri;
  try {
    final target = await service.open(card,
        qrToken: qrToken,
        isActive: () =>
            context.mounted &&
            router.routeInformationProvider.value.uri == sourceLocation);
    if (router.routeInformationProvider.value.uri != sourceLocation) return;
    // The source runtime may have been disposed by the intentional space switch.
    // Navigation uses the stable app router, not the retired source WidgetRef.
    final extra = {
      'title': target.displayName,
      'avatarUrl': target.effectiveAvatarUrl,
      'peerUserId': target.officialUserId,
      'conversationType': 'direct',
      'isGroup': false,
    };
    if (fromPersonalSpace) {
      // Home is the declarative parent, so auth refresh keeps the same route
      // identity and only a real exit invokes personal-space restoration.
      router.go('/official-chat/${target.conversationId}', extra: extra);
    } else {
      router.go('/chat/${target.conversationId}', extra: extra);
    }
  } catch (error) {
    if (!context.mounted) return;
    if (showTeenModeServerAction(context, ref, error)) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          officialAccountErrorMessage(AppLocalizations.of(context), error)),
    ));
  }
}

String officialAccountErrorMessage(AppLocalizations l10n, Object error) {
  if (error == OfficialAccountConnectionFailure.teenMode) {
    return l10n.teenModeActionBlocked;
  }
  if (error == OfficialAccountConnectionFailure.switched) {
    return l10n.officialAccountAccountChanged;
  }
  if (error == OfficialAccountConnectionFailure.directory) {
    return l10n.officialAccountDirectoryUnavailable;
  }
  if (error == OfficialAccountConnectionFailure.unavailable) {
    return l10n.officialAccountUnavailable;
  }
  if (error is ServerError) {
    return switch (error.code) {
      'OFFICIAL_ACCOUNT_FRIEND_JOIN_DISABLED' =>
        l10n.officialAccountJoinDisabled,
      'OFFICIAL_ACCOUNT_CUSTOMER_REMOVED' => l10n.officialAccountRemoved,
      'OFFICIAL_ACCOUNT_CUSTOMER_BANNED' => l10n.officialAccountBanned,
      'OFFICIAL_ACCOUNT_UNAVAILABLE' => l10n.officialAccountUnavailable,
      'JOIN_DISABLED_IN_BINDING_MODE' =>
        l10n.officialAccountJoinBindingDisabled,
      'SOCIAL_TARGET_INVALID' => l10n.officialAccountPlatformRequired,
      _ => l10n.officialAccountOpenFailed,
    };
  }
  return l10n.officialAccountOpenFailed;
}

class OfficialAccountBadge extends StatelessWidget {
  const OfficialAccountBadge({super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4)),
        child: Text(AppLocalizations.of(context).officialAccountBadge,
            style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onPrimaryContainer)),
      );
}

class OfficialAccountActionButton extends ConsumerStatefulWidget {
  const OfficialAccountActionButton(
      {super.key, required this.card, this.qrToken});
  final OfficialAccountCard card;
  final String? qrToken;
  @override
  ConsumerState<OfficialAccountActionButton> createState() =>
      _OfficialAccountActionButtonState();
}

class _OfficialAccountActionButtonState
    extends ConsumerState<OfficialAccountActionButton> {
  bool _busy = false;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FilledButton(
      onPressed: _busy
          ? null
          : () async {
              setState(() => _busy = true);
              await openOfficialAccountConversation(context, ref, widget.card,
                  qrToken: widget.qrToken);
              if (mounted) setState(() => _busy = false);
            },
      child: _busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2))
          : Text(widget.card.canOpenConversation
              ? l10n.officialAccountOpenConversation
              : l10n.commonAdd),
    );
  }
}

class OfficialAccountCardView extends StatelessWidget {
  const OfficialAccountCardView({super.key, required this.card});
  final OfficialAccountCard card;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          UserAvatar(
              avatarUrl: card.effectiveAvatarUrl,
              name: card.displayName,
              size: 72),
          const SizedBox(height: 16),
          Text(card.displayName, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const OfficialAccountBadge(),
          const SizedBox(height: 8),
          Text(card.tenantName),
          if (card.lppId != null)
            Text(
                '${AppLocalizations.of(context).profilePageLppId}: ${card.lppId}'),
          if (!card.isMember)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child:
                    Text(AppLocalizations.of(context).officialAccountJoinHint)),
          const SizedBox(height: 16),
          OfficialAccountActionButton(card: card),
        ]),
      );
}

class OfficialAccountSearchTile extends StatelessWidget {
  const OfficialAccountSearchTile(
      {super.key, required this.card, required this.onTap});
  final OfficialAccountCard card;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
        key: ValueKey('official-search-${card.officialUserId}'),
        leading: UserAvatar(
            avatarUrl: card.effectiveAvatarUrl,
            name: card.displayName,
            size: 48),
        title: Row(children: [
          Flexible(
              child: Text(card.displayName, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 6),
          const OfficialAccountBadge()
        ]),
        subtitle:
            Text(card.tenantName, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: OfficialAccountActionButton(card: card),
        onTap: onTap,
      );
}
