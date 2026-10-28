import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/app/theme/theme.dart';
import 'package:im_sdk/core/widgets/app_toast.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/space/domain/entities/space_entity.dart';
import 'package:im_sdk/features/space/presentation/providers/spaces_provider.dart';
import 'package:im_sdk/shared/widgets/app_badge.dart';

/// 空间列表页
///
/// 展示所有空间的卡片列表：
/// - Logo + 名称 + "X 条会话 · Y 条未读"
/// - 当前激活空间：浅绿背景卡片 + 右侧绿色圆点
/// - 未读数角标（红色）
/// - 点击切换空间
class SpaceListPage extends ConsumerWidget {
  const SpaceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacesAsync = ref.watch(spacesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('切换空间'),
        backgroundColor: colorScheme.surface,
      ),
      body: spacesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            '加载失败：$error',
            style: AppTextStyles.bodySecondary.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        data: (spaces) => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: spaces.length,
          separatorBuilder: (_, __) => const SizedBox(height: 0),
          itemBuilder: (context, index) {
            final space = spaces[index];
            return _SpaceCard(
              space: space,
              onTap: () async {
                if (!space.isActive) {
                  try {
                    await ref
                        .read(spacesProvider.notifier)
                        .switchSpace(space.spaceId);
                  } catch (error) {
                    if (context.mounted) {
                      AppToast.error(
                        context,
                        error.toString().replaceFirst('Exception: ', ''),
                      );
                    }
                    return;
                  }
                }
                if (context.mounted) Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}

class _SpaceCard extends StatelessWidget {
  final Space space;
  final VoidCallback onTap;

  const _SpaceCard({required this.space, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeBackground = colorScheme.primary.withValues(alpha: 0.12);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: space.isActive ? activeBackground : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // 空间 Logo
            AppBadge(
              count: space.unreadCount,
              child: _SpaceAvatar(space: space),
            ),

            const SizedBox(width: 12),

            // 名称 + 会话信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    space.name,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: space.isActive
                          ? AppColors.primary
                          : colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _buildSubtitle(space),
                    style: AppTextStyles.caption.copyWith(
                      color: space.isActive
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // 激活状态：绿色圆点
            if (space.isActive)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle(Space space) {
    final parts = <String>[];
    if (space.conversationCount > 0) {
      parts.add('${space.conversationCount} 个未读会话');
    } else {
      parts.add('暂无未读会话');
    }
    if (space.unreadCount > 0) {
      parts.add('${space.unreadCount} 条未读消息');
    }
    return parts.join(' · ');
  }
}

/// 空间头像（Logo 图片或首字母）
class _SpaceAvatar extends StatelessWidget {
  final Space space;

  const _SpaceAvatar({required this.space});

  @override
  Widget build(BuildContext context) {
    if (space.logoUrl != null && space.logoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AuthNetworkImage(
          url: space.logoUrl!,
          cacheScope: NetworkImageCacheScope.spaceDirectory,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(context),
        ),
      );
    }
    return _fallback(context);
  }

  Widget _fallback(BuildContext context) {
    final isPersonal = space.isPersonal;
    final label = space.name.isNotEmpty ? space.name[0].toUpperCase() : '企';

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: isPersonal
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF07C160), Color(0xFF00A854)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: isPersonal
          ? Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 26,
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
    );
  }
}
