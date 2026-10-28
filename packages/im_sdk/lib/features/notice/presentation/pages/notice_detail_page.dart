import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/notice/domain/entities/notice.dart';
import 'package:im_sdk/features/settings/presentation/providers/timezone_provider.dart';

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final noticeDetailProvider =
    FutureProvider.family<Notice, String>((ref, noticeId) async {
  final dio = ref.watch(dioProvider);
  final resp = await dio.get('/api/client/v1/announcements/$noticeId');
  return Notice.fromJson(resp.data['data'] as Map<String, dynamic>);
}, dependencies: [dioProvider]);

// ---------------------------------------------------------------------------
// NoticeDetailPage
// ---------------------------------------------------------------------------

class NoticeDetailPage extends ConsumerWidget {
  final String noticeId;
  final Notice? preloadedNotice;

  const NoticeDetailPage({
    super.key,
    required this.noticeId,
    this.preloadedNotice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (preloadedNotice != null) {
      return _buildScaffold(context, ref, preloadedNotice!);
    }

    final noticeAsync = ref.watch(noticeDetailProvider(noticeId));
    return noticeAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => context.pop(),
          ),
          title: const Text('公告详情'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => context.pop(),
          ),
          title: const Text('公告详情'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('加载失败'),
              TextButton(
                onPressed: () => ref.invalidate(noticeDetailProvider(noticeId)),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
      data: (notice) => _buildScaffold(context, ref, notice),
    );
  }

  Widget _buildScaffold(BuildContext context, WidgetRef ref, Notice notice) {
    final tzOffset = ref.watch(timezoneOffsetProvider);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: null,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '公告详情',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Priority badge
            if (notice.isImportant)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '重要公告',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            // Title
            Text(
              notice.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            // Meta info
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  formatChineseFullMinuteWithTimezone(
                    notice.publishedAt,
                    tzOffset,
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (notice.isPinned) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
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
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: colorScheme.outlineVariant),
            const SizedBox(height: 16),
            // Cover image
            if (notice.coverImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AuthNetworkImage(
                  url: notice.coverImage!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported,
                      color: colorScheme.onSurfaceVariant,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Content
            _NoticeContent(content: notice.content),
            const SizedBox(height: 32),
            // Footer
            Center(
              child: Text(
                '本服务由微界提供安全加密技术支持',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content renderer
// ---------------------------------------------------------------------------

class _NoticeContent extends StatelessWidget {
  final String content;

  const _NoticeContent({required this.content});

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('**') && line.endsWith('**')) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 6),
            child: Text(
              line.replaceAll('**', ''),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          );
        }
        if (line.startsWith('•') || line.startsWith('-')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 8),
            child: Text(
              line,
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          );
        }
        if (line.trim().isEmpty) {
          return const SizedBox(height: 8);
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            line,
            style: TextStyle(
              fontSize: 15,
              color: colorScheme.onSurfaceVariant,
              height: 1.7,
            ),
          ),
        );
      }).toList(),
    );
  }
}
