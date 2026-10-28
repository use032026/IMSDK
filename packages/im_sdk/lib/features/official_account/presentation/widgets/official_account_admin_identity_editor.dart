import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_admin.dart';
import 'package:im_sdk/features/official_account/presentation/providers/official_account_admin_provider.dart';

Future<void> editOfficialAccountIdentity(BuildContext context, WidgetRef ref,
    OfficialAccountScope scope, OfficialAccountAdminOverview overview) async {
  final change = await showDialog<OfficialAccountProfileChange>(
      context: context, builder: (_) => _ProfileEditor(overview: overview));
  if (change == null || !context.mounted) return;
  try {
    await ref
        .read(officialAccountAdminProvider(scope).notifier)
        .updateProfile(change);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('官方号资料已保存')));
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('保存失败：$error')));
    }
  }
}

class _ProfileEditor extends StatefulWidget {
  final OfficialAccountAdminOverview overview;
  const _ProfileEditor({required this.overview});
  @override
  State<_ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<_ProfileEditor> {
  late final name = TextEditingController(text: widget.overview.displayName);
  late final avatar =
      TextEditingController(text: widget.overview.avatarUrl ?? '');
  late final lppId = TextEditingController(text: widget.overview.lppId ?? '');
  String? error;
  @override
  void dispose() {
    name.dispose();
    avatar.dispose();
    lppId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppAlertDialog(
        title: const Text('官方号资料'),
        scrollable: true,
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: name,
              maxLength: 64,
              decoration: const InputDecoration(labelText: '显示名称')),
          TextField(
              controller: avatar,
              decoration: const InputDecoration(
                  labelText: '头像 URL', helperText: '留空恢复企业 Logo')),
          TextField(
              controller: lppId,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                  labelText: '官方号', helperText: '6–10 位数字；留空解除绑定')),
          if (error != null)
            Text(error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('取消')),
          TextButton(
              onPressed: () {
                final change = OfficialAccountProfileChange(
                    displayName: name.text.trim(),
                    avatarUrl: avatar.text.trim(),
                    lppId: lppId.text.trim());
                if (change.validationError != null) {
                  setState(() => error = change.validationError);
                  return;
                }
                Navigator.pop(context, change);
              },
              child: const Text('保存'))
        ],
      );
}

class OfficialAccountAdminQrDialog extends ConsumerStatefulWidget {
  final OfficialAccountScope scope;
  const OfficialAccountAdminQrDialog({super.key, required this.scope});
  @override
  ConsumerState<OfficialAccountAdminQrDialog> createState() => _QrState();
}

class _QrState extends ConsumerState<OfficialAccountAdminQrDialog> {
  OfficialAccountAdminInviteQr? qr;
  Object? error;
  bool busy = true;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
  }

  Future<void> _load({bool reset = false}) async {
    if (!mounted) return;
    setState(() {
      busy = true;
      error = null;
      if (reset) qr = null;
    });
    try {
      final result = await ref
          .read(officialAccountAdminProvider(widget.scope).notifier)
          .getInviteQr(reset: reset);
      if (mounted) setState(() => qr = result);
    } catch (e) {
      if (mounted) setState(() => error = e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _reset() async {
    if (qr != null) {
      final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AppAlertDialog(
                  title: const Text('重置二维码'),
                  content: const Text('旧二维码将立即失效，确定重置？'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('取消')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('重置'))
                  ]));
      if (confirmed != true || !mounted) return;
    }
    await _load(reset: true);
  }

  @override
  Widget build(BuildContext context) => AppAlertDialog(
          title: const Text('官方号二维码'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            if (busy) const LinearProgressIndicator(),
            if (qr != null) ...[
              QrImageView(
                  data: qr!.qrPayload,
                  size: 200,
                  backgroundColor: Colors.white),
              Text('已使用 ${qr!.usedCount} 次')
            ],
            if (!busy && qr == null && error == null) const Text('尚未生成二维码'),
            if (error != null) const Text('二维码加载失败，请重试'),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭')),
            TextButton(
                onPressed: busy ? null : () => _load(),
                child: const Text('刷新')),
            TextButton(
                onPressed: busy || error != null ? null : _reset,
                child: Text(qr == null ? '生成' : '重置'))
          ]);
}
