import 'dart:io' show Platform;

const mobileAppUpdateAppKey = 'user';

const Set<String> _androidReleaseFaceChannels = {'vivo', 'oppo'};

/// Android store-channel identifier for the anonymous release-face endpoint.
///
/// Android audit channels and `ios` participate in release-face lookups. Other
/// channels deliberately retain existing product behavior without a request.
const mobileAppReleaseChannel = String.fromEnvironment(
  'APP_RELEASE_CHANNEL',
  defaultValue: '',
);

String normalizeMobileAppReleaseChannel(String value) =>
    value.trim().toLowerCase();

String get normalizedMobileAppReleaseChannel =>
    normalizeMobileAppReleaseChannel(mobileAppReleaseChannel);

bool shouldFetchReleaseFaceForChannel(String value) {
  final channel = normalizeMobileAppReleaseChannel(value);
  return _androidReleaseFaceChannels.contains(channel) || channel == 'ios';
}

bool shouldFetchMobileReleaseFace() =>
    shouldFetchReleaseFaceForChannel(mobileAppReleaseChannel);

/// Android audit channels consume the A/B result. iOS is fetched for backend
/// verification only until it has its own product rule.
bool shouldApplyReleaseFaceForChannel({
  required String channel,
  required bool isAndroid,
}) =>
    isAndroid &&
    _androidReleaseFaceChannels.contains(
      normalizeMobileAppReleaseChannel(channel),
    );

bool shouldApplyMobileReleaseFace() => shouldApplyReleaseFaceForChannel(
      channel: mobileAppReleaseChannel,
      isAndroid: Platform.isAndroid,
    );

String currentMobileUpdatePlatform() {
  if (Platform.isIOS) return 'ios';
  return 'android';
}

bool shouldEnableMobileAppUpdatesForPlatform({
  required String platform,
  String channel = mobileAppReleaseChannel,
}) {
  return platform.trim().toLowerCase() != 'android' ||
      normalizeMobileAppReleaseChannel(channel) != 'google';
}

bool shouldEnableMobileAppUpdates() =>
    shouldEnableMobileAppUpdatesForPlatform(
      platform: currentMobileUpdatePlatform(),
    );

Uri resolveAppUpdateUrl({
  required String baseUrl,
  required String downloadUrl,
}) {
  final uri = Uri.parse(downloadUrl);
  if (uri.hasScheme) return uri;
  return Uri.parse(baseUrl).resolve(downloadUrl);
}
