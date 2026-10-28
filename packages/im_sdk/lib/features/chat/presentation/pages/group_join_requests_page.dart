import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/permissions/app_permissions.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/chat/domain/entities/group_join_request.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/chat/presentation/providers/group_join_requests_provider.dart';
import 'package:im_sdk/features/chat/presentation/pages/group_settings_page.dart';

class GroupJoinRequestsPage extends ConsumerWidget {
  final String groupId;

  const GroupJoinRequestsPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(groupDetailProvider(groupId));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '入群申请',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: detailAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
        error: (_, __) => Center(
          child: Text(
            '加载失败',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
        data: (detail) {
          if (!AppPermissions.isGroupManager(detail.myRole)) {
            return Center(
              child: Text(
                '仅群主或群管理员可查看入群申请',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            );
          }

          return _AuthorizedRequestsBody(groupId: groupId);
        },
      ),
    );
  }
}

class _AuthorizedRequestsBody extends ConsumerWidget {
  final String groupId;

  const _AuthorizedRequestsBody({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(groupJoinRequestsProvider(groupId));
    final colorScheme = Theme.of(context).colorScheme;
    return requestsAsync.when(
      loading: () => Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      ),
      error: (_, __) => _ErrorView(
        onRetry: () =>
            ref.read(groupJoinRequestsProvider(groupId).notifier).load(),
      ),
      data: (requests) {
        if (requests.isEmpty) {
          return const _EmptyView();
        }
        return RefreshIndicator(
          color: colorScheme.primary,
          onRefresh: () =>
              ref.read(groupJoinRequestsProvider(groupId).notifier).load(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: requests.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: 72,
              color: colorScheme.outlineVariant,
            ),
            itemBuilder: (context, index) => _RequestTile(
              groupId: groupId,
              request: requests[index],
            ),
          ),
        );
      },
    );
  }
}

class _RequestTile extends ConsumerStatefulWidget {
  final String groupId;
  final GroupJoinRequest request;

  const _RequestTile({required this.groupId, required this.request});

  @override
  ConsumerState<_RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends ConsumerState<_RequestTile> {
  bool _saving = false;

  Future<void> _approve() async {
    await _review(
      () => ref
          .read(groupJoinRequestsProvider(widget.groupId).notifier)
          .approve(widget.request.requestId),
      '已同意入群申请',
    );
  }

  Future<void> _reject() async {
    final reason = await _showRejectReason();
    if (reason == null) return;
    await _review(
      () => ref
          .read(groupJoinRequestsProvider(widget.groupId).notifier)
          .reject(widget.request.requestId, reason: reason),
      '已拒绝入群申请',
    );
  }

  Future<void> _review(
    Future<GroupJoinRequestReviewResult> Function() action,
    String successText,
  ) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final result = await action();
      await _refreshAfterReview();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            result == GroupJoinRequestReviewResult.alreadyHandled
                ? '该申请已被处理'
                : successText,
          ),
        ));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('操作失败，请重试')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _refreshAfterReview() async {
    ref.read(groupDetailProvider(widget.groupId).notifier).refresh();
    ref.read(groupMembersProvider(widget.groupId).notifier).refresh();
    final spaceId = ref.read(currentSpaceProvider)?.spaceId;
    if (spaceId != null && spaceId.isNotEmpty) {
      ref.invalidate(conversationsProvider(spaceId));
    }
  }

  Future<String?> _showRejectReason() async {
    final controller = TextEditingController();
    final colorScheme = Theme.of(context).colorScheme;
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AppAlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('拒绝入群申请'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: '填写拒绝原因（可选）',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: Text(
              '拒绝',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(
            avatarUrl: request.avatarUrl,
            name: request.displayName,
            size: 44,
            borderRadius: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        request.displayName,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _StatusPill(status: request.status),
                  ],
                ),
                if (request.message?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    request.message!.trim(),
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (request.isPending) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: _saving ? null : _reject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          side: BorderSide(color: colorScheme.error),
                          minimumSize: const Size(72, 34),
                        ),
                        child: const Text('拒绝'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _saving ? null : _approve,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          minimumSize: const Size(72, 34),
                        ),
                        child: _saving
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.onPrimary,
                                ),
                              )
                            : const Text('同意'),
                      ),
                    ],
                  ),
                ] else if (request.rejectReason?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Text(
                    '拒绝原因：${request.rejectReason!.trim()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
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

class _StatusPill extends StatelessWidget {
  final GroupJoinRequestStatus status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (text, color) = switch (status) {
      GroupJoinRequestStatus.approved => ('已通过', colorScheme.primary),
      GroupJoinRequestStatus.rejected => ('已拒绝', colorScheme.error),
      GroupJoinRequestStatus.handled => (
          '已处理',
          colorScheme.onSurfaceVariant,
        ),
      _ => ('待审核', colorScheme.onSurfaceVariant),
    };
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: color),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '暂无入群申请',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onRetry,
        child: const Text('加载失败，点击重试'),
      ),
    );
  }
}
