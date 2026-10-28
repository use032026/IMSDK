import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/chat/data/mappers/group_read_receipts_mapper.dart';
import 'package:im_sdk/features/chat/presentation/providers/chat_provider.dart';

// ---------------------------------------------------------------------------
// 群聊已读回执页
// GET /api/client/v1/groups/{groupId}/read-receipts
// ---------------------------------------------------------------------------

final _readReceiptsProvider = FutureProvider.autoDispose.family<
    GroupReadReceipts, (String groupId, String messageId, int messageSeq)>(
  (ref, args) async {
    final dio = ref.read(dioProvider);
    final currentSpace = ref.watch(currentSpaceProvider);
    var currentProfile = ref.watch(currentUserProfileProvider);
    if (currentProfile == null && currentSpace?.userId.isNotEmpty == true) {
      await ref.read(profileProvider.notifier).loadProfile();
      currentProfile = ref.read(currentUserProfileProvider);
    }
    final resp = await dio.get<Map<String, dynamic>>(
      '/api/client/v1/groups/${args.$1}/read-receipts',
      queryParameters: {'messageId': args.$2},
    );
    final receipts = parseGroupReadReceiptsPayload(
      resp.data?['data'],
      currentUser: GroupReadReceiptIdentity(
        userId: currentProfile?.userId ?? currentSpace?.userId,
        platformUserId: currentProfile?.platformUserId,
        lppId: currentProfile?.lppId,
        displayName: currentProfile?.displayName,
      ),
      messageSeq: args.$3,
    );
    final spaceId = currentSpace?.spaceId;
    if (spaceId != null && spaceId.isNotEmpty) {
      ref
          .read(chatProvider((spaceId, args.$1, true)).notifier)
          .syncGroupReadReceiptSnapshot(
            messageId: args.$2,
            messageSeq: args.$3,
            readCount: receipts.readCount,
          );
    }
    return receipts;
  },
  dependencies: [
    dioProvider,
    currentUserProfileProvider,
    profileProvider,
    chatProvider,
  ],
);

class GroupReadReceiptsPage extends ConsumerWidget {
  final String groupId;
  final String messageId;
  final int messageSeq;

  const GroupReadReceiptsPage({
    super.key,
    required this.groupId,
    required this.messageId,
    required this.messageSeq,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerKey = (groupId, messageId, messageSeq);
    final receiptsAsync = ref.watch(_readReceiptsProvider(providerKey));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: null,
      appBar: AppBar(
        backgroundColor: null,
        elevation: 0,
        title: Text('已读回执',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: 18, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: 20,
              color: colorScheme.onSurface,
            ),
            onPressed: () => ref.invalidate(_readReceiptsProvider(providerKey)),
          ),
        ],
      ),
      body: receiptsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: TextButton.icon(
            onPressed: () => ref.invalidate(_readReceiptsProvider(providerKey)),
            icon: const Icon(Icons.refresh),
            label: const Text('加载失败，点击重试'),
          ),
        ),
        data: (receipts) {
          final readUsers = receipts.readMembers;
          final unreadUsers = receipts.unreadMembers;

          return RefreshIndicator(
            onRefresh: () async {
              final _ =
                  await ref.refresh(_readReceiptsProvider(providerKey).future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _SectionHeader(
                  title: '已读',
                  count: readUsers.length,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 8),
                if (readUsers.isEmpty)
                  const _EmptyHint(text: '暂无人已读')
                else
                  _UserList(users: readUsers),
                const SizedBox(height: 16),
                _SectionHeader(
                  title: '未读',
                  count: unreadUsers.length,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
                const SizedBox(height: 8),
                if (unreadUsers.isEmpty)
                  const _EmptyHint(text: '所有人已读')
                else
                  _UserList(users: unreadUsers),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _SectionHeader(
      {required this.title, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text('$title ($count)',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

class _UserList extends StatelessWidget {
  final List<GroupReadReceiptMember> users;

  const _UserList({required this.users});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: users.asMap().entries.map((e) {
          final i = e.key;
          final user = e.value;
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    UserAvatar(
                      avatarUrl: user.avatarUrl,
                      name: user.displayName,
                      size: 40,
                      borderRadius: 8,
                    ),
                    const SizedBox(width: 12),
                    Text(user.displayName,
                        style: TextStyle(
                          fontSize: 15,
                          color: colorScheme.onSurface,
                        )),
                  ],
                ),
              ),
              if (i < users.length - 1)
                Divider(
                  height: 1,
                  indent: 68,
                  color: colorScheme.outlineVariant,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;

  const _EmptyHint({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(text,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            )),
      ),
    );
  }
}
