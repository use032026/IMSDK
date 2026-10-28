import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/providers/font_size_provider.dart';
import 'package:im_sdk/core/space/space_manager.dart';
import 'package:im_sdk/core/widgets/identity_badge.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/services/mention_reminder.dart';
import 'package:im_sdk/features/chat/domain/services/conversation_peer_identity.dart';
import 'package:im_sdk/features/chat/domain/usecases/message_badge_count.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_local_resources_provider.dart';
import 'package:im_sdk/features/chat/presentation/widgets/conversation_avatar.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/settings/presentation/providers/timezone_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

const _avatarSize = 40.0;

final _conversationUnreadMentionProvider = FutureProvider.family<
    UnreadMentionReminder?,
    ({
      String spaceId,
      String conversationId,
      String currentUserId,
      bool isGroup,
      int lastReadSeq,
    })>((ref, args) async {
  if (!args.isGroup || args.currentUserId.isEmpty) return null;
  final messages = await ref.read(chatLocalDataSourceProvider).getMessages(
        args.spaceId,
        args.conversationId,
        limit: 80,
      );
  messages.sort((a, b) => a.conversationSeq.compareTo(b.conversationSeq));
  return latestUnreadMentionReminderForMessages(
    messages: messages,
    currentUserId: args.currentUserId,
    isGroup: args.isGroup,
    lastReadSeq: args.lastReadSeq,
  );
}, dependencies: [chatLocalDataSourceProvider]);

class ConversationRow extends ConsumerWidget {
  final Conversation conversation;
  final bool isPersonal;
  final bool isEmployee;
  final bool isPinned;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onAvatarTap;
  final String? overrideTitle;

  const ConversationRow({
    super.key,
    required this.conversation,
    required this.isPersonal,
    required this.isEmployee,
    required this.onTap,
    this.isPinned = false,
    this.onLongPress,
    this.onAvatarTap,
    this.overrideTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGroup = conversation.type == ConversationType.group ||
        conversation.type == ConversationType.tempSession;
    final rowTextScale =
        ref.watch(fontSizeScaleProvider).clamp(0.90, 1.15).toDouble();
    final currentSpace = ref.watch(currentSpaceProvider);
    final currentUserId = currentSpace?.userId;
    final effectivePeerUserId = _effectivePeerUserId(currentUserId);
    final localMentionReminder = isGroup &&
            conversation.unreadCount > 0 &&
            currentUserId?.isNotEmpty == true
        ? ref
            .watch(_conversationUnreadMentionProvider((
              spaceId: currentSpace!.spaceId,
              conversationId: conversation.conversationId,
              currentUserId: currentUserId!,
              isGroup: isGroup,
              lastReadSeq: conversation.lastReadSeq,
            )))
            .valueOrNull
        : null;

    bool isPeerOfficial = false;
    ({String label, String shortLabel, IdentityBadgeTone tone})? peerIdentity;
    if (!isPersonal && !isGroup) {
      int? directoryUserType;
      String? directoryRoleLabel;
      if (isEmployee && effectivePeerUserId?.isNotEmpty == true) {
        final membersAsync = ref.watch(tenantMembersProvider);
        if (membersAsync.hasValue) {
          final members = membersAsync.valueOrNull ?? [];
          final peer =
              members.where((m) => m.userId == effectivePeerUserId).firstOrNull;
          if (peer != null) {
            directoryUserType = peer.userType;
            directoryRoleLabel = peer.customerTag;
          } else if (conversation.peerUserType == null) {
            isPeerOfficial = true;
          }
        }
      }
      peerIdentity = _conversationPeerIdentity(
        resolveConversationPeerIdentity(
          peerUserType: conversation.peerUserType,
          directoryUserType: directoryUserType,
          directoryRoleLabel: directoryRoleLabel,
        ),
      );
    }

    final directAvatarPreview = !isGroup &&
            conversation.title.isEmpty &&
            effectivePeerUserId?.isNotEmpty == true
        ? ref.watch(userAvatarPreviewProvider(effectivePeerUserId!)).valueOrNull
        : null;
    final directTitle = overrideTitle ??
        (conversation.title.isNotEmpty
            ? conversation.title
            : directAvatarPreview?.displayName ?? conversation.title);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isPinned
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
              : _rowSurface(context),
          borderRadius: BorderRadius.zero,
          boxShadow: const [],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 7, 14, 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onAvatarTap,
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: _avatarSize,
                          height: _avatarSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: const [],
                          ),
                          child: ConversationAvatar(
                            conversation:
                                effectivePeerUserId == conversation.peerUserId
                                    ? conversation
                                    : conversation.copyWith(
                                        peerUserId: effectivePeerUserId,
                                      ),
                            isPersonal: isPersonal,
                            isEmployee: isEmployee,
                            size: _avatarSize,
                            groupBorderRadius: 6,
                            personBorderRadius: 6,
                            overrideTitle: directTitle,
                          ),
                        ),
                        if (conversation.unreadCount > 0)
                          Positioned(
                            top: -3,
                            right: -3,
                            child: shouldShowNumericUnreadBadge(conversation)
                                ? _UnreadBadge(
                                    count: conversation.unreadCount,
                                  )
                                : _UnreadDot(
                                    muted: conversation.isMuted,
                                  ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      directTitle,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w400,
                                        color: _rowTitleColor(context),
                                        height: 1.18,
                                      ),
                                      textScaler:
                                          TextScaler.linear(rowTextScale),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  if (!isPersonal &&
                                      isEmployee &&
                                      !isGroup &&
                                      isPeerOfficial)
                                    _ConversationTag(
                                      label: '官方',
                                      bgColor: const Color(0xFFFFB800),
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  if (!isPersonal &&
                                      !isGroup &&
                                      peerIdentity != null)
                                    IdentityBadge(
                                      label: peerIdentity.label,
                                      tone: peerIdentity.tone,
                                      compact: true,
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (conversation.lastActivityAt != null)
                                  Text(
                                    _formatTime(
                                      conversation.lastActivityAt!,
                                      ref.watch(timezoneOffsetProvider),
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                    ),
                                    textScaler: TextScaler.linear(rowTextScale),
                                  ),
                                if (conversation.isMuted)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Icon(
                                      Icons.notifications_off_outlined,
                                      size: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _lastMessagePreview(
                            conversation,
                            context,
                            currentUserId: currentUserId,
                            mentionReminderKind: localMentionReminder?.kind,
                          ),
                          style: TextStyle(
                            fontSize: 12.5,
                            color: _rowSubtitleColor(context),
                            height: 1.22,
                          ),
                          textScaler: TextScaler.linear(rowTextScale),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 72),
              child: Divider(
                height: 0.5,
                thickness: 0.5,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _effectivePeerUserId(String? currentUserId) {
    if (conversation.peerUserId?.isNotEmpty == true) {
      return conversation.peerUserId;
    }
    if (conversation.type != ConversationType.direct) return null;
    final senderUserId = conversation.lastMessage?.senderUserId;
    if (senderUserId == null || senderUserId.isEmpty) return null;
    if (currentUserId != null &&
        currentUserId.isNotEmpty &&
        senderUserId == currentUserId) {
      return null;
    }
    return senderUserId;
  }

  String _lastMessagePreview(
    Conversation conversation,
    BuildContext context, {
    required String? currentUserId,
    MentionReminderKind? mentionReminderKind,
  }) {
    final l10n = AppLocalizations.of(context);
    final msg = conversation.lastMessage;
    if (msg == null) return '';
    final label = mentionReminderLabel(
      mentionReminderKind ??
          mentionReminderKindForConversation(
            conversation,
            currentUserId: currentUserId,
          ),
    );
    final prefix = label == null ? '' : '$label ';
    if (msg.text != null && msg.text!.isNotEmpty) return '$prefix${msg.text!}';
    late final String preview;
    switch (msg.messageType) {
      case 'image':
        preview = l10n.chatImageMessage;
      case 'video':
        preview = l10n.chatVideoMessage;
      case 'audio':
      case 'voice':
        preview = l10n.chatVoiceMessage;
      case 'file':
        preview = l10n.chatFileMessage;
      case 'contact_card':
        preview = '[名片]';
      case 'call_log':
        preview = '[通话记录]';
      case 'location':
        preview = '[位置]';
      case 'link':
        preview = '[链接]';
      case 'event':
        preview = '[系统消息]';
      default:
        preview = '[消息]';
    }
    return '$prefix$preview';
  }

  String _formatTime(DateTime dt, double tzOffset) {
    return formatChatTime(dt, tzOffset);
  }
}

Color _rowSurface(BuildContext context) {
  return Theme.of(context).colorScheme.surface;
}

Color _rowTitleColor(BuildContext context) {
  return Theme.of(context).colorScheme.onSurface;
}

Color _rowSubtitleColor(BuildContext context) {
  return Theme.of(context).colorScheme.onSurfaceVariant;
}

class _UnreadDot extends StatelessWidget {
  final bool muted;

  const _UnreadDot({required this.muted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13,
      height: 13,
      decoration: BoxDecoration(
        color: muted ? const Color(0xFF98A2B3) : const Color(0xFFF04438),
        shape: BoxShape.circle,
        border: Border.all(
          color: _rowSurface(context),
          width: 1.8,
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final isOverflowCount = count > 99;
    return Container(
      key: const ValueKey('conversation-unread-badge'),
      width: isOverflowCount ? 32 : 20,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFFF04438),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _rowSurface(context), width: 1.5),
      ),
      child: Center(
        child: Text(
          isOverflowCount ? '99+' : '$count',
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: isOverflowCount ? 10 : 11,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _ConversationTag extends StatelessWidget {
  final String label;
  final Color? bgColor;
  final Color textColor;

  const _ConversationTag({
    required this.label,
    this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: textColor,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

({String label, String shortLabel, IdentityBadgeTone tone})?
    _conversationPeerIdentity(ConversationPeerIdentityKind kind) {
  final identity = switch (kind) {
    ConversationPeerIdentityKind.customer => identityBadgeFor(userType: 1),
    ConversationPeerIdentityKind.customerService =>
      identityBadgeFor(customerTag: '客服'),
    ConversationPeerIdentityKind.admin => identityBadgeFor(customerTag: '管理员'),
    ConversationPeerIdentityKind.owner => identityBadgeFor(customerTag: '所有者'),
    ConversationPeerIdentityKind.employee ||
    ConversationPeerIdentityKind.unknown =>
      null,
  };
  return identity?.tone == IdentityBadgeTone.customer ? null : identity;
}
