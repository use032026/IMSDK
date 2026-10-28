import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/contacts/application/friend_acceptance_conversation_service.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/contacts/presentation/providers/friend_acceptance_conversation_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';
import 'package:im_sdk/features/teen_mode/presentation/utils/teen_mode_ui.dart';

// ---------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------
const _primary = Color(0xFF00B27A);

Color _pageBg(BuildContext context) =>
    Theme.of(context).scaffoldBackgroundColor;

Color _primaryText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface;

Color _secondaryText(BuildContext context) =>
    Theme.of(context).colorScheme.onSurfaceVariant;

Color _mutedSurface(BuildContext context) =>
    Theme.of(context).colorScheme.surfaceContainerHighest;

enum RequestType { incoming, outgoing }

// ---------------------------------------------------------------------------
// NewFriendsPage
// ---------------------------------------------------------------------------
class NewFriendsPage extends ConsumerStatefulWidget {
  const NewFriendsPage({super.key});

  @override
  ConsumerState<NewFriendsPage> createState() => _NewFriendsPageState();
}

class _NewFriendsPageState extends ConsumerState<NewFriendsPage>
    with WidgetsBindingObserver {
  final Map<String, FriendRequestStatus> _localStatus = {};
  final Set<String> _handlingRequests = {};
  final Set<String> _awaitingGuardianApproval = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(friendRequestsProvider);
      ref.invalidate(pendingFriendRequestsProvider);
    }
  }

  Future<void> _handleRequest(String requestId, bool accept) async {
    if (accept && !ref.read(teenModePolicyProvider).canAttemptAcceptFriend) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).teenModeActionBlocked),
        ),
      );
      return;
    }
    if (_handlingRequests.contains(requestId) ||
        _localStatus.containsKey(requestId)) {
      return;
    }
    FriendRequest? request;
    for (final item in ref.read(friendRequestsProvider).valueOrNull ??
        const <FriendRequest>[]) {
      if (item.requestId == requestId) {
        request = item;
        break;
      }
    }
    setState(() {
      _handlingRequests.add(requestId);
      _localStatus[requestId] =
          accept ? FriendRequestStatus.accepted : FriendRequestStatus.rejected;
    });
    try {
      final repo = ref.read(contactsRepositoryProvider);
      await repo.handleFriendRequest(requestId, accept ? 'accept' : 'reject');
      // 成功后等待服务端最新列表回来，避免按钮仍短暂显示为可点。
      final _ = await ref.refresh(friendRequestsProvider.future);
      ref.invalidate(pendingFriendRequestsProvider);
      // 同时刷新好友列表；接受成功后等待服务端好友快照短暂收敛。
      final acceptanceDraft = accept && request != null
          ? FriendAcceptanceConversationDraft.fromRequest(
              request,
              currentUserId: ref.read(currentSpaceProvider)?.userId,
            )
          : null;
      if (acceptanceDraft?.peerUserId.isNotEmpty == true) {
        await ref
            .read(friendsProvider.notifier)
            .refreshUntilContains(acceptanceDraft!.peerUserId);
      } else {
        await ref.read(friendsProvider.notifier).refresh();
      }
      if (accept) {
        if (request != null) {
          try {
            await ensureFriendAcceptanceConversation(
              ref,
              acceptanceDraft!,
            );
          } catch (_) {
            // 好友关系已处理成功；会话补齐失败时保留刷新兜底，避免回滚用户操作。
          }
        }
        final spaceId = ref.read(currentSpaceProvider)?.spaceId;
        if (spaceId != null) {
          ref.invalidate(conversationsProvider(spaceId));
          await ref.read(conversationsProvider(spaceId).notifier).refresh();
        }
      }
    } catch (e) {
      if (mounted) {
        final teenAction = teenModeServerActionForError(ref, e);
        setState(() {
          _handlingRequests.remove(requestId);
          _localStatus.remove(requestId);
          if (teenAction?.awaitsServerReplay == true) {
            _awaitingGuardianApproval.add(requestId);
          }
        });
        if (teenAction != null) {
          showTeenModeServerAction(context, ref, e);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('操作失败：$e')));
        }
      }
    } finally {
      if (mounted) {
        setState(() => _handlingRequests.remove(requestId));
      } else {
        _handlingRequests.remove(requestId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final requestsAsync = ref.watch(friendRequestsProvider);

    return Scaffold(
      backgroundColor: _pageBg(context),
      body: Column(
        children: [
          _buildAppBar(context, l10n),
          Expanded(
            child: requestsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _buildErrorState(context),
              data: (requests) => _buildList(context, requests, l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back,
                    color: _primaryText(context), size: 20),
                onPressed: () => context.pop(),
              ),
              Expanded(
                child: Center(
                  child: Text(l10n.friendNewFriendsTitle,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: _primaryText(context))),
                ),
              ),
              if (ref.watch(teenModePolicyProvider).canAttemptAddFriend)
                IconButton(
                  icon: Icon(Icons.person_add_outlined,
                      color: _primaryText(context), size: 20),
                  onPressed: () => context.push('/add-friend'),
                )
              else
                const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _mutedSurface(context),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_add_disabled_outlined,
                  size: 28, color: _secondaryText(context)),
            ),
            const SizedBox(height: 16),
            Text(
              '好友申请暂时不可用',
              style: TextStyle(fontSize: 15, color: _primaryText(context)),
            ),
            const SizedBox(height: 8),
            Text(
              '请稍后再试',
              style: TextStyle(fontSize: 13, color: _secondaryText(context)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                ref.invalidate(friendRequestsProvider);
                ref.invalidate(pendingFriendRequestsProvider);
              },
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<FriendRequest> requests,
      AppLocalizations l10n) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _mutedSurface(context),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_add_outlined,
                  size: 28, color: _secondaryText(context)),
            ),
            const SizedBox(height: 16),
            Text(l10n.friendNoRequests,
                style: TextStyle(fontSize: 15, color: _secondaryText(context))),
          ],
        ),
      );
    }

    final canAcceptFriend =
        ref.watch(teenModePolicyProvider).canAttemptAcceptFriend;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: List.generate(requests.length, (i) {
            final req = requests[i];
            final view = _FriendRequestView.fromRequest(
              req,
              currentUserId: ref.read(currentSpaceProvider)?.userId,
              overrideStatus: _localStatus[req.requestId],
              awaitingGuardianApproval:
                  req.status == FriendRequestStatus.pending &&
                      _awaitingGuardianApproval.contains(req.requestId),
            );
            return _RequestTile(
              request: view,
              l10n: l10n,
              showDivider: i < requests.length - 1,
              onAccept: canAcceptFriend
                  ? () => _handleRequest(req.requestId, true)
                  : null,
              onReject: () => _handleRequest(req.requestId, false),
              onTap: view.userId.isNotEmpty
                  ? () => context.push('/profile/${view.userId}')
                  : null,
            );
          }),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// View model
// ---------------------------------------------------------------------------
class _FriendRequestView {
  final String userId;
  final String name;
  final String? avatarUrl;
  final String message;
  final String time;
  final FriendRequestStatus status;
  final RequestType type;
  final FriendRequestSource? source;
  final DateTime? handledAt;
  final bool awaitingGuardianApproval;

  const _FriendRequestView({
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.message,
    required this.time,
    required this.status,
    required this.type,
    this.source,
    this.handledAt,
    this.awaitingGuardianApproval = false,
  });

  factory _FriendRequestView.fromRequest(
    FriendRequest request, {
    required String? currentUserId,
    FriendRequestStatus? overrideStatus,
    bool awaitingGuardianApproval = false,
  }) {
    final outgoing =
        currentUserId != null && request.fromUserId == currentUserId;
    final userId = outgoing ? request.toUserId : request.fromUserId;
    final name = outgoing ? request.toDisplayName : request.fromDisplayName;
    final avatarUrl = outgoing ? request.toAvatarUrl : request.fromAvatarUrl;
    final sourceLabel = switch (request.source) {
      FriendRequestSource.search => '搜索',
      FriendRequestSource.qr => '扫码',
      null => '',
    };
    final message = request.message ?? '';
    return _FriendRequestView(
      userId: userId,
      name: name.isNotEmpty ? name : userId,
      avatarUrl: avatarUrl,
      message: sourceLabel.isEmpty
          ? message
          : '$sourceLabel${message.isEmpty ? '申请' : ' · $message'}',
      time: _formatRequestTime(request.handledAt ?? request.createdAt),
      status: overrideStatus ?? request.status,
      type: outgoing ? RequestType.outgoing : RequestType.incoming,
      source: request.source,
      handledAt: request.handledAt,
      awaitingGuardianApproval: awaitingGuardianApproval,
    );
  }

  static String _formatRequestTime(DateTime createdAt) {
    final dt = createdAt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thatDay = DateTime(dt.year, dt.month, dt.day);
    final diffDays = today.difference(thatDay).inDays;
    if (diffDays == 0) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    if (diffDays == 1) return '昨天';
    return '${dt.month}/${dt.day}';
  }
}

// ---------------------------------------------------------------------------
// Request tile
// ---------------------------------------------------------------------------
class _RequestTile extends StatelessWidget {
  final _FriendRequestView request;
  final bool showDivider;
  final VoidCallback? onAccept;
  final VoidCallback onReject;
  final VoidCallback? onTap;
  final AppLocalizations l10n;

  const _RequestTile({
    required this.request,
    required this.showDivider,
    required this.onAccept,
    required this.onReject,
    required this.l10n,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onTap,
                child: UserAvatar(
                  avatarUrl: request.avatarUrl,
                  name: request.name,
                  size: 48,
                  borderRadius: 10,
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(request.name,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: _primaryText(context))),
                        ),
                        Text(request.time,
                            style: TextStyle(
                                fontSize: 12, color: _secondaryText(context))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.type == RequestType.outgoing
                          ? '你发送了好友申请 · ${request.message}'
                          : request.message,
                      style: TextStyle(
                          fontSize: 13, color: _secondaryText(context)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildStatusWidget(context),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            margin: const EdgeInsets.only(left: 76),
            color: Theme.of(context).dividerColor,
          ),
      ],
    );
  }

  Widget _buildStatusWidget(BuildContext context) {
    if (request.awaitingGuardianApproval) {
      return Text(
        l10n.approvalPending,
        style: TextStyle(fontSize: 13, color: _secondaryText(context)),
      );
    }

    if (request.status == FriendRequestStatus.pending &&
        request.type == RequestType.incoming) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 32,
              child: ElevatedButton.icon(
                onPressed: onAccept,
                icon: const Icon(Icons.check, size: 14),
                label: Text(l10n.friendAccept,
                    style: const TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 32,
              child: OutlinedButton.icon(
                onPressed: onReject,
                icon: const Icon(Icons.close, size: 14),
                label: Text(l10n.friendReject,
                    style: const TextStyle(fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _secondaryText(context),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (request.status == FriendRequestStatus.accepted) {
      return Text(l10n.friendAccepted,
          style: const TextStyle(fontSize: 13, color: _primary));
    }

    if (request.status == FriendRequestStatus.rejected) {
      return Text(l10n.friendRejected,
          style: TextStyle(fontSize: 13, color: _secondaryText(context)));
    }

    if (request.status == FriendRequestStatus.cancelled) {
      return Text('已撤销',
          style: TextStyle(fontSize: 13, color: _secondaryText(context)));
    }

    if (request.status == FriendRequestStatus.unknown) {
      return Text('状态异常',
          style: TextStyle(fontSize: 13, color: _secondaryText(context)));
    }

    if (request.status == FriendRequestStatus.pending &&
        request.type == RequestType.outgoing) {
      return Text('等待验证',
          style: TextStyle(fontSize: 13, color: _secondaryText(context)));
    }

    return const SizedBox.shrink();
  }
}
