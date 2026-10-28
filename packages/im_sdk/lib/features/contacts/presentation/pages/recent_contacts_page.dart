import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/space/space_manager.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/settings/presentation/providers/timezone_provider.dart';

Color _recentPrimaryText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface;

Color _recentSecondaryText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurfaceVariant;

Color _recentHintText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.42);

class RecentContactsPage extends ConsumerWidget {
  const RecentContactsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final space = ref.watch(currentSpaceProvider);
    final spaceId = space?.spaceId ?? 'personal';
    final convsAsync = ref.watch(releaseVisibleConversationsProvider(spaceId));

    return Scaffold(
      backgroundColor: null,
      appBar: buildSettingsAppBar(context, '最近联系'),
      body: convsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
            child: Text('加载失败',
                style: TextStyle(color: _recentSecondaryText(context)))),
        data: (convs) {
          // 按最后活跃时间排序，取前 20 条
          final sorted = [...convs]..sort((a, b) =>
              (b.lastActivityAt ?? DateTime(0))
                  .compareTo(a.lastActivityAt ?? DateTime(0)));
          final recent = sorted.take(20).toList();

          if (recent.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time,
                      size: 48, color: _recentHintText(context)),
                  const SizedBox(height: 12),
                  Text('暂无最近联系',
                      style: TextStyle(
                          fontSize: 14, color: _recentSecondaryText(context))),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: recent.length,
            itemBuilder: (context, i) {
              final c = recent[i];
              final tzOffset = ref.watch(timezoneOffsetProvider);
              final isLast = i == recent.length - 1;
              return Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => context.push(
                        '/chat/${c.conversationId}',
                        extra: {
                          'isGroup': c.type == ConversationType.group,
                          'conversationType': c.type.name,
                          'title': c.title,
                          'avatarUrl': c.avatarUrl,
                        },
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.outline,
                                borderRadius: BorderRadius.circular(
                                    c.type == ConversationType.group ? 12 : 24),
                              ),
                              child: c.avatarUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          c.type == ConversationType.group
                                              ? 12
                                              : 24),
                                      child: AuthNetworkImage(
                                        url: c.avatarUrl!,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      ))
                                  : Center(
                                      child: Text(
                                        c.title.isNotEmpty
                                            ? c.title[0].toUpperCase()
                                            : '?',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                _recentSecondaryText(context)),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.title,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: _recentPrimaryText(context))),
                                  if (c.lastActivityAt != null)
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 12,
                                            color: _recentHintText(context)),
                                        const SizedBox(width: 4),
                                        Text(
                                          formatChatTime(
                                              c.lastActivityAt!, tzOffset),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: _recentHintText(context)),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast)
                      Divider(
                          height: 1,
                          indent: 76,
                          color: Theme.of(context).dividerColor),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
