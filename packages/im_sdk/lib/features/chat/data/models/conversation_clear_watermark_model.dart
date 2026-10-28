import 'package:im_sdk/features/chat/domain/entities/conversation_clear_watermark.dart';

class ConversationClearWatermarkModel {
  const ConversationClearWatermarkModel._();

  static List<ConversationClearWatermark> parseList(Object? raw) {
    if (raw is! List) return const [];
    return raw.whereType<Map>().map((item) {
      final json = Map<String, dynamic>.from(item);
      final conversationId = json['conversationId']?.toString().trim() ?? '';
      final rawSeq = json['clearedSeq'];
      final clearedSeq = rawSeq is num
          ? rawSeq.toInt()
          : int.tryParse(rawSeq?.toString() ?? '');
      if (conversationId.isEmpty || clearedSeq == null || clearedSeq < 0) {
        return null;
      }
      return ConversationClearWatermark(
        conversationId: conversationId,
        clearedSeq: clearedSeq,
      );
    }).whereType<ConversationClearWatermark>().toList(growable: false);
  }
}
