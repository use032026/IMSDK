import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/app_update/presentation/app_update_provider.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/presentation/models/conversation_route_policy.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

// ─── 标签数据 ─────────────────────────────────────────────────────────────────
const _barLabels = ['全部', '文字', '图片', '视频', '语音', '文件', '其他'];
const _typeLabels = _barLabels;
const _customLabels = ['阿里云', '房子', '股票', '家人', '药方'];

// ─── Model ───────────────────────────────────────────────────────────────────
enum FavoriteCategory { all, text, image, video, voice, file, other }

class FavoriteItem {
  final String favoriteId;
  final String messageId;
  final String conversationId;
  final String? conversationType;
  final String messageType;
  final FavoriteCategory category;
  final String? preview;
  final String? senderDisplayName;
  final String? conversationTitle;
  final DateTime? favoritedAt;
  final String? thumbnailUrl;
  final Map<String, dynamic>? body;
  final int conversationSeq; // 用于 beforeSeq 精确定位原消息
  final bool isRecalled; // 消息是否已被撤回

  const FavoriteItem({
    required this.favoriteId,
    required this.messageId,
    required this.conversationId,
    required this.conversationType,
    required this.messageType,
    required this.category,
    this.preview,
    this.senderDisplayName,
    this.conversationTitle,
    this.favoritedAt,
    this.thumbnailUrl,
    this.body,
    this.conversationSeq = 0,
    this.isRecalled = false,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    FavoriteCategory cat;
    switch (
        json['favoriteCategory'] as String? ?? json['messageType'] as String?) {
      case 'image':
        cat = FavoriteCategory.image;
      case 'video':
        cat = FavoriteCategory.video;
      case 'voice':
        cat = FavoriteCategory.voice;
      case 'file':
        cat = FavoriteCategory.file;
      case 'text':
      case 'markdown':
        cat = FavoriteCategory.text;
      default:
        cat = FavoriteCategory.other;
    }
    DateTime? favAt;
    final s = json['favoritedAt'] as String?;
    if (s != null) {
      try {
        favAt = DateTime.parse(s);
      } catch (_) {}
    }
    final body = json['body'] as Map<String, dynamic>?;
    return FavoriteItem(
      favoriteId: json['favoriteId'] as String? ?? '',
      messageId: json['messageId'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      conversationType: json['conversationType'] as String?,
      messageType: json['messageType'] as String? ?? '',
      category: cat,
      preview: json['preview'] as String?,
      senderDisplayName: json['senderDisplayName'] as String?,
      conversationTitle: json['conversationTitle'] as String?,
      favoritedAt: favAt,
      thumbnailUrl: (body?['image']?['thumbnailUrl'] ??
          body?['video']?['thumbnailUrl']) as String?,
      body: body,
      conversationSeq: json['conversationSeq'] as int? ?? 0,
      isRecalled: json['isRecalled'] as bool? ?? false,
    );
  }
}

class FavoriteSummary {
  final int totalCount;
  final int textCount;
  final int imageCount;
  final int videoCount;
  final int voiceCount;
  final int fileCount;
  final int otherCount;

  const FavoriteSummary({
    this.totalCount = 0,
    this.textCount = 0,
    this.imageCount = 0,
    this.videoCount = 0,
    this.voiceCount = 0,
    this.fileCount = 0,
    this.otherCount = 0,
  });

  factory FavoriteSummary.fromJson(Map<String, dynamic> json) {
    return FavoriteSummary(
      totalCount: json['totalCount'] as int? ?? 0,
      textCount: json['textCount'] as int? ?? 0,
      imageCount: json['imageCount'] as int? ?? 0,
      videoCount: json['videoCount'] as int? ?? 0,
      voiceCount: json['voiceCount'] as int? ?? 0,
      fileCount: json['fileCount'] as int? ?? 0,
      otherCount: json['otherCount'] as int? ?? 0,
    );
  }
}

// ─── Providers ───────────────────────────────────────────────────────────────
final _searchProvider = StateProvider<String>((ref) => '');
final _categoryProvider =
    StateProvider<FavoriteCategory>((ref) => FavoriteCategory.all);

/// 收藏分类汇总（用于渲染分类标签数量）
final favoritesSummaryProvider = FutureProvider<FavoriteSummary>((ref) async {
  final space = ref.watch(currentSpaceProvider);
  if (space == null || space.accessToken.isEmpty) {
    return const FavoriteSummary();
  }
  final dio = ref.watch(dioProvider);
  final keyword = ref.watch(_searchProvider);
  final params = <String, dynamic>{};
  if (keyword.trim().isNotEmpty) params['keyword'] = keyword.trim();
  final resp = await dio.get<Map<String, dynamic>>(
      '/api/client/v1/favorites/summary',
      queryParameters: params);
  final data = resp.data?['data'] as Map<String, dynamic>?;
  if (data == null) return const FavoriteSummary();
  return FavoriteSummary.fromJson(data);
}, dependencies: [dioProvider]);

final favoritesProvider = FutureProvider<List<FavoriteItem>>((ref) async {
  final space = ref.watch(currentSpaceProvider);
  if (space == null || space.accessToken.isEmpty) return [];
  final dio = ref.watch(dioProvider);
  final keyword = ref.watch(_searchProvider);
  final category = ref.watch(_categoryProvider);
  final params = <String, dynamic>{'limit': 50};
  if (keyword.trim().isNotEmpty) params['keyword'] = keyword.trim();
  // 传 category 参数给 API（all 时不传，让服务端返回全部）
  if (category != FavoriteCategory.all) {
    params['category'] =
        category.name; // 'text','image','video','voice','file','other'
  }
  final resp = await dio.get<Map<String, dynamic>>(
      '/api/client/v1/favorites/list',
      queryParameters: params);
  final data = resp.data?['data'];
  final List<dynamic> raw = data is Map
      ? (data['items'] as List<dynamic>? ?? [])
      : data is List
          ? data
          : [];
  return raw
      .map((e) => FavoriteItem.fromJson(e as Map<String, dynamic>))
      .toList();
}, dependencies: [dioProvider]);

// ─── FavoritesPage ───────────────────────────────────────────────────────────
class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});
  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  String? _selectedTag;
  final Set<String> _customSelected = {};
  bool _showPanel = false;

  Map<String, ConversationType> _knownConversationTypes() {
    final spaceId = ref.read(currentSpaceProvider)?.spaceId ?? '';
    final conversations =
        ref.read(conversationsProvider(spaceId)).valueOrNull ??
            const <Conversation>[];
    return {
      for (final conversation in conversations)
        conversation.conversationId: conversation.type,
    };
  }

  ConversationType? _resolvedConversationType(
    FavoriteItem item,
    Map<String, ConversationType> knownConversationTypes,
  ) {
    return resolveConversationTypeForNavigation(
      conversationId: item.conversationId,
      explicitType: item.conversationType,
      knownConversationTypes: knownConversationTypes,
    );
  }

  // ── 删除 ──────────────────────────────────────────────────────────────────
  Future<void> _delete(String id) async {
    try {
      await ref.read(dioProvider).delete('/api/client/v1/favorites/$id');
      ref.invalidate(favoritesProvider);
      ref.invalidate(favoritesSummaryProvider);
    } on Exception catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final err = e is DioException ? ErrorHandler.fromDioException(e) : null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              err is ServerError ? err.message : l10n.favoritesDeleteFailed)));
    }
  }

  // ── 跳转原消息 ────────────────────────────────────────────────────────────
  void _goOriginal(FavoriteItem item) {
    if (item.conversationId.isEmpty) return;
    final conversationType =
        _resolvedConversationType(item, _knownConversationTypes());
    final groupFeaturesBlocked =
        ref.read(appUpdateGroupFeaturesBlockedProvider);
    if (!isConversationVisibleForReleaseFace(
      groupFeaturesBlocked: groupFeaturesBlocked,
      conversationType: conversationType,
    )) {
      return;
    }
    final navigationType = conversationType ?? ConversationType.direct;
    context.push('/chat/${item.conversationId}', extra: {
      ...conversationRouteMetadata(
        conversationId: item.conversationId,
        conversationType: navigationType,
      ),
      'title': item.conversationTitle ?? '',
      // 用 conversationSeq 精确定位原消息（beforeSeq = seq + 1）
      'scrollToMessageId': item.messageId,
      if (item.conversationSeq > 0) 'beforeSeq': item.conversationSeq + 1,
    });
  }

  // ── 详情弹窗 ──────────────────────────────────────────────────────────────
  void _showDetail(FavoriteItem item) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, sc) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: Theme.of(ctx).dividerColor,
                    borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(item.conversationTitle ?? '收藏详情',
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(ctx).colorScheme.onSurface),
                          overflow: TextOverflow.ellipsis),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: Theme.of(ctx)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.55),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Theme.of(ctx).dividerColor),
              Expanded(
                child: SingleChildScrollView(
                  controller: sc,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.senderDisplayName != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            item.senderDisplayName!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(ctx)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.55),
                            ),
                          ),
                        ),
                      _DetailContent(item: item),
                      const SizedBox(height: 16),
                      if (item.favoritedAt != null)
                        Text(
                          '收藏于 ${_fmtFull(item.favoritedAt!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(ctx)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.55),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _goOriginal(item);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(ctx).colorScheme.primary,
                        foregroundColor: Theme.of(ctx).colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(l10n.favoritesViewOriginal,
                          style: const TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String _fmtFull(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}';

  String _fmtShort(DateTime? dt) {
    if (dt == null) return '';
    final d = DateTime.now().difference(dt).inDays;
    if (d == 0) return '今天';
    if (d == 1) return '昨天';
    if (d < 7) return '$d天前';
    return '${dt.month}/${dt.day}';
  }

  IconData _icon(FavoriteCategory c) {
    switch (c) {
      case FavoriteCategory.image:
        return Icons.image_outlined;
      case FavoriteCategory.video:
        return Icons.videocam_outlined;
      case FavoriteCategory.voice:
        return Icons.mic_outlined;
      case FavoriteCategory.file:
        return Icons.insert_drive_file_outlined;
      case FavoriteCategory.text:
        return Icons.text_snippet_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  // ── 分类标签映射 ──────────────────────────────────────────────────────────
  static const _categoryMap = {
    '全部': FavoriteCategory.all,
    '文字': FavoriteCategory.text,
    '图片': FavoriteCategory.image,
    '视频': FavoriteCategory.video,
    '语音': FavoriteCategory.voice,
    '文件': FavoriteCategory.file,
    '其他': FavoriteCategory.other,
  };

  bool _isSelectedCategory(String label) {
    return _selectedTag == label || (_selectedTag == null && label == '全部');
  }

  void _setCategoryTag(String? label) {
    final category = label == null
        ? FavoriteCategory.all
        : _categoryMap[label] ?? FavoriteCategory.all;
    setState(() {
      _selectedTag = category == FavoriteCategory.all ? null : label;
    });
    ref.read(_categoryProvider.notifier).state = category;
    ref.invalidate(favoritesProvider);
    ref.invalidate(favoritesSummaryProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hideGroupFeatures = ref.watch(appUpdateGroupFeaturesBlockedProvider);
    final spaceId = ref.watch(currentSpaceProvider)?.spaceId ?? '';
    final conversations =
        ref.watch(conversationsProvider(spaceId)).valueOrNull ??
            const <Conversation>[];
    final knownConversationTypes = {
      for (final conversation in conversations)
        conversation.conversationId: conversation.type,
    };
    final favAsync = ref.watch(favoritesProvider).whenData(
          (items) => hideGroupFeatures
              ? items
                  .where(
                    (item) => isConversationVisibleForReleaseFace(
                      groupFeaturesBlocked: true,
                      conversationType: _resolvedConversationType(
                        item,
                        knownConversationTypes,
                      ),
                    ),
                  )
                  .toList(growable: false)
              : items,
        );
    final topPad = MediaQuery.of(context).padding.top;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 主体
          Column(
            children: [
              // Header
              Container(
                color: colorScheme.surface,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 导航栏
                      Container(
                        color: colorScheme.surface,
                        height: 44,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  size: 18, color: colorScheme.onSurface),
                              onPressed: () => context.pop(),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(l10n.favoritesTitle,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorScheme.onSurface,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 搜索框
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: colorScheme.shadow
                                      .withValues(alpha: 0.04),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1)),
                            ],
                          ),
                          child: _selectedTag != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  child: Row(
                                    children: [
                                      Icon(Icons.grid_view_rounded,
                                          size: 15, color: colorScheme.primary),
                                      const SizedBox(width: 4),
                                      Text(_selectedTag!,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: colorScheme.primary)),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () => _setCategoryTag(null),
                                        child: Icon(
                                          Icons.close,
                                          size: 15,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.55),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 18,
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(l10n.favoritesSearchHint,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.5))),
                                  ],
                                ),
                        ),
                      ),
                      // 标签栏（始终显示）
                      SizedBox(
                        height: 32,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                                itemCount: _barLabels.length,
                                itemBuilder: (_, i) {
                                  final label = _barLabels[i];
                                  final sel = _isSelectedCategory(label);
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            i < _barLabels.length - 1 ? 20 : 0),
                                    child: GestureDetector(
                                      onTap: () => _setCategoryTag(
                                        label == '全部' || sel ? null : label,
                                      ),
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: sel
                                              ? colorScheme.primary
                                              : colorScheme.onSurface
                                                  .withValues(alpha: 0.55),
                                          fontWeight: sel
                                              ? FontWeight.w500
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () =>
                                  setState(() => _showPanel = !_showPanel),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
                                child: Icon(
                                  _showPanel
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  size: 22,
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.55),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 列表
              Expanded(
                child: favAsync.when(
                  loading: () => Center(
                    child:
                        CircularProgressIndicator(color: colorScheme.primary),
                  ),
                  error: (_, __) => Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '加载失败',
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref.invalidate(favoritesProvider),
                        child: Text(
                          '重试',
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                    ]),
                  ),
                  data: (items) => items.isEmpty
                      ? const _EmptyView()
                      : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (_, i) {
                            final item = items[i];
                            return Dismissible(
                              key: ValueKey(item.favoriteId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: colorScheme.error,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: Icon(Icons.delete_outline,
                                    color: colorScheme.onError),
                              ),
                              onDismissed: (_) => _delete(item.favoriteId),
                              child: _FavTile(
                                item: item,
                                onTap: () => _showDetail(item),
                                fmtShort: _fmtShort,
                                icon: _icon,
                                showDivider: i < items.length - 1,
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
          // 遮罩
          if (_showPanel)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _showPanel = false),
                child: Container(
                  color: Theme.of(context)
                      .colorScheme
                      .scrim
                      .withValues(alpha: 0.26),
                ),
              ),
            ),
          // 内联筛选面板（紧贴搜索框下方）
          if (_showPanel)
            Positioned(
              left: 0,
              right: 0,
              top: topPad + 44 + 54,
              child: _InlineFilterPanel(
                selectedTag: _selectedTag,
                customSelected: _customSelected,
                onClose: () => setState(() => _showPanel = false),
                onTypeTagTap: (label) {
                  _setCategoryTag(label == '全部' ? null : label);
                  setState(() => _showPanel = false);
                },
                onCustomTagTap: (label) => setState(() {
                  _customSelected.contains(label)
                      ? _customSelected.remove(label)
                      : _customSelected.add(label);
                  _showPanel = false;
                }),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── _InlineFilterPanel ───────────────────────────────────────────────────────
class _InlineFilterPanel extends StatelessWidget {
  final String? selectedTag;
  final Set<String> customSelected;
  final ValueChanged<String> onTypeTagTap;
  final ValueChanged<String> onCustomTagTap;
  final VoidCallback onClose;

  const _InlineFilterPanel({
    required this.selectedTag,
    required this.customSelected,
    required this.onTypeTagTap,
    required this.onCustomTagTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelColor = colorScheme.onSurface.withValues(alpha: 0.55);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 类型标题
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Icon(Icons.grid_view_rounded, size: 14, color: labelColor),
                const SizedBox(width: 5),
                Expanded(
                  child: Text('类型',
                      style: TextStyle(fontSize: 13, color: labelColor)),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: Icon(Icons.keyboard_arrow_up_rounded,
                      size: 18, color: labelColor),
                ),
              ],
            ),
          ),
          _TagGrid(
            labels: _typeLabels,
            isSelected: (l) =>
                selectedTag == l || (selectedTag == null && l == '全部'),
            onTap: onTypeTagTap,
            bgColor: colorScheme.surface,
            textColor: colorScheme.onSurface,
            selectedBorder: colorScheme.primary,
          ),
          const SizedBox(height: 4),
          // 标签标题
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                Icon(Icons.label_outline_rounded, size: 14, color: labelColor),
                const SizedBox(width: 5),
                Text('标签', style: TextStyle(fontSize: 13, color: labelColor)),
              ],
            ),
          ),
          _TagGrid(
            labels: _customLabels,
            isSelected: (l) => customSelected.contains(l),
            onTap: onCustomTagTap,
            bgColor: colorScheme.surface,
            textColor: colorScheme.onSurface,
            selectedBorder: colorScheme.primary,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─── _TagGrid ─────────────────────────────────────────────────────────────────
class _TagGrid extends StatelessWidget {
  final List<String> labels;
  final bool Function(String) isSelected;
  final ValueChanged<String> onTap;
  final Color bgColor;
  final Color textColor;
  final Color? selectedBorder;

  const _TagGrid({
    required this.labels,
    required this.isSelected,
    required this.onTap,
    required this.bgColor,
    required this.textColor,
    this.selectedBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3.2,
        ),
        itemCount: labels.length,
        itemBuilder: (_, i) {
          final label = labels[i];
          final sel = isSelected(label);
          return GestureDetector(
            onTap: () => onTap(label),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
                border: sel && selectedBorder != null
                    ? Border.all(color: selectedBorder!, width: 1.5)
                    : null,
                boxShadow: Theme.of(context).brightness == Brightness.light
                    ? [
                        BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withValues(alpha: 0.04),
                            blurRadius: 2,
                            offset: const Offset(0, 1))
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(label,
                  style: TextStyle(fontSize: 14, color: textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          );
        },
      ),
    );
  }
}

// ─── _FavTile ─────────────────────────────────────────────────────────────────
class _FavTile extends StatelessWidget {
  final FavoriteItem item;
  final VoidCallback onTap;
  final String Function(DateTime?) fmtShort;
  final IconData Function(FavoriteCategory) icon;
  final bool showDivider;

  const _FavTile({
    required this.item,
    required this.onTap,
    required this.fmtShort,
    required this.icon,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: item.thumbnailUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AuthNetworkImage(
                              url: item.thumbnailUrl!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ))
                        : Icon(
                            icon(item.category),
                            size: 22,
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.55),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.isRecalled
                              ? AppLocalizations.of(context)
                                  .favoritesOriginalRecalled
                              : (item.preview ??
                                  item.conversationTitle ??
                                  '收藏内容'),
                          style: TextStyle(
                            fontSize: 15,
                            color: colorScheme.onSurface.withValues(
                              alpha: item.isRecalled ? 0.55 : 1,
                            ),
                            fontStyle: item.isRecalled
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.senderDisplayName != null ||
                            item.conversationTitle != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            [
                              if (item.senderDisplayName != null)
                                item.senderDisplayName!,
                              if (item.conversationTitle != null)
                                item.conversationTitle!,
                            ].join(' · '),
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.55),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          fmtShort(item.favoritedAt),
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showDivider)
            Container(
                height: 0.5,
                margin: const EdgeInsets.only(left: 76),
                color: Theme.of(context).dividerColor),
        ],
      ),
    );
  }
}

// ─── _DetailContent ───────────────────────────────────────────────────────────
class _DetailContent extends StatelessWidget {
  final FavoriteItem item;
  const _DetailContent({required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.category == FavoriteCategory.image) {
      final url = item.thumbnailUrl ?? item.body?['image']?['url'] as String?;
      if (url != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AuthNetworkImage(
              url: url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                    Icons.broken_image,
                    size: 48,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.55),
                  )),
        );
      }
    }
    if (item.category == FavoriteCategory.video) {
      return Container(
        height: 160,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inverseSurface,
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Icon(
            Icons.play_circle_outline,
            size: 56,
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
        ),
      );
    }
    return Text(item.preview ?? '（无内容）',
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).colorScheme.onSurface,
          height: 1.6,
        ));
  }
}

// ─── _EmptyView ───────────────────────────────────────────────────────────────
class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final emptyColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45);
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.description_outlined, size: 48, color: emptyColor),
        const SizedBox(height: 12),
        Text(l10n.favoritesEmpty,
            style: TextStyle(fontSize: 14, color: emptyColor)),
      ]),
    );
  }
}
