import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/settings/presentation/providers/timezone_provider.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_card.dart';
import 'package:im_sdk/features/official_account/presentation/widgets/official_account_card_view.dart';

/// A platform summary intentionally has no current-space swipe mutations.
class OfficialAccountInboxTile extends ConsumerStatefulWidget {
  const OfficialAccountInboxTile({super.key, required this.summary});
  final OfficialAccountConversationSummary summary;
  @override
  ConsumerState<OfficialAccountInboxTile> createState() =>
      _OfficialAccountInboxTileState();
}

class _OfficialAccountInboxTileState
    extends ConsumerState<OfficialAccountInboxTile> {
  bool _busy = false;
  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    final card = summary.officialAccount;
    return ListTile(
      key: ValueKey('official-inbox-${summary.key}'),
      enabled: !_busy,
      leading: Badge(
        isLabelVisible: summary.unreadCount > 0,
        label:
            Text(summary.unreadCount > 99 ? '99+' : '${summary.unreadCount}'),
        child: UserAvatar(
            avatarUrl: card.effectiveAvatarUrl,
            name: card.displayName,
            size: 48,
            borderRadius: 6),
      ),
      title: Row(children: [
        Flexible(
            child: Text(card.displayName,
                maxLines: 1, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 6),
        const OfficialAccountBadge()
      ]),
      subtitle: Text(summary.lastMessagePreview ?? card.tenantName,
          maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: _busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2))
          : summary.lastMessageAt == null
              ? null
              : Text(
                  formatChatTime(summary.lastMessageAt!,
                      ref.watch(timezoneOffsetProvider)),
                  style: Theme.of(context).textTheme.bodySmall),
      onTap: () async {
        setState(() => _busy = true);
        await openOfficialAccountConversation(context, ref, card);
        if (mounted) setState(() => _busy = false);
      },
    );
  }
}
