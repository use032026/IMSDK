import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/im_sdk.dart';

const _configuration = ImSdkConfig(
  apiBaseUrl: 'https://im.example.test',
  serviceRealmId: 'fixture',
  privacyConsentGranted: false,
  passwordLogin: ImSdkPasswordLoginConfig(tenantCode: 'fixed-tenant'),
);

class _Client extends ImSdkClient {
  final changes = ValueNotifier(0);
  ImSdkConfig? installed;
  int initializations = 0;
  int attempts = 0;
  int captchaRequests = 0;
  int registrationAttempts = 0;
  String? registeredIdentifier;
  String? registeredChannel;
  String? registeredCode;
  @override
  Future<ImSdkRegistrationVerificationSettings>
      getRegistrationVerificationSettings() async =>
          const ImSdkRegistrationVerificationSettings(
              smsEnabled: true,
              emailEnabled: true,
              smsRequired: true,
              emailRequired: true);
  @override
  Future<void> registerWithPassword(
      {required String displayName,
      required String password,
      required String channel,
      required String identifier,
      String? verificationCode,
      String? captchaToken,
      String? captchaAnswer}) async {
    registrationAttempts++;
    registeredIdentifier = identifier;
    registeredChannel = channel;
    registeredCode = verificationCode;
    this.password = password;
  }

  String? account;
  String? password;
  String? answer;
  String? token;
  ImSdkException? failure;
  bool requireCaptcha = false;
  @override
  ValueNotifier<int> get revision => changes;
  @override
  bool get isInitialized => installed != null;
  @override
  ImSdkConfig? get config => installed;
  @override
  Future<void> initialize(ImSdkConfig config) async {
    config.validate();
    initializations++;
    installed = config;
    changes.value++;
  }

  @override
  Future<void> loginWithPassword(
      {required String account,
      required String password,
      String? captchaToken,
      String? captchaAnswer}) async {
    attempts++;
    this.account = account;
    this.password = password;
    answer = captchaAnswer;
    token = captchaToken;
    if (requireCaptcha && captchaToken == null) {
      throw const ImSdkException(
          'AUTH_CAPTCHA_REQUIRED', 'sensitive backend text');
    }
    if (failure != null) throw failure!;
  }

  @override
  Future<ImSdkCaptchaChallenge> requestLoginCaptcha() async {
    captchaRequests++;
    return const ImSdkCaptchaChallenge(
        token: 'fixture-challenge', question: '1 + 2 = ?');
  }
}

Future<void> _fill(WidgetTester tester) async {
  await tester.enterText(
      find.byKey(const ValueKey('messaging.account')), ' account ');
  await tester.enterText(
      find.byKey(const ValueKey('messaging.password')), ' password ');
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pumpAndSettle();
}

Future<void> _tapLogin(WidgetTester tester) async {
  final button = find.byKey(const ValueKey('messaging.login'));
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('default UI contains only account login, no technical form',
      (tester) async {
    final client = _Client();
    await tester.pumpWidget(
        ImSdkMessagingView(client: client, configuration: _configuration));
    expect(find.byType(TextFormField), findsNWidgets(2));
    for (final label in [
      'accessToken',
      'conversationId',
      'apiBaseUrl',
      '提交 IM 凭证',
      '联系企业客服'
    ]) {
      expect(find.textContaining(label), findsNothing);
    }
    expect(client.initializations, 0);
    expect(client.attempts, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    await client.dispose();
  });

  testWidgets(
      'missing integration config disables login without asking user for service fields',
      (tester) async {
    final client = _Client();
    await tester.pumpWidget(ImSdkMessagingView(client: client));
    expect(find.textContaining('接入方尚未配置聊天服务'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
    expect(client.initializations, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    await client.dispose();
  });

  testWidgets('registration entry requires consent before initialization',
      (tester) async {
    final client = _Client();
    await tester.pumpWidget(
        ImSdkMessagingView(client: client, configuration: _configuration));
    final entry = find.byKey(const ValueKey('messaging.register'));
    await tester.ensureVisible(entry);
    await tester.tap(entry);
    await tester.pumpAndSettle();
    expect(client.initializations, 0);
    expect(find.text('请先同意使用聊天服务'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await client.dispose();
  });

  testWidgets(
      'personal registration has channel verification and no space picker',
      (tester) async {
    final client = _Client()
      ..installed = ImSdkConfig.fromMap(
          {..._configuration.toMap(), 'privacyConsentGranted': true});
    await tester.pumpWidget(ImSdkMessagingView(client: client));
    final entry = find.byKey(const ValueKey('messaging.register'));
    await tester.ensureVisible(entry);
    await tester.tap(entry);
    await tester.pumpAndSettle();
    expect(find.text('注册后即可开始聊天，无需选择空间'), findsOneWidget);
    expect(find.text('选择空间'), findsNothing);
    for (final text in ['企业码', '邀请码', 'tenantId', 'spaceId']) {
      expect(find.textContaining(text), findsNothing);
    }
    await tester.enterText(
        find.byKey(const ValueKey('registration.name')), 'New user');
    await tester.enterText(
        find.byKey(const ValueKey('registration.identifier')), '13800138000');
    await tester.enterText(
        find.byKey(const ValueKey('registration.password')), ' password ');
    await tester.enterText(
        find.byKey(const ValueKey('registration.confirmation')), ' password ');
    final submit = find.byKey(const ValueKey('registration.submit'));
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(client.registrationAttempts, 0);
    expect(find.text('请输入验证码'), findsOneWidget);
    await tester.enterText(
        find.byKey(const ValueKey('registration.code')), '123456');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(client.registrationAttempts, 1);
    expect(client.registeredIdentifier, '13800138000');
    expect(client.registeredChannel, 'sms');
    expect(client.registeredCode, '123456');
    expect(client.password, ' password ');
    await tester.pumpWidget(const SizedBox.shrink());
    await client.dispose();
  });

  testWidgets('consent gates initialization and login', (tester) async {
    final client = _Client();
    await tester.pumpWidget(
        ImSdkMessagingView(client: client, configuration: _configuration));
    await _fill(tester);
    await _tapLogin(tester);
    expect(find.text('请先同意使用聊天服务'), findsOneWidget);
    expect(client.initializations, 0);
    expect(client.attempts, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    await client.dispose();
  });

  testWidgets(
      'failed password login stays at login, hides backend text and preserves password exactly',
      (tester) async {
    final client = _Client()
      ..failure = const ImSdkException(
          'AUTH_INVALID_CREDENTIALS', 'secret-server-text');
    await tester.pumpWidget(
        ImSdkMessagingView(client: client, configuration: _configuration));
    await _fill(tester);
    await tester.tap(find.byKey(const ValueKey('messaging.consent')));
    await _tapLogin(tester);
    expect(client.initializations, 1);
    expect(client.installed!.privacyConsentGranted, true);
    expect(client.account, 'account');
    expect(client.password, ' password ');
    expect(find.text('会话'), findsNothing);
    expect(find.textContaining('secret-server-text'), findsNothing);
    expect(find.textContaining('账号或密码不正确'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await client.dispose();
  });

  testWidgets(
      'server challenge prompts once and retries with original password',
      (tester) async {
    final client = _Client()
      ..installed = ImSdkConfig.fromMap(
          {..._configuration.toMap(), 'privacyConsentGranted': true})
      ..requireCaptcha = true;
    await tester.pumpWidget(ImSdkMessagingView(client: client));
    await _fill(tester);
    await _tapLogin(tester);
    expect(find.text('登录验证'), findsOneWidget);
    expect(client.captchaRequests, 1);
    await tester.enterText(
        find.descendant(
            of: find.byType(AlertDialog), matching: find.byType(TextField)),
        '3');
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(client.attempts, 2);
    expect(client.token, 'fixture-challenge');
    expect(client.answer, '3');
    expect(client.password, ' password ');
    expect(
        tester
            .widget<TextFormField>(
                find.byKey(const ValueKey('messaging.password')))
            .controller!
            .text,
        isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
    await client.dispose();
  });
}
