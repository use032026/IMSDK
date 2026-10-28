import 'package:flutter/material.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/official_account/presentation/widgets/official_account_admin_identity_editor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/network/site_line_manager.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_admin.dart';
import 'package:im_sdk/features/official_account/presentation/providers/official_account_admin_provider.dart';

class OfficialAccountPage extends ConsumerWidget {
  const OfficialAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final space = ref.watch(currentSpaceProvider);
    final colorScheme = Theme.of(context).colorScheme;
    if (space == null || !space.isAdminOrAbove) {
      return Scaffold(
        backgroundColor: colorScheme.surfaceContainerLow,
        appBar: buildSettingsAppBar(context, '官方账号管理'),
        body: const _LoadError(forbidden: true),
      );
    }
    final scope = (
      siteId: SiteLineManager.instance.currentSite.id,
      spaceId: space.spaceId,
      userId: space.userId,
    );
    final provider = officialAccountAdminProvider(scope);
    final state = ref.watch(provider);
    Future<void> save(OfficialAccountAdminConfig config) =>
        _save(context, ref, scope, config);
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: buildSettingsAppBar(context, '官方账号管理'),
      body: state.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _LoadError(
          forbidden: error is OfficialAccountManagePermissionDenied ||
              (error is ServerError && error.statusCode == 403),
          onRetry: () => ref.invalidate(provider),
        ),
        data: (overview) => RefreshIndicator(
          onRefresh: () async => ref.refresh(provider.future),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              if (state.isRefreshing)
                const LinearProgressIndicator(minHeight: 2),
              _IdentityCard(overview: overview),
              _SectionCard(
                  title: '官方号资料与二维码',
                  subtitle: '维护客户看到的官方身份',
                  children: [
                    _ValueRow(
                        title: '编辑资料',
                        value: overview.lppId == null
                            ? '设置官方号、名称及头像'
                            : '官方号 ${overview.lppId}',
                        onTap: state.isRefreshing
                            ? null
                            : () => editOfficialAccountIdentity(
                                context, ref, scope, overview)),
                    _ValueRow(
                        title: '官方号二维码',
                        value: '查看或重置',
                        onTap: () => showDialog<void>(
                            context: context,
                            builder: (_) =>
                                OfficialAccountAdminQrDialog(scope: scope))),
                    _SwitchRow(
                        title: '加官方号自动加入企业',
                        subtitle: '客户添加官方号时自动加入企业客户空间',
                        value: overview.config.friendAutoJoin,
                        onChanged: state.isRefreshing
                            ? null
                            : (value) => save(overview.config
                                .copyWith(friendAutoJoin: value))),
                  ]),
              const SizedBox(height: 16),
              _SectionCard(
                title: '会话能力',
                subtitle: '设置会立即影响客户侧官方会话',
                children: [
                  _SwitchRow(
                    title: '服务菜单',
                    subtitle: '向客户展示已在 PC 管理端配置的菜单',
                    value: overview.config.menuEnabled,
                    onChanged: state.isRefreshing
                        ? null
                        : (value) =>
                            save(overview.config.copyWith(menuEnabled: value)),
                  ),
                  _SwitchRow(
                    title: '首次欢迎语',
                    subtitle: overview.config.welcomeText,
                    value: overview.config.welcomeEnabled,
                    onChanged: state.isRefreshing
                        ? null
                        : (value) => save(
                              overview.config.copyWith(welcomeEnabled: value),
                            ),
                    onTap: state.isRefreshing
                        ? null
                        : () => _editText(
                              context,
                              title: '欢迎语',
                              initialValue: overview.config.welcomeText,
                              onSave: (value) => save(
                                overview.config.copyWith(welcomeText: value),
                              ),
                            ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: '人工客服引流',
                subtitle: '新建或重新开启的接待采用所选模式，进行中的会话保持原模式',
                children: [
                  _ValueRow(
                      title: '人工接待模式',
                      value: overview.config.handoffMode == 'in_official'
                          ? '官方号会话内接待'
                          : '坐席独立私聊（旧模式）',
                      onTap: state.isRefreshing
                          ? null
                          : () async {
                              final mode = await showDialog<String>(
                                  context: context,
                                  builder: (context) => SimpleDialog(
                                          title: const Text('人工接待模式'),
                                          children: [
                                            SimpleDialogOption(
                                                onPressed: () => Navigator.pop(
                                                    context, 'in_official'),
                                                child: const Text('官方号会话内接待')),
                                            SimpleDialogOption(
                                                onPressed: () => Navigator.pop(
                                                    context, 'separate_dm'),
                                                child:
                                                    const Text('坐席独立私聊（旧模式）')),
                                          ]));
                              if (mode != null) {
                                await save(overview.config
                                    .copyWith(handoffMode: mode));
                              }
                            }),
                  if (overview.config.handoffMode == 'in_official') ...[
                    _SwitchRow(
                        title: '接待服务提示',
                        subtitle: overview.config.servingNoticeText,
                        value: overview.config.servingNoticeEnabled,
                        onChanged: state.isRefreshing
                            ? null
                            : (value) => save(overview.config
                                .copyWith(servingNoticeEnabled: value)),
                        onTap: state.isRefreshing
                            ? null
                            : () => _editText(context,
                                title: '接待服务提示语',
                                initialValue: overview.config.servingNoticeText,
                                onSave: (value) => save(overview.config
                                    .copyWith(servingNoticeText: value)))),
                  ],
                  _SwitchRow(
                    title: '自动转人工',
                    subtitle: '客户在官方会话发消息时触发坐席分配',
                    value: overview.config.inboundHandoffEnabled,
                    onChanged: state.isRefreshing
                        ? null
                        : (value) => save(
                              overview.config
                                  .copyWith(inboundHandoffEnabled: value),
                            ),
                  ),
                  if (overview.config.handoffMode != 'in_official')
                    _SwitchRow(
                      title: '转发客户原话',
                      subtitle: '转接后把客户消息同步给坐席',
                      value: overview.config.relayCustomerMessageToStaff,
                      onChanged: state.isRefreshing
                          ? null
                          : (value) => save(
                                overview.config.copyWith(
                                  relayCustomerMessageToStaff: value,
                                ),
                              ),
                    ),
                  if (overview.config.handoffMode != 'in_official' &&
                      overview.config.mirrorStaffReplyToOfficial != null)
                    _SwitchRow(
                        title: '坐席回复同步官方号',
                        subtitle: '旧模式下将坐席回复同步回官方会话',
                        value: overview.config.mirrorStaffReplyToOfficial!,
                        onChanged: state.isRefreshing
                            ? null
                            : (value) => save(overview.config
                                .copyWith(mirrorStaffReplyToOfficial: value))),
                  _ValueRow(
                    title: '引流提示冷却',
                    value: '${overview.config.handoffNoticeCooldownMinutes} 分钟',
                    onTap: state.isRefreshing
                        ? null
                        : () => _editCooldown(
                              context,
                              overview.config,
                              save,
                            ),
                  ),
                  if (overview.config.handoffMode != 'in_official')
                    _ValueRow(
                      title: '已分配提示语',
                      value: overview.config.handoffAssignedText,
                      onTap: state.isRefreshing
                          ? null
                          : () => _editText(
                                context,
                                title: '已分配提示语',
                                initialValue:
                                    overview.config.handoffAssignedText,
                                onSave: (value) => save(
                                  overview.config
                                      .copyWith(handoffAssignedText: value),
                                ),
                              ),
                    ),
                  _ValueRow(
                    title: '排队提示语',
                    value: overview.config.handoffQueuedText,
                    onTap: state.isRefreshing
                        ? null
                        : () => _editText(
                              context,
                              title: '排队提示语',
                              initialValue: overview.config.handoffQueuedText,
                              onSave: (value) => save(
                                overview.config
                                    .copyWith(handoffQueuedText: value),
                              ),
                            ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '菜单结构、密码和官方群管理请在 PC 工作台完成。',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    OfficialAccountScope scope,
    OfficialAccountAdminConfig config,
  ) async {
    try {
      await ref
          .read(officialAccountAdminProvider(scope).notifier)
          .updateConfig(config);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('设置已保存')));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('保存失败，请稍后重试')));
    }
  }

  Future<void> _editCooldown(
    BuildContext context,
    OfficialAccountAdminConfig config,
    Future<void> Function(OfficialAccountAdminConfig config) onSave,
  ) async {
    final controller = TextEditingController(
      text: config.handoffNoticeCooldownMinutes.toString(),
    );
    final value = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AppAlertDialog(
        title: const Text('引流提示冷却'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: '分钟',
            helperText: '范围 0–1440 分钟',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final minutes = int.tryParse(controller.text);
              if (minutes == null || minutes < 0 || minutes > 1440) return;
              Navigator.pop(dialogContext, minutes);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null || !context.mounted) return;
    await onSave(config.copyWith(handoffNoticeCooldownMinutes: value));
  }

  Future<void> _editText(
    BuildContext context, {
    required String title,
    required String initialValue,
    required Future<void> Function(String value) onSave,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AppAlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          decoration: const InputDecoration(
            helperText: '支持 {staff}、{tenant}、{customer} 占位符',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null || !context.mounted) return;
    await onSave(value.trim());
  }
}

class _IdentityCard extends StatelessWidget {
  final OfficialAccountAdminOverview overview;

  const _IdentityCard({required this.overview});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primaryContainer,
                  child: overview.avatarUrl == null
                      ? Icon(
                          Icons.verified_outlined,
                          color: colorScheme.onPrimaryContainer,
                        )
                      : ClipOval(
                          child: AuthNetworkImage(
                            url: overview.avatarUrl!,
                            width: 48,
                            height: 48,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        overview.displayName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        overview.loginName,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(
                  active: overview.status == OfficialAccountAdminStatus.active,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _Metric(label: '客户', value: overview.linkedCustomerCount),
                _Metric(label: '官方群', value: overview.groupCount),
                _Metric(label: '菜单项', value: overview.menuItemCount),
                _Metric(label: '菜单版本', value: overview.menuVersion),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SwitchListTile.adaptive(
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: GestureDetector(
        onTap: onTap,
        child: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: onTap == null
                ? colorScheme.onSurfaceVariant
                : colorScheme.primary,
            fontSize: 12,
          ),
        ),
      ),
      value: value,
      activeTrackColor: colorScheme.primary,
      onChanged: onChanged,
    );
  }
}

class _ValueRow extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _ValueRow({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final int value;

  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;

  const _StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? '启用' : '停用',
        style: TextStyle(
          color: active
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  final bool forbidden;
  final VoidCallback? onRetry;

  const _LoadError({required this.forbidden, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              forbidden ? Icons.lock_outline : Icons.cloud_off_outlined,
              size: 44,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 14),
            Text(
              forbidden ? '当前账号缺少 service_account.manage 权限' : '官方账号配置加载失败',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (!forbidden)
              OutlinedButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}
