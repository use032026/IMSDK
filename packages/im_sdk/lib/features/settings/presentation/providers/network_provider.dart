import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/network/site_line_manager.dart';
import 'package:im_sdk/core/network/site_line_selection.dart';
import 'package:im_sdk/core/storage/secure_storage.dart';

class NetworkState {
  final AppSiteLine currentSite;
  final List<AppSiteLine> switchableSites;
  final bool isRefreshing;
  final bool isSwitching;

  const NetworkState({
    this.currentSite = AppSiteLine.primary,
    this.switchableSites = const [AppSiteLine.primary],
    this.isRefreshing = false,
    this.isSwitching = false,
  });

  /// Kept for older call sites that still expect a mode.
  String get mode => 'direct';

  /// Kept for older call sites that still expect a route code.
  String get route => currentSite.id;

  String get displayLabel => currentSite.name;

  NetworkState copyWith({
    AppSiteLine? currentSite,
    List<AppSiteLine>? switchableSites,
    bool? isRefreshing,
    bool? isSwitching,
  }) {
    return NetworkState(
      currentSite: currentSite ?? this.currentSite,
      switchableSites: switchableSites ?? this.switchableSites,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSwitching: isSwitching ?? this.isSwitching,
    );
  }
}

class NetworkNotifier extends StateNotifier<NetworkState> {
  final SecureStorageService _storage;
  final SiteLineManager _manager;

  NetworkNotifier(this._storage, this._manager)
      : super(NetworkState(
          currentSite: _manager.currentSite,
          switchableSites: _manager.switcherSites,
        )) {
    _manager.addListener(_syncFromManager);
  }

  @override
  void dispose() {
    _manager.removeListener(_syncFromManager);
    super.dispose();
  }

  void _syncFromManager() {
    state = state.copyWith(
      currentSite: _manager.currentSite,
      switchableSites: _manager.switcherSites,
    );
  }

  Future<bool> refreshLines() async {
    state = state.copyWith(isRefreshing: true);
    try {
      final result = await _manager.bootstrap(_storage);
      return result.refreshedConfig;
    } catch (_) {
      return false;
    } finally {
      state = state.copyWith(
        currentSite: _manager.currentSite,
        switchableSites: _manager.switcherSites,
        isRefreshing: false,
      );
    }
  }

  Future<bool> selectSite(AppSiteLine site) async {
    if (state.isSwitching) return false;
    state = state.copyWith(isSwitching: true);
    try {
      await _manager.selectSite(site);
      return true;
    } catch (_) {
      return false;
    } finally {
      state = state.copyWith(isSwitching: false);
    }
  }

  Future<SiteLineProbeResult> probeSite(AppSiteLine site) =>
      _manager.probeSite(site);

  /// Compatibility for old direct/proxy UI actions. The new product model has
  /// one switchable site list, so mode changes no longer alter route groups.
  Future<void> setMode(String mode) async {}

  Future<void> setRoute(String route) async {
    final site = state.switchableSites
        .where((candidate) => candidate.id == route)
        .firstOrNull;
    if (site != null) {
      await selectSite(site);
    }
  }
}

final networkProvider =
    StateNotifierProvider<NetworkNotifier, NetworkState>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return NetworkNotifier(storage, SiteLineManager.instance);
});
