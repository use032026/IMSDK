import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/widgets/app_alert_dialog.dart';
import 'package:im_sdk/features/chat/presentation/providers/complaint_submission_provider.dart';

// ---------------------------------------------------------------------------
// ComplaintPage — 投诉页面（微信风格：列表选择投诉原因）
// ---------------------------------------------------------------------------

class ComplaintPage extends ConsumerStatefulWidget {
  const ComplaintPage({
    this.subjectType,
    this.subjectId,
    super.key,
  });

  final String? subjectType;
  final String? subjectId;

  @override
  ConsumerState<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends ConsumerState<ComplaintPage> {
  bool _submitting = false;

  static const _options = [
    '存在欺诈骗钱行为',
    '存在侵权行为',
    '发送不良信息',
    '骚扰他人',
    '散布谣言',
    '其他',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: colors.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text('投诉',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.onSurface)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16),
        children: [
          Container(
            color: colors.surface,
            child: Column(
              children: _options.asMap().entries.map((e) {
                final i = e.key;
                final opt = e.value;
                return Column(
                  children: [
                    InkWell(
                      onTap: _submitting ? null : () => _submit(opt),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(opt,
                                  style: TextStyle(
                                      fontSize: 15, color: colors.onSurface)),
                            ),
                            Icon(Icons.chevron_right,
                                size: 18, color: colors.onSurfaceVariant),
                          ],
                        ),
                      ),
                    ),
                    if (i < _options.length - 1)
                      Divider(
                        height: 1,
                        indent: 16,
                        color: colors.outlineVariant,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(String reason) async {
    setState(() => _submitting = true);
    try {
      final result =
          await ref.read(complaintSubmissionControllerProvider).submit(
                reason: reason,
                subjectType: widget.subjectType,
                subjectId: widget.subjectId,
              );
      if (!mounted) return;
      await _showSubmittedDialog(reason, result.feedbackId);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('投诉提交失败，请重试')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _showSubmittedDialog(String reason, String feedbackId) {
    return showDialog<void>(
      context: context,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;
        return AppAlertDialog(
          backgroundColor: colors.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            '投诉已提交',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
          content: Text(
            '感谢你的反馈，我们会尽快处理「$reason」相关投诉。'
            '${feedbackId.isEmpty ? '' : '\n投诉编号：$feedbackId'}',
            style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.pop(); // 返回来源设置页
              },
              child: Text(
                '确定',
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
