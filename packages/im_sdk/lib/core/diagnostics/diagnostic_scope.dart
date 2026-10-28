import 'package:im_sdk/core/space/account_scope.dart';

/// Uses the existing account identity; diagnostics never creates an auth owner.
class DiagnosticScope {
  const DiagnosticScope(this.accountHash, this.storageHash);

  factory DiagnosticScope.account(AccountScope scope) =>
      DiagnosticScope(scope.platformAccountHash, scope.storageKeyHash);

  static const public = DiagnosticScope('public', 'public');
  static const unattributed = DiagnosticScope('unattributed', 'unattributed');

  final String accountHash;
  final String storageHash;

  bool get isAttributed => storageHash != 'unattributed';
  bool includes(DiagnosticScope other) =>
      other == public || (isAttributed && this == other);

  Map<String, Object?> toJson() => {
        'accountHash': accountHash,
        'storageHash': storageHash,
      };

  @override
  bool operator ==(Object other) =>
      other is DiagnosticScope &&
      other.accountHash == accountHash &&
      other.storageHash == storageHash;
  @override
  int get hashCode => Object.hash(accountHash, storageHash);
}
