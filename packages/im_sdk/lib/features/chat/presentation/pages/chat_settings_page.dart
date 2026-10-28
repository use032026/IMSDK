import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/permissions/app_permissions.dart';
import 'package:im_sdk/core/widgets/app_toast.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/chat/presentation/controllers/conversation_actions_controller.dart';
import 'package:im_sdk/features/chat/presentation/pages/complaint_page.dart';
import 'package:im_sdk/features/app_update/presentation/app_update_provider.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/presentation/models/conversation_route_policy.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';

// ---------------------------------------------------------------------------
// ChatSettingsPage
// ---------------------------------------------------------------------------
class ChatSettingsPage extends ConsumerStatefulWidget {
  final String chatId;

  const ChatSettingsPage({super.key, required this.chatId});

  @override
  ConsumerState<ChatSettingsPage> createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends ConsumerState<ChatSettingsPage> {
  bool _mutedNotification = false;
  bool _pinned = false;
  bool _isLoading = true;
  String? _peerUserId;
  String? _peerName;
  String? _peerAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadChatDetail();
  }

  Future<void> _loadChatDetail() async {
    try {
      final dio = ref.read(dioProvider);
      final resp =
          await dio.get('/api/client/v1/direct-chats/${widget.chatId}');
      final data = resp.data?['data'] as Map<String, dynamic>?;
      if (data != null && mounted) {
        setState(() {
          _mutedNotification = data['isMuted'] as bool? ?? false;
          _pinned = data['isPinned'] as bool? ?? false;
          _peerUserId = data['peerUserId'] as String?;
          _peerName = data['peerDisplayName'] as String?;
          _peerAvatarUrl = data['peerAvatarUrl'] as String?;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleMute(bool value) async {
    setState(() => _mutedNotification = value);
    try {
      await ref.read(conversationActionsControllerProvider).setMuted(
            widget.chatId,
            muted: value,
            isGroup: false,
          );
    } catch (_) {
      if (mounted) setState(() => _mutedNotification = !value);
    }
  }

  Future<void> _togglePin(bool value) async {
    setState(() => _pinned = value);
    try {
      await ref.read(conversationActionsControllerProvider).setPinned(
            widget.chatId,
            pinned: value,
            isGroup: false,
          );
    } catch (_) {
      if (mounted) setState(() => _pinned = !value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final canCreateGroup = AppPermissions.canCreateGroupForReleaseFace(
          ref.watch(currentSpaceProvider),
          releaseFaceBlocks: ref.watch(appUpdateGroupFeaturesBlockedProvider),
        ) &&
        ref.watch(teenModePolicyProvider).canAttemptCreateGroup;
    return Scaffold(
      backgroundColor: null,
      appBar: AppBar(
        backgroundColor: null,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onSurface,
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text('聊天详情',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            )
          : ListView(
              children: [
                const SizedBox(height: 8),
                _buildMembersSection(context, canCreateGroup),
                const SizedBox(height: 8),
                _buildSection([
                  _SettingItem(
                    icon: Icons.search,
                    label: '查找聊天内容',
                    showArrow: true,
                    onTap: () => context.push('/search', extra: {
                      ...conversationRouteMetadata(
                        conversationId: widget.chatId,
                        conversationType: ConversationType.direct,
                      ),
                      'conversationTitle': _peerName,
                    }),
                  ),
                  const _Divider(),
                  _SettingItem(
                    icon: Icons.schedule_send_outlined,
                    label: '定时消息',
                    showArrow: true,
                    onTap: () => context.push(
                      '/chat/${widget.chatId}/scheduled-messages',
                      extra: conversationRouteMetadata(
                        conversationId: widget.chatId,
                        conversationType: ConversationType.direct,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                _buildSection([
                  _SwitchItem(
                    label: '消息免打扰',
                    value: _mutedNotification,
                    onChanged: _toggleMute,
                  ),
                  const _Divider(),
                  _SwitchItem(
                    label: '置顶聊天',
                    value: _pinned,
                    onChanged: _togglePin,
                  ),
                ]),
                const SizedBox(height: 8),
                _buildSection([
                  _SettingItem(
                    label: '设置当前聊天背景',
                    showArrow: true,
                    onTap: () => context.push(
                      '/chat-background?conversationId=${widget.chatId}',
                      extra: conversationRouteMetadata(
                        conversationId: widget.chatId,
                        conversationType: ConversationType.direct,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                _buildSection([
                  _SettingItem(
                    label: '清空聊天记录',
                    onTap: () => _showClearSheet(context),
                  ),
                ]),
                const SizedBox(height: 8),
                _buildSection([
                  _SettingItem(
                    label: '投诉',
                    showArrow: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ComplaintPage(
                          subjectType: 'direct_chat',
                          subjectId: widget.chatId,
                        ),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildMembersSection(BuildContext context, bool canCreateGroup) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_peerUserId != null)
            GestureDetector(
              onTap: () => context.push('/profile/$_peerUserId'),
              child: Column(
                children: [
                  UserAvatar(
                    avatarUrl: _peerAvatarUrl,
                    name: _peerName ?? '?',
                    size: 48,
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 56,
                    child: Text(
                      _peerName ?? '联系人',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          if (canCreateGroup) const SizedBox(width: 16),
          if (canCreateGroup)
            GestureDetector(
              onTap: () => context.push('/create-group'),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 22,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 56,
                    child: Text('添加',
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(children: children),
    );
  }

  void _showClearSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final colorScheme = Theme.of(sheetContext).colorScheme;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  '清空聊天记录',
                  style: TextStyle(color: colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  AppToast.success(context, '聊天记录已清空');
                },
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              ListTile(
                title: Text(
                  '取消',
                  style: TextStyle(color: colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
                onTap: () => Navigator.pop(sheetContext),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Helper widgets
// ---------------------------------------------------------------------------

class _SettingItem extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool showArrow;
  final VoidCallback? onTap;

  const _SettingItem({
    this.icon,
    required this.label,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
              ),
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

class _SwitchItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchItem({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colorScheme.primary,
            activeTrackColor: colorScheme.primary.withValues(alpha: 0.55),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 16),
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
