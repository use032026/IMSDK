import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/core/di/injector.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/storage/account_storage_context_provider.dart';
import 'package:im_sdk/features/auth/presentation/providers/auth_provider.dart';
import 'package:im_sdk/features/official_account/data/official_account_inbox_repository.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_card.dart';

final officialAccountInboxRepositoryProvider =
    Provider<OfficialAccountInboxRepository?>((ref) {
  final storage = ref.watch(accountStorageContextProvider);
  if (storage == null || storage.scope.spaceId != 'personal') return null;
  return OfficialAccountInboxRepository(ref.watch(dioProvider), storage);
}, dependencies: [accountStorageContextProvider, dioProvider]);

final officialAccountInboxProvider = AsyncNotifierProvider<
    OfficialAccountInboxController, List<OfficialAccountConversationSummary>>(
  OfficialAccountInboxController.new,
  dependencies: [
    officialAccountInboxRepositoryProvider,
    accountRuntimeCurrentSpaceProvider
  ],
);

class OfficialAccountInboxController
    extends AsyncNotifier<List<OfficialAccountConversationSummary>> {
  int _revision = 0;
  Future<void>? _pending;

  @override
  Future<List<OfficialAccountConversationSummary>> build() async {
    final revision = ++_revision;
    _pending = null;
    ref.onDispose(() => _revision++);
    final space = ref.watch(accountRuntimeCurrentSpaceProvider);
    final repository = ref.watch(officialAccountInboxRepositoryProvider);
    if (space?.isPersonal != true || repository == null) return const [];
    final cached = repository.loadCached();
    if (cached != null) {
      // Publish the disk snapshot without waiting for the platform request.
      unawaited(Future<void>.microtask(() async {
        if (_revision == revision) await refresh();
      }));
      return cached;
    }
    final token = ref.read(authProvider).valueOrNull?.platformToken;
    if (token == null) return const [];
    final request = repository.fetch(token).then((result) async {
      if (!_isCurrent(revision)) {
        return const <OfficialAccountConversationSummary>[];
      }
      await repository.save(result);
      return result;
    });
    // A manual/resume refresh joins the cold request rather than starting a
    // second request whose older response could overwrite the new snapshot.
    _pending =
        request.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    try {
      return await request;
    } finally {
      if (_revision == revision) _pending = null;
    }
  }

  bool _isCurrent(int revision) =>
      _revision == revision &&
      ref.read(accountRuntimeCurrentSpaceProvider)?.isPersonal == true;

  Future<void> refresh() {
    if (_pending != null) return _pending!;
    final revision = _revision;
    final pending = _refresh(revision);
    _pending = pending;
    return pending.whenComplete(() {
      if (_revision == revision) _pending = null;
    });
  }

  Future<void> _refresh(int revision) async {
    if (!_isCurrent(revision)) return;
    final repository = ref.read(officialAccountInboxRepositoryProvider);
    final token = ref.read(authProvider).valueOrNull?.platformToken;
    if (repository == null || token == null) return;
    try {
      final result = await repository.fetch(token);
      if (!_isCurrent(revision)) return;
      await repository.save(result);
      if (_isCurrent(revision)) state = AsyncData(result);
    } catch (error, stack) {
      if (!_isCurrent(revision)) return;
      AppDiagnostics.instance.warning('official_account.inbox.refresh',
          'Official inbox refresh failed; keeping the local snapshot',
          context: {'errorType': error.runtimeType.toString()});
      state = AsyncError<List<OfficialAccountConversationSummary>>(error, stack)
          .copyWithPrevious(state);
    }
  }
}
