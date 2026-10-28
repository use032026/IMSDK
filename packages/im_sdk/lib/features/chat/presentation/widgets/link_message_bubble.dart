import 'package:flutter/material.dart';
import 'package:im_sdk/core/widgets/app_network_image.dart';
import 'package:im_sdk/core/network/http_client.dart';
import 'package:im_sdk/core/network/trusted_media_url.dart';
import 'package:im_sdk/features/chat/domain/entities/link_message_body.dart';
import 'package:im_sdk/features/chat/presentation/controllers/external_link_controller.dart';

class LinkMessageBubble extends StatelessWidget {
  final LinkMessageBody link;
  final ExternalLinkController? controller;

  const LinkMessageBubble({
    super.key,
    required this.link,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final siteName = link.siteName?.trim();
    final imageUrl =
        trustedServerMediaUrl(link.imageUrl, HttpClient.baseUrl)?.toString();
    final faviconUrl =
        trustedServerMediaUrl(link.faviconUrl, HttpClient.baseUrl)?.toString();

    return Semantics(
      button: true,
      label: '打开链接 ${link.displayTitle}',
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const ValueKey('link-message-open'),
          onTap: () => _open(context),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AppNetworkImage(
                        url: imageUrl,
                        key: const ValueKey('link-message-preview-image'),
                        width: double.infinity,
                        height: 112,
                        fit: BoxFit.cover,
                        errorBuilder: (_) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(
                    link.displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                  ),
                  if (link.description?.trim().isNotEmpty == true) ...[
                    const SizedBox(height: 6),
                    Text(
                      link.description!.trim(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  if (link.previewStatus == LinkPreviewStatus.pending &&
                      link.title == null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '正在生成链接预览',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                  Row(
                    children: [
                      _LinkSiteIcon(faviconUrl: faviconUrl),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (siteName?.isNotEmpty == true &&
                                siteName != link.displayTitle)
                              Text(
                                siteName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            Text(
                              link.url,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.open_in_new,
                        size: 15,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final opened =
        await (controller ?? ExternalLinkController()).open(link.url);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无法打开该链接')),
      );
    }
  }
}

class _LinkSiteIcon extends StatelessWidget {
  final String? faviconUrl;

  const _LinkSiteIcon({required this.faviconUrl});

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(
      Icons.link,
      size: 15,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    if (faviconUrl == null) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: AppNetworkImage(
        url: faviconUrl!,
        key: const ValueKey('link-message-favicon'),
        width: 15,
        height: 15,
        fit: BoxFit.cover,
        errorBuilder: (_) => fallback,
      ),
    );
  }
}
