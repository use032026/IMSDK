import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/app_update/presentation/app_update_provider.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/domain/usecases/message_badge_count.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/space/data/repositories/space_repository_impl.dart';
import 'package:im_sdk/features/space/domain/entities/space_entity.dart';
import 'package:im_sdk/features/space/domain/repositories/space_repository.dart';

// ---------------------------------------------------------------------------
// Repository Provider
// ---------------------------------------------------------------------------

final _spaceRepositoryProvider = Provider<SpaceRepository>((ref) {
  return SpaceRepositoryImpl(
    getCurrentSpace: () => ref.read(accountRuntimeCurrentSpaceProvider),
    getAvailableTenants: () =>
        ref.read(authProvider).valueOrNull?.availableTenants ?? [],
    hasPlatformSession: () =>
        ref.read(authProvider).valueOrNull?.platformToken?.isNotEmpty == true,
  );
}, dependencies: [accountRuntimeCurrentSpaceProvider, authProvider]);

// ---------------------------------------------------------------------------
// Spaces Provider
// ---------------------------------------------------------------------------

/// 空间列表 Provider
final spacesProvider = AsyncNotifierProvider<SpacesNotifier, List<Space>>(
  SpacesNotifier.new,
  dependencies: [
    dioProvider,
    _spaceRepositoryProvider,
    authProvider,
    accountRuntimeCurrentSpaceProvider,
    accountStorageContextProvider,
    conversationsProvider,
    releaseVisibleConversationsProvider,
    appUpdateGroupFeaturesBlockedProvider,
    spaceUnreadSummaryProvider,
  ],
);

class SpacesNotifier extends AsyncNotifier<List<Space>> {
  SpaceRepository get _repo => ref.read(_spaceRepositoryProvider);

  @override
  Future<List<Space>> build() async {
    // 当前空间的红点必须和消息页同源：只统计过滤后的普通 IM 会话。
    final currentSpace = ref.watch(accountRuntimeCurrentSpaceProvider);
    if (currentSpace != null) {
      ref.watch(releaseVisibleConversationsProvider(currentSpace.spaceId));
    }
    final unreadSummaries =
        ref.watch(spaceUnreadSummaryProvider).valueOrNull ?? const [];
    return _loadSpaces(
      unreadSummaries: unreadSummaries,
      hideGroupFeatures: ref.watch(appUpdateGroupFeaturesBlockedProvider),
    );
  }

  Future<List<Space>> _loadSpaces({
    required List<SpaceUnreadSummary> unreadSummaries,
    required bool hideGroupFeatures,
  }) async {
    var spaces = await _repo.getSpaces();

    // 平台汇总是跨端未读事实源。当前空间只有在汇总不可用（例如离线）
    // 时才使用端侧会话快照，不能用可能尚未归约完成的本地值覆盖服务端。
    if (unreadSummaries.isNotEmpty) {
      spaces = _mergeUnreadSummaries(spaces, unreadSummaries);
    }

    final currentSpace = ref.read(accountRuntimeCurrentSpaceProvider);
    final currentImUnread = _currentSpaceImUnreadSummary(ref);
    if (hideGroupFeatures) {
      // The platform summary does not separate direct and group unread. Do not
      // expose its aggregate on the audit face. The active space can safely
      // restore its direct-only value from the filtered local projection.
      spaces = projectSpaceUnreadForReleaseFace(
        spaces,
        currentSpaceId: currentSpace?.spaceId,
        currentSpaceUnread: currentImUnread,
      );
    }
    if (currentSpace != null && currentImUnread != null) {
      final serverSummary =
          _summaryForSpace(unreadSummaries, currentSpace.spaceId);
      _logUnreadSummaryMismatchIfNeeded(
        currentSpace.spaceId,
        unreadSummaries,
        currentImUnread,
      );
      if (!hideGroupFeatures && serverSummary == null) {
        spaces = _overrideCurrentSpaceUnread(
          spaces,
          currentSpace.spaceId,
          currentImUnread,
        );
      }
    }

    // 用 my/tenants 里的 logoUrl 补充企业空间头像（platform token 接口）
    try {
      final authState = ref.read(authProvider).valueOrNull;
      final platformToken = authState?.platformToken;
      if (platformToken != null) {
        final tenants = authState!.availableTenants;
        if (tenants.isNotEmpty) {
          final logoMap = <String, String>{};
          for (final t in tenants) {
            if (t.logoUrl != null && t.logoUrl!.isNotEmpty) {
              logoMap[t.tenantId] = t.logoUrl!;
            }
          }
          if (logoMap.isNotEmpty) {
            return spaces.map((space) {
              final logo = logoMap[space.spaceId];
              if (logo != null) {
                return space.copyWith(logoUrl: logo);
              }
              return space;
            }).toList();
          }
        }
      }
    } catch (_) {}

    return spaces;
  }

  /// 切换空间
  ///
  /// AuthNotifier is the only switching owner. It commits the new account
  /// Session before publishing the target SpaceContext.
  Future<void> switchSpace(String spaceId) async {
    if (ref.read(accountRuntimeCurrentSpaceProvider)?.spaceId == spaceId) {
      return;
    }
    final previous = state.valueOrNull;
    try {
      final auth = ref.read(authProvider.notifier);
      if (spaceId == 'personal') {
        await auth.selectPersonalSpace();
      } else {
        await auth.selectTenant(spaceId);
      }
      final authState = ref.read(authProvider);
      if (authState.hasError ||
          authState.valueOrNull?.status != AuthStatus.authenticated ||
          authState.valueOrNull?.currentSpace?.spaceId != spaceId) {
        throw authState.error ?? StateError('空间切换未完成');
      }
      // The target runtime owns its own spaces projection. This notifier is
      // scoped to the source runtime and must not write state after the
      // ProviderScope handoff disposes it.
    } catch (e, st) {
      if (previous != null) {
        state = AsyncData(previous);
      } else {
        state = AsyncError(e, st);
      }
      Error.throwWithStackTrace(e, st);
    }
  }

  /// 刷新空间列表（例如收到新消息后更新未读数）
  Future<void> refresh() async {
    ref.invalidate(spaceUnreadSummaryProvider);
    state = AsyncData(
      await _loadSpaces(
        unreadSummaries: await ref.read(spaceUnreadSummaryProvider.future),
        hideGroupFeatures: ref.read(appUpdateGroupFeaturesBlockedProvider),
      ),
    );
  }
}

@visibleForTesting
List<Space> projectSpaceUnreadForReleaseFace(
  List<Space> spaces, {
  required String? currentSpaceId,
  required SpaceImUnreadSummary? currentSpaceUnread,
}) {
  return spaces.map((space) {
    final isCurrent = space.spaceId == currentSpaceId;
    return space.copyWith(
      conversationCount:
          isCurrent ? currentSpaceUnread?.unreadConversationCount ?? 0 : 0,
      unreadCount: isCurrent ? currentSpaceUnread?.unreadMessageCount ?? 0 : 0,
    );
  }).toList(growable: false);
}

SpaceImUnreadSummary? _currentSpaceImUnreadSummary(Ref ref) {
  final currentSpace = ref.read(accountRuntimeCurrentSpaceProvider);
  if (currentSpace == null) return null;
  final conversations = ref
      .read(releaseVisibleConversationsProvider(currentSpace.spaceId))
      .valueOrNull;
  if (conversations == null) return null;
  return computeImUnreadSummaryForSpaceBadges(conversations);
}

void _logUnreadSummaryMismatchIfNeeded(
  String currentSpaceId,
  List<SpaceUnreadSummary> summaries,
  SpaceImUnreadSummary clientSummary,
) {
  final serverSummary = _summaryForSpace(summaries, currentSpaceId);
  if (serverSummary == null) return;
  final serverConversationCount = serverSummary.unreadConversationCount;
  final serverMessageCount = serverSummary.unreadMessageCount;
  if (serverConversationCount == clientSummary.unreadConversationCount &&
      serverMessageCount == clientSummary.unreadMessageCount) {
    return;
  }
  AppDiagnostics.instance.warning(
    'space.unread',
    'server unread summary differs from visible IM conversations',
    context: {
      'spaceId': currentSpaceId,
      'serverUnreadConversationCount': serverConversationCount,
      'serverUnreadMessageCount': serverMessageCount,
      'clientUnreadConversationCount': clientSummary.unreadConversationCount,
      'clientUnreadMessageCount': clientSummary.unreadMessageCount,
    },
  );
}

// ---------------------------------------------------------------------------
// 跨空间未读汇总 Provider
// 调用 GET /api/platform/v1/my/spaces/unread-summary（需要平台 Token）
// ---------------------------------------------------------------------------

final spaceUnreadSummaryProvider =
    FutureProvider<List<SpaceUnreadSummary>>((ref) async {
  ref.watch(authProvider);
  return _fetchSpaceUnreadSummaries(ref);
}, dependencies: [dioProvider, authProvider]);

const _spaceUnreadSummaryRefreshWindow = Duration(seconds: 2);

final _spaceUnreadSummaryRefreshSchedulerProvider =
    Provider<SpaceUnreadSummaryRefreshScheduler>((ref) {
  final scheduler = SpaceUnreadSummaryRefreshScheduler(
    refreshWindow: _spaceUnreadSummaryRefreshWindow,
    onRefresh: () => ref.invalidate(spaceUnreadSummaryProvider),
  );
  ref.onDispose(scheduler.dispose);
  return scheduler;
});

void requestSpaceUnreadSummaryRefresh(Ref ref) {
  ref.read(_spaceUnreadSummaryRefreshSchedulerProvider).requestRefresh();
}

@visibleForTesting
class SpaceUnreadSummaryRefreshScheduler {
  final Duration refreshWindow;
  final VoidCallback onRefresh;
  Timer? _timer;

  SpaceUnreadSummaryRefreshScheduler({
    required this.refreshWindow,
    required this.onRefresh,
  });

  void requestRefresh() {
    if (_timer?.isActive == true) return;
    _timer = Timer(refreshWindow, onRefresh);
  }

  void dispose() {
    _timer?.cancel();
  }
}

Future<List<SpaceUnreadSummary>> _fetchSpaceUnreadSummaries(Ref ref) async {
  final authState = ref.read(authProvider).valueOrNull;
  final platformToken = authState?.platformToken;
  if (platformToken == null) return [];

  final dio = ref.watch(dioProvider);
  try {
    final resp = await dio.get<Map<String, dynamic>>(
      '/api/platform/v1/my/spaces/unread-summary',
      options: Options(headers: {'Authorization': 'Bearer $platformToken'}),
    );
    final data = resp.data?['data'] as Map<String, dynamic>?;
    final spaces = data?['spaces'] as List<dynamic>? ?? [];
    return spaces
        .map((e) => SpaceUnreadSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return [];
  }
}

List<Space> _mergeUnreadSummaries(
  List<Space> spaces,
  List<SpaceUnreadSummary> summaries,
) {
  final summaryBySpaceId = <String, SpaceUnreadSummary>{};
  for (final summary in summaries) {
    final spaceId = summary.spaceType == 1 ? 'personal' : summary.tenantId;
    if (spaceId == null || spaceId.isEmpty) continue;
    summaryBySpaceId[spaceId] = summary;
  }

  return spaces.map((space) {
    final summary = summaryBySpaceId[space.spaceId];
    if (summary == null) return space;
    return space.copyWith(
      name: summary.spaceName.isNotEmpty ? summary.spaceName : space.name,
      logoUrl:
          summary.logoUrl?.isNotEmpty == true ? summary.logoUrl : space.logoUrl,
      conversationCount: summary.unreadConversationCount,
      unreadCount: summary.unreadMessageCount,
    );
  }).toList();
}

SpaceUnreadSummary? _summaryForSpace(
  List<SpaceUnreadSummary> summaries,
  String spaceId,
) {
  for (final summary in summaries) {
    final summarySpaceId =
        summary.spaceType == 1 ? 'personal' : summary.tenantId;
    if (summarySpaceId == spaceId) return summary;
  }
  return null;
}

List<Space> _overrideCurrentSpaceUnread(
  List<Space> spaces,
  String currentSpaceId,
  SpaceImUnreadSummary summary,
) {
  return spaces.map((space) {
    if (space.spaceId != currentSpaceId) return space;
    return space.copyWith(
      conversationCount: summary.unreadConversationCount,
      unreadCount: summary.unreadMessageCount,
    );
  }).toList();
}

@visibleForTesting
SpaceImUnreadSummary computeImUnreadSummaryForSpaceBadges(
  List<Conversation> conversations,
) {
  final badgeConversations = conversations
      .where((conversation) =>
          conversation.type == ConversationType.direct ||
          conversation.type == ConversationType.group)
      .toList(growable: false);
  return SpaceImUnreadSummary(
    unreadConversationCount: calculateNumericUnreadConversationCount(
      badgeConversations,
    ),
    unreadMessageCount: calculateMessageBadgeCount(badgeConversations),
  );
}

@visibleForTesting
class SpaceImUnreadSummary {
  final int unreadConversationCount;
  final int unreadMessageCount;

  const SpaceImUnreadSummary({
    required this.unreadConversationCount,
    required this.unreadMessageCount,
  });
}

class SpaceUnreadSummary {
  final int spaceType; // 1=personal, 2=tenant
  final String? tenantId;
  final String spaceName;
  final String? tenantCode;
  final String? logoUrl;
  final int unreadConversationCount;
  final int unreadMessageCount;
  final bool hasUnread;

  const SpaceUnreadSummary({
    required this.spaceType,
    this.tenantId,
    required this.spaceName,
    this.tenantCode,
    this.logoUrl,
    required this.unreadConversationCount,
    required this.unreadMessageCount,
    required this.hasUnread,
  });

  factory SpaceUnreadSummary.fromJson(Map<String, dynamic> json) {
    return SpaceUnreadSummary(
      spaceType: json['spaceType'] as int? ?? 1,
      tenantId: json['tenantId'] as String?,
      spaceName: json['spaceName'] as String? ?? '',
      tenantCode: json['tenantCode'] as String?,
      logoUrl: json['logoUrl'] as String?,
      unreadConversationCount: json['unreadConversationCount'] as int? ?? 0,
      unreadMessageCount: json['unreadMessageCount'] as int? ?? 0,
      hasUnread: json['hasUnread'] as bool? ?? false,
    );
  }
}
