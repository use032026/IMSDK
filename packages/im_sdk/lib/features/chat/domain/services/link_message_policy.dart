import 'package:im_sdk/features/chat/domain/entities/link_message_body.dart';
import 'package:im_sdk/features/chat/domain/services/message_text_link_han_tlds.dart';
import 'package:punycode/punycode.dart';

class LinkMessagePolicy {
  const LinkMessagePolicy._();

  static final _textUrlPattern = RegExp(
    r'''(?:(https?://)|www\.|(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z]{2,63})[^\s<>"'，。！？；：、（）【】《》「」『』]*''',
    caseSensitive: false,
  );
  static final _authorityPattern =
      RegExp(r'^https?://([^/?#]*)', caseSensitive: false);
  static final _hanPattern = RegExp(r'\p{Script=Han}', unicode: true);
  static final _trailingDotsPattern = RegExp(r'\.+$');
  static final _asciiTldPattern = RegExp(r'^[a-z]{2,63}$');
  static final _hostLabelPattern =
      RegExp(r'^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$', caseSensitive: false);
  static final _bareHostContinuationPattern =
      RegExp(r'[a-z0-9_@./:\\%+\-]', caseSensitive: false);
  static final _bareContextBoundaryPattern = RegExp(r'[\s<>，。！？；：、（）【】《》「」『』]');

  static List<TextMessageLink> findTextLinks(String text) {
    final links = <TextMessageLink>[];
    for (final match in _textUrlPattern.allMatches(text)) {
      final hasScheme = match.group(1) != null;
      if (!hasScheme && !_canStartBareLink(text, match.start)) continue;
      final prefix = hasScheme ? '' : 'https://';
      var url = '$prefix${match.group(0)!}';
      while (url.isNotEmpty) {
        final last = url[url.length - 1];
        final opening = const {')': '(', ']': '[', '}': '{'}[last];
        final unmatchedClosing = opening != null &&
            last.allMatches(url).length > opening.allMatches(url).length;
        if (!'.,!?;:'.contains(last) && !unmatchedClosing) break;
        url = url.substring(0, url.length - 1);
      }
      url = _trimDomainProse(url);
      if (tryParseStandaloneUrl(url) == null) continue;
      if (!hasScheme && !_isBareDomainUrl(url)) continue;
      links.add(TextMessageLink(
        start: match.start,
        end: match.start + url.length - prefix.length,
        url: url,
      ));
    }
    return links;
  }

  static bool _canStartBareLink(String text, int start) {
    if (start == 0) return true;
    if (_bareHostContinuationPattern.hasMatch(text[start - 1])) return false;
    // Never salvage a host from an email, path or another scheme's payload.
    for (var index = start - 1; index >= 0; index--) {
      final character = text[index];
      if (_bareContextBoundaryPattern.hasMatch(character)) break;
      if (character == ':') return false;
    }
    return true;
  }

  static bool _isBareDomainUrl(String url) {
    final uri = tryParseStandaloneUrl(url);
    if (uri == null || !_hasDomainEnding(url)) return false;
    try {
      if (uri.hasPort && (uri.port < 1 || uri.port > 65535)) return false;
      final labels = Uri.decodeComponent(uri.host).split('.').map((label) =>
          label.runes.any((rune) => rune > 0x7f)
              ? 'xn--${punycodeEncode(label)}'
              : label);
      return labels.join('.').length <= 253 &&
          labels.every(_hostLabelPattern.hasMatch);
    } on FormatException {
      return false;
    }
  }

  static String _trimDomainProse(String url) {
    final match = _authorityPattern.firstMatch(url);
    final authority = match?.group(1);
    if (match == null ||
        authority == null ||
        authority.contains('@') ||
        !_hanPattern.hasMatch(authority)) {
      return url;
    }
    if (_hasDomainEnding(url)) return url;

    // Only the authority is ambiguous; Chinese paths, queries and fragments stay.
    final authorityStart = match.end - authority.length;
    for (final han in _hanPattern.allMatches(authority)) {
      final candidate = url
          .substring(0, authorityStart + han.start)
          .replaceFirst(_trailingDotsPattern, '');
      if (_hasDomainEnding(candidate)) return candidate;
    }
    return url;
  }

  static bool _hasDomainEnding(String url) {
    final uri = tryParseStandaloneUrl(url);
    if (uri == null) return false;
    try {
      final labels = Uri.decodeComponent(uri.host)
          .toLowerCase()
          .replaceFirst(RegExp(r'\.$'), '')
          .split('.');
      if (labels.length < 2 || labels.any((label) => label.isEmpty)) {
        return false;
      }
      final tld = labels.last;
      if (_asciiTldPattern.hasMatch(tld)) return true;
      final asciiTld = tld.runes.any((rune) => rune > 0x7f)
          ? 'xn--${punycodeEncode(tld)}'
          : tld;
      return messageTextLinkHanTlds.contains(asciiTld);
    } on FormatException {
      return false;
    }
  }

  static Uri? tryParseStandaloneUrl(String input) {
    final value = input.trim();
    if (value.isEmpty || value.contains(RegExp(r'\s'))) return null;
    return LinkMessageBody.tryParseUrl(value);
  }

  static bool isSafeExternalUrl(String input) =>
      tryParseStandaloneUrl(input) != null;
}

class TextMessageLink {
  final int start;
  final int end;
  final String url;

  const TextMessageLink({
    required this.start,
    required this.end,
    required this.url,
  });
}
