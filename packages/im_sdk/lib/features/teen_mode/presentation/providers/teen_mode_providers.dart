import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/features/teen_mode/application/teen_mode_action_executor.dart';
import 'package:im_sdk/features/teen_mode/data/datasources/teen_mode_remote_data_source.dart';
import 'package:im_sdk/features/teen_mode/data/repositories/teen_mode_repository_impl.dart';
import 'package:im_sdk/features/teen_mode/domain/entities/teen_mode.dart';
import 'package:im_sdk/features/teen_mode/domain/repositories/teen_mode_repository.dart';
import 'package:im_sdk/features/teen_mode/domain/services/teen_mode_policy.dart';

final teenModeRepositoryProvider = Provider<TeenModeRepository>((ref) {
  return TeenModeRepositoryImpl(
    TeenModeRemoteDataSource(ref.watch(dioProvider)),
  );
}, dependencies: [dioProvider]);

final teenModeControllerProvider =
    AsyncNotifierProvider<TeenModeController, TeenModeState>(
  TeenModeController.new,
  dependencies: [teenModeRepositoryProvider],
);

final teenModePolicyProvider = Provider<TeenModePolicy>((ref) {
  return TeenModePolicy(ref.watch(teenModeControllerProvider).valueOrNull);
}, dependencies: [teenModeControllerProvider]);

final teenModeActionExecutorProvider = Provider<TeenModeActionExecutor>((ref) {
  return TeenModeActionExecutor(
    refreshProfile: () =>
        ref.read(teenModeControllerProvider.notifier).refresh(),
    refreshSession: () =>
        ref.read(teenModeControllerProvider.notifier).refreshSession(),
    invalidateRequests: () => ref.invalidate(teenRequestsControllerProvider),
    invalidateGuardian: () {
      ref.invalidate(guardianCenterControllerProvider);
      ref.invalidate(guardianMinorSnapshotProvider);
    },
  );
}, dependencies: [
  teenModeControllerProvider,
  teenRequestsControllerProvider,
  guardianCenterControllerProvider,
  guardianMinorSnapshotProvider,
]);

class TeenModeController extends AsyncNotifier<TeenModeState> {
  TeenModeRepository get _repository => ref.read(teenModeRepositoryProvider);
  int _profileGeneration = 0;
  int _sessionGeneration = 0;

  @override
  Future<TeenModeState> build() async {
    final config = await ref.watch(teenModeRepositoryProvider).getConfig();
    if (!config.enabled) {
      return TeenModeState(config: config, profile: null);
    }
    return TeenModeState(
      config: config,
      profile: await ref.read(teenModeRepositoryProvider).getMe(),
    );
  }

  Future<void> refresh() async {
    final generation = ++_profileGeneration;
    final sessionGeneration = ++_sessionGeneration;
    final previous = state.valueOrNull;
    state = const AsyncLoading<TeenModeState>().copyWithPrevious(state);
    try {
      final config = await _repository.getConfig();
      var profile = config.enabled ? await _repository.getMe() : null;
      if (generation != _profileGeneration) return;
      final latestProfile = state.valueOrNull?.profile;
      if (profile != null &&
          profile.active &&
          latestProfile != null &&
          latestProfile.active &&
          sessionGeneration != _sessionGeneration) {
        profile = profile.copyWith(session: latestProfile.session);
      }
      state = AsyncData(TeenModeState(config: config, profile: profile));
    } catch (error, stackTrace) {
      if (generation != _profileGeneration) return;
      state = AsyncError<TeenModeState>(error, stackTrace).copyWithPrevious(
        previous == null ? const AsyncLoading() : AsyncData(previous),
      );
      rethrow;
    }
  }

  Future<void> enable({
    required String passcode,
    required String timeZoneId,
  }) async {
    final generation = ++_profileGeneration;
    ++_sessionGeneration;
    final current = state.requireValue;
    final profile = await _repository.enable(
      passcode: passcode,
      timeZoneId: timeZoneId,
    );
    if (generation != _profileGeneration) return;
    state = AsyncData(TeenModeState(config: current.config, profile: profile));
  }

  Future<TeenModeDisableResult> disable(String passcode) async {
    final result = await _repository.disable(passcode);
    await refresh();
    return result;
  }

  Future<void> updatePasscode({
    String? currentPasscode,
    required String newPasscode,
  }) async {
    await _repository.updatePasscode(
      currentPasscode: currentPasscode,
      newPasscode: newPasscode,
    );
    await refresh();
  }

  Future<void> heartbeat() async {
    final current = state.valueOrNull;
    final profile = current?.profile;
    if (current?.config.enabled != true || profile?.active != true) return;
    final generation = ++_sessionGeneration;
    final session = await _repository.heartbeat(profile!.timeZoneId);
    if (generation != _sessionGeneration) return;
    final latest = state.valueOrNull;
    if (latest?.profile == null) return;
    state = AsyncData(
      TeenModeState(
        config: latest!.config,
        profile: latest.profile!.copyWith(session: session),
      ),
    );
  }

  Future<void> refreshSession() async {
    final current = state.valueOrNull;
    if (current?.profile?.active != true) return;
    final generation = ++_sessionGeneration;
    final session = await _repository.getSessionStatus();
    if (generation != _sessionGeneration) return;
    final latest = state.valueOrNull;
    if (latest?.profile == null) return;
    state = AsyncData(
      TeenModeState(
        config: latest!.config,
        profile: latest.profile!.copyWith(session: session),
      ),
    );
  }

  Future<TeenModeExtendRequestResult> requestExtension(int minutes) async {
    final result = await _repository.requestExtension(minutes);
    await refreshSession();
    return result;
  }
}

class GuardianCenterState {
  const GuardianCenterState({
    required this.links,
    required this.minors,
    required this.approvals,
  });

  final List<GuardianLink> links;
  final List<GuardianMinor> minors;
  final GuardianApprovalPage approvals;
}

final guardianCenterControllerProvider =
    AsyncNotifierProvider<GuardianCenterController, GuardianCenterState>(
  GuardianCenterController.new,
  dependencies: [teenModeRepositoryProvider, teenModeControllerProvider],
);

class GuardianCenterController extends AsyncNotifier<GuardianCenterState> {
  TeenModeRepository get _repository => ref.read(teenModeRepositoryProvider);
  bool _loadingMoreApprovals = false;

  @override
  Future<GuardianCenterState> build() async {
    final values = await Future.wait<Object>([
      ref.watch(teenModeRepositoryProvider).getLinks(),
      ref.read(teenModeRepositoryProvider).getMinors(),
      ref.read(teenModeRepositoryProvider).getApprovals(),
    ]);
    return GuardianCenterState(
      links: values[0] as List<GuardianLink>,
      minors: values[1] as List<GuardianMinor>,
      approvals: values[2] as GuardianApprovalPage,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<GuardianBindCode> createBindCode({
    required GuardianRole role,
    required String relation,
  }) =>
      _repository.createBindCode(role: role, relation: relation);

  Future<void> cancelBindCode(String tokenId) =>
      _repository.cancelBindCode(tokenId);

  Future<void> bind({required String code, required String relation}) async {
    await _repository.bind(code: code, relation: relation);
    await refresh();
    ref.invalidate(teenModeControllerProvider);
  }

  Future<GuardianUnbindResult> deleteLink(String linkId) async {
    final result = await _repository.deleteLink(linkId);
    await refresh();
    ref.invalidate(teenModeControllerProvider);
    return result;
  }

  Future<void> updateLink({
    required String linkId,
    required String relation,
    bool? isPrimary,
    bool? canApprove,
    bool? canManagePolicy,
  }) async {
    await _repository.updateLink(
      linkId: linkId,
      relation: relation,
      isPrimary: isPrimary,
      canApprove: canApprove,
      canManagePolicy: canManagePolicy,
    );
    await refresh();
    ref.invalidate(teenModeControllerProvider);
  }

  Future<void> extendMinor({
    required String minorPlatformUserId,
    required int minutes,
  }) async {
    await _repository.extendMinor(
      minorPlatformUserId: minorPlatformUserId,
      minutes: minutes,
    );
    await refresh();
  }

  Future<void> decide({
    required String requestId,
    required bool approve,
    String? note,
  }) async {
    await _repository.decideApproval(
      requestId: requestId,
      approve: approve,
      note: note,
    );
    await refresh();
  }

  Future<void> loadMoreApprovals() async {
    final current = state.valueOrNull;
    final cursor = current?.approvals.nextCursor;
    if (_loadingMoreApprovals ||
        current == null ||
        cursor == null ||
        cursor.isEmpty) {
      return;
    }
    _loadingMoreApprovals = true;
    try {
      final next = await _repository.getApprovals(cursor: cursor);
      final latest = state.valueOrNull;
      if (latest == null || latest.approvals.nextCursor != cursor) return;
      state = AsyncData(GuardianCenterState(
        links: latest.links,
        minors: latest.minors,
        approvals: _mergeApprovalPages(latest.approvals, next),
      ));
    } finally {
      _loadingMoreApprovals = false;
    }
  }
}

class GuardianMinorEditorState {
  const GuardianMinorEditorState({
    required this.minor,
    required this.catalog,
    required this.draft,
    required this.dirtyKeys,
    required this.catalogReady,
    required this.isSaving,
  });

  final GuardianMinor minor;
  final List<TeenPolicyCatalogItem> catalog;
  final TeenPolicy draft;
  final Set<String> dirtyKeys;
  final bool catalogReady;
  final bool isSaving;

  bool get hasEditablePolicies => catalog.any((item) =>
      item.isRenderable &&
      !item.locked &&
      minor.editablePolicyKeys.contains(item.key));

  bool get canSave =>
      catalogReady &&
      hasEditablePolicies &&
      minor.canManagePolicy &&
      dirtyKeys.isNotEmpty &&
      !isSaving;

  Object? valueFor(TeenPolicyCatalogItem item) =>
      draft[item.key] ?? item.defaultValue;

  GuardianMinorEditorState copyWith({
    GuardianMinor? minor,
    List<TeenPolicyCatalogItem>? catalog,
    TeenPolicy? draft,
    Set<String>? dirtyKeys,
    bool? catalogReady,
    bool? isSaving,
  }) =>
      GuardianMinorEditorState(
        minor: minor ?? this.minor,
        catalog: catalog ?? this.catalog,
        draft: draft ?? this.draft,
        dirtyKeys: dirtyKeys ?? this.dirtyKeys,
        catalogReady: catalogReady ?? this.catalogReady,
        isSaving: isSaving ?? this.isSaving,
      );
}

final guardianMinorSnapshotProvider =
    FutureProvider.family<GuardianMinor, String>((ref, minorPlatformUserId) {
  return ref.watch(teenModeRepositoryProvider).getMinor(minorPlatformUserId);
}, dependencies: [teenModeRepositoryProvider]);

final guardianMinorControllerProvider = AsyncNotifierProvider.family<
    GuardianMinorController, GuardianMinorEditorState, String>(
  GuardianMinorController.new,
  dependencies: [
    teenModeRepositoryProvider,
    teenModeControllerProvider,
    guardianMinorSnapshotProvider,
    guardianCenterControllerProvider,
  ],
);

class GuardianMinorController
    extends FamilyAsyncNotifier<GuardianMinorEditorState, String> {
  TeenModeRepository get _repository => ref.read(teenModeRepositoryProvider);
  Map<String, Object>? _draft;
  final Set<String> _dirtyKeys = {};

  @override
  Future<GuardianMinorEditorState> build(String arg) async {
    final teenState = await ref.watch(teenModeControllerProvider.future);
    if (!teenState.config.enabled) {
      throw StateError('teen mode policy catalog is unavailable');
    }
    final minor = await ref.watch(guardianMinorSnapshotProvider(arg).future);
    final catalog = teenState.config.policyCatalog
        .where((item) => item.isRenderable)
        .toList(growable: false);
    final allowedKeys = catalog.map((item) => item.key).toSet();
    final previousDraft = _draft;
    final reconciled = <String, Object>{};
    final resolver = TeenPolicyResolver(
      policy: minor.policy,
      catalog: catalog,
    );
    for (final item in catalog) {
      final value = resolver.value(item.key);
      if (value != null) reconciled[item.key] = value;
    }
    if (previousDraft != null) {
      for (final key in _dirtyKeys.toList(growable: false)) {
        if (!allowedKeys.contains(key) ||
            !minor.editablePolicyKeys.contains(key)) {
          _dirtyKeys.remove(key);
          continue;
        }
        final value = previousDraft[key];
        if (value != null) reconciled[key] = value;
      }
    }
    _draft = reconciled;
    return GuardianMinorEditorState(
      minor: minor,
      catalog: catalog,
      draft: Map.unmodifiable(reconciled),
      dirtyKeys: Set.unmodifiable(_dirtyKeys),
      catalogReady: true,
      isSaving: false,
    );
  }

  void setDraftValue(String key, Object value) {
    final current = state.valueOrNull;
    if (current == null || current.isSaving) return;
    final item = current.catalog.where((item) => item.key == key).firstOrNull;
    if (item == null ||
        item.locked ||
        !current.minor.canManagePolicy ||
        !current.minor.editablePolicyKeys.contains(key) ||
        !_valueMatches(item, value)) {
      return;
    }
    final next = Map<String, Object>.from(current.draft)..[key] = value;
    _draft = next;
    _dirtyKeys.add(key);
    state = AsyncData(current.copyWith(
      draft: Map.unmodifiable(next),
      dirtyKeys: Set.unmodifiable(_dirtyKeys),
    ));
  }

  Future<void> savePolicy() async {
    final current = state.requireValue;
    if (!current.canSave) return;
    final policy = <String, Object>{};
    for (final item in current.catalog) {
      if (item.locked || !current.minor.editablePolicyKeys.contains(item.key)) {
        continue;
      }
      final value = current.draft[item.key];
      if (value == null || !_valueMatches(item, value)) continue;
      policy[item.key] = _normalizedValue(item, value);
    }
    if (policy.isEmpty) return;
    state = AsyncData(current.copyWith(isSaving: true));
    try {
      final updated = await _repository.updateMinorPolicy(
        minorPlatformUserId: arg,
        policy: policy,
      );
      _dirtyKeys.clear();
      final nextDraft = <String, Object>{};
      final resolver = TeenPolicyResolver(
        policy: updated.policy,
        catalog: current.catalog,
      );
      for (final item in current.catalog) {
        final value = resolver.value(item.key);
        if (value != null) nextDraft[item.key] = value;
      }
      _draft = nextDraft;
      state = AsyncData(current.copyWith(
        minor: updated,
        draft: Map.unmodifiable(nextDraft),
        dirtyKeys: const <String>{},
        isSaving: false,
      ));
      ref.invalidate(guardianCenterControllerProvider);
    } catch (error) {
      state = AsyncData(current.copyWith(isSaving: false));
      rethrow;
    }
  }

  Future<void> refresh() async {
    ref.invalidate(guardianMinorSnapshotProvider(arg));
    await future;
  }

  bool _valueMatches(TeenPolicyCatalogItem item, Object value) =>
      switch (item.kind) {
        TeenPolicyKind.boolValue => value is bool,
        TeenPolicyKind.intValue => value is num,
        TeenPolicyKind.enumValue =>
          item.options.any((option) => option.value == value),
        TeenPolicyKind.unknown => false,
      };

  Object _normalizedValue(TeenPolicyCatalogItem item, Object value) {
    if (item.kind != TeenPolicyKind.intValue || value is! num) return value;
    var normalized = value.toInt();
    if (item.min != null && normalized < item.min!) normalized = item.min!;
    if (item.max != null && normalized > item.max!) normalized = item.max!;
    return normalized;
  }
}

final teenRequestsControllerProvider =
    AsyncNotifierProvider<TeenRequestsController, GuardianApprovalPage>(
  TeenRequestsController.new,
  dependencies: [teenModeRepositoryProvider, teenModeControllerProvider],
);

class TeenRequestsController extends AsyncNotifier<GuardianApprovalPage> {
  TeenModeRepository get _repository => ref.read(teenModeRepositoryProvider);
  bool _loadingMore = false;

  @override
  Future<GuardianApprovalPage> build() =>
      ref.watch(teenModeRepositoryProvider).getMyRequests();

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> cancel(String requestId) async {
    await _repository.cancelMyRequest(requestId);
    await refresh();
    ref.invalidate(teenModeControllerProvider);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    final cursor = current?.nextCursor;
    if (_loadingMore || current == null || cursor == null || cursor.isEmpty) {
      return;
    }
    _loadingMore = true;
    try {
      final next = await _repository.getMyRequests(cursor: cursor);
      final latest = state.valueOrNull;
      if (latest == null || latest.nextCursor != cursor) return;
      state = AsyncData(_mergeApprovalPages(latest, next));
    } finally {
      _loadingMore = false;
    }
  }
}

GuardianApprovalPage _mergeApprovalPages(
  GuardianApprovalPage current,
  GuardianApprovalPage next,
) {
  final seen = current.items.map((item) => item.requestId).toSet();
  return GuardianApprovalPage(
    items: [
      ...current.items,
      ...next.items.where((item) => seen.add(item.requestId)),
    ],
    nextCursor: next.nextCursor,
    pendingCount: next.pendingCount,
  );
}
