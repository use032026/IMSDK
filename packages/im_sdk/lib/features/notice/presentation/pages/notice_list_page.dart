import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/notice/domain/entities/notice.dart';
import 'package:im_sdk/features/settings/presentation/providers/timezone_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final noticeListProvider = StateNotifierProvider.autoDispose<NoticeListNotifier,
    AsyncValue<List<Notice>>>(
  (ref) => NoticeListNotifier(ref),
  dependencies: [dioProvider],
);

class NoticeListNotifier extends StateNotifier<AsyncValue<List<Notice>>> {
  final Ref _ref;

  NoticeListNotifier(this._ref) : super(const AsyncLoading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncLoading();
    try {
      final dio = _ref.read(dioProvider);
      final resp = await dio.get('/api/client/v1/announcements');
      final list = resp.data['data'] as List<dynamic>;
      final notices = list
          .map((e) => Notice.fromJson(e as Map<String, dynamic>))
          .where((n) => !n.isExpired)
          .toList();
      _sort(notices);
      state = AsyncData(notices);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void _sort(List<Notice> notices) {
    notices.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      if (a.isImportant && !b.isImportant) return -1;
      if (!a.isImportant && b.isImportant) return 1;
      return b.publishedAt.compareTo(a.publishedAt);
    });
  }

  Future<void> refresh() => _load();

  void markRead(String noticeId) {
    state = state.whenData((list) => list
        .map((n) => n.noticeId == noticeId ? n.copyWith(isRead: true) : n)
        .toList());
  }

  void markAllRead() {
    state = state
        .whenData((list) => list.map((n) => n.copyWith(isRead: true)).toList());
  }
}

// ---------------------------------------------------------------------------
// NoticeListPage
// ---------------------------------------------------------------------------

class NoticeListPage extends ConsumerWidget {
  const NoticeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final noticesAsync = ref.watch(noticeListProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: null,
      appBar: AppBar(
        backgroundColor: null,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.noticeTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          noticesAsync.whenOrNull(
                data: (notices) {
                  final unread = notices.where((n) => !n.isRead).length;
                  if (unread == 0) return const SizedBox.shrink();
                  return TextButton(
                    onPressed: () =>
                        ref.read(noticeListProvider.notifier).markAllRead(),
                    child: Text(
                      '全部已读',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: noticesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                '加载失败',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              TextButton(
                onPressed: () =>
                    ref.read(noticeListProvider.notifier).refresh(),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
        data: (notices) {
          if (notices.isEmpty) {
            return Center(
              child: Text(l10n.noticeEmpty,
                  style: TextStyle(color: colorScheme.onSurfaceVariant)),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(noticeListProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notice = notices[index];
                return _NoticeCard(
                  notice: notice,
                  onTap: () {
                    ref
                        .read(noticeListProvider.notifier)
                        .markRead(notice.noticeId);
                    context.push('/notices/${notice.noticeId}', extra: notice);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notice Card
// ---------------------------------------------------------------------------

class _NoticeCard extends ConsumerWidget {
  final Notice notice;
  final VoidCallback onTap;

  const _NoticeCard({required this.notice, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tzOffset = ref.watch(timezoneOffsetProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: notice.isPinned
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            if (notice.coverImage != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AuthNetworkImage(
                        url: notice.coverImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_not_supported,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (!notice.isRead)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      if (notice.isImportant)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '重要',
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onErrorContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          notice.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: notice.isRead
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notice.isRead && notice.coverImage == null)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  if (notice.summary != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      notice.summary!,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        formatDateWithTimezone(notice.publishedAt, tzOffset),
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      if (notice.isPinned)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '置顶',
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
