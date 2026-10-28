import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/features/settings/presentation/providers/timezone_provider.dart';

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

class GroupAnnouncement {
  final String announcementId;
  final String conversationId;
  final String publisherUserId;
  final String? publisherDisplayName;
  final String? title;
  final String content;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GroupAnnouncement({
    required this.announcementId,
    required this.conversationId,
    required this.publisherUserId,
    this.publisherDisplayName,
    this.title,
    required this.content,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupAnnouncement.fromJson(Map<String, dynamic> json) {
    return GroupAnnouncement(
      announcementId: json['announcementId'] as String,
      conversationId: json['conversationId'] as String? ?? '',
      publisherUserId: json['publisherUserId'] as String? ?? '',
      publisherDisplayName: json['publisherDisplayName'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String? ?? '',
      isPinned: json['isPinned'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final groupAnnouncementsProvider =
    FutureProvider.family<List<GroupAnnouncement>, String>(
        (ref, groupId) async {
  final dio = ref.watch(dioProvider);
  final resp = await dio.get('/api/client/v1/groups/$groupId/announcements');
  final list = resp.data['data'] as List<dynamic>? ?? [];
  return list
      .map((e) => GroupAnnouncement.fromJson(e as Map<String, dynamic>))
      .toList();
}, dependencies: [dioProvider]);

// ---------------------------------------------------------------------------
// GroupAnnouncementPage
// ---------------------------------------------------------------------------

class GroupAnnouncementPage extends ConsumerWidget {
  final String groupId;
  final bool isAdminOrAbove;

  const GroupAnnouncementPage({
    super.key,
    required this.groupId,
    required this.isAdminOrAbove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(groupAnnouncementsProvider(groupId));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '群公告',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          if (isAdminOrAbove)
            TextButton(
              onPressed: () => _showEditSheet(context, ref, null),
              child: Text('发布',
                  style: TextStyle(
                      fontSize: 15,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500)),
            ),
        ],
      ),
      body: announcementsAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
        error: (_, __) => Center(
          child: TextButton(
            onPressed: () =>
                ref.invalidate(groupAnnouncementsProvider(groupId)),
            child: Text(
              '加载失败，点击重试',
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ),
        data: (announcements) {
          if (announcements.isEmpty) {
            return Center(
              child: Text('暂无公告',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 15,
                  )),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: announcements.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final a = announcements[i];
              return _AnnouncementCard(
                announcement: a,
                isAdminOrAbove: isAdminOrAbove,
                onEdit: () => _showEditSheet(context, ref, a),
                onDelete: () => _delete(context, ref, a.announcementId),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditSheet(
      BuildContext context, WidgetRef ref, GroupAnnouncement? existing) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _AnnouncementEditSheet(
        groupId: groupId,
        existing: existing,
        onSaved: () {
          ref.invalidate(groupAnnouncementsProvider(groupId));
        },
      ),
    );
  }

  Future<void> _delete(
      BuildContext context, WidgetRef ref, String announcementId) async {
    final colorScheme = Theme.of(context).colorScheme;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppAlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('删除公告'),
        content: const Text('确定删除这条公告吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              '取消',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              '删除',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      final dio = ref.read(dioProvider);
      await dio.delete(
          '/api/client/v1/groups/$groupId/announcements/$announcementId');
      ref.invalidate(groupAnnouncementsProvider(groupId));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('删除失败，请重试')));
      }
    }
  }
}

// ---------------------------------------------------------------------------
// AnnouncementCard
// ---------------------------------------------------------------------------

class _AnnouncementCard extends ConsumerWidget {
  final GroupAnnouncement announcement;
  final bool isAdminOrAbove;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AnnouncementCard({
    required this.announcement,
    required this.isAdminOrAbove,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tzOffset = ref.watch(timezoneOffsetProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 置顶标签 + 标题
          Row(
            children: [
              if (announcement.isPinned) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('置顶',
                      style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  announcement.title?.isNotEmpty == true
                      ? announcement.title!
                      : '公告',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isAdminOrAbove)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onSelected: (v) {
                    if (v == 'edit') onEdit();
                    if (v == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('编辑')),
                    PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          '删除',
                          style: TextStyle(color: colorScheme.error),
                        )),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          // 内容
          Text(announcement.content,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
                height: 1.5,
              )),
          const SizedBox(height: 8),
          // 发布者 + 时间
          Row(
            children: [
              if (announcement.publisherDisplayName != null)
                Text(announcement.publisherDisplayName!,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    )),
              const Spacer(),
              Text(
                  formatFullMinuteWithTimezone(
                      announcement.createdAt, tzOffset),
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AnnouncementEditSheet
// ---------------------------------------------------------------------------

class _AnnouncementEditSheet extends ConsumerStatefulWidget {
  final String groupId;
  final GroupAnnouncement? existing;
  final VoidCallback onSaved;

  const _AnnouncementEditSheet({
    required this.groupId,
    this.existing,
    required this.onSaved,
  });

  @override
  ConsumerState<_AnnouncementEditSheet> createState() =>
      _AnnouncementEditSheetState();
}

class _AnnouncementEditSheetState
    extends ConsumerState<_AnnouncementEditSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  bool _isPinned = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.existing?.content ?? '');
    _isPinned = widget.existing?.isPinned ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_contentCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final dio = ref.read(dioProvider);
      final data = {
        'title': _titleCtrl.text.trim().isEmpty ? null : _titleCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
        'isPinned': _isPinned,
      };
      if (widget.existing != null) {
        await dio.put(
          '/api/client/v1/groups/${widget.groupId}/announcements/${widget.existing!.announcementId}',
          data: data,
        );
      } else {
        await dio.post(
          '/api/client/v1/groups/${widget.groupId}/announcements',
          data: data,
        );
      }
      widget.onSaved();
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('保存失败，请重试')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部栏
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      '取消',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '发布公告',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface),
                    ),
                  ),
                  TextButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: colorScheme.primary))
                        : Text('发布',
                            style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            // 标题
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _titleCtrl,
                style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: '公告标题（选填）',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  border: InputBorder.none,
                ),
              ),
            ),
            Divider(height: 1, indent: 16, color: colorScheme.outlineVariant),
            // 内容
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _contentCtrl,
                maxLines: 5,
                style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: '公告内容',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  border: InputBorder.none,
                ),
              ),
            ),
            Divider(height: 1, indent: 16, color: colorScheme.outlineVariant),
            // 置顶开关
            SwitchListTile(
              title: Text(
                '置顶公告',
                style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
              ),
              value: _isPinned,
              onChanged: (v) => setState(() => _isPinned = v),
              activeThumbColor: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
