// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get navWorkbench => 'कार्यस्थल';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'खाते का डेटा लोड नहीं हो सका';

  @override
  String get startupFailureTitle => 'शुरू नहीं हो सका';

  @override
  String get startupFailureMessage => 'नेटवर्क जाँचें और दोबारा कोशिश करें';

  @override
  String get privacyConsentTitle => 'सेवा की शर्तें और गोपनीयता नीति';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return '$brand में आपका स्वागत है। खाते में साइन इन, त्वरित संदेश, व्यावसायिक सहयोग, ऑनलाइन ग्राहक सेवा, संदेश सूचनाएँ और सुरक्षा देने के लिए हमें सेवा की शर्तों और गोपनीयता नीति के अनुसार आवश्यक जानकारी संसाधित करनी होती है।\n\nआपके «सहमत हूँ» पर टैप करने से पहले हम क्लिपबोर्ड नहीं पढ़ते, JPush/JCore या डिवाइस निर्माताओं के पुश SDK शुरू नहीं करते और इनके माध्यम से Android ID, OAID, इंस्टॉल किए गए ऐप की सूची, MAC पते या ऐसी अन्य जानकारी नहीं लेते। यदि आप अभी मना करते हैं, तो हम आपका विकल्प सहेजेंगे; आप दस्तावेज़ पढ़ना जारी रख सकते हैं और बाद में फिर चुन सकते हैं।\n\nआपकी सहमति के बाद संदेश, ग्राहक सेवा और आने वाली कॉल की सूचनाएँ देने के लिए JPush/JCore और डिवाइस निर्माताओं की पुश सेवाएँ डिवाइस मॉडल, Android संस्करण, ऐप पैकेज और संस्करण, नेटवर्क प्रकार, IP पता, Android ID, OAID, पुश पंजीकरण ID, निर्माता का पुश टोकन तथा सूचना पहुँचने और क्लिक किए जाने का डेटा संसाधित कर सकती हैं। हमने स्मार्ट पुश, इंस्टॉल किए गए ऐप की सूची, MAC, IMEI, IMSI, Wi-Fi सूचियाँ, अपने-आप जगाना और संबद्ध स्टार्टअप जैसी अनावश्यक क्षमताएँ बंद कर दी हैं।\n\nक्लिपबोर्ड केवल तब पढ़ा जाता है जब आप स्वयं कॉपी या पेस्ट करते हैं। कैमरा, माइक्रोफ़ोन, सूचनाओं और अन्य सिस्टम अनुमतियों का अनुरोध केवल संबंधित सुविधा के आपके द्वारा उपयोग किए जाने पर किया जाता है। किसी अनुमति को मना करने से केवल वही सुविधा प्रभावित होती है। नीचे दिए पूरे दस्तावेज़ पढ़ें और तय करें कि आप सहमत हैं या नहीं।';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return '$brand में आपका स्वागत है। खाते में साइन इन, त्वरित संदेश, व्यावसायिक सहयोग, ऑनलाइन ग्राहक सेवा, संदेश सूचनाएँ और सुरक्षा देने के लिए हमें सेवा की शर्तों और गोपनीयता नीति के अनुसार आवश्यक जानकारी संसाधित करनी होती है।\n\nआपके «सहमत हूँ» पर टैप करने से पहले हम क्लिपबोर्ड नहीं पढ़ते, JPush/JCore शुरू नहीं करते, Apple Push Notification service (APNs) में पंजीकरण नहीं करते और JPush पंजीकरण ID या APNs डिवाइस टोकन जैसे पुश पहचानकर्ता नहीं लेते। यदि आप अभी मना करते हैं, तो हम आपका विकल्प सहेजेंगे; आप दस्तावेज़ पढ़ना जारी रख सकते हैं और बाद में फिर चुन सकते हैं।\n\nआपकी सहमति के बाद संदेश, ग्राहक सेवा और आने वाली कॉल की सूचनाएँ देने के लिए हम iPhone मॉडल, iOS संस्करण, ऐप पैकेज और संस्करण, नेटवर्क प्रकार, IP पता, IDFV, JPush पंजीकरण ID, APNs डिवाइस टोकन तथा सूचना पहुँचने और क्लिक किए जाने का डेटा संसाधित कर सकते हैं। JPush/JCore पुश सेवा से जुड़ता है; Apple APNs सिस्टम सूचनाएँ पहुँचाने के लिए ऐप पहचानकर्ता, डिवाइस टोकन और सूचना की सामग्री संसाधित करता है। वर्तमान iOS ऐप विज्ञापन सेवाओं का उपयोग नहीं करता और IDFA नहीं लेता।\n\nक्लिपबोर्ड केवल तब पढ़ा जाता है जब आप स्वयं कॉपी या पेस्ट करते हैं। कैमरा, माइक्रोफ़ोन, सूचनाओं और अन्य सिस्टम अनुमतियों का अनुरोध केवल संबंधित सुविधा के आपके द्वारा उपयोग किए जाने पर किया जाता है। किसी अनुमति को मना करने से केवल वही सुविधा प्रभावित होती है। नीचे दिए पूरे दस्तावेज़ पढ़ें और तय करें कि आप सहमत हैं या नहीं।';
  }

  @override
  String get privacyConsentTermsLink => 'उपयोगकर्ता समझौता';

  @override
  String get privacyConsentConjunction => 'और';

  @override
  String get privacyConsentPrivacyLink => 'गोपनीयता नीति';

  @override
  String get privacyConsentDecline => 'अस्वीकार करें';

  @override
  String get privacyConsentDeclinedExit =>
      'आप सेवा की शर्तों और गोपनीयता नीति से सहमत नहीं हुए। ऐप अब बंद हो जाएगा।';

  @override
  String get privacyConsentAccept => 'स्वीकार करें';

  @override
  String get privacyConsentRuntimeFailure =>
      'शुरू नहीं हो सका। नेटवर्क जाँचें और दोबारा कोशिश करें।';

  @override
  String get privacyConsentSaveFailure =>
      'आपका विकल्प सहेजा नहीं जा सका। फिर कोशिश करें।';

  @override
  String get appUpdateRequiredTitle => 'जारी रखने के लिए अपडेट ज़रूरी है';

  @override
  String get appUpdateOptionalTitle => 'नया वर्जन उपलब्ध है';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version उपलब्ध है';
  }

  @override
  String get appUpdateLater => 'बाद में';

  @override
  String get appUpdateNow => 'अभी अपडेट करें';

  @override
  String get appUpdateProcessing => 'प्रक्रिया चल रही है…';

  @override
  String get appUpdateInvalidUrl =>
      'अपडेट का पता अमान्य है। बाद में फिर कोशिश करें।';

  @override
  String get appUpdateOpenUrlFailed =>
      'अपडेट लिंक खोला नहीं जा सका। बाद में फिर कोशिश करें।';

  @override
  String get appUpdateDownloadInterrupted =>
      'डाउनलोड रुक गया। नेटवर्क जाँचें और फिर कोशिश करें।';

  @override
  String get appUpdatePackageVerificationFailed =>
      'पैकेज की जाँच विफल हुई। फिर डाउनलोड करें।';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'सिस्टम सेटिंग में $brand को अपडेट इंस्टॉल करने दें।';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'सिस्टम इंस्टॉलर खोला नहीं जा सका। इंस्टॉलेशन अनुमतियाँ जाँचें।';

  @override
  String get appUpdateGenericFailure =>
      'अपडेट विफल हुआ। नेटवर्क जाँचें और फिर कोशिश करें।';

  @override
  String get appUpdateUnavailable =>
      'नया संस्करण अभी डाउनलोड के लिए उपलब्ध नहीं है। बाद में कोशिश करें।';

  @override
  String get appUpdateCheckFailed =>
      'अपडेट की जाँच नहीं हो सकी। बाद में फिर कोशिश करें।';

  @override
  String get appUpdateChecking => 'जाँच जारी है';

  @override
  String get commonConfirm => 'ठीक है';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonSave => 'सहेजें';

  @override
  String get commonEdit => 'संपादन';

  @override
  String get commonDelete => 'हटाएँ';

  @override
  String get commonSearch => 'खोजें';

  @override
  String get commonLoading => 'लोड हो रहा है…';

  @override
  String get commonLoadFailed => 'लोड करने में विफल';

  @override
  String get commonRetry => 'पुनः प्रयास करें';

  @override
  String get commonEmpty => 'कोई डेटा नहीं';

  @override
  String get commonCopy => 'कॉपी करें';

  @override
  String get commonForward => 'आगे भेजें';

  @override
  String get commonFavorite => 'सहेजें';

  @override
  String get commonClose => 'बंद करें';

  @override
  String get commonSend => 'भेजें';

  @override
  String get commonDone => 'हो गया';

  @override
  String get commonMore => 'अधिक';

  @override
  String get commonSettings => 'सेटिंग्स';

  @override
  String get commonCopied => 'कॉपी किया गया';

  @override
  String get commonUnknown => 'अज्ञात';

  @override
  String get commonNotSet => 'सेट नहीं है';

  @override
  String get commonUnbound => 'लिंक नहीं किया गया';

  @override
  String get commonViewAll => 'सभी देखें';

  @override
  String get commonSubmit => 'जमा करें';

  @override
  String get commonAdd => 'जोड़ें';

  @override
  String get commonRemove => 'हटाएं';

  @override
  String get commonCreate => 'बनाएँ';

  @override
  String get commonUpdate => 'अपडेट करें';

  @override
  String get commonUpload => 'अपलोड करें';

  @override
  String get commonShare => 'साझा करें';

  @override
  String get commonBlock => 'ब्लॉक करें';

  @override
  String get commonUnblock => 'ब्लॉक हटाएँ';

  @override
  String get commonMute => 'म्यूट करें';

  @override
  String get commonUnmute => 'म्यूट हटाएँ';

  @override
  String get commonPin => 'पिन किया गया';

  @override
  String get commonUnpin => 'पिन हटाएँ';

  @override
  String get commonMarkRead => 'पढ़ा हुआ चिह्नित करें';

  @override
  String get commonMarkUnread => 'अपठित चिह्नित करें';

  @override
  String get commonOnline => 'ऑनलाइन';

  @override
  String get commonOffline => 'ऑफ़लाइन';

  @override
  String get commonOperationFailed => 'कार्रवाई विफल हुई। फिर कोशिश करें।';

  @override
  String get commonNetworkError => 'नेटवर्क त्रुटि। कनेक्शन जाँचें।';

  @override
  String get navMessages => 'संदेशों';

  @override
  String get navContacts => 'संपर्क';

  @override
  String get navMe => 'मैं';

  @override
  String get authLoginTitle => 'StartLink में साइन इन करें';

  @override
  String get authTabMobile => 'फ़ोन';

  @override
  String get authTabEmail => 'ईमेल';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'फ़ोन नंबर दर्ज करें';

  @override
  String get authHintEmail => 'अपना ईमेल पता दर्ज करें';

  @override
  String get authHintPassword => 'पासवर्ड दर्ज करें';

  @override
  String get authHintCode => 'सत्यापन कोड दर्ज करें';

  @override
  String get authHintLoginName => 'StartLink ID दर्ज करें (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'लॉग इन करें';

  @override
  String get authGetCode => 'कोड प्राप्त करें';

  @override
  String authResendCode(int seconds) {
    return '$seconds सेकंड में फिर भेजें';
  }

  @override
  String get authUsePassword => 'पासवर्ड इस्तेमाल करें';

  @override
  String get authUseCode => 'सत्यापन कोड इस्तेमाल करें';

  @override
  String get authAgreementPrefix => 'मैंने पढ़ लिया है और सहमत हूँ:';

  @override
  String get authAgreementAnd => 'और';

  @override
  String get authTermsLink => 'उपयोगकर्ता समझौता';

  @override
  String get authPrivacyLink => 'गोपनीयता नीति';

  @override
  String get authCaptchaTitle => 'सुरक्षा सत्यापन';

  @override
  String get authCaptchaHint => 'उत्तर दर्ज करें';

  @override
  String get authCaptchaFailed => 'कैप्चा नहीं मिल सका। फिर कोशिश करें।';

  @override
  String get authErrorEmptyCode => 'कृपया सत्यापन कोड दर्ज करें';

  @override
  String get authErrorEmptyPassword => 'पासवर्ड दर्ज करें';

  @override
  String get authErrorEmptyLoginName => 'कृपया StartLink ID दर्ज करें';

  @override
  String get authErrorWrongCredentials => 'खाता या पासवर्ड ग़लत है';

  @override
  String get authDeactivatingTitle => 'खाता हटाना';

  @override
  String get authDeactivatingContent =>
      'आपका खाता हटाने की प्रतीक्षा अवधि (7 दिन) में है।\n\nहटाना रद्द करने के लिए «हटाना रद्द करें» पर टैप करें; अन्यथा ऐप खोलने के लिए «जारी रखें» पर टैप करें।';

  @override
  String get authContinueUse => 'जारी रखें';

  @override
  String get authCancelDeactivation => 'हटाना रद्द करें';

  @override
  String get authDeactivationCancelled => 'हटाना रद्द हुआ, खाता बहाल हो गया';

  @override
  String get authDeactivationCancelFailed =>
      'रद्द नहीं हो सका। फिर कोशिश करें।';

  @override
  String get authLogout => 'लॉग आउट करें';

  @override
  String get authLogoutConfirm => 'क्या आप वाकई साइन आउट करना चाहते हैं?';

  @override
  String get authSendingCode => 'भेजा जा रहा है…';

  @override
  String get authCodeSent => 'सत्यापन कोड भेजा गया';

  @override
  String get authLoginFailed => 'साइन इन विफल हुआ। फिर कोशिश करें।';

  @override
  String get authRegisterFailed => 'पंजीकरण विफल हुआ। फिर कोशिश करें।';

  @override
  String get authEnterpriseCode => 'कंपनी कोड';

  @override
  String get authEnterpriseCodeHint => 'कंपनी कोड दर्ज करें';

  @override
  String get authPendingApproval =>
      'पंजीकरण सफल हुआ। कंपनी में शामिल होने का आपका अनुरोध भेज दिया गया है और अनुमोदन की प्रतीक्षा है।';

  @override
  String get authNoAccount => 'क्या आपके पास खाता नहीं है?';

  @override
  String get authRegisterNow => 'अभी पंजीकरण करें';

  @override
  String get authCountryPickerTitle => 'देश या क्षेत्र चुनें';

  @override
  String get authCountrySearchHint => 'देश या क्षेत्र खोजें';

  @override
  String get authCountryChinaMainland => 'मुख्यभूमि चीन';

  @override
  String get authCountryHongKong => 'हांगकांग, चीन';

  @override
  String get authCountryMacau => 'मकाओ, चीन';

  @override
  String get authCountryTaiwan => 'ताइवान, चीन';

  @override
  String get authCountryUnitedStates => 'संयुक्त राज्य अमेरिका';

  @override
  String get authCountryUnitedKingdom => 'यूनाइटेड किंगडम';

  @override
  String get authCountryJapan => 'जापान';

  @override
  String get authCountrySouthKorea => 'दक्षिण कोरिया';

  @override
  String get authCountrySingapore => 'सिंगापुर';

  @override
  String get authCountryMalaysia => 'मलेशिया';

  @override
  String get authCountryAustralia => 'ऑस्ट्रेलिया';

  @override
  String get authCountryCanada => 'कनाडा';

  @override
  String get authCountryGermany => 'जर्मनी';

  @override
  String get authCountryFrance => 'फ़्रांस';

  @override
  String get authCountryIndia => 'भारत';

  @override
  String get authCountryThailand => 'थाईलैंड';

  @override
  String get authCountryVietnam => 'वियतनाम';

  @override
  String get authCountryIndonesia => 'इंडोनेशिया';

  @override
  String get authCountryPhilippines => 'फ़िलीपींस';

  @override
  String get authQuickLoginTitle => 'त्वरित लॉगिन';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress =>
      'साइन इन हो रहा है। कृपया प्रतीक्षा करें।';

  @override
  String get authRoleOwner => 'स्वामी';

  @override
  String get authRoleAdministrator => 'व्यवस्थापक';

  @override
  String get authRoleCustomerService => 'ग्राहक सेवा';

  @override
  String get authRoleTechnicalSupport => 'तकनीकी सहायता';

  @override
  String get authRoleEmployee => 'कर्मचारी';

  @override
  String get authRoleMember => 'सदस्य';

  @override
  String get authRoleEnterpriseCustomer => 'कंपनी का ग्राहक';

  @override
  String get authUnavailablePrefix => 'अनुपलब्ध · ';

  @override
  String get authUnassignedService => 'कोई सेवा प्रतिनिधि नहीं सौंपा गया';

  @override
  String authAssignedService(String staff) {
    return '$staff को सौंपा गया';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'ग्राहक · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'कर्मचारी · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count उपयोगकर्ता';
  }

  @override
  String get authMetaPhone => 'फ़ोन';

  @override
  String get authMetaIdentity => 'पहचान';

  @override
  String get authRegisterTitle => 'पंजीकरण करें';

  @override
  String get authNickname => 'उपनाम';

  @override
  String get authNicknameHint => 'उपनाम सेट करें';

  @override
  String get authPassword => 'पासवर्ड';

  @override
  String get authPasswordSetHint => 'पासवर्ड सेट करें (कम से कम 6 वर्ण)';

  @override
  String get authConfirmPassword => 'पासवर्ड पुष्टि';

  @override
  String get authConfirmPasswordHint => 'पासवर्ड फिर दर्ज करें';

  @override
  String get authVerificationCode => 'सत्यापन कोड';

  @override
  String get authRegisterAndLogin => 'पंजीकरण करके साइन इन करें';

  @override
  String get authHaveAccount => 'क्या पहले से खाता है?';

  @override
  String get authGoLogin => 'लॉग इन करें';

  @override
  String get authEmailVerificationUnavailable =>
      'ईमेल सत्यापन उपलब्ध नहीं है। मोबाइल नंबर से पंजीकरण करें।';

  @override
  String get authSmsVerificationUnavailable =>
      'SMS सत्यापन उपलब्ध नहीं है। ईमेल से पंजीकरण करें।';

  @override
  String get authSendFailed => 'भेजा नहीं जा सका। फिर कोशिश करें।';

  @override
  String get authErrorEmptyNickname => 'उपनाम दर्ज करें';

  @override
  String get authErrorInvalidMobile => 'मान्य मोबाइल नंबर दर्ज करें';

  @override
  String get authErrorInvalidEmail => 'मान्य ईमेल पता दर्ज करें';

  @override
  String get authErrorPasswordTooShort =>
      'पासवर्ड में कम से कम 6 वर्ण होने चाहिए';

  @override
  String get authErrorPasswordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get authErrorVerificationRequired =>
      'पहले सत्यापन कोड लें और दर्ज करें';

  @override
  String get authRegisterErrorTitle => 'पंजीकरण विफल हुआ';

  @override
  String get authGotIt => 'समझ गया';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'कंपनी «$code» नहीं मिली। कंपनी कोड जाँचें।';
  }

  @override
  String get authTenantSearchFailed => 'खोज विफल हुई। फिर कोशिश करें।';

  @override
  String get authInvitationInvalid =>
      'आमंत्रण कोड अमान्य है। जाँचकर फिर कोशिश करें।';

  @override
  String get authCollapseJoin => 'शामिल होने की जानकारी छिपाएँ';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'मान्य आमंत्रण: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'कंपनी मिली: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'संगठन चुनें';

  @override
  String get authNoOrganization => 'कोई संगठन उपलब्ध नहीं है';

  @override
  String get authNoOrganizationHint =>
      'किसी व्यवस्थापक से संगठन में आमंत्रित करने को कहें';

  @override
  String get authPersonalSpace => 'निजी स्पेस';

  @override
  String get authPersonalSpaceSubtitle => 'दोस्तों से चैट और निजी पसंदीदा';

  @override
  String get authSpaceIdentityValidationFailed =>
      'स्पेस की पहचान सत्यापित नहीं हो सकी। फिर कोशिश करें।';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'निजी स्पेस बहाल नहीं हो सका। फिर कोशिश करें।';

  @override
  String get authJoinEnterpriseFailed =>
      'कंपनी में शामिल नहीं हो सके। बाद में फिर कोशिश करें।';

  @override
  String get homeTitle => 'संदेशों';

  @override
  String get homeGatewayConnectingTitle => 'कनेक्ट हो रहा है';

  @override
  String get homePersonalSpace => 'निजी';

  @override
  String get homeOfficialService => 'आधिकारिक सेवा';

  @override
  String get homeSwitchSpace => 'स्पेस बदलें';

  @override
  String get homeSpaceSubtitle => 'निजी · कंपनी';

  @override
  String get homeJoinEnterprise => 'कंपनी में शामिल हों';

  @override
  String get homeCreateGroup => 'नया समूह';

  @override
  String get homeAddFriend => 'संपर्क जोड़ें';

  @override
  String get homeScan => 'स्कैन करें';

  @override
  String get homeJoinNewSpace => 'नए स्पेस में शामिल हों';

  @override
  String get homeSearchConversation => 'खोजें';

  @override
  String get homeNoMessages => 'कोई संदेश नहीं';

  @override
  String get homeDeleteConversation => 'चैट हटाएँ';

  @override
  String get homeDeleteConversationConfirm =>
      'यह चैट हटाएँ? चैट इतिहास मिट जाएगा।';

  @override
  String get homePersonalNote => 'मैं (निजी नोट्स)';

  @override
  String get homeWorkNote => 'मैं (काम के नोट्स)';

  @override
  String homeConversationCount(int count) {
    return '$count चैट';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count अपठित';
  }

  @override
  String get chatInputHint => 'संदेश लिखें…';

  @override
  String get chatVoiceHint => 'बोलने के लिए दबाए रखें';

  @override
  String get chatVoiceRelease => 'भेजने के लिए छोड़ें';

  @override
  String get chatVoiceCancel => 'रद्द करने के लिए ऊपर खिसकाएँ';

  @override
  String get chatMenuCopy => 'कॉपी करें';

  @override
  String get chatMenuForward => 'आगे भेजें';

  @override
  String get chatMenuRecall => 'वापस लें';

  @override
  String get chatMenuDelete => 'हटाएँ';

  @override
  String get chatMenuFavorite => 'सहेजें';

  @override
  String get chatMenuReply => 'जवाब दें';

  @override
  String get chatMenuMultiSelect => 'चुनें';

  @override
  String get chatMenuTranslate => 'अनुवाद करें';

  @override
  String get chatMenuVoiceToText => 'टेक्स्ट में बदलें';

  @override
  String get chatMenuTextToSpeech => 'पढ़कर सुनाएँ';

  @override
  String get chatStatusRecalled => 'संदेश वापस लिया गया';

  @override
  String get chatRecallSuccess => 'वापस लिया गया';

  @override
  String get chatRecallFailed => 'वापस नहीं लिया जा सका';

  @override
  String get chatRecallTimeout =>
      '2 मिनट से पुराने संदेश वापस नहीं लिए जा सकते';

  @override
  String get chatTranslateFailed => 'अनुवाद विफल हुआ। फिर कोशिश करें।';

  @override
  String get chatTranslateNotConfigured => 'अनुवाद सेवा उपलब्ध नहीं है';

  @override
  String get chatVoiceToTextFailed => 'बदलना विफल हुआ। फिर कोशिश करें।';

  @override
  String get chatTextToSpeechFailed => 'पढ़कर सुनाना विफल हुआ। फिर कोशिश करें।';

  @override
  String get chatVoiceToText => 'बदलें';

  @override
  String get chatForwardSuccess => 'आगे भेज दिया गया';

  @override
  String get chatForwardFailed => 'आगे नहीं भेजा जा सका। फिर कोशिश करें।';

  @override
  String get chatNoConversations => 'आगे भेजने के लिए कोई चैट नहीं है';

  @override
  String get chatSendFailed => 'भेजना विफल हुआ';

  @override
  String get chatResend => 'कोड पुनः भेजें';

  @override
  String get chatNotFriend => 'संपर्क सूची में नहीं है';

  @override
  String get chatNotFriendHint =>
      'आप अभी संपर्क नहीं हैं। संदेश नहीं भेज सकते।';

  @override
  String get chatMutedHint => 'सभी सदस्य म्यूट हैं';

  @override
  String get chatFileUploadFailed => 'फ़ाइल अपलोड विफल हुआ। फिर कोशिश करें।';

  @override
  String get chatFileStatusNotDownloaded => 'डाउनलोड नहीं हुआ';

  @override
  String get chatFileStatusDownloaded => 'डाउनलोड हुआ';

  @override
  String get chatFileStatusUploading => 'अपलोड हो रहा है';

  @override
  String get chatFileStatusUploadFailed => 'अपलोड असफल';

  @override
  String get chatCardSendFailed => 'संपर्क कार्ड नहीं भेजा जा सका';

  @override
  String get chatFavoriteSuccess => 'सहेजा गया';

  @override
  String get chatFavoriteFailed => 'पसंदीदा में नहीं जोड़ा जा सका';

  @override
  String get chatLoadFailed => 'लोड करने में विफल';

  @override
  String get chatImageMessage => '[चित्र]';

  @override
  String get chatVoiceMessage => '[वॉइस संदेश]';

  @override
  String get chatVideoMessage => '[वीडियो]';

  @override
  String get chatFileMessage => '[फ़ाइल]';

  @override
  String get chatLocationMessage => '[स्थान]';

  @override
  String get chatContactCardMessage => '[संपर्क]';

  @override
  String get chatCallLogMessage => '[कॉल]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return '$count ने पढ़ा';
  }

  @override
  String get chatUnread => 'अपठित';

  @override
  String get chatRecalledSelf => 'आपने एक संदेश वापस लिया';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender ने एक संदेश वापस लिया';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'अनुवाद: $translation';
  }

  @override
  String get chatMessageDeleted => 'संदेश हटाया गया';

  @override
  String get chatPeer => 'दूसरी ओर';

  @override
  String get chatSelf => 'मैं';

  @override
  String get chatGenericMessage => '[संदेश]';

  @override
  String get chatVoiceHideText => 'टेक्स्ट छिपाएँ';

  @override
  String get chatVoiceShowText => 'टेक्स्ट में बदलें';

  @override
  String get chatFileDefaultName => 'फ़ाइल';

  @override
  String get chatContactDefaultName => 'संपर्क';

  @override
  String get chatContactCardTitle => 'संपर्क कार्ड';

  @override
  String get chatCallMissed => 'छूटी हुई';

  @override
  String get chatCallCancelled => 'रद्द हुई';

  @override
  String get chatCallRejected => 'अस्वीकृत';

  @override
  String get chatCallDisconnected => 'कनेक्शन टूटा';

  @override
  String get chatCallEnded => 'कॉल समाप्त';

  @override
  String get chatCallFailed => 'कॉल विफल हुई';

  @override
  String chatCallDuration(String duration) {
    return 'अवधि $duration';
  }

  @override
  String get chatVideoCallTitle => 'वीडियो कॉल';

  @override
  String get chatVoiceCallTitle => 'वॉइस कॉल';

  @override
  String get chatToolPhotos => 'फ़ोटो';

  @override
  String get chatToolCamera => 'कैमरा';

  @override
  String get chatToolFile => 'फ़ाइल';

  @override
  String get chatToolLocation => 'स्थान';

  @override
  String get chatToolContactCard => 'संपर्क';

  @override
  String get chatToolVoiceCall => 'वॉइस कॉल';

  @override
  String get chatToolVideoCall => 'वीडियो कॉल';

  @override
  String get chatToolFavorites => 'पसंदीदा';

  @override
  String get chatToolTranslate => 'अनुवाद करें';

  @override
  String get chatTranslationChooseLanguage => 'अनुवाद की भाषा चुनें';

  @override
  String get chatTranslationEnterText => 'पहले टेक्स्ट दर्ज करें';

  @override
  String get chatTranslationMentionsUnsupported =>
      'मेंशन वाले संदेशों का अनुवाद उपलब्ध नहीं है';

  @override
  String get chatTranslationScheduledUnsupported =>
      'निर्धारित संदेश संपादित करते समय अनुवाद उपलब्ध नहीं है';

  @override
  String get chatTranslationFailed => 'अनुवाद विफल हुआ। फिर कोशिश करें।';

  @override
  String get chatTranslationEmpty => 'कोई अनुवाद नहीं मिला। फिर कोशिश करें।';

  @override
  String get chatTranslationTranslating => 'अनुवाद हो रहा है…';

  @override
  String get chatTranslationSend => 'अनुवाद भेजें';

  @override
  String get chatTranslationSending => 'भेजा जा रहा है…';

  @override
  String get chatTranslationExpand => 'और दिखाएँ';

  @override
  String get chatTranslationCollapse => 'कम दिखाएँ';

  @override
  String get chatFileTooLarge => 'फ़ाइल 100 MB की सीमा से बड़ी है';

  @override
  String get chatInputMutedAdminOnly =>
      'केवल स्वामी या चुने हुए सदस्य लिख सकते हैं।';

  @override
  String get chatImageUploadUnsupported =>
      'चित्र अपलोड विफल हुआ। सर्वर पर यह सुविधा अभी उपलब्ध नहीं है।';

  @override
  String get chatFavoriteLongPressHint =>
      'संदेश पसंदीदा में जोड़ने के लिए उसे दबाए रखें';

  @override
  String chatSelectedCount(int count) {
    return '$count चुने गए';
  }

  @override
  String get chatLocationSheetTitle => 'स्थान भेजें';

  @override
  String get chatLocationNameLabel => 'स्थान का नाम';

  @override
  String get chatLocationNameHint => 'जैसे कार्यालय, ग्राहक का पता';

  @override
  String get chatLocationAddressLabel => 'पता';

  @override
  String get chatLocationOptionalHint => 'वैकल्पिक';

  @override
  String get chatLocationLatitudeLabel => 'अक्षांश';

  @override
  String get chatLocationLatitudeHint => '-90 से 90';

  @override
  String get chatLocationLongitudeLabel => 'देशांतर';

  @override
  String get chatLocationLongitudeHint => '-180 से 180';

  @override
  String chatLocationValidationRequired(String label) {
    return '$label दर्ज करें';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label सीमा से बाहर है';
  }

  @override
  String get chatLocationDefaultTitle => 'स्थान';

  @override
  String get chatMutedFullNotice =>
      'यह समूह म्यूट है। केवल स्वामी या चुने हुए सदस्य लिख सकते हैं।';

  @override
  String get chatNotFriendSendBlocked =>
      'आप अब दोस्त नहीं हैं और संदेश नहीं भेज सकते';

  @override
  String get chatPersonalNotesTitle => 'निजी नोट्स';

  @override
  String get chatWorkNotesTitle => 'काम के नोट्स';

  @override
  String get chatPersonalNotesDescription =>
      'अपने विचार और ज़रूरी जानकारी यहाँ सहेजें\nसभी डिवाइस पर सिंक होकर कभी भी उपलब्ध';

  @override
  String get chatWorkNotesDescription =>
      'काम के कार्य और सामग्री यहाँ सहेजें\nटीम स्पेस अलग और सुरक्षित रहते हैं';

  @override
  String get chatNoMessages => 'कोई संदेश नहीं';

  @override
  String chatReplyTo(String sender) {
    return '$sender को जवाब दें';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature जल्द उपलब्ध होगा';
  }

  @override
  String get chatForwardSelectTitle => 'चैट चुनें';

  @override
  String get chatContactSelectTitle => 'संपर्क चुनें';

  @override
  String get chatNoContacts => 'कोई संपर्क नहीं है';

  @override
  String get contactsTitle => 'संपर्क';

  @override
  String get contactsSearch => 'संपर्क खोजें';

  @override
  String get contactsNewFriends => 'नए दोस्त';

  @override
  String get contactsGroups => 'समूह';

  @override
  String get contactsFavorites => 'पसंदीदा';

  @override
  String get contactsRecent => 'हाल के';

  @override
  String get contactsOrganization => 'संगठन';

  @override
  String get contactsAnnouncement => 'घोषणाएँ';

  @override
  String get contactsNewApplications => 'नए आवेदन';

  @override
  String get contactsCustomerGroups => 'ग्राहक समूह';

  @override
  String get contactsAllCustomers => 'सभी ग्राहक';

  @override
  String get contactsMyCustomers => 'मेरे ग्राहक';

  @override
  String get contactsViewAll => 'सभी देखें';

  @override
  String get contactsMyContacts => 'मेरे संपर्क';

  @override
  String get contactsMyAdvisor => 'मेरा सलाहकार';

  @override
  String get contactsNoAdvisor => 'अभी कोई सलाहकार नहीं सौंपा गया';

  @override
  String get contactsAdvisorLoading => 'लोड हो रहा है…';

  @override
  String get contactsNavigateFailed => 'नेविगेशन विफल हुआ। फिर कोशिश करें।';

  @override
  String get contactsEmpty => 'कोई संपर्क नहीं है';

  @override
  String get contactsNoAnnouncement => 'कोई घोषणा नहीं है';

  @override
  String get contactsOfficialBadge => 'आधिकारिक';

  @override
  String get contactsCustomerBadge => 'ग्राहक';

  @override
  String get contactsEmptyCustomers => 'कोई ग्राहक नहीं है';

  @override
  String get myTitle => 'मैं';

  @override
  String get myEnterpriseInfo => 'कंपनी की जानकारी';

  @override
  String get myEnterpriseManage => 'कंपनी प्रबंधन';

  @override
  String get myQrCode => 'QR कोड';

  @override
  String get myFavorites => 'पसंदीदा';

  @override
  String get myLanguage => 'भाषा';

  @override
  String get myTimezone => 'समय क्षेत्र';

  @override
  String get myAutoTranslate => 'अपने-आप अनुवाद';

  @override
  String get myNetworkSwitch => 'लाइन बदलें';

  @override
  String get mySettings => 'सेटिंग्स';

  @override
  String get myLogout => 'लॉग आउट करें';

  @override
  String get myLogoutConfirm => 'क्या आप वाकई साइन आउट करना चाहते हैं?';

  @override
  String get myLeaveEnterprise => 'कंपनी छोड़ें';

  @override
  String get myLeaveEnterpriseConfirm =>
      'क्या आप वाकई यह कंपनी छोड़ना चाहते हैं? कंपनी के डेटा तक आपकी पहुँच समाप्त हो जाएगी।';

  @override
  String get myLeaveEnterpriseSuccess => 'कंपनी छोड़ दी';

  @override
  String get myLeaveEnterpriseFailed => 'छोड़ना विफल हुआ। फिर कोशिश करें।';

  @override
  String get myLppIdCopied => 'StartLink ID कॉपी हो गई';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count संपर्क';
  }

  @override
  String get myAutoSelect => 'अपने-आप';

  @override
  String get myPresenceStatus => 'उपस्थिति स्थिति';

  @override
  String get myPresenceStatusTitle => 'उपस्थिति सेट करें';

  @override
  String get myPresenceOnline => 'ऑनलाइन';

  @override
  String get myPresenceBusy => 'व्यस्त';

  @override
  String get myPresenceAway => 'दूर';

  @override
  String get myPresenceInvisible => 'अदृश्य';

  @override
  String get profileTitle => 'मेरी प्रोफ़ाइल';

  @override
  String get profileName => 'नाम';

  @override
  String get profileGender => 'लिंग';

  @override
  String get profileBirthday => 'जन्मदिन';

  @override
  String get profileRegion => 'क्षेत्र';

  @override
  String get profileSignature => 'परिचय';

  @override
  String get profileSignatureHint => 'अपने बारे में कुछ बताएँ';

  @override
  String get profileTapTapText => 'हल्की थपकी';

  @override
  String get profileTapTapHint =>
      'थपकी मिलने पर दिखने वाला टेक्स्ट (अधिकतम 20 वर्ण)';

  @override
  String get profileAccountSection => 'खाता';

  @override
  String get profileBasicSection => 'सामान्य जानकारी';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'सेट नहीं है';

  @override
  String get profileMobile => 'फ़ोन';

  @override
  String get profileMobileUnbound => 'लिंक नहीं किया गया';

  @override
  String get profileEmail => 'ईमेल';

  @override
  String get profileEmailUnbound => 'लिंक नहीं किया गया';

  @override
  String get profileQrCode => 'मेरा QR कोड';

  @override
  String get profileChangePassword => 'पासवर्ड बदलें';

  @override
  String get profileGenderMale => 'पुरुष';

  @override
  String get profileGenderFemale => 'महिला';

  @override
  String get profileGenderOther => 'अन्य';

  @override
  String get profileGenderUnset => 'सेट नहीं है';

  @override
  String get profileSaveFailed => 'सहेजना विफल हुआ। फिर कोशिश करें।';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'StartLink ID केवल एक बार बदली जा सकती है। सावधानी से चुनें।';

  @override
  String get profileLppIdChangeFailed =>
      'बदलना विफल हुआ (StartLink ID केवल एक बार बदल सकती है)';

  @override
  String get profileChangePasswordOld => 'वर्तमान पासवर्ड';

  @override
  String get profileChangePasswordNew => 'नया पासवर्ड';

  @override
  String get profileChangePasswordConfirm => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get profileChangePasswordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get profileChangePasswordSuccess =>
      'पासवर्ड बदल गया। फिर साइन इन करें।';

  @override
  String get profileChangePasswordFailed =>
      'पासवर्ड बदलना विफल हुआ। फिर कोशिश करें।';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsSectionEnterprise => 'कंपनी';

  @override
  String get settingsSectionAccount => 'खाता';

  @override
  String get settingsSectionGeneral => 'सामान्य';

  @override
  String get settingsSectionFeatures => 'सुविधाएँ';

  @override
  String get settingsSectionAbout => 'हमारे बारे में';

  @override
  String get settingsEnterpriseInfo => 'कंपनी की जानकारी';

  @override
  String get settingsProfile => 'मेरी प्रोफ़ाइल';

  @override
  String get settingsAccountSecurity => 'खाते की सुरक्षा';

  @override
  String get settingsNotification => 'सूचनाएँ';

  @override
  String get settingsDisplay => 'डिस्प्ले';

  @override
  String get settingsFriendPrivacy => 'गोपनीयता';

  @override
  String get settingsChat => 'चैट';

  @override
  String get settingsChatHistory => 'चैट इतिहास';

  @override
  String get settingsAbout => 'StartLink के बारे में';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsTimezone => 'समय क्षेत्र';

  @override
  String get settingsAutoTranslate => 'अपने-आप अनुवाद';

  @override
  String get settingsNetworkSwitch => 'लाइन बदलें';

  @override
  String get enterpriseInfoTitle => 'कंपनी की जानकारी';

  @override
  String get enterpriseName => 'नाम';

  @override
  String get enterpriseDescription => 'विवरण';

  @override
  String get enterpriseUpdateSuccess => 'सफलतापूर्वक अपडेट किया गया';

  @override
  String get enterpriseUpdateFailed => 'अपडेट विफल हुआ। फिर कोशिश करें।';

  @override
  String get enterpriseLeave => 'कंपनी छोड़ें';

  @override
  String get enterpriseLeaveConfirm =>
      'क्या आप वाकई यह कंपनी छोड़ना चाहते हैं?';

  @override
  String get enterpriseLeaveSuccess => 'कंपनी छोड़ दी';

  @override
  String get enterpriseLeaveFailed => 'छोड़ना विफल हुआ। फिर कोशिश करें।';

  @override
  String get enterpriseLeaveOwnerError =>
      'स्वामी सीधे नहीं छोड़ सकता। पहले स्वामित्व सौंपें।';

  @override
  String get enterpriseMemberCount => 'सदस्य';

  @override
  String get enterpriseCreatedAt => 'बनाया गया';

  @override
  String get enterpriseCode => 'कंपनी कोड';

  @override
  String get enterpriseInviteMembers => 'सदस्य आमंत्रित करें';

  @override
  String get enterpriseCopyInviteCode => 'आमंत्रण कोड कॉपी करें';

  @override
  String get enterpriseInviteCodeCopied => 'आमंत्रण कोड कॉपी हो गया';

  @override
  String get groupCreateTitle => 'नया समूह';

  @override
  String get groupNameHint => 'समूह का नाम दर्ज करें';

  @override
  String get groupCreateSuccess => 'समूह बन गया';

  @override
  String get groupCreateFailed => 'समूह नहीं बन सका';

  @override
  String get groupSettings => 'समूह सेटिंग';

  @override
  String get groupName => 'समूह का नाम';

  @override
  String get groupAvatar => 'समूह चित्र';

  @override
  String get groupAnnouncement => 'घोषणा';

  @override
  String get groupMembers => 'सदस्य';

  @override
  String get groupAddMember => 'सदस्य जोड़ें';

  @override
  String get groupRemoveMember => 'सदस्य हटाएँ';

  @override
  String get groupRemoveMemberConfirm => 'इस सदस्य को हटाएँ?';

  @override
  String get groupSetAdmin => 'व्यवस्थापक बनाएँ';

  @override
  String get groupRemoveAdmin => 'व्यवस्थापक हटाएँ';

  @override
  String get groupTransferOwner => 'स्वामित्व सौंपें';

  @override
  String get groupTransferOwnerConfirm =>
      'इस सदस्य को समूह का स्वामित्व सौंपें?';

  @override
  String get groupTransferOwnerSuccess => 'स्वामित्व सौंप दिया गया';

  @override
  String get groupTransferOwnerFailed => 'सौंपना विफल हुआ। फिर कोशिश करें।';

  @override
  String get groupLeave => 'समूह छोड़ें';

  @override
  String get groupLeaveConfirm => 'यह समूह छोड़ें?';

  @override
  String get groupLeaveSuccess => 'समूह छोड़ दिया';

  @override
  String get groupLeaveFailed => 'छोड़ना विफल हुआ। फिर कोशिश करें।';

  @override
  String get groupDissolve => 'समूह भंग करें';

  @override
  String get groupDissolveConfirm => 'यह समूह भंग करें? सभी सदस्य हट जाएँगे।';

  @override
  String get groupDissolveSuccess => 'समूह भंग हो गया';

  @override
  String get groupDissolveFailed => 'भंग करना विफल हुआ। फिर कोशिश करें।';

  @override
  String get groupQrCode => 'समूह का QR कोड';

  @override
  String get groupMuteAll => 'सभी को म्यूट करें';

  @override
  String get groupMuteAllOn => 'सभी को म्यूट करना चालू करें';

  @override
  String get groupMuteAllOff => 'सभी को म्यूट करना बंद करें';

  @override
  String get groupAllowMemberInvite => 'सदस्यों को आमंत्रण देने दें';

  @override
  String get groupAllowMemberModifyTitle => 'सदस्यों को समूह का नाम बदलने दें';

  @override
  String get groupAllowMemberAtAll => 'सदस्यों को @सभी मेंशन करने दें';

  @override
  String get groupAllowMemberViewMemberList =>
      'सदस्यों को सदस्य सूची देखने दें';

  @override
  String get groupAllowQrCodeJoin => 'QR कोड से शामिल होने दें';

  @override
  String get groupRequireApproval => 'शामिल होने के लिए अनुमोदन ज़रूरी';

  @override
  String get groupAllowMemberAddFriend => 'सदस्यों को एक-दूसरे को जोड़ने दें';

  @override
  String get groupRoleOwner => 'स्वामी';

  @override
  String get groupRoleAdmin => 'व्यवस्थापक';

  @override
  String get groupRoleMember => 'सदस्य';

  @override
  String get groupNoMembers => 'कोई सदस्य नहीं है';

  @override
  String get groupNoAnnouncements => 'कोई घोषणा नहीं है';

  @override
  String get groupCreateAnnouncement => 'घोषणा प्रकाशित करें';

  @override
  String get groupEditAnnouncement => 'घोषणा संपादित करें';

  @override
  String get groupDeleteAnnouncement => 'घोषणा हटाएँ';

  @override
  String get groupDeleteAnnouncementConfirm => 'यह घोषणा हटाएँ?';

  @override
  String get groupAnnouncementTitle => 'शीर्षक';

  @override
  String get groupAnnouncementContent => 'सामग्री';

  @override
  String get groupAnnouncementPin => 'घोषणा पिन करें';

  @override
  String groupMemberCount(int count) {
    return '$count सदस्य';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count चुने गए';
  }

  @override
  String get groupJoinRequestApprove => 'स्वीकार करें';

  @override
  String get groupJoinRequestReject => 'अस्वीकार करें';

  @override
  String get groupJoinRequests => 'शामिल होने के अनुरोध';

  @override
  String get groupNoJoinRequests => 'शामिल होने का कोई अनुरोध नहीं है';

  @override
  String get groupReadReceipts => 'पढ़ने की पुष्टि';

  @override
  String groupReadCount(int count) {
    return '$count ने पढ़ा';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count अपठित';
  }

  @override
  String get friendAddTitle => 'संपर्क जोड़ें';

  @override
  String get friendSearchHint => 'फ़ोन / ईमेल / StartLink ID';

  @override
  String get friendRequestSent => 'दोस्ती का अनुरोध भेज दिया गया';

  @override
  String get friendRequestFailed => 'भेजना विफल हुआ। फिर कोशिश करें।';

  @override
  String get friendAlreadyFriend => 'पहले से संपर्क हैं';

  @override
  String get friendNewFriendsTitle => 'नए दोस्त';

  @override
  String get friendNoRequests => 'दोस्ती का कोई अनुरोध नहीं है';

  @override
  String get friendAccept => 'स्वीकार करें';

  @override
  String get friendReject => 'अस्वीकार करें';

  @override
  String get friendAccepted => 'स्वीकार किया गया';

  @override
  String get friendRejected => 'अस्वीकृत';

  @override
  String get friendDeleteConfirm => 'यह संपर्क हटाएँ?';

  @override
  String get friendDeleteSuccess => 'संपर्क हटा दिया गया';

  @override
  String get friendDeleteFailed => 'हटाना विफल हुआ। फिर कोशिश करें।';

  @override
  String get friendRemarkName => 'संपर्क का उपनाम';

  @override
  String get friendGroupName => 'समूह';

  @override
  String get friendSendMessage => 'संदेश';

  @override
  String get friendMatchTypeLppId => 'StartLink ID से मिला';

  @override
  String get friendMatchTypeMobile => 'फ़ोन से मिला';

  @override
  String get friendMatchTypeEmail => 'ईमेल से मिला';

  @override
  String get friendSearchEmpty => 'कोई उपयोगकर्ता नहीं मिला';

  @override
  String get friendAddMessage => 'मैं आपको अपने संपर्कों में जोड़ना चाहता हूँ';

  @override
  String get friendBlockConfirm => 'इस उपयोगकर्ता को ब्लॉक करें?';

  @override
  String get friendUnblockConfirm => 'इस उपयोगकर्ता का ब्लॉक हटाएँ?';

  @override
  String get friendBlockSuccess => 'ब्लॉक किया गया';

  @override
  String get friendUnblockSuccess => 'ब्लॉक हटा दिया गया';

  @override
  String get profilePageTitle => 'व्यक्तिगत जानकारी';

  @override
  String get profilePageSendMessage => 'संदेश';

  @override
  String get profilePageAddFriend => 'दोस्त जोड़ें';

  @override
  String get profilePageAlreadyFriend => 'पहले से दोस्त हैं';

  @override
  String get profilePageBlocked => 'ब्लॉक किया गया';

  @override
  String get profilePageBlock => 'ब्लॉक करें';

  @override
  String get profilePageUnblock => 'ब्लॉक हटाएँ';

  @override
  String get profilePageHidden => 'इस उपयोगकर्ता ने अपनी प्रोफ़ाइल छिपाई है';

  @override
  String get profilePageFriendsOnly =>
      'यह उपयोगकर्ता केवल दोस्तों को प्रोफ़ाइल दिखाता है';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'टिप्पणियाँ';

  @override
  String get profilePageEditRemark => 'संपर्क का उपनाम संपादित करें';

  @override
  String get profilePageSaveRemarkSuccess => 'उपनाम सहेजा गया';

  @override
  String get profilePageSaveRemarkFailed => 'सहेजना विफल हुआ। फिर कोशिश करें।';

  @override
  String get searchTitle => 'खोजें';

  @override
  String get searchHint => 'फ़ोन, ईमेल या StartLink ID से खोजें';

  @override
  String get searchNoResults => 'कोई परिणाम नहीं मिला';

  @override
  String get searchMessages => 'संदेशों';

  @override
  String get searchUsers => 'उपयोगकर्ता';

  @override
  String get searchFailed => 'खोज विफल हुई। फिर कोशिश करें।';

  @override
  String get scanTitle => 'स्कैन करें';

  @override
  String get scanFailed => 'पहचान विफल हुई। फिर कोशिश करें।';

  @override
  String get scanInvalidQrCode => 'अमान्य QR कोड';

  @override
  String get scanFlashOn => 'फ़्लैशलाइट चालू करें';

  @override
  String get scanFlashOff => 'फ़्लैशलाइट बंद करें';

  @override
  String get scanAlbum => 'एल्बम से चुनें';

  @override
  String get favoritesTitle => 'पसंदीदा';

  @override
  String get favoritesEmpty => 'अभी तक कुछ भी सहेजा नहीं गया है';

  @override
  String get favoritesAll => 'सभी';

  @override
  String get favoritesText => 'पाठ';

  @override
  String get favoritesImage => 'चित्र';

  @override
  String get favoritesVideo => 'वीडियो';

  @override
  String get favoritesVoice => 'वॉइस संदेश';

  @override
  String get favoritesFile => 'फ़ाइलें';

  @override
  String get favoritesOther => 'अन्य';

  @override
  String get favoritesDeleteConfirm => 'पसंदीदा से हटाएँ?';

  @override
  String get favoritesDeleteSuccess => 'सहेजे गए से हटा दिया गया';

  @override
  String get favoritesDeleteFailed => 'हटाना विफल हुआ';

  @override
  String get favoritesOriginalRecalled => 'संदेश वापस लिया गया';

  @override
  String get favoritesViewOriginal => 'मूल देखें';

  @override
  String get favoritesSearchHint => 'पसंदीदा खोजें';

  @override
  String get favoritesNoResults => 'कोई मेल खाता पसंदीदा नहीं है';

  @override
  String get noticeTitle => 'घोषणाएँ';

  @override
  String get noticeEmpty => 'कोई घोषणा नहीं है';

  @override
  String get noticeDetail => 'घोषणा का विवरण';

  @override
  String get noticePublishedAt => 'प्रकाशित';

  @override
  String get noticePriorityNormal => 'सामान्य';

  @override
  String get noticePriorityImportant => 'महत्वपूर्ण';

  @override
  String get noticePriorityUrgent => 'अत्यावश्यक';

  @override
  String get organizationTitle => 'संगठन';

  @override
  String get organizationEmpty => 'विभाग की कोई जानकारी नहीं है';

  @override
  String get organizationMembers => 'सदस्य';

  @override
  String get organizationDepartment => 'विभाग';

  @override
  String get organizationPosition => 'पद';

  @override
  String get organizationLeader => 'प्रमुख';

  @override
  String get qrCodeTitle => 'मेरा QR कोड';

  @override
  String get qrCodeSave => 'एल्बम में सहेजें';

  @override
  String get qrCodeShare => 'साझा करें';

  @override
  String get qrCodeSaveSuccess => 'एल्बम में सहेजा गया';

  @override
  String get qrCodeSaveFailed => 'सहेजना विफल हुआ। फिर कोशिश करें।';

  @override
  String get qrCodeRefresh => 'QR कोड रीफ़्रेश करें';

  @override
  String get qrCodeExpired => 'QR कोड की अवधि समाप्त है। रीफ़्रेश करें।';

  @override
  String get qrCodeScanToAdd => 'मुझे संपर्क में जोड़ने के लिए स्कैन करें';

  @override
  String get spacePersonal => 'निजी';

  @override
  String get spaceEnterprise => 'कंपनी';

  @override
  String get spaceJoinByCode => 'कंपनी कोड से शामिल हों';

  @override
  String get spaceJoinByInvite => 'आमंत्रण कोड से शामिल हों';

  @override
  String get spaceEnterCode => 'कंपनी कोड दर्ज करें';

  @override
  String get spaceEnterInviteCode => 'आमंत्रण कोड दर्ज करें';

  @override
  String get spaceSearchEnterprise => 'कंपनी खोजें';

  @override
  String get spaceJoinRequestSent =>
      'अनुरोध भेज दिया गया, अनुमोदन की प्रतीक्षा है';

  @override
  String get spaceJoinRequestPending => 'अनुमोदन की प्रतीक्षा है';

  @override
  String get spaceJoinRequestApproved => 'अनुरोध अनुमोदित हुआ';

  @override
  String get spaceJoinRequestRejected => 'अनुरोध अस्वीकृत हुआ';

  @override
  String get spaceAlreadyMember => 'आप पहले से सदस्य हैं';

  @override
  String get spaceAutoApproved => 'अपने-आप अनुमोदित। स्वागत है!';

  @override
  String get spacePendingApprovalHint =>
      'पंजीकरण सफल हुआ। शामिल होने का अनुरोध भेज दिया गया है।';

  @override
  String get spaceNoSpaces => 'कोई स्पेस नहीं है';

  @override
  String get spaceInviteExpired => 'आमंत्रण कोड की अवधि समाप्त है';

  @override
  String get spaceInviteTargetMismatch =>
      'यह आमंत्रण कोड आपके खाते के लिए नहीं है';

  @override
  String get spaceAcceptInviteSuccess => 'कंपनी में सफलतापूर्वक शामिल हुए';

  @override
  String get spaceAcceptInviteFailed => 'शामिल होना विफल हुआ। फिर कोशिश करें।';

  @override
  String get spaceTenantSelectTitle => 'स्पेस चुनें';

  @override
  String get spaceTenantSelectHint => 'खोलने के लिए स्पेस चुनें';

  @override
  String get spaceEnterPersonal => 'निजी स्पेस खोलें';

  @override
  String get spaceEnterEnterprise => 'कंपनी स्पेस खोलें';

  @override
  String get aboutTitle => 'StartLink के बारे में';

  @override
  String get aboutVersion => 'संस्करण';

  @override
  String get aboutTerms => 'सेवा की शर्तें';

  @override
  String get aboutPrivacy => 'गोपनीयता नीति';

  @override
  String get aboutOpenSource => 'ओपन सोर्स लाइसेंस';

  @override
  String get aboutCheckUpdate => 'अपडेट जाँचें';

  @override
  String get aboutLatestVersion => 'आप नवीनतम संस्करण पर हैं';

  @override
  String get aboutUpdateAvailable => 'नया वर्जन उपलब्ध है';

  @override
  String get aboutUpdateNow => 'अभी अपडेट करें';

  @override
  String get aboutUpdateLater => 'बाद में';

  @override
  String get notificationTitle => 'सूचनाएँ';

  @override
  String get notificationGlobalMute => 'परेशान न करें';

  @override
  String get notificationSound => 'ध्वनि';

  @override
  String get notificationVibration => 'कंपन';

  @override
  String get notificationPreview => 'संदेश का पूर्वावलोकन';

  @override
  String get notificationDndStart => 'परेशान न करें की शुरुआत';

  @override
  String get notificationDndEnd => 'परेशान न करें की समाप्ति';

  @override
  String get blacklistTitle => 'काली सूची में शामिल';

  @override
  String get blacklistEmpty => 'कोई ब्लॉक किया उपयोगकर्ता नहीं है';

  @override
  String get blacklistRemove => 'ब्लॉक हटाएँ';

  @override
  String get blacklistRemoveConfirm => 'इस उपयोगकर्ता का ब्लॉक हटाएँ?';

  @override
  String get feedbackTitle => 'फ़ीडबैक';

  @override
  String get feedbackTypeComplaint => 'शिकायत';

  @override
  String get feedbackTypeSuggestion => 'सुझाव';

  @override
  String get feedbackTypeBug => 'बग रिपोर्ट';

  @override
  String get feedbackContent => 'विवरण';

  @override
  String get feedbackContentHint => 'अपनी समस्या या सुझाव विस्तार से बताएँ';

  @override
  String get feedbackContact => 'संपर्क (वैकल्पिक)';

  @override
  String get feedbackSubmit => 'जमा करें';

  @override
  String get feedbackSuccess => 'फ़ीडबैक भेज दिया गया। धन्यवाद!';

  @override
  String get feedbackFailed => 'जमा करना विफल हुआ। फिर कोशिश करें।';

  @override
  String get networkTitle => 'लाइन बदलें';

  @override
  String get networkAutoSelect => 'अपने-आप';

  @override
  String get networkManual => 'मैन्युअल';

  @override
  String get timezoneTitle => 'समय क्षेत्र';

  @override
  String get timezoneAuto => 'सिस्टम के अनुसार';

  @override
  String get autoTranslateTitle => 'अपने-आप अनुवाद';

  @override
  String get autoTranslateEnabled => 'अपने-आप अनुवाद चालू करें';

  @override
  String get autoTranslateLanguage => 'लक्ष्य भाषा';

  @override
  String get displayTitle => 'डिस्प्ले';

  @override
  String get displayFontSize => 'फ़ॉन्ट आकार';

  @override
  String get displayChatBackground => 'चैट पृष्ठभूमि';

  @override
  String get displayDarkMode => 'रूप';

  @override
  String get displayDarkModeSystem => 'सिस्टम के अनुसार';

  @override
  String get displayDarkModeSystemHint =>
      'सिस्टम सेटिंग के अनुसार अपने-आप बदलें';

  @override
  String get displayDarkModeOff => 'हल्का';

  @override
  String get displayDarkModeOffHint => 'हमेशा हल्की थीम इस्तेमाल करें';

  @override
  String get displayDarkModeOn => 'गहरा';

  @override
  String get displayDarkModeOnHint => 'हमेशा गहरी थीम इस्तेमाल करें';

  @override
  String get chatSettingsTitle => 'चैट';

  @override
  String get chatHistoryTitle => 'चैट इतिहास';

  @override
  String get chatHistoryClear => 'पूरा इतिहास मिटाएँ';

  @override
  String get chatHistoryClearConfirm =>
      'पूरा चैट इतिहास मिटाएँ? इसे वापस नहीं किया जा सकता।';

  @override
  String get chatHistoryClearSuccess => 'चैट इतिहास मिटा दिया गया';

  @override
  String get accountSecurityTitle => 'खाते की सुरक्षा';

  @override
  String get accountSecurityChangePassword => 'पासवर्ड बदलें';

  @override
  String get accountSecurityChangeMobile => 'फ़ोन बदलें';

  @override
  String get accountSecurityChangeEmail => 'ईमेल बदलें';

  @override
  String get accountSecurityLoggedDevices => 'साइन इन किए डिवाइस';

  @override
  String get accountSecurityDeactivate => 'खाता हटाएँ';

  @override
  String get accountSecurityDeactivateConfirm =>
      'सभी डेटा 7 दिन बाद स्थायी रूप से हट जाएगा। खाता हटाएँ?';

  @override
  String get loggedDevicesTitle => 'साइन इन किए डिवाइस';

  @override
  String get loggedDevicesCurrent => 'यह डिवाइस';

  @override
  String get loggedDevicesRevoke => 'साइन आउट';

  @override
  String get loggedDevicesRevokeConfirm => 'इस डिवाइस से साइन आउट करें?';

  @override
  String get loggedDevicesRevokeSuccess => 'डिवाइस से साइन आउट हो गया';

  @override
  String get loggedDevicesRevokeFailed => 'विफल हुआ। फिर कोशिश करें।';

  @override
  String get loggedDevicesLastActive => 'आखिरी सक्रियता';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'वेब';

  @override
  String get loggedDevicesTypeDesktop => 'डेस्कटॉप';

  @override
  String get loggedDevicesTypeUnknown => 'अज्ञात डिवाइस';

  @override
  String get privacySettingsTitle => 'गोपनीयता';

  @override
  String get privacySearchableByMobile => 'फ़ोन नंबर से खोजने दें';

  @override
  String get privacySearchableByLppId => 'StartLink ID से खोजने दें';

  @override
  String get privacyAllowFriendRequest => 'दोस्ती के अनुरोध स्वीकार करें';

  @override
  String get privacyProfileVisibility => 'प्रोफ़ाइल की दृश्यता';

  @override
  String get privacyEveryone => 'सभी';

  @override
  String get privacyFriendsOfFriends => 'दोस्तों के दोस्त';

  @override
  String get privacyNobody => 'कोई नहीं';

  @override
  String get privacyFriendsOnly => 'केवल दोस्त';

  @override
  String get privacySaveSuccess => 'सेटिंग सहेज ली गईं';

  @override
  String get privacySaveFailed => 'सहेजना विफल हुआ। फिर कोशिश करें।';

  @override
  String get fontSizeTitle => 'फ़ॉन्ट आकार';

  @override
  String get fontSizeSmall => 'छोटा';

  @override
  String get fontSizeNormal => 'मानक';

  @override
  String get fontSizeLarge => 'बड़ा';

  @override
  String get fontSizeExtraLarge => 'अतिरिक्त बड़ा';

  @override
  String get fontSizePreview => 'पूर्वावलोकन';

  @override
  String get chatBackgroundTitle => 'चैट पृष्ठभूमि';

  @override
  String get chatBackgroundDefault => 'डिफ़ॉल्ट';

  @override
  String get chatBackgroundCustom => 'कस्टम';

  @override
  String get chatBackgroundReset => 'डिफ़ॉल्ट्स पुनः स्थापित करें';

  @override
  String get termsTitle => 'सेवा की शर्तें';

  @override
  String get privacyPolicyTitle => 'गोपनीयता नीति';

  @override
  String get recentContactsTitle => 'हाल के';

  @override
  String get recentContactsEmpty => 'हाल में कोई संपर्क नहीं है';

  @override
  String get inviteFriendsTitle => 'दोस्तों को आमंत्रित करें';

  @override
  String get inviteFriendsCopyLink => 'आमंत्रण लिंक कॉपी करें';

  @override
  String get inviteFriendsLinkCopied => 'आमंत्रण लिंक कॉपी हो गया';

  @override
  String get imageViewerTitle => 'फ़ोटो';

  @override
  String get imageViewerSave => 'एल्बम में सहेजें';

  @override
  String get imageViewerSaveSuccess => 'एल्बम में सहेजा गया';

  @override
  String get imageViewerSaveFailed => 'सहेजना विफल हुआ। फिर कोशिश करें।';

  @override
  String get customerServiceTitle => 'सेवा डेस्क';

  @override
  String get customerServiceQueue => 'कतार में';

  @override
  String get customerServiceActive => 'सक्रिय';

  @override
  String get customerServiceClaim => 'स्वीकार करें';

  @override
  String get customerServiceTakeover => 'अपने नियंत्रण में लें';

  @override
  String get customerServiceClose => 'सेवा समाप्त करें';

  @override
  String get customerServiceCloseConfirm => 'यह सेवा सत्र समाप्त करें?';

  @override
  String get customerServiceNoQueue => 'कतार में कोई सत्र नहीं है';

  @override
  String get customerServiceNoActive => 'कोई सक्रिय सत्र नहीं है';

  @override
  String get customerServiceVisitor => 'आगंतुक';

  @override
  String get customerServiceCustomer => 'ग्राहक';

  @override
  String get customerServiceAssignedTo => 'सौंपा गया';

  @override
  String get customerServiceTransferConversation => 'चैट सौंपें';

  @override
  String get marketingToolbar => 'मार्केटिंग साधन';

  @override
  String get callIncoming => 'आने वाली कॉल';

  @override
  String get callOutgoing => 'जाने वाली कॉल';

  @override
  String get callAccept => 'स्वीकार करें';

  @override
  String get callReject => 'अस्वीकार करें';

  @override
  String get callHangup => 'समाप्त करें';

  @override
  String get callMissed => 'छूटी हुई कॉल';

  @override
  String get callDuration => 'अवधि';

  @override
  String get callAudio => 'वॉइस कॉल';

  @override
  String get callGeneric => 'कॉल';

  @override
  String get callVideo => 'वीडियो कॉल';

  @override
  String get callConnecting => 'कनेक्ट हो रहा है…';

  @override
  String get callRinging => 'घंटी बज रही है…';

  @override
  String get callEnded => 'कॉल समाप्त';

  @override
  String get callFailed => 'कॉल विफल हुई';

  @override
  String get callRejected => 'कॉल अस्वीकृत';

  @override
  String get callTimeout => 'कोई जवाब नहीं';

  @override
  String get callCancelled => 'रद्द हुई';

  @override
  String get callUnknownPeer => 'अज्ञात';

  @override
  String get callVideoInvitation => 'वीडियो कॉल का आमंत्रण';

  @override
  String get callAudioInvitation => 'वॉइस कॉल का आमंत्रण';

  @override
  String get callAnswerAudio => 'ऑडियो से जवाब दें';

  @override
  String get callAnswerVideo => 'वीडियो से जवाब दें';

  @override
  String get callViewProfile => 'प्रोफ़ाइल देखें';

  @override
  String get callOpeningCamera => 'कैमरा खुल रहा है…';

  @override
  String get callWaitingRemoteVideo => 'दूसरी ओर के वीडियो की प्रतीक्षा है…';

  @override
  String get callCameraOff => 'कैमरा बंद';

  @override
  String get callCameraOn => 'कैमरा चालू';

  @override
  String get callMicrophoneOff => 'माइक्रोफ़ोन बंद';

  @override
  String get callMicrophoneOn => 'माइक्रोफ़ोन चालू';

  @override
  String get callSpeakerOff => 'स्पीकर बंद';

  @override
  String get callSpeakerOn => 'स्पीकर चालू';

  @override
  String get callVideoPermissionFailure =>
      'वीडियो कॉल शुरू नहीं हो सकी। कैमरा और माइक्रोफ़ोन अनुमतियाँ जाँचकर फिर कोशिश करें।';

  @override
  String get callAudioPermissionFailure =>
      'वॉइस कॉल शुरू नहीं हो सकी। माइक्रोफ़ोन अनुमति जाँचकर फिर कोशिश करें।';

  @override
  String get callIncompleteIncoming =>
      'आने वाली कॉल की जानकारी अधूरी है, इसलिए जवाब नहीं दिया जा सकता।';

  @override
  String get callInProgress => 'कॉल पर';

  @override
  String get callCalling => 'कॉल की जा रही है…';

  @override
  String callEndedMedia(String media) {
    return '$media समाप्त';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media अस्वीकृत हुई';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media का जवाब नहीं मिला';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media रद्द हुई';
  }

  @override
  String get callConnectionLost => 'कॉल का कनेक्शन टूट गया';

  @override
  String get callAdminEnded => 'व्यवस्थापक ने कॉल समाप्त की';

  @override
  String callFailedMedia(String media) {
    return '$media विफल हुई';
  }

  @override
  String get callBusy => 'दूसरी ओर व्यक्ति व्यस्त है';

  @override
  String callDurationValue(String duration) {
    return 'कॉल की अवधि $duration';
  }

  @override
  String get callNotConnected => 'कनेक्ट नहीं हुआ';

  @override
  String get callDialed => 'जाने वाली';

  @override
  String get callAnswered => 'जवाब दिया गया';

  @override
  String get callRejectedByPeer => 'दूसरी ओर से अस्वीकृत';

  @override
  String get callRejectedBySelf => 'अस्वीकृत';

  @override
  String get callPeerDidNotAnswer => 'दूसरी ओर से जवाब नहीं मिला';

  @override
  String get callMissedIncoming => 'छूटी हुई आने वाली कॉल';

  @override
  String get callPeerCancelled => 'दूसरी ओर से रद्द हुई';

  @override
  String get notificationNewMessageTitle => 'नया StartLink संदेश';

  @override
  String get notificationOnlineServiceTitle => 'ग्राहक सेवा का नया संदेश';

  @override
  String get notificationNewMessageBody => 'आपको नया संदेश मिला है';

  @override
  String get notificationImagePreview => 'चित्र भेजा';

  @override
  String get notificationVideoPreview => 'वीडियो भेजा';

  @override
  String get notificationVoicePreview => 'वॉइस संदेश भेजा';

  @override
  String get notificationFilePreview => 'फ़ाइल भेजी';

  @override
  String get notificationContactPreview => 'संपर्क कार्ड भेजा';

  @override
  String get notificationCallLogPreview => 'कॉल रिकॉर्ड भेजा';

  @override
  String get notificationLocationPreview => 'स्थान साझा किया';

  @override
  String get notificationLinkPreview => 'लिंक साझा किया';

  @override
  String notificationMentionMe(String body) {
    return 'आपको मेंशन किया: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender ने आपको मेंशन किया: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'सभी को मेंशन किया: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender ने सभी को मेंशन किया: $body';
  }

  @override
  String get notificationSecurityTitle => 'खाते की सुरक्षा चेतावनी';

  @override
  String get notificationSecurityBody =>
      'आपके StartLink खाते की सुरक्षा सेटिंग बदली हैं। अभी जाँचें।';

  @override
  String get notificationFriendAcceptedTitle => 'दोस्ती का अनुरोध स्वीकार हुआ';

  @override
  String get notificationFriendRejectedTitle => 'दोस्ती का अनुरोध अस्वीकृत हुआ';

  @override
  String get notificationFriendAcceptedBody =>
      'दूसरी ओर ने आपका दोस्ती का अनुरोध स्वीकार किया';

  @override
  String get notificationFriendRejectedBody =>
      'दूसरी ओर ने आपका दोस्ती का अनुरोध अस्वीकार किया';

  @override
  String get notificationVideoCallTitle => 'वीडियो कॉल का आमंत्रण';

  @override
  String get notificationAudioCallTitle => 'वॉइस कॉल का आमंत्रण';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller ने आपको वीडियो कॉल में आमंत्रित किया';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller ने आपको वॉइस कॉल में आमंत्रित किया';
  }

  @override
  String get notificationMessageChannelName => 'संदेश';

  @override
  String get notificationMessageChannelDescription =>
      'चैट संदेश, कॉल रिकॉर्ड और सिस्टम चेतावनियाँ';

  @override
  String get notificationCallChannelName => 'कॉल';

  @override
  String get notificationCallChannelDescription => 'वॉइस और वीडियो कॉल सूचनाएँ';

  @override
  String get notificationSecurityChannelName => 'खाते की सुरक्षा';

  @override
  String get notificationSecurityChannelDescription =>
      'साइन इन, पासवर्ड और मोबाइल नंबर बदलने की सूचनाएँ';

  @override
  String get notificationUnknownCaller => 'अज्ञात कॉलर';

  @override
  String get pendingJoinRequestsTitle => 'नए आवेदन';

  @override
  String get pendingJoinRequestsEmpty => 'कोई आवेदन नहीं है';

  @override
  String get pendingJoinRequestApprove => 'स्वीकार करें';

  @override
  String get pendingJoinRequestReject => 'अस्वीकार करें';

  @override
  String get pendingJoinRequestApproveSuccess => 'अनुमोदित';

  @override
  String get pendingJoinRequestRejectSuccess => 'अस्वीकृत';

  @override
  String get pendingJoinRequestFailed => 'कार्रवाई विफल हुई। फिर कोशिश करें।';

  @override
  String get myCustomersTitle => 'मेरे ग्राहक';

  @override
  String get myCustomersEmpty => 'कोई ग्राहक नहीं है';

  @override
  String get groupListTitle => 'समूह';

  @override
  String get groupListEmpty => 'कोई समूह नहीं है';

  @override
  String get addFriendTitle => 'संपर्क जोड़ें';

  @override
  String get addFriendSearchHint => 'फ़ोन / ईमेल / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'जोड़ें';

  @override
  String get addFriendCannotAddSelf => 'आप स्वयं को नहीं जोड़ सकते';

  @override
  String get addFriendUnsupportedUser =>
      'इस उपयोगकर्ता को जोड़ा नहीं जा सकता। आप सीधे संदेश भेज सकते हैं।';

  @override
  String get addFriendMessageHint => 'संदेश दर्ज करें';

  @override
  String get addFriendSendRequest => 'अनुरोध भेजें';

  @override
  String get joinCompanyTitle => 'कंपनी में शामिल हों';

  @override
  String get joinCompanyCodeHint => 'कंपनी कोड दर्ज करें';

  @override
  String get joinCompanySearchHint => 'कंपनी का नाम खोजें';

  @override
  String get joinCompanyApply => 'शामिल होने का आवेदन दें';

  @override
  String get joinCompanyApplySuccess => 'आवेदन भेज दिया गया';

  @override
  String get joinCompanyApplyFailed => 'आवेदन विफल हुआ। फिर कोशिश करें।';

  @override
  String get joinCompanyAutoApproved => 'अपने-आप अनुमोदित। स्वागत है!';

  @override
  String get joinCompanyPending =>
      'आवेदन भेज दिया गया, अनुमोदन की प्रतीक्षा है';

  @override
  String get joinCompanyInviteCodeHint => 'आमंत्रण कोड दर्ज करें';

  @override
  String get joinCompanyAcceptInvite => 'आमंत्रण स्वीकार करें';

  @override
  String get joinCompanyNoResults => 'कोई कंपनी नहीं मिली';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count सदस्य';
  }

  @override
  String get timezoneNameHawaii => 'हवाई';

  @override
  String get timezoneNameAlaska => 'अलास्का';

  @override
  String get timezoneNamePacificTime => 'प्रशांत समय';

  @override
  String get timezoneNameMountainTime => 'पर्वतीय समय';

  @override
  String get timezoneNameCentralTime => 'केंद्रीय समय';

  @override
  String get timezoneNameEasternTime => 'पूर्वी समय';

  @override
  String get timezoneNameAtlanticTime => 'अटलांटिक समय';

  @override
  String get timezoneNameBrasilia => 'ब्रासीलिया';

  @override
  String get timezoneNameAzores => 'अज़ोरेस';

  @override
  String get timezoneNameLondonDublin => 'लंदन/डबलिन';

  @override
  String get timezoneNameBerlinParisRome => 'बर्लिन/पेरिस/रोम';

  @override
  String get timezoneNameCairoHelsinki => 'काहिरा/हेलसिंकी';

  @override
  String get timezoneNameMoscowRiyadh => 'मॉस्को/रियाद';

  @override
  String get timezoneNameTehran => 'तेहरान';

  @override
  String get timezoneNameDubaiBaku => 'दुबई/बाकू';

  @override
  String get timezoneNameKabul => 'काबुल';

  @override
  String get timezoneNameKarachiTashkent => 'कराची/ताशकंद';

  @override
  String get timezoneNameMumbaiNewDelhi => 'मुंबई/नई दिल्ली';

  @override
  String get timezoneNameKathmandu => 'काठमांडू';

  @override
  String get timezoneNameDhakaAlmaty => 'ढाका/अल्माटी';

  @override
  String get timezoneNameYangon => 'यांगून';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'बैंकॉक/हनोई/जकार्ता';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'बीजिंग/शंघाई/हांगकांग/ताइपे';

  @override
  String get timezoneNameTokyoSeoul => 'टोक्यो/सियोल';

  @override
  String get timezoneNameAdelaide => 'एडिलेड';

  @override
  String get timezoneNameSydneyMelbourne => 'सिडनी/मेलबर्न';

  @override
  String get timezoneNameSolomonIslands => 'सोलोमन द्वीप';

  @override
  String get timezoneNameAucklandFiji => 'ऑकलैंड/फ़िजी';

  @override
  String get networkSmartSelectBestRoute => 'सबसे अच्छा मार्ग अपने-आप चुनें';

  @override
  String get networkTesting => 'परीक्षण जारी है…';

  @override
  String get networkTestingShort => 'परीक्षण';

  @override
  String networkLatencyMs(int ms) {
    return 'विलंब $ms ms';
  }

  @override
  String get networkConnectionMode => 'कनेक्शन मोड';

  @override
  String get networkDirectMode => 'सीधा मोड';

  @override
  String get networkProxyMode => 'प्रॉक्सी मोड';

  @override
  String get networkDirectModeDesc => 'सीधे सर्वर से जुड़ें';

  @override
  String get networkProxyModeDesc => 'प्रॉक्सी सर्वर के माध्यम से जुड़ें';

  @override
  String get networkDirectRoutes => 'सीधे मार्ग';

  @override
  String get networkProxyRoutes => 'प्रॉक्सी मार्ग';

  @override
  String get networkTestAll => 'सभी का परीक्षण करें';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'हांगकांग नोड';

  @override
  String get networkSingaporeNode => 'सिंगापुर नोड';

  @override
  String get networkJapanNode => 'जापान नोड';

  @override
  String get networkUnitedStatesNode => 'अमेरिका नोड';

  @override
  String get networkHint =>
      'सुझाव:\n• सीधा मोड: तेज़ और देश के भीतर उपयोग के लिए उपयुक्त\n• प्रॉक्सी मोड: अंतरराष्ट्रीय संचार के लिए अधिक स्थिर\n• किसी एक मार्ग का विलंब जाँचने के लिए रीफ़्रेश चिह्न पर टैप करें';

  @override
  String get teenModeTitle => 'किशोर मोड';

  @override
  String get teenModeStatusOn => 'चालू';

  @override
  String get teenModeStatusOff => 'बंद';

  @override
  String get teenModeStatusLoading => 'लोड हो रहा है';

  @override
  String get teenModeUnavailable =>
      'किशोर मोड की स्थिति अस्थायी रूप से उपलब्ध नहीं है';

  @override
  String get teenModeInvalidResponse => 'किशोर मोड से अमान्य उत्तर मिला';

  @override
  String get teenModeEnableDescription =>
      'प्लेटफ़ॉर्म नियम उपयोग के समय और चुनी हुई सुविधाओं को सीमित करेंगे।';

  @override
  String get teenModePasscode => 'पासकोड';

  @override
  String get teenModeCurrentPasscode => 'वर्तमान पासकोड';

  @override
  String get teenModeNewPasscode => 'नया पासकोड';

  @override
  String get teenModePasscodeHint => '4–6 अंक दर्ज करें';

  @override
  String get teenModeEnable => 'किशोर मोड चालू करें';

  @override
  String get teenModeDisable => 'किशोर मोड बंद करें';

  @override
  String get teenModeChangePasscode => 'पासकोड बदलें';

  @override
  String get teenModeSource => 'सक्रिय करने वाला';

  @override
  String get teenModeDailyUsage => 'आज का उपयोग';

  @override
  String get teenModeRemaining => 'बाकी समय';

  @override
  String get teenModeMinutesUnit => 'मिनट';

  @override
  String get teenModeUnlimited => 'असीमित';

  @override
  String get teenModeRequestExtension => 'और समय माँगें';

  @override
  String get teenModeExtensionSubmitted =>
      'समय का अनुरोध अभिभावक को भेज दिया गया';

  @override
  String get teenModeTimeLimitReached => 'आज की उपयोग सीमा पूरी हो गई है';

  @override
  String get teenModeCurfewActive => 'इस समय उपयोग प्रतिबंधित है';

  @override
  String get teenModeReliefHint =>
      'आप अभी भी इतिहास देख सकते हैं, आधिकारिक सहायता से संपर्क कर सकते हैं और समस्या बता सकते हैं।';

  @override
  String get teenModeRestrictedNotice =>
      'किशोर मोड अभी संदेश भेजने से रोकता है';

  @override
  String get teenModeActionBlocked => 'किशोर मोड अभी इस कार्रवाई से रोकता है';

  @override
  String get teenModeMyRequests => 'मेरे अनुरोध';

  @override
  String get guardianCenterTitle => 'अभिभावक केंद्र';

  @override
  String get guardianRelationships => 'अभिभावक संबंध';

  @override
  String get guardianMinors => 'मेरी निगरानी में बच्चे';

  @override
  String get guardianApprovals => 'अनुमोदन की प्रतीक्षा';

  @override
  String get guardianBind => 'लिंकिंग कोड दर्ज करें';

  @override
  String get guardianCreateMinorCode => 'मैं बच्चा हूँ — कोड बनाएँ';

  @override
  String get guardianCreateGuardianCode => 'मैं अभिभावक हूँ — कोड बनाएँ';

  @override
  String get guardianRelation => 'संबंध';

  @override
  String get guardianPrimary => 'मुख्य अभिभावक';

  @override
  String get guardianCode => '6 अंकों का लिंकिंग कोड';

  @override
  String get guardianCodeHint => 'दूसरे व्यक्ति से मिला कोड दर्ज करें';

  @override
  String get guardianCodeCreated =>
      'कोड बन गया। अवधि समाप्त होने से पहले साझा करें।';

  @override
  String get guardianEmpty => 'कोई अभिभावक संबंध नहीं है';

  @override
  String get guardianNoMinors => 'निगरानी में कोई बच्चा नहीं है';

  @override
  String get guardianUnbind => 'संबंध हटाएँ';

  @override
  String get guardianExtend => 'बच्चे के लिए समय जोड़ें';

  @override
  String get guardianPolicyTitle => 'उपयोग के नियम';

  @override
  String get guardianPolicyLocked => 'प्लेटफ़ॉर्म ने लॉक किया है';

  @override
  String get approvalEmpty => 'कोई अनुरोध नहीं है';

  @override
  String get approvalApprove => 'स्वीकार करें';

  @override
  String get approvalReject => 'अस्वीकार करें';

  @override
  String get approvalPending => 'लंबित';

  @override
  String get approvalApproved => 'अनुमोदित';

  @override
  String get approvalRejected => 'अस्वीकृत';

  @override
  String get approvalExpired => 'समाप्त';

  @override
  String get approvalCancelled => 'रद्द किया गया';

  @override
  String get approvalReplayFailed => 'मूल कार्रवाई विफल हुई। फिर कोशिश करें।';

  @override
  String get requestCancelled => 'अनुरोध रद्द हुआ';

  @override
  String get kycTitle => 'पहचान सत्यापन';

  @override
  String get kycNotRequired => 'पहचान सत्यापन ज़रूरी नहीं है';

  @override
  String get kycVerified => 'पहचान सत्यापित';

  @override
  String get kycDeclared => 'पहचान की जानकारी जमा की गई';

  @override
  String get kycPending => 'समीक्षा जारी है';

  @override
  String get kycRejected => 'समीक्षा में अस्वीकृत';

  @override
  String get kycNone => 'पहचान की जानकारी जमा नहीं की गई';

  @override
  String get kycRealName => 'पूरा नाम';

  @override
  String get kycIdNumber => 'आईडी नंबर';

  @override
  String get kycIdType => 'दस्तावेज़ का प्रकार';

  @override
  String get kycApplicability =>
      'चुने गए दस्तावेज़ के लिए अपनी वास्तविक जानकारी दर्ज करें। स्वीकार्य प्रकार सूची में हैं।';

  @override
  String get kycCamera => 'फोटो लें';

  @override
  String get kycGallery => 'एल्बम से चुनें';

  @override
  String get kycPhotoLimit => 'हर फ़ोटो का अधिकतम आकार';

  @override
  String get kycSelectPhoto => 'फ़ोटो चुनें';

  @override
  String get kycPhotoSelected => 'चुना गया';

  @override
  String get kycViewPhoto => 'फ़ोटो देखने के लिए टैप करें';

  @override
  String get kycReplacePhoto => 'दूसरी फ़ोटो चुनें';

  @override
  String get kycDisclosure =>
      'हम आपकी पहचान की जाँच के लिए नाम, दस्तावेज़ संख्या और दस्तावेज़ की फ़ोटो इस्तेमाल करते हैं। इनके बिना आवेदन जमा नहीं होगा और कुछ प्रतिबंधित सुविधाएँ उपलब्ध नहीं होंगी।';

  @override
  String get kycConsent =>
      'मैं इस पहचान संबंधी जानकारी के प्रसंस्करण की अलग से सहमति देता हूँ';

  @override
  String get kycConsentRequired => 'जमा करने से पहले अलग से सहमति दें';

  @override
  String get kycResubmitTitle => 'पहचान की जानकारी फिर जमा करें';

  @override
  String get kycResubmitWarning =>
      'फिर जमा करने से आपका लंबित आवेदन बदल जाएगा। जारी रखें?';

  @override
  String get kycSubmitting => 'जमा हो रहा है';

  @override
  String get kycSubmitFailed => 'जमा करना विफल हुआ। फिर कोशिश करें।';

  @override
  String get kycSubmitUnavailable => 'अभी पहचान की जानकारी जमा नहीं हो सकती';

  @override
  String get kycResubmitNotAllowed =>
      'अस्वीकृति के बाद फिर जमा करना उपलब्ध नहीं है। ज़रूरत होने पर सहायता से संपर्क करें।';

  @override
  String get kycDailyLimit => 'आज की आवेदन सीमा पूरी हो गई है। कल कोशिश करें।';

  @override
  String get kycTypeUnavailable =>
      'कोई दस्तावेज़ प्रकार उपलब्ध नहीं है। बाद में फिर कोशिश करें।';

  @override
  String get kycNameInvalid => 'कानूनी नाम 2–64 वर्णों का होना चाहिए';

  @override
  String get kycNumberRequired => 'दस्तावेज़ संख्या दर्ज करें';

  @override
  String get kycFrontRequired => 'दस्तावेज़ का सामने वाला भाग अपलोड करें';

  @override
  String get kycBackRequired => 'दस्तावेज़ का पीछे वाला भाग अपलोड करें';

  @override
  String get kycPhotoTooLarge =>
      'फ़ोटो आकार सीमा से बड़ी है। संपीड़ित करके फिर कोशिश करें।';

  @override
  String get kycAccountChanged => 'खाता या स्पेस बदल गया। यह पेज फिर खोलें।';

  @override
  String get kycPhotoInvalid => 'मान्य चित्र चुनें';

  @override
  String get kycPortraitSide => 'फ़ोटो वाला भाग';

  @override
  String get kycEmblemSide => 'पहचान पत्र का पिछला भाग';

  @override
  String get kycPassportDataPage => 'पासपोर्ट का जानकारी पृष्ठ';

  @override
  String get kycPassportOtherPage => 'पासपोर्ट का वीज़ा या खाली पृष्ठ';

  @override
  String get kycFront => 'पहचान पत्र का सामने का भाग';

  @override
  String get kycBack => 'पहचान पत्र का पिछला भाग';

  @override
  String get kycRequired => 'समूह बनाने से पहले पहचान सत्यापन ज़रूरी है';

  @override
  String get kycGoVerify => 'अभी सत्यापित करें';

  @override
  String get kycStatusUnknown =>
      'पहचान की स्थिति उपलब्ध नहीं है। बाद में रीफ़्रेश करें।';

  @override
  String get kycSuperseded =>
      'बाद के आवेदन ने इसे बदल दिया। अपनी नवीनतम पहचान स्थिति देखें।';

  @override
  String get kycMediaNotFound =>
      'दस्तावेज़ की फ़ोटो इस स्पेस में उपलब्ध नहीं है। जमा करने से पहले फिर चुनें।';

  @override
  String get customerServiceBroadcastDirectTitle => 'ग्राहकों को सामूहिक संदेश';

  @override
  String get officialAccountBadge => 'आधिकारिक';

  @override
  String get officialAccountOpenConversation => 'बातचीत खोलें';

  @override
  String get officialAccountJoinHint =>
      'इस खाते को जोड़ने पर आप ग्राहक के रूप में कंपनी में शामिल होते हैं। दोस्ती का अनुमोदन ज़रूरी नहीं है।';

  @override
  String get officialAccountJoinDisabled =>
      'यह कंपनी नए ग्राहक स्वीकार नहीं कर रही। सहायता से संपर्क करें।';

  @override
  String get officialAccountRemoved =>
      'आपको इस कंपनी से हटा दिया गया। कंपनी से फिर आमंत्रित करने को कहें।';

  @override
  String get officialAccountBanned =>
      'इस कंपनी में आपका खाता निष्क्रिय कर दिया गया है।';

  @override
  String get officialAccountUnavailable =>
      'यह आधिकारिक खाता अभी उपलब्ध नहीं है।';

  @override
  String get officialAccountJoinBindingDisabled =>
      'वर्तमान मोड में कंपनी में शामिल होना अनुमत नहीं है।';

  @override
  String get officialAccountPlatformRequired =>
      'इस आधिकारिक खाते को जोड़ने के लिए प्लेटफ़ॉर्म खाता इस्तेमाल करें।';

  @override
  String get officialAccountOpenFailed =>
      'बातचीत खुल नहीं सकी। फिर कोशिश करें।';

  @override
  String get officialAccountAccountChanged =>
      'खाता या स्पेस बदल गया। फिर खोलें।';

  @override
  String get officialAccountDirectoryUnavailable =>
      'कंपनी डायरेक्टरी अपडेट नहीं है। थोड़ी देर बाद फिर कोशिश करें।';

  @override
  String get officialAccountInboxSyncFailed =>
      'आधिकारिक खाता सिंक विफल हुआ। स्थानीय सामग्री अभी भी उपलब्ध है।';

  @override
  String get officialAccountInboxSyncing =>
      'आधिकारिक खाते के संदेश सिंक हो रहे हैं';

  @override
  String get diagnosticsTitle => 'निदान';

  @override
  String get diagnosticsExplanation =>
      'लॉग में संवेदनशील जानकारी छिपाई जाती है। इनमें इस खाते और स्पेस की संचालन व त्रुटि जानकारी तथा सार्वजनिक स्टार्टअप घटनाएँ होती हैं। चैट सामग्री और लॉगिन जानकारी शामिल नहीं हैं।';

  @override
  String get diagnosticsHour => 'पिछला घंटा';

  @override
  String get diagnosticsDay => 'पिछले 24 घंटे';

  @override
  String get diagnosticsWeek => '7 दिन';

  @override
  String diagnosticsEventCount(int count) {
    return 'उपलब्ध घटनाएँ: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'लॉग इस डिवाइस पर सहेजे जाते हैं और फिर शुरू होने के बाद भी उपलब्ध रहते हैं।';

  @override
  String get diagnosticsNotPersistent =>
      'कुछ लॉग सहेजे नहीं गए। फिर कोशिश करने के लिए रीफ़्रेश करें।';

  @override
  String get diagnosticsExport => 'निर्यात और साझा करें';

  @override
  String get diagnosticsRefresh => 'ताज़ा करें';

  @override
  String get diagnosticsClear => 'इस स्पेस के लॉग मिटाएँ';

  @override
  String get diagnosticsClearConfirm =>
      'इस स्पेस के निदान लॉग मिटाएँ? चैट इतिहास बना रहेगा।';

  @override
  String get diagnosticsShared =>
      'सिस्टम से साझा करना पूरा हुआ। प्राप्त करने वाले ऐप में फ़ाइल जाँचें।';

  @override
  String get diagnosticsCancelled =>
      'साझा करना रद्द हुआ। आप फिर निर्यात कर सकते हैं।';

  @override
  String get diagnosticsUnconfirmed =>
      'साझा करने की पुष्टि नहीं हो सकी। प्राप्त करने वाला ऐप जाँचें।';

  @override
  String get diagnosticsFailed => 'कार्रवाई विफल हुई। फिर कोशिश करें।';
}
