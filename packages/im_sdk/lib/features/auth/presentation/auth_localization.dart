import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

const _localizedAuthErrorCode = <String>{
  'AUTH_INVALID_CREDENTIALS',
  'AUTH_INVALID_TOKEN',
  'AUTH_CAPTCHA_REQUIRED',
  'AUTH_VERIFICATION_REQUIRED',
  'AUTH_EMAIL_EXISTS',
  'AUTH_MOBILE_EXISTS',
  'VERIFY_TOO_FREQUENT',
  'VERIFY_HOURLY_LIMIT',
  'VERIFY_DAILY_LIMIT',
  'TENANT_NOT_MEMBER',
  'TENANT_SUSPENDED',
  'RATE_LIMITED',
};

String authPresentationFailureMessage(
  AppLocalizations l10n,
  AuthPresentationFailure failure,
) {
  return switch (failure) {
    AuthPresentationFailure.spaceIdentityValidation =>
      l10n.authSpaceIdentityValidationFailed,
    AuthPresentationFailure.personalSpaceRestore =>
      l10n.authPersonalSpaceRestoreFailed,
    AuthPresentationFailure.joinEnterprise => l10n.authJoinEnterpriseFailed,
    AuthPresentationFailure.tenantDirectory => l10n.startupFailureMessage,
    AuthPresentationFailure.spaceSwitch => l10n.commonNetworkError,
  };
}

String authExceptionMessage(
  AppLocalizations l10n,
  Object error, {
  required String fallback,
}) {
  if (error is NetworkError) return l10n.commonNetworkError;
  if (error is AuthError) return ErrorHandler.localizedMessage(error, l10n);
  if (error is ServerError) {
    switch (error.code) {
      case 'REGISTER_EMPTY_RESPONSE':
        return l10n.authRegisterFailed;
      case 'AUTH_STABLE_IDENTITY_MISSING':
        return l10n.authSpaceIdentityValidationFailed;
      case 'TENANT_NOT_FOUND':
        return l10n.authNoOrganization;
    }
    if (_localizedAuthErrorCode.contains(error.code)) {
      return ErrorHandler.localizedMessage(error, l10n);
    }
  }
  return fallback;
}
