import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/platform/local_file.dart';
import 'package:im_sdk/core/diagnostics/media_diagnostics.dart';
import 'package:im_sdk/core/platform/local_video_poster.dart';
import 'package:im_sdk/core/space/space_manager.dart';
import 'package:im_sdk/core/widgets/app_network_image.dart';
import 'package:im_sdk/core/widgets/identity_badge.dart';
import 'package:im_sdk/core/widgets/person_avatar_with_badge.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/chat/domain/entities/media_local_file.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/services/audio_player_service.dart';
import 'package:im_sdk/features/chat/domain/services/call_log_policy.dart';
import 'package:im_sdk/features/chat/domain/services/link_message_policy.dart';
import 'package:im_sdk/features/chat/domain/services/message_link_access_policy.dart';
import 'package:im_sdk/features/chat/domain/services/message_read_receipt_service.dart';
import 'package:im_sdk/features/chat/presentation/controllers/media_open_controller.dart';
import 'package:im_sdk/features/chat/presentation/pages/image_viewer_page.dart';
import 'package:im_sdk/features/chat/presentation/models/message_media_preview_model.dart';
import 'package:im_sdk/features/chat/presentation/models/call_log_display_model.dart';
import 'package:im_sdk/features/chat/presentation/models/message_upload_progress_model.dart';
import 'package:im_sdk/features/chat/presentation/providers/message_link_whitelist_provider.dart';
import 'package:im_sdk/features/chat/presentation/widgets/link_message_bubble.dart';
import 'package:im_sdk/features/chat/presentation/widgets/message_copy_button.dart';
import 'package:im_sdk/features/chat/presentation/widgets/message_text_content.dart';
import 'package:im_sdk/features/settings/presentation/providers/timezone_provider.dart';
import 'package:im_sdk/features/settings/presentation/providers/chat_background_provider.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

class _C {
  static const green = Color(0xFF13BFA6);

  static Color selfBg(BuildContext context) {
    return Theme.of(context).colorScheme.primaryContainer;
  }

  static Color otherBg(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }
}

typedef TrustedMediaDimensionsResolved = void Function(
  Message message,
  Size displaySize,
);

class MessageBubble extends ConsumerWidget {
  static const double _externalStatusSlotWidth = 24;

  final Message message;
  final bool isSelf;
  final String currentUserId;
  final String? senderName;
  final String? senderAvatarUrl;
  final String? senderIdentityLabel;
  final IdentityBadgeTone? senderIdentityTone;
  final String? senderAvatarBadgeLabel;
  final IdentityBadgeTone? senderAvatarBadgeTone;
  final bool showSenderInfo;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onConvertVoiceToText;
  final VoidCallback? onCallLogTap;

  /// 被引用的消息（用于显示引用块内容）
  final Message? replyMessage;

  /// 被引用消息的发送者名字
  final String? replySenderName;

  /// 群聊 ID（非空时不显示私聊阅读勾）
  final String? groupId;

  /// 发送失败时点击感叹号的回调
  final VoidCallback? onFailedTap;

  /// 是否显示时间戳（相邻消息时间差 < 5 分钟时隐藏）
  final bool showTimestamp;
  final bool showGroupReadReceipt;
  final VoidCallback? onGroupReadReceiptTap;
  final List<ChatMediaViewerItem> mediaViewerItems;
  final TrustedMediaDimensionsResolved? onTrustedMediaDimensionsResolved;
  final MediaPreviewLayoutCache? mediaPreviewLayoutCache;
  final ChatBackgroundSetting? chatBackground;
  final bool enableTextActions;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSelf,
    this.currentUserId = '',
    this.senderName,
    this.senderAvatarUrl,
    this.senderIdentityLabel,
    this.senderIdentityTone,
    this.senderAvatarBadgeLabel,
    this.senderAvatarBadgeTone,
    this.showSenderInfo = false,
    this.onAvatarTap,
    this.onConvertVoiceToText,
    this.onCallLogTap,
    this.replyMessage,
    this.replySenderName,
    this.groupId,
    this.onFailedTap,
    this.showTimestamp = true,
    this.showGroupReadReceipt = true,
    this.onGroupReadReceiptTap,
    this.mediaViewerItems = const [],
    this.onTrustedMediaDimensionsResolved,
    this.mediaPreviewLayoutCache,
    this.chatBackground,
    this.enableTextActions = true,
  });

  Widget _senderNameLabel(BuildContext context) {
    final background = chatBackground;
    final Color color;
    if (background == null) {
      color = Theme.of(context).colorScheme.onSurface;
    } else if (background.hasImage) {
      color = Colors.white;
    } else {
      // Either black or white reaches at least 4.5:1 at this threshold.
      color = background.color.computeLuminance() >= 0.179
          ? Colors.black
          : Colors.white;
    }
    final label = Text(
      senderName!,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
      overflow: TextOverflow.ellipsis,
    );
    if (background?.hasImage != true) return label;
    return DecoratedBox(
      key: const ValueKey('group-sender-name-backdrop'),
      decoration: BoxDecoration(
        color: const Color(0xDB000000),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: label,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tzOffset = ref.watch(timezoneOffsetProvider);
    if (message.isRecalled) {
      return _RecalledBubble(isSelf: isSelf, senderName: senderName);
    }

    // 系统事件消息：居中灰色文字，无头像无气泡；text 为空时不渲染
    if (message.type == MessageType.event) {
      if (message.body.text == null || message.body.text!.isEmpty) {
        return const SizedBox.shrink();
      }
      return _EventBubble(message: message);
    }

    final showGroupReceipt = _shouldShowGroupReadReceipt(
      message,
      isSelf: isSelf,
      groupId: groupId,
      showGroupReadReceipt: showGroupReadReceipt,
      onTap: onGroupReadReceiptTap,
    );
    final showStatusSlot = showGroupReceipt ||
        _shouldShowExternalStatusIndicator(message, groupId);
    final reservesExternalStatusSlot = isSelf;
    final link = message.body.link;
    final linkCanOpen = message.type == MessageType.link && link != null
        ? _resolveLinkCanOpen(ref, link.url)
        : null;
    final isText = message.type == MessageType.text ||
        message.type == MessageType.markdown;
    final detectedTextLinks = enableTextActions && isText
        ? LinkMessagePolicy.findTextLinks(message.body.text ?? '')
        : const <TextMessageLink>[];
    final textLinks = detectedTextLinks
        .where((link) => _resolveLinkCanOpen(ref, link.url))
        .toList(growable: false);
    final copyText = isText || message.type == MessageType.link
        ? message.body.text ?? link?.url ?? ''
        : '';
    final showCopy = enableTextActions &&
        copyText.isNotEmpty &&
        (detectedTextLinks.isNotEmpty ||
            (message.type == MessageType.link && link != null));

    return Padding(
      padding: EdgeInsets.only(
        left: isSelf
            ? 56 - (reservesExternalStatusSlot ? _externalStatusSlotWidth : 0)
            : 6,
        right: isSelf ? 12 : 56,
        top: 4,
        bottom: 4,
      ),
      child: Row(
        mainAxisAlignment:
            isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 对方头像（左侧，顶部对齐）
          if (!isSelf) ...[
            GestureDetector(
              onTap: onAvatarTap,
              child: _Avatar(
                url: senderAvatarUrl,
                name: senderName,
                badgeLabel: senderAvatarBadgeLabel,
                badgeTone: senderAvatarBadgeTone,
              ),
            ),
            const SizedBox(width: 8),
          ],
          // 消息内容区
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // 群聊中显示对方名字；私聊由会话标题标识对方，不重复显示。
                if (showSenderInfo &&
                    !isSelf &&
                    senderName != null &&
                    senderName!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 3, left: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: _senderNameLabel(context),
                        ),
                        if (senderIdentityLabel != null &&
                            senderIdentityTone != null) ...[
                          const SizedBox(width: 4),
                          IdentityBadge(
                            label: senderIdentityLabel!,
                            tone: senderIdentityTone!,
                            compact: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                // 气泡 + 极简投递/阅读状态
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (reservesExternalStatusSlot)
                      SizedBox(
                        width: _externalStatusSlotWidth,
                        height: 20,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: showGroupReceipt
                              ? _GroupReadReceiptEntry(
                                  readCount: message.readCount,
                                  onTap: onGroupReadReceiptTap!,
                                )
                              : showStatusSlot
                                  ? _StatusIndicator(
                                      status: message.status,
                                      isReadByPeer: message.isReadByPeer,
                                      showReadReceipt: groupId == null,
                                      showSendingProgress:
                                          !_suppressesExternalSendProgress(
                                              message),
                                      onFailedTap: onFailedTap,
                                    )
                                  : const SizedBox.shrink(),
                        ),
                      ),
                    if (isSelf && showCopy) MessageCopyButton(text: copyText),
                    Flexible(
                      child: _BubbleContent(
                        message: message,
                        isSelf: isSelf,
                        currentUserId: currentUserId,
                        linkCanOpen: linkCanOpen,
                        textLinks: textLinks,
                        onConvertVoiceToText: onConvertVoiceToText,
                        onCallLogTap: onCallLogTap,
                        replyMessage: replyMessage,
                        replySenderName: replySenderName,
                        mediaViewerItems: mediaViewerItems,
                        onTrustedMediaDimensionsResolved:
                            onTrustedMediaDimensionsResolved,
                        mediaPreviewLayoutCache: mediaPreviewLayoutCache,
                      ),
                    ),
                    if (!isSelf && showCopy) MessageCopyButton(text: copyText),
                  ],
                ),
                // 时间戳（相邻消息时间差 < 5 分钟时隐藏）
                if (showTimestamp)
                  Padding(
                    padding: EdgeInsets.only(top: 3, left: 2, right: 2),
                    child: Text(
                      formatTimeWithTimezone(message.sentAt, tzOffset),
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // 自己头像（右侧）
          if (isSelf) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onAvatarTap,
              child: _Avatar(
                url: senderAvatarUrl,
                name: senderName,
                isMyAvatar: true,
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _resolveLinkCanOpen(WidgetRef ref, String url) {
    final teenPolicy = ref.watch(teenModePolicyProvider);
    if (!teenPolicy.linkAccessResolved) return false;
    if (teenPolicy.blocksAllLinks) return false;

    final senderKind = _linkSenderKind(ref);
    final requiresWhitelist = teenPolicy.requiresLinkWhitelist ||
        MessageLinkAccessPolicy.requiresWhitelist(senderKind);
    if (!requiresWhitelist) {
      return MessageLinkAccessPolicy.canOpen(
        url: url,
        senderKind: senderKind,
        whitelist: null,
      );
    }

    final spaceId = ref.watch(
      currentSpaceProvider.select((space) => space?.spaceId),
    );
    final whitelist = spaceId == null
        ? null
        : ref.watch(messageLinkWhitelistProvider(spaceId)).valueOrNull;
    if (teenPolicy.requiresLinkWhitelist) {
      return whitelist?.allows(url) ?? false;
    }
    return MessageLinkAccessPolicy.canOpen(
      url: url,
      senderKind: senderKind,
      whitelist: whitelist,
    );
  }

  MessageLinkSenderKind _linkSenderKind(WidgetRef ref) {
    if (isSelf || message.isSelf) {
      final isCustomer = ref.watch(
        currentSpaceProvider.select((space) => space?.isCustomer),
      );
      if (isCustomer == true) return MessageLinkSenderKind.customer;
      if (isCustomer == false) return MessageLinkSenderKind.staff;
      return MessageLinkSenderKind.unknown;
    }
    switch (senderIdentityTone ?? senderAvatarBadgeTone) {
      case IdentityBadgeTone.customer:
        return MessageLinkSenderKind.customer;
      case IdentityBadgeTone.service:
      case IdentityBadgeTone.admin:
      case IdentityBadgeTone.owner:
      case IdentityBadgeTone.official:
      case IdentityBadgeTone.employee:
        return MessageLinkSenderKind.staff;
      case null:
        return MessageLinkSenderKind.unknown;
    }
  }
}

// ---------------------------------------------------------------------------
// Avatar — 圆角矩形（微信风格），轻阴影，36×36dp
// ---------------------------------------------------------------------------

class _Avatar extends StatelessWidget {
  final String? url;
  final String? name;
  final bool isMyAvatar;
  final String? badgeLabel;
  final IdentityBadgeTone? badgeTone;

  const _Avatar({
    this.url,
    this.name,
    this.isMyAvatar = false,
    this.badgeLabel,
    this.badgeTone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: messageAvatarSize,
      height: messageAvatarSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: PersonAvatarWithBadge(
        avatarUrl: url,
        name: name ?? '',
        size: messageAvatarSize,
        borderRadius: 8,
        isMyAvatar: isMyAvatar,
        showIdentity: badgeLabel != null && badgeTone != null,
        badgeLabel: badgeLabel,
        badgeTone: badgeTone,
        badgeSize: 16,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status Indicator — 私聊用单/双勾表达阅读状态
// ---------------------------------------------------------------------------

class _StatusIndicator extends StatelessWidget {
  final MessageStatus status;
  final bool isReadByPeer;
  final bool showReadReceipt;
  final bool showSendingProgress;
  final VoidCallback? onFailedTap;
  const _StatusIndicator({
    required this.status,
    this.isReadByPeer = false,
    required this.showReadReceipt,
    this.showSendingProgress = true,
    this.onFailedTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sending:
        if (!showSendingProgress) return const SizedBox.shrink();
        return SizedBox(
          key: const ValueKey('message-text-send-progress'),
          width: 20,
          height: 20,
          child: Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.45),
              ),
            ),
          ),
        );
      case MessageStatus.sent:
      case MessageStatus.delivered:
        if (!showReadReceipt) return const SizedBox.shrink();
        return isReadByPeer
            ? const _DirectReadReceiptMark()
            : const SizedBox.shrink();
      case MessageStatus.read:
        if (!showReadReceipt) return const SizedBox.shrink();
        return const _DirectReadReceiptMark();
      case MessageStatus.awaitingApproval:
        return Icon(
          Icons.schedule,
          size: 20,
          color: Theme.of(context).colorScheme.tertiary,
        );
      case MessageStatus.failed:
      case MessageStatus.rejected:
        return GestureDetector(
          onTap: onFailedTap,
          child: const Icon(Icons.error_outline, size: 20, color: Colors.red),
        );
      case MessageStatus.recalled:
      case MessageStatus.deletedLocal:
        return const SizedBox.shrink();
    }
  }
}

// ---------------------------------------------------------------------------

bool _shouldShowExternalStatusIndicator(Message message, String? groupId) {
  switch (message.status) {
    case MessageStatus.sending:
      return !_suppressesExternalSendProgress(message);
    case MessageStatus.sent:
    case MessageStatus.delivered:
      return groupId == null && message.isReadByPeer;
    case MessageStatus.read:
      return groupId == null;
    case MessageStatus.awaitingApproval:
      return true;
    case MessageStatus.failed:
    case MessageStatus.rejected:
      return true;
    case MessageStatus.recalled:
    case MessageStatus.deletedLocal:
      return false;
  }
}

bool _suppressesExternalSendProgress(Message message) {
  if (message.type == MessageType.text ||
      message.type == MessageType.markdown ||
      message.type == MessageType.link ||
      message.type == MessageType.image) {
    return false;
  }
  final uploadState = message.localUploadState;
  if (uploadState != null && uploadState.isActive) return true;
  final url = switch (message.type) {
    MessageType.image => message.body.image?.url,
    MessageType.video => message.body.video?.url,
    _ => null,
  };
  if (url == null || url.isEmpty) return false;
  return url.startsWith('/') ||
      (!url.startsWith('http://') && !url.startsWith('https://'));
}

bool _shouldShowGroupReadReceipt(
  Message message, {
  required bool isSelf,
  required String? groupId,
  required bool showGroupReadReceipt,
  required VoidCallback? onTap,
}) {
  return showGroupReadReceipt &&
      onTap != null &&
      message.readCount > 0 &&
      const MessageReadReceiptService().canShowGroupReadReceipt(
        message,
        isSelf: isSelf,
        isGroup: groupId != null,
      );
}

class _GroupReadReceiptEntry extends StatelessWidget {
  final int readCount;
  final VoidCallback onTap;

  const _GroupReadReceiptEntry({
    required this.readCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '已读详情',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          key: const ValueKey('message-group-read-receipt-entry'),
          width: 16,
          height: 16,
          alignment: Alignment.center,
          child: _GroupReadReceiptMark(readCount: readCount),
        ),
      ),
    );
  }
}

class _DirectReadReceiptMark extends StatelessWidget {
  const _DirectReadReceiptMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      height: 14,
      child: CustomPaint(
        painter: _DirectReadReceiptPainter(
          fillColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class _GroupReadReceiptMark extends StatelessWidget {
  final int readCount;

  const _GroupReadReceiptMark({required this.readCount});

  @override
  Widget build(BuildContext context) {
    final ratio = readCount > 0 ? 0.42 : 0.0;
    return SizedBox(
      width: 14,
      height: 14,
      child: CustomPaint(
        painter: _GroupReadReceiptPainter(
          ratio: ratio,
          fillColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class _DirectReadReceiptPainter extends CustomPainter {
  final Color fillColor;

  const _DirectReadReceiptPainter({required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 14;
    final center = size.center(Offset.zero);
    final ringFill = Paint()
      ..style = PaintingStyle.fill
      ..color = fillColor;
    canvas.drawCircle(center, 5.45 * scale, ringFill);

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7 * scale
      ..strokeCap = StrokeCap.round
      ..color = _C.green;
    canvas.drawCircle(center, 5.45 * scale, ring);

    final check = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.75 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = _C.green;
    final path = Path()
      ..moveTo(4.45 * scale, 7.05 * scale)
      ..lineTo(6.12 * scale, 8.68 * scale)
      ..lineTo(9.58 * scale, 5.28 * scale);
    canvas.drawPath(path, check);
  }

  @override
  bool shouldRepaint(covariant _DirectReadReceiptPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor;
  }
}

class _GroupReadReceiptPainter extends CustomPainter {
  final double ratio;
  final Color fillColor;

  const _GroupReadReceiptPainter({
    required this.ratio,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 14;
    final center = size.center(Offset.zero);
    final ringFill = Paint()
      ..style = PaintingStyle.fill
      ..color = fillColor;
    canvas.drawCircle(center, 5.35 * scale, ringFill);

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.45 * scale
      ..color = _C.green;
    canvas.drawCircle(center, 5.35 * scale, ring);

    final track = Paint()
      ..style = PaintingStyle.fill
      ..color = fillColor;
    canvas.drawCircle(center, 3.25 * scale, track);

    final clamped = ratio.clamp(0.0, 1.0).toDouble();
    if (clamped <= 0) return;
    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = _C.green;
    final rect = Rect.fromCircle(center: center, radius: 3.25 * scale);
    canvas.drawArc(rect, -math.pi / 2, clamped * math.pi * 2, true, fill);
  }

  @override
  bool shouldRepaint(covariant _GroupReadReceiptPainter oldDelegate) {
    return oldDelegate.ratio != ratio || oldDelegate.fillColor != fillColor;
  }
}
// Recalled Bubble
// ---------------------------------------------------------------------------

class _RecalledBubble extends StatelessWidget {
  final bool isSelf;
  final String? senderName;
  _RecalledBubble({required this.isSelf, this.senderName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = isSelf
        ? l10n.chatRecalledSelf
        : l10n.chatRecalledPeer(senderName ?? l10n.chatPeer);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(text,
            style: TextStyle(
                fontSize: 12,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bubble Content dispatcher
// ---------------------------------------------------------------------------

class _BubbleContent extends StatelessWidget {
  final Message message;
  final bool isSelf;
  final String currentUserId;
  final bool? linkCanOpen;
  final List<TextMessageLink> textLinks;
  final VoidCallback? onConvertVoiceToText;
  final VoidCallback? onCallLogTap;
  final Message? replyMessage;
  final String? replySenderName;
  final List<ChatMediaViewerItem> mediaViewerItems;
  final TrustedMediaDimensionsResolved? onTrustedMediaDimensionsResolved;
  final MediaPreviewLayoutCache? mediaPreviewLayoutCache;
  const _BubbleContent(
      {required this.message,
      required this.isSelf,
      required this.currentUserId,
      this.linkCanOpen,
      this.textLinks = const [],
      this.onConvertVoiceToText,
      this.onCallLogTap,
      this.replyMessage,
      this.replySenderName,
      this.mediaViewerItems = const [],
      this.onTrustedMediaDimensionsResolved,
      this.mediaPreviewLayoutCache});

  Color _bg(BuildContext context) =>
      isSelf ? _C.selfBg(context) : _C.otherBg(context);

  BorderRadius get _br => BorderRadius.only(
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
        bottomLeft: Radius.circular(isSelf ? 12 : 4),
        bottomRight: Radius.circular(isSelf ? 4 : 12),
      );

  @override
  Widget build(BuildContext context) {
    final bg = _bg(context);
    switch (message.type) {
      case MessageType.text:
      case MessageType.markdown:
        return _TextBubble(
            message: message,
            textLinks: textLinks,
            bg: bg,
            br: _br,
            isSelf: isSelf,
            replyMessage: replyMessage,
            replySenderName: replySenderName,
            mediaViewerItems: mediaViewerItems);
      case MessageType.image:
        return _ImageBubble(
          message: message,
          mediaViewerItems: mediaViewerItems,
          onTrustedMediaDimensionsResolved: onTrustedMediaDimensionsResolved,
          mediaPreviewLayoutCache: mediaPreviewLayoutCache,
        );
      case MessageType.voice:
        return _VoiceBubble(
          message: message,
          bg: bg,
          br: _br,
          isSelf: isSelf,
          onConvertVoiceToText: onConvertVoiceToText,
        );
      case MessageType.video:
        return _VideoBubble(
          message: message,
          mediaViewerItems: mediaViewerItems,
          onTrustedMediaDimensionsResolved: onTrustedMediaDimensionsResolved,
          mediaPreviewLayoutCache: mediaPreviewLayoutCache,
        );
      case MessageType.file:
        return _FileBubble(message: message, br: _br);
      case MessageType.event:
        return _EventBubble(message: message);
      case MessageType.contactCard:
        return _ContactCardBubble(card: message.body.contactCard);
      case MessageType.callLog:
        return _CallLogBubble(
          message: message,
          currentUserId: currentUserId,
          bg: bg,
          br: _br,
          onTap: onCallLogTap,
        );
      case MessageType.location:
        return _LocationBubble(loc: message.body.location, bg: bg, br: _br);
      case MessageType.link:
        final link = message.body.link;
        if (link == null) {
          return _TextBubble(
            message: message,
            bg: bg,
            br: _br,
            isSelf: isSelf,
            replyMessage: replyMessage,
            replySenderName: replySenderName,
          );
        }
        if (linkCanOpen != true) {
          return _TextBubble(
            message: message.copyWith(
              type: MessageType.text,
              body: MessageBody(text: message.body.text ?? link.url),
            ),
            bg: bg,
            br: _br,
            isSelf: isSelf,
            replyMessage: replyMessage,
            replySenderName: replySenderName,
          );
        }
        return LinkMessageBubble(link: link);
    }
  }
}

// ---------------------------------------------------------------------------
// Text Bubble — 支持回复引用 + 翻译显示
// ---------------------------------------------------------------------------

class _TextBubble extends StatelessWidget {
  final Message message;
  final List<TextMessageLink> textLinks;
  final Color bg;
  final BorderRadius br;
  final bool isSelf;
  final Message? replyMessage;
  final String? replySenderName;
  final List<ChatMediaViewerItem> mediaViewerItems;
  const _TextBubble(
      {required this.message,
      this.textLinks = const [],
      required this.bg,
      required this.br,
      required this.isSelf,
      this.replyMessage,
      this.replySenderName,
      this.mediaViewerItems = const []});

  /// 从消息中提取预览文字
  static String _previewOf(BuildContext context, Message msg) {
    if (msg.type == MessageType.link && msg.body.link != null) {
      return msg.body.link!.displayTitle;
    }
    if (msg.body.text != null && msg.body.text!.isNotEmpty)
      return msg.body.text!;
    final l10n = AppLocalizations.of(context);
    switch (msg.type) {
      case MessageType.image:
        return l10n.chatImageMessage;
      case MessageType.video:
        return l10n.chatVideoMessage;
      case MessageType.voice:
        return l10n.chatVoiceMessage;
      case MessageType.file:
        return l10n.chatFileMessage;
      default:
        return l10n.chatGenericMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 微信风格：正文气泡 + 下方引用块（分离显示）
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 10,
          left: isSelf ? null : -6,
          right: isSelf ? -6 : null,
          child: CustomPaint(
            key: const ValueKey('message-text-bubble-tail'),
            size: const Size(7, 14),
            painter: _MessageBubbleTailPainter(
              color: bg,
              pointsRight: isSelf,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 正文气泡
            Container(
              key: const ValueKey('message-text-bubble'),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.70),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: message.replyToMessageId != null
                    ? BorderRadius.only(
                        topLeft: br.topLeft,
                        topRight: br.topRight,
                        // 有引用时底部直角，与引用块无缝连接
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero,
                      )
                    : br,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 正文
                  MessageTextContent(
                    message: message,
                    links: textLinks,
                    isSelf: isSelf,
                  ),
                  // 翻译
                  if (message.isTranslating)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: colorScheme.outlineVariant)),
                      ),
                      child: const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ),
                    )
                  else if (message.translation != null &&
                      message.translation!.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: colorScheme.outlineVariant)),
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                            .chatTranslationPrefix(message.translation!),
                        style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7)),
                      ),
                    ),
                ],
              ),
            ),
            // 微信风格引用块：在气泡下方，灰色背景
            if (message.replyToMessageId != null)
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.70),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.only(
                    bottomLeft: br.bottomLeft,
                    bottomRight: br.bottomRight,
                  ),
                ),
                child: _buildReplyBlock(context),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildReplyBlock(BuildContext context) {
    if (replyMessage == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(AppLocalizations.of(context).chatMessageDeleted,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )),
      );
    }

    final sender = replySenderName ?? AppLocalizations.of(context).chatPeer;
    final isImage = replyMessage!.type == MessageType.image;
    final replyMedia = replyMessage!.body.image;
    final imageUrl = imageBubbleVisualSource(replyMedia);

    if (isImage && imageUrl != null && replyMedia != null) {
      // 图片引用：显示缩略图，可点击查看
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$sender：',
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5))),
            _ReplyImagePreview(
              hostMessageId: message.messageId,
              message: replyMessage!,
              media: replyMedia,
              mediaViewerItems: mediaViewerItems,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        '$sender：${_previewOf(context, replyMessage!)}',
        style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _MessageBubbleTailPainter extends CustomPainter {
  final Color color;
  final bool pointsRight;

  const _MessageBubbleTailPainter({
    required this.color,
    required this.pointsRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (pointsRight) {
      path
        ..moveTo(0, 1)
        ..quadraticBezierTo(
          size.width * 0.45,
          2,
          size.width,
          size.height / 2,
        )
        ..quadraticBezierTo(
          size.width * 0.45,
          size.height - 2,
          0,
          size.height - 1,
        );
    } else {
      path
        ..moveTo(size.width, 1)
        ..quadraticBezierTo(
          size.width * 0.55,
          2,
          0,
          size.height / 2,
        )
        ..quadraticBezierTo(
          size.width * 0.55,
          size.height - 2,
          size.width,
          size.height - 1,
        );
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_MessageBubbleTailPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.pointsRight != pointsRight;
}

class _ReplyImagePreview extends StatefulWidget {
  final String hostMessageId;
  final Message message;
  final MediaResource media;
  final List<ChatMediaViewerItem> mediaViewerItems;

  const _ReplyImagePreview({
    required this.hostMessageId,
    required this.message,
    required this.media,
    required this.mediaViewerItems,
  });

  @override
  State<_ReplyImagePreview> createState() => _ReplyImagePreviewState();
}

class _ReplyImagePreviewState extends State<_ReplyImagePreview> {
  String? _displayedPreviewUrl;
  Size? _decodedPreviewSize;
  ImageProvider? _displayedPreviewProvider;
  final ImagePreviewAnchorHandle _previewAnchor = ImagePreviewAnchorHandle();

  void _handlePreviewProvider(ImageProvider provider) {
    if (_displayedPreviewProvider == provider) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _displayedPreviewProvider != provider) {
        setState(() => _displayedPreviewProvider = provider);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _displayedPreviewUrl = imageBubbleVisualSource(widget.media);
  }

  @override
  void didUpdateWidget(_ReplyImagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.messageId != widget.message.messageId ||
        imageBubbleVisualIdentityChanged(oldWidget.media, widget.media)) {
      _displayedPreviewUrl = imageBubbleVisualSource(widget.media);
      _decodedPreviewSize = null;
      _displayedPreviewProvider = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const size = MediaBubbleSize(width: 40, height: 40);
    return GestureDetector(
      onTap: () {
        final item = ChatMediaViewerItem.fromMessage(
          message: widget.message,
          media: widget.media,
          previewUrl: _displayedPreviewUrl,
          previewSize: _decodedPreviewSize,
          previewProvider: _displayedPreviewProvider,
        );
        unawaited(openChatMediaViewer(
          context,
          request: ChatMediaViewerRequest.forItem(
            item: item,
            availableItems: widget.mediaViewerItems,
            initialAnchor: _previewAnchor,
          ),
        ));
      },
      child: ImagePreviewAnchor(
        handle: _previewAnchor,
        sourceIdentity:
            'reply:${widget.hostMessageId}:${widget.message.messageId}',
        imageProvider: _displayedPreviewProvider,
        borderRadius: 4,
        fit: BoxFit.contain,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: _ImageVisualFrame(
              media: widget.media,
              size: size,
              placeholderBuilder: (context, size) => ColoredBox(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: SizedBox(width: size.width, height: size.height),
                  ),
              onVisualSourceResolved: (source) {
                _displayedPreviewUrl = source;
              },
              onIntrinsicSize: (decodedSize) {
                _decodedPreviewSize = decodedSize;
              },
              onImageProviderResolved: (provider) {
                _handlePreviewProvider(provider);
              }),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Image Bubble
// ---------------------------------------------------------------------------

class _ImageBubble extends ConsumerStatefulWidget {
  final Message message;
  final List<ChatMediaViewerItem> mediaViewerItems;
  final TrustedMediaDimensionsResolved? onTrustedMediaDimensionsResolved;
  final MediaPreviewLayoutCache? mediaPreviewLayoutCache;

  const _ImageBubble({
    required this.message,
    required this.mediaViewerItems,
    this.onTrustedMediaDimensionsResolved,
    this.mediaPreviewLayoutCache,
  });

  @override
  ConsumerState<_ImageBubble> createState() => _ImageBubbleState();
}

class _ImageBubbleState extends ConsumerState<_ImageBubble> {
  String? _displayedPreviewUrl;
  Size? _decodedPreviewSize;
  Size? _reportedTrustedSize;
  ImageProvider? _displayedPreviewProvider;
  final ImagePreviewAnchorHandle _previewAnchor = ImagePreviewAnchorHandle();

  void _handlePreviewProvider(ImageProvider provider) {
    if (_displayedPreviewProvider == provider) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _displayedPreviewProvider != provider) {
        setState(() => _displayedPreviewProvider = provider);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _displayedPreviewUrl = imageBubbleVisualSource(widget.message.body.image);
    _decodedPreviewSize = widget.mediaPreviewLayoutCache
        ?.sizeFor(widget.message.messageId, _displayedPreviewUrl);
  }

  @override
  void didUpdateWidget(_ImageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.messageId != widget.message.messageId ||
        imageBubbleVisualIdentityChanged(
          oldWidget.message.body.image,
          widget.message.body.image,
        )) {
      _displayedPreviewUrl = imageBubbleVisualSource(widget.message.body.image);
      _decodedPreviewSize = widget.mediaPreviewLayoutCache
          ?.sizeFor(widget.message.messageId, _displayedPreviewUrl);
      _reportedTrustedSize = null;
      _displayedPreviewProvider = null;
    }
  }

  void _handleIntrinsicSize(Size decodedSize) {
    if (!decodedSize.width.isFinite ||
        !decodedSize.height.isFinite ||
        decodedSize.width <= 0 ||
        decodedSize.height <= 0) {
      return;
    }
    final binding = WidgetsBinding.instance;
    binding.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_decodedPreviewSize != decodedSize) {
        setState(() => _decodedPreviewSize = decodedSize);
      }
      final source = _displayedPreviewUrl ??
          imageBubbleVisualSource(widget.message.body.image);
      widget.mediaPreviewLayoutCache
          ?.remember(widget.message.messageId, source, decodedSize);
      final media = widget.message.body.image;
      if (!isLocalVisualMediaUrl(source) ||
          _hasValidDisplayDimensions(media) ||
          _reportedTrustedSize == decodedSize) {
        return;
      }
      _reportedTrustedSize = decodedSize;
      widget.onTrustedMediaDimensionsResolved?.call(
        widget.message,
        decodedSize,
      );
    });
    binding.ensureVisualUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    final media = message.body.image;
    final viewerUrl = imageBubbleVisualSource(media);
    final uploadPresentation =
        imageMessageUploadPresentation(message.localUploadState);
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final viewportShortestSide = MediaQuery.sizeOf(context).shortestSide;
        final resolvedSource = _displayedPreviewUrl ?? viewerUrl;
        final decodedSourceIsTrusted = isLocalVisualMediaUrl(resolvedSource);
        final size = imageBubbleSize(
          media,
          availableWidth: availableWidth,
          viewportShortestSide: viewportShortestSide,
          trustedDecodedSize:
              decodedSourceIsTrusted ? _decodedPreviewSize : null,
          visualFallbackSize:
              decodedSourceIsTrusted ? null : _decodedPreviewSize,
        );
        return GestureDetector(
          onTap:
              viewerUrl != null && media != null && !uploadPresentation.active
                  ? () {
                      final item = ChatMediaViewerItem.fromMessage(
                        message: message,
                        media: media,
                        previewUrl: _displayedPreviewUrl ?? viewerUrl,
                        previewSize: _decodedPreviewSize,
                        previewProvider: _displayedPreviewProvider,
                      );
                      unawaited(openChatMediaViewer(
                        context,
                        request: ChatMediaViewerRequest.forItem(
                          item: item,
                          availableItems: widget.mediaViewerItems,
                          initialAnchor: _previewAnchor,
                        ),
                      ));
                    }
                  : null,
          child: ImagePreviewAnchor(
            handle: _previewAnchor,
            sourceIdentity: 'message:${message.messageId}',
            imageProvider: _displayedPreviewProvider,
            borderRadius: 12,
            fit: BoxFit.contain,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                key: const ValueKey('message-image-frame'),
                width: size.width,
                height: size.height,
                child: _ImageVisualFrame(
                  media: media,
                  size: size,
                  placeholderBuilder: _placeholder,
                  onVisualSourceResolved: (source) {
                    _displayedPreviewUrl = source;
                  },
                  onIntrinsicSize: (decodedSize) {
                    _handleIntrinsicSize(decodedSize);
                  },
                  onImageProviderResolved: (provider) {
                    _handlePreviewProvider(provider);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _placeholder(BuildContext ctx, MediaBubbleSize size) =>
      _ImageLoadStatus(size: size, failed: false);
}

class _ImageLoadStatus extends StatelessWidget {
  final MediaBubbleSize size;
  final bool failed;

  const _ImageLoadStatus({required this.size, required this.failed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final label = failed ? l10n.commonLoadFailed : l10n.commonLoading;
    return Semantics(
      label: label,
      child: Container(
        key: ValueKey(failed ? 'message-image-error' : 'message-image-loading'),
        width: size.width,
        height: size.height,
        color: theme.colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.all(8),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  failed ? Icons.broken_image_outlined : Icons.image_outlined,
                  size: 28,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                if (size.width >= 64 && size.height >= 64) ...[
                  const SizedBox(height: 4),
                  Text(label,
                      style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageVisualFrame extends ConsumerStatefulWidget {
  final MediaResource? media;
  final MediaBubbleSize size;
  final Widget Function(BuildContext, MediaBubbleSize) placeholderBuilder;
  final ValueChanged<String?>? onVisualSourceResolved;
  final ValueChanged<Size>? onIntrinsicSize;
  final ValueChanged<ImageProvider>? onImageProviderResolved;

  const _ImageVisualFrame({
    required this.media,
    required this.size,
    required this.placeholderBuilder,
    this.onVisualSourceResolved,
    this.onIntrinsicSize,
    this.onImageProviderResolved,
  });

  @override
  ConsumerState<_ImageVisualFrame> createState() => _ImageVisualFrameState();
}

class _ImageVisualFrameState extends ConsumerState<_ImageVisualFrame> {
  String? _resolvedVisualUrl;
  int _sourceRevision = 0;

  @override
  void initState() {
    super.initState();
    _resolveVisualSource();
  }

  @override
  void didUpdateWidget(_ImageVisualFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media?.localPreviewUrl != widget.media?.localPreviewUrl ||
        oldWidget.media?.url != widget.media?.url ||
        oldWidget.media?.thumbnailUrl != widget.media?.thumbnailUrl) {
      _resolveVisualSource();
    }
  }

  void _resolveVisualSource() {
    final revision = ++_sourceRevision;
    final media = widget.media;
    _resolvedVisualUrl = imageBubbleVisualSource(media);
    widget.onVisualSourceResolved?.call(_resolvedVisualUrl);
    unawaited(() async {
      final resolved = await resolveAvailableImageBubbleVisualSource(media);
      if (!mounted ||
          revision != _sourceRevision ||
          widget.media?.localPreviewUrl != media?.localPreviewUrl ||
          widget.media?.thumbnailUrl != media?.thumbnailUrl ||
          widget.media?.url != media?.url) {
        return;
      }
      if (resolved != _resolvedVisualUrl) {
        setState(() => _resolvedVisualUrl = resolved);
        widget.onVisualSourceResolved?.call(resolved);
      }
    }());
  }

  Widget _networkError(BuildContext context, String failedSource) {
    final fallback = imageBubbleFallbackSource(widget.media, failedSource);
    if (fallback == null) {
      return _ImageLoadStatus(size: widget.size, failed: true);
    }
    final revision = _sourceRevision;
    // Image error builders run during build; switch sources after this frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          revision != _sourceRevision ||
          _resolvedVisualUrl != failedSource) {
        return;
      }
      setState(() {
        ++_sourceRevision;
        _resolvedVisualUrl = fallback;
      });
      widget.onVisualSourceResolved?.call(fallback);
    });
    return widget.placeholderBuilder(context, widget.size);
  }

  @override
  Widget build(BuildContext context) {
    final url = _resolvedVisualUrl;
    if (url == null) {
      return _ImageLoadStatus(size: widget.size, failed: true);
    }

    final isLocalFile = isLocalVisualMediaUrl(url) &&
        !url.startsWith('/media') &&
        !url.startsWith('/api');
    if (isLocalFile) {
      return localImageWidget(
        localPathFromUriOrPath(url),
        diagnostic: MediaDiagnosticOperation(
            scope: ref.read(mediaDiagnosticScopeProvider),
            kind: DiagnosticMediaKind.image,
            resource: url),
        width: widget.size.width,
        height: widget.size.height,
        fit: BoxFit.contain,
        onImageSize: widget.onIntrinsicSize,
        onImageProviderResolved: widget.onImageProviderResolved,
      );
    }
    return AppNetworkImage(
      key: ValueKey(url),
      url: url,
      width: widget.size.width,
      height: widget.size.height,
      fit: BoxFit.contain,
      onImageSize: widget.onIntrinsicSize,
      onImageProviderResolved: widget.onImageProviderResolved,
      placeholderBuilder: (context) =>
          widget.placeholderBuilder(context, widget.size),
      errorBuilder: (context) => _networkError(context, url),
    );
  }
}

// ---------------------------------------------------------------------------
// Voice Bubble — AudioPlayerService 互斥播放 + 微信式时长气泡
// ---------------------------------------------------------------------------

double voiceBubbleWidthForDuration(int durationSeconds) {
  final duration = durationSeconds.clamp(0, 60);
  final shortPart = math.min(duration, 5) * 6.0;
  final longPart = math.max(duration - 5, 0) * 3.0;
  return (78.0 + shortPart + longPart).clamp(78.0, 184.0);
}

const int voiceSpeakerLayerCount = 3;
const double messageAvatarSize = 36;
const double voiceBubbleVisibleHeight = 36;
const double voiceBubbleTapTargetHeight = 44;
const double voiceBubbleContentGap = 6;
const double voiceSpeakerSize = 18;
const double voiceDurationFontSize = 15;

class _VoiceBubble extends ConsumerStatefulWidget {
  final Message message;
  final Color bg;
  final BorderRadius br;
  final bool isSelf;
  final VoidCallback? onConvertVoiceToText;

  const _VoiceBubble({
    required this.message,
    required this.bg,
    required this.br,
    required this.isSelf,
    this.onConvertVoiceToText,
  });

  @override
  ConsumerState<_VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends ConsumerState<_VoiceBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  StreamSubscription<PlayerState>? _playerSub;
  bool _listened = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    final svc = ref.read(audioPlayerServiceProvider);
    _playerSub = svc.playerStateStream.listen((state) {
      if (!mounted) {
        return;
      }
      if (svc.currentlyPlayingId != widget.message.messageId) {
        if (_ctrl.isAnimating) {
          _ctrl
            ..stop()
            ..reset();
          setState(() {});
        }
        return;
      }
      if (isVoicePlaybackCompleted(state)) {
        _ctrl
          ..stop()
          ..reset();
        unawaited(svc.stop());
      } else if (state.playing) {
        if (!_ctrl.isAnimating) {
          _ctrl.repeat(reverse: true);
        }
        _listened = true;
      } else {
        _ctrl.stop();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _playerSub?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  bool get _isPlaying {
    final svc = ref.read(audioPlayerServiceProvider);
    return svc.currentlyPlayingId == widget.message.messageId && svc.isPlaying;
  }

  Future<void> _togglePlay() async {
    final svc = ref.read(audioPlayerServiceProvider);
    final url = widget.message.body.voice?.url.trim();
    if (url == null || url.isEmpty) return;

    if (svc.currentlyPlayingId == widget.message.messageId && svc.isPlaying) {
      await svc.pause();
      _ctrl.stop();
    } else {
      try {
        final token = ref.read(currentSpaceProvider)?.accessToken;
        final spaceId = ref.read(currentSpaceProvider)?.spaceId;
        final media = widget.message.body.voice;
        final source = spaceId == null || media == null
            ? url
            : await ref.read(mediaOpenControllerProvider(spaceId)).localPathFor(
                  MediaOpenRequest.fromResource(
                    message: widget.message,
                    mediaKind: MediaKind.voice,
                    variant: MediaVariant.voiceSource,
                    resource: media,
                    fallbackName: 'voice.m4a',
                  ),
                );
        await svc.play(widget.message.messageId, source, token: token);
      } catch (error) {
        debugPrint('[VoiceBubble] playback failed: $error');
        _ctrl.stop();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context).commonOperationFailed),
          ));
        }
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Listen to player state to update UI
    ref.listen(audioPlayerServiceProvider, (_, __) {
      if (mounted) setState(() {});
    });

    final duration = widget.message.body.voice?.durationSeconds ?? 0;
    final isPlaying = _isPlaying;
    final hasVoiceText = widget.message.translation?.isNotEmpty == true;

    final bubbleWidth = voiceBubbleWidthForDuration(duration);

    return Column(
      crossAxisAlignment:
          widget.isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 15,
                  left: widget.isSelf ? null : -6,
                  right: widget.isSelf ? -6 : null,
                  child: CustomPaint(
                    key: const ValueKey('message-voice-bubble-tail'),
                    size: const Size(7, 14),
                    painter: _VoiceBubbleTailPainter(
                      color: widget.bg,
                      pointsRight: widget.isSelf,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _togglePlay,
                  child: SizedBox(
                    width: bubbleWidth,
                    height: voiceBubbleTapTargetHeight,
                    child: Center(
                      child: Container(
                        key: const ValueKey('message-voice-bubble'),
                        width: bubbleWidth,
                        height: voiceBubbleVisibleHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: widget.bg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: widget.isSelf
                              ? [
                                  const Spacer(),
                                  Text(
                                    '$duration"',
                                    style: TextStyle(
                                      fontSize: voiceDurationFontSize,
                                      height: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: voiceBubbleContentGap),
                                  _buildAnimatedSpeaker(isPlaying),
                                ]
                              : [
                                  _buildAnimatedSpeaker(isPlaying),
                                  const SizedBox(width: voiceBubbleContentGap),
                                  Text(
                                    '$duration"',
                                    style: TextStyle(
                                      fontSize: voiceDurationFontSize,
                                      height: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (!widget.isSelf && !_listened) ...[
              const SizedBox(width: 6),
              Container(
                key: const ValueKey('message-voice-unread-dot'),
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4D4F),
                  shape: BoxShape.circle,
                ),
              ),
            ],
            if (!widget.isSelf &&
                !hasVoiceText &&
                widget.onConvertVoiceToText != null) ...[
              const SizedBox(width: 10),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: widget.message.isTranslating
                      ? null
                      : widget.onConvertVoiceToText,
                  child: Container(
                    key: const ValueKey('message-voice-convert-chip'),
                    height: 24,
                    constraints: const BoxConstraints(minWidth: 54),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: widget.message.isTranslating
                        ? SizedBox(
                            width: 13,
                            height: 13,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.38),
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context).chatVoiceToText,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.38),
                              fontSize: 13,
                              height: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ],
        ),
        if (widget.message.isTranslating &&
            (widget.isSelf || widget.onConvertVoiceToText == null))
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          ),
        // 转文字内容
        if (hasVoiceText)
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.message.translation!,
              style: TextStyle(
                  fontSize: 13,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
      ],
    );
  }

  /// 微信风格三级声波：一个 90° 扇形挖掉两圈空白。
  Widget _buildAnimatedSpeaker(bool isPlaying) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return SizedBox(
          width: voiceSpeakerSize,
          height: voiceSpeakerSize,
          child: CustomPaint(
            painter: _SpeakerPainter(
              progress: isPlaying ? _ctrl.value : 1.0,
              color: Theme.of(context).colorScheme.onSurface,
              reverse: widget.isSelf,
            ),
          ),
        );
      },
    );
  }
} // end _VoiceBubbleState

// ---------------------------------------------------------------------------
// Speaker Painter — 微信风格三级声波（单一扇形挖两圈空白）
// ---------------------------------------------------------------------------

class _VoiceBubbleTailPainter extends CustomPainter {
  final Color color;
  final bool pointsRight;

  const _VoiceBubbleTailPainter({
    required this.color,
    required this.pointsRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (pointsRight) {
      path
        ..moveTo(0, 1)
        ..quadraticBezierTo(
          size.width * 0.45,
          2,
          size.width,
          size.height / 2,
        )
        ..quadraticBezierTo(
          size.width * 0.45,
          size.height - 2,
          0,
          size.height - 1,
        );
    } else {
      path
        ..moveTo(size.width, 1)
        ..quadraticBezierTo(
          size.width * 0.55,
          2,
          0,
          size.height / 2,
        )
        ..quadraticBezierTo(
          size.width * 0.55,
          size.height - 2,
          size.width,
          size.height - 1,
        );
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_VoiceBubbleTailPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.pointsRight != pointsRight;
}

class _SpeakerPainter extends CustomPainter {
  static final Path _sourceVoicePath = _buildSourceVoicePath();

  final double progress; // 0~1，播放时动画进度
  final Color color;
  final bool reverse;

  const _SpeakerPainter({
    required this.progress,
    required this.color,
    required this.reverse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (reverse) {
      canvas
        ..translate(size.width, 0)
        ..scale(-1, 1);
    }

    // 从参考图提取的同心扇形参数：
    // 基础半径 92、圆心角 90°；挖空 29–43 与 61–75 两圈。
    const sourceOuterRadius = 92.0;
    const sourceMiddleOuterRadius = 61.0;
    const sourceInnerSectorRadius = 29.0;
    final scale = size.height / (sourceOuterRadius * math.sqrt2);
    final center = Offset(
      (size.width - sourceOuterRadius * scale) / 2,
      size.height / 2,
    );
    final transform = Matrix4.diagonal3Values(scale, scale, 1)
      ..setTranslationRaw(center.dx, center.dy, 0);
    final voicePath = _sourceVoicePath.transform(transform.storage);

    canvas.drawPath(
      voicePath,
      Paint()
        ..color = color.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill,
    );

    final revealRadius = switch (progress) {
      >= 1.0 => sourceOuterRadius * scale,
      >= 2 / voiceSpeakerLayerCount => sourceMiddleOuterRadius * scale,
      >= 1 / voiceSpeakerLayerCount => sourceInnerSectorRadius * scale,
      _ => 0.0,
    };
    if (revealRadius > 0) {
      canvas
        ..save()
        ..clipPath(
          Path()
            ..addOval(
              Rect.fromCircle(center: center, radius: revealRadius),
            ),
        )
        ..drawPath(
          voicePath,
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        )
        ..restore();
    }
  }

  static Path _buildSourceVoicePath() {
    final baseSector = _sector(92);
    final innerGap = _ringSector(29, 43);
    final outerGap = _ringSector(61, 75);
    return Path.combine(
      PathOperation.difference,
      Path.combine(PathOperation.difference, baseSector, innerGap),
      outerGap,
    );
  }

  static Path _ringSector(double innerRadius, double outerRadius) {
    return Path.combine(
      PathOperation.difference,
      _sector(outerRadius),
      _sector(innerRadius),
    );
  }

  static Path _sector(double radius) {
    const startAngle = -math.pi / 4;
    const sweepAngle = math.pi / 2;
    final start = Offset(
      radius * math.cos(startAngle),
      radius * math.sin(startAngle),
    );
    return Path()
      ..moveTo(0, 0)
      ..lineTo(start.dx, start.dy)
      ..arcTo(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        startAngle,
        sweepAngle,
        false,
      )
      ..close();
  }

  @override
  bool shouldRepaint(_SpeakerPainter old) =>
      old.progress != progress || old.color != color || old.reverse != reverse;
}

// ---------------------------------------------------------------------------
// Video Bubble
// ---------------------------------------------------------------------------

bool _hasValidDisplayDimensions(MediaResource? media) =>
    media?.width != null &&
    media!.height != null &&
    media.width! > 0 &&
    media.height! > 0;

class _VideoBubble extends ConsumerStatefulWidget {
  final Message message;
  final List<ChatMediaViewerItem> mediaViewerItems;
  final TrustedMediaDimensionsResolved? onTrustedMediaDimensionsResolved;
  final MediaPreviewLayoutCache? mediaPreviewLayoutCache;

  const _VideoBubble({
    required this.message,
    required this.mediaViewerItems,
    this.onTrustedMediaDimensionsResolved,
    this.mediaPreviewLayoutCache,
  });

  @override
  ConsumerState<_VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends ConsumerState<_VideoBubble> {
  String? _displayedPosterUrl;
  Size? _decodedPosterSize;
  Size? _reportedTrustedSize;
  ImageProvider? _displayedPosterProvider;
  final ImagePreviewAnchorHandle _previewAnchor = ImagePreviewAnchorHandle();

  void _handlePosterProvider(ImageProvider provider) {
    if (_displayedPosterProvider == provider) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _displayedPosterProvider != provider) {
        setState(() => _displayedPosterProvider = provider);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _displayedPosterUrl = videoBubblePosterSource(widget.message.body.video);
    _decodedPosterSize = widget.mediaPreviewLayoutCache
        ?.sizeFor(widget.message.messageId, _displayedPosterUrl);
  }

  @override
  void didUpdateWidget(_VideoBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = oldWidget.message.body.video;
    final current = widget.message.body.video;
    if (oldWidget.message.messageId != widget.message.messageId ||
        previous?.url != current?.url ||
        previous?.thumbnailUrl != current?.thumbnailUrl ||
        previous?.localPosterUrl != current?.localPosterUrl) {
      _displayedPosterUrl = videoBubblePosterSource(current);
      _decodedPosterSize = widget.mediaPreviewLayoutCache
          ?.sizeFor(widget.message.messageId, _displayedPosterUrl);
      _reportedTrustedSize = null;
      _displayedPosterProvider = null;
    }
  }

  void _handlePosterSize(Size decodedSize) {
    if (!decodedSize.width.isFinite ||
        !decodedSize.height.isFinite ||
        decodedSize.width <= 0 ||
        decodedSize.height <= 0) {
      return;
    }
    final binding = WidgetsBinding.instance;
    binding.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_decodedPosterSize != decodedSize) {
        setState(() => _decodedPosterSize = decodedSize);
      }
      final source = _displayedPosterUrl ??
          videoBubblePosterSource(widget.message.body.video);
      widget.mediaPreviewLayoutCache
          ?.remember(widget.message.messageId, source, decodedSize);
      final media = widget.message.body.video;
      if (!isLocalVisualMediaUrl(source) ||
          _hasValidDisplayDimensions(media) ||
          _reportedTrustedSize == decodedSize) {
        return;
      }
      _reportedTrustedSize = decodedSize;
      widget.onTrustedMediaDimensionsResolved?.call(
        widget.message,
        decodedSize,
      );
    });
    binding.ensureVisualUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    final posterUrl = videoBubblePosterSource(message.body.video);
    final duration = message.body.video?.durationSeconds;
    final uploadPresentation =
        videoMessageUploadPresentation(message.localUploadState);
    final isLocalPoster = isLocalVisualMediaUrl(posterUrl) &&
        posterUrl != null &&
        !posterUrl.startsWith('/media') &&
        !posterUrl.startsWith('/api');

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final resolvedSource = _displayedPosterUrl ?? posterUrl;
        final decodedSourceIsTrusted = isLocalVisualMediaUrl(resolvedSource);
        final size = videoBubbleSize(
          message.body.video,
          availableWidth: availableWidth,
          viewportShortestSide: MediaQuery.sizeOf(context).shortestSide,
          trustedDecodedSize:
              decodedSourceIsTrusted ? _decodedPosterSize : null,
          visualFallbackSize:
              decodedSourceIsTrusted ? null : _decodedPosterSize,
        );
        return Semantics(
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            key: const ValueKey('message-video-bubble'),
            onTap: uploadPresentation.active
                ? null
                : () {
                    final media = message.body.video;
                    if (media == null || media.url.trim().isEmpty) return;
                    final item = ChatMediaViewerItem.fromMessage(
                      message: message,
                      media: media,
                      previewUrl: _displayedPosterUrl ?? posterUrl,
                      previewSize: _decodedPosterSize,
                      previewProvider: _displayedPosterProvider,
                    );
                    unawaited(openChatMediaViewer(
                      context,
                      request: ChatMediaViewerRequest.forItem(
                        item: item,
                        availableItems: widget.mediaViewerItems,
                        initialAnchor: _previewAnchor,
                      ),
                    ));
                  },
            child: ImagePreviewAnchor(
              handle: _previewAnchor,
              sourceIdentity: 'message:${message.messageId}',
              imageProvider: _displayedPosterProvider,
              borderRadius: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      key: const ValueKey('message-video-poster-frame'),
                      width: size.width,
                      height: size.height,
                      child: _VideoPosterFrame(
                        message: message,
                        media: message.body.video,
                        posterUrl: posterUrl,
                        isLocalPoster: isLocalPoster,
                        width: size.width,
                        height: size.height,
                        placeholderBuilder: _placeholder,
                        onPosterSourceResolved: (source) {
                          _displayedPosterUrl = source;
                        },
                        onPosterSizeResolved: (size) {
                          _handlePosterSize(size);
                        },
                        onPosterProviderResolved: (provider) {
                          _handlePosterProvider(provider);
                        },
                      ),
                    ),
                    if (uploadPresentation.active)
                      _MediaUploadOverlay(
                        key: const ValueKey('message-video-upload-progress'),
                        uploadPresentation: uploadPresentation,
                      )
                    else
                      Container(
                        key: const ValueKey('message-video-play-button'),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle),
                        child: Icon(Icons.play_arrow,
                            color: Theme.of(context).colorScheme.surface,
                            size: 24),
                      ),
                    if (duration != null)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(_fmt(duration),
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontSize: 11)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _placeholder(BuildContext context, double width, double height) =>
      Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.videocam,
          size: 42,
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.34),
        ),
      );

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
}

class _VideoPosterFrame extends ConsumerStatefulWidget {
  final Message message;
  final MediaResource? media;
  final String? posterUrl;
  final bool isLocalPoster;
  final double width;
  final double height;
  final Widget Function(BuildContext, double, double) placeholderBuilder;
  final ValueChanged<String?>? onPosterSourceResolved;
  final ValueChanged<Size>? onPosterSizeResolved;
  final ValueChanged<ImageProvider>? onPosterProviderResolved;

  const _VideoPosterFrame({
    required this.message,
    required this.media,
    required this.posterUrl,
    required this.isLocalPoster,
    required this.width,
    required this.height,
    required this.placeholderBuilder,
    this.onPosterSourceResolved,
    this.onPosterSizeResolved,
    this.onPosterProviderResolved,
  });

  @override
  ConsumerState<_VideoPosterFrame> createState() => _VideoPosterFrameState();
}

class _VideoPosterFrameState extends ConsumerState<_VideoPosterFrame> {
  String? _generatedPosterPath;
  String? _generatingForUrl;
  String? _checkedLocalPosterUrl;
  bool _skipLocalPoster = false;

  @override
  void initState() {
    super.initState();
    _restoreGeneratedPosterFromCache();
    _verifyLocalPosterAvailability();
    _maybeGeneratePoster();
  }

  @override
  void didUpdateWidget(_VideoPosterFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.posterUrl != widget.posterUrl ||
        oldWidget.media?.url != widget.media?.url ||
        oldWidget.message.messageId != widget.message.messageId) {
      _generatedPosterPath = null;
      _checkedLocalPosterUrl = null;
      _skipLocalPoster = false;
      _restoreGeneratedPosterFromCache();
      _verifyLocalPosterAvailability();
      _maybeGeneratePoster();
    }
  }

  void _restoreGeneratedPosterFromCache() {
    _generatedPosterPath = null;
  }

  void _maybeGeneratePoster() {
    final availablePoster = videoBubblePosterSource(
      widget.media,
      generatedPosterUrl: _generatedPosterPath,
      skipLocalPoster: _skipLocalPoster,
    );
    if (availablePoster?.trim().isNotEmpty == true) {
      return;
    }
    final videoUrl = widget.media?.url.trim();
    if (videoUrl == null || videoUrl.isEmpty || videoUrl == _generatingForUrl) {
      return;
    }
    _generatingForUrl = videoUrl;
    unawaited(_generatePoster(videoUrl));
  }

  void _verifyLocalPosterAvailability() {
    final posterUrl = widget.posterUrl?.trim();
    if (posterUrl == null || posterUrl.isEmpty) return;
    if (!isLocalVisualMediaUrl(posterUrl)) return;
    if (_checkedLocalPosterUrl == posterUrl) return;
    _checkedLocalPosterUrl = posterUrl;

    unawaited(() async {
      final exists = await localFileExists(localPathFromUriOrPath(posterUrl));
      if (!mounted || widget.posterUrl?.trim() != posterUrl) return;
      if (!exists) {
        setState(() => _skipLocalPoster = true);
        _maybeGeneratePoster();
      }
    }());
  }

  Future<void> _generatePoster(String videoUrl) async {
    final diagnostic = MediaDiagnosticOperation(
        scope: ref.read(mediaDiagnosticScopeProvider),
        kind: DiagnosticMediaKind.video,
        resource: videoUrl,
        messageId: widget.message.messageId);
    try {
      final accountMediaRoot =
          ref.read(mediaFileRuntimeProvider).accountMediaRoot;
      final cachedPosterPath = await cachedLocalVideoPosterPath(
        videoUrl,
        accountMediaRoot: accountMediaRoot,
      );
      if (cachedPosterPath?.trim().isNotEmpty == true) {
        if (!mounted || _generatingForUrl != videoUrl) return;
        setState(() => _generatedPosterPath = cachedPosterPath);
        return;
      }
      final localVideoPath = _isLocalMediaPath(videoUrl)
          ? localPathFromUriOrPath(videoUrl)
          : await _localVideoPathForPoster();
      if (localVideoPath == null || localVideoPath.trim().isEmpty) {
        if (!mounted || _generatingForUrl != videoUrl) return;
        setState(() => _generatedPosterPath = null);
        return;
      }
      final posterPath = await generateLocalVideoPoster(
        localVideoPath,
        accountMediaRoot: accountMediaRoot,
        cacheKey: videoUrl,
      );
      if (!mounted || _generatingForUrl != videoUrl) return;
      setState(() => _generatedPosterPath = posterPath);
    } catch (error, stack) {
      diagnostic.failed(MediaFailureStage.decode, error, stack);
    }
  }

  Future<String?> _localVideoPathForPoster() async {
    final media = widget.media;
    if (media == null) throw StateError('Video media is empty');
    final spaceId = ref.read(currentSpaceProvider)?.spaceId;
    if (spaceId == null) throw StateError('Current space is empty');
    return ref.read(mediaOpenControllerProvider(spaceId)).cachedLocalPathFor(
          MediaOpenRequest.fromResource(
            message: widget.message,
            mediaKind: MediaKind.video,
            variant: MediaVariant.videoSource,
            resource: media,
            fallbackName: media.fileName ?? 'video.mp4',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final source = videoBubblePosterSource(
      widget.media,
      generatedPosterUrl: _generatedPosterPath,
      skipLocalPoster: _skipLocalPoster,
    );
    widget.onPosterSourceResolved?.call(source);
    if (source == null || source.trim().isEmpty) {
      return widget.placeholderBuilder(context, widget.width, widget.height);
    }

    final isLocal = (!_skipLocalPoster && widget.isLocalPoster) ||
        isLocalVisualMediaUrl(source);
    if (isLocal) {
      return localImageWidget(
        localPathFromUriOrPath(source),
        diagnostic: MediaDiagnosticOperation(
            scope: ref.read(mediaDiagnosticScopeProvider),
            kind: DiagnosticMediaKind.image,
            resource: source),
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
        onImageSize: widget.onPosterSizeResolved,
        onImageProviderResolved: widget.onPosterProviderResolved,
      );
    }
    return AppNetworkImage(
      url: source,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
      cacheInMemory: true,
      onImageSize: widget.onPosterSizeResolved,
      onImageProviderResolved: widget.onPosterProviderResolved,
      placeholderBuilder: (context) =>
          widget.placeholderBuilder(context, widget.width, widget.height),
      errorBuilder: (context) =>
          widget.placeholderBuilder(context, widget.width, widget.height),
    );
  }
}

class _MediaUploadOverlay extends StatelessWidget {
  final MessageUploadPresentation uploadPresentation;

  const _MediaUploadOverlay({
    super.key,
    required this.uploadPresentation,
  });

  @override
  Widget build(BuildContext context) {
    final progress = uploadPresentation.progress.clamp(0, 100).toInt();
    final color =
        uploadPresentation.failed ? Colors.redAccent : const Color(0xFFFFFFFF);
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.52),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CustomPaint(
              painter: _UploadRingPainter(
                progress: progress,
                color: color,
                trackColor: Colors.white.withValues(alpha: 0.22),
                strokeWidth: 1.5,
              ),
            ),
          ),
          if (uploadPresentation.failed)
            const Icon(Icons.error_outline, size: 16, color: Colors.redAccent),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// File Bubble
// ---------------------------------------------------------------------------

class _FileBubble extends ConsumerWidget {
  final Message message;
  final BorderRadius br;
  const _FileBubble({required this.message, required this.br});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final file = message.body.file;
    final name = file?.fileName ?? l10n.chatFileDefaultName;
    final size = file?.sizeBytes;
    final uploadPresentation = fileMessageUploadPresentation(
      message.localUploadState,
      messageStatus: message.status,
    );
    final fileType = _FileTypeStyle.from(file: file, fallbackName: name);
    final statusText = _fileStatusText(
      context: context,
      sizeBytes: size,
      file: file,
      uploadPresentation: uploadPresentation,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final cardWidth = fileBubbleWidth(
          viewportWidth: MediaQuery.sizeOf(context).width,
          availableWidth: availableWidth,
        );
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: uploadPresentation.active
                ? null
                : () => _openMediaResource(
                      context,
                      ref,
                      message,
                      MediaKind.file,
                      MediaVariant.attachment,
                      file,
                      fallbackName: name,
                    ),
            borderRadius: br,
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: cardWidth),
              child: Ink(
                key: const ValueKey('message-file-card'),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: br,
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.18,
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(height: 8),
                          Text(statusText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.1,
                                color: colorScheme.onSurfaceVariant,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _FileIconWithUploadProgress(
                      fileType: fileType,
                      uploadPresentation: uploadPresentation,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _fileStatusText({
    required BuildContext context,
    required int? sizeBytes,
    required MediaResource? file,
    required MessageUploadPresentation uploadPresentation,
  }) {
    final l10n = AppLocalizations.of(context);
    final status = uploadPresentation.failed
        ? l10n.chatFileStatusUploadFailed
        : uploadPresentation.active
            ? uploadPresentation.showPercent
                ? '${l10n.chatFileStatusUploading} '
                    '${uploadPresentation.progress}%'
                : l10n.chatFileStatusUploading
            : _hasLocalFileCandidate(file)
                ? l10n.chatFileStatusDownloaded
                : l10n.chatFileStatusNotDownloaded;
    final sizeText = _fmtSize(sizeBytes);
    return sizeText == null ? status : '$sizeText $status';
  }

  bool _hasLocalFileCandidate(MediaResource? file) {
    if (file == null) return false;
    final url = file.url.trim();
    if (url.isNotEmpty && _isLocalMediaPath(url)) return true;
    final localPreviewUrl = file.localPreviewUrl?.trim();
    return localPreviewUrl != null &&
        localPreviewUrl.isNotEmpty &&
        _isLocalMediaPath(localPreviewUrl);
  }

  String? _fmtSize(int? bytes) {
    if (bytes == null) return null;
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return _fmtUnit(bytes / 1024, 'KB');
    if (bytes < 1024 * 1024 * 1024) {
      return _fmtUnit(bytes / (1024 * 1024), 'MB');
    }
    return _fmtUnit(bytes / (1024 * 1024 * 1024), 'GB');
  }

  String _fmtUnit(double value, String unit) {
    final rounded = value.roundToDouble();
    final compact = value >= 100 || value == rounded
        ? rounded.toInt().toString()
        : value.toStringAsFixed(1);
    return '$compact$unit';
  }
}

class _FileTypeStyle {
  final String label;
  final Color color;

  const _FileTypeStyle({required this.label, required this.color});

  factory _FileTypeStyle.from({
    required MediaResource? file,
    required String fallbackName,
  }) {
    final ext = _fileExtension(file, fallbackName);
    switch (ext) {
      case 'pdf':
        return const _FileTypeStyle(label: 'PDF', color: Color(0xFFE94343));
      case 'doc':
      case 'docx':
        return const _FileTypeStyle(label: 'DOC', color: Color(0xFF3478F6));
      case 'xls':
      case 'xlsx':
      case 'csv':
        return const _FileTypeStyle(label: 'XLS', color: Color(0xFF22A06B));
      case 'ppt':
      case 'pptx':
        return const _FileTypeStyle(label: 'PPT', color: Color(0xFFFF8A34));
      case 'zip':
      case 'rar':
      case '7z':
        return const _FileTypeStyle(label: 'ZIP', color: Color(0xFF7A8599));
      case 'mp3':
        return const _FileTypeStyle(label: 'MP3', color: Color(0xFF8E64D8));
      case 'txt':
        return const _FileTypeStyle(label: 'TXT', color: Color(0xFF6B778C));
      default:
        final label = ext.isEmpty ? 'FILE' : ext.toUpperCase();
        return _FileTypeStyle(
          label: label.length > 4 ? label.substring(0, 4) : label,
          color: const Color(0xFF7A8599),
        );
    }
  }

  static String _fileExtension(MediaResource? file, String fallbackName) {
    final fromName = p.extension(file?.fileName ?? fallbackName).toLowerCase();
    if (fromName.isNotEmpty) return fromName.substring(1);

    switch (file?.mimeType?.trim().toLowerCase()) {
      case 'application/pdf':
        return 'pdf';
      case 'application/msword':
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        return 'doc';
      case 'application/vnd.ms-excel':
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
      case 'text/csv':
        return 'xls';
      case 'application/vnd.ms-powerpoint':
      case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
        return 'ppt';
      case 'application/zip':
      case 'application/vnd.rar':
      case 'application/x-7z-compressed':
        return 'zip';
      case 'audio/mpeg':
        return 'mp3';
      case 'text/plain':
        return 'txt';
      default:
        return '';
    }
  }
}

class _FileIconWithUploadProgress extends StatelessWidget {
  final _FileTypeStyle fileType;
  final MessageUploadPresentation uploadPresentation;

  const _FileIconWithUploadProgress({
    required this.fileType,
    required this.uploadPresentation,
  });

  @override
  Widget build(BuildContext context) {
    final tone = uploadPresentation.failed ? Colors.redAccent : fileType.color;
    final onTone = Theme.of(context).colorScheme.onPrimary;
    return SizedBox(
      key: const ValueKey('message-file-type-icon'),
      width: 32,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _FileDocumentPainter(
                color: tone,
                foldColor: onTone.withValues(alpha: 0.34),
              ),
            ),
          ),
          Text(
            uploadPresentation.failed ? '!' : fileType.label,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: onTone,
              fontSize: 12,
              height: 1,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (uploadPresentation.active)
            SizedBox(
              key: const ValueKey('message-file-upload-progress'),
              width: 16,
              height: 16,
              child: CustomPaint(
                painter: _UploadRingPainter(
                  progress: uploadPresentation.progress,
                  color: onTone,
                  trackColor: onTone.withValues(alpha: 0.32),
                  strokeWidth: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FileDocumentPainter extends CustomPainter {
  final Color color;
  final Color foldColor;

  const _FileDocumentPainter({
    required this.color,
    required this.foldColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fold = size.width * 0.28;
    final body = Path()
      ..moveTo(4, 0)
      ..lineTo(size.width - fold, 0)
      ..lineTo(size.width, fold)
      ..lineTo(size.width, size.height - 4)
      ..quadraticBezierTo(size.width, size.height, size.width - 4, size.height)
      ..lineTo(4, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - 4)
      ..lineTo(0, 4)
      ..quadraticBezierTo(0, 0, 4, 0)
      ..close();

    canvas.drawPath(body, Paint()..color = color);

    final foldPath = Path()
      ..moveTo(size.width - fold, 0)
      ..lineTo(size.width - fold, fold)
      ..lineTo(size.width, fold)
      ..close();
    canvas.drawPath(
      foldPath,
      Paint()..color = foldColor,
    );
  }

  @override
  bool shouldRepaint(covariant _FileDocumentPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.foldColor != foldColor;
  }
}

class _UploadRingPainter extends CustomPainter {
  final int progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  const _UploadRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inset = strokeWidth / 2;
    final arcRect = rect.deflate(inset);
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final meterPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, -math.pi / 2, math.pi * 2, false, trackPaint);
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      math.pi * 2 * (progress.clamp(0, 100).toDouble() / 100),
      false,
      meterPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _UploadRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

Future<void> _openMediaResource(
  BuildContext context,
  WidgetRef ref,
  Message message,
  MediaKind mediaKind,
  MediaVariant variant,
  MediaResource? resource, {
  required String fallbackName,
}) async {
  final media = resource;
  if (media == null) return;
  final rawUrl = media.url.trim();
  if (rawUrl.isEmpty) return;

  try {
    final spaceId = ref.read(currentSpaceProvider)?.spaceId;
    if (spaceId == null || spaceId.isEmpty) {
      throw StateError('Current space is empty');
    }
    final path =
        await ref.read(mediaOpenControllerProvider(spaceId)).localPathFor(
              MediaOpenRequest.fromResource(
                message: message,
                mediaKind: mediaKind,
                variant: variant,
                resource: media,
                fallbackName: fallbackName,
              ),
            );
    final result = await OpenFilex.open(path, type: media.mimeType);
    if (result.type != ResultType.done && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).commonOperationFailed),
      ));
    }
  } catch (error) {
    debugPrint('[MessageBubble] open media failed: $error');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context).commonOperationFailed),
      ));
    }
  }
}

bool _isLocalMediaPath(String url) {
  final uri = Uri.tryParse(url);
  if (uri != null && uri.scheme == 'file') return true;
  if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
    return false;
  }
  return !url.startsWith('/media') &&
      !url.startsWith('/api') &&
      !url.startsWith('/uploads') &&
      !url.startsWith('/files');
}

// ---------------------------------------------------------------------------
// Event Bubble
// ---------------------------------------------------------------------------

class _EventBubble extends StatelessWidget {
  final Message message;
  const _EventBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message.body.text ?? '',
            style: TextStyle(
                fontSize: 12,
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.5))),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Contact Card Bubble — 对照 API ContactCardDto
// ---------------------------------------------------------------------------

class _ContactCardBubble extends StatelessWidget {
  final ContactCardDto? card;
  const _ContactCardBubble({required this.card});

  @override
  Widget build(BuildContext context) {
    final name = card?.displayName ??
        AppLocalizations.of(context).chatContactDefaultName;
    final avatarUrl = card?.avatarUrl;
    final userId = card?.userId ?? '';
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: userId.isNotEmpty ? () => context.push('/profile/$userId') : null,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: avatarUrl != null && avatarUrl.isNotEmpty
                        ? AuthNetworkImage(
                            url: avatarUrl,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _avatarFallback(context, name, 36),
                          )
                        : _avatarFallback(context, name, 36),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      size: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5)),
                ],
              ),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 4, 10, 6),
              child: Text(AppLocalizations.of(context).chatContactCardTitle,
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback(BuildContext context, String name, double size) =>
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF4A90E2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            name.isNotEmpty ? name[0] : '?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: size * 0.4,
            ),
          ),
        ),
      );
}

// ---------------------------------------------------------------------------
// Call Log Bubble — 对照 API CallLogDto
// ---------------------------------------------------------------------------

class _CallLogBubble extends StatelessWidget {
  final Message message;
  final String currentUserId;
  final Color bg;
  final BorderRadius br;
  final VoidCallback? onTap;
  const _CallLogBubble({
    required this.message,
    required this.currentUserId,
    required this.bg,
    required this.br,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final semantic = CallLogPolicy.resolve(
      message,
      currentUserId: currentUserId,
    );
    final display = localizedCallLogDisplay(
      AppLocalizations.of(context),
      semantic,
    );

    IconData icon;
    Color iconColor;

    switch (semantic.outcome) {
      case CallLogOutcome.missed:
        icon = Icons.phone_missed;
        iconColor = Colors.red;
      case CallLogOutcome.canceled:
        icon = Icons.phone_disabled;
        iconColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
      case CallLogOutcome.rejected:
        icon = Icons.phone_disabled;
        iconColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
      case CallLogOutcome.failed:
        icon = Icons.phone_disabled;
        iconColor = Colors.red;
      case CallLogOutcome.completed:
        icon = semantic.mediaKind == CallLogMediaKind.video
            ? Icons.videocam
            : Icons.phone;
        iconColor = _C.green;
      case CallLogOutcome.unknown:
        icon = Icons.call_end;
        iconColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: br,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 180),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: bg, borderRadius: br),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      display.mediaTitle,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: 2),
                    Text(display.statusWithDetail,
                        style: TextStyle(
                            fontSize: 12,
                            color: semantic.outcome == CallLogOutcome.missed
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Location Bubble — 对照 API LocationDto
// ---------------------------------------------------------------------------

class _LocationBubble extends StatelessWidget {
  final LocationDto? loc;
  final Color bg;
  final BorderRadius br;
  const _LocationBubble(
      {required this.loc, required this.bg, required this.br});

  @override
  Widget build(BuildContext context) {
    final title =
        loc?.title ?? AppLocalizations.of(context).chatLocationDefaultTitle;
    final address = loc?.address ?? '';
    final detail = address.isNotEmpty
        ? address
        : loc == null
            ? ''
            : '${loc!.latitude.toStringAsFixed(6)}, '
                '${loc!.longitude.toStringAsFixed(6)}';
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 240,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: br,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _C.green.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              color: _C.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (detail.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.55),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
