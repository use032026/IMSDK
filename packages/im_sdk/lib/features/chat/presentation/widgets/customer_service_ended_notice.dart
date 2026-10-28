import 'package:flutter/material.dart';

class CustomerServiceEndedNotice extends StatelessWidget {
  final String? statusLabel;
  final String description;
  final VoidCallback? onRefresh;
  final bool refreshing;

  const CustomerServiceEndedNotice({
    super.key,
    this.statusLabel,
    this.description = '历史记录已保留，客户继续对话后会恢复接待。',
    this.onRefresh,
    this.refreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = statusLabel?.trim();
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomInset),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  status == null || status.isEmpty ? '会话已结束' : status,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: refreshing ? null : onRefresh,
                icon: refreshing
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh, size: 16),
                label: const Text('刷新状态'),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
