import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:im_sdk/features/official_account/application/official_account_connection_service.dart';
import 'package:im_sdk/features/teen_mode/presentation/providers/teen_mode_providers.dart';

final officialAccountConnectionProvider =
    Provider<OfficialAccountConnectionService>((ref) {
  final auth = ref.read(authProvider.notifier);
  final contacts = ref.read(contactsRepositoryProvider);
  return OfficialAccountConnectionService(
    readActor: () {
      final state = auth.snapshot;
      final space = state?.currentSpace;
      final session =
          state == null ? null : activeAccountSessionFromAuthState(state);
      if (state?.status != AuthStatus.authenticated ||
          state?.platformUserId == null ||
          space == null ||
          session == null) {
        return null;
      }
      return (
        accountId: state!.platformUserId!,
        spaceId: space.spaceId,
        userId: space.userId,
        sessionId: session.sessionId,
      );
    },
    canAddFriend: () => ref.read(teenModePolicyProvider).canAttemptAddFriend,
    addFriend: (userId, token) => token == null
        ? contacts.sendFriendRequest(userId)
        : contacts.acceptFriendInviteQr(token),
    refreshDirectory: auth.refreshTenants,
    isTenantAuthorized: (tenantId) =>
        auth.snapshot?.availableTenants
            .any((tenant) => tenant.tenantId == tenantId) ==
        true,
    activateTenant: auth.selectTenantForOfficialConversation,
  );
}, dependencies: [contactsRepositoryProvider, teenModePolicyProvider]);
