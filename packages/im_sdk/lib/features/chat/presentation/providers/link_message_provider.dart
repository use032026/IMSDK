import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/chat/application/link_message_draft_resolver.dart';
import 'package:im_sdk/features/chat/presentation/controllers/external_link_controller.dart';

final externalLinkControllerProvider = Provider<ExternalLinkController>(
  (ref) => ExternalLinkController(),
);

final linkMessageDraftResolverProvider = Provider<LinkMessageDraftResolver>(
  (ref) => const LinkMessageDraftResolver(),
);
