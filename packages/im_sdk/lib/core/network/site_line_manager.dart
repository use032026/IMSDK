import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/network/site_line_config.dart';
import 'package:im_sdk/core/network/site_line_config_fetcher.dart';
import 'package:im_sdk/core/network/site_line_project_config.dart';
import 'package:im_sdk/core/network/site_line_selection.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';

const String kPrimarySiteId = 'main-1';
const String kPrimarySiteName = '主站1';
const String kPrimarySiteBaseUrl = String.fromEnvironment(
  'GJB_API_BASE_URL',
  defaultValue: 'https://chat.hearteasechat.com',
);

const String _kCurrentSiteIdKey = 'site_line_current_site_id_v1';
const String _kVerifiedConfigKey = 'site_line_verified_config_v1';
const String _kSelectionKey = 'site_line_selection_v2';

@immutable
class AppSiteLine {
  final String id;
  final String name;
  final String apiBaseUrl;
  final String? adminBaseUrl;
  final String? gatewayBaseUrl;
  final String? configFileUrl;
  final String type;
  final double weight;
  final bool isPrimary;

  const AppSiteLine({
    required this.id,
    required this.name,
    required this.apiBaseUrl,
    this.adminBaseUrl,
    this.gatewayBaseUrl,
    this.configFileUrl,
    this.type = '',
    this.weight = 1,
    this.isPrimary = false,
  });

  static const primary = AppSiteLine(
    id: kPrimarySiteId,
    name: kPrimarySiteName,
    apiBaseUrl: kPrimarySiteBaseUrl,
    isPrimary: true,
  );

  factory AppSiteLine.fromVerified(VerifiedSiteLine line) => AppSiteLine(
        id: line.id,
        name: line.displayName,
        apiBaseUrl: line.chat,
        adminBaseUrl: line.admin,
        gatewayBaseUrl: line.ws,
        configFileUrl: line.configfile,
        type: line.type,
        weight: line.weight,
      );

  String get effectiveAdminBaseUrl {
    if (adminBaseUrl != null) return adminBaseUrl!;
    final uri = Uri.parse(apiBaseUrl);
    final host = uri.host.startsWith('chat.')
        ? uri.host.replaceFirst('chat.', 'admin.')
        : uri.host;
    return uri.replace(host: host).toString().replaceFirst(RegExp(r'/$'), '');
  }

  /// SignalR negotiates over HTTP(S) before upgrading to WebSocket.
  String get effectiveGatewayBaseUrl {
    final raw = gatewayBaseUrl ?? apiBaseUrl;
    final uri = Uri.parse(raw);
    final scheme = uri.scheme == 'wss' ? 'https' : uri.scheme;
    return uri
        .replace(scheme: scheme)
        .toString()
        .replaceFirst(RegExp(r'/$'), '');
  }

  bool sameRouteAs(AppSiteLine other) =>
      id == other.id &&
      apiBaseUrl == other.apiBaseUrl &&
      effectiveAdminBaseUrl == other.effectiveAdminBaseUrl &&
      effectiveGatewayBaseUrl == other.effectiveGatewayBaseUrl;
}

@immutable
class SiteLineBootstrapResult {
  final AppSiteLine currentSite;
  final List<AppSiteLine> switchableSites;
  final bool refreshedConfig;
  final String? selectedFromConfigFile;
  final int? configVersion;

  const SiteLineBootstrapResult({
    required this.currentSite,
    required this.switchableSites,
    required this.refreshedConfig,
    this.selectedFromConfigFile,
    this.configVersion,
  });
}

class SiteLineUnavailable implements Exception {
  const SiteLineUnavailable();
}

class SiteLineManager extends ChangeNotifier {
  SiteLineManager._()
      : _fetcher = const SiteLineConfigFetcher(
          codec: SiteLineConfigCodec(
            aesKey: SiteLineProjectConfig.aesKey,
            publicKeyPem: SiteLineProjectConfig.publicKeyPem,
            requiredAlgorithm: SiteLineProjectConfig.signatureAlgorithm,
          ),
        );

  @visibleForTesting
  SiteLineManager.forTesting(this._fetcher);

  static final SiteLineManager instance = SiteLineManager._();

  final SiteLineConfigFetcher _fetcher;
  SecureStorageService? _storage;
  AppSiteLine _currentSite = AppSiteLine.primary;
  List<AppSiteLine> _switchableSites = const [];
  VerifiedSiteLineConfig? _verifiedConfig;
  String? _manualId;
  bool _initialized = false;
  int _routeRevision = 0;
  Future<SiteLineBootstrapResult>? _bootstrapFuture;
  Future<void> _operationTail = Future<void>.value();

  AppSiteLine get currentSite => _currentSite;
  String get apiBaseUrl => _currentSite.apiBaseUrl;
  String get adminBaseUrl => _currentSite.effectiveAdminBaseUrl;
  String get gatewayBaseUrl => _currentSite.effectiveGatewayBaseUrl;
  int get routeRevision => _routeRevision;

  /// Uses the host route without fetching the standalone App's route config.
  void configureForSdk({required String apiBaseUrl, String? gatewayBaseUrl}) {
    _storage = null;
    _switchableSites = const [];
    _verifiedConfig = null;
    _manualId = null;
    _initialized = true;
    _publishRoute(AppSiteLine(
        id: 'sdk',
        name: 'SDK',
        apiBaseUrl: apiBaseUrl,
        adminBaseUrl: apiBaseUrl,
        gatewayBaseUrl: gatewayBaseUrl,
        isPrimary: true));
  }

  bool get initialized => _initialized;
  int? get configVersion => _verifiedConfig?.version;
  List<AppSiteLine> get switcherSites =>
      List.unmodifiable([AppSiteLine.primary, ..._switchableSites]);

  /// Restores only the previously verified local route. Network refresh is
  /// intentionally separate so a slow config source cannot delay app entry.
  Future<void> restoreCachedRoute(SecureStorageService storage) =>
      _enqueue(() => _restoreCachedRoute(storage));

  Future<SiteLineBootstrapResult> bootstrap(SecureStorageService storage) {
    return _bootstrapFuture ??=
        _enqueue(() => _bootstrap(storage)).whenComplete(() {
      _bootstrapFuture = null;
    });
  }

  Future<T> _enqueue<T>(Future<T> Function() operation) {
    final next = _operationTail.then((_) => operation());
    _operationTail =
        next.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return next;
  }

  Future<SiteLineBootstrapResult> _bootstrap(
      SecureStorageService storage) async {
    await _restoreCachedRoute(storage);

    final urls = configFetchCandidates(
      currentSite: _currentSite,
      cachedSwitchableSites: _switchableSites,
    );
    final loaded = await _fetcher.race(
      urls,
      minimumVersion: _verifiedConfig?.version,
    );
    if (loaded != null) {
      AppDiagnostics.instance.info(
        'site_line.config_loaded',
        'Verified site lines fetched',
        context: {
          'sourceUrl': _diagnosticUrl(loaded.url),
          'version': loaded.config.version,
          'lineCount': loaded.config.lines.length,
          'lines': [
            for (final line in loaded.config.lines)
              {
                'id': line.id,
                'name': line.displayName,
                'nameEn': line.displayNameEn,
                'type': line.type,
                'weight': line.weight,
                'chat': _diagnosticUrl(line.chat),
                'ws': _diagnosticUrl(line.ws),
                'admin': _diagnosticUrl(line.admin),
                'configfile': _diagnosticUrl(line.configfile),
              },
          ],
        },
      );
    }

    final candidates = loaded == null
        ? _switchableSites
        : List<AppSiteLine>.unmodifiable(loaded.config.lines
            .where((line) => line.id != kPrimarySiteId)
            .map(AppSiteLine.fromVerified));
    final selection = await _selectAutomatically(
      candidates,
      minimumVersion: loaded?.config.version,
      probeCandidatesForConfig: loaded != null,
    );
    final selected = selection.selected;
    final acceptedConfig =
        loaded != null && selected != null && selection.hasAvailableCandidate;
    if (selected != null && !selected.sameRouteAs(_currentSite)) {
      await _persistSelection(storage, selected.id, _manualId);
    }
    if (loaded != null && acceptedConfig) {
      // Keep the last working signed manifest until a route from the new one
      // passes its own configfile probe. A failed same-ID update must not
      // replace the endpoint restored on the next launch.
      await storage.write(_kVerifiedConfigKey, loaded.config.encryptedBody);
      _installConfig(loaded.config);
    }
    if (selected != null && !selected.sameRouteAs(_currentSite)) {
      _publishRoute(selected);
    }
    return SiteLineBootstrapResult(
      currentSite: _currentSite,
      switchableSites: switcherSites,
      refreshedConfig: acceptedConfig,
      selectedFromConfigFile: acceptedConfig ? loaded.url : null,
      configVersion: _verifiedConfig?.version,
    );
  }

  Future<void> _restoreCachedRoute(SecureStorageService storage) async {
    _storage = storage;
    if (_initialized) return;
    final saved = await _readSelection(storage);
    _manualId = saved.manualId;
    final cached = await _readVerifiedCache(storage);
    if (cached != null) {
      _installConfig(cached);
      final restored = _siteById(saved.currentId);
      if (restored != null) _publishRoute(restored);
    }
    _initialized = true;
  }

  Future<void> selectSite(AppSiteLine requested) =>
      _enqueue(() => _selectSite(requested));

  Future<void> _selectSite(AppSiteLine requested) async {
    final storage = _storage;
    if (storage == null) {
      throw StateError('Site line manager is not initialized');
    }
    final site = _siteById(requested.id);
    if (site == null) throw const SiteLineUnavailable();
    final result = await probeSite(site);
    if (!result.available) throw const SiteLineUnavailable();
    await _persistSelection(storage, site.id, site.id);
    _manualId = site.id;
    _publishRoute(site);
  }

  Future<SiteLineProbeResult> probeSite(
    AppSiteLine site, {
    int? minimumVersion,
  }) async {
    final watch = Stopwatch()..start();
    final cachedVersion = _verifiedConfig?.version;
    final requiredVersion = minimumVersion != null &&
            (cachedVersion == null || minimumVersion > cachedVersion)
        ? minimumVersion
        : cachedVersion;
    if (site.isPrimary && site.configFileUrl == null) {
      _logProbe(site,
          available: true,
          reason: 'primary_fallback_unverified',
          expectedVersion: requiredVersion);
      return const SiteLineProbeResult(available: true);
    }
    final url = site.configFileUrl;
    if (url == null) {
      _logProbe(site,
          available: false,
          reason: 'missing_configfile',
          expectedVersion: requiredVersion);
      return const SiteLineProbeResult(available: false);
    }
    try {
      final config =
          await _fetcher.fetch(url, timeout: const Duration(seconds: 4));
      final versionAccepted = requiredVersion == null ||
          (config.version != null && config.version! >= requiredVersion);
      final endpointMatches = config.lines.any((line) =>
          line.id == site.id &&
          line.chat == site.apiBaseUrl &&
          line.admin == site.adminBaseUrl &&
          line.ws == site.gatewayBaseUrl);
      final matches = versionAccepted && endpointMatches;
      _logProbe(
        site,
        available: matches,
        reason: !versionAccepted
            ? 'stale_version'
            : endpointMatches
                ? 'manifest_match'
                : 'endpoint_mismatch',
        durationMs: watch.elapsedMilliseconds,
        returnedVersion: config.version,
        expectedVersion: requiredVersion,
      );
      return SiteLineProbeResult(
        available: matches,
        latencyMs: matches ? watch.elapsedMilliseconds : null,
      );
    } on SiteLineConfigException catch (error) {
      _logProbe(site,
          available: false,
          reason: error.code,
          durationMs: watch.elapsedMilliseconds,
          expectedVersion: requiredVersion);
      return const SiteLineProbeResult(available: false);
    } catch (error) {
      _logProbe(site,
          available: false,
          reason: 'unexpected_error',
          durationMs: watch.elapsedMilliseconds,
          expectedVersion: requiredVersion,
          errorType: error.runtimeType.toString());
      return const SiteLineProbeResult(available: false);
    }
  }

  void _logProbe(
    AppSiteLine site, {
    required bool available,
    required String reason,
    int? durationMs,
    int? returnedVersion,
    int? expectedVersion,
    String? errorType,
  }) {
    AppDiagnostics.instance.info(
      'site_line.probe',
      'Site line configfile probe completed',
      context: {
        'siteId': site.id,
        'siteName': site.name,
        'configfile': site.configFileUrl == null
            ? null
            : _diagnosticUrl(site.configFileUrl!),
        'available': available,
        'reason': reason,
        if (durationMs != null) 'durationMs': durationMs,
        if (returnedVersion != null) 'returnedVersion': returnedVersion,
        if (expectedVersion != null) 'expectedVersion': expectedVersion,
        if (errorType != null) 'errorType': errorType,
      },
    );
  }

  Future<({AppSiteLine? selected, bool hasAvailableCandidate})>
      _selectAutomatically(
    List<AppSiteLine> sites, {
    int? minimumVersion,
    required bool probeCandidatesForConfig,
  }) async {
    if (_manualId == kPrimarySiteId && !probeCandidatesForConfig) {
      return (selected: AppSiteLine.primary, hasAvailableCandidate: false);
    }
    if (sites.isEmpty) {
      return (
        selected: _currentSite.isPrimary ? AppSiteLine.primary : null,
        hasAvailableCandidate: false,
      );
    }
    final results = await Future.wait(
      sites.map((site) => probeSite(site, minimumVersion: minimumVersion)),
    );
    final hasAvailableCandidate = results.any((result) => result.available);
    if (_manualId == kPrimarySiteId) {
      return (
        selected: AppSiteLine.primary,
        hasAvailableCandidate: hasAvailableCandidate,
      );
    }
    final probes = <String, SiteLineProbeResult>{};
    for (var i = 0; i < sites.length; i++) {
      probes[sites[i].id] = results[i];
    }
    final selectedId = chooseSiteLine(
      sites.map((site) => SiteLineCandidate(site.id, site.weight)).toList(),
      probes,
      manualId: _manualId,
      currentId: _currentSite.id,
    );
    if (selectedId == null) {
      return (
        selected: _currentSite.isPrimary ? AppSiteLine.primary : null,
        hasAvailableCandidate: false,
      );
    }
    for (final site in sites) {
      if (site.id == selectedId) {
        return (selected: site, hasAvailableCandidate: hasAvailableCandidate);
      }
    }
    return (selected: null, hasAvailableCandidate: hasAvailableCandidate);
  }

  void _installConfig(VerifiedSiteLineConfig config) {
    _verifiedConfig = config;
    _switchableSites = List.unmodifiable(config.lines
        .where((line) => line.id != kPrimarySiteId)
        .map(AppSiteLine.fromVerified));
    notifyListeners();
  }

  void _publishRoute(AppSiteLine site) {
    if (!site.sameRouteAs(_currentSite)) {
      _currentSite = site;
      _routeRevision += 1;
    }
    notifyListeners();
  }

  AppSiteLine? _siteById(String? id) {
    if (id == null) return null;
    if (id == kPrimarySiteId) return AppSiteLine.primary;
    for (final site in _switchableSites) {
      if (site.id == id) return site;
    }
    return null;
  }

  static List<String> configFetchCandidates({
    required AppSiteLine currentSite,
    required List<AppSiteLine> cachedSwitchableSites,
  }) {
    final urls = <String>[];
    void add(String? url) {
      if (url != null && url.isNotEmpty && !urls.contains(url)) urls.add(url);
    }

    add(currentSite.configFileUrl);
    for (final site in cachedSwitchableSites
        .where((item) => item.id != currentSite.id)
        .take(2)) {
      add(site.configFileUrl);
    }
    for (final url in SiteLineProjectConfig.seedUrls) {
      add(url);
    }
    for (final url in SiteLineProjectConfig.globalUrls) {
      add(url);
    }
    return urls.take(8).toList();
  }

  Future<VerifiedSiteLineConfig?> _readVerifiedCache(
      SecureStorageService storage) async {
    final encrypted = await storage.read(_kVerifiedConfigKey);
    if (encrypted == null || encrypted.isEmpty) return null;
    try {
      return _fetcher.codec.decode(encrypted);
    } catch (_) {
      return null;
    }
  }

  Future<({String? currentId, String? manualId})> _readSelection(
      SecureStorageService storage) async {
    final raw = await storage.read(_kSelectionKey);
    if (raw != null) {
      try {
        final data = Map<String, dynamic>.from(jsonDecode(raw) as Map);
        return (
          currentId: data['currentId'] as String?,
          manualId: data['manualId'] as String?,
        );
      } catch (_) {}
    }
    // v1 retained only the ID; never consume its unverified endpoint cache.
    final oldId = await storage.read(_kCurrentSiteIdKey);
    return (currentId: oldId, manualId: oldId == kPrimarySiteId ? null : oldId);
  }

  Future<void> _persistSelection(
    SecureStorageService storage,
    String currentId,
    String? manualId,
  ) =>
      storage.write(
          _kSelectionKey,
          jsonEncode({
            'currentId': currentId,
            'manualId': manualId,
          }));
}

String _diagnosticUrl(String raw) => raw.split(RegExp(r'[?#]')).first;
