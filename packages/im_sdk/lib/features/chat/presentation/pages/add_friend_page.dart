import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/permissions/app_permissions.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/contacts/application/friend_relation_status.dart';
import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/official_account/presentation/widgets/official_account_card_view.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';
import 'package:im_sdk/features/teen_mode/presentation/utils/teen_mode_ui.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// AddFriendPage
// ---------------------------------------------------------------------------

class AddFriendPage extends ConsumerStatefulWidget {
  const AddFriendPage({super.key, this.messagingOnly = false});
  final bool messagingOnly;

  @override
  ConsumerState<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends ConsumerState<AddFriendPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  bool _loading = false;
  String? _submittingUserId;
  List<Contact> _results = [];
  String? _errorMsg;
  final Set<String> _localPendingUserIds = <String>{};

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final l10n = AppLocalizations.of(context);
    final space = ref.read(currentSpaceProvider);
    final sourceSession =
        ref.read(currentAccountOperationContextProvider)?.sessionId;
    bool isCurrentSearch() {
      if (!mounted) return false;
      final current = ref.read(currentSpaceProvider);
      return current?.spaceId == space?.spaceId &&
          current?.userId == space?.userId &&
          ref.read(currentAccountOperationContextProvider)?.sessionId ==
              sourceSession;
    }

    final q = _searchCtrl.text.trim();
    if (q.isEmpty) return;

    setState(() {
      _loading = true;
      _errorMsg = null;
      _results = [];
    });

    try {
      final items = await ref.read(contactsRepositoryProvider).searchUsers(q);
      if (!isCurrentSearch()) return;
      await _refreshFriendRelations();
      if (!isCurrentSearch()) return;
      setState(() {
        _results = items
            .where((user) => user.userId.isNotEmpty)
            .where(
              (user) =>
                  user.officialAccount != null ||
                  widget.messagingOnly ||
                  AppPermissions.canDiscoverFriendCandidate(
                    space: space,
                    targetIsEmployee: user.isEmployee,
                  ),
            )
            .toList();
        if (_results.isEmpty) _errorMsg = l10n.friendSearchEmpty;
      });
    } on AppError catch (err) {
      if (!isCurrentSearch()) return;
      setState(() {
        _errorMsg =
            err is ServerError ? err.message : l10n.commonOperationFailed;
      });
    } catch (_) {
      if (!isCurrentSearch()) return;
      setState(() => _errorMsg = l10n.commonOperationFailed);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _isSelf(Contact user) {
    final currentUserId = ref.read(currentSpaceProvider)?.userId;
    return currentUserId != null && currentUserId == user.userId;
  }

  FriendRelationSnapshot _relationFor(Contact user) {
    return resolveFriendRelation(
      userId: user.userId,
      currentUserId: ref.read(currentSpaceProvider)?.userId,
      friends: ref.read(friendsProvider).valueOrNull ?? const [],
      requests: ref.read(friendRequestsProvider).valueOrNull ?? const [],
      isFriend: user.isFriend,
      localOutgoingPending: _localPendingUserIds.contains(user.userId),
    );
  }

  Future<void> _refreshFriendRelations() async {
    try {
      await ref.read(friendsProvider.notifier).refresh();
    } catch (_) {
      // 搜索结果仍可展示；好友关系用搜索返回的 isFriend 或本地缓存兜底。
    }
    try {
      final _ = await ref.refresh(friendRequestsProvider.future);
      ref.invalidate(pendingFriendRequestsProvider);
    } catch (_) {
      // 待验证申请读取失败不影响搜索结果展示。
    }
  }

  Future<void> _sendFriendRequest(Contact user) async {
    final l10n = AppLocalizations.of(context);
    if (!ref.read(teenModePolicyProvider).canAttemptAddFriend) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.teenModeActionBlocked)),
      );
      return;
    }
    final space = ref.read(currentSpaceProvider);
    if (_isSelf(user)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addFriendCannotAddSelf)),
      );
      return;
    }
    final permission = AppPermissions.canSendFriendRequest(
      space: space,
      groupAllowsFriendRequest: true,
      targetIsEmployee: user.isEmployee,
    );
    if (!widget.messagingOnly && !permission.allowed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(permission.reason ?? l10n.friendRequestFailed)),
      );
      return;
    }

    setState(() => _submittingUserId = user.userId);
    try {
      final result = await ref
          .read(contactsRepositoryProvider)
          .sendFriendRequest(user.userId);
      if (result.becameFriends) {
        _localPendingUserIds.remove(user.userId);
      } else {
        _localPendingUserIds.add(user.userId);
      }
      await _refreshFriendRelations();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(result.becameFriends ? '你们已成为好友' : l10n.friendRequestSent),
        ));
      }
    } catch (e) {
      final err = e is AppError ? e : const NetworkError('发送失败，请重试');
      if (mounted) {
        if (showTeenModeServerAction(context, ref, err)) {
          _localPendingUserIds.remove(user.userId);
        } else if (_isAlreadyFriendError(err)) {
          _localPendingUserIds.remove(user.userId);
          await _refreshFriendRelations();
          if (mounted) _openProfile(user);
        } else if (_isPendingFriendRequestError(err)) {
          _localPendingUserIds.add(user.userId);
          await _refreshFriendRelations();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('好友申请已发送，等待对方通过')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_friendRequestErrorMessage(l10n, err))));
        }
      }
    } finally {
      if (mounted) setState(() => _submittingUserId = null);
    }
  }

  bool _isAlreadyFriendError(AppError err) {
    if (err is! ServerError) return false;
    return isAlreadyFriendErrorCode(err.code, err.message);
  }

  bool _isPendingFriendRequestError(AppError err) {
    if (err is! ServerError) return false;
    return isFriendRequestPendingErrorCode(err.code, err.message);
  }

  String _friendRequestErrorMessage(AppLocalizations l10n, AppError err) {
    if (err is ServerError &&
        err.message.toLowerCase().contains('invalid operation')) {
      return l10n.addFriendUnsupportedUser;
    }
    return err is ServerError ? err.message : l10n.friendRequestFailed;
  }

  void _openProfile(Contact user) {
    context.push('/profile/${user.userId}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(l10n),
          const SizedBox(height: 8),
          if (!widget.messagingOnly) _buildOptions(),
          if (_loading)
            Padding(
              padding: const EdgeInsets.all(32),
              child: CircularProgressIndicator(color: colors.primary),
            )
          else if (_results.isNotEmpty)
            Expanded(child: _buildResults(l10n))
          else if (_errorMsg != null)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.search,
                    size: 48,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _errorMsg!,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else if (_query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.search,
                    size: 48,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.addFriendSearchHint,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: colors.onSurface,
                      size: 20,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(l10n.addFriendTitle,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: colors.onSurface)),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _query = v),
                        onSubmitted: (_) => _search(),
                        keyboardType: TextInputType.emailAddress,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: colors.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.addFriendSearchHint,
                          hintStyle: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 15,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 16,
                            color: colors.onSurfaceVariant,
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 34),
                          filled: true,
                          fillColor: colors.surfaceContainerHighest,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 10, 12, 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: colors.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: colors.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: colors.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _search,
                    child: Text(l10n.commonSearch,
                        style: TextStyle(
                            fontSize: 15,
                            color: colors.primary,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions() {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.surface,
      child: Column(
        children: [
          _OptionTile(
            icon: Icons.qr_code_scanner,
            label: '扫一扫',
            onTap: () => context.push('/scan'),
          ),
          Divider(height: 1, indent: 56, color: colors.outlineVariant),
          _OptionTile(
            icon: Icons.qr_code,
            label: '我的二维码',
            onTap: () => context.push('/qrcode'),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(AppLocalizations l10n) {
    final colors = Theme.of(context).colorScheme;
    ref.watch(friendsProvider);
    ref.watch(friendRequestsProvider);
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: _results.length,
      itemBuilder: (context, i) {
        final user = _results[i];
        if (user.officialAccount != null) {
          return OfficialAccountSearchTile(
            card: user.officialAccount!,
            onTap: () => _openProfile(user),
          );
        }
        final relation = _relationFor(user);
        final isSelf = relation.status == FriendRelationStatus.self;
        final isFriend = relation.status == FriendRelationStatus.friend;
        final isOutgoingPending =
            relation.status == FriendRelationStatus.outgoingPending;
        final isIncomingPending =
            relation.status == FriendRelationStatus.incomingPending;
        final isSubmitting = _submittingUserId == user.userId;
        final buttonLabel = isSelf
            ? '自己'
            : isFriend
                ? '查看'
                : isOutgoingPending
                    ? '等待验证'
                    : isIncomingPending
                        ? '去处理'
                        : l10n.addFriendButton;
        return Container(
          color: colors.surface,
          margin: const EdgeInsets.only(bottom: 1),
          child: ListTile(
            leading: UserAvatar(
              avatarUrl: user.avatarUrl,
              name: user.displayName,
              size: 48,
              borderRadius: 24,
            ),
            title: Text(user.displayName,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: colors.onSurface)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (user.lppId != null)
                  Text('${l10n.profilePageLppId}: ${user.lppId}',
                      style: TextStyle(
                          fontSize: 12, color: colors.onSurfaceVariant)),
                if (user.signature != null && user.signature!.isNotEmpty)
                  Text(user.signature!,
                      style: TextStyle(
                          fontSize: 12, color: colors.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: isSubmitting || isSelf || isOutgoingPending
                  ? null
                  : () {
                      if (isIncomingPending) {
                        context.push('/new-friends');
                        return;
                      }
                      if (isFriend) {
                        _openProfile(user);
                        return;
                      }
                      _sendFriendRequest(user);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                minimumSize: const Size(72, 32),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 13),
              ),
              child: isSubmitting
                  ? SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.onPrimary,
                      ),
                    )
                  : Text(buttonLabel),
            ),
            onTap: () => _openProfile(user),
          ),
        );
      },
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors.surface, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: TextStyle(fontSize: 16, color: colors.onSurface)),
            ),
            Icon(
              Icons.chevron_right,
              color: colors.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
