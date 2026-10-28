import 'package:flutter/material.dart';
import 'package:im_sdk/features/settings/presentation/pages/legal_document_page.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({this.showOfficialLink = true, super.key});

  final bool showOfficialLink;

  @override
  Widget build(BuildContext context) {
    final platform = legalPlatformForTargetPlatform(Theme.of(context).platform);
    final locale = Localizations.localeOf(context);
    return LegalDocumentScaffold(
      document: termsLegalDocumentForPlatform(platform),
      officialUri: showOfficialLink
          ? termsOfficialUriForPlatform(platform, locale)
          : null,
    );
  }
}
