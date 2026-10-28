/// Call 模块 domain repository 接口
///
/// 通话会话分配走 REST API，通话中的信令由 CallService（SignalR Hub）处理。
/// 通话记录由服务端根据终态唯一生成，本仓储不提供消息写入能力。
abstract class CallRepository {
  Future<({String callId, String relayUrl})> createVoiceCallSession({
    required String targetUserId,
    required bool isVideo,
    String? videoProfile,
  });
}
