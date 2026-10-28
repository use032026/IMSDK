import 'dart:async';

import 'im_sdk_models.dart';

/// A host identity and one login incarnation. Neither value is a login token.
/// The host must change [sessionId] on logout followed by another login, even
/// when the user is unchanged. A null snapshot means the host has signed out.
class ImSdkHostSession {
  const ImSdkHostSession({
    required this.hostUserId,
    required this.sessionId,
  });

  final String hostUserId;
  final String sessionId;

  void validate() {
    if (hostUserId.trim().isEmpty || sessionId.trim().isEmpty) {
      throw const ImSdkException('INVALID_HOST_SESSION', '宿主登录状态无效');
    }
  }

  Map<String, Object?> toMap() => {
        'hostUserId': hostUserId,
        'sessionId': sessionId,
      };

  factory ImSdkHostSession.fromMap(Map<String, dynamic> value) {
    final user = value['hostUserId'];
    final session = value['sessionId'];
    if (user is! String || session is! String) {
      throw const ImSdkException('INVALID_HOST_SESSION', '宿主登录状态无效');
    }
    final result = ImSdkHostSession(hostUserId: user, sessionId: session);
    result.validate();
    return result;
  }

  @override
  bool operator ==(Object other) =>
      other is ImSdkHostSession &&
      hostUserId == other.hostUserId &&
      sessionId == other.sessionId;

  @override
  int get hashCode => Object.hash(hostUserId, sessionId);

  @override
  String toString() => 'ImSdkHostSession(<redacted>)';
}

/// Bridges an app's existing login session to IM credentials issued by its
/// trusted backend. A failed query must throw; it must not return null unless
/// the host has actually signed out. No account mapping is inferred locally.
abstract class ImSdkHostSessionProvider {
  Future<ImSdkHostSession?> readSession();

  Future<ImSdkCredentials> fetchCredentials(ImSdkHostSession session);

  /// Emit immediately when host login, logout, or account switching occurs.
  /// Hosts without a stream call client.notifyHostSessionChanged() instead.
  Stream<void> get changes => const Stream<void>.empty();
}
