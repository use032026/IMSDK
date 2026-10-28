import 'package:im_sdk/features/call/data/datasources/call_datasources.dart';
import 'package:im_sdk/features/call/domain/repositories/call_repositories.dart';

class CallRepositoryImpl implements CallRepository {
  final CallRemoteDataSource _remote;

  CallRepositoryImpl(this._remote);

  @override
  Future<({String callId, String relayUrl})> createVoiceCallSession({
    required String targetUserId,
    required bool isVideo,
    String? videoProfile,
  }) async {
    final session = await _remote.createVoiceCallSession(
      targetUserId: targetUserId,
      isVideo: isVideo,
      videoProfile: videoProfile,
    );
    return (callId: session.callId, relayUrl: session.relayUrl);
  }
}
