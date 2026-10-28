import 'package:flutter/foundation.dart';
import 'package:im_sdk/core/network/service_realm_config.dart';

@immutable
class AccountOperationContext {
  const AccountOperationContext({
    required this.accountScopeKey,
    required this.identityRevision,
    required this.sessionId,
  });

  final String accountScopeKey;
  final int identityRevision;
  final String sessionId;
}

@immutable
class NetworkOperationContext {
  const NetworkOperationContext({
    required this.account,
    required this.connectionRevision,
  });

  final AccountOperationContext account;
  final int connectionRevision;
}

class AccountOperationSuperseded implements Exception {}

class AccountOperationGuard {
  AccountOperationGuard(this.current);

  final AccountOperationContext current;

  void verify(AccountOperationContext context) {
    if (context.accountScopeKey != current.accountScopeKey ||
        context.identityRevision != current.identityRevision ||
        context.sessionId != current.sessionId) {
      throw AccountOperationSuperseded();
    }
  }

  bool accepts(AccountOperationContext context) {
    try {
      verify(context);
      return true;
    } on AccountOperationSuperseded {
      return false;
    }
  }
}

class NetworkOperationSuperseded implements Exception {}

class UntrustedServiceOrigin implements Exception {}

class NetworkOperationGuard {
  NetworkOperationGuard({
    required AccountOperationContext currentAccount,
    required this.currentConnectionRevision,
    required this.serviceRealm,
  }) : _accountGuard = AccountOperationGuard(currentAccount);

  final AccountOperationGuard _accountGuard;
  final int currentConnectionRevision;
  final ServiceRealmConfig serviceRealm;

  void verify(NetworkOperationContext context, {required String endpoint}) {
    _accountGuard.verify(context.account);
    if (context.connectionRevision != currentConnectionRevision) {
      throw NetworkOperationSuperseded();
    }
    if (!serviceRealm.trusts(endpoint)) throw UntrustedServiceOrigin();
  }
}
