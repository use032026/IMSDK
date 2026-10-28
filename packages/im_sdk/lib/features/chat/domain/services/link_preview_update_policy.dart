import 'package:im_sdk/features/chat/domain/entities/message.dart';

Message? mergeLinkPreviewSnapshot(Message current, Message snapshot) {
  if (current.messageId != snapshot.messageId) return null;
  final currentLink = current.body.link;
  final incomingLink = snapshot.body.link;
  if (currentLink == null ||
      incomingLink == null ||
      incomingLink.previewVersion < currentLink.previewVersion) {
    return null;
  }
  return current.copyWith(
    type: MessageType.link,
    body: MessageBody(
      text: snapshot.body.text ?? current.body.text,
      image: current.body.image,
      video: current.body.video,
      voice: current.body.voice,
      file: current.body.file,
      contactCard: current.body.contactCard,
      callLog: current.body.callLog,
      location: current.body.location,
      link: incomingLink,
      event: current.body.event,
      eventData: current.body.eventData,
    ),
  );
}
