import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/space/space_manager.dart';
import 'package:im_sdk/core/storage/account_profile_box_provider.dart';
import 'package:im_sdk/features/chat/presentation/widgets/group_conversation_avatar.dart';

// ---------------------------------------------------------------------------
// Provider — 本地存储群备注（仅自己可见，无服务端接口）
// ---------------------------------------------------------------------------

/// 读取群备注（本地 Hive）
Future<String?> loadGroupRemark(
  String spaceId,
  String groupId,
  AccountProfileBoxResolver profileBoxResolver,
) async {
  try {
    final box = await profileBoxResolver(spaceId);
    return box.get('group_remark_$groupId') as String?;
  } catch (_) {
    return null;
  }
}

/// 保存群备注（本地 Hive）
Future<void> saveGroupRemark(
  String spaceId,
  String groupId,
  String remark,
  AccountProfileBoxResolver profileBoxResolver,
) async {
  final box = await profileBoxResolver(spaceId);
  if (remark.isEmpty) {
    await box.delete('group_remark_$groupId');
  } else {
    await box.put('group_remark_$groupId', remark);
  }
}

// ---------------------------------------------------------------------------
// GroupRemarkPage
// ---------------------------------------------------------------------------

class GroupRemarkPage extends ConsumerStatefulWidget {
  final String groupId;
  final String groupName;
  final String? groupAvatarUrl;

  const GroupRemarkPage({
    super.key,
    required this.groupId,
    required this.groupName,
    this.groupAvatarUrl,
  });

  @override
  ConsumerState<GroupRemarkPage> createState() => _GroupRemarkPageState();
}

class _GroupRemarkPageState extends ConsumerState<GroupRemarkPage> {
  late final TextEditingController _ctrl;
  bool _saving = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
    _loadRemark();
  }

  Future<void> _loadRemark() async {
    final space = ref.read(currentSpaceProvider);
    if (space == null) return;
    final remark = await loadGroupRemark(
      space.spaceId,
      widget.groupId,
      ref.read(accountProfileBoxResolverProvider),
    );
    if (mounted) {
      setState(() {
        _ctrl.text = remark ?? '';
        _loaded = true;
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final space = ref.read(currentSpaceProvider);
    if (space == null) return;
    setState(() => _saving = true);
    await saveGroupRemark(
      space.spaceId,
      widget.groupId,
      _ctrl.text.trim(),
      ref.read(accountProfileBoxResolverProvider),
    );
    if (mounted) {
      setState(() => _saving = false);
      context.pop(_ctrl.text.trim()); // 返回新备注给上层
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = _ctrl.text.trim().isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '备注',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 说明文字
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text('群聊的备注仅自己可见',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                )),
          ),

          // 输入卡片
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 群头像
                GroupConversationAvatar(
                  groupId: widget.groupId,
                  size: 44,
                  borderRadius: 8,
                ),
                const SizedBox(width: 12),
                // 输入框
                Expanded(
                  child: _loaded
                      ? TextField(
                          controller: _ctrl,
                          autofocus: true,
                          maxLength: 30,
                          style: TextStyle(
                            fontSize: 15,
                            color: colorScheme.onSurface,
                          ),
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: '备注',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            border: InputBorder.none,
                            counterText: '',
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: colorScheme.outlineVariant),

          // 群聊名称提示 + 填入按钮
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Text('群聊名称：${widget.groupName}  ',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    )),
                GestureDetector(
                  onTap: () {
                    _ctrl.text = widget.groupName;
                    setState(() {});
                  },
                  child: Text(
                    '填入',
                    style: TextStyle(fontSize: 13, color: colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // 确定按钮
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: hasContent && !_saving ? _save : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasContent
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  foregroundColor: colorScheme.onPrimary,
                  disabledForegroundColor: colorScheme.onSurfaceVariant,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _saving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: colorScheme.onPrimary))
                    : const Text('确定',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
