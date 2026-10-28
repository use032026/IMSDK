import 'package:im_sdk/core/auth/account_session.dart';
import 'package:im_sdk/core/runtime/account_runtime.dart';
import 'package:im_sdk/core/space/space_context.dart';
import 'package:im_sdk/features/chat/domain/entities/conversation.dart';

/// Reads the existing account store without creating another conversation cache.
class ConversationTypeResolver {
  ConversationTypeResolver({
    required this.groupFeaturesBlocked,
    required this.currentRuntime,
    required this.currentSession,
    required this.currentSpace,
    required this.readLocalTypes,
    required this.readDirectConversation,
    this.lookupTimeout = const Duration(seconds: 5),
  });

  final bool Function() groupFeaturesBlocked;
  final AccountRuntime? Function() currentRuntime;
  final AccountSession? Function() currentSession;
  final SpaceContext? Function() currentSpace;
  final Future<Map<String, ConversationType>> Function(
      AccountRuntime, String, Set<String>) readLocalTypes;
  final Future<bool> Function(
          String conversationId, String accessToken, Duration timeout)
      readDirectConversation;
  final Duration lookupTimeout;

  Future<ConversationType?> resolve({
    required String spaceId,
    required String conversationId,
    bool allowRemote = true,
  }) async {
    final types = await resolveMany(
      spaceId: spaceId,
      conversationIds: [conversationId],
      allowRemote: allowRemote,
    );
    return types[conversationId];
  }

  Future<Map<String, ConversationType>> resolveMany({
    required String spaceId,
    required Iterable<String> conversationIds,
    bool allowRemote = true,
  }) async {
    if (!groupFeaturesBlocked()) return const {};
    final ids = conversationIds.where((id) => id.isNotEmpty).toSet();
    if (ids.isEmpty) return const {};
    final runtime = _runtimeFor(spaceId);
    final space = currentSpace();
    if (runtime == null || space == null) return const {};
    final elapsed = Stopwatch()..start();
    bool isCurrent() =>
        groupFeaturesBlocked() && identical(runtime, _runtimeFor(spaceId));

    final resolved = <String, ConversationType>{};
    try {
      final local = await readLocalTypes(runtime, spaceId, ids);
      if (!isCurrent()) return const {};
      resolved.addAll(local);
    } catch (_) {
      // A missing local snapshot may still be resolved by its direct-chat ID.
      if (!isCurrent()) return const {};
    }
    if (!allowRemote) return resolved;

    final missing = ids.difference(resolved.keys.toSet()).toList();
    // Search results can contain several unseen conversations. Bound requests
    // and reuse this operation's local snapshot, rather than scanning all pages.
    for (var offset = 0; offset < missing.length; offset += 4) {
      if (!isCurrent()) return const {};
      final remaining = lookupTimeout - elapsed.elapsed;
      if (remaining <= Duration.zero) break;
      await Future.wait(missing.skip(offset).take(4).map((id) async {
        try {
          final isDirect = await readDirectConversation(
            id,
            space.accessToken,
            remaining,
          );
          if (isDirect && isCurrent()) resolved[id] = ConversationType.direct;
        } catch (_) {
          // Permission failures, missing IDs and network errors remain unknown.
        }
      }));
      if (!isCurrent()) return const {};
    }
    return resolved;
  }

  AccountRuntime? _runtimeFor(String spaceId) {
    final runtime = currentRuntime();
    final session = currentSession();
    final space = currentSpace();
    if (runtime == null ||
        session == null ||
        runtime.lifecycle != AccountRuntimeLifecycle.active ||
        runtime.session.sessionId != session.sessionId ||
        runtime.session.scope != session.scope ||
        runtime.session.identityRevision != session.identityRevision ||
        runtime.session.scope.spaceId != spaceId ||
        !runtime.session.scope.ownsSpace(space) ||
        space!.accessToken.isEmpty) {
      return null;
    }
    return runtime;
  }
}
