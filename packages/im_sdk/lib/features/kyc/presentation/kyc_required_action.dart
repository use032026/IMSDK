import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

bool showKycRequiredAction(BuildContext context, Object error) {
  final normalized =
      error is DioException ? ErrorHandler.fromDioException(error) : error;
  if (normalized is! ServerError || normalized.code != 'KYC_REQUIRED') {
    return false;
  }
  final l10n = AppLocalizations.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
          normalized.message.isEmpty ? l10n.kycRequired : normalized.message),
      action: SnackBarAction(
        label: l10n.kycGoVerify,
        onPressed: () => context.push('/settings/kyc'),
      ),
    ),
  );
  return true;
}
