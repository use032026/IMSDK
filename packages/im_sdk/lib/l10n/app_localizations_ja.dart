// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get navWorkbench => 'ワークベンチ';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'アカウントデータを読み込めませんでした';

  @override
  String get startupFailureTitle => '起動に失敗しました';

  @override
  String get startupFailureMessage => 'ネットワークを確認して再試行してください';

  @override
  String get privacyConsentTitle => '利用規約とプライバシーポリシー';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return '$brandをご利用いただきありがとうございます。アカウントログイン、インスタントメッセージ、企業コラボレーション、オンラインカスタマーサービス、通知、安全保護を提供するため、利用規約とプライバシーポリシーに従って必要な情報を処理します。\n\n同意するまでは、クリップボード情報を読み取らず、JPush/JCore または端末メーカーのプッシュ SDK を初期化せず、これらの SDK を通じて Android ID、OAID、インストール済みアプリ一覧、MAC アドレスなどを取得しません。今は同意しない場合、その選択を保存します。文書を引き続き確認し、後から選択し直すことができます。\n\n同意後、メッセージ、カスタマーサービス、着信通知を届けるため、JPush/JCore および端末メーカーのプッシュサービスが、端末モデル、Android バージョン、アプリのパッケージ名とバージョン、ネットワーク種類、IP アドレス、Android ID、OAID、プッシュ Registration ID、メーカーのプッシュ Token、通知の配信・クリック情報を処理する場合があります。スマートプッシュ、インストール済みアプリ一覧、MAC、IMEI、IMSI、Wi-Fi 一覧、自動起動、関連起動など不要な機能は無効にしています。\n\nクリップボードはコピーまたは貼り付けをユーザーが実行した場合にのみ使用します。カメラ、マイク、通知などのシステム権限は、該当機能を使用するときにのみ要求します。個別の権限を拒否しても、その機能にのみ影響します。以下の全文を確認し、同意するか選択してください。';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return '$brandをご利用いただきありがとうございます。アカウントログイン、インスタントメッセージ、企業コラボレーション、オンラインカスタマーサービス、通知、安全保護を提供するため、利用規約とプライバシーポリシーに従って必要な情報を処理します。\n\n同意するまでは、クリップボード情報を読み取らず、JPush/JCore を初期化せず、Apple Push Notification service（APNs）への登録も行いません。また、JPush の Registration ID や APNs デバイストークンなどのプッシュ識別子も取得しません。今は同意しない場合、その選択を保存します。文書を引き続き確認し、後から選択し直すことができます。\n\n同意後、メッセージ、カスタマーサービス、着信通知を届けるため、iPhone のモデル、iOS のバージョン、アプリのパッケージ名とバージョン、ネットワークの種類、IP アドレス、IDFV、JPush の Registration ID、APNs デバイストークン、通知の配信・クリック情報を処理する場合があります。JPush/JCore はプッシュサービスへの接続に使用し、Apple APNs はシステム通知の配信に必要なアプリ識別子、デバイストークン、通知内容を処理します。現在の iOS 版では広告サービスを利用せず、IDFA を取得しません。\n\nクリップボードはコピーまたは貼り付けをユーザーが実行した場合にのみ使用します。カメラ、マイク、通知などのシステム権限は、該当機能を使用するときにのみ要求します。個別の権限を拒否しても、その機能にのみ影響します。以下の全文を確認し、同意するか選択してください。';
  }

  @override
  String get privacyConsentTermsLink => '利用規約';

  @override
  String get privacyConsentConjunction => 'と';

  @override
  String get privacyConsentPrivacyLink => 'プライバシーポリシー';

  @override
  String get privacyConsentDecline => '同意しない';

  @override
  String get privacyConsentDeclinedExit =>
      '利用規約とプライバシーポリシーに同意しなかったため、アプリを終了します。';

  @override
  String get privacyConsentAccept => '同意する';

  @override
  String get privacyConsentRuntimeFailure => '起動に失敗しました。ネットワークを確認して再試行してください。';

  @override
  String get privacyConsentSaveFailure => '選択を保存できませんでした。再試行してください。';

  @override
  String get appUpdateRequiredTitle => '続行するには更新が必要です';

  @override
  String get appUpdateOptionalTitle => '新しいバージョンがあります';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version に更新できます';
  }

  @override
  String get appUpdateLater => '後で';

  @override
  String get appUpdateNow => '今すぐ更新';

  @override
  String get appUpdateProcessing => '処理中...';

  @override
  String get appUpdateInvalidUrl => '更新先が無効です。しばらくしてから再試行してください。';

  @override
  String get appUpdateOpenUrlFailed => '更新リンクを開けませんでした。しばらくしてから再試行してください。';

  @override
  String get appUpdateDownloadInterrupted =>
      'ダウンロードが中断されました。ネットワークを確認して再試行してください。';

  @override
  String get appUpdatePackageVerificationFailed =>
      'パッケージの検証に失敗しました。もう一度ダウンロードしてください。';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'システム設定で$brandによる更新のインストールを許可してください。';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'システムインストーラーを開けませんでした。インストール権限を確認してください。';

  @override
  String get appUpdateGenericFailure => '更新に失敗しました。ネットワークを確認して再試行してください。';

  @override
  String get appUpdateUnavailable => '新しいバージョンはまだダウンロードできません。しばらくしてからお試しください。';

  @override
  String get appUpdateCheckFailed => '更新を確認できませんでした。しばらくしてから再試行してください。';

  @override
  String get appUpdateChecking => '確認中';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonSave => '保存';

  @override
  String get commonEdit => '編集';

  @override
  String get commonDelete => '削除';

  @override
  String get commonSearch => '検索';

  @override
  String get commonLoading => '読み込み中...';

  @override
  String get commonLoadFailed => '読み込みに失敗しました';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonEmpty => 'データがありません';

  @override
  String get commonCopy => 'コピー';

  @override
  String get commonForward => '転送';

  @override
  String get commonFavorite => 'お気に入り';

  @override
  String get commonClose => '閉じる';

  @override
  String get commonSend => '送信';

  @override
  String get commonDone => '完了';

  @override
  String get commonMore => 'もっと見る';

  @override
  String get commonSettings => '設定';

  @override
  String get commonCopied => 'コピーしました';

  @override
  String get commonUnknown => '不明';

  @override
  String get commonNotSet => '未設定';

  @override
  String get commonUnbound => '未登録';

  @override
  String get commonViewAll => 'すべて見る';

  @override
  String get commonSubmit => '送信';

  @override
  String get commonAdd => '追加';

  @override
  String get commonRemove => '削除';

  @override
  String get commonCreate => '作成';

  @override
  String get commonUpdate => '更新';

  @override
  String get commonUpload => 'アップロード';

  @override
  String get commonShare => '共有';

  @override
  String get commonBlock => 'ブロック';

  @override
  String get commonUnblock => 'ブロック解除';

  @override
  String get commonMute => '通知オフ';

  @override
  String get commonUnmute => '通知オン';

  @override
  String get commonPin => 'ピン留め';

  @override
  String get commonUnpin => 'ピン留め解除';

  @override
  String get commonMarkRead => '既読にする';

  @override
  String get commonMarkUnread => '未読にする';

  @override
  String get commonOnline => 'オンライン';

  @override
  String get commonOffline => 'オフライン';

  @override
  String get commonOperationFailed => '操作に失敗しました。もう一度お試しください';

  @override
  String get commonNetworkError => 'ネットワークエラーです。接続を確認してください';

  @override
  String get navMessages => 'トーク';

  @override
  String get navContacts => '連絡先';

  @override
  String get navMe => 'マイページ';

  @override
  String get authLoginTitle => 'StartLinkにログイン';

  @override
  String get authTabMobile => '電話番号';

  @override
  String get authTabEmail => 'メールアドレス';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => '電話番号を入力してください';

  @override
  String get authHintEmail => 'メールアドレスを入力してください';

  @override
  String get authHintPassword => 'パスワードを入力してください';

  @override
  String get authHintCode => '認証コードを入力してください';

  @override
  String get authHintLoginName => 'StartLink IDを入力してください（lpp_xxxxxxxx）';

  @override
  String get authLoginButton => 'ログイン';

  @override
  String get authGetCode => '認証コードを取得';

  @override
  String authResendCode(int seconds) {
    return '$seconds秒後に再送';
  }

  @override
  String get authUsePassword => 'パスワードでログイン';

  @override
  String get authUseCode => '認証コードでログイン';

  @override
  String get authAgreementPrefix => '利用規約とプライバシーポリシーに同意します';

  @override
  String get authAgreementAnd => 'および';

  @override
  String get authTermsLink => '利用規約';

  @override
  String get authPrivacyLink => 'プライバシーポリシー';

  @override
  String get authCaptchaTitle => 'セキュリティ確認';

  @override
  String get authCaptchaHint => '答えを入力してください';

  @override
  String get authCaptchaFailed => '認証コードの取得に失敗しました。もう一度お試しください';

  @override
  String get authErrorEmptyCode => '認証コードを入力してください';

  @override
  String get authErrorEmptyPassword => 'パスワードを入力してください';

  @override
  String get authErrorEmptyLoginName => 'StartLink IDを入力してください';

  @override
  String get authErrorWrongCredentials => 'アカウントまたはパスワードが正しくありません';

  @override
  String get authDeactivatingTitle => 'アカウント削除中';

  @override
  String get authDeactivatingContent =>
      'アカウントは削除の猶予期間中です（7日間）。\n\n削除をキャンセルするには「削除をキャンセル」をタップしてください。';

  @override
  String get authContinueUse => '続ける';

  @override
  String get authCancelDeactivation => '削除をキャンセル';

  @override
  String get authDeactivationCancelled => '削除がキャンセルされました';

  @override
  String get authDeactivationCancelFailed => 'キャンセルに失敗しました。もう一度お試しください';

  @override
  String get authLogout => 'ログアウト';

  @override
  String get authLogoutConfirm => 'ログアウトしてもよろしいですか？';

  @override
  String get authSendingCode => '送信中...';

  @override
  String get authCodeSent => '認証コードを送信しました';

  @override
  String get authLoginFailed => 'ログインに失敗しました。もう一度お試しください';

  @override
  String get authRegisterFailed => '登録に失敗しました。もう一度お試しください';

  @override
  String get authEnterpriseCode => '企業コード';

  @override
  String get authEnterpriseCodeHint => '企業コードを入力してください';

  @override
  String get authPendingApproval => '登録が完了しました。企業への参加申請が提出され、承認待ちです。';

  @override
  String get authNoAccount => 'アカウントをお持ちでないですか？';

  @override
  String get authRegisterNow => '今すぐ登録';

  @override
  String get authCountryPickerTitle => '国/地域を選択';

  @override
  String get authCountrySearchHint => '国/地域を検索';

  @override
  String get authCountryChinaMainland => '中国大陸';

  @override
  String get authCountryHongKong => '中国香港';

  @override
  String get authCountryMacau => '中国マカオ';

  @override
  String get authCountryTaiwan => '中国台湾';

  @override
  String get authCountryUnitedStates => 'アメリカ';

  @override
  String get authCountryUnitedKingdom => 'イギリス';

  @override
  String get authCountryJapan => '日本';

  @override
  String get authCountrySouthKorea => '韓国';

  @override
  String get authCountrySingapore => 'シンガポール';

  @override
  String get authCountryMalaysia => 'マレーシア';

  @override
  String get authCountryAustralia => 'オーストラリア';

  @override
  String get authCountryCanada => 'カナダ';

  @override
  String get authCountryGermany => 'ドイツ';

  @override
  String get authCountryFrance => 'フランス';

  @override
  String get authCountryIndia => 'インド';

  @override
  String get authCountryThailand => 'タイ';

  @override
  String get authCountryVietnam => 'ベトナム';

  @override
  String get authCountryIndonesia => 'インドネシア';

  @override
  String get authCountryPhilippines => 'フィリピン';

  @override
  String get authQuickLoginTitle => 'クイックログイン';

  @override
  String authQuickLoginSummary(int count) {
    return '$count 件のクイックログインアカウント。認証情報はホストから取得します。';
  }

  @override
  String get authQuickLoginProgress => 'ログイン中です。お待ちください';

  @override
  String get authRoleOwner => '所有者';

  @override
  String get authRoleAdministrator => '管理者';

  @override
  String get authRoleCustomerService => 'カスタマーサービス';

  @override
  String get authRoleTechnicalSupport => 'テクニカルサポート';

  @override
  String get authRoleEmployee => '従業員';

  @override
  String get authRoleMember => 'メンバー';

  @override
  String get authRoleEnterpriseCustomer => '企業顧客';

  @override
  String get authUnavailablePrefix => '利用不可 · ';

  @override
  String get authUnassignedService => '担当者未割り当て';

  @override
  String authAssignedService(String staff) {
    return '$staff が担当';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return '顧客 · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return '従業員 · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count 人';
  }

  @override
  String get authMetaPhone => '電話';

  @override
  String get authMetaIdentity => '身元';

  @override
  String get authRegisterTitle => '登録';

  @override
  String get authNickname => 'ニックネーム';

  @override
  String get authNicknameHint => 'ニックネームを設定';

  @override
  String get authPassword => 'パスワード';

  @override
  String get authPasswordSetHint => 'パスワードを設定（6文字以上）';

  @override
  String get authConfirmPassword => 'パスワードの確認';

  @override
  String get authConfirmPasswordHint => 'パスワードを再入力';

  @override
  String get authVerificationCode => '確認コード';

  @override
  String get authRegisterAndLogin => '登録してログイン';

  @override
  String get authHaveAccount => 'アカウントをお持ちですか？';

  @override
  String get authGoLogin => 'ログイン';

  @override
  String get authEmailVerificationUnavailable =>
      'メール認証を利用できません。携帯電話番号で登録してください。';

  @override
  String get authSmsVerificationUnavailable => 'SMS 認証を利用できません。メールで登録してください。';

  @override
  String get authSendFailed => '送信できませんでした。再試行してください。';

  @override
  String get authErrorEmptyNickname => 'ニックネームを入力してください';

  @override
  String get authErrorInvalidMobile => '有効な携帯電話番号を入力してください';

  @override
  String get authErrorInvalidEmail => '有効なメールアドレスを入力してください';

  @override
  String get authErrorPasswordTooShort => 'パスワードは6文字以上です';

  @override
  String get authErrorPasswordMismatch => 'パスワードが一致しません';

  @override
  String get authErrorVerificationRequired => '確認コードを取得して入力してください';

  @override
  String get authRegisterErrorTitle => '登録できませんでした';

  @override
  String get authGotIt => '了解';

  @override
  String get authJoinCredentialHint => '招待コードを入力';

  @override
  String authTenantNotFound(String code) {
    return '企業「$code」が見つかりません。企業コードを確認してください。';
  }

  @override
  String get authTenantSearchFailed => '検索できませんでした。再試行してください。';

  @override
  String get authInvitationInvalid => '招待コードが無効です。確認して再試行してください。';

  @override
  String get authCollapseJoin => '参加情報を閉じる';

  @override
  String get authExpandJoin => '企業に参加しますか？招待コード（任意）';

  @override
  String authInvitationValid(String name) {
    return '有効な招待：$name';
  }

  @override
  String authTenantFound(String name) {
    return '企業が見つかりました：$name';
  }

  @override
  String get authJoinNotFound => '招待コードが無効か、存在しません';

  @override
  String get authJoinHelp => '企業から提供された招待コードを入力すると、登録後に参加できます。';

  @override
  String get authSelectOrganization => '組織を選択';

  @override
  String get authNoOrganization => '利用できる組織がありません';

  @override
  String get authNoOrganizationHint => '管理者に組織への招待を依頼してください';

  @override
  String get authPersonalSpace => '個人スペース';

  @override
  String get authPersonalSpaceSubtitle => '友達とのチャットと個人のお気に入り';

  @override
  String get authSpaceIdentityValidationFailed =>
      'スペースの身元を確認できませんでした。再試行してください。';

  @override
  String get authPersonalSpaceRestoreFailed => '個人スペースを復元できませんでした。再試行してください。';

  @override
  String get authJoinEnterpriseFailed => '企業に参加できませんでした。後で再試行してください。';

  @override
  String get homeTitle => 'トーク';

  @override
  String get homeGatewayConnectingTitle => '接続中';

  @override
  String get homePersonalSpace => '個人スペース';

  @override
  String get homeOfficialService => '公式サービス';

  @override
  String get homeSwitchSpace => 'スペース切替';

  @override
  String get homeSpaceSubtitle => '個人 · 企業';

  @override
  String get homeJoinEnterprise => '企業に参加';

  @override
  String get homeCreateGroup => 'グループ作成';

  @override
  String get homeAddFriend => '友達追加';

  @override
  String get homeScan => 'QRコードスキャン';

  @override
  String get homeJoinNewSpace => '新しいスペースに参加';

  @override
  String get homeSearchConversation => 'トークを検索';

  @override
  String get homeNoMessages => 'メッセージはありません';

  @override
  String get homeDeleteConversation => 'トークを削除';

  @override
  String get homeDeleteConversationConfirm => 'このトークを削除しますか？履歴も削除されます。';

  @override
  String get homePersonalNote => '自分（個人メモ）';

  @override
  String get homeWorkNote => '自分（仕事メモ）';

  @override
  String homeConversationCount(int count) {
    return '$count件のトーク';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count件の未読';
  }

  @override
  String get chatInputHint => 'メッセージを入力...';

  @override
  String get chatVoiceHint => '押して話す';

  @override
  String get chatVoiceRelease => '離して送信';

  @override
  String get chatVoiceCancel => '上にスライドでキャンセル';

  @override
  String get chatMenuCopy => 'コピー';

  @override
  String get chatMenuForward => '転送';

  @override
  String get chatMenuRecall => '取り消し';

  @override
  String get chatMenuDelete => '削除';

  @override
  String get chatMenuFavorite => 'お気に入り';

  @override
  String get chatMenuReply => '返信';

  @override
  String get chatMenuMultiSelect => '複数選択';

  @override
  String get chatMenuTranslate => '翻訳';

  @override
  String get chatMenuVoiceToText => 'テキスト変換';

  @override
  String get chatMenuTextToSpeech => '読み上げ';

  @override
  String get chatStatusRecalled => 'メッセージが取り消されました';

  @override
  String get chatRecallSuccess => '取り消しました';

  @override
  String get chatRecallFailed => '取り消しに失敗しました';

  @override
  String get chatRecallTimeout => '2分以上経過したメッセージは取り消せません';

  @override
  String get chatTranslateFailed => '翻訳に失敗しました。もう一度お試しください';

  @override
  String get chatTranslateNotConfigured => '翻訳サービスは現在利用できません';

  @override
  String get chatVoiceToTextFailed => '変換に失敗しました。もう一度お試しください';

  @override
  String get chatTextToSpeechFailed => '読み上げに失敗しました。もう一度お試しください';

  @override
  String get chatVoiceToText => '文字起こし';

  @override
  String get chatForwardSuccess => '転送しました';

  @override
  String get chatForwardFailed => '転送に失敗しました。もう一度お試しください';

  @override
  String get chatNoConversations => '転送先のトークがありません';

  @override
  String get chatSendFailed => '送信に失敗しました';

  @override
  String get chatResend => '再送信';

  @override
  String get chatNotFriend => '友達ではありません';

  @override
  String get chatNotFriendHint => 'まだ友達ではないため、メッセージを送信できません';

  @override
  String get chatMutedHint => '全員ミュート中';

  @override
  String get chatFileUploadFailed => 'ファイルのアップロードに失敗しました';

  @override
  String get chatFileStatusNotDownloaded => '未ダウンロード';

  @override
  String get chatFileStatusDownloaded => 'ダウンロード済み';

  @override
  String get chatFileStatusUploading => 'アップロード中';

  @override
  String get chatFileStatusUploadFailed => 'アップロード失敗';

  @override
  String get chatCardSendFailed => '連絡先カードの送信に失敗しました';

  @override
  String get chatFavoriteSuccess => 'お気に入りに追加しました';

  @override
  String get chatFavoriteFailed => 'お気に入りへの追加に失敗しました';

  @override
  String get chatLoadFailed => '読み込みに失敗しました';

  @override
  String get chatImageMessage => '[画像]';

  @override
  String get chatVoiceMessage => '[音声]';

  @override
  String get chatVideoMessage => '[動画]';

  @override
  String get chatFileMessage => '[ファイル]';

  @override
  String get chatLocationMessage => '[位置情報]';

  @override
  String get chatContactCardMessage => '[連絡先]';

  @override
  String get chatCallLogMessage => '[通話履歴]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return '$count人が既読';
  }

  @override
  String get chatUnread => '未読';

  @override
  String get chatRecalledSelf => 'メッセージを取り消しました';

  @override
  String chatRecalledPeer(String sender) {
    return '$senderがメッセージを取り消しました';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return '翻訳：$translation';
  }

  @override
  String get chatMessageDeleted => 'メッセージは削除されました';

  @override
  String get chatPeer => '相手';

  @override
  String get chatSelf => '自分';

  @override
  String get chatGenericMessage => '[メッセージ]';

  @override
  String get chatVoiceHideText => '文字を隠す';

  @override
  String get chatVoiceShowText => '文字に変換';

  @override
  String get chatFileDefaultName => 'ファイル';

  @override
  String get chatContactDefaultName => '連絡先';

  @override
  String get chatContactCardTitle => '連絡先カード';

  @override
  String get chatCallMissed => '未応答';

  @override
  String get chatCallCancelled => 'キャンセル済み';

  @override
  String get chatCallRejected => '拒否済み';

  @override
  String get chatCallDisconnected => '接続が切断されました';

  @override
  String get chatCallEnded => '通話終了';

  @override
  String get chatCallFailed => '通話失敗';

  @override
  String chatCallDuration(String duration) {
    return '通話時間 $duration';
  }

  @override
  String get chatVideoCallTitle => 'ビデオ通話';

  @override
  String get chatVoiceCallTitle => '音声通話';

  @override
  String get chatToolPhotos => '写真';

  @override
  String get chatToolCamera => '撮影';

  @override
  String get chatToolFile => 'ファイル';

  @override
  String get chatToolLocation => '位置情報';

  @override
  String get chatToolContactCard => '連絡先';

  @override
  String get chatToolVoiceCall => '音声通話';

  @override
  String get chatToolVideoCall => 'ビデオ通話';

  @override
  String get chatToolFavorites => 'お気に入り';

  @override
  String get chatToolTranslate => '翻訳';

  @override
  String get chatTranslationChooseLanguage => '翻訳先の言語を選択';

  @override
  String get chatTranslationEnterText => '先に文字を入力してください';

  @override
  String get chatTranslationMentionsUnsupported => 'メンションを含むメッセージは翻訳できません';

  @override
  String get chatTranslationScheduledUnsupported => '予約メッセージの編集中は翻訳できません';

  @override
  String get chatTranslationFailed => '翻訳に失敗しました。再試行してください';

  @override
  String get chatTranslationEmpty => '翻訳結果がありません。再試行してください';

  @override
  String get chatTranslationTranslating => '翻訳中…';

  @override
  String get chatTranslationSend => '翻訳を送信';

  @override
  String get chatTranslationSending => '送信中…';

  @override
  String get chatTranslationExpand => '全文を表示';

  @override
  String get chatTranslationCollapse => '折りたたむ';

  @override
  String get chatFileTooLarge => 'ファイルサイズが上限を超えています（100 MB）';

  @override
  String get chatInputMutedAdminOnly => 'オーナーまたは指定メンバーのみ発言できます';

  @override
  String get chatImageUploadUnsupported => '画像のアップロードに失敗しました。サーバーはまだ対応していません。';

  @override
  String get chatFavoriteLongPressHint => 'メッセージを長押ししてお気に入りに追加してください';

  @override
  String chatSelectedCount(int count) {
    return '$count件選択中';
  }

  @override
  String get chatLocationSheetTitle => '位置情報を送信';

  @override
  String get chatLocationNameLabel => '場所名';

  @override
  String get chatLocationNameHint => '例：会社、顧客住所';

  @override
  String get chatLocationAddressLabel => '住所';

  @override
  String get chatLocationOptionalHint => '任意';

  @override
  String get chatLocationLatitudeLabel => '緯度';

  @override
  String get chatLocationLatitudeHint => '-90 から 90';

  @override
  String get chatLocationLongitudeLabel => '経度';

  @override
  String get chatLocationLongitudeHint => '-180 から 180';

  @override
  String chatLocationValidationRequired(String label) {
    return '$labelを入力してください';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$labelの範囲が正しくありません';
  }

  @override
  String get chatLocationDefaultTitle => '位置情報';

  @override
  String get chatMutedFullNotice => 'このグループは全員ミュート中です。オーナーまたは指定メンバーのみ発言できます';

  @override
  String get chatNotFriendSendBlocked => '相手と友達ではないため、メッセージを送信できません';

  @override
  String get chatPersonalNotesTitle => '個人メモ';

  @override
  String get chatWorkNotesTitle => '仕事メモ';

  @override
  String get chatPersonalNotesDescription =>
      '個人的な考えや大切な情報をここに保存\n端末間で同期され、いつでも確認できます';

  @override
  String get chatWorkNotesDescription =>
      '仕事のタスクや資料をここに保存\nチームスペースは独立して安全に管理されます';

  @override
  String get chatNoMessages => 'メッセージはありません';

  @override
  String chatReplyTo(String sender) {
    return '$senderに返信';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature は近日公開予定です';
  }

  @override
  String get chatForwardSelectTitle => 'トークを選択';

  @override
  String get chatContactSelectTitle => '連絡先を選択';

  @override
  String get chatNoContacts => '連絡先がありません';

  @override
  String get contactsTitle => '連絡先';

  @override
  String get contactsSearch => '連絡先を検索';

  @override
  String get contactsNewFriends => '新しい友達';

  @override
  String get contactsGroups => 'グループ';

  @override
  String get contactsFavorites => 'お気に入り';

  @override
  String get contactsRecent => '最近の連絡先';

  @override
  String get contactsOrganization => '組織図';

  @override
  String get contactsAnnouncement => 'お知らせ';

  @override
  String get contactsNewApplications => '新しい申請';

  @override
  String get contactsCustomerGroups => '顧客グループ';

  @override
  String get contactsAllCustomers => 'すべての顧客';

  @override
  String get contactsMyCustomers => '担当顧客';

  @override
  String get contactsViewAll => 'すべて見る';

  @override
  String get contactsMyContacts => '連絡先';

  @override
  String get contactsMyAdvisor => '担当アドバイザー';

  @override
  String get contactsNoAdvisor => '担当者が割り当てられていません';

  @override
  String get contactsAdvisorLoading => '読み込み中...';

  @override
  String get contactsNavigateFailed => '移動に失敗しました。もう一度お試しください';

  @override
  String get contactsEmpty => '連絡先がありません';

  @override
  String get contactsNoAnnouncement => 'お知らせはありません';

  @override
  String get contactsOfficialBadge => '公式';

  @override
  String get contactsCustomerBadge => '顧客';

  @override
  String get contactsEmptyCustomers => '顧客がいません';

  @override
  String get myTitle => 'マイページ';

  @override
  String get myEnterpriseInfo => '企業情報';

  @override
  String get myEnterpriseManage => '企業管理';

  @override
  String get myQrCode => 'QRコード名刺';

  @override
  String get myFavorites => 'お気に入り';

  @override
  String get myLanguage => '言語';

  @override
  String get myTimezone => 'タイムゾーン';

  @override
  String get myAutoTranslate => '自動翻訳';

  @override
  String get myNetworkSwitch => 'ネットワーク';

  @override
  String get mySettings => '設定';

  @override
  String get myLogout => 'ログアウト';

  @override
  String get myLogoutConfirm => 'ログアウトしてもよろしいですか？';

  @override
  String get myLeaveEnterprise => '企業を退出';

  @override
  String get myLeaveEnterpriseConfirm => 'この企業を退出しますか？退出後は企業データにアクセスできなくなります。';

  @override
  String get myLeaveEnterpriseSuccess => '企業を退出しました';

  @override
  String get myLeaveEnterpriseFailed => '退出に失敗しました。もう一度お試しください';

  @override
  String get myLppIdCopied => 'StartLink IDをコピーしました';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count人の友達';
  }

  @override
  String get myAutoSelect => '自動';

  @override
  String get myPresenceStatus => 'オンライン状態';

  @override
  String get myPresenceStatusTitle => 'オンライン状態を設定';

  @override
  String get myPresenceOnline => 'オンライン';

  @override
  String get myPresenceBusy => '取り込み中';

  @override
  String get myPresenceAway => '離席中';

  @override
  String get myPresenceInvisible => '非表示';

  @override
  String get profileTitle => 'プロフィール';

  @override
  String get profileName => '名前';

  @override
  String get profileGender => '性別';

  @override
  String get profileBirthday => '誕生日';

  @override
  String get profileRegion => '地域';

  @override
  String get profileSignature => '自己紹介';

  @override
  String get profileSignatureHint => '自己紹介を入力してください';

  @override
  String get profileTapTapText => 'タップタップ';

  @override
  String get profileTapTapHint => 'タップ時に表示するテキスト（最大20文字）';

  @override
  String get profileAccountSection => 'アカウント';

  @override
  String get profileBasicSection => '基本情報';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => '未設定';

  @override
  String get profileMobile => '電話番号';

  @override
  String get profileMobileUnbound => '未登録';

  @override
  String get profileEmail => 'メールアドレス';

  @override
  String get profileEmailUnbound => '未登録';

  @override
  String get profileQrCode => 'マイQRコード';

  @override
  String get profileChangePassword => 'パスワード変更';

  @override
  String get profileGenderMale => '男性';

  @override
  String get profileGenderFemale => '女性';

  @override
  String get profileGenderOther => 'その他';

  @override
  String get profileGenderUnset => '未設定';

  @override
  String get profileSaveFailed => '保存に失敗しました。もう一度お試しください';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce => 'StartLink IDは一度しか変更できません。慎重に入力してください。';

  @override
  String get profileLppIdChangeFailed => '変更に失敗しました（StartLink IDは一度しか変更できません）';

  @override
  String get profileChangePasswordOld => '現在のパスワード';

  @override
  String get profileChangePasswordNew => '新しいパスワード';

  @override
  String get profileChangePasswordConfirm => '新しいパスワードを確認';

  @override
  String get profileChangePasswordMismatch => 'パスワードが一致しません';

  @override
  String get profileChangePasswordSuccess => 'パスワードを変更しました。再度ログインしてください。';

  @override
  String get profileChangePasswordFailed => 'パスワードの変更に失敗しました。もう一度お試しください';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSectionEnterprise => '企業';

  @override
  String get settingsSectionAccount => 'アカウント';

  @override
  String get settingsSectionGeneral => '一般';

  @override
  String get settingsSectionFeatures => '機能';

  @override
  String get settingsSectionAbout => 'このアプリについて';

  @override
  String get settingsEnterpriseInfo => '企業情報';

  @override
  String get settingsProfile => 'プロフィール';

  @override
  String get settingsAccountSecurity => 'アカウントセキュリティ';

  @override
  String get settingsNotification => '通知';

  @override
  String get settingsDisplay => '表示';

  @override
  String get settingsFriendPrivacy => 'プライバシー';

  @override
  String get settingsChat => 'トーク';

  @override
  String get settingsChatHistory => 'トーク履歴';

  @override
  String get settingsAbout => 'StartLinkについて';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsTimezone => 'タイムゾーン';

  @override
  String get settingsAutoTranslate => '自動翻訳';

  @override
  String get settingsNetworkSwitch => 'ネットワーク';

  @override
  String get enterpriseInfoTitle => '企業情報';

  @override
  String get enterpriseName => '企業名';

  @override
  String get enterpriseDescription => '企業概要';

  @override
  String get enterpriseUpdateSuccess => '更新しました';

  @override
  String get enterpriseUpdateFailed => '更新に失敗しました。もう一度お試しください';

  @override
  String get enterpriseLeave => '企業を退出';

  @override
  String get enterpriseLeaveConfirm => 'この企業を退出しますか？';

  @override
  String get enterpriseLeaveSuccess => '企業を退出しました';

  @override
  String get enterpriseLeaveFailed => '退出に失敗しました。もう一度お試しください';

  @override
  String get enterpriseLeaveOwnerError => 'オーナーは直接退出できません。先にオーナー権限を譲渡してください。';

  @override
  String get enterpriseMemberCount => 'メンバー数';

  @override
  String get enterpriseCreatedAt => '作成日';

  @override
  String get enterpriseCode => '企業コード';

  @override
  String get enterpriseInviteMembers => 'メンバーを招待';

  @override
  String get enterpriseCopyInviteCode => '招待コードをコピー';

  @override
  String get enterpriseInviteCodeCopied => '招待コードをコピーしました';

  @override
  String get groupCreateTitle => 'グループを作成';

  @override
  String get groupNameHint => 'グループ名を入力してください';

  @override
  String get groupCreateSuccess => 'グループを作成しました';

  @override
  String get groupCreateFailed => 'グループの作成に失敗しました';

  @override
  String get groupSettings => 'グループ設定';

  @override
  String get groupName => 'グループ名';

  @override
  String get groupAvatar => 'グループアイコン';

  @override
  String get groupAnnouncement => 'お知らせ';

  @override
  String get groupMembers => 'メンバー';

  @override
  String get groupAddMember => 'メンバーを追加';

  @override
  String get groupRemoveMember => 'メンバーを削除';

  @override
  String get groupRemoveMemberConfirm => 'このメンバーを削除しますか？';

  @override
  String get groupSetAdmin => '管理者に設定';

  @override
  String get groupRemoveAdmin => '管理者を解除';

  @override
  String get groupTransferOwner => 'オーナーを譲渡';

  @override
  String get groupTransferOwnerConfirm => 'このメンバーにオーナーを譲渡しますか？';

  @override
  String get groupTransferOwnerSuccess => 'オーナーを譲渡しました';

  @override
  String get groupTransferOwnerFailed => '譲渡に失敗しました。もう一度お試しください';

  @override
  String get groupLeave => 'グループを退出';

  @override
  String get groupLeaveConfirm => 'このグループを退出しますか？';

  @override
  String get groupLeaveSuccess => 'グループを退出しました';

  @override
  String get groupLeaveFailed => '退出に失敗しました。もう一度お試しください';

  @override
  String get groupDissolve => 'グループを解散';

  @override
  String get groupDissolveConfirm => 'このグループを解散しますか？全メンバーが削除されます。';

  @override
  String get groupDissolveSuccess => 'グループを解散しました';

  @override
  String get groupDissolveFailed => '解散に失敗しました。もう一度お試しください';

  @override
  String get groupQrCode => 'グループQRコード';

  @override
  String get groupMuteAll => '全員ミュート';

  @override
  String get groupMuteAllOn => '全員ミュートをオン';

  @override
  String get groupMuteAllOff => '全員ミュートをオフ';

  @override
  String get groupAllowMemberInvite => 'メンバーの招待を許可';

  @override
  String get groupAllowMemberModifyTitle => 'メンバーのグループ名変更を許可';

  @override
  String get groupAllowMemberAtAll => 'メンバーの@全員を許可';

  @override
  String get groupAllowMemberViewMemberList => 'メンバーリストの閲覧を許可';

  @override
  String get groupAllowQrCodeJoin => 'QRコードでの参加を許可';

  @override
  String get groupRequireApproval => '参加に承認が必要';

  @override
  String get groupAllowMemberAddFriend => 'メンバー同士の友達追加を許可';

  @override
  String get groupRoleOwner => 'オーナー';

  @override
  String get groupRoleAdmin => '管理者';

  @override
  String get groupRoleMember => 'メンバー';

  @override
  String get groupNoMembers => 'メンバーがいません';

  @override
  String get groupNoAnnouncements => 'お知らせはありません';

  @override
  String get groupCreateAnnouncement => 'お知らせを投稿';

  @override
  String get groupEditAnnouncement => 'お知らせを編集';

  @override
  String get groupDeleteAnnouncement => 'お知らせを削除';

  @override
  String get groupDeleteAnnouncementConfirm => 'このお知らせを削除しますか？';

  @override
  String get groupAnnouncementTitle => 'タイトル';

  @override
  String get groupAnnouncementContent => '内容';

  @override
  String get groupAnnouncementPin => 'お知らせをピン留め';

  @override
  String groupMemberCount(int count) {
    return '$count人';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count人を選択中';
  }

  @override
  String get groupJoinRequestApprove => '承認';

  @override
  String get groupJoinRequestReject => '拒否';

  @override
  String get groupJoinRequests => '参加申請';

  @override
  String get groupNoJoinRequests => '参加申請はありません';

  @override
  String get groupReadReceipts => '既読確認';

  @override
  String groupReadCount(int count) {
    return '$count人が既読';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count人が未読';
  }

  @override
  String get friendAddTitle => '友達を追加';

  @override
  String get friendSearchHint => '電話番号 / メール / StartLink ID';

  @override
  String get friendRequestSent => '友達申請を送りました';

  @override
  String get friendRequestFailed => '送信に失敗しました。もう一度お試しください';

  @override
  String get friendAlreadyFriend => 'すでに友達です';

  @override
  String get friendNewFriendsTitle => '新しい友達';

  @override
  String get friendNoRequests => '友達申請はありません';

  @override
  String get friendAccept => '承認';

  @override
  String get friendReject => '拒否';

  @override
  String get friendAccepted => '承認しました';

  @override
  String get friendRejected => '拒否しました';

  @override
  String get friendDeleteConfirm => 'この友達を削除しますか？';

  @override
  String get friendDeleteSuccess => '友達を削除しました';

  @override
  String get friendDeleteFailed => '削除に失敗しました。もう一度お試しください';

  @override
  String get friendRemarkName => 'ニックネーム';

  @override
  String get friendGroupName => 'グループ';

  @override
  String get friendSendMessage => 'メッセージを送る';

  @override
  String get friendMatchTypeLppId => 'StartLink IDで一致';

  @override
  String get friendMatchTypeMobile => '電話番号で一致';

  @override
  String get friendMatchTypeEmail => 'メールアドレスで一致';

  @override
  String get friendSearchEmpty => 'ユーザーが見つかりません';

  @override
  String get friendAddMessage => '友達申請を送りたいです';

  @override
  String get friendBlockConfirm => 'このユーザーをブロックしますか？';

  @override
  String get friendUnblockConfirm => 'ブロックを解除しますか？';

  @override
  String get friendBlockSuccess => 'ブロックしました';

  @override
  String get friendUnblockSuccess => 'ブロックを解除しました';

  @override
  String get profilePageTitle => 'プロフィール';

  @override
  String get profilePageSendMessage => 'メッセージを送る';

  @override
  String get profilePageAddFriend => '友達追加';

  @override
  String get profilePageAlreadyFriend => '友達です';

  @override
  String get profilePageBlocked => 'ブロック中';

  @override
  String get profilePageBlock => 'ブロック';

  @override
  String get profilePageUnblock => 'ブロック解除';

  @override
  String get profilePageHidden => 'このユーザーはプロフィールを非公開にしています';

  @override
  String get profilePageFriendsOnly => 'このユーザーは友達にのみプロフィールを公開しています';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'ニックネーム';

  @override
  String get profilePageEditRemark => 'ニックネームを編集';

  @override
  String get profilePageSaveRemarkSuccess => 'ニックネームを保存しました';

  @override
  String get profilePageSaveRemarkFailed => '保存に失敗しました。もう一度お試しください';

  @override
  String get searchTitle => '検索';

  @override
  String get searchHint => '電話番号、メール、またはStartLink IDで検索';

  @override
  String get searchNoResults => '結果が見つかりません';

  @override
  String get searchMessages => 'メッセージ';

  @override
  String get searchUsers => 'ユーザー';

  @override
  String get searchFailed => '検索に失敗しました。もう一度お試しください';

  @override
  String get scanTitle => 'QRコードスキャン';

  @override
  String get scanFailed => '認識に失敗しました。もう一度お試しください';

  @override
  String get scanInvalidQrCode => '無効なQRコードです';

  @override
  String get scanFlashOn => 'フラッシュをオン';

  @override
  String get scanFlashOff => 'フラッシュをオフ';

  @override
  String get scanAlbum => 'アルバムから選択';

  @override
  String get favoritesTitle => 'お気に入り';

  @override
  String get favoritesEmpty => 'お気に入りはありません';

  @override
  String get favoritesAll => 'すべて';

  @override
  String get favoritesText => 'テキスト';

  @override
  String get favoritesImage => '画像';

  @override
  String get favoritesVideo => '動画';

  @override
  String get favoritesVoice => '音声';

  @override
  String get favoritesFile => 'ファイル';

  @override
  String get favoritesOther => 'その他';

  @override
  String get favoritesDeleteConfirm => 'お気に入りから削除しますか？';

  @override
  String get favoritesDeleteSuccess => 'お気に入りから削除しました';

  @override
  String get favoritesDeleteFailed => '削除に失敗しました';

  @override
  String get favoritesOriginalRecalled => 'メッセージが取り消されました';

  @override
  String get favoritesViewOriginal => '元のメッセージを見る';

  @override
  String get favoritesSearchHint => 'お気に入りを検索';

  @override
  String get favoritesNoResults => '該当するお気に入りが見つかりません';

  @override
  String get noticeTitle => 'お知らせ';

  @override
  String get noticeEmpty => 'お知らせはありません';

  @override
  String get noticeDetail => 'お知らせ詳細';

  @override
  String get noticePublishedAt => '投稿日時';

  @override
  String get noticePriorityNormal => '通常';

  @override
  String get noticePriorityImportant => '重要';

  @override
  String get noticePriorityUrgent => '緊急';

  @override
  String get organizationTitle => '組織図';

  @override
  String get organizationEmpty => '部門情報がありません';

  @override
  String get organizationMembers => 'メンバー';

  @override
  String get organizationDepartment => '部門';

  @override
  String get organizationPosition => '役職';

  @override
  String get organizationLeader => 'リーダー';

  @override
  String get qrCodeTitle => 'マイQRコード';

  @override
  String get qrCodeSave => 'アルバムに保存';

  @override
  String get qrCodeShare => '共有';

  @override
  String get qrCodeSaveSuccess => 'アルバムに保存しました';

  @override
  String get qrCodeSaveFailed => '保存に失敗しました。もう一度お試しください';

  @override
  String get qrCodeRefresh => 'QRコードを更新';

  @override
  String get qrCodeExpired => 'QRコードの有効期限が切れました。更新してください';

  @override
  String get qrCodeScanToAdd => 'QRコードをスキャンして友達追加';

  @override
  String get spacePersonal => '個人スペース';

  @override
  String get spaceEnterprise => '企業スペース';

  @override
  String get spaceJoinByCode => '企業コードで参加';

  @override
  String get spaceJoinByInvite => '招待コードで参加';

  @override
  String get spaceEnterCode => '企業コードを入力してください';

  @override
  String get spaceEnterInviteCode => '招待コードを入力してください';

  @override
  String get spaceSearchEnterprise => '企業を検索';

  @override
  String get spaceJoinRequestSent => '申請を送りました。承認をお待ちください';

  @override
  String get spaceJoinRequestPending => '承認待ちです';

  @override
  String get spaceJoinRequestApproved => '申請が承認されました';

  @override
  String get spaceJoinRequestRejected => '申請が拒否されました';

  @override
  String get spaceAlreadyMember => 'すでにメンバーです';

  @override
  String get spaceAutoApproved => '自動承認されました。ようこそ！';

  @override
  String get spacePendingApprovalHint => '登録が完了しました。参加申請が提出され、承認待ちです。';

  @override
  String get spaceNoSpaces => 'スペースがありません';

  @override
  String get spaceInviteExpired => '招待コードの有効期限が切れています';

  @override
  String get spaceInviteTargetMismatch => 'この招待コードはあなたのアカウントには使用できません';

  @override
  String get spaceAcceptInviteSuccess => '企業に参加しました';

  @override
  String get spaceAcceptInviteFailed => '参加に失敗しました。もう一度お試しください';

  @override
  String get spaceTenantSelectTitle => 'スペースを選択';

  @override
  String get spaceTenantSelectHint => '入るスペースを選択してください';

  @override
  String get spaceEnterPersonal => '個人スペースに入る';

  @override
  String get spaceEnterEnterprise => '企業スペースに入る';

  @override
  String get aboutTitle => 'StartLinkについて';

  @override
  String get aboutVersion => 'バージョン';

  @override
  String get aboutTerms => '利用規約';

  @override
  String get aboutPrivacy => 'プライバシーポリシー';

  @override
  String get aboutOpenSource => 'オープンソースライセンス';

  @override
  String get aboutCheckUpdate => 'アップデートを確認';

  @override
  String get aboutLatestVersion => '最新バージョンです';

  @override
  String get aboutUpdateAvailable => 'アップデートがあります';

  @override
  String get aboutUpdateNow => '今すぐアップデート';

  @override
  String get aboutUpdateLater => '後で';

  @override
  String get notificationTitle => '通知';

  @override
  String get notificationGlobalMute => 'おやすみモード';

  @override
  String get notificationSound => 'サウンド';

  @override
  String get notificationVibration => 'バイブレーション';

  @override
  String get notificationPreview => '通知プレビュー';

  @override
  String get notificationDndStart => 'おやすみ開始時間';

  @override
  String get notificationDndEnd => 'おやすみ終了時間';

  @override
  String get blacklistTitle => 'ブロックリスト';

  @override
  String get blacklistEmpty => 'ブロックしているユーザーはいません';

  @override
  String get blacklistRemove => 'ブロック解除';

  @override
  String get blacklistRemoveConfirm => 'このユーザーのブロックを解除しますか？';

  @override
  String get feedbackTitle => 'フィードバック';

  @override
  String get feedbackTypeComplaint => '苦情';

  @override
  String get feedbackTypeSuggestion => '提案';

  @override
  String get feedbackTypeBug => 'バグ報告';

  @override
  String get feedbackContent => '内容';

  @override
  String get feedbackContentHint => '問題や提案を詳しく説明してください';

  @override
  String get feedbackContact => '連絡先（任意）';

  @override
  String get feedbackSubmit => '送信';

  @override
  String get feedbackSuccess => 'フィードバックを送信しました。ありがとうございます！';

  @override
  String get feedbackFailed => '送信に失敗しました。もう一度お試しください';

  @override
  String get networkTitle => 'ネットワーク';

  @override
  String get networkAutoSelect => '自動';

  @override
  String get networkManual => '手動';

  @override
  String get timezoneTitle => 'タイムゾーン';

  @override
  String get timezoneAuto => 'システムに従う';

  @override
  String get autoTranslateTitle => '自動翻訳';

  @override
  String get autoTranslateEnabled => '自動翻訳を有効にする';

  @override
  String get autoTranslateLanguage => '翻訳先の言語';

  @override
  String get displayTitle => '表示';

  @override
  String get displayFontSize => '文字サイズ';

  @override
  String get displayChatBackground => 'トーク背景';

  @override
  String get displayDarkMode => 'ダーク';

  @override
  String get displayDarkModeSystem => 'システムに従う';

  @override
  String get displayDarkModeSystemHint => 'システム設定に従って自動切替';

  @override
  String get displayDarkModeOff => 'ライト';

  @override
  String get displayDarkModeOffHint => '常にライトテーマを使用';

  @override
  String get displayDarkModeOn => 'ダーク';

  @override
  String get displayDarkModeOnHint => '常にダークテーマを使用';

  @override
  String get chatSettingsTitle => 'トーク';

  @override
  String get chatHistoryTitle => 'トーク履歴';

  @override
  String get chatHistoryClear => '履歴をすべて削除';

  @override
  String get chatHistoryClearConfirm => 'すべてのトーク履歴を削除しますか？この操作は元に戻せません。';

  @override
  String get chatHistoryClearSuccess => 'トーク履歴を削除しました';

  @override
  String get accountSecurityTitle => 'アカウントセキュリティ';

  @override
  String get accountSecurityChangePassword => 'パスワード変更';

  @override
  String get accountSecurityChangeMobile => '電話番号変更';

  @override
  String get accountSecurityChangeEmail => 'メールアドレス変更';

  @override
  String get accountSecurityLoggedDevices => 'ログイン中のデバイス';

  @override
  String get accountSecurityDeactivate => 'アカウント削除';

  @override
  String get accountSecurityDeactivateConfirm =>
      'アカウントを削除すると、7日後にすべてのデータが完全に削除されます。削除しますか？';

  @override
  String get loggedDevicesTitle => 'ログイン中のデバイス';

  @override
  String get loggedDevicesCurrent => 'このデバイス';

  @override
  String get loggedDevicesRevoke => 'ログアウト';

  @override
  String get loggedDevicesRevokeConfirm => 'このデバイスからログアウトしますか？';

  @override
  String get loggedDevicesRevokeSuccess => 'デバイスからログアウトしました';

  @override
  String get loggedDevicesRevokeFailed => '失敗しました。もう一度お試しください';

  @override
  String get loggedDevicesLastActive => '最終アクティブ';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'ウェブ';

  @override
  String get loggedDevicesTypeDesktop => 'デスクトップ';

  @override
  String get loggedDevicesTypeUnknown => '不明なデバイス';

  @override
  String get privacySettingsTitle => 'プライバシー';

  @override
  String get privacySearchableByMobile => '電話番号での検索を許可';

  @override
  String get privacySearchableByLppId => 'StartLink IDでの検索を許可';

  @override
  String get privacyAllowFriendRequest => '友達申請を許可';

  @override
  String get privacyProfileVisibility => 'プロフィールの公開範囲';

  @override
  String get privacyEveryone => '全員';

  @override
  String get privacyFriendsOfFriends => '友達の友達';

  @override
  String get privacyNobody => '非公開';

  @override
  String get privacyFriendsOnly => '友達のみ';

  @override
  String get privacySaveSuccess => '設定を保存しました';

  @override
  String get privacySaveFailed => '保存に失敗しました。もう一度お試しください';

  @override
  String get fontSizeTitle => '文字サイズ';

  @override
  String get fontSizeSmall => '小';

  @override
  String get fontSizeNormal => '標準';

  @override
  String get fontSizeLarge => '大';

  @override
  String get fontSizeExtraLarge => '特大';

  @override
  String get fontSizePreview => 'プレビュー';

  @override
  String get chatBackgroundTitle => 'トーク背景';

  @override
  String get chatBackgroundDefault => 'デフォルト';

  @override
  String get chatBackgroundCustom => 'カスタム';

  @override
  String get chatBackgroundReset => 'デフォルトに戻す';

  @override
  String get termsTitle => '利用規約';

  @override
  String get privacyPolicyTitle => 'プライバシーポリシー';

  @override
  String get recentContactsTitle => '最近の連絡先';

  @override
  String get recentContactsEmpty => '最近の連絡先はありません';

  @override
  String get inviteFriendsTitle => '友達を招待';

  @override
  String get inviteFriendsCopyLink => '招待リンクをコピー';

  @override
  String get inviteFriendsLinkCopied => '招待リンクをコピーしました';

  @override
  String get imageViewerTitle => '写真';

  @override
  String get imageViewerSave => 'アルバムに保存';

  @override
  String get imageViewerSaveSuccess => 'アルバムに保存しました';

  @override
  String get imageViewerSaveFailed => '保存に失敗しました。もう一度お試しください';

  @override
  String get customerServiceTitle => 'カスタマーサービス';

  @override
  String get customerServiceQueue => '待機中';

  @override
  String get customerServiceActive => '対応中';

  @override
  String get customerServiceClaim => '受付';

  @override
  String get customerServiceTakeover => '引き継ぎ';

  @override
  String get customerServiceClose => '対応終了';

  @override
  String get customerServiceCloseConfirm => 'この対応を終了しますか？';

  @override
  String get customerServiceNoQueue => '待機中のセッションはありません';

  @override
  String get customerServiceNoActive => '対応中のセッションはありません';

  @override
  String get customerServiceVisitor => '訪問者';

  @override
  String get customerServiceCustomer => '顧客';

  @override
  String get customerServiceAssignedTo => '担当者';

  @override
  String get customerServiceTransferConversation => 'チャットを転送';

  @override
  String get marketingToolbar => 'マーケティングツール';

  @override
  String get callIncoming => '着信';

  @override
  String get callOutgoing => '発信';

  @override
  String get callAccept => '応答';

  @override
  String get callReject => '拒否';

  @override
  String get callHangup => '終了';

  @override
  String get callMissed => '不在着信';

  @override
  String get callDuration => '通話時間';

  @override
  String get callAudio => '音声通話';

  @override
  String get callGeneric => '通話';

  @override
  String get callVideo => 'ビデオ通話';

  @override
  String get callConnecting => '接続中...';

  @override
  String get callRinging => '呼び出し中...';

  @override
  String get callEnded => '通話が終了しました';

  @override
  String get callFailed => '通話に失敗しました';

  @override
  String get callRejected => '通話が拒否されました';

  @override
  String get callTimeout => '応答がありません';

  @override
  String get callCancelled => 'キャンセルしました';

  @override
  String get callUnknownPeer => '不明';

  @override
  String get callVideoInvitation => 'ビデオ通話の招待';

  @override
  String get callAudioInvitation => '音声通話の招待';

  @override
  String get callAnswerAudio => '音声で応答';

  @override
  String get callAnswerVideo => 'ビデオで応答';

  @override
  String get callViewProfile => 'プロフィールを表示';

  @override
  String get callOpeningCamera => 'カメラを起動中...';

  @override
  String get callWaitingRemoteVideo => '相手の映像を待っています...';

  @override
  String get callCameraOff => 'カメラオフ';

  @override
  String get callCameraOn => 'カメラオン';

  @override
  String get callMicrophoneOff => 'マイクオフ';

  @override
  String get callMicrophoneOn => 'マイクオン';

  @override
  String get callSpeakerOff => 'スピーカーオフ';

  @override
  String get callSpeakerOn => 'スピーカーオン';

  @override
  String get callVideoPermissionFailure =>
      'ビデオ通話を開始できません。カメラとマイクの権限を確認して再試行してください。';

  @override
  String get callAudioPermissionFailure => '音声通話を開始できません。マイクの権限を確認して再試行してください。';

  @override
  String get callIncompleteIncoming => '着信情報が不完全なため応答できません。';

  @override
  String get callInProgress => '通話中';

  @override
  String get callCalling => '発信中...';

  @override
  String callEndedMedia(String media) {
    return '$mediaが終了しました';
  }

  @override
  String callRejectedMedia(String media) {
    return '$mediaが拒否されました';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$mediaに応答がありませんでした';
  }

  @override
  String callCancelledMedia(String media) {
    return '$mediaがキャンセルされました';
  }

  @override
  String get callConnectionLost => '通話接続が切断されました';

  @override
  String get callAdminEnded => '管理者により通話が終了されました';

  @override
  String callFailedMedia(String media) {
    return '$mediaに失敗しました';
  }

  @override
  String get callBusy => '相手が通話中です';

  @override
  String callDurationValue(String duration) {
    return '通話時間 $duration';
  }

  @override
  String get callNotConnected => '未接続';

  @override
  String get callDialed => '発信済み';

  @override
  String get callAnswered => '応答済み';

  @override
  String get callRejectedByPeer => '相手が拒否しました';

  @override
  String get callRejectedBySelf => '拒否しました';

  @override
  String get callPeerDidNotAnswer => '相手が応答しませんでした';

  @override
  String get callMissedIncoming => '不在着信';

  @override
  String get callPeerCancelled => '相手がキャンセルしました';

  @override
  String get notificationNewMessageTitle => 'StartLinkの新着メッセージ';

  @override
  String get notificationOnlineServiceTitle => 'カスタマーサービスの新着メッセージ';

  @override
  String get notificationNewMessageBody => '新しいメッセージが届きました';

  @override
  String get notificationImagePreview => '画像が送信されました';

  @override
  String get notificationVideoPreview => '動画が送信されました';

  @override
  String get notificationVoicePreview => '音声メッセージが送信されました';

  @override
  String get notificationFilePreview => 'ファイルが送信されました';

  @override
  String get notificationContactPreview => '連絡先カードが送信されました';

  @override
  String get notificationCallLogPreview => '通話履歴が送信されました';

  @override
  String get notificationLocationPreview => '位置情報が共有されました';

  @override
  String get notificationLinkPreview => 'リンクが共有されました';

  @override
  String notificationMentionMe(String body) {
    return 'あなたをメンションしました：$body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$senderがあなたをメンションしました：$body';
  }

  @override
  String notificationMentionAll(String body) {
    return '全員をメンションしました：$body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$senderが全員をメンションしました：$body';
  }

  @override
  String get notificationSecurityTitle => 'アカウントセキュリティ警告';

  @override
  String get notificationSecurityBody =>
      'StartLinkアカウントのセキュリティ設定が変更されました。今すぐ確認してください。';

  @override
  String get notificationFriendAcceptedTitle => '友達申請が承認されました';

  @override
  String get notificationFriendRejectedTitle => '友達申請が拒否されました';

  @override
  String get notificationFriendAcceptedBody => '相手が友達申請を承認しました';

  @override
  String get notificationFriendRejectedBody => '相手が友達申請を拒否しました';

  @override
  String get notificationVideoCallTitle => 'ビデオ通話の招待';

  @override
  String get notificationAudioCallTitle => '音声通話の招待';

  @override
  String notificationVideoCallBody(String caller) {
    return '$callerからビデオ通話に招待されました';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$callerから音声通話に招待されました';
  }

  @override
  String get notificationMessageChannelName => 'メッセージ';

  @override
  String get notificationMessageChannelDescription => 'チャット、通話履歴、システム通知';

  @override
  String get notificationCallChannelName => '通話';

  @override
  String get notificationCallChannelDescription => '音声・ビデオ通話の着信通知';

  @override
  String get notificationSecurityChannelName => 'アカウントセキュリティ';

  @override
  String get notificationSecurityChannelDescription => 'ログイン、パスワード、携帯電話番号の変更通知';

  @override
  String get notificationUnknownCaller => '不明な発信者';

  @override
  String get pendingJoinRequestsTitle => '新しい申請';

  @override
  String get pendingJoinRequestsEmpty => '申請はありません';

  @override
  String get pendingJoinRequestApprove => '承認';

  @override
  String get pendingJoinRequestReject => '拒否';

  @override
  String get pendingJoinRequestApproveSuccess => '承認しました';

  @override
  String get pendingJoinRequestRejectSuccess => '拒否しました';

  @override
  String get pendingJoinRequestFailed => '操作に失敗しました。もう一度お試しください';

  @override
  String get myCustomersTitle => '担当顧客';

  @override
  String get myCustomersEmpty => '顧客がいません';

  @override
  String get groupListTitle => 'グループ一覧';

  @override
  String get groupListEmpty => 'グループがありません';

  @override
  String get addFriendTitle => '友達を追加';

  @override
  String get addFriendSearchHint => '電話番号 / メール / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => '友達追加';

  @override
  String get addFriendCannotAddSelf => '自分自身は追加できません';

  @override
  String get addFriendUnsupportedUser => 'このユーザーは友達追加できません。直接メッセージできます。';

  @override
  String get addFriendMessageHint => 'メッセージを入力してください';

  @override
  String get addFriendSendRequest => '申請を送る';

  @override
  String get joinCompanyTitle => '企業に参加';

  @override
  String get joinCompanyCodeHint => '企業コードを入力してください';

  @override
  String get joinCompanySearchHint => '企業名を検索';

  @override
  String get joinCompanyApply => '参加申請';

  @override
  String get joinCompanyApplySuccess => '申請を送りました';

  @override
  String get joinCompanyApplyFailed => '申請に失敗しました。もう一度お試しください';

  @override
  String get joinCompanyAutoApproved => '自動承認されました。ようこそ！';

  @override
  String get joinCompanyPending => '申請を送りました。承認をお待ちください';

  @override
  String get joinCompanyInviteCodeHint => '招待コードを入力してください';

  @override
  String get joinCompanyAcceptInvite => '招待を承認';

  @override
  String get joinCompanyNoResults => '企業が見つかりません';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count名';
  }

  @override
  String get timezoneNameHawaii => 'ハワイ';

  @override
  String get timezoneNameAlaska => 'アラスカ';

  @override
  String get timezoneNamePacificTime => '太平洋時間';

  @override
  String get timezoneNameMountainTime => '山岳部時間';

  @override
  String get timezoneNameCentralTime => '中部時間';

  @override
  String get timezoneNameEasternTime => '東部時間';

  @override
  String get timezoneNameAtlanticTime => '大西洋時間';

  @override
  String get timezoneNameBrasilia => 'ブラジリア';

  @override
  String get timezoneNameAzores => 'アゾレス諸島';

  @override
  String get timezoneNameLondonDublin => 'ロンドン/ダブリン';

  @override
  String get timezoneNameBerlinParisRome => 'ベルリン/パリ/ローマ';

  @override
  String get timezoneNameCairoHelsinki => 'カイロ/ヘルシンキ';

  @override
  String get timezoneNameMoscowRiyadh => 'モスクワ/リヤド';

  @override
  String get timezoneNameTehran => 'テヘラン';

  @override
  String get timezoneNameDubaiBaku => 'ドバイ/バクー';

  @override
  String get timezoneNameKabul => 'カブール';

  @override
  String get timezoneNameKarachiTashkent => 'カラチ/タシュケント';

  @override
  String get timezoneNameMumbaiNewDelhi => 'ムンバイ/ニューデリー';

  @override
  String get timezoneNameKathmandu => 'カトマンズ';

  @override
  String get timezoneNameDhakaAlmaty => 'ダッカ/アルマトイ';

  @override
  String get timezoneNameYangon => 'ヤンゴン';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'バンコク/ハノイ/ジャカルタ';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei => '北京/上海/香港/台北';

  @override
  String get timezoneNameTokyoSeoul => '東京/ソウル';

  @override
  String get timezoneNameAdelaide => 'アデレード';

  @override
  String get timezoneNameSydneyMelbourne => 'シドニー/メルボルン';

  @override
  String get timezoneNameSolomonIslands => 'ソロモン諸島';

  @override
  String get timezoneNameAucklandFiji => 'オークランド/フィジー';

  @override
  String get networkSmartSelectBestRoute => '最適なルートを自動選択';

  @override
  String get networkTesting => 'テスト中...';

  @override
  String get networkTestingShort => 'テスト中';

  @override
  String networkLatencyMs(int ms) {
    return '遅延 ${ms}ms';
  }

  @override
  String get networkConnectionMode => '接続モード';

  @override
  String get networkDirectMode => '直接接続モード';

  @override
  String get networkProxyMode => 'プロキシモード';

  @override
  String get networkDirectModeDesc => 'サーバーへ直接接続します';

  @override
  String get networkProxyModeDesc => 'プロキシサーバー経由で接続します';

  @override
  String get networkDirectRoutes => '直接接続ルート';

  @override
  String get networkProxyRoutes => 'プロキシルート';

  @override
  String get networkTestAll => 'すべてテスト';

  @override
  String get networkChinaTelecom => '中国電信';

  @override
  String get networkChinaUnicom => '中国聯通';

  @override
  String get networkChinaMobile => '中国移動';

  @override
  String get networkHongKongNode => '香港ノード';

  @override
  String get networkSingaporeNode => 'シンガポールノード';

  @override
  String get networkJapanNode => '日本ノード';

  @override
  String get networkUnitedStatesNode => '米国ノード';

  @override
  String get networkHint =>
      'ヒント:\n• 直接接続モード: 高速で国内利用に適しています\n• プロキシモード: 越境通信で安定しやすいです\n• 更新アイコンをタップすると個別ルートの遅延をテストできます';

  @override
  String get teenModeTitle => '青少年モード';

  @override
  String get teenModeStatusOn => 'オン';

  @override
  String get teenModeStatusOff => 'オフ';

  @override
  String get teenModeStatusLoading => '取得中';

  @override
  String get teenModeUnavailable => '青少年モードの状態を取得できません';

  @override
  String get teenModeInvalidResponse => '青少年モードのサービスから無効な応答が返されました';

  @override
  String get teenModeEnableDescription => 'プラットフォームのルールにより利用時間と一部機能が制限されます。';

  @override
  String get teenModePasscode => 'パスコード';

  @override
  String get teenModeCurrentPasscode => '現在のパスコード';

  @override
  String get teenModeNewPasscode => '新しいパスコード';

  @override
  String get teenModePasscodeHint => '4～6桁の数字を入力';

  @override
  String get teenModeEnable => '青少年モードをオンにする';

  @override
  String get teenModeDisable => '青少年モードをオフにする';

  @override
  String get teenModeChangePasscode => 'パスコードを変更';

  @override
  String get teenModeSource => '設定元';

  @override
  String get teenModeDailyUsage => '本日の利用時間';

  @override
  String get teenModeRemaining => '残り時間';

  @override
  String get teenModeMinutesUnit => '分';

  @override
  String get teenModeUnlimited => '無制限';

  @override
  String get teenModeRequestExtension => '延長を申請';

  @override
  String get teenModeExtensionSubmitted => '延長申請を保護者に送信しました';

  @override
  String get teenModeTimeLimitReached => '本日の利用上限に達しました';

  @override
  String get teenModeCurfewActive => '現在は利用制限時間です';

  @override
  String get teenModeReliefHint => '履歴の閲覧、公式サポートへの連絡、通報は引き続き利用できます。';

  @override
  String get teenModeRestrictedNotice => '青少年モードによりメッセージ送信が制限されています';

  @override
  String get teenModeActionBlocked => '青少年モードによりこの操作は制限されています';

  @override
  String get teenModeMyRequests => '自分の申請';

  @override
  String get guardianCenterTitle => '保護者センター';

  @override
  String get guardianRelationships => '保護者関係';

  @override
  String get guardianMinors => '見守っている子ども';

  @override
  String get guardianApprovals => '承認待ち';

  @override
  String get guardianBind => '連携コードを入力';

  @override
  String get guardianCreateMinorCode => '子どもとしてコードを作成';

  @override
  String get guardianCreateGuardianCode => '保護者としてコードを作成';

  @override
  String get guardianRelation => '続柄';

  @override
  String get guardianPrimary => '主な保護者';

  @override
  String get guardianCode => '6桁の連携コード';

  @override
  String get guardianCodeHint => '相手から受け取ったコードを入力';

  @override
  String get guardianCodeCreated => 'コードを作成しました。期限内に相手へ共有してください。';

  @override
  String get guardianEmpty => '保護者関係はありません';

  @override
  String get guardianNoMinors => '見守り対象はいません';

  @override
  String get guardianUnbind => '関係を解除';

  @override
  String get guardianExtend => '子どもの時間を延長';

  @override
  String get guardianPolicyTitle => '利用ルール';

  @override
  String get guardianPolicyLocked => 'プラットフォームにより固定';

  @override
  String get approvalEmpty => '申請はありません';

  @override
  String get approvalApprove => '承認';

  @override
  String get approvalReject => '拒否';

  @override
  String get approvalPending => '承認待ち';

  @override
  String get approvalApproved => '承認済み';

  @override
  String get approvalRejected => '拒否済み';

  @override
  String get approvalExpired => '期限切れ';

  @override
  String get approvalCancelled => '取り消し済み';

  @override
  String get approvalReplayFailed => '元の操作に失敗しました。もう一度実行してください。';

  @override
  String get requestCancelled => '申請を取り消しました';

  @override
  String get kycTitle => '本人確認';

  @override
  String get kycNotRequired => '本人確認は不要です';

  @override
  String get kycVerified => '本人確認済み';

  @override
  String get kycDeclared => '本人情報を提出しました';

  @override
  String get kycPending => '審査中';

  @override
  String get kycRejected => '審査に通りませんでした';

  @override
  String get kycNone => '本人情報は未提出です';

  @override
  String get kycRealName => '氏名';

  @override
  String get kycIdNumber => '証明書番号';

  @override
  String get kycIdType => '証明書の種類';

  @override
  String get kycApplicability =>
      '選択した証明書に合わせて正しい情報を入力してください。対応する種類は一覧をご確認ください。';

  @override
  String get kycCamera => '写真を撮る';

  @override
  String get kycGallery => '写真から選択';

  @override
  String get kycPhotoLimit => '写真1枚の上限';

  @override
  String get kycSelectPhoto => '写真を選択';

  @override
  String get kycPhotoSelected => '選択済み';

  @override
  String get kycViewPhoto => 'タップして写真を表示';

  @override
  String get kycReplacePhoto => '写真を選び直す';

  @override
  String get kycDisclosure =>
      '氏名、証明書番号、証明書の写真を本人確認のために使用します。提供しない場合は提出できず、一部の機能を利用できないことがあります。';

  @override
  String get kycConsent => '今回の本人情報の処理に個別に同意します';

  @override
  String get kycConsentRequired => '提出前に個別の同意が必要です';

  @override
  String get kycResubmitTitle => '本人情報を再提出';

  @override
  String get kycResubmitWarning => '再提出すると審査中の申請が無効になります。続行しますか？';

  @override
  String get kycSubmitting => '提出中';

  @override
  String get kycSubmitFailed => '提出に失敗しました。再試行してください';

  @override
  String get kycSubmitUnavailable => '現在は本人情報を提出できません';

  @override
  String get kycResubmitNotAllowed => '却下後の再提出はできません。必要に応じてサポートにお問い合わせください';

  @override
  String get kycDailyLimit => '本日の提出回数の上限に達しました。明日お試しください';

  @override
  String get kycTypeUnavailable => '利用できる証明書の種類がありません。後でもう一度お試しください';

  @override
  String get kycNameInvalid => '氏名は2～64文字で入力してください';

  @override
  String get kycNumberRequired => '証明書番号を入力してください';

  @override
  String get kycFrontRequired => '証明書の表面の写真をアップロードしてください';

  @override
  String get kycBackRequired => '証明書の裏面の写真をアップロードしてください';

  @override
  String get kycPhotoTooLarge => '写真のサイズが上限を超えています。圧縮して再試行してください';

  @override
  String get kycAccountChanged => 'アカウントまたはスペースが切り替わりました。このページを開き直してください';

  @override
  String get kycPhotoInvalid => '有効な画像を選択してください';

  @override
  String get kycPortraitSide => '顔写真の面';

  @override
  String get kycEmblemSide => '国章の面';

  @override
  String get kycPassportDataPage => 'パスポートの顔写真ページ';

  @override
  String get kycPassportOtherPage => 'パスポートの査証・予備ページ';

  @override
  String get kycFront => '証明書の表面';

  @override
  String get kycBack => '証明書の裏面';

  @override
  String get kycRequired => 'グループ作成には本人確認が必要です';

  @override
  String get kycGoVerify => '本人確認へ';

  @override
  String get kycStatusUnknown => '本人確認の状態を表示できません。後でもう一度更新してください';

  @override
  String get kycSuperseded => 'この申請は後の申請に置き換えられました。最新の状態を確認してください';

  @override
  String get kycMediaNotFound => 'このスペースで証明書の画像が見つかりません。選び直してから送信してください';

  @override
  String get customerServiceBroadcastDirectTitle => '顧客一斉送信';

  @override
  String get officialAccountBadge => '公式';

  @override
  String get officialAccountOpenConversation => '会話を開く';

  @override
  String get officialAccountJoinHint => '追加すると顧客として企業に参加します。友だちの承認は不要です。';

  @override
  String get officialAccountJoinDisabled =>
      'この企業は現在追加を受け付けていません。サポートにお問い合わせください。';

  @override
  String get officialAccountRemoved => 'この企業から削除されています。企業に再招待を依頼してください。';

  @override
  String get officialAccountBanned => 'この企業でアカウントが無効になっています。';

  @override
  String get officialAccountUnavailable => 'この公式アカウントは現在利用できません。';

  @override
  String get officialAccountJoinBindingDisabled => '現在のモードでは企業に参加できません。';

  @override
  String get officialAccountPlatformRequired =>
      'プラットフォームアカウントで公式アカウントを追加してください。';

  @override
  String get officialAccountOpenFailed => '会話を開けませんでした。再試行してください。';

  @override
  String get officialAccountAccountChanged =>
      'アカウントまたはスペースが切り替わりました。もう一度開いてください。';

  @override
  String get officialAccountDirectoryUnavailable =>
      '企業一覧が更新されていません。しばらくしてから再試行してください。';

  @override
  String get officialAccountInboxSyncFailed =>
      '公式アカウントの同期に失敗しました。ローカルの内容は保持されています。';

  @override
  String get officialAccountInboxSyncing => '公式アカウントのメッセージを同期中';

  @override
  String get diagnosticsTitle => '問題の診断';

  @override
  String get diagnosticsExplanation =>
      'ログは匿名化され、現在のアカウントとスペースの動作・エラー情報、および共通の起動記録のみを含みます。チャット本文や認証情報は含みません。';

  @override
  String get diagnosticsHour => '過去1時間';

  @override
  String get diagnosticsDay => '過去24時間';

  @override
  String get diagnosticsWeek => '過去7日間';

  @override
  String diagnosticsEventCount(int count) {
    return '利用可能な記録：$count件';
  }

  @override
  String get diagnosticsPersistent => 'ログは端末に保存され、再起動後も書き出せます。';

  @override
  String get diagnosticsNotPersistent => '一部のログが保存されていません。更新してください。';

  @override
  String get diagnosticsExport => '書き出して共有';

  @override
  String get diagnosticsRefresh => '更新';

  @override
  String get diagnosticsClear => 'このスペースのログを消去';

  @override
  String get diagnosticsClearConfirm => 'このスペースの診断ログを消去しますか？チャット履歴は削除されません。';

  @override
  String get diagnosticsShared => 'システムの共有操作が完了しました。共有先でファイルを確認してください。';

  @override
  String get diagnosticsCancelled => '共有をキャンセルしました。再度書き出せます。';

  @override
  String get diagnosticsUnconfirmed => '共有結果を確認できません。共有先で確認してください。';

  @override
  String get diagnosticsFailed => '操作に失敗しました。再試行してください。';
}
