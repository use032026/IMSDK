import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/permissions/app_permissions.dart';
import 'package:im_sdk/core/storage/account_profile_box_provider.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/core/widgets/identity_badge.dart';
import 'package:im_sdk/core/widgets/app_toast.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/call/presentation/models/call_route_intent.dart';
import 'package:im_sdk/features/app_update/presentation/app_update_provider.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';
import 'package:im_sdk/features/chat/presentation/providers/conversations_provider.dart';
import 'package:im_sdk/features/contacts/application/friend_relation_status.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/contacts/domain/entities/friend_profile_extra.dart';
import 'package:im_sdk/features/contacts/domain/services/customer_phone_privacy.dart';
import 'package:im_sdk/features/contacts/domain/services/profile_public_id_visibility.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/contacts/presentation/providers/user_profile_provider.dart';
import 'package:im_sdk/features/official_account/presentation/widgets/official_account_card_view.dart';
import 'package:im_sdk/features/customer_service/presentation/providers/customer_service_providers.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';
import 'package:im_sdk/features/teen_mode/presentation/utils/teen_mode_ui.dart';

export 'package:im_sdk/features/contacts/presentation/providers/user_profile_provider.dart';

const _kDirectChatIdPrefix = 'direct_chat_id_';

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// ProfilePage
// ---------------------------------------------------------------------------
class ProfilePage extends ConsumerStatefulWidget {
  final String userId;
  final bool? allowAddFriendFromGroup;
  final bool adminCustomerView;
  final ProfileAccessContext accessContext;

  const ProfilePage({
    super.key,
    required this.userId,
    this.allowAddFriendFromGroup,
    this.adminCustomerView = false,
    this.accessContext = const ProfileAccessContext.standard(),
  });

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String _remarkName = '';
  bool _localFriendRequestPending = false;

  Future<void> _openChat(BuildContext context, UserProfile profile) async {
    final cachedChatId = await _findCachedDirectChatId(profile.userId);
    if (!mounted || !context.mounted) return;
    _pushDirectChat(
      context,
      profile,
      cachedChatId ?? 'pending_direct_${profile.userId}',
    );
  }

  Future<String?> _findCachedDirectChatId(String peerUserId) async {
    final space = ref.read(currentSpaceProvider);
    if (space == null) return null;

    final conversations =
        ref.read(conversationsProvider(space.spaceId)).valueOrNull ?? const [];
    for (final conversation in conversations) {
      if (conversation.type == ConversationType.direct &&
          conversation.peerUserId == peerUserId &&
          conversation.conversationId.isNotEmpty) {
        await _cacheDirectChatId(peerUserId, conversation.conversationId);
        return conversation.conversationId;
      }
    }

    try {
      final box =
          await ref.read(accountProfileBoxResolverProvider)(space.spaceId);
      final cached = box.get('$_kDirectChatIdPrefix$peerUserId');
      if (cached is String && cached.isNotEmpty) return cached;
    } catch (_) {}
    return null;
  }

  Future<void> _cacheDirectChatId(String peerUserId, String chatId) async {
    final space = ref.read(currentSpaceProvider);
    if (space == null || chatId.isEmpty) return;
    try {
      final box =
          await ref.read(accountProfileBoxResolverProvider)(space.spaceId);
      await box.put('$_kDirectChatIdPrefix$peerUserId', chatId);
    } catch (_) {}
  }

  void _pushDirectChat(
    BuildContext context,
    UserProfile profile,
    String chatId,
  ) {
    context.push('/chat/$chatId', extra: {
      'title': profile.name,
      'isGroup': false,
      'avatarUrl': profile.avatarUrl,
      'peerUserId': widget.userId,
    });
  }

  Future<void> _startCall(
    BuildContext context,
    UserProfile profile, {
    required bool isVideo,
    required bool isFriend,
  }) async {
    if (!ref
        .read(teenModePolicyProvider)
        .canAttemptStartCall(isFriend: isFriend)) {
      AppToast.error(
        context,
        AppLocalizations.of(context).teenModeActionBlocked,
      );
      return;
    }
    context.push(
      '/call/${widget.userId}',
      extra: {
        freshOutgoingCallIntentKey: true,
        'isVideo': isVideo,
        'title': profile.name,
        'targetUserId': widget.userId,
        'avatarUrl': profile.avatarUrl,
      },
    );
  }

  Future<void> _showCallOptions(
    BuildContext context,
    UserProfile profile, {
    required bool isFriend,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final surface = Theme.of(ctx).colorScheme.surface;
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _ActionSheetItem(
                        label: '语音通话',
                        onTap: () {
                          Navigator.pop(ctx);
                          _startCall(
                            context,
                            profile,
                            isVideo: false,
                            isFriend: isFriend,
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _ActionSheetItem(
                        label: '视频通话',
                        onTap: () {
                          Navigator.pop(ctx);
                          _startCall(
                            context,
                            profile,
                            isVideo: true,
                            isFriend: isFriend,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: _ActionSheetItem(
                    label: '取消',
                    isCancel: true,
                    onTap: () => Navigator.pop(ctx),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendFriendRequest() async {
    if (!ref.read(teenModePolicyProvider).canAttemptAddFriend) {
      AppToast.error(
        context,
        AppLocalizations.of(context).teenModeActionBlocked,
      );
      return;
    }
    try {
      final result = await ref
          .read(contactsRepositoryProvider)
          .sendFriendRequest(widget.userId);
      _localFriendRequestPending = !result.becameFriends;
      await _refreshFriendRelations();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result.becameFriends ? '你们已成为好友' : '好友申请已发送，等待对方通过'),
        ));
        // 刷新资料页（更新好友状态）
        ref.invalidate(userProfileProvider(widget.userId));
      }
    } catch (e) {
      final err = e is AppError ? e : null;
      if (mounted && showTeenModeServerAction(context, ref, e)) {
        _localFriendRequestPending = false;
        return;
      }
      if (err is ServerError &&
          isAlreadyFriendErrorCode(err.code, err.message)) {
        _localFriendRequestPending = false;
        await _refreshFriendRelations();
        ref.invalidate(userProfileProvider(widget.userId));
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('你们已经是好友')));
        }
        return;
      }
      if (err is ServerError &&
          isFriendRequestPendingErrorCode(err.code, err.message)) {
        _localFriendRequestPending = true;
        await _refreshFriendRelations();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('好友申请已发送，等待对方通过')),
          );
        }
        return;
      }
      if (mounted) {
        final message = err is ServerError ? err.message : '发送失败，请重试';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  Future<void> _refreshFriendRelations() async {
    try {
      await ref.read(friendsProvider.notifier).refresh();
    } catch (_) {}
    try {
      final _ = await ref.refresh(friendRequestsProvider.future);
      ref.invalidate(pendingFriendRequestsProvider);
    } catch (_) {}
  }

  FriendRelationSnapshot _relationFor(UserProfile profile) {
    return resolveFriendRelation(
      userId: profile.userId,
      currentUserId: ref.read(currentSpaceProvider)?.userId,
      friends: ref.read(friendsProvider).valueOrNull ?? const [],
      requests: ref.read(friendRequestsProvider).valueOrNull ?? const [],
      isFriend: profile.isFriend,
      localOutgoingPending: _localFriendRequestPending,
    );
  }

  Future<bool> _confirmFriendRelation(UserProfile profile) async {
    if (_relationFor(profile).status == FriendRelationStatus.friend) {
      return true;
    }
    await ref.read(friendsProvider.notifier).refresh();
    if (!mounted) return false;
    return _relationFor(profile).status == FriendRelationStatus.friend;
  }

  Future<void> _showMoreActions(UserProfile profile) async {
    final currentUserId = ref.read(currentSpaceProvider)?.userId;
    if (profile.userId == currentUserId) {
      return;
    }
    final isFriend = await _confirmFriendRelation(profile);
    if (!mounted) return;
    if (!isFriend) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('仅好友可进行此设置')),
      );
      return;
    }
    final space = ref.read(currentSpaceProvider);
    if (space == null) return;
    final scope = FriendProfileScope(
      spaceId: space.spaceId,
      ownerUserId: space.userId,
      friendUserId: profile.userId,
    );
    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FriendSettingsPage(
          profile: profile,
          scope: scope,
        ),
      ),
    );
    if (deleted == true && mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final profileAsync = ref.watch(userProfileProvider(widget.userId));
    ref.watch(friendsProvider);
    ref.watch(friendRequestsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: colors.onSurface,
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: colors.onSurface),
            onPressed: profileAsync.valueOrNull == null || profileAsync.valueOrNull?.officialAccount != null
                ? null
                : () => _showMoreActions(profileAsync.requireValue),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (profile) {
          if (profile.officialAccount != null) {
            return SingleChildScrollView(child: OfficialAccountCardView(card: profile.officialAccount!));
          }
          final space = ref.watch(currentSpaceProvider);
          final relation = _relationFor(profile);
          final scope = space == null
              ? null
              : FriendProfileScope(
                  spaceId: space.spaceId,
                  ownerUserId: space.userId,
                  friendUserId: profile.userId,
                );
          final loadedExtra =
              scope == null || relation.status != FriendRelationStatus.friend
                  ? null
                  : ref.watch(friendProfileExtraProvider(scope)).valueOrNull;
          final profileExtra =
              loadedExtra ?? FriendProfileExtra(friendUserId: profile.userId);
          final extra = FriendProfileExtra(
            friendUserId: profile.userId,
            remarkName: loadedExtra == null
                ? profile.remarkName?.trim() ?? _remarkName
                : profileExtra.remarkName,
            tags: loadedExtra == null ? profile.tags : profileExtra.tags,
            note: profileExtra.note,
            mobile: profileExtra.mobile ?? profile.mobile,
            gender: profileExtra.gender ?? profile.gender,
            remarkGender: profileExtra.remarkGender,
            remarkGenderProvided: profileExtra.remarkGenderProvided,
            region: profileExtra.region ?? profile.region,
            signature: profileExtra.signature ?? profile.signature,
            source: profileExtra.source,
            addedAt: profileExtra.addedAt,
            commonGroupCount: profileExtra.commonGroupCount,
            syncedAt: profileExtra.syncedAt,
          );
          if (_remarkName.isEmpty && profile.remarkName?.isNotEmpty == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _remarkName = profile.remarkName!);
            });
          }
          final effectiveRemark = loadedExtra == null
              ? (_remarkName.isNotEmpty
                  ? _remarkName
                  : profile.remarkName?.trim() ?? '')
              : extra.remarkName;
          final displayName =
              effectiveRemark.isNotEmpty ? effectiveRemark : profile.name;
          final isFriendOrEmployee =
              relation.status == FriendRelationStatus.friend ||
                  profile.isEmployee;

          // 当前登录用户信息
          final myUserId = space?.userId ?? '';
          final isMe = profile.userId == myUserId;
          final adminCustomerView = widget.adminCustomerView &&
              profile.isCustomer &&
              AppPermissions.canSeeAllCustomers(space);
          final groupAllowsFriendRequest =
              widget.allowAddFriendFromGroup ?? true;
          final friendRequestDecision = AppPermissions.canSendFriendRequest(
            space: space,
            groupAllowsFriendRequest: groupAllowsFriendRequest,
            targetIsEmployee: profile.isEmployee,
          );
          final teenPolicy = ref.watch(teenModePolicyProvider);
          final canSendFriendRequest =
              friendRequestDecision.allowed && teenPolicy.canAttemptAddFriend;
          final friendRequestBlockedReason = !teenPolicy.canAttemptAddFriend
              ? l10n.teenModeActionBlocked
              : friendRequestDecision.reason ?? '';
          final canStartCall = teenPolicy.canAttemptStartCall(
            isFriend: relation.status == FriendRelationStatus.friend,
          );
          final canDirectMessage = AppPermissions.canDirectMessageProfile(
            space: space,
            adminCustomerView: adminCustomerView,
            targetIsFriend: relation.status == FriendRelationStatus.friend,
            targetIsEmployee: profile.isEmployee,
          );

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(
                  profile,
                  displayName,
                  l10n,
                  gender: extra.effectiveGender,
                  hasRemark: effectiveRemark.isNotEmpty,
                  showPublicId:
                      isMe || canViewProfilePublicId(widget.accessContext),
                ),
                const SizedBox(height: 8),
                _buildProfileActions(context, isFriendOrEmployee, profile,
                    l10n: l10n,
                    relation: relation,
                    extra: extra,
                    isEnterpriseSpace: space?.isPersonal != true,
                    isMe: isMe,
                    canDirectMessage: canDirectMessage,
                    canStartCall: canStartCall,
                    canSendFriendRequest: canSendFriendRequest,
                    friendRequestBlockedReason: friendRequestBlockedReason,
                    adminCustomerView: adminCustomerView),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
    UserProfile profile,
    String displayName,
    AppLocalizations l10n, {
    required String? gender,
    required bool hasRemark,
    required bool showPublicId,
  }) {
    final space = ref.watch(currentSpaceProvider);
    final colors = Theme.of(context).colorScheme;
    final showIdentity = space != null && !space.isPersonal;
    final identity = showIdentity
        ? identityBadgeFor(
            userType: profile.userType,
            official: profile.isOfficial,
            includeEmployee: true,
          )
        : null;
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar — 用 UserAvatar 统一处理相对路径、token、缓存
              UserAvatar(
                avatarUrl: profile.avatarUrl,
                name: profile.name,
                size: 80,
                borderRadius: 16,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(displayName,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: colors.onSurface)),
                        ),
                        if (_genderMarkFrom(gender) != null) ...[
                          const SizedBox(width: 6),
                          _GenderIcon(mark: _genderMarkFrom(gender)!),
                        ],
                        if (showIdentity && profile.isOfficial) ...[
                          const SizedBox(width: 8),
                          const IdentityBadge(
                            label: '官方',
                            tone: IdentityBadgeTone.official,
                          ),
                        ] else if (identity != null) ...[
                          const SizedBox(width: 8),
                          IdentityBadge(
                            label: identity.label,
                            tone: identity.tone,
                          ),
                        ],
                      ],
                    ),
                    if (hasRemark) ...[
                      const SizedBox(height: 4),
                      Text('昵称：${profile.name}',
                          style: TextStyle(
                              fontSize: 13, color: colors.onSurfaceVariant)),
                    ],
                    if (showPublicId) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text('${l10n.profilePageLppId}：${profile.bubbleId}',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: colors.onSurfaceVariant)),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: profile.bubbleId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('已复制')));
                            },
                            child: Icon(
                              Icons.copy,
                              size: 14,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (profile.region?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text('地区：${profile.region!.trim()}',
                          style: TextStyle(
                              fontSize: 13, color: colors.onSurfaceVariant)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileActions(
      BuildContext context, bool isFriendOrEmployee, UserProfile profile,
      {required AppLocalizations l10n,
      required FriendRelationSnapshot relation,
      required FriendProfileExtra extra,
      required bool isEnterpriseSpace,
      bool isMe = false,
      bool canDirectMessage = false,
      bool canStartCall = true,
      bool canSendFriendRequest = true,
      String friendRequestBlockedReason = '当前暂不支持添加好友',
      bool adminCustomerView = false}) {
    return Column(
      children: [
        if (!adminCustomerView) ...[
          _FriendSummaryBlock(
            profile: profile,
            extra: extra,
            isEnterpriseSpace: isEnterpriseSpace,
            onTap: () => Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (_) => FriendDetailsPage(
                  profile: profile,
                  initialRemark: extra.remarkName,
                  isEnterpriseSpace: isEnterpriseSpace,
                  canEditRemarks:
                      relation.status == FriendRelationStatus.friend,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        if (isMe) ...[
          _ProfileActionSection(
            rows: [
              _ProfileActionRowData(
                icon: Icons.chat_bubble_outline,
                label: l10n.profilePageSendMessage,
                onTap: () => _openChat(context, profile),
              ),
            ],
          ),
        ] else if (adminCustomerView) ...[
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(16),
            child: _AdminCustomerActions(profile: profile),
          ),
        ] else if (isFriendOrEmployee || canDirectMessage) ...[
          _ProfileActionSection(
            rows: [
              _ProfileActionRowData(
                icon: Icons.chat_bubble_outline,
                label: l10n.profilePageSendMessage,
                onTap: () => _openChat(context, profile),
              ),
              if (relation.status == FriendRelationStatus.none &&
                  canSendFriendRequest)
                _ProfileActionRowData(
                  icon: Icons.person_add_alt_1_outlined,
                  label: l10n.profilePageAddFriend,
                  onTap: _sendFriendRequest,
                ),
              if (canStartCall)
                _ProfileActionRowData(
                  icon: Icons.call_outlined,
                  label: '音视频通话',
                  onTap: () => _showCallOptions(
                    context,
                    profile,
                    isFriend: relation.status == FriendRelationStatus.friend,
                  ),
                ),
            ],
          ),
        ] else if (relation.status == FriendRelationStatus.outgoingPending) ...[
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            alignment: Alignment.center,
            child: Text(
              '好友申请已发送，等待对方通过',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
        ] else if (relation.status == FriendRelationStatus.incomingPending) ...[
          _ProfileActionSection(
            rows: [
              _ProfileActionRowData(
                icon: Icons.person_add_alt_1_outlined,
                label: '处理好友申请',
                onTap: () => context.push('/new-friends'),
              ),
            ],
          ),
        ] else if (canSendFriendRequest) ...[
          _ProfileActionSection(
            rows: [
              _ProfileActionRowData(
                icon: Icons.person_add_alt_1_outlined,
                label: l10n.profilePageAddFriend,
                onTap: _sendFriendRequest,
              ),
            ],
          ),
        ] else ...[
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            alignment: Alignment.center,
            child: Text(
              friendRequestBlockedReason,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

enum _GenderMark { male, female }

_GenderMark? _genderMarkFrom(String? value) {
  final normalized = value?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) return null;
  if (normalized == 'male' || normalized == '男' || normalized == '男性') {
    return _GenderMark.male;
  }
  if (normalized == 'female' || normalized == '女' || normalized == '女性') {
    return _GenderMark.female;
  }
  return null;
}

String _friendGenderDisplayLabel(String? value) {
  final normalized = value?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) return '未设置';
  if (normalized == 'male' || normalized == '男' || normalized == '男性') {
    return '男';
  }
  if (normalized == 'female' || normalized == '女' || normalized == '女性') {
    return '女';
  }
  if (normalized == 'other' || normalized == '其他') return '其他';
  if (normalized == 'unset' || normalized == 'unknown') return '未设置';
  return value!.trim();
}

class _GenderIcon extends StatelessWidget {
  final _GenderMark mark;

  const _GenderIcon({required this.mark});

  @override
  Widget build(BuildContext context) {
    final isMale = mark == _GenderMark.male;
    return Container(
      width: 17,
      height: 17,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isMale ? const Color(0xFF5AA7FF) : const Color(0xFFFF7DA7),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isMale ? Icons.north_east : Icons.add,
        size: isMale ? 12 : 13,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

const _kFriendCommonGroupsPrefix = 'friend_common_groups_';
const _friendProfileFallbackRefreshInterval = Duration(hours: 6);

class FriendDetailsPage extends ConsumerStatefulWidget {
  final UserProfile profile;
  final String initialRemark;
  final bool isEnterpriseSpace;
  final bool canEditRemarks;

  const FriendDetailsPage({
    super.key,
    required this.profile,
    required this.initialRemark,
    required this.isEnterpriseSpace,
    required this.canEditRemarks,
  });

  @override
  ConsumerState<FriendDetailsPage> createState() => _FriendDetailsPageState();
}

class _FriendDetailsPageState extends ConsumerState<FriendDetailsPage> {
  bool _savingGender = false;

  bool _canEditRemarks() {
    if (widget.canEditRemarks) return true;
    final relation = resolveFriendRelation(
      userId: widget.profile.userId,
      currentUserId: ref.read(currentSpaceProvider)?.userId,
      friends: ref.read(friendsProvider).valueOrNull ?? const [],
      requests: const [],
      isFriend: widget.profile.isFriend,
    );
    return relation.status == FriendRelationStatus.friend;
  }

  FriendProfileExtra _fallbackExtra(FriendProfileExtra? extra) {
    return FriendProfileExtra(
      friendUserId: widget.profile.userId,
      remarkName: extra?.remarkName ?? widget.initialRemark,
      tags: extra?.tags ?? widget.profile.tags,
      note: extra?.note ?? '',
      mobile: extra?.mobile ?? widget.profile.mobile,
      gender: extra?.gender ?? widget.profile.gender,
      remarkGender: extra?.remarkGender,
      remarkGenderProvided: extra?.remarkGenderProvided ?? false,
      region: extra?.region ?? widget.profile.region,
      signature: extra?.signature ?? widget.profile.signature,
      source: extra?.source,
      addedAt: extra?.addedAt,
      commonGroupCount: extra?.commonGroupCount ?? 0,
      syncedAt: extra?.syncedAt,
    );
  }

  Future<void> _openEdit(
    FriendProfileScope scope,
    FriendProfileExtra extra,
    FriendRemarkSection section,
  ) async {
    if (!_canEditRemarks()) return;
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FriendRemarkEditPage(
          initialDraft: FriendRemarkDraft.fromProfile(extra),
          originalName: widget.profile.name,
          initialSection: section,
          onSave: (draft) async {
            try {
              final updated = await ref
                  .read(friendProfileExtraProvider(scope).notifier)
                  .saveRemark(draft);
              await ref
                  .read(userProfileProvider(widget.profile.userId).notifier)
                  .updateRemark(updated.remarkName);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已保存')),
                );
              }
              return true;
            } catch (_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('保存失败，请重试')),
                );
              }
              return false;
            }
          },
        ),
      ),
    );
  }

  Future<void> _openGenderPicker(
    FriendProfileScope scope,
    FriendProfileExtra extra,
  ) async {
    if (!_canEditRemarks() || _savingGender) return;
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final colors = Theme.of(sheetContext).colorScheme;
        final current = extra.remarkGender ?? 'unset';
        const options = [
          ('male', '男'),
          ('female', '女'),
          ('other', '其他'),
          ('unset', '未设置'),
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '性别（仅自己可见）',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              ...options.map(
                (option) => ListTile(
                  title: Text(option.$2),
                  trailing: current == option.$1
                      ? Icon(Icons.check, color: colors.primary)
                      : null,
                  onTap: () => Navigator.of(sheetContext).pop(option.$1),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (selected == null || !mounted) return;

    setState(() => _savingGender = true);
    try {
      await ref
          .read(friendProfileExtraProvider(scope).notifier)
          .saveGender(selected == 'unset' ? null : selected);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已保存')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存失败，请重试')),
        );
      }
    } finally {
      if (mounted) setState(() => _savingGender = false);
    }
  }

  void _openCommonGroups(FriendProfileExtra extra) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => FriendCommonGroupsPage(
          friendUserId: widget.profile.userId,
          friendName: widget.profile.remarkName?.isNotEmpty == true
              ? widget.profile.remarkName!
              : widget.profile.name,
          count: extra.commonGroupCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final space = ref.watch(currentSpaceProvider);
    if (!widget.canEditRemarks) {
      ref.watch(friendsProvider);
    }
    final canEditRemarks = _canEditRemarks();
    final scope = FriendProfileScope(
      spaceId: space?.spaceId ?? '',
      ownerUserId: space?.userId ?? '',
      friendUserId: widget.profile.userId,
    );
    final extra = space == null
        ? _fallbackExtra(null)
        : _fallbackExtra(
            ref.watch(friendProfileExtraProvider(scope)).valueOrNull);
    final tagsText = _tagsText(extra.tags);
    final visiblePhone = friendProfileVisiblePhone(
      isEnterpriseSpace: widget.isEnterpriseSpace,
      phone: extra.mobile,
    );
    final hideGroupFeatures = ref.watch(appUpdateGroupFeaturesBlockedProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onSurface,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '朋友资料',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8),
        children: [
          Container(
            color: colorScheme.surface,
            child: Column(
              children: [
                const _SectionHeader(label: '备注'),
                _InfoRow(
                  label: '备注名',
                  value: extra.remarkName.isEmpty ? '未设置' : extra.remarkName,
                  onTap: canEditRemarks
                      ? () => _openEdit(
                            scope,
                            extra,
                            FriendRemarkSection.remarkName,
                          )
                      : null,
                  showArrow: canEditRemarks,
                ),
                if (visiblePhone != null)
                  _InfoRow(
                    label: '电话',
                    value: visiblePhone,
                  ),
                _InfoRow(
                  label: '性别',
                  value: _friendGenderDisplayLabel(extra.effectiveGender),
                  onTap: canEditRemarks && !_savingGender
                      ? () => _openGenderPicker(scope, extra)
                      : null,
                  showArrow: canEditRemarks,
                ),
                _InfoRow(
                  label: '标签',
                  value: tagsText,
                  onTap: canEditRemarks
                      ? () => _openEdit(
                            scope,
                            extra,
                            FriendRemarkSection.tags,
                          )
                      : null,
                  showArrow: canEditRemarks,
                ),
                _InfoRow(
                  label: '备注',
                  value: extra.note.isNotEmpty ? extra.note : '未设置',
                  onTap: canEditRemarks
                      ? () => _openEdit(
                            scope,
                            extra,
                            FriendRemarkSection.note,
                          )
                      : null,
                  showArrow: canEditRemarks,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: colorScheme.surface,
            child: Column(
              children: [
                const _SectionHeader(label: '更多信息'),
                if (!hideGroupFeatures)
                  _InfoRow(
                    label: '我和他的共同群聊',
                    value: extra.commonGroupCount > 0
                        ? '${extra.commonGroupCount} 个'
                        : '暂无',
                    onTap: () => _openCommonGroups(extra),
                    showArrow: true,
                  ),
                _InfoRow(
                  label: '地区',
                  value:
                      extra.region?.isNotEmpty == true ? extra.region! : '未设置',
                ),
                _InfoRow(
                  label: '签名',
                  value: extra.signature?.isNotEmpty == true
                      ? extra.signature!
                      : '未设置',
                ),
                _InfoRow(
                  label: '来源',
                  value:
                      extra.source?.isNotEmpty == true ? extra.source! : '未设置',
                ),
                _InfoRow(
                  label: '添加时间',
                  value: extra.addedAt?.isNotEmpty == true
                      ? extra.addedAt!
                      : '未设置',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

bool _shouldFallbackRefresh(DateTime? syncedAt) {
  if (syncedAt == null) return true;
  return DateTime.now().difference(syncedAt) >
      _friendProfileFallbackRefreshInterval;
}

DateTime? _parseDateTime(Object? value) {
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

class _FriendTextEditPage extends StatefulWidget {
  final String title;
  final String labelText;
  final String? hintText;
  final String initialValue;
  final int maxLength;
  final int maxLines;

  const _FriendTextEditPage({
    required this.title,
    required this.labelText,
    this.hintText,
    required this.initialValue,
    required this.maxLength,
    this.maxLines = 1,
  });

  @override
  State<_FriendTextEditPage> createState() => _FriendTextEditPageState();
}

class _FriendTextEditPageState extends State<_FriendTextEditPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            '取消',
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
        leadingWidth: 64,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              '完成',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12),
        children: [
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: TextField(
              controller: _controller,
              autofocus: true,
              maxLength: widget.maxLength,
              minLines: widget.maxLines,
              maxLines: widget.maxLines,
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                counterText: '',
                border: InputBorder.none,
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(
                          Icons.cancel,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () => setState(_controller.clear),
                      ),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _submit(),
            ),
          ),
        ],
      ),
    );
  }
}

class FriendCommonGroupsPage extends ConsumerStatefulWidget {
  final String friendUserId;
  final String friendName;
  final int count;

  const FriendCommonGroupsPage({
    super.key,
    required this.friendUserId,
    required this.friendName,
    required this.count,
  });

  @override
  ConsumerState<FriendCommonGroupsPage> createState() =>
      _FriendCommonGroupsPageState();
}

class _FriendCommonGroupsPageState
    extends ConsumerState<FriendCommonGroupsPage> {
  List<_FriendCommonGroup> _groups = const [];
  DateTime? _syncedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(appUpdateGroupFeaturesBlockedProvider)) return;
      _loadThenMaybeRefresh();
    });
  }

  Future<void> _loadThenMaybeRefresh() async {
    final hasCache = await _loadCached();
    if (!hasCache || _shouldFallbackRefresh(_syncedAt)) {
      await _syncRemote();
    }
  }

  Future<bool> _loadCached() async {
    final space = ref.read(currentSpaceProvider);
    if (space == null) return false;
    try {
      final box =
          await ref.read(accountProfileBoxResolverProvider)(space.spaceId);
      final raw = box.get('$_kFriendCommonGroupsPrefix${widget.friendUserId}');
      if (raw == null) return false;
      final map = jsonDecode(raw as String) as Map<String, dynamic>;
      final items = map['items'];
      if (!mounted) return false;
      setState(() {
        _groups = _FriendCommonGroup.listFrom(items);
        _syncedAt = _parseDateTime(map['syncedAt']);
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _saveCached() async {
    final space = ref.read(currentSpaceProvider);
    if (space == null) return;
    try {
      final box =
          await ref.read(accountProfileBoxResolverProvider)(space.spaceId);
      await box.put(
        '$_kFriendCommonGroupsPrefix${widget.friendUserId}',
        jsonEncode({
          'items': _groups.map((e) => e.toJson()).toList(growable: false),
          'syncedAt': (_syncedAt ?? DateTime.now()).toIso8601String(),
        }),
      );
    } catch (_) {}
  }

  Future<void> _syncRemote() async {
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.get<Map<String, dynamic>>(
        '/api/client/v1/friends/${widget.friendUserId}/common-groups',
      );
      final body = resp.data?['data'];
      final items = body is Map<String, dynamic> ? body['items'] : body;
      if (!mounted) return;
      setState(() {
        _groups = _FriendCommonGroup.listFrom(items);
        _syncedAt = DateTime.now();
      });
      await _saveCached();
    } catch (_) {
      // 共同群聊查看走本地快照；接口不可用时不打断资料页体验。
    }
  }

  void _openGroup(_FriendCommonGroup group) {
    if (ref.read(appUpdateGroupFeaturesBlockedProvider)) return;
    final conversationId =
        group.conversationId.isNotEmpty ? group.conversationId : group.groupId;
    if (conversationId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('暂时无法打开该群聊')),
      );
      return;
    }
    context.push('/chat/$conversationId', extra: {
      'title': group.title,
      'isGroup': true,
      'conversationType': ConversationType.group.name,
      'avatarUrl': group.avatarUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(appUpdateGroupFeaturesBlockedProvider)) {
      return const SizedBox.shrink();
    }
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onSurface,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '共同群聊',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: _groups.isEmpty
          ? Center(
              child: Text(
                widget.count > 0 ? '共同群聊数据同步中' : '暂无共同群聊',
                style: TextStyle(
                  fontSize: 15,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.only(top: 8),
              itemCount: _groups.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final group = _groups[index];
                return ListTile(
                  tileColor: colorScheme.surface,
                  leading: UserAvatar(
                    avatarUrl: group.avatarUrl,
                    name: group.title,
                    size: 44,
                    borderRadius: 8,
                  ),
                  title: Text(
                    group.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: group.memberCount > 0
                      ? Text('${group.memberCount} 人')
                      : null,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: () => _openGroup(group),
                );
              },
            ),
    );
  }
}

class _FriendCommonGroup {
  final String groupId;
  final String conversationId;
  final String title;
  final String? avatarUrl;
  final int memberCount;

  const _FriendCommonGroup({
    required this.groupId,
    required this.conversationId,
    required this.title,
    this.avatarUrl,
    this.memberCount = 0,
  });

  factory _FriendCommonGroup.fromJson(Map<String, dynamic> json) {
    return _FriendCommonGroup(
      groupId: json['groupId'] as String? ?? '',
      conversationId:
          json['conversationId'] as String? ?? json['chatId'] as String? ?? '',
      title: json['title'] as String? ??
          json['groupName'] as String? ??
          json['name'] as String? ??
          '群聊',
      avatarUrl: json['avatarUrl'] as String?,
      memberCount: json['memberCount'] as int? ?? 0,
    );
  }

  static List<_FriendCommonGroup> listFrom(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => _FriendCommonGroup.fromJson(
              e.cast<String, dynamic>(),
            ))
        .where((e) => e.title.trim().isNotEmpty)
        .toList(growable: false);
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'conversationId': conversationId,
      'title': title,
      'avatarUrl': avatarUrl,
      'memberCount': memberCount,
    };
  }
}

enum FriendRemarkSection { remarkName, tags, note }

class FriendRemarkEditPage extends StatefulWidget {
  final FriendRemarkDraft initialDraft;
  final String originalName;
  final FriendRemarkSection initialSection;
  final Future<bool> Function(FriendRemarkDraft draft) onSave;

  const FriendRemarkEditPage({
    super.key,
    required this.initialDraft,
    required this.originalName,
    this.initialSection = FriendRemarkSection.remarkName,
    required this.onSave,
  });

  @override
  State<FriendRemarkEditPage> createState() => _FriendRemarkEditPageState();
}

class _FriendRemarkEditPageState extends State<FriendRemarkEditPage> {
  late final TextEditingController _remarkController;
  late final TextEditingController _noteController;
  late List<String> _tags;
  final _scrollController = ScrollController();
  final _remarkSectionKey = GlobalKey();
  final _tagsSectionKey = GlobalKey();
  final _noteSectionKey = GlobalKey();
  final _remarkFocus = FocusNode();
  final _noteFocus = FocusNode();
  bool _saving = false;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    _remarkController = TextEditingController(
      text: widget.initialDraft.remarkName,
    );
    _noteController = TextEditingController(text: widget.initialDraft.note);
    _tags = normalizeFriendTags(widget.initialDraft.tags);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      switch (widget.initialSection) {
        case FriendRemarkSection.remarkName:
          _remarkFocus.requestFocus();
          _reveal(_remarkSectionKey);
          break;
        case FriendRemarkSection.tags:
          _reveal(_tagsSectionKey);
          break;
        case FriendRemarkSection.note:
          _noteFocus.requestFocus();
          _reveal(_noteSectionKey);
          break;
      }
    });
  }

  void _reveal(GlobalKey key) {
    final sectionContext = key.currentContext;
    if (sectionContext == null) return;
    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      alignment: 0.18,
    );
  }

  @override
  void dispose() {
    _remarkController.dispose();
    _noteController.dispose();
    _scrollController.dispose();
    _remarkFocus.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  FriendRemarkDraft _draft() => FriendRemarkDraft(
        remarkName: _remarkController.text,
        tags: _tags,
        note: _noteController.text,
      ).normalized();

  bool get _isDirty {
    final current = _draft();
    final initial = widget.initialDraft.normalized();
    return current.remarkName != initial.remarkName ||
        current.tags.join('\u0000') != initial.tags.join('\u0000') ||
        current.note != initial.note;
  }

  bool get _isValid =>
      _remarkController.text.trim().length <= 20 &&
      _noteController.text.trim().length <= 200;

  Future<void> _openTags() async {
    if (_saving) return;
    final updated = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(
        builder: (_) => FriendTagsEditPage(initialTags: _tags),
      ),
    );
    if (!mounted || updated == null) return;
    setState(() => _tags = normalizeFriendTags(updated));
  }

  Future<void> _submit() async {
    if (_saving) return;
    setState(() => _saving = true);
    final saved = await widget.onSave(_draft());
    if (!mounted) return;
    if (saved) {
      setState(() => _allowPop = true);
      Navigator.of(context).pop(true);
    } else {
      setState(() => _saving = false);
    }
  }

  Future<bool> _confirmDiscard() async {
    if (!_isDirty) return true;
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AppAlertDialog(
            title: const Text('放弃修改？'),
            content: const Text('当前修改尚未保存。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('继续编辑'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(
                  '放弃修改',
                  style: TextStyle(
                    color: Theme.of(dialogContext).colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _requestClose() async {
    if (_saving || !await _confirmDiscard() || !mounted) return;
    setState(() => _allowPop = true);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final linkColor = theme.brightness == Brightness.dark
        ? colors.primary
        : const Color(0xFF526F96);

    return PopScope(
      canPop: _allowPop || (!_saving && !_isDirty),
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || _saving) return;
        await _requestClose();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: colors.surface,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: TextButton(
            onPressed: _saving ? null : _requestClose,
            child: Text(
              '取消',
              style: TextStyle(color: colors.onSurface),
            ),
          ),
          leadingWidth: 64,
          actions: [
            TextButton(
              onPressed: _saving || !_isDirty || !_isValid ? null : _submit,
              child: _saving
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary,
                      ),
                    )
                  : Text(
                      '完成',
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
        body: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 36),
          children: [
            Text(
              '编辑备注',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 72),
            KeyedSubtree(
              key: _remarkSectionKey,
              child: _RemarkEditField(
                label: '备注名',
                child: TextField(
                  key: const Key('friend_remark_name'),
                  controller: _remarkController,
                  focusNode: _remarkFocus,
                  enabled: !_saving,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    hintText: '添加备注',
                    counterText: '',
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  style: TextStyle(color: colors.onSurface),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
            if (widget.originalName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 30),
                child: Text(
                  '原昵称  ${widget.originalName}',
                  style: TextStyle(
                    fontSize: 13,
                    color: linkColor,
                  ),
                ),
              )
            else
              const SizedBox(height: 30),
            KeyedSubtree(
              key: _tagsSectionKey,
              child: _RemarkEditField(
                label: '标签',
                child: InkWell(
                  key: const Key('friend_tags_entry'),
                  onTap: _saving ? null : _openTags,
                  child: SizedBox(
                    height: 62,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _tags.isEmpty ? '添加标签' : _tags.join('、'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: linkColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            KeyedSubtree(
              key: _noteSectionKey,
              child: _RemarkEditField(
                label: '备注',
                child: TextField(
                  key: const Key('friend_note'),
                  controller: _noteController,
                  focusNode: _noteFocus,
                  enabled: !_saving,
                  maxLength: 200,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: '添加文字',
                    counterText: '',
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  style: TextStyle(color: colors.onSurface),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemarkEditField extends StatelessWidget {
  final String label;
  final Widget child;

  const _RemarkEditField({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
            label,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: child,
          ),
        ),
      ],
    );
  }
}

class FriendTagsEditPage extends StatefulWidget {
  final List<String> initialTags;

  const FriendTagsEditPage({
    super.key,
    required this.initialTags,
  });

  @override
  State<FriendTagsEditPage> createState() => _FriendTagsEditPageState();
}

class _FriendTagsEditPageState extends State<FriendTagsEditPage> {
  late List<String> _tags;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _tags = normalizeFriendTags(widget.initialTags).toList();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTags() {
    final incoming = normalizeFriendTags(
      _controller.text.split(RegExp(r'[,，]')),
    );
    if (incoming.isEmpty) return;
    setState(() {
      _tags = normalizeFriendTags([..._tags, ...incoming]).toList();
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final linkColor = theme.brightness == Brightness.dark
        ? colors.primary
        : const Color(0xFF526F96);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: colors.onSurface,
          ),
        ),
        title: Text(
          '编辑标签',
          style: TextStyle(color: colors.onSurface),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_tags),
            child: Text(
              '完成',
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14, bottom: 8),
            child: Text(
              '已添加标签',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 15,
              ),
            ),
          ),
          for (var index = 0; index < _tags.length; index++) ...[
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _tags[index],
                      style: TextStyle(color: colors.onSurface),
                    ),
                  ),
                  IconButton(
                    key: Key('remove_friend_tag_$index'),
                    onPressed: () => setState(() => _tags.removeAt(index)),
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.only(left: 14, bottom: 8),
            child: Text(
              '添加标签',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 4),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('friend_tag_input'),
                    controller: _controller,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addTags(),
                    decoration: const InputDecoration(
                      hintText: '输入标签',
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(color: colors.onSurface),
                  ),
                ),
                IconButton(
                  key: const Key('add_friend_tag'),
                  onPressed: _addTags,
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: linkColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FriendSettingsPage extends ConsumerStatefulWidget {
  final UserProfile profile;
  final FriendProfileScope scope;

  const FriendSettingsPage({
    super.key,
    required this.profile,
    required this.scope,
  });

  @override
  ConsumerState<FriendSettingsPage> createState() => _FriendSettingsPageState();
}

class _FriendSettingsPageState extends ConsumerState<FriendSettingsPage> {
  bool _updatingBlock = false;
  bool _deleting = false;
  bool _loadingProfile = false;

  Future<void> _openFriendDetails() async {
    if (_loadingProfile) return;
    setState(() => _loadingProfile = true);
    try {
      var extra =
          ref.read(friendProfileExtraProvider(widget.scope)).valueOrNull;
      if (extra == null) {
        await ref
            .read(friendProfileExtraProvider(widget.scope).notifier)
            .refresh();
        extra = ref.read(friendProfileExtraProvider(widget.scope)).valueOrNull;
      }
      if (extra == null) throw StateError('friend profile unavailable');
      final space = ref.read(currentSpaceProvider);
      if (space == null) throw StateError('space unavailable');
      if (!mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => FriendDetailsPage(
            profile: widget.profile,
            initialRemark: extra!.remarkName,
            isEnterpriseSpace: !space.isPersonal,
            canEditRemarks: true,
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('资料加载失败，请重试')),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingProfile = false);
    }
  }

  Future<void> _toggleBlocked(bool blocked) async {
    if (_updatingBlock) return;
    setState(() => _updatingBlock = true);
    try {
      final repository = ref.read(contactsRepositoryProvider);
      if (blocked) {
        await repository.blockUser(widget.profile.userId);
      } else {
        await repository.unblockUser(widget.profile.userId);
      }
      ref.invalidate(blocklistProvider);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('操作失败，请重试')),
        );
      }
    } finally {
      if (mounted) setState(() => _updatingBlock = false);
    }
  }

  Future<void> _deleteFriend() async {
    if (_deleting) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppAlertDialog(
        title: const Text('删除好友'),
        content: Text('确定删除「${widget.profile.name}」吗？删除后不会清空已有聊天记录。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              '删除',
              style: TextStyle(
                color: Theme.of(dialogContext).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || _deleting) return;
    setState(() => _deleting = true);
    try {
      await ref
          .read(contactsRepositoryProvider)
          .deleteFriend(widget.profile.userId);
      await ref
          .read(friendProfileExtraProvider(widget.scope).notifier)
          .deleteCache();
      await ref.read(friendsProvider.notifier).refresh();
      ref.invalidate(friendRequestsProvider);
      ref.invalidate(pendingFriendRequestsProvider);
      ref.invalidate(userProfileProvider(widget.profile.userId));
      ref.invalidate(friendProfileExtraProvider(widget.scope));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已删除好友')),
      );
      Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('删除失败，请重试')),
        );
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final extraAsync = ref.watch(friendProfileExtraProvider(widget.scope));
    final blocklistAsync = ref.watch(blocklistProvider);
    final blocked = blocklistAsync.valueOrNull
            ?.any((item) => item.userId == widget.profile.userId) ??
        false;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.surface,
        title: Text(
          '好友设置',
          style: TextStyle(color: colors.onSurface),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: colors.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 12),
        children: [
          _SettingsRow(
            label: '编辑备注',
            showArrow: true,
            trailing: _loadingProfile || extraAsync.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            onTap: _loadingProfile ? null : _openFriendDetails,
          ),
          const SizedBox(height: 12),
          _SettingsRow(
            label: blocked ? '移出黑名单' : '加入黑名单',
            trailing: _updatingBlock || blocklistAsync.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Switch(
                    value: blocked,
                    onChanged: _updatingBlock || blocklistAsync.hasError
                        ? null
                        : _toggleBlocked,
                  ),
          ),
          const SizedBox(height: 12),
          _SettingsRow(
            label: _deleting ? '正在删除…' : '删除好友',
            destructive: true,
            onTap: _deleting ? null : _deleteFriend,
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final Widget? trailing;
  final bool showArrow;
  final bool destructive;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.label,
    this.trailing,
    this.showArrow = false,
    this.destructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      child: ListTile(
        onTap: onTap,
        title: Text(
          label,
          textAlign: destructive ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: destructive ? colors.error : colors.onSurface,
          ),
        ),
        trailing: trailing ??
            (showArrow
                ? Icon(Icons.chevron_right, color: colors.onSurfaceVariant)
                : null),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper widgets
// ---------------------------------------------------------------------------
String _tagsText(List<String> tags) {
  if (tags.isEmpty) return '未设置';
  return tags.join('，');
}

class _FriendSummaryBlock extends StatelessWidget {
  final UserProfile profile;
  final FriendProfileExtra extra;
  final bool isEnterpriseSpace;
  final VoidCallback onTap;

  const _FriendSummaryBlock({
    required this.profile,
    required this.extra,
    required this.isEnterpriseSpace,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final displayMobile = friendProfileVisiblePhone(
      isEnterpriseSpace: isEnterpriseSpace,
      phone: extra.mobile ?? profile.mobile,
    );
    final tags = extra.tags;
    final lines = <_SummaryLine>[
      if (extra.remarkName.trim().isNotEmpty)
        _SummaryLine(label: '备注名', value: extra.remarkName.trim()),
      if (displayMobile?.isNotEmpty == true)
        _SummaryLine(label: '电话', value: displayMobile!),
      if (tags.isNotEmpty) _SummaryLine(label: '标签', value: tags.join('，')),
      if (extra.note.trim().isNotEmpty)
        _SummaryLine(label: '备注', value: extra.note.trim()),
    ];
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 54,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '朋友资料',
                      style: TextStyle(
                        fontSize: 17,
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colors.onSurfaceVariant,
                    size: 22,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: lines,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 46,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: colors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionRowData {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ProfileActionRowData({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class _ProfileActionSection extends StatelessWidget {
  final List<_ProfileActionRowData> rows;

  const _ProfileActionSection({required this.rows});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.surface,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _ProfileCenterActionRow(row: rows[i]),
            if (i < rows.length - 1)
              Divider(
                height: 1,
                thickness: 0.5,
                color: colors.outlineVariant,
              ),
          ],
        ],
      ),
    );
  }
}

class _ProfileCenterActionRow extends StatelessWidget {
  final _ProfileActionRowData row;

  const _ProfileCenterActionRow({required this.row});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.primary
        : const Color(0xFF576B95);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: row.onTap,
        child: SizedBox(
          height: 64,
          width: double.infinity,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(row.icon, size: 23, color: actionColor),
                const SizedBox(width: 8),
                Text(
                  row.label,
                  style: TextStyle(
                    fontSize: 17,
                    color: actionColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionSheetItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isCancel;

  const _ActionSheetItem({
    required this.label,
    required this.onTap,
    this.isCancel = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 54,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 17,
              color: isCancel ? colors.onSurface : colors.primary,
              fontWeight: isCancel ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _AdminCustomerActions extends ConsumerStatefulWidget {
  final UserProfile profile;

  const _AdminCustomerActions({required this.profile});

  @override
  ConsumerState<_AdminCustomerActions> createState() =>
      _AdminCustomerActionsState();
}

class _AdminCustomerActionsState extends ConsumerState<_AdminCustomerActions> {
  List<String>? _tagsOverride;
  bool _savingTags = false;

  UserProfile get profile => widget.profile;

  void _comingSoon(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action功能即将上线')),
    );
  }

  Future<void> _showMissingCustomerChatApi(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AppAlertDialog(
          title: const Text('缺少服务端接口'),
          content: const SingleChildScrollView(
            child: Text(
              '查看客户聊天信息需要服务端提供对应的会话查询接口。\n\n'
              '建议接口：GET /api/admin/v1/customer-service/center/threads?customerUserId={userId}\n'
              '或在客户资料接口中返回可查看的会话 ID 列表。',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('知道了'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAssignStaffSheet(
      BuildContext context, WidgetRef ref) async {
    final members = ref.read(tenantMembersProvider).valueOrNull ?? const [];
    final staff = members.where(_canServeCustomer).toList();

    if (staff.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('暂无可分配客服')),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '分配客服',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '选择新的负责客服，相关服务会话将同步转交。',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: staff.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final member = staff[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: UserAvatar(
                          avatarUrl: member.avatarUrl,
                          name: member.displayName,
                          size: 38,
                          borderRadius: 10,
                        ),
                        title: Text(
                          member.displayName,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(member.customerTag ?? '客服'),
                        onTap: () async {
                          Navigator.pop(ctx);
                          await _assignStaff(context, ref, member);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _canServeCustomer(Contact contact) {
    return AppPermissions.canBeAssignedAsCustomerService(
      roleTag: contact.customerTag,
    );
  }

  Future<void> _assignStaff(
    BuildContext context,
    WidgetRef ref,
    Contact staff,
  ) async {
    try {
      await ref
          .read(adminCustomerServiceRepositoryProvider)
          .assignCustomerService(
            customerUserId: profile.userId,
            staffUserId: staff.userId,
            transferConversation: true,
          );
      ref.invalidate(adminCustomersProvider);
      ref.invalidate(adminCustomerManagementSummaryProvider);
      ref.invalidate(adminCustomerDetailProvider(profile.userId));
      ref.invalidate(adminCustomerServiceDashboardProvider);
      ref.invalidate(
        adminCustomerServiceThreadsProvider(
          const AdminCustomerServiceThreadQuery(),
        ),
      );
      ref.invalidate(adminDirectCustomerThreadsProvider(false));
      ref.invalidate(adminDirectCustomerThreadsProvider(true));
      ref.invalidate(customerServiceThreadsProvider);
      ref.invalidate(customerServiceDashboardProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已分配给 ${staff.displayName}')),
      );
    } catch (e) {
      if (!context.mounted) return;
      final message = e is DioException && e.response?.statusCode == 403
          ? '当前账号无权分配客服，请使用企业所有者账号'
          : '分配客服失败，请稍后重试';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _editEnterpriseTags(List<String> currentTags) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => _FriendTextEditPage(
          title: '企业标签',
          labelText: '企业标签',
          hintText: '多个标签用逗号分隔',
          initialValue: currentTags.join('，'),
          maxLength: 120,
          maxLines: 3,
        ),
      ),
    );
    if (result == null) return;
    final nextTags = parseUserProfileTags(result);
    if (_savingTags) return;

    setState(() => _savingTags = true);
    try {
      await ref.read(adminCustomerServiceRepositoryProvider).updateCustomerTags(
            customerUserId: profile.userId,
            tags: nextTags,
          );
      ref.invalidate(adminCustomersProvider);
      ref.invalidate(adminCustomerDetailProvider(profile.userId));
      if (!mounted) return;
      setState(() {
        _tagsOverride = nextTags;
        _savingTags = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已保存企业标签')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _savingTags = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存标签失败，请稍后重试')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final space = ref.watch(currentSpaceProvider);
    final isOwner = space?.isOwner ?? false;
    final detailAsync = ref.watch(adminCustomerDetailProvider(profile.userId));
    final currentTags =
        _tagsOverride ?? detailAsync.valueOrNull?.tags ?? profile.tags;
    final hideGroupFeatures = ref.watch(appUpdateGroupFeaturesBlockedProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: _savingTags ? null : () => _editEnterpriseTags(currentTags),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '企业标签',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '用于客户管理筛选，企业内共享',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      _savingTags ? '保存中...' : _tagsText(currentTags),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        color: currentTags.isEmpty
                            ? colors.onSurfaceVariant
                            : colors.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: colors.onSurfaceVariant,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '所有者可调整该客户的负责客服。查看服务会话记录需要服务端提供对应接口。',
            style: TextStyle(
              fontSize: 13,
              color: colors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isOwner
                    ? () => _showMissingCustomerChatApi(context)
                    : () => _comingSoon(context, '查看聊天信息'),
                icon: const Icon(Icons.chat_outlined, size: 18),
                label: const Text('查看聊天信息'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  side: BorderSide(color: colors.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isOwner
                    ? () => _showAssignStaffSheet(context, ref)
                    : () => _comingSoon(context, '分配客服'),
                icon: const Icon(Icons.support_agent, size: 18),
                label: const Text('分配客服'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (!hideGroupFeatures) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => context.push('/group-list'),
            icon: const Icon(Icons.groups_outlined, size: 18),
            label: const Text('该客户的服务群'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primary,
              side: BorderSide(color: colors.primary, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool showArrow;

  const _InfoRow({
    required this.label,
    required this.value,
    this.onTap,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 62),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.outlineVariant)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 150,
              child: Text(
                label,
                style: TextStyle(fontSize: 16, color: colors.onSurface),
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: colors.onSurfaceVariant,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
