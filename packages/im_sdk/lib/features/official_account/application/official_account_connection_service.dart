import 'package:im_sdk/features/contacts/domain/entities/contact.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_card.dart';

enum OfficialAccountConnectionFailure {
  unavailable,
  switched,
  teenMode,
  directory,
  activation
}

typedef OfficialAccountActor = ({
  String accountId,
  String spaceId,
  String userId,
  String sessionId
});

/// One application flow for search, contact cards, QR acceptance and the inbox.
/// Authentication keeps ownership of directory authorization and space changes.
class OfficialAccountConnectionService {
  OfficialAccountConnectionService({
    required this.readActor,
    required this.canAddFriend,
    required this.addFriend,
    required this.refreshDirectory,
    required this.isTenantAuthorized,
    required this.activateTenant,
  });

  final OfficialAccountActor? Function() readActor;
  final bool Function() canAddFriend;
  final Future<FriendRequestSubmission> Function(String userId, String? qrToken)
      addFriend;
  final Future<void> Function() refreshDirectory;
  final bool Function(String tenantId) isTenantAuthorized;
  final Future<void> Function(String tenantId) activateTenant;
  Future<OfficialAccountCard>? _pending;

  Future<OfficialAccountCard> open(
    OfficialAccountCard card, {
    String? qrToken,
    bool Function()? isActive,
  }) {
    // A second tap cannot add twice or start a competing space transition.
    if (_pending != null) throw OfficialAccountConnectionFailure.switched;
    final operation = _open(card, qrToken: qrToken, isActive: isActive);
    _pending = operation;
    return operation.whenComplete(() => _pending = null);
  }

  Future<OfficialAccountCard> _open(
    OfficialAccountCard initial, {
    String? qrToken,
    bool Function()? isActive,
  }) async {
    final actor = readActor();
    if (actor == null) throw OfficialAccountConnectionFailure.unavailable;
    void checkSource() {
      if (readActor() != actor || (isActive != null && !isActive())) {
        throw OfficialAccountConnectionFailure.switched;
      }
    }

    checkSource();
    var card = initial;
    if (!card.canOpenConversation) {
      if (!canAddFriend()) throw OfficialAccountConnectionFailure.teenMode;
      final result = await addFriend(card.officialUserId, qrToken);
      checkSource();
      final accepted = result.officialAccount;
      if (!result.becameFriends ||
          accepted == null ||
          !accepted.canOpenConversation ||
          accepted.tenantId != card.tenantId ||
          accepted.officialUserId != card.officialUserId) {
        throw OfficialAccountConnectionFailure.unavailable;
      }
      card = accepted;
    }

    if (!isTenantAuthorized(card.tenantId) || card.joined) {
      await refreshDirectory();
      checkSource();
    }
    if (!isTenantAuthorized(card.tenantId)) {
      throw OfficialAccountConnectionFailure.directory;
    }
    checkSource();
    if (actor.spaceId != card.tenantId) await activateTenant(card.tenantId);
    final target = readActor();
    if (target == null ||
        target.accountId != actor.accountId ||
        target.spaceId != card.tenantId ||
        (card.customerUserId != null && target.userId != card.customerUserId)) {
      throw OfficialAccountConnectionFailure.activation;
    }
    return card;
  }
}
