import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/customer_service/application/customer_service_ai_reply_controller.dart';
import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';
import 'package:im_sdk/features/customer_service/presentation/providers/customer_service_providers.dart';

Future<String?> showCustomerServiceAiReplySheet(
  BuildContext context, {
  required CustomerServiceAiReplyTarget target,
  String? contextText,
}) {
  return showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.86,
      child: CustomerServiceAiReplySheet(
        target: target,
        contextText: contextText,
      ),
    ),
  );
}

class CustomerServiceAiReplySheet extends ConsumerWidget {
  final CustomerServiceAiReplyTarget target;
  final String? contextText;

  const CustomerServiceAiReplySheet({
    super.key,
    required this.target,
    this.contextText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(customerServiceAiReplyProvider(target));
    final controller =
        ref.read(customerServiceAiReplyProvider(target).notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final contextPreview = contextText?.trim() ?? '';
    final hasSuggestions = state.suggestions.isNotEmpty;
    final busy =
        state.isLoadingHistory || state.isGenerating || state.isAdopting;

    Future<void> retryFailure() async {
      switch (state.failureOperation) {
        case CustomerServiceAiReplyFailureOperation.history:
          await controller.loadHistory();
          return;
        case CustomerServiceAiReplyFailureOperation.generate:
          await controller.generateSuggestion();
          return;
        case CustomerServiceAiReplyFailureOperation.adopt:
          final text = await controller.adoptSelected();
          if (!context.mounted || text == null) return;
          Navigator.of(context).pop(text);
          return;
        case null:
          return;
      }
    }

    final retry =
        state.error == null || busy ? null : () => unawaited(retryFailure());

    return SafeArea(
      top: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'AI回复',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                IconButton(
                  tooltip: '关闭',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              children: [
                if (contextPreview.isNotEmpty) ...[
                  Text(
                    '客户消息',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      contextPreview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hasSuggestions ? '回复建议' : '生成回复建议',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: busy ? null : controller.generateSuggestion,
                      icon: state.isGenerating
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.auto_awesome_outlined, size: 18),
                      label: Text(
                        hasSuggestions ? '重新生成' : '生成建议',
                      ),
                    ),
                  ],
                ),
                if (state.isLoadingHistory && !hasSuggestions)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 44),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (!hasSuggestions)
                  _EmptyState(
                    error: state.error,
                    onRetry: retry,
                  )
                else ...[
                  if (state.error != null)
                    _InlineError(
                      message: _formatAiReplyError(state.error),
                      onRetry: retry,
                    ),
                  ...state.suggestions.map(
                    (suggestion) => _SuggestionCard(
                      suggestion: suggestion,
                      selected: suggestion.suggestionId ==
                          state.selectedSuggestion?.suggestionId,
                      onSelected: () =>
                          controller.selectSuggestion(suggestion.suggestionId),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: state.selectedSuggestion == null || busy
                      ? null
                      : () async {
                          await Clipboard.setData(
                            ClipboardData(
                              text: state.selectedSuggestion!.text,
                            ),
                          );
                        },
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  label: const Text('复制'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: state.selectedSuggestion == null || busy
                        ? null
                        : () async {
                            final text = await controller.adoptSelected();
                            if (!context.mounted || text == null) return;
                            Navigator.of(context).pop(text);
                          },
                    icon: state.isAdopting
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.edit_outlined, size: 18),
                    label: Text(state.isAdopting ? '采纳中…' : '插入回复'),
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

class _SuggestionCard extends StatelessWidget {
  final CsAiSuggestion suggestion;
  final bool selected;
  final VoidCallback onSelected;

  const _SuggestionCard({
    required this.suggestion,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onSelected,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer.withValues(alpha: 0.48)
                : colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  selected ? colorScheme.primary : colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      suggestion.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.45,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? colorScheme.primary : colorScheme.outline,
                    size: 21,
                  ),
                ],
              ),
              if (suggestion.sources.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  '知识来源',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 5),
                ...suggestion.sources.take(3).map(
                      (source) => _SourceRow(source: source),
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  final CsAiSuggestionSource source;

  const _SourceRow({required this.source});

  @override
  Widget build(BuildContext context) {
    final title = source.documentTitle ?? source.knowledgeBaseName ?? '知识库资料';
    final detail = [
      if (source.knowledgeBaseName != null && source.knowledgeBaseName != title)
        source.knowledgeBaseName!,
      if (source.headingPath.isNotEmpty) source.headingPath.join(' / '),
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.description_outlined, size: 16),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                if (detail.isNotEmpty)
                  Text(
                    detail,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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

class _EmptyState extends StatelessWidget {
  final Object? error;
  final VoidCallback? onRetry;

  const _EmptyState({this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 42),
      child: Column(
        children: [
          Icon(
            error == null
                ? Icons.auto_awesome_outlined
                : Icons.error_outline_rounded,
            size: 34,
          ),
          const SizedBox(height: 10),
          Text(
            error == null
                ? '暂无历史建议，点击生成一条真实 AI 回复'
                : _formatAiReplyError(error),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 10),
            TextButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _InlineError({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(child: Text(message)),
          TextButton(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
    );
  }
}

String _formatAiReplyError(Object? error) {
  if (error is ServerError) {
    final code = error.code.trim().toUpperCase();
    if (code == 'CS_SUGGESTION_NO_CUSTOMER_MESSAGE') {
      return '暂无客户消息可用于生成回复';
    }
    if (code == 'CUSTOMER_SERVICE_STAFF_REQUIRED' || error.statusCode == 403) {
      return '当前账号无客服 AI 权限';
    }
    if (code == 'CS_THREAD_TYPE_INVALID') {
      return '当前会话类型暂不支持 AI 回复';
    }
    if (code.contains('THREAD_NOT_FOUND')) {
      return '当前客服会话不可用，请刷新后重试';
    }
  }
  if (error is NetworkError) return error.message;
  return 'AI 回复请求失败，请重试';
}
