import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/app/router/router.dart';
import 'package:im_sdk/app/theme/theme.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_entities.dart';
import 'package:im_sdk/features/auth/presentation/auth_localization.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class TenantSelectPage extends ConsumerWidget {
  const TenantSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);

    ref.listen<AsyncValue<AuthState>>(authProvider, (_, next) {
      next.whenOrNull(
        data: (state) {
          if (state.status == AuthStatus.authenticated) {
            context.go(AppRoutes.home);
          } else if (state.error != null &&
              state.error != AuthPresentationFailure.tenantDirectory) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  authPresentationFailureMessage(l10n, state.error!),
                ),
              ),
            );
          }
        },
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                authExceptionMessage(
                  l10n,
                  e,
                  fallback: l10n.commonOperationFailed,
                ),
              ),
            ),
          );
        },
      );
    });

    final tenants = authState.valueOrNull?.availableTenants ?? [];
    final canSelectPersonalSpace = authState.valueOrNull?.platformToken != null;
    final isLoading = authState.isLoading;
    final directoryFailed =
        authState.valueOrNull?.error == AuthPresentationFailure.tenantDirectory;

    void handleBack() {
      if (isLoading) return;
      if (canSelectPersonalSpace) {
        ref.read(authProvider.notifier).selectPersonalSpace();
      } else {
        context.go(AppRoutes.login);
      }
    }

    // GoRouter 13 skips root-route PopScope callbacks for Android back.
    return BackButtonListener(
      onBackButtonPressed: () async {
        if (!canSelectPersonalSpace && !isLoading) return false;
        handleBack();
        return true;
      },
      child: PopScope<void>(
        canPop: !canSelectPersonalSpace && !isLoading,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && canSelectPersonalSpace) handleBack();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(l10n.authSelectOrganization),
            backgroundColor: colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: isLoading ? null : handleBack,
            ),
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : directoryFailed
                  ? _buildDirectoryError(context, l10n, ref)
                  : tenants.isEmpty && !canSelectPersonalSpace
                      ? _buildEmpty(context, l10n)
                      : _buildTenantList(context, ref, tenants),
        ),
      ),
    );
  }

  Widget _buildDirectoryError(
    BuildContext context,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined,
              size: 64, color: colorScheme.onSurface.withValues(alpha: 0.35)),
          const SizedBox(height: 16),
          Text(
            l10n.startupFailureMessage,
            style: AppTextStyles.bodySecondary.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref
                .read(authProvider.notifier)
                .retryRegistrationTenantDirectory(),
            child: Text(l10n.commonRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.business_outlined,
              size: 64, color: colorScheme.onSurface.withValues(alpha: 0.35)),
          const SizedBox(height: 16),
          Text(
            l10n.authNoOrganization,
            style: AppTextStyles.bodySecondary.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.authNoOrganizationHint,
            style: AppTextStyles.caption.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTenantList(
    BuildContext context,
    WidgetRef ref,
    List<TenantSummary> tenants,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tenants.length + 1, // +1 for personal space entry
      separatorBuilder: (context, __) => Divider(
        height: 0.5,
        indent: 72,
        color: Theme.of(context).dividerColor,
      ),
      itemBuilder: (context, index) {
        // 最后一项：进入个人空间
        if (index == tenants.length) {
          return _PersonalSpaceItem(
            onTap: () => ref.read(authProvider.notifier).selectPersonalSpace(),
          );
        }
        final tenant = tenants[index];
        return _TenantListItem(
          tenant: tenant,
          onTap: () => ref.read(authProvider.notifier).selectTenant(
                tenant.tenantId,
              ),
        );
      },
    );
  }
}

class _TenantListItem extends StatelessWidget {
  final TenantSummary tenant;
  final VoidCallback onTap;

  const _TenantListItem({required this.tenant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildAvatar(context),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tenant.tenantName,
                    style: AppTextStyles.body.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _tenantRoleLabel(
                      AppLocalizations.of(context),
                      tenant.membershipRole,
                    ),
                    style: AppTextStyles.caption.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (tenant.logoUrl != null && tenant.logoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AuthNetworkImage(
          url: tenant.logoUrl!,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultAvatar(context),
        ),
      );
    }
    return _defaultAvatar(context);
  }

  Widget _defaultAvatar(BuildContext context) {
    final initial =
        tenant.tenantName.isNotEmpty ? tenant.tenantName[0].toUpperCase() : '?';
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PersonalSpaceItem extends StatelessWidget {
  final VoidCallback onTap;

  const _PersonalSpaceItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.person_outline,
                  color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).authPersonalSpace,
                      style: AppTextStyles.body.copyWith(
                        color: colorScheme.onSurface,
                      )),
                  const SizedBox(height: 2),
                  Text(AppLocalizations.of(context).authPersonalSpaceSubtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      )),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: colorScheme.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

String _tenantRoleLabel(AppLocalizations l10n, int membershipRole) {
  return switch (membershipRole) {
    4 => l10n.authRoleOwner,
    3 => l10n.authRoleAdministrator,
    2 => l10n.authRoleCustomerService,
    1 => l10n.authRoleTechnicalSupport,
    _ => l10n.authRoleMember,
  };
}
