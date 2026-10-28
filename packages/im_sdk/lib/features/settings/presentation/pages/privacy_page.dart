import 'package:flutter/material.dart';
import 'package:im_sdk/features/settings/presentation/pages/legal_document_page.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({this.showOfficialLink = true, super.key});

  final bool showOfficialLink;

  @override
  Widget build(BuildContext context) {
    final platform = legalPlatformForTargetPlatform(Theme.of(context).platform);
    final locale = Localizations.localeOf(context);
    return LegalDocumentScaffold(
      document: privacyLegalDocumentForPlatform(platform),
      officialUri: showOfficialLink
          ? privacyOfficialUriForPlatform(platform, locale)
          : null,
    );
  }
}
