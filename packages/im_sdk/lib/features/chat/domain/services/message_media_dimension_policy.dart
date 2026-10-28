import 'package:im_sdk/features/chat/domain/entities/message.dart';

class MessageMediaDimensionPolicy {
  const MessageMediaDimensionPolicy();

  Message mergeRemoteSnapshot({
    required Message local,
    required Message remote,
  }) {
    if (!_isSameMessage(local, remote) || local.type != remote.type) {
      return remote;
    }
    final localResource = _resourceFor(local);
    final remoteResource = _resourceFor(remote);
    if (localResource == null || remoteResource == null) return remote;

    final remoteHasDimensions = _hasValidDimensions(remoteResource);
    final localHasDimensions = _hasValidDimensions(localResource);
    final merged = remoteResource.copyWith(
      width: remoteHasDimensions
          ? remoteResource.width
          : localHasDimensions
              ? localResource.width
              : null,
      height: remoteHasDimensions
          ? remoteResource.height
          : localHasDimensions
              ? localResource.height
              : null,
      localPreviewUrl:
          remoteResource.localPreviewUrl ?? localResource.localPreviewUrl,
      localPosterUrl:
          remoteResource.localPosterUrl ?? localResource.localPosterUrl,
    );
    if (_sameDisplayState(remoteResource, merged)) return remote;
    return remote.copyWith(
      body: _bodyWithResource(remote.body, remote.type, merged),
    );
  }

  Message enrich(
    Message message, {
    required MessageType type,
    required int displayWidth,
    required int displayHeight,
  }) {
    if (message.type != type || displayWidth <= 0 || displayHeight <= 0) {
      return message;
    }

    final body = message.body;
    final resource = _resourceFor(message);
    if (resource == null || _hasValidDimensions(resource)) return message;

    final enriched = resource.copyWith(
      width: displayWidth,
      height: displayHeight,
    );
    return message.copyWith(body: _bodyWithResource(body, type, enriched));
  }

  MediaResource? _resourceFor(Message message) => switch (message.type) {
        MessageType.image => message.body.image,
        MessageType.video => message.body.video,
        _ => null,
      };

  MessageBody _bodyWithResource(
    MessageBody body,
    MessageType type,
    MediaResource resource,
  ) =>
      MessageBody(
        text: body.text,
        image: type == MessageType.image ? resource : body.image,
        video: type == MessageType.video ? resource : body.video,
        voice: body.voice,
        file: body.file,
        contactCard: body.contactCard,
        callLog: body.callLog,
        location: body.location,
        link: body.link,
        event: body.event,
        eventData: body.eventData,
      );

  bool _isSameMessage(Message local, Message remote) {
    if (local.messageId.isNotEmpty &&
        remote.messageId.isNotEmpty &&
        local.messageId == remote.messageId) {
      return true;
    }
    final localClientId = local.clientMsgId;
    final remoteClientId = remote.clientMsgId;
    return localClientId != null &&
        localClientId.isNotEmpty &&
        localClientId == remoteClientId;
  }

  bool _sameDisplayState(MediaResource first, MediaResource second) =>
      first.width == second.width &&
      first.height == second.height &&
      first.localPreviewUrl == second.localPreviewUrl &&
      first.localPosterUrl == second.localPosterUrl;

  bool _hasValidDimensions(MediaResource resource) =>
      resource.width != null &&
      resource.height != null &&
      resource.width! > 0 &&
      resource.height! > 0;
}
