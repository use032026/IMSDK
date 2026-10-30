// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get navWorkbench => 'Workstation';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Hindi ma-load ang data ng account';

  @override
  String get startupFailureTitle => 'Hindi makapagsimula';

  @override
  String get startupFailureMessage => 'Suriin ang network at subukang muli';

  @override
  String get privacyConsentTitle =>
      'Mga Tuntunin ng Serbisyo at Patakaran sa Pagkapribado';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Maligayang pagdating sa $brand. Para maibigay ang pag-sign in sa account, instant messaging, pakikipagtulungan sa negosyo, online na serbisyo sa customer, mga abiso sa mensahe, at proteksiyon sa seguridad, kailangan naming iproseso ang kinakailangang impormasyon alinsunod sa Mga Tuntunin ng Serbisyo at Patakaran sa Privacy.\n\nBago mo i-tap ang Sumasang-ayon, hindi namin babasahin ang clipboard, sisimulan ang JPush/JCore o mga push SDK ng gumawa ng device, o gagamitin ang mga SDK na iyon para ma-access ang Android ID, OAID, listahan ng mga naka-install na app, MAC address, o katulad na impormasyon. Kung hindi ka muna papayag, ise-save namin ang pasyang iyon; maaari mo pa ring basahin ang mga dokumento at magpasya muli sa ibang pagkakataon.\n\nPagkatapos mong pumayag, para maghatid ng mga abiso sa mensahe, serbisyo sa customer, at papasok na tawag, maaaring iproseso ng JPush/JCore at mga push service ng gumawa ng device ang modelo ng device, bersyon ng Android, pangalan ng package at bersyon ng app, uri ng network, IP address, Android ID, OAID, push Registration ID, push token ng gumawa, at data ng paghahatid at pag-click sa abiso. Hindi namin pinagana ang mga hindi kinakailangang kakayahan, kabilang ang smart push, listahan ng mga naka-install na app, MAC, IMEI, IMSI, listahan ng Wi-Fi, awtomatikong paggising, at magkakaugnay na pagsisimula.\n\nIna-access lang ang clipboard kapag ginagamit mo ang pagkopya o pag-paste. Hinihingi lang ang pahintulot sa camera, mikropono, mga abiso, at iba pang pahintulot ng system kapag ginagamit mo ang kaukulang feature. Ang pagtanggi sa isang pahintulot ay nakaaapekto lamang sa kaukulang feature. Basahin ang buong dokumento sa ibaba at piliin kung sasang-ayon ka.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Maligayang pagdating sa $brand. Para maibigay ang pag-sign in sa account, instant messaging, pakikipagtulungan sa negosyo, online na serbisyo sa customer, mga abiso sa mensahe, at proteksiyon sa seguridad, kailangan naming iproseso ang kinakailangang impormasyon alinsunod sa Mga Tuntunin ng Serbisyo at Patakaran sa Privacy.\n\nBago mo i-tap ang Sumasang-ayon, hindi namin babasahin ang clipboard, sisimulan ang JPush/JCore, magrerehistro sa Apple Push Notification service (APNs), o kukuha ng mga push identifier gaya ng JPush Registration ID o APNs device token. Kung hindi ka muna papayag, ise-save namin ang pasyang iyon; maaari mo pa ring basahin ang mga dokumento at magpasya muli sa ibang pagkakataon.\n\nPagkatapos mong pumayag, para maghatid ng mga abiso sa mensahe, serbisyo sa customer, at papasok na tawag, maaari naming iproseso ang modelo ng iPhone, bersyon ng iOS, pangalan ng package at bersyon ng app, uri ng network, IP address, IDFV, JPush Registration ID, APNs device token, at data ng paghahatid at pag-click sa abiso. Kumokonekta ang JPush/JCore sa push service; pinoproseso ng Apple APNs ang identifier ng app, device token, at nilalaman ng abiso para maghatid ng mga abiso ng system. Ang kasalukuyang iOS app ay hindi gumagamit ng mga serbisyo sa advertising o kumukuha ng IDFA.\n\nIna-access lang ang clipboard kapag ginagamit mo ang pagkopya o pag-paste. Hinihingi lang ang pahintulot sa camera, mikropono, mga abiso, at iba pang pahintulot ng system kapag ginagamit mo ang kaukulang feature. Ang pagtanggi sa isang pahintulot ay nakaaapekto lamang sa kaukulang feature. Basahin ang buong dokumento sa ibaba at piliin kung sasang-ayon ka.';
  }

  @override
  String get privacyConsentTermsLink => 'Kasunduan sa Gumagamit';

  @override
  String get privacyConsentConjunction => 'at';

  @override
  String get privacyConsentPrivacyLink => 'Patakaran sa Pagkapribado';

  @override
  String get privacyConsentDecline => 'Hindi sumasang-ayon';

  @override
  String get privacyConsentDeclinedExit =>
      'Hindi ka sumang-ayon sa Mga Tuntunin ng Serbisyo at Patakaran sa Privacy. Isasara na ang app.';

  @override
  String get privacyConsentAccept => 'Sumasang-ayon';

  @override
  String get privacyConsentRuntimeFailure =>
      'Hindi makapagsimula. Suriin ang network at subukang muli.';

  @override
  String get privacyConsentSaveFailure =>
      'Hindi ma-save ang iyong pasya. Subukang muli.';

  @override
  String get appUpdateRequiredTitle => 'Kailangang mag-update para magpatuloy';

  @override
  String get appUpdateOptionalTitle => 'Available na ang bagong bersyon';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Available na ang $brand $version';
  }

  @override
  String get appUpdateLater => 'Mamaya';

  @override
  String get appUpdateNow => 'I-update Ngayon';

  @override
  String get appUpdateProcessing => 'Pinoproseso...';

  @override
  String get appUpdateInvalidUrl =>
      'Hindi wasto ang address ng update. Subukan ulit mamaya.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Hindi mabuksan ang link ng update. Subukan ulit mamaya.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Naputol ang pag-download. Suriin ang network at subukang muli.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Hindi na-verify ang package. I-download itong muli.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Payagan ang $brand na mag-install ng mga update sa mga setting ng system.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Hindi mabuksan ang installer ng system. Suriin ang mga pahintulot sa pag-install.';

  @override
  String get appUpdateGenericFailure =>
      'Hindi na-update. Suriin ang network at subukang muli.';

  @override
  String get appUpdateUnavailable =>
      'Hindi pa mada-download ang bagong bersyon. Subukan ulit mamaya.';

  @override
  String get appUpdateCheckFailed =>
      'Hindi masuri ang mga update. Subukan ulit mamaya.';

  @override
  String get appUpdateChecking => 'Sinusuri';

  @override
  String get commonConfirm => 'Sige';

  @override
  String get commonCancel => 'Kanselahin';

  @override
  String get commonSave => 'I-save';

  @override
  String get commonEdit => 'I-edit';

  @override
  String get commonDelete => 'Tanggalin';

  @override
  String get commonSearch => 'Maghanap';

  @override
  String get commonLoading => 'Naglo-load...';

  @override
  String get commonLoadFailed => 'Hindi maikarga';

  @override
  String get commonRetry => 'Subukan Muli';

  @override
  String get commonEmpty => 'Walang Data';

  @override
  String get commonCopy => 'Kopyahin';

  @override
  String get commonForward => 'Ipasa';

  @override
  String get commonFavorite => 'I-save';

  @override
  String get commonClose => 'Isara';

  @override
  String get commonSend => 'Ipadala';

  @override
  String get commonDone => 'Tapos na';

  @override
  String get commonMore => 'Higit pa';

  @override
  String get commonSettings => 'Mga Setting';

  @override
  String get commonCopied => 'Nakopya';

  @override
  String get commonUnknown => 'Hindi kilala';

  @override
  String get commonNotSet => 'Hindi pa itinakda';

  @override
  String get commonUnbound => 'Hindi Naka-link';

  @override
  String get commonViewAll => 'Tingnan lahat';

  @override
  String get commonSubmit => 'Isumite';

  @override
  String get commonAdd => 'Idagdag';

  @override
  String get commonRemove => 'Alisin';

  @override
  String get commonCreate => 'Gumawa';

  @override
  String get commonUpdate => 'I-update';

  @override
  String get commonUpload => 'I-upload';

  @override
  String get commonShare => 'Ibahagi';

  @override
  String get commonBlock => 'I-block';

  @override
  String get commonUnblock => 'I-unblock';

  @override
  String get commonMute => 'I-mute';

  @override
  String get commonUnmute => 'I-unmute';

  @override
  String get commonPin => 'Nakapirmi';

  @override
  String get commonUnpin => 'Alisin sa naka-pin';

  @override
  String get commonMarkRead => 'Markahang nabasa na';

  @override
  String get commonMarkUnread => 'Markahang hindi pa nababasa';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed => 'Hindi naisagawa, subukang muli';

  @override
  String get commonNetworkError =>
      'Error sa network, suriin ang iyong koneksiyon';

  @override
  String get navMessages => 'Mga Mensahe';

  @override
  String get navContacts => 'Mga contact';

  @override
  String get navMe => 'Ako';

  @override
  String get authLoginTitle => 'Mag-sign in sa StartLink';

  @override
  String get authTabMobile => 'Telepono';

  @override
  String get authTabEmail => 'Email';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'Ilagay ang numero ng telepono';

  @override
  String get authHintEmail => 'Ipasok ang iyong email address';

  @override
  String get authHintPassword => 'Ilagay ang password';

  @override
  String get authHintCode => 'Ilagay ang verification code';

  @override
  String get authHintLoginName => 'Ilagay ang StartLink ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Mag-sign in';

  @override
  String get authGetCode => 'Kumuha ng Code';

  @override
  String authResendCode(int seconds) {
    return 'Ipadala muli makalipas ang ${seconds}s';
  }

  @override
  String get authUsePassword => 'Gumamit ng password';

  @override
  String get authUseCode => 'Gumamit ng verification code';

  @override
  String get authAgreementPrefix => 'Nabasa ko na at sumasang-ayon ako sa';

  @override
  String get authAgreementAnd => 'at';

  @override
  String get authTermsLink => 'Kasunduan sa Gumagamit';

  @override
  String get authPrivacyLink => 'Patakaran sa Pagkapribado';

  @override
  String get authCaptchaTitle => 'Pag-verify sa seguridad';

  @override
  String get authCaptchaHint => 'Ilagay ang sagot';

  @override
  String get authCaptchaFailed => 'Hindi nakuha ang captcha, subukang muli';

  @override
  String get authErrorEmptyCode => 'Pakilagay ang verification code';

  @override
  String get authErrorEmptyPassword => 'Ilagay ang password';

  @override
  String get authErrorEmptyLoginName => 'Pakilagay ang StartLink ID';

  @override
  String get authErrorWrongCredentials => 'Maling account o password';

  @override
  String get authDeactivatingTitle => 'Pag-deactivate ng account';

  @override
  String get authDeactivatingContent =>
      'Nasa palugit para sa pag-deactivate ang iyong account (7 araw).\n\nPara kanselahin ang pag-deactivate, i-tap ang \"Kanselahin ang pag-deactivate\"; kung hindi, i-tap ang \"Magpatuloy\" para pumasok sa app.';

  @override
  String get authContinueUse => 'Magpatuloy';

  @override
  String get authCancelDeactivation => 'Kanselahin ang pag-deactivate';

  @override
  String get authDeactivationCancelled =>
      'Nakansela ang pag-deactivate at naibalik ang account';

  @override
  String get authDeactivationCancelFailed => 'Hindi nakansela, subukang muli';

  @override
  String get authLogout => 'Mag-logout';

  @override
  String get authLogoutConfirm => 'Sigurado ka bang gusto mong mag-sign out?';

  @override
  String get authSendingCode => 'Ipinapadala...';

  @override
  String get authCodeSent => 'Naipadala na ang verification code';

  @override
  String get authLoginFailed => 'Hindi makapag-sign in, subukang muli';

  @override
  String get authRegisterFailed => 'Hindi nakapagrehistro, subukang muli';

  @override
  String get authEnterpriseCode => 'Code ng negosyo';

  @override
  String get authEnterpriseCodeHint => 'Ilagay ang code ng negosyo';

  @override
  String get authPendingApproval =>
      'Matagumpay ang pagpaparehistro. Naipadala na ang iyong kahilingang sumali sa negosyo at naghihintay ng pag-apruba.';

  @override
  String get authNoAccount => 'Wala ka pang account?';

  @override
  String get authRegisterNow => 'Magrehistro ngayon';

  @override
  String get authCountryPickerTitle => 'Pumili ng bansa/rehiyon';

  @override
  String get authCountrySearchHint => 'Maghanap ng bansa/rehiyon';

  @override
  String get authCountryChinaMainland => 'Mainland China';

  @override
  String get authCountryHongKong => 'Hong Kong, China';

  @override
  String get authCountryMacau => 'Macao, China';

  @override
  String get authCountryTaiwan => 'Taiwan, China';

  @override
  String get authCountryUnitedStates => 'Estados Unidos';

  @override
  String get authCountryUnitedKingdom => 'United Kingdom';

  @override
  String get authCountryJapan => 'Japan';

  @override
  String get authCountrySouthKorea => 'Timog Korea';

  @override
  String get authCountrySingapore => 'Singapore';

  @override
  String get authCountryMalaysia => 'Malaysia';

  @override
  String get authCountryAustralia => 'Australia';

  @override
  String get authCountryCanada => 'Canada';

  @override
  String get authCountryGermany => 'Germany';

  @override
  String get authCountryFrance => 'France';

  @override
  String get authCountryIndia => 'India';

  @override
  String get authCountryThailand => 'Thailand';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonesia';

  @override
  String get authCountryPhilippines => 'Pilipinas';

  @override
  String get authQuickLoginTitle => 'Mabilis na pag-sign in';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Nagsa-sign in. Maghintay.';

  @override
  String get authRoleOwner => 'May-ari';

  @override
  String get authRoleAdministrator => 'Administrator';

  @override
  String get authRoleCustomerService => 'Serbisyo sa customer';

  @override
  String get authRoleTechnicalSupport => 'Teknikal na suporta';

  @override
  String get authRoleEmployee => 'Empleyado';

  @override
  String get authRoleMember => 'Miyembro';

  @override
  String get authRoleEnterpriseCustomer => 'Customer ng negosyo';

  @override
  String get authUnavailablePrefix => 'Hindi available · ';

  @override
  String get authUnassignedService => 'Walang nakatalagang ahente';

  @override
  String authAssignedService(String staff) {
    return 'Nakatalaga kay $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Customer · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Empleyado · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count user';
  }

  @override
  String get authMetaPhone => 'Telepono';

  @override
  String get authMetaIdentity => 'Pagkakakilanlan';

  @override
  String get authRegisterTitle => 'Magrehistro';

  @override
  String get authNickname => 'Palayaw';

  @override
  String get authNicknameHint => 'Magtakda ng palayaw';

  @override
  String get authPassword => 'Sekretong Salita';

  @override
  String get authPasswordSetHint =>
      'Magtakda ng password (hindi bababa sa 6 na character)';

  @override
  String get authConfirmPassword => 'Kumpirmahin ang Password';

  @override
  String get authConfirmPasswordHint => 'Ilagay muli ang password';

  @override
  String get authVerificationCode => 'Kodigo ng Pagpapatunay';

  @override
  String get authRegisterAndLogin => 'Magrehistro at mag-sign in';

  @override
  String get authHaveAccount => 'May account ka na?';

  @override
  String get authGoLogin => 'Mag-login';

  @override
  String get authEmailVerificationUnavailable =>
      'Hindi available ang pag-verify sa email. Magrehistro gamit ang numero ng mobile.';

  @override
  String get authSmsVerificationUnavailable =>
      'Hindi available ang pag-verify sa SMS. Magrehistro gamit ang email.';

  @override
  String get authSendFailed => 'Hindi maipadala. Subukang muli.';

  @override
  String get authErrorEmptyNickname => 'Ilagay ang palayaw';

  @override
  String get authErrorInvalidMobile => 'Maglagay ng wastong numero ng mobile';

  @override
  String get authErrorInvalidEmail => 'Maglagay ng wastong email address';

  @override
  String get authErrorPasswordTooShort =>
      'Dapat may hindi bababa sa 6 na character ang password';

  @override
  String get authErrorPasswordMismatch => 'Hindi magkapareho ang mga password';

  @override
  String get authErrorVerificationRequired =>
      'Kunin at ilagay muna ang verification code';

  @override
  String get authRegisterErrorTitle => 'Hindi nakapagrehistro';

  @override
  String get authGotIt => 'Sige';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Hindi nahanap ang negosyong \"$code\". Suriin ang code ng negosyo.';
  }

  @override
  String get authTenantSearchFailed => 'Hindi nakapaghanap. Subukang muli.';

  @override
  String get authInvitationInvalid =>
      'Hindi wasto ang code ng imbitasyon. Suriin ito at subukang muli.';

  @override
  String get authCollapseJoin => 'Itago ang impormasyon sa pagsali';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Wastong imbitasyon: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Nahanap na negosyo: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Pumili ng organisasyon';

  @override
  String get authNoOrganization => 'Walang available na organisasyon';

  @override
  String get authNoOrganizationHint =>
      'Hilingin sa administrator na imbitahan ka sa organisasyon';

  @override
  String get authPersonalSpace => 'Personal na espasyo';

  @override
  String get authPersonalSpaceSubtitle =>
      'Mga chat sa kaibigan at personal na paborito';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Hindi ma-verify ang pagkakakilanlan ng espasyo. Subukang muli.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Hindi maibalik ang personal na espasyo. Subukang muli.';

  @override
  String get authJoinEnterpriseFailed =>
      'Hindi makasali sa negosyo. Subukan ulit mamaya.';

  @override
  String get homeTitle => 'Mga Mensahe';

  @override
  String get homeGatewayConnectingTitle => 'Kumokonekta';

  @override
  String get homePersonalSpace => 'Personal';

  @override
  String get homeOfficialService => 'Opisyal na serbisyo';

  @override
  String get homeSwitchSpace => 'Lumipat ng espasyo';

  @override
  String get homeSpaceSubtitle => 'Personal · Negosyo';

  @override
  String get homeJoinEnterprise => 'Sumali sa negosyo';

  @override
  String get homeCreateGroup => 'Bagong grupo';

  @override
  String get homeAddFriend => 'Magdagdag ng contact';

  @override
  String get homeScan => 'I-scan';

  @override
  String get homeJoinNewSpace => 'Sumali sa bagong espasyo';

  @override
  String get homeSearchConversation => 'Maghanap';

  @override
  String get homeNoMessages => 'Walang mensahe';

  @override
  String get homeDeleteConversation => 'Burahin ang chat';

  @override
  String get homeDeleteConversationConfirm =>
      'Burahin ang chat na ito? Maki-clear ang kasaysayan ng chat.';

  @override
  String get homePersonalNote => 'Ako (Mga personal na tala)';

  @override
  String get homeWorkNote => 'Ako (Mga tala sa trabaho)';

  @override
  String homeConversationCount(int count) {
    return '$count chat';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count hindi pa nababasa';
  }

  @override
  String get chatInputHint => 'Mag-type ng mensahe...';

  @override
  String get chatVoiceHint => 'Pindutin nang matagal para magsalita';

  @override
  String get chatVoiceRelease => 'Bitawan para ipadala';

  @override
  String get chatVoiceCancel => 'I-slide pataas para kanselahin';

  @override
  String get chatMenuCopy => 'Kopyahin';

  @override
  String get chatMenuForward => 'Ipasa';

  @override
  String get chatMenuRecall => 'Bawiin';

  @override
  String get chatMenuDelete => 'Tanggalin';

  @override
  String get chatMenuFavorite => 'I-save';

  @override
  String get chatMenuReply => 'Tumugon';

  @override
  String get chatMenuMultiSelect => 'Pumili';

  @override
  String get chatMenuTranslate => 'Isalin';

  @override
  String get chatMenuVoiceToText => 'Gawing teksto';

  @override
  String get chatMenuTextToSpeech => 'Basahin nang malakas';

  @override
  String get chatStatusRecalled => 'Binawi ang mensahe';

  @override
  String get chatRecallSuccess => 'Binawi';

  @override
  String get chatRecallFailed => 'Hindi mabawi';

  @override
  String get chatRecallTimeout =>
      'Hindi na mababawi ang mga mensaheng lampas 2 minuto na';

  @override
  String get chatTranslateFailed => 'Hindi naisalin, subukang muli';

  @override
  String get chatTranslateNotConfigured =>
      'Hindi available ang serbisyo sa pagsasalin';

  @override
  String get chatVoiceToTextFailed => 'Hindi na-convert, subukang muli';

  @override
  String get chatTextToSpeechFailed =>
      'Hindi mabasa nang malakas, subukang muli';

  @override
  String get chatVoiceToText => 'I-convert';

  @override
  String get chatForwardSuccess => 'Naipasa';

  @override
  String get chatForwardFailed => 'Hindi naipasa, subukang muli';

  @override
  String get chatNoConversations => 'Walang chat na mapagpapasahan';

  @override
  String get chatSendFailed => 'Hindi naipadala';

  @override
  String get chatResend => 'Ipadala muli';

  @override
  String get chatNotFriend => 'Wala sa listahan ng contact';

  @override
  String get chatNotFriendHint =>
      'Hindi pa kayo magka-contact. Hindi makapagpadala ng mensahe.';

  @override
  String get chatMutedHint => 'Naka-mute ang lahat ng miyembro';

  @override
  String get chatFileUploadFailed => 'Hindi na-upload ang file, subukang muli';

  @override
  String get chatFileStatusNotDownloaded => 'Hindi pa na-download';

  @override
  String get chatFileStatusDownloaded => 'Na-download na';

  @override
  String get chatFileStatusUploading => 'Nag-a-upload';

  @override
  String get chatFileStatusUploadFailed => 'Nabigong Mag-upload';

  @override
  String get chatCardSendFailed => 'Hindi naipadala ang contact card';

  @override
  String get chatFavoriteSuccess => 'Na-save';

  @override
  String get chatFavoriteFailed => 'Hindi naidagdag sa mga paborito';

  @override
  String get chatLoadFailed => 'Hindi maikarga';

  @override
  String get chatImageMessage => '[Larawan]';

  @override
  String get chatVoiceMessage => '[Boses]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[File]';

  @override
  String get chatLocationMessage => '[Lokasyon]';

  @override
  String get chatContactCardMessage => '[Contact]';

  @override
  String get chatCallLogMessage => '[Tawag]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Nabasa ng $count';
  }

  @override
  String get chatUnread => 'Hindi pa nababasa';

  @override
  String get chatRecalledSelf => 'Binawi mo ang isang mensahe';

  @override
  String chatRecalledPeer(String sender) {
    return 'Binawi ni $sender ang isang mensahe';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Salin: $translation';
  }

  @override
  String get chatMessageDeleted => 'Nabura ang mensahe';

  @override
  String get chatPeer => 'Iba pa';

  @override
  String get chatSelf => 'Ako';

  @override
  String get chatGenericMessage => '[Mensahe]';

  @override
  String get chatVoiceHideText => 'Itago ang teksto';

  @override
  String get chatVoiceShowText => 'Gawing teksto';

  @override
  String get chatFileDefaultName => 'File';

  @override
  String get chatContactDefaultName => 'Contact';

  @override
  String get chatContactCardTitle => 'Contact card';

  @override
  String get chatCallMissed => 'Hindi nasagot';

  @override
  String get chatCallCancelled => 'Nakansela';

  @override
  String get chatCallRejected => 'Tinanggihan';

  @override
  String get chatCallDisconnected => 'Nadiskonekta';

  @override
  String get chatCallEnded => 'Natapos ang tawag';

  @override
  String get chatCallFailed => 'Hindi natuloy ang tawag';

  @override
  String chatCallDuration(String duration) {
    return 'Tagal $duration';
  }

  @override
  String get chatVideoCallTitle => 'Video call';

  @override
  String get chatVoiceCallTitle => 'Voice call';

  @override
  String get chatToolPhotos => 'Mga larawan';

  @override
  String get chatToolCamera => 'Camera';

  @override
  String get chatToolFile => 'File';

  @override
  String get chatToolLocation => 'Lokasyon';

  @override
  String get chatToolContactCard => 'Contact';

  @override
  String get chatToolVoiceCall => 'Voice call';

  @override
  String get chatToolVideoCall => 'Video call';

  @override
  String get chatToolFavorites => 'Mga paborito';

  @override
  String get chatToolTranslate => 'Isalin';

  @override
  String get chatTranslationChooseLanguage => 'Pumili ng wika ng pagsasalin';

  @override
  String get chatTranslationEnterText => 'Maglagay muna ng teksto';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Hindi available ang pagsasalin para sa mga mensaheng may pagbanggit';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Hindi available ang pagsasalin habang ine-edit ang nakaiskedyul na mensahe';

  @override
  String get chatTranslationFailed => 'Hindi naisalin. Subukang muli';

  @override
  String get chatTranslationEmpty => 'Walang ibinalik na salin. Subukang muli';

  @override
  String get chatTranslationTranslating => 'Isinasalin…';

  @override
  String get chatTranslationSend => 'Ipadala ang salin';

  @override
  String get chatTranslationSending => 'Ipinapadala…';

  @override
  String get chatTranslationExpand => 'Magpakita pa';

  @override
  String get chatTranslationCollapse => 'Magpakita ng mas kaunti';

  @override
  String get chatFileTooLarge => 'Lampas sa limitasyon ang file (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Tanging may-ari o piling miyembro lang ang makapagsasalita.';

  @override
  String get chatImageUploadUnsupported =>
      'Hindi na-upload ang larawan. Hindi pa available ang suporta sa server.';

  @override
  String get chatFavoriteLongPressHint =>
      'Pindutin nang matagal ang mensahe para idagdag sa mga paborito';

  @override
  String chatSelectedCount(int count) {
    return '$count napili';
  }

  @override
  String get chatLocationSheetTitle => 'Ipadala ang lokasyon';

  @override
  String get chatLocationNameLabel => 'Pangalan ng lugar';

  @override
  String get chatLocationNameHint => 'hal. Opisina, address ng customer';

  @override
  String get chatLocationAddressLabel => 'Address';

  @override
  String get chatLocationOptionalHint => 'Opsyonal';

  @override
  String get chatLocationLatitudeLabel => 'Latitude';

  @override
  String get chatLocationLatitudeHint => '-90 hanggang 90';

  @override
  String get chatLocationLongitudeLabel => 'Longitude';

  @override
  String get chatLocationLongitudeHint => '-180 hanggang 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Ilagay ang $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return 'Wala sa saklaw ang $label';
  }

  @override
  String get chatLocationDefaultTitle => 'Lokasyon';

  @override
  String get chatMutedFullNotice =>
      'Naka-mute ang grupong ito. Tanging may-ari o piling miyembro lang ang makapagsasalita.';

  @override
  String get chatNotFriendSendBlocked =>
      'Hindi na kayo magkaibigan at hindi makapagpadala ng mensahe';

  @override
  String get chatPersonalNotesTitle => 'Mga personal na tala';

  @override
  String get chatWorkNotesTitle => 'Mga tala sa trabaho';

  @override
  String get chatPersonalNotesDescription =>
      'Isulat ang mga personal na ideya at i-save ang mahalagang impormasyon dito\nNaka-sync sa mga device para ma-access anumang oras';

  @override
  String get chatWorkNotesDescription =>
      'Itala ang mga gawain at i-save ang mga materyal sa trabaho dito\nHiwalay at ligtas ang mga espasyo ng koponan';

  @override
  String get chatNoMessages => 'Walang mensahe';

  @override
  String chatReplyTo(String sender) {
    return 'Tumugon kay $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return 'Malapit nang dumating ang $feature';
  }

  @override
  String get chatForwardSelectTitle => 'Pumili ng chat';

  @override
  String get chatContactSelectTitle => 'Pumili ng contact';

  @override
  String get chatNoContacts => 'Walang contact';

  @override
  String get contactsTitle => 'Mga contact';

  @override
  String get contactsSearch => 'Maghanap ng contact';

  @override
  String get contactsNewFriends => 'Mga bagong kaibigan';

  @override
  String get contactsGroups => 'Mga grupo';

  @override
  String get contactsFavorites => 'Mga paborito';

  @override
  String get contactsRecent => 'Kamakailan';

  @override
  String get contactsOrganization => 'Organisasyon';

  @override
  String get contactsAnnouncement => 'Mga anunsiyo';

  @override
  String get contactsNewApplications => 'Mga bagong aplikasyon';

  @override
  String get contactsCustomerGroups => 'Mga grupo ng customer';

  @override
  String get contactsAllCustomers => 'Lahat ng customer';

  @override
  String get contactsMyCustomers => 'Mga customer ko';

  @override
  String get contactsViewAll => 'Tingnan lahat';

  @override
  String get contactsMyContacts => 'Mga contact ko';

  @override
  String get contactsMyAdvisor => 'Tagapayo ko';

  @override
  String get contactsNoAdvisor => 'Wala pang nakatalagang tagapayo';

  @override
  String get contactsAdvisorLoading => 'Naglo-load...';

  @override
  String get contactsNavigateFailed =>
      'Hindi makapunta sa pahina, subukang muli';

  @override
  String get contactsEmpty => 'Walang contact';

  @override
  String get contactsNoAnnouncement => 'Walang anunsiyo';

  @override
  String get contactsOfficialBadge => 'Opisyal';

  @override
  String get contactsCustomerBadge => 'Customer';

  @override
  String get contactsEmptyCustomers => 'Walang customer';

  @override
  String get myTitle => 'Ako';

  @override
  String get myEnterpriseInfo => 'Impormasyon ng negosyo';

  @override
  String get myEnterpriseManage => 'Pamamahala ng negosyo';

  @override
  String get myQrCode => 'QR code';

  @override
  String get myFavorites => 'Mga paborito';

  @override
  String get myLanguage => 'Wika';

  @override
  String get myTimezone => 'Time zone';

  @override
  String get myAutoTranslate => 'Awtomatikong pagsasalin';

  @override
  String get myNetworkSwitch => 'Palitan ang linya';

  @override
  String get mySettings => 'Mga Setting';

  @override
  String get myLogout => 'Mag-logout';

  @override
  String get myLogoutConfirm => 'Sigurado ka bang gusto mong mag-sign out?';

  @override
  String get myLeaveEnterprise => 'Umalis sa negosyo';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Sigurado ka bang aalis ka sa negosyong ito? Mawawalan ka ng access sa data ng negosyo.';

  @override
  String get myLeaveEnterpriseSuccess => 'Nakaalis na sa negosyo';

  @override
  String get myLeaveEnterpriseFailed => 'Hindi makaalis, subukang muli';

  @override
  String get myLppIdCopied => 'Nakopya ang StartLink ID';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count contact';
  }

  @override
  String get myAutoSelect => 'Awtomatiko';

  @override
  String get myPresenceStatus => 'Presensya';

  @override
  String get myPresenceStatusTitle => 'Itakda ang presensya';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Abala';

  @override
  String get myPresenceAway => 'Wala muna';

  @override
  String get myPresenceInvisible => 'Hindi nakikita';

  @override
  String get profileTitle => 'Aking Profile';

  @override
  String get profileName => 'Pangalan';

  @override
  String get profileGender => 'Kasarian';

  @override
  String get profileBirthday => 'Kaarawan';

  @override
  String get profileRegion => 'Rehiyon';

  @override
  String get profileSignature => 'Talambuhay';

  @override
  String get profileSignatureHint => 'Magkuwento tungkol sa iyong sarili';

  @override
  String get profileTapTapText => 'Tapik';

  @override
  String get profileTapTapHint =>
      'Tekstong ipinapakita kapag tinapik (hanggang 20 character)';

  @override
  String get profileAccountSection => 'Account';

  @override
  String get profileBasicSection => 'Pangunahing impormasyon';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'Hindi pa itinakda';

  @override
  String get profileMobile => 'Telepono';

  @override
  String get profileMobileUnbound => 'Hindi Naka-link';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailUnbound => 'Hindi Naka-link';

  @override
  String get profileQrCode => 'QR code ko';

  @override
  String get profileChangePassword => 'Baguhin ang Password';

  @override
  String get profileGenderMale => 'Lalaki';

  @override
  String get profileGenderFemale => 'Babae';

  @override
  String get profileGenderOther => 'Iba pa';

  @override
  String get profileGenderUnset => 'Hindi pa itinakda';

  @override
  String get profileSaveFailed => 'Hindi na-save, subukang muli';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'Isang beses lang maaaring baguhin ang StartLink ID. Pag-isipang mabuti ang pipiliin.';

  @override
  String get profileLppIdChangeFailed =>
      'Hindi nabago (isang beses lang maaaring baguhin ang StartLink ID)';

  @override
  String get profileChangePasswordOld => 'Kasalukuyang password';

  @override
  String get profileChangePasswordNew => 'Bagong Password';

  @override
  String get profileChangePasswordConfirm => 'Kumpirmahin ang Bagong Password';

  @override
  String get profileChangePasswordMismatch =>
      'Hindi magkapareho ang mga password';

  @override
  String get profileChangePasswordSuccess =>
      'Nabago ang password. Mag-sign in muli.';

  @override
  String get profileChangePasswordFailed =>
      'Hindi nabago ang password, subukang muli';

  @override
  String get settingsTitle => 'Mga Setting';

  @override
  String get settingsSectionEnterprise => 'Negosyo';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsSectionGeneral => 'Pangkalahatan';

  @override
  String get settingsSectionFeatures => 'Mga feature';

  @override
  String get settingsSectionAbout => 'Tungkol';

  @override
  String get settingsEnterpriseInfo => 'Impormasyon ng negosyo';

  @override
  String get settingsProfile => 'Aking Profile';

  @override
  String get settingsAccountSecurity => 'Seguridad ng account';

  @override
  String get settingsNotification => 'Mga abiso';

  @override
  String get settingsDisplay => 'Display';

  @override
  String get settingsFriendPrivacy => 'Privacy';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsChatHistory => 'Kasaysayan ng chat';

  @override
  String get settingsAbout => 'Tungkol sa StartLink';

  @override
  String get settingsLanguage => 'Wika';

  @override
  String get settingsTimezone => 'Time zone';

  @override
  String get settingsAutoTranslate => 'Awtomatikong pagsasalin';

  @override
  String get settingsNetworkSwitch => 'Palitan ang linya';

  @override
  String get enterpriseInfoTitle => 'Impormasyon ng negosyo';

  @override
  String get enterpriseName => 'Pangalan';

  @override
  String get enterpriseDescription => 'Paglalarawan';

  @override
  String get enterpriseUpdateSuccess => 'Matagumpay na na-update';

  @override
  String get enterpriseUpdateFailed => 'Hindi na-update, subukang muli';

  @override
  String get enterpriseLeave => 'Umalis sa negosyo';

  @override
  String get enterpriseLeaveConfirm =>
      'Sigurado ka bang aalis ka sa negosyong ito?';

  @override
  String get enterpriseLeaveSuccess => 'Nakaalis na sa negosyo';

  @override
  String get enterpriseLeaveFailed => 'Hindi makaalis, subukang muli';

  @override
  String get enterpriseLeaveOwnerError =>
      'Hindi maaaring umalis agad ang may-ari. Ilipat muna ang pagmamay-ari.';

  @override
  String get enterpriseMemberCount => 'Mga miyembro';

  @override
  String get enterpriseCreatedAt => 'Ginawa';

  @override
  String get enterpriseCode => 'Code ng negosyo';

  @override
  String get enterpriseInviteMembers => 'Mag-imbita ng miyembro';

  @override
  String get enterpriseCopyInviteCode => 'Kopyahin ang code ng imbitasyon';

  @override
  String get enterpriseInviteCodeCopied => 'Nakopya ang code ng imbitasyon';

  @override
  String get groupCreateTitle => 'Bagong grupo';

  @override
  String get groupNameHint => 'Ilagay ang pangalan ng grupo';

  @override
  String get groupCreateSuccess => 'Nagawa ang grupo';

  @override
  String get groupCreateFailed => 'Hindi nagawa ang grupo';

  @override
  String get groupSettings => 'Mga setting ng grupo';

  @override
  String get groupName => 'Pangalan ng grupo';

  @override
  String get groupAvatar => 'Avatar ng grupo';

  @override
  String get groupAnnouncement => 'Anunsiyo';

  @override
  String get groupMembers => 'Mga miyembro';

  @override
  String get groupAddMember => 'Magdagdag ng miyembro';

  @override
  String get groupRemoveMember => 'Alisin ang miyembro';

  @override
  String get groupRemoveMemberConfirm => 'Alisin ang miyembrong ito?';

  @override
  String get groupSetAdmin => 'Gawing admin';

  @override
  String get groupRemoveAdmin => 'Alisin bilang admin';

  @override
  String get groupTransferOwner => 'Ilipat ang pagmamay-ari';

  @override
  String get groupTransferOwnerConfirm =>
      'Ilipat ang pagmamay-ari ng grupo sa miyembrong ito?';

  @override
  String get groupTransferOwnerSuccess => 'Nailipat ang pagmamay-ari';

  @override
  String get groupTransferOwnerFailed => 'Hindi nailipat, subukang muli';

  @override
  String get groupLeave => 'Umalis sa grupo';

  @override
  String get groupLeaveConfirm => 'Umalis sa grupong ito?';

  @override
  String get groupLeaveSuccess => 'Nakaalis na sa grupo';

  @override
  String get groupLeaveFailed => 'Hindi makaalis, subukang muli';

  @override
  String get groupDissolve => 'Buwagin ang grupo';

  @override
  String get groupDissolveConfirm =>
      'Buwagin ang grupong ito? Aalisin ang lahat ng miyembro.';

  @override
  String get groupDissolveSuccess => 'Nabuwag ang grupo';

  @override
  String get groupDissolveFailed => 'Hindi nabuwag, subukang muli';

  @override
  String get groupQrCode => 'QR code ng grupo';

  @override
  String get groupMuteAll => 'I-mute lahat';

  @override
  String get groupMuteAllOn => 'I-on ang pag-mute sa lahat';

  @override
  String get groupMuteAllOff => 'I-off ang pag-mute sa lahat';

  @override
  String get groupAllowMemberInvite => 'Payagang mag-imbita ang mga miyembro';

  @override
  String get groupAllowMemberModifyTitle =>
      'Payagang baguhin ng mga miyembro ang pangalan ng grupo';

  @override
  String get groupAllowMemberAtAll =>
      'Payagang banggitin ng mga miyembro ang @Lahat';

  @override
  String get groupAllowMemberViewMemberList =>
      'Payagang makita ng mga miyembro ang listahan ng miyembro';

  @override
  String get groupAllowQrCodeJoin => 'Payagang sumali gamit ang QR code';

  @override
  String get groupRequireApproval => 'Kailangan ng pag-apruba para sumali';

  @override
  String get groupAllowMemberAddFriend =>
      'Payagang magdagdag ang mga miyembro sa isa\'t isa';

  @override
  String get groupRoleOwner => 'May-ari';

  @override
  String get groupRoleAdmin => 'Admin';

  @override
  String get groupRoleMember => 'Miyembro';

  @override
  String get groupNoMembers => 'Walang miyembro';

  @override
  String get groupNoAnnouncements => 'Walang anunsiyo';

  @override
  String get groupCreateAnnouncement => 'Mag-post ng anunsiyo';

  @override
  String get groupEditAnnouncement => 'I-edit ang anunsiyo';

  @override
  String get groupDeleteAnnouncement => 'Burahin ang anunsiyo';

  @override
  String get groupDeleteAnnouncementConfirm => 'Burahin ang anunsiyong ito?';

  @override
  String get groupAnnouncementTitle => 'Pamagat';

  @override
  String get groupAnnouncementContent => 'Nilalaman';

  @override
  String get groupAnnouncementPin => 'I-pin ang anunsiyo';

  @override
  String groupMemberCount(int count) {
    return '$count miyembro';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count napili';
  }

  @override
  String get groupJoinRequestApprove => 'Sumasang-ayon';

  @override
  String get groupJoinRequestReject => 'Tanggihan';

  @override
  String get groupJoinRequests => 'Mga kahilingang sumali';

  @override
  String get groupNoJoinRequests => 'Walang kahilingang sumali';

  @override
  String get groupReadReceipts => 'Mga resibo ng pagbasa';

  @override
  String groupReadCount(int count) {
    return '$count nabasa na';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count hindi pa nababasa';
  }

  @override
  String get friendAddTitle => 'Magdagdag ng contact';

  @override
  String get friendSearchHint => 'Telepono / Email / StartLink ID';

  @override
  String get friendRequestSent => 'Naipadala ang friend request';

  @override
  String get friendRequestFailed => 'Hindi naipadala, subukang muli';

  @override
  String get friendAlreadyFriend => 'Magka-contact na';

  @override
  String get friendNewFriendsTitle => 'Mga bagong kaibigan';

  @override
  String get friendNoRequests => 'Walang friend request';

  @override
  String get friendAccept => 'Tanggapin';

  @override
  String get friendReject => 'Tanggihan';

  @override
  String get friendAccepted => 'Tinanggap';

  @override
  String get friendRejected => 'Rejected';

  @override
  String get friendDeleteConfirm => 'Alisin ang contact na ito?';

  @override
  String get friendDeleteSuccess => 'Naalis ang contact';

  @override
  String get friendDeleteFailed => 'Hindi naalis, subukang muli';

  @override
  String get friendRemarkName => 'Palayaw';

  @override
  String get friendGroupName => 'Grupo';

  @override
  String get friendSendMessage => 'Mensahe';

  @override
  String get friendMatchTypeLppId => 'Nakatugma ayon sa StartLink ID';

  @override
  String get friendMatchTypeMobile => 'Nakatugma ayon sa telepono';

  @override
  String get friendMatchTypeEmail => 'Nakatugma ayon sa email';

  @override
  String get friendSearchEmpty => 'Walang nahanap na user';

  @override
  String get friendAddMessage => 'Gusto kitang idagdag bilang contact';

  @override
  String get friendBlockConfirm => 'I-block ang user na ito?';

  @override
  String get friendUnblockConfirm => 'I-unblock ang user na ito?';

  @override
  String get friendBlockSuccess => 'Na-block';

  @override
  String get friendUnblockSuccess => 'Na-unblock';

  @override
  String get profilePageTitle => 'Personal na Impormasyon';

  @override
  String get profilePageSendMessage => 'Mensahe';

  @override
  String get profilePageAddFriend => 'Magdagdag ng kaibigan';

  @override
  String get profilePageAlreadyFriend => 'Magkaibigan na';

  @override
  String get profilePageBlocked => 'Na-block';

  @override
  String get profilePageBlock => 'I-block';

  @override
  String get profilePageUnblock => 'I-unblock';

  @override
  String get profilePageHidden => 'Itinago ng user na ito ang kanilang profile';

  @override
  String get profilePageFriendsOnly =>
      'Sa mga kaibigan lang ipinapakita ng user na ito ang profile';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'Mga Tala';

  @override
  String get profilePageEditRemark => 'I-edit ang palayaw';

  @override
  String get profilePageSaveRemarkSuccess => 'Na-save ang palayaw';

  @override
  String get profilePageSaveRemarkFailed => 'Hindi na-save, subukang muli';

  @override
  String get searchTitle => 'Maghanap';

  @override
  String get searchHint => 'Maghanap gamit ang telepono, email o StartLink ID';

  @override
  String get searchNoResults => 'Walang nahanap na resulta';

  @override
  String get searchMessages => 'Mga Mensahe';

  @override
  String get searchUsers => 'Mga user';

  @override
  String get searchFailed => 'Hindi nakapaghanap, subukang muli';

  @override
  String get scanTitle => 'I-scan';

  @override
  String get scanFailed => 'Hindi nakilala, subukang muli';

  @override
  String get scanInvalidQrCode => 'Hindi wastong QR code';

  @override
  String get scanFlashOn => 'I-on ang flashlight';

  @override
  String get scanFlashOff => 'I-off ang flashlight';

  @override
  String get scanAlbum => 'Pumili mula sa Album';

  @override
  String get favoritesTitle => 'Mga paborito';

  @override
  String get favoritesEmpty => 'Wala pang nai-save';

  @override
  String get favoritesAll => 'Lahat';

  @override
  String get favoritesText => 'Teksto';

  @override
  String get favoritesImage => 'Mga larawan';

  @override
  String get favoritesVideo => 'Bidyo';

  @override
  String get favoritesVoice => 'Boses';

  @override
  String get favoritesFile => 'Mga file';

  @override
  String get favoritesOther => 'Iba pa';

  @override
  String get favoritesDeleteConfirm => 'Alisin sa mga paborito?';

  @override
  String get favoritesDeleteSuccess => 'Inalis sa mga nasave';

  @override
  String get favoritesDeleteFailed => 'Hindi naalis';

  @override
  String get favoritesOriginalRecalled => 'Binawi ang mensahe';

  @override
  String get favoritesViewOriginal => 'Tingnan ang orihinal';

  @override
  String get favoritesSearchHint => 'Maghanap sa mga paborito';

  @override
  String get favoritesNoResults => 'Walang tumugmang paborito';

  @override
  String get noticeTitle => 'Mga anunsiyo';

  @override
  String get noticeEmpty => 'Walang anunsiyo';

  @override
  String get noticeDetail => 'Detalye ng anunsiyo';

  @override
  String get noticePublishedAt => 'Na-publish';

  @override
  String get noticePriorityNormal => 'Normal';

  @override
  String get noticePriorityImportant => 'Mahalaga';

  @override
  String get noticePriorityUrgent => 'Agaran';

  @override
  String get organizationTitle => 'Organisasyon';

  @override
  String get organizationEmpty => 'Walang impormasyon ng departamento';

  @override
  String get organizationMembers => 'Mga miyembro';

  @override
  String get organizationDepartment => 'Departamento';

  @override
  String get organizationPosition => 'Posisyon';

  @override
  String get organizationLeader => 'Pinuno';

  @override
  String get qrCodeTitle => 'QR code ko';

  @override
  String get qrCodeSave => 'I-save sa Album';

  @override
  String get qrCodeShare => 'Ibahagi';

  @override
  String get qrCodeSaveSuccess => 'Na-save sa album';

  @override
  String get qrCodeSaveFailed => 'Hindi na-save, subukang muli';

  @override
  String get qrCodeRefresh => 'I-refresh ang QR code';

  @override
  String get qrCodeExpired => 'Nag-expire ang QR code, i-refresh ito';

  @override
  String get qrCodeScanToAdd => 'I-scan para idagdag ako bilang contact';

  @override
  String get spacePersonal => 'Personal';

  @override
  String get spaceEnterprise => 'Negosyo';

  @override
  String get spaceJoinByCode => 'Sumali gamit ang code ng negosyo';

  @override
  String get spaceJoinByInvite => 'Sumali gamit ang code ng imbitasyon';

  @override
  String get spaceEnterCode => 'Ilagay ang code ng negosyo';

  @override
  String get spaceEnterInviteCode => 'Ilagay ang code ng imbitasyon';

  @override
  String get spaceSearchEnterprise => 'Maghanap ng negosyo';

  @override
  String get spaceJoinRequestSent =>
      'Naipadala ang kahilingan, naghihintay ng pag-apruba';

  @override
  String get spaceJoinRequestPending => 'Naghihintay ng pag-apruba';

  @override
  String get spaceJoinRequestApproved => 'Naaprubahan ang kahilingan';

  @override
  String get spaceJoinRequestRejected => 'Tinanggihan ang kahilingan';

  @override
  String get spaceAlreadyMember => 'Miyembro ka na';

  @override
  String get spaceAutoApproved =>
      'Awtomatikong naaprubahan. Maligayang pagdating!';

  @override
  String get spacePendingApprovalHint =>
      'Matagumpay ang pagpaparehistro. Naipadala na ang iyong kahilingang sumali.';

  @override
  String get spaceNoSpaces => 'Walang espasyo';

  @override
  String get spaceInviteExpired => 'Nag-expire ang code ng imbitasyon';

  @override
  String get spaceInviteTargetMismatch =>
      'Hindi para sa account mo ang code ng imbitasyong ito';

  @override
  String get spaceAcceptInviteSuccess => 'Matagumpay na nakasali sa negosyo';

  @override
  String get spaceAcceptInviteFailed => 'Hindi nakasali, subukang muli';

  @override
  String get spaceTenantSelectTitle => 'Pumili ng espasyo';

  @override
  String get spaceTenantSelectHint => 'Pumili ng espasyong papasukan';

  @override
  String get spaceEnterPersonal => 'Pumasok sa personal na espasyo';

  @override
  String get spaceEnterEnterprise => 'Pumasok sa espasyo ng negosyo';

  @override
  String get aboutTitle => 'Tungkol sa StartLink';

  @override
  String get aboutVersion => 'Bersyon';

  @override
  String get aboutTerms => 'Kasunduan sa Paggamit';

  @override
  String get aboutPrivacy => 'Patakaran sa Pagkapribado';

  @override
  String get aboutOpenSource => 'Mga lisensiya ng open source';

  @override
  String get aboutCheckUpdate => 'Suriin ang mga update';

  @override
  String get aboutLatestVersion => 'Nasa pinakabagong bersyon ka na.';

  @override
  String get aboutUpdateAvailable => 'Available na ang bagong bersyon';

  @override
  String get aboutUpdateNow => 'I-update Ngayon';

  @override
  String get aboutUpdateLater => 'Mamaya';

  @override
  String get notificationTitle => 'Mga abiso';

  @override
  String get notificationGlobalMute => 'Huwag istorbohin';

  @override
  String get notificationSound => 'Tunog';

  @override
  String get notificationVibration => 'Pag-vibrate';

  @override
  String get notificationPreview => 'Preview ng mensahe';

  @override
  String get notificationDndStart => 'Simula ng huwag istorbohin';

  @override
  String get notificationDndEnd => 'Wakas ng huwag istorbohin';

  @override
  String get blacklistTitle => 'Nakablistahan';

  @override
  String get blacklistEmpty => 'Walang naka-block na user';

  @override
  String get blacklistRemove => 'I-unblock';

  @override
  String get blacklistRemoveConfirm => 'I-unblock ang user na ito?';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackTypeComplaint => 'Reklamo';

  @override
  String get feedbackTypeSuggestion => 'Mungkahi';

  @override
  String get feedbackTypeBug => 'Ulat ng bug';

  @override
  String get feedbackContent => 'Paglalarawan';

  @override
  String get feedbackContentHint =>
      'Ilarawan nang detalyado ang iyong problema o mungkahi';

  @override
  String get feedbackContact => 'Contact (opsyonal)';

  @override
  String get feedbackSubmit => 'Isumite';

  @override
  String get feedbackSuccess => 'Naipadala ang feedback. Salamat!';

  @override
  String get feedbackFailed => 'Hindi naisumite, subukang muli';

  @override
  String get networkTitle => 'Palitan ang linya';

  @override
  String get networkAutoSelect => 'Awtomatiko';

  @override
  String get networkManual => 'Manwal';

  @override
  String get timezoneTitle => 'Time zone';

  @override
  String get timezoneAuto => 'Sundin ang system';

  @override
  String get autoTranslateTitle => 'Awtomatikong pagsasalin';

  @override
  String get autoTranslateEnabled => 'I-on ang awtomatikong pagsasalin';

  @override
  String get autoTranslateLanguage => 'Target na wika';

  @override
  String get displayTitle => 'Display';

  @override
  String get displayFontSize => 'Sukat ng Font';

  @override
  String get displayChatBackground => 'Background ng chat';

  @override
  String get displayDarkMode => 'Hitsura';

  @override
  String get displayDarkModeSystem => 'Sundin ang system';

  @override
  String get displayDarkModeSystemHint =>
      'Awtomatikong lumipat ayon sa setting ng system';

  @override
  String get displayDarkModeOff => 'Maliwanag';

  @override
  String get displayDarkModeOffHint => 'Laging gamitin ang maliwanag na tema';

  @override
  String get displayDarkModeOn => 'Madilim';

  @override
  String get displayDarkModeOnHint => 'Laging gamitin ang madilim na tema';

  @override
  String get chatSettingsTitle => 'Chat';

  @override
  String get chatHistoryTitle => 'Kasaysayan ng chat';

  @override
  String get chatHistoryClear => 'Burahin ang lahat ng kasaysayan';

  @override
  String get chatHistoryClearConfirm =>
      'Burahin ang lahat ng kasaysayan ng chat? Hindi ito mababawi.';

  @override
  String get chatHistoryClearSuccess => 'Nabura ang kasaysayan ng chat';

  @override
  String get accountSecurityTitle => 'Seguridad ng account';

  @override
  String get accountSecurityChangePassword => 'Baguhin ang Password';

  @override
  String get accountSecurityChangeMobile => 'Baguhin ang Numero ng Telepono';

  @override
  String get accountSecurityChangeEmail => 'Baguhin ang email';

  @override
  String get accountSecurityLoggedDevices => 'Mga naka-sign in na device';

  @override
  String get accountSecurityDeactivate => 'I-deactivate ang account';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Permanenteng mabubura ang lahat ng data pagkatapos ng 7 araw. I-deactivate?';

  @override
  String get loggedDevicesTitle => 'Mga naka-sign in na device';

  @override
  String get loggedDevicesCurrent => 'Device na ito';

  @override
  String get loggedDevicesRevoke => 'Mag-sign out';

  @override
  String get loggedDevicesRevokeConfirm => 'Mag-sign out sa device na ito?';

  @override
  String get loggedDevicesRevokeSuccess => 'Nakapag-sign out sa device';

  @override
  String get loggedDevicesRevokeFailed => 'Hindi nagawa, subukang muli';

  @override
  String get loggedDevicesLastActive => 'Huling aktibo';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Desktop';

  @override
  String get loggedDevicesTypeUnknown => 'Hindi kilalang device';

  @override
  String get privacySettingsTitle => 'Privacy';

  @override
  String get privacySearchableByMobile =>
      'Payagang hanapin gamit ang numero ng telepono';

  @override
  String get privacySearchableByLppId =>
      'Payagang hanapin gamit ang StartLink ID';

  @override
  String get privacyAllowFriendRequest => 'Payagan ang mga friend request';

  @override
  String get privacyProfileVisibility => 'Pagiging nakikita ng profile';

  @override
  String get privacyEveryone => 'Lahat';

  @override
  String get privacyFriendsOfFriends => 'Mga kaibigan ng kaibigan';

  @override
  String get privacyNobody => 'Wala';

  @override
  String get privacyFriendsOnly => 'Mga kaibigan lang';

  @override
  String get privacySaveSuccess => 'Na-save ang mga setting';

  @override
  String get privacySaveFailed => 'Hindi na-save, subukang muli';

  @override
  String get fontSizeTitle => 'Sukat ng Font';

  @override
  String get fontSizeSmall => 'Maliit';

  @override
  String get fontSizeNormal => 'Karaniwan';

  @override
  String get fontSizeLarge => 'Malaki';

  @override
  String get fontSizeExtraLarge => 'Napakalaki';

  @override
  String get fontSizePreview => 'Preview';

  @override
  String get chatBackgroundTitle => 'Background ng chat';

  @override
  String get chatBackgroundDefault => 'Default';

  @override
  String get chatBackgroundCustom => 'Custom';

  @override
  String get chatBackgroundReset => 'Ibalik sa Default';

  @override
  String get termsTitle => 'Kasunduan sa Paggamit';

  @override
  String get privacyPolicyTitle => 'Patakaran sa Pagkapribado';

  @override
  String get recentContactsTitle => 'Kamakailan';

  @override
  String get recentContactsEmpty => 'Walang kamakailang contact';

  @override
  String get inviteFriendsTitle => 'Mag-imbita ng kaibigan';

  @override
  String get inviteFriendsCopyLink => 'Kopyahin ang link ng imbitasyon';

  @override
  String get inviteFriendsLinkCopied => 'Nakopya ang link ng imbitasyon';

  @override
  String get imageViewerTitle => 'Larawan';

  @override
  String get imageViewerSave => 'I-save sa Album';

  @override
  String get imageViewerSaveSuccess => 'Na-save sa album';

  @override
  String get imageViewerSaveFailed => 'Hindi na-save, subukang muli';

  @override
  String get customerServiceTitle => 'Desk ng serbisyo';

  @override
  String get customerServiceQueue => 'Nakapila';

  @override
  String get customerServiceActive => 'Aktibo';

  @override
  String get customerServiceClaim => 'Tanggapin';

  @override
  String get customerServiceTakeover => 'Pangasiwaan';

  @override
  String get customerServiceClose => 'Tapusin ang serbisyo';

  @override
  String get customerServiceCloseConfirm =>
      'Tapusin ang session ng serbisyong ito?';

  @override
  String get customerServiceNoQueue => 'Walang nakapilang session';

  @override
  String get customerServiceNoActive => 'Walang aktibong session';

  @override
  String get customerServiceVisitor => 'Bisita';

  @override
  String get customerServiceCustomer => 'Customer';

  @override
  String get customerServiceAssignedTo => 'Nakatalaga kay';

  @override
  String get customerServiceTransferConversation => 'Ilipat ang chat';

  @override
  String get marketingToolbar => 'Mga tool sa marketing';

  @override
  String get callIncoming => 'Papasok na tawag';

  @override
  String get callOutgoing => 'Papalabas na tawag';

  @override
  String get callAccept => 'Tanggapin';

  @override
  String get callReject => 'Tanggihan';

  @override
  String get callHangup => 'Tapusin';

  @override
  String get callMissed => 'Hindi nasagot na tawag';

  @override
  String get callDuration => 'Tagal';

  @override
  String get callAudio => 'Voice call';

  @override
  String get callGeneric => 'Tawag';

  @override
  String get callVideo => 'Video call';

  @override
  String get callConnecting => 'Kumokonekta...';

  @override
  String get callRinging => 'Tumutunog...';

  @override
  String get callEnded => 'Natapos ang tawag';

  @override
  String get callFailed => 'Hindi natuloy ang tawag';

  @override
  String get callRejected => 'Tinanggihan ang tawag';

  @override
  String get callTimeout => 'Walang sagot';

  @override
  String get callCancelled => 'Nakansela';

  @override
  String get callUnknownPeer => 'Hindi kilala';

  @override
  String get callVideoInvitation => 'Imbitasyon sa video call';

  @override
  String get callAudioInvitation => 'Imbitasyon sa voice call';

  @override
  String get callAnswerAudio => 'Sagutin gamit ang boses';

  @override
  String get callAnswerVideo => 'Sagutin gamit ang video';

  @override
  String get callViewProfile => 'Tingnan ang profile';

  @override
  String get callOpeningCamera => 'Binubuksan ang camera...';

  @override
  String get callWaitingRemoteVideo => 'Hinihintay ang video ng kausap...';

  @override
  String get callCameraOff => 'Naka-off ang camera';

  @override
  String get callCameraOn => 'Naka-on ang camera';

  @override
  String get callMicrophoneOff => 'Naka-off ang mikropono';

  @override
  String get callMicrophoneOn => 'Naka-on ang mikropono';

  @override
  String get callSpeakerOff => 'Naka-off ang speaker';

  @override
  String get callSpeakerOn => 'Naka-on ang speaker';

  @override
  String get callVideoPermissionFailure =>
      'Hindi masimulan ang video call. Suriin ang mga pahintulot sa camera at mikropono at subukang muli.';

  @override
  String get callAudioPermissionFailure =>
      'Hindi masimulan ang voice call. Suriin ang pahintulot sa mikropono at subukang muli.';

  @override
  String get callIncompleteIncoming =>
      'Hindi kumpleto ang impormasyon ng papasok na tawag at hindi ito masasagot.';

  @override
  String get callInProgress => 'Nasa tawag';

  @override
  String get callCalling => 'Tumatawag...';

  @override
  String callEndedMedia(String media) {
    return 'Natapos ang $media';
  }

  @override
  String callRejectedMedia(String media) {
    return 'Tinanggihan ang $media';
  }

  @override
  String callUnansweredMedia(String media) {
    return 'Hindi nasagot ang $media';
  }

  @override
  String callCancelledMedia(String media) {
    return 'Nakansela ang $media';
  }

  @override
  String get callConnectionLost => 'Naputol ang koneksiyon ng tawag';

  @override
  String get callAdminEnded => 'Tinapos ng administrator ang tawag';

  @override
  String callFailedMedia(String media) {
    return 'Hindi natuloy ang $media';
  }

  @override
  String get callBusy => 'Abala ang kausap';

  @override
  String callDurationValue(String duration) {
    return 'Tagal ng tawag $duration';
  }

  @override
  String get callNotConnected => 'Hindi nakakonekta';

  @override
  String get callDialed => 'Papalabas';

  @override
  String get callAnswered => 'Nasagot';

  @override
  String get callRejectedByPeer => 'Tinanggihan ng kausap';

  @override
  String get callRejectedBySelf => 'Rejected';

  @override
  String get callPeerDidNotAnswer => 'Hindi sumagot ang kausap';

  @override
  String get callMissedIncoming => 'Hindi nasagot na papasok na tawag';

  @override
  String get callPeerCancelled => 'Kinansela ng kausap';

  @override
  String get notificationNewMessageTitle => 'Bagong mensahe sa StartLink';

  @override
  String get notificationOnlineServiceTitle =>
      'Bagong mensahe ng serbisyo sa customer';

  @override
  String get notificationNewMessageBody => 'May natanggap kang bagong mensahe';

  @override
  String get notificationImagePreview => 'Nagpadala ng larawan';

  @override
  String get notificationVideoPreview => 'Nagpadala ng video';

  @override
  String get notificationVoicePreview => 'Nagpadala ng voice message';

  @override
  String get notificationFilePreview => 'Nagpadala ng file';

  @override
  String get notificationContactPreview => 'Nagpadala ng contact card';

  @override
  String get notificationCallLogPreview => 'Nagpadala ng rekord ng tawag';

  @override
  String get notificationLocationPreview => 'Nagbahagi ng lokasyon';

  @override
  String get notificationLinkPreview => 'Nagbahagi ng link';

  @override
  String notificationMentionMe(String body) {
    return 'Binanggit ka: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return 'Binanggit ka ni $sender: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Binanggit ang lahat: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return 'Binanggit ni $sender ang lahat: $body';
  }

  @override
  String get notificationSecurityTitle => 'Babala sa seguridad ng account';

  @override
  String get notificationSecurityBody =>
      'Nabago ang mga setting sa seguridad ng iyong StartLink account. Suriin ngayon.';

  @override
  String get notificationFriendAcceptedTitle => 'Tinanggap ang friend request';

  @override
  String get notificationFriendRejectedTitle =>
      'Tinanggihan ang friend request';

  @override
  String get notificationFriendAcceptedBody =>
      'Tinanggap ng kausap ang iyong friend request';

  @override
  String get notificationFriendRejectedBody =>
      'Tinanggihan ng kausap ang iyong friend request';

  @override
  String get notificationVideoCallTitle => 'Imbitasyon sa video call';

  @override
  String get notificationAudioCallTitle => 'Imbitasyon sa voice call';

  @override
  String notificationVideoCallBody(String caller) {
    return 'Inimbitahan ka ni $caller sa video call';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return 'Inimbitahan ka ni $caller sa voice call';
  }

  @override
  String get notificationMessageChannelName => 'Mga mensahe';

  @override
  String get notificationMessageChannelDescription =>
      'Mga mensahe sa chat, rekord ng tawag, at abiso ng system';

  @override
  String get notificationCallChannelName => 'Mga tawag';

  @override
  String get notificationCallChannelDescription =>
      'Mga abiso sa voice at video call';

  @override
  String get notificationSecurityChannelName => 'Seguridad ng account';

  @override
  String get notificationSecurityChannelDescription =>
      'Mga abiso sa pag-sign in at pagbabago ng password o numero ng mobile';

  @override
  String get notificationUnknownCaller => 'Hindi kilalang tumatawag';

  @override
  String get pendingJoinRequestsTitle => 'Mga bagong aplikasyon';

  @override
  String get pendingJoinRequestsEmpty => 'Walang aplikasyon';

  @override
  String get pendingJoinRequestApprove => 'Sumasang-ayon';

  @override
  String get pendingJoinRequestReject => 'Tanggihan';

  @override
  String get pendingJoinRequestApproveSuccess => 'Naaprubahan';

  @override
  String get pendingJoinRequestRejectSuccess => 'Tinanggihan';

  @override
  String get pendingJoinRequestFailed => 'Hindi naisagawa, subukang muli';

  @override
  String get myCustomersTitle => 'Mga customer ko';

  @override
  String get myCustomersEmpty => 'Walang customer';

  @override
  String get groupListTitle => 'Mga grupo';

  @override
  String get groupListEmpty => 'Walang grupo';

  @override
  String get addFriendTitle => 'Magdagdag ng contact';

  @override
  String get addFriendSearchHint => 'Telepono / Email / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'Idagdag';

  @override
  String get addFriendCannotAddSelf =>
      'Hindi mo maaaring idagdag ang sarili mo';

  @override
  String get addFriendUnsupportedUser =>
      'Hindi maaaring idagdag ang user na ito. Maaari mo silang direktang padalhan ng mensahe.';

  @override
  String get addFriendMessageHint => 'Maglagay ng mensahe';

  @override
  String get addFriendSendRequest => 'Ipadala ang kahilingan';

  @override
  String get joinCompanyTitle => 'Sumali sa negosyo';

  @override
  String get joinCompanyCodeHint => 'Ilagay ang code ng negosyo';

  @override
  String get joinCompanySearchHint => 'Hanapin ang pangalan ng negosyo';

  @override
  String get joinCompanyApply => 'Mag-apply para sumali';

  @override
  String get joinCompanyApplySuccess => 'Naipadala ang aplikasyon';

  @override
  String get joinCompanyApplyFailed => 'Hindi nakapag-apply, subukang muli';

  @override
  String get joinCompanyAutoApproved =>
      'Awtomatikong naaprubahan. Maligayang pagdating!';

  @override
  String get joinCompanyPending =>
      'Naipadala ang aplikasyon, naghihintay ng pag-apruba';

  @override
  String get joinCompanyInviteCodeHint => 'Ilagay ang code ng imbitasyon';

  @override
  String get joinCompanyAcceptInvite => 'Tanggapin ang imbitasyon';

  @override
  String get joinCompanyNoResults => 'Walang nahanap na negosyo';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count miyembro';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Oras sa Pasipiko';

  @override
  String get timezoneNameMountainTime => 'Oras sa Kabundukan';

  @override
  String get timezoneNameCentralTime => 'Gitnang Oras';

  @override
  String get timezoneNameEasternTime => 'Silangang Oras';

  @override
  String get timezoneNameAtlanticTime => 'Oras sa Atlantiko';

  @override
  String get timezoneNameBrasilia => 'Brasilia';

  @override
  String get timezoneNameAzores => 'Azores';

  @override
  String get timezoneNameLondonDublin => 'London/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Paris/Rome';

  @override
  String get timezoneNameCairoHelsinki => 'Cairo/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moscow/Riyadh';

  @override
  String get timezoneNameTehran => 'Tehran';

  @override
  String get timezoneNameDubaiBaku => 'Dubai/Baku';

  @override
  String get timezoneNameKabul => 'Kabul';

  @override
  String get timezoneNameKarachiTashkent => 'Karachi/Tashkent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/New Delhi';

  @override
  String get timezoneNameKathmandu => 'Kathmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Dhaka/Almaty';

  @override
  String get timezoneNameYangon => 'Yangon';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoi/Jakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Beijing/Shanghai/Hong Kong/Taipei';

  @override
  String get timezoneNameTokyoSeoul => 'Tokyo/Seoul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Solomon Islands';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute =>
      'Matalinong piliin ang pinakamagandang ruta';

  @override
  String get networkTesting => 'Sinusubukan...';

  @override
  String get networkTestingShort => 'Sinusubukan';

  @override
  String networkLatencyMs(int ms) {
    return 'Latency ${ms}ms';
  }

  @override
  String get networkConnectionMode => 'Mode ng koneksiyon';

  @override
  String get networkDirectMode => 'Direktang mode';

  @override
  String get networkProxyMode => 'Proxy mode';

  @override
  String get networkDirectModeDesc => 'Direktang kumonekta sa server';

  @override
  String get networkProxyModeDesc => 'Kumonekta gamit ang proxy server';

  @override
  String get networkDirectRoutes => 'Mga direktang ruta';

  @override
  String get networkProxyRoutes => 'Mga proxy na ruta';

  @override
  String get networkTestAll => 'Subukan lahat';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Hong Kong node';

  @override
  String get networkSingaporeNode => 'Singapore node';

  @override
  String get networkJapanNode => 'Japan node';

  @override
  String get networkUnitedStatesNode => 'Estados Unidos node';

  @override
  String get networkHint =>
      'Mga tip:\n• Direktang mode: mas mabilis at angkop sa lokal na paggamit\n• Proxy mode: mas matatag para sa komunikasyon sa ibang bansa\n• I-tap ang refresh icon para subukan ang latency ng isang ruta';

  @override
  String get teenModeTitle => 'Mode para sa kabataan';

  @override
  String get teenModeStatusOn => 'Naka-on';

  @override
  String get teenModeStatusOff => 'Naka-off';

  @override
  String get teenModeStatusLoading => 'Naglo-load';

  @override
  String get teenModeUnavailable =>
      'Pansamantalang hindi available ang status ng mode para sa kabataan';

  @override
  String get teenModeInvalidResponse =>
      'Nagbalik ng hindi wastong tugon ang mode para sa kabataan';

  @override
  String get teenModeEnableDescription =>
      'Lilimitahan ng mga panuntunan ng platform ang oras ng paggamit at ilang feature.';

  @override
  String get teenModePasscode => 'Passcode';

  @override
  String get teenModeCurrentPasscode => 'Kasalukuyang passcode';

  @override
  String get teenModeNewPasscode => 'Bagong passcode';

  @override
  String get teenModePasscodeHint => 'Maglagay ng 4–6 na digit';

  @override
  String get teenModeEnable => 'I-on ang mode para sa kabataan';

  @override
  String get teenModeDisable => 'I-off ang mode para sa kabataan';

  @override
  String get teenModeChangePasscode => 'Baguhin ang passcode';

  @override
  String get teenModeSource => 'Pinagana ni';

  @override
  String get teenModeDailyUsage => 'Nagamit ngayon';

  @override
  String get teenModeRemaining => 'Natitirang oras';

  @override
  String get teenModeMinutesUnit => 'Minuto';

  @override
  String get teenModeUnlimited => 'Walang limitasyon';

  @override
  String get teenModeRequestExtension => 'Humiling ng dagdag na oras';

  @override
  String get teenModeExtensionSubmitted =>
      'Naipadala sa tagapag-alaga ang kahilingan sa oras';

  @override
  String get teenModeTimeLimitReached =>
      'Naabot na ang limitasyon sa paggamit ngayong araw';

  @override
  String get teenModeCurfewActive => 'Nasa oras ng limitadong paggamit ngayon';

  @override
  String get teenModeReliefHint =>
      'Maaari mo pa ring tingnan ang kasaysayan, makipag-ugnayan sa opisyal na suporta, at mag-ulat ng mga problema.';

  @override
  String get teenModeRestrictedNotice =>
      'Pinipigilan ngayon ng mode para sa kabataan ang pagpapadala ng mensahe';

  @override
  String get teenModeActionBlocked =>
      'Pinipigilan ngayon ng mode para sa kabataan ang pagkilos na ito';

  @override
  String get teenModeMyRequests => 'Mga kahilingan ko';

  @override
  String get guardianCenterTitle => 'Sentro ng tagapag-alaga';

  @override
  String get guardianRelationships => 'Mga ugnayan ng pag-aalaga';

  @override
  String get guardianMinors => 'Mga batang pinangangasiwaan ko';

  @override
  String get guardianApprovals => 'Mga naghihintay ng pag-apruba';

  @override
  String get guardianBind => 'Ilagay ang linking code';

  @override
  String get guardianCreateMinorCode => 'Bata ako — gumawa ng code';

  @override
  String get guardianCreateGuardianCode => 'Tagapag-alaga ako — gumawa ng code';

  @override
  String get guardianRelation => 'Ugnayan';

  @override
  String get guardianPrimary => 'Pangunahing tagapag-alaga';

  @override
  String get guardianCode => '6 na digit na linking code';

  @override
  String get guardianCodeHint => 'Ilagay ang code na ibinigay ng kausap';

  @override
  String get guardianCodeCreated =>
      'Nagawa ang code. Ibahagi ito bago mag-expire.';

  @override
  String get guardianEmpty => 'Walang ugnayan ng pag-aalaga';

  @override
  String get guardianNoMinors => 'Walang batang pinangangasiwaan';

  @override
  String get guardianUnbind => 'Alisin ang ugnayan';

  @override
  String get guardianExtend => 'Dagdagan ang oras ng bata';

  @override
  String get guardianPolicyTitle => 'Mga panuntunan sa paggamit';

  @override
  String get guardianPolicyLocked => 'Naka-lock ng platform';

  @override
  String get approvalEmpty => 'Walang kahilingan';

  @override
  String get approvalApprove => 'Sumasang-ayon';

  @override
  String get approvalReject => 'Tanggihan';

  @override
  String get approvalPending => 'Naghihintay';

  @override
  String get approvalApproved => 'Naaprubahan';

  @override
  String get approvalRejected => 'Rejected';

  @override
  String get approvalExpired => 'Expired';

  @override
  String get approvalCancelled => 'Kinansela';

  @override
  String get approvalReplayFailed =>
      'Hindi naisagawa ang orihinal na pagkilos. Subukan itong muli.';

  @override
  String get requestCancelled => 'Nakansela ang kahilingan';

  @override
  String get kycTitle => 'Pag-verify ng pagkakakilanlan';

  @override
  String get kycNotRequired =>
      'Hindi kailangan ang pag-verify ng pagkakakilanlan';

  @override
  String get kycVerified => 'Na-verify ang pagkakakilanlan';

  @override
  String get kycDeclared => 'Naipadala ang impormasyon ng pagkakakilanlan';

  @override
  String get kycPending => 'Sinusuri';

  @override
  String get kycRejected => 'Tinanggihan sa pagsusuri';

  @override
  String get kycNone => 'Walang naipadalang impormasyon ng pagkakakilanlan';

  @override
  String get kycRealName => 'Buong Pangalan';

  @override
  String get kycIdNumber => 'Numero ng ID';

  @override
  String get kycIdType => 'Uri ng dokumento';

  @override
  String get kycApplicability =>
      'Ilagay ang iyong tunay na detalye para sa napiling dokumento. Nasa listahan ang mga tinatanggap na uri.';

  @override
  String get kycCamera => 'Kumuha ng Larawan';

  @override
  String get kycGallery => 'Pumili mula sa Album';

  @override
  String get kycPhotoLimit => 'Pinakamalaki bawat larawan';

  @override
  String get kycSelectPhoto => 'Pumili ng Larawan';

  @override
  String get kycPhotoSelected => 'Napili';

  @override
  String get kycViewPhoto => 'I-tap para tingnan ang larawan';

  @override
  String get kycReplacePhoto => 'Pumili ng ibang larawan';

  @override
  String get kycDisclosure =>
      'Ginagamit namin ang pangalan, numero ng dokumento, at mga larawan ng dokumento mo para suriin ang iyong pagkakakilanlan. Kung wala ang mga ito, hindi ka makapagsusumite at maaaring hindi available ang ilang pinaghihigpitang feature.';

  @override
  String get kycConsent =>
      'Hiwalay akong pumapayag sa pagproseso ng impormasyong ito ng pagkakakilanlan';

  @override
  String get kycConsentRequired =>
      'Ibigay muna ang hiwalay na pahintulot bago magsumite';

  @override
  String get kycResubmitTitle =>
      'Ipadala muli ang impormasyon ng pagkakakilanlan';

  @override
  String get kycResubmitWarning =>
      'Papalitan ng muling pagsusumite ang iyong nakabinbing aplikasyon. Magpatuloy?';

  @override
  String get kycSubmitting => 'Isinusumite';

  @override
  String get kycSubmitFailed => 'Hindi naisumite. Subukang muli.';

  @override
  String get kycSubmitUnavailable =>
      'Hindi maaaring isumite ngayon ang impormasyon ng pagkakakilanlan';

  @override
  String get kycResubmitNotAllowed =>
      'Hindi available ang muling pagsusumite matapos tanggihan. Makipag-ugnayan sa suporta kung kailangan.';

  @override
  String get kycDailyLimit =>
      'Naabot mo na ang limitasyon sa pagsusumite ngayon. Subukan bukas.';

  @override
  String get kycTypeUnavailable =>
      'Walang available na uri ng dokumento. Subukan ulit mamaya.';

  @override
  String get kycNameInvalid =>
      'Dapat may 2–64 na character ang legal na pangalan';

  @override
  String get kycNumberRequired => 'Ilagay ang numero ng dokumento mo';

  @override
  String get kycFrontRequired => 'I-upload ang harap ng dokumento mo';

  @override
  String get kycBackRequired => 'I-upload ang likod ng dokumento mo';

  @override
  String get kycPhotoTooLarge =>
      'Lampas sa limitasyon ng laki ang larawan. I-compress ito at subukang muli.';

  @override
  String get kycAccountChanged =>
      'Nagbago ang account o espasyo. Buksan muli ang pahinang ito.';

  @override
  String get kycPhotoInvalid => 'Pumili ng wastong larawan';

  @override
  String get kycPortraitSide => 'Harap ng ID';

  @override
  String get kycEmblemSide => 'Likod ng ID';

  @override
  String get kycPassportDataPage => 'Pahina ng datos ng pasaporte';

  @override
  String get kycPassportOtherPage =>
      'Pahina ng visa o bakanteng pahina ng pasaporte';

  @override
  String get kycFront => 'Harap ng ID';

  @override
  String get kycBack => 'Likod ng ID';

  @override
  String get kycRequired =>
      'Kailangan ang pag-verify ng pagkakakilanlan bago gumawa ng grupo';

  @override
  String get kycGoVerify => 'I-verify ngayon';

  @override
  String get kycStatusUnknown =>
      'Hindi available ang status ng pagkakakilanlan. I-refresh mamaya.';

  @override
  String get kycSuperseded =>
      'Pinalitan ito ng mas bagong pagsusumite. Suriin ang pinakabagong status ng iyong pagkakakilanlan.';

  @override
  String get kycMediaNotFound =>
      'Hindi available ang larawan ng dokumento sa espasyong ito. Piliin itong muli bago magsumite.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Broadcast sa customer';

  @override
  String get officialAccountBadge => 'Opisyal';

  @override
  String get officialAccountOpenConversation => 'Buksan ang pag-uusap';

  @override
  String get officialAccountJoinHint =>
      'Kapag idinagdag mo ang account na ito, sasali ka sa negosyo bilang customer. Hindi kailangan ng pag-apruba sa friend request.';

  @override
  String get officialAccountJoinDisabled =>
      'Hindi tumatanggap ng bagong customer ang negosyong ito. Makipag-ugnayan sa suporta.';

  @override
  String get officialAccountRemoved =>
      'Inalis ka sa negosyong ito. Hilingin sa negosyo na imbitahan kang muli.';

  @override
  String get officialAccountBanned =>
      'Hindi pinagana ang iyong account sa negosyong ito.';

  @override
  String get officialAccountUnavailable =>
      'Hindi available ngayon ang opisyal na account na ito.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Hindi pinapayagang sumali sa negosyo sa kasalukuyang mode.';

  @override
  String get officialAccountPlatformRequired =>
      'Gumamit ng platform account para idagdag ang opisyal na account na ito.';

  @override
  String get officialAccountOpenFailed =>
      'Hindi mabuksan ang pag-uusap. Subukang muli.';

  @override
  String get officialAccountAccountChanged =>
      'Nagbago ang account o espasyo. Buksan itong muli.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Hindi pa napapanahon ang direktoryo ng negosyo. Subukan pagkaraan ng ilang sandali.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Hindi na-sync ang opisyal na account. Available pa rin ang lokal na nilalaman.';

  @override
  String get officialAccountInboxSyncing =>
      'Sini-sync ang mga mensahe ng opisyal na account';

  @override
  String get diagnosticsTitle => 'Diagnostics';

  @override
  String get diagnosticsExplanation =>
      'Inalisan ng sensitibong impormasyon ang mga log at naglalaman ang mga ito ng operasyon at mga error ng account at espasyong ito, kasama ang mga pampublikong kaganapan sa pagsisimula. Hindi kasama ang nilalaman ng chat at mga kredensiyal.';

  @override
  String get diagnosticsHour => 'Nakaraang oras';

  @override
  String get diagnosticsDay => 'Nakaraang 24 oras';

  @override
  String get diagnosticsWeek => '7 Araw';

  @override
  String diagnosticsEventCount(int count) {
    return 'Available na kaganapan: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Naka-save ang mga log sa device na ito at mananatiling available matapos mag-restart.';

  @override
  String get diagnosticsNotPersistent =>
      'May mga log na hindi pa na-save. I-refresh para subukang muli.';

  @override
  String get diagnosticsExport => 'I-export at ibahagi';

  @override
  String get diagnosticsRefresh => 'I-refresh';

  @override
  String get diagnosticsClear => 'Burahin ang mga log ng espasyong ito';

  @override
  String get diagnosticsClearConfirm =>
      'Burahin ang mga diagnostic log ng espasyong ito? Mananatili ang kasaysayan ng chat.';

  @override
  String get diagnosticsShared =>
      'Natapos ang pagbabahagi ng system. Tiyakin ang file sa tumanggap na app.';

  @override
  String get diagnosticsCancelled =>
      'Nakansela ang pagbabahagi. Maaari kang mag-export muli.';

  @override
  String get diagnosticsUnconfirmed =>
      'Hindi makumpirma ang pagbabahagi. Suriin ang tumanggap na app.';

  @override
  String get diagnosticsFailed => 'Hindi naisagawa. Subukang muli.';
}
