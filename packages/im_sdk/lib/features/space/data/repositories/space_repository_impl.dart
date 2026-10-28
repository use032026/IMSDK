import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/features/auth/domain/entities/auth_entities.dart';
import 'package:im_sdk/features/space/domain/entities/space_entity.dart';
import 'package:im_sdk/features/space/domain/repositories/space_repository.dart';

/// Maps the current authenticated account's space metadata for presentation.
///
/// Space switching and credential installation belong exclusively to
/// AuthNotifier. This repository must not recover a business context from
/// legacy space-only credentials.
class SpaceRepositoryImpl implements SpaceRepository {
  final SpaceContext? Function() _getCurrentSpace;
  final List<TenantSummary> Function() _getAvailableTenants;
  final bool Function() _hasPlatformSession;

  SpaceRepositoryImpl({
    required SpaceContext? Function() getCurrentSpace,
    required List<TenantSummary> Function() getAvailableTenants,
    required bool Function() hasPlatformSession,
  })  : _getCurrentSpace = getCurrentSpace,
        _getAvailableTenants = getAvailableTenants,
        _hasPlatformSession = hasPlatformSession;

  @override
  Future<List<Space>> getSpaces() async {
    final currentSpace = _getCurrentSpace();
    final activeSpaceId = currentSpace?.spaceId;
    final tenants = _getAvailableTenants();
    final spaces = <Space>[];
    // A tenant-only login has no platform credential with which to enter the
    // personal space. Do not render a dead navigation target for that flow.
    if (currentSpace == null ||
        currentSpace.isPersonal ||
        _hasPlatformSession()) {
      spaces.add(Space(
        spaceId: 'personal',
        name: '个人空间',
        logoUrl: null,
        type: SpaceType.personal,
        unreadCount: 0,
        conversationCount: 0,
        isActive: activeSpaceId == 'personal',
      ));
    }

    // Entries come from the authenticated account's verified directory:
    // `/my/tenants` for platform sessions, or the single tenant proven by a
    // successful tenant-only login. Never infer enterprise visibility from
    // legacy space-only credentials.
    for (final tenant in tenants) {
      spaces.add(
        Space(
          spaceId: tenant.tenantId,
          name: tenant.tenantName,
          logoUrl: tenant.logoUrl?.isNotEmpty == true ? tenant.logoUrl : null,
          type: SpaceType.employee,
          unreadCount: 0,
          conversationCount: 0,
          isActive: activeSpaceId == tenant.tenantId,
        ),
      );
    }

    return spaces;
  }
}
