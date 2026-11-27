import 'package:flutter/material.dart';
import 'package:im_sdk/l10n/app_localizations.dart';

class OfficialVerifiedName extends StatelessWidget {
  const OfficialVerifiedName({
    super.key,
    required this.name,
    required this.verified,
  });

  final Widget name;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    if (!verified) return name;
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: name),
        const SizedBox(width: 4),
        Icon(
          Icons.verified,
          size: 14,
          color: colors.primary,
          semanticLabel: l10n.officialAccountVerifiedBadge,
        ),
      ],
    );
  }
}
