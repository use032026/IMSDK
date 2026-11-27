import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/chat/domain/entities/media_local_file.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/presentation/controllers/media_open_controller.dart';

final fileMessageAvailabilityProvider = StreamProvider.autoDispose
    .family<bool, ({String spaceId, Message message})>((ref, request) {
  final file = request.message.body.file;
  if (file == null || request.spaceId.isEmpty) return Stream.value(false);
  final source = ref
      .watch(mediaOpenControllerProvider(request.spaceId))
      .watchCachedAvailabilityFor(MediaOpenRequest.fromResource(
        message: request.message,
        mediaKind: MediaKind.file,
        variant: MediaVariant.attachment,
        resource: file,
        fallbackName: 'file',
      ));
  final events = StreamController<bool>(sync: true);
  final subscription =
      source.listen(events.add, onError: events.addError, onDone: events.close);
  // Riverpod retains a loading stream for provider.future until its first value.
  // Release the ledger observation even if the row leaves before its cold read.
  ref.onDispose(() {
    unawaited(subscription.cancel());
    unawaited(events.close());
  });
  return events.stream;
}, dependencies: [mediaOpenControllerProvider]);
