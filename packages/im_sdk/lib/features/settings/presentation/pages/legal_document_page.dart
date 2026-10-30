import 'package:flutter/material.dart';
import 'package:im_sdk/core/widgets/setting_tile.dart';
import 'package:url_launcher/url_launcher.dart';

part 'package:im_sdk/generated/l10n/sdk_legal_documents.g.dart';

class LegalDocumentData {
  final String appBarTitle;
  final List<LegalDocumentBlock> blocks;

  const LegalDocumentData({required this.appBarTitle, required this.blocks});
}

class LegalDocumentBlock {
  final String text;

  const LegalDocumentBlock(this.text);
}

enum LegalPlatform { ios, android }

LegalPlatform legalPlatformForTargetPlatform(TargetPlatform platform) =>
    platform == TargetPlatform.iOS ? LegalPlatform.ios : LegalPlatform.android;

String officialLegalLanguageCodeForLocale(Locale locale) {
  final languageCode = locale.languageCode.toLowerCase();
  if (languageCode == 'zh') {
    final countryCode = locale.countryCode?.toUpperCase();
    final isTraditionalChinese = locale.scriptCode?.toLowerCase() == 'hant' ||
        const {'TW', 'HK', 'MO'}.contains(countryCode);
    return isTraditionalChinese ? 'zh-hant' : 'zh';
  }
  return const {'en', 'ja', 'ko', 'vi'}.contains(languageCode)
      ? languageCode
      : 'zh';
}

Uri termsOfficialUriForPlatform(
  LegalPlatform platform, [
  Locale locale = const Locale('zh', 'CN'),
]) =>
    Uri.parse(
      platform == LegalPlatform.ios
          ? 'https://www.hearteasechat.com/terms-ios'
          : 'https://www.hearteasechat.com/terms-android',
    ).replace(
      queryParameters: {'lang': officialLegalLanguageCodeForLocale(locale)},
    );

Uri privacyOfficialUriForPlatform(
  LegalPlatform platform, [
  Locale locale = const Locale('zh', 'CN'),
]) =>
    Uri.parse(
      platform == LegalPlatform.ios
          ? 'https://www.hearteasechat.com/privacy-ios'
          : 'https://www.hearteasechat.com/privacy-android',
    ).replace(
      queryParameters: {'lang': officialLegalLanguageCodeForLocale(locale)},
    );

LegalDocumentData termsLegalDocumentForPlatform(LegalPlatform platform) =>
    _platformDocument(
      termsLegalDocumentZh,
      platform,
      appBarTitle: platform == LegalPlatform.ios
          ? sdkLegalTitles['termsAppBarIos']!
          : sdkLegalTitles['termsAppBarAndroid']!,
      documentTitle: platform == LegalPlatform.ios
          ? sdkLegalTitles['termsTitleIos']!
          : sdkLegalTitles['termsTitleAndroid']!,
    );

LegalDocumentData privacyLegalDocumentForPlatform(LegalPlatform platform) {
  if (platform == LegalPlatform.android) {
    return privacyLegalDocumentAndroidZh;
  }
  return _platformDocument(
    privacyLegalDocumentZh,
    platform,
    appBarTitle: sdkLegalTitles['privacyAppBarIos']!,
    documentTitle: sdkLegalTitles['privacyTitleIos']!,
  );
}

LegalDocumentData _platformDocument(
  LegalDocumentData source,
  LegalPlatform platform, {
  required String appBarTitle,
  required String documentTitle,
}) {
  final blocks = <LegalDocumentBlock>[];
  for (var index = 0; index < source.blocks.length; index++) {
    final text = index == 0
        ? documentTitle
        : _platformizeLegalText(source.blocks[index].text, platform);
    if (text != null) blocks.add(LegalDocumentBlock(text));
  }
  return LegalDocumentData(appBarTitle: appBarTitle, blocks: blocks);
}

String? _platformizeLegalText(String text, LegalPlatform platform) {
  final isIos = platform == LegalPlatform.ios;

  // Prefixes identify existing clauses; displayed replacement text is generated.

  if (text.startsWith('1.2 微界支持移动端')) {
    return isIos
        ? sdkLegalPlatformClauses['1.2 微界支持移动端']!['ios']!
        : sdkLegalPlatformClauses['1.2 微界支持移动端']!['android']!;
  }
  if (text.startsWith('1.5 本协议统一适用于')) {
    return isIos
        ? sdkLegalPlatformClauses['1.5 本协议统一适用于']!['ios']!
        : sdkLegalPlatformClauses['1.5 本协议统一适用于']!['android']!;
  }
  if (text.startsWith('3.1 您可以在移动端')) {
    return isIos
        ? sdkLegalPlatformClauses['3.1 您可以在移动端']!['ios']!
        : sdkLegalPlatformClauses['3.1 您可以在移动端']!['android']!;
  }
  if (text.startsWith('6.2 微界会根据具体功能')) {
    return isIos
        ? sdkLegalPlatformClauses['6.2 微界会根据具体功能']!['ios']!
        : sdkLegalPlatformClauses['6.2 微界会根据具体功能']!['android']!;
  }
  if (text.startsWith('7.7 您通过 Apple App Store')) {
    return isIos
        ? sdkLegalPlatformClauses['7.7 您通过 Apple App Store']!['ios']!
        : sdkLegalPlatformClauses['7.7 您通过 Apple App Store']!['android']!;
  }
  if (text.startsWith('1.1 本政策统一适用于')) {
    return isIos
        ? sdkLegalPlatformClauses['1.1 本政策统一适用于']!['ios']!
        : sdkLegalPlatformClauses['1.1 本政策统一适用于']!['android']!;
  }
  if (text.startsWith('2.7 通知、设备与网络信息')) {
    return isIos
        ? sdkLegalPlatformClauses['2.7 通知、设备与网络信息']!['ios']!
        : sdkLegalPlatformClauses['2.7 通知、设备与网络信息']!['android']!;
  }
  if (text.startsWith('3.3 相册/照片/媒体/文件访问')) {
    return isIos
        ? sdkLegalPlatformClauses['3.3 相册/照片/媒体/文件访问']!['ios']!
        : sdkLegalPlatformClauses['3.3 相册/照片/媒体/文件访问']!['android']!;
  }
  if (text.startsWith('3.7 旧版存储写入权限')) {
    return isIos ? null : sdkLegalPlatformClauses['3.7 旧版存储写入权限']!['android']!;
  }
  if (text.startsWith('3.10 平台差异说明')) {
    return isIos
        ? sdkLegalPlatformClauses['3.10 平台差异说明']!['ios']!
        : sdkLegalPlatformClauses['3.10 平台差异说明']!['android']!;
  }
  if (text.startsWith('5.2 移动端和桌面端')) {
    return isIos
        ? sdkLegalPlatformClauses['5.2 移动端和桌面端']!['ios']!
        : sdkLegalPlatformClauses['5.2 移动端和桌面端']!['android']!;
  }
  if (text.startsWith('6.2 极光推送 JPush/JCore')) {
    return isIos
        ? sdkLegalPlatformClauses['6.2 极光推送 JPush/JCore']!['ios']!
        : sdkLegalPlatformClauses['6.2 极光推送 JPush/JCore']!['android']!;
  }
  if (text.startsWith('6.3 系统和厂商推送服务')) {
    return isIos
        ? sdkLegalPlatformClauses['6.3 系统和厂商推送服务']!['ios']!
        : sdkLegalPlatformClauses['6.3 系统和厂商推送服务']!['android']!;
  }
  if (text.startsWith('6.4 位置服务说明')) {
    return isIos
        ? sdkLegalPlatformClauses['6.4 位置服务说明']!['ios']!
        : sdkLegalPlatformClauses['6.4 位置服务说明']!['android']!;
  }
  if (text.startsWith('6.5 系统语音识别服务')) {
    return isIos
        ? sdkLegalPlatformClauses['6.5 系统语音识别服务']!['ios']!
        : sdkLegalPlatformClauses['6.5 系统语音识别服务']!['android']!;
  }
  if (text.startsWith('6.6 WebRTC 与本地媒体组件')) {
    return isIos
        ? text.replaceFirst('（iOS、Android）', sdkLegalPlatformSuffixes['ios']!)
        : text.replaceFirst(
            '（iOS、Android）', sdkLegalPlatformSuffixes['android']!);
  }
  if (text.startsWith('10.5 注销账号和删除账号数据')) {
    return isIos
        ? sdkLegalPlatformClauses['10.5 注销账号和删除账号数据']!['ios']!
        : sdkLegalPlatformClauses['10.5 注销账号和删除账号数据']!['android']!;
  }

  return text;
}

class LegalDocumentScaffold extends StatelessWidget {
  final LegalDocumentData document;
  final Uri? officialUri;

  const LegalDocumentScaffold({
    required this.document,
    this.officialUri,
    super.key,
  });

  Future<void> _openOfficialDocument(BuildContext context) async {
    final uri = officialUri;
    if (uri == null) return;
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      if (opened || !context.mounted) return;
    } catch (_) {
      if (!context.mounted) return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(sdkLegalOpenFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: null,
      appBar: buildSettingsAppBar(context, document.appBarTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (officialUri != null) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _openOfficialDocument(context),
                  icon: const Icon(Icons.language, size: 18),
                  label: const Text(sdkLegalViewOfficial),
                ),
              ),
              const SizedBox(height: 12),
            ],
            _LegalDocumentCard(document: document),
          ],
        ),
      ),
    );
  }
}

class _LegalDocumentCard extends StatelessWidget {
  final LegalDocumentData document;

  const _LegalDocumentCard({required this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < document.blocks.length; index++) ...[
            _LegalBlockText(index: index, text: document.blocks[index].text),
            if (index < document.blocks.length - 1)
              SizedBox(height: _spacingAfter(document.blocks[index].text)),
          ],
        ],
      ),
    );
  }
}

class _LegalBlockText extends StatelessWidget {
  final int index;
  final String text;

  const _LegalBlockText({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    final kind = _resolveBlockKind(index, text);
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: switch (kind) {
        _LegalBlockKind.title => TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            height: 1.45,
          ),
        _LegalBlockKind.meta => TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
            height: 1.45,
          ),
        _LegalBlockKind.section => TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
            height: 1.55,
          ),
        _LegalBlockKind.body => TextStyle(
            fontSize: 14,
            color: colorScheme.onSurfaceVariant,
            height: 1.7,
          ),
      },
    );
  }
}

enum _LegalBlockKind { title, meta, section, body }

_LegalBlockKind _resolveBlockKind(int index, String text) {
  if (index == 0) return _LegalBlockKind.title;
  if (text.startsWith('更新日期：') ||
      text.startsWith('最近更新日期：') ||
      text.startsWith('生效日期：') ||
      text.startsWith('协议生效日期：') ||
      RegExp(r'^(Last updated|Updated|Effective|Effective date|最終更新日|発効日|Cập nhật|Ngày có hiệu lực|최종 업데이트|시행일):|^(最近更新日期|生效日期)：')
          .hasMatch(text)) {
    return _LegalBlockKind.meta;
  }
  if (RegExp(r'^[一二三四五六七八九十]+、').hasMatch(text) ||
      RegExp(r'^\d+[.．]\s').hasMatch(text)) {
    return _LegalBlockKind.section;
  }
  return _LegalBlockKind.body;
}

double _spacingAfter(String text) {
  if (text.startsWith('更新日期：') ||
      text.startsWith('最近更新日期：') ||
      text.startsWith('生效日期：') ||
      RegExp(r'^(Last updated|Updated|Effective|Effective date|最終更新日|発効日|Cập nhật|Ngày có hiệu lực|최종 업데이트|시행일):|^(最近更新日期|生效日期)：')
          .hasMatch(text)) {
    return 4;
  }
  if (RegExp(r'^[一二三四五六七八九十]+、').hasMatch(text) ||
      RegExp(r'^\d+[.．]\s').hasMatch(text)) {
    return 8;
  }
  return 12;
}
