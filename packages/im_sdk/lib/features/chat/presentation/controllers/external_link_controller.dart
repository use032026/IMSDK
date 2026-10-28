import 'package:im_sdk/features/chat/domain/services/link_message_policy.dart';
import 'package:url_launcher/url_launcher.dart';

typedef ExternalUrlLauncher = Future<bool> Function(
  Uri uri,
  LaunchMode mode,
);

class ExternalLinkController {
  final ExternalUrlLauncher _launcher;

  ExternalLinkController({
    ExternalUrlLauncher? launcher,
  }) : _launcher = launcher ??
            ((uri, mode) => launchUrl(
                  uri,
                  mode: mode,
                ));

  Future<bool> open(String url) async {
    final uri = LinkMessagePolicy.tryParseStandaloneUrl(url);
    if (uri == null) return false;
    try {
      return await _launcher(uri, LaunchMode.inAppBrowserView);
    } catch (_) {
      return false;
    }
  }
}
