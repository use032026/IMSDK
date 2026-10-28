import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';
import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';
import 'package:im_sdk/features/teen_mode/presentation/utils/teen_mode_ui.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class TeenRequestsPage extends ConsumerWidget {
  const TeenRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(teenRequestsControllerProvider);
    return Scaffold(
      appBar: buildSettingsAppBar(context, l10n.teenModeMyRequests),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: OutlinedButton(
            onPressed: () => ref.invalidate(teenRequestsControllerProvider),
            child: Text(teenModeErrorText(error, l10n)),
          ),
        ),
        data: (page) => RefreshIndicator(
          onRefresh: () =>
              ref.read(teenRequestsControllerProvider.notifier).refresh(),
          child: page.items.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 160),
                    Center(child: Text(l10n.approvalEmpty)),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: page.items.length +
                      (page.nextCursor?.isNotEmpty == true ? 1 : 0),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index == page.items.length) {
                      return Center(
                        child: TextButton(
                          onPressed: () => ref
                              .read(teenRequestsControllerProvider.notifier)
                              .loadMore(),
                          child: Text(l10n.commonMore),
                        ),
                      );
                    }
                    final request = page.items[index];
                    return _ApprovalTile(
                      request: request,
                      trailing: request.status == GuardianApprovalStatus.pending
                          ? TextButton(
                              onPressed: () => _cancel(context, ref, request),
                              child: Text(l10n.commonCancel),
                            )
                          : null,
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<void> _cancel(
    BuildContext context,
    WidgetRef ref,
    GuardianApproval request,
  ) async {
    try {
      await ref
          .read(teenRequestsControllerProvider.notifier)
          .cancel(request.requestId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context).requestCancelled)),
        );
      }
    } catch (error) {
      if (context.mounted) showTeenModeError(context, error, ref: ref);
    }
  }
}

class GuardianApprovalsPage extends ConsumerWidget {
  const GuardianApprovalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(guardianCenterControllerProvider);
    return Scaffold(
      appBar: buildSettingsAppBar(context, l10n.guardianApprovals),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: OutlinedButton(
            onPressed: () => ref.invalidate(guardianCenterControllerProvider),
            child: Text(teenModeErrorText(error, l10n)),
          ),
        ),
        data: (center) {
          final items = center.approvals.items;
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(guardianCenterControllerProvider.notifier).refresh(),
            child: items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 160),
                      Center(child: Text(l10n.approvalEmpty)),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: items.length +
                        (center.approvals.nextCursor?.isNotEmpty == true
                            ? 1
                            : 0),
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      if (index == items.length) {
                        return Center(
                          child: TextButton(
                            onPressed: () => ref
                                .read(guardianCenterControllerProvider.notifier)
                                .loadMoreApprovals(),
                            child: Text(l10n.commonMore),
                          ),
                        );
                      }
                      final request = items[index];
                      return _ApprovalTile(
                        request: request,
                        trailing: request.status ==
                                GuardianApprovalStatus.pending
                            ? Wrap(
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        _decide(context, ref, request, false),
                                    child: Text(l10n.approvalReject),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        _decide(context, ref, request, true),
                                    child: Text(l10n.approvalApprove),
                                  ),
                                ],
                              )
                            : null,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  Future<void> _decide(
    BuildContext context,
    WidgetRef ref,
    GuardianApproval request,
    bool approve,
  ) async {
    String? note;
    if (!approve) {
      note = await showTeenTextInputDialog(
        context,
        title: AppLocalizations.of(context).approvalReject,
        label: AppLocalizations.of(context).approvalReject,
      );
      if (!context.mounted || note == null) return;
    }
    try {
      await ref.read(guardianCenterControllerProvider.notifier).decide(
            requestId: request.requestId,
            approve: approve,
            note: note,
          );
    } catch (error) {
      if (context.mounted) showTeenModeError(context, error, ref: ref);
    }
  }
}

class _ApprovalTile extends StatelessWidget {
  const _ApprovalTile({required this.request, this.trailing});

  final GuardianApproval request;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = request.actionLabel.isNotEmpty
        ? request.actionLabel
        : request.actionCode;
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (request.summary.isNotEmpty) Text(request.summary),
          Text(approvalStatusLabel(l10n, request.status)),
          if (request.replayStatus == GuardianReplayStatus.failed)
            Text(
              request.replayError?.isNotEmpty == true
                  ? request.replayError!
                  : l10n.approvalReplayFailed,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
      trailing: trailing,
      isThreeLine: request.replayStatus == GuardianReplayStatus.failed,
    );
  }
}
