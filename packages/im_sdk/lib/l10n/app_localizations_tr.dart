// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get navWorkbench => 'Çalışma alanı';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Hesap verileri yüklenemedi';

  @override
  String get startupFailureTitle => 'Başlatılamadı';

  @override
  String get startupFailureMessage => 'Ağınızı kontrol edip tekrar deneyin';

  @override
  String get privacyConsentTitle => 'Hizmet Şartları ve Gizlilik Politikası';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return '$brand uygulamasına hoş geldiniz. Hesaba giriş, anlık mesajlaşma, kurumsal iş birliği, çevrim içi müşteri hizmetleri, mesaj bildirimleri ve güvenlik hizmetlerini sunmak için Hizmet Koşulları ve Gizlilik Politikası kapsamında gerekli bilgileri işlememiz gerekir.\n\nKabul Et seçeneğine dokunmadan önce panoyu okumayız, JPush/JCore veya cihaz üreticisinin anlık bildirim SDK’larını başlatmayız ve bu SDK’larla Android ID, OAID, yüklü uygulama listesi, MAC adresi ya da benzer bilgilere erişmeyiz. Şimdilik kabul etmezseniz seçiminizi kaydederiz; belgeleri okumaya devam edebilir ve daha sonra yeniden karar verebilirsiniz.\n\nKabul ettikten sonra mesaj, müşteri hizmetleri ve gelen arama bildirimlerini iletmek için JPush/JCore ve cihaz üreticisinin anlık bildirim hizmetleri; cihaz modeli, Android sürümü, uygulama paket adı ve sürümü, ağ türü, IP adresi, Android ID, OAID, bildirim Registration ID’si, üreticinin bildirim belirteci ve bildirim teslim/tıklama verilerini işleyebilir. Akıllı bildirim, yüklü uygulama listesi, MAC, IMEI, IMSI, Wi-Fi listesi, otomatik uyandırma ve bağlantılı başlatma gibi zorunlu olmayan özellikler kapatılmıştır.\n\nPanoya yalnızca kopyalama veya yapıştırma işlevini kullandığınızda erişilir. Kamera, mikrofon, bildirim ve diğer sistem izinleri yalnızca ilgili özelliği kullandığınızda istenir. Bir izni reddetmek yalnızca ilgili özelliği etkiler. Lütfen aşağıdaki belgelerin tamamını okuyup kabul edip etmeyeceğinize karar verin.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return '$brand uygulamasına hoş geldiniz. Hesaba giriş, anlık mesajlaşma, kurumsal iş birliği, çevrim içi müşteri hizmetleri, mesaj bildirimleri ve güvenlik hizmetlerini sunmak için Hizmet Koşulları ve Gizlilik Politikası kapsamında gerekli bilgileri işlememiz gerekir.\n\nKabul Et seçeneğine dokunmadan önce panoyu okumayız, JPush/JCore’u başlatmayız, Apple Push Notification service (APNs) hizmetine kaydolmayız ve JPush Registration ID veya APNs cihaz belirteci gibi bildirim tanımlayıcılarını almayız. Şimdilik kabul etmezseniz seçiminizi kaydederiz; belgeleri okumaya devam edebilir ve daha sonra yeniden karar verebilirsiniz.\n\nKabul ettikten sonra mesaj, müşteri hizmetleri ve gelen arama bildirimlerini iletmek için iPhone modeli, iOS sürümü, uygulama paket adı ve sürümü, ağ türü, IP adresi, IDFV, JPush Registration ID, APNs cihaz belirteci ve bildirim teslim/tıklama verilerini işleyebiliriz. JPush/JCore bildirim hizmetine bağlanır; Apple APNs, sistem bildirimlerini iletmek için uygulama tanımlayıcısını, cihaz belirtecini ve bildirim içeriğini işler. Mevcut iOS uygulaması reklam hizmeti kullanmaz ve IDFA almaz.\n\nPanoya yalnızca kopyalama veya yapıştırma işlevini kullandığınızda erişilir. Kamera, mikrofon, bildirim ve diğer sistem izinleri yalnızca ilgili özelliği kullandığınızda istenir. Bir izni reddetmek yalnızca ilgili özelliği etkiler. Lütfen aşağıdaki belgelerin tamamını okuyup kabul edip etmeyeceğinize karar verin.';
  }

  @override
  String get privacyConsentTermsLink => 'Kullanıcı Sözleşmesi';

  @override
  String get privacyConsentConjunction => 've';

  @override
  String get privacyConsentPrivacyLink => 'Gizlilik Politikası';

  @override
  String get privacyConsentDecline => 'Kabul Etmiyorum';

  @override
  String get privacyConsentDeclinedExit =>
      'Hizmet Koşulları ve Gizlilik Politikası’nı kabul etmediniz. Uygulama kapanacak.';

  @override
  String get privacyConsentAccept => 'Kabul Ediyorum';

  @override
  String get privacyConsentRuntimeFailure =>
      'Başlatılamadı. Ağınızı kontrol edip tekrar deneyin.';

  @override
  String get privacyConsentSaveFailure =>
      'Seçiminiz kaydedilemedi. Tekrar deneyin.';

  @override
  String get appUpdateRequiredTitle => 'Devam etmek için güncelleyin';

  @override
  String get appUpdateOptionalTitle => 'Yeni sürüm mevcut';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version kullanıma hazır';
  }

  @override
  String get appUpdateLater => 'Sonra';

  @override
  String get appUpdateNow => 'Şimdi Güncelle';

  @override
  String get appUpdateProcessing => 'İşleniyor...';

  @override
  String get appUpdateInvalidUrl =>
      'Güncelleme adresi geçersiz. Daha sonra tekrar deneyin.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Güncelleme bağlantısı açılamadı. Daha sonra tekrar deneyin.';

  @override
  String get appUpdateDownloadInterrupted =>
      'İndirme kesildi. Ağınızı kontrol edip tekrar deneyin.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Paket doğrulanamadı. Yeniden indirin.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Sistem ayarlarında $brand uygulamasının güncelleme yüklemesine izin verin.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Sistem yükleyicisi açılamadı. Yükleme izinlerini kontrol edin.';

  @override
  String get appUpdateGenericFailure =>
      'Güncelleme başarısız. Ağınızı kontrol edip tekrar deneyin.';

  @override
  String get appUpdateUnavailable =>
      'Yeni sürüm henüz indirilemiyor. Daha sonra tekrar deneyin.';

  @override
  String get appUpdateCheckFailed =>
      'Güncellemeler kontrol edilemedi. Daha sonra tekrar deneyin.';

  @override
  String get appUpdateChecking => 'Kontrol ediliyor';

  @override
  String get commonConfirm => 'Tamam';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonEdit => 'Düzenle';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonSearch => 'Ara';

  @override
  String get commonLoading => 'Yükleniyor...';

  @override
  String get commonLoadFailed => 'Yükleme başarısız oldu';

  @override
  String get commonRetry => 'Yeniden Dene';

  @override
  String get commonEmpty => 'Veri Yok';

  @override
  String get commonCopy => 'Kopyala';

  @override
  String get commonForward => 'İlet';

  @override
  String get commonFavorite => 'Kaydet';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonSend => 'Gönder';

  @override
  String get commonDone => 'Bitti';

  @override
  String get commonMore => 'Diğer';

  @override
  String get commonSettings => 'Ayarlar';

  @override
  String get commonCopied => 'Kopyalandı';

  @override
  String get commonUnknown => 'Bilinmeyen';

  @override
  String get commonNotSet => 'Ayarlanmadı';

  @override
  String get commonUnbound => 'Bağlı Değil';

  @override
  String get commonViewAll => 'Tümünü gör';

  @override
  String get commonSubmit => 'Gönder';

  @override
  String get commonAdd => 'Ekle';

  @override
  String get commonRemove => 'Kaldır';

  @override
  String get commonCreate => 'Oluştur';

  @override
  String get commonUpdate => 'Güncelle';

  @override
  String get commonUpload => 'Yükle';

  @override
  String get commonShare => 'Paylaş';

  @override
  String get commonBlock => 'Engelle';

  @override
  String get commonUnblock => 'Engeli kaldır';

  @override
  String get commonMute => 'Sessize al';

  @override
  String get commonUnmute => 'Sesi aç';

  @override
  String get commonPin => 'Sabitlenmiş';

  @override
  String get commonUnpin => 'Sabitlemeyi kaldır';

  @override
  String get commonMarkRead => 'Okundu olarak işaretle';

  @override
  String get commonMarkUnread => 'Okunmadı olarak işaretle';

  @override
  String get commonOnline => 'Çevrim içi';

  @override
  String get commonOffline => 'Çevrim dışı';

  @override
  String get commonOperationFailed => 'İşlem başarısız, tekrar deneyin';

  @override
  String get commonNetworkError => 'Ağ hatası, bağlantınızı kontrol edin';

  @override
  String get navMessages => 'Mesajlar';

  @override
  String get navContacts => 'Kişiler';

  @override
  String get navMe => 'Ben';

  @override
  String get authLoginTitle => 'StartLink’e giriş yap';

  @override
  String get authTabMobile => 'Telefon';

  @override
  String get authTabEmail => 'E-posta';

  @override
  String get authTabLoginName => 'StartLink kimliği';

  @override
  String get authHintMobile => 'Telefon numarasını girin';

  @override
  String get authHintEmail => 'E-posta adresinizi girin';

  @override
  String get authHintPassword => 'Şifre girin';

  @override
  String get authHintCode => 'Doğrulama kodunu girin';

  @override
  String get authHintLoginName => 'StartLink kimliğini girin (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Giriş Yap';

  @override
  String get authGetCode => 'Kodu Al';

  @override
  String authResendCode(int seconds) {
    return '$seconds sn sonra yeniden gönder';
  }

  @override
  String get authUsePassword => 'Parola kullan';

  @override
  String get authUseCode => 'Doğrulama kodu kullan';

  @override
  String get authAgreementPrefix => 'Okudum ve kabul ediyorum';

  @override
  String get authAgreementAnd => 've';

  @override
  String get authTermsLink => 'Kullanıcı Sözleşmesi';

  @override
  String get authPrivacyLink => 'Gizlilik Politikası';

  @override
  String get authCaptchaTitle => 'Güvenlik doğrulaması';

  @override
  String get authCaptchaHint => 'Yanıtı girin';

  @override
  String get authCaptchaFailed => 'Güvenlik kodu alınamadı, tekrar deneyin';

  @override
  String get authErrorEmptyCode => 'Lütfen doğrulama kodunu girin';

  @override
  String get authErrorEmptyPassword => 'Şifre girin';

  @override
  String get authErrorEmptyLoginName => 'Lütfen StartLink kimliğini girin';

  @override
  String get authErrorWrongCredentials => 'Hesap veya parola yanlış';

  @override
  String get authDeactivatingTitle => 'Hesabı kapatma';

  @override
  String get authDeactivatingContent =>
      'Hesabınız kapatma bekleme süresinde (7 gün).\n\nKapatmayı iptal etmek için \"Kapatmayı iptal et\" seçeneğine; aksi hâlde uygulamaya girmek için \"Devam et\" seçeneğine dokunun.';

  @override
  String get authContinueUse => 'Devam et';

  @override
  String get authCancelDeactivation => 'Kapatmayı iptal et';

  @override
  String get authDeactivationCancelled =>
      'Kapatma iptal edildi, hesap geri yüklendi';

  @override
  String get authDeactivationCancelFailed => 'İptal edilemedi, tekrar deneyin';

  @override
  String get authLogout => 'Çıkış Yap';

  @override
  String get authLogoutConfirm => 'Çıkış yapmak istediğinizden emin misiniz?';

  @override
  String get authSendingCode => 'Gönderiliyor...';

  @override
  String get authCodeSent => 'Doğrulama kodu gönderildi';

  @override
  String get authLoginFailed => 'Giriş yapılamadı, tekrar deneyin';

  @override
  String get authRegisterFailed => 'Kayıt başarısız, tekrar deneyin';

  @override
  String get authEnterpriseCode => 'Kurum kodu';

  @override
  String get authEnterpriseCodeHint => 'Kurum kodunu girin';

  @override
  String get authPendingApproval =>
      'Kayıt başarılı. Kuruma katılma talebiniz gönderildi ve onay bekliyor.';

  @override
  String get authNoAccount => 'Hesabınız yok mu?';

  @override
  String get authRegisterNow => 'Şimdi kaydol';

  @override
  String get authCountryPickerTitle => 'Ülke/bölge seçin';

  @override
  String get authCountrySearchHint => 'Ülke/bölge arayın';

  @override
  String get authCountryChinaMainland => 'Çin ana karası';

  @override
  String get authCountryHongKong => 'Hong Kong, Çin';

  @override
  String get authCountryMacau => 'Makao, Çin';

  @override
  String get authCountryTaiwan => 'Tayvan, Çin';

  @override
  String get authCountryUnitedStates => 'Amerika Birleşik Devletleri';

  @override
  String get authCountryUnitedKingdom => 'Birleşik Krallık';

  @override
  String get authCountryJapan => 'Japonya';

  @override
  String get authCountrySouthKorea => 'Güney Kore';

  @override
  String get authCountrySingapore => 'Singapur';

  @override
  String get authCountryMalaysia => 'Malezya';

  @override
  String get authCountryAustralia => 'Avustralya';

  @override
  String get authCountryCanada => 'Kanada';

  @override
  String get authCountryGermany => 'Almanya';

  @override
  String get authCountryFrance => 'Fransa';

  @override
  String get authCountryIndia => 'Hindistan';

  @override
  String get authCountryThailand => 'Tayland';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Endonezya';

  @override
  String get authCountryPhilippines => 'Filipinler';

  @override
  String get authQuickLoginTitle => 'Hızlı giriş';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Giriş yapılıyor. Lütfen bekleyin.';

  @override
  String get authRoleOwner => 'Sahip';

  @override
  String get authRoleAdministrator => 'Yönetici';

  @override
  String get authRoleCustomerService => 'Müşteri hizmetleri';

  @override
  String get authRoleTechnicalSupport => 'Teknik destek';

  @override
  String get authRoleEmployee => 'Çalışan';

  @override
  String get authRoleMember => 'Üye';

  @override
  String get authRoleEnterpriseCustomer => 'Kurumsal müşteri';

  @override
  String get authUnavailablePrefix => 'Kullanılamıyor · ';

  @override
  String get authUnassignedService => 'Atanmış temsilci yok';

  @override
  String authAssignedService(String staff) {
    return '$staff kişisine atandı';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Müşteri · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Çalışan · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count kullanıcı';
  }

  @override
  String get authMetaPhone => 'Telefon';

  @override
  String get authMetaIdentity => 'Kimlik';

  @override
  String get authRegisterTitle => 'Kaydol';

  @override
  String get authNickname => 'Takma Ad';

  @override
  String get authNicknameHint => 'Takma ad belirleyin';

  @override
  String get authPassword => 'Şifre';

  @override
  String get authPasswordSetHint => 'Parola belirleyin (en az 6 karakter)';

  @override
  String get authConfirmPassword => 'Şifre Tekrarı';

  @override
  String get authConfirmPasswordHint => 'Parolayı yeniden girin';

  @override
  String get authVerificationCode => 'Doğrulama Kodu';

  @override
  String get authRegisterAndLogin => 'Kaydol ve giriş yap';

  @override
  String get authHaveAccount => 'Zaten hesabınız var mı?';

  @override
  String get authGoLogin => 'Giriş Yap';

  @override
  String get authEmailVerificationUnavailable =>
      'E-posta doğrulaması kullanılamıyor. Cep telefonu numarasıyla kaydolun.';

  @override
  String get authSmsVerificationUnavailable =>
      'SMS doğrulaması kullanılamıyor. E-posta ile kaydolun.';

  @override
  String get authSendFailed => 'Gönderilemedi. Tekrar deneyin.';

  @override
  String get authErrorEmptyNickname => 'Takma ad girin';

  @override
  String get authErrorInvalidMobile =>
      'Geçerli bir cep telefonu numarası girin';

  @override
  String get authErrorInvalidEmail => 'Geçerli bir e-posta adresi girin';

  @override
  String get authErrorPasswordTooShort => 'Parola en az 6 karakter olmalı';

  @override
  String get authErrorPasswordMismatch => 'Parolalar eşleşmiyor';

  @override
  String get authErrorVerificationRequired =>
      'Önce doğrulama kodunu alıp girin';

  @override
  String get authRegisterErrorTitle => 'Kayıt başarısız';

  @override
  String get authGotIt => 'Anladım';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return '\"$code\" kurumu bulunamadı. Kurum kodunu kontrol edin.';
  }

  @override
  String get authTenantSearchFailed => 'Arama başarısız. Tekrar deneyin.';

  @override
  String get authInvitationInvalid =>
      'Davet kodu geçersiz. Kontrol edip tekrar deneyin.';

  @override
  String get authCollapseJoin => 'Katılım bilgilerini gizle';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Geçerli davet: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Kurum bulundu: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Kuruluş seçin';

  @override
  String get authNoOrganization => 'Kullanılabilir kuruluş yok';

  @override
  String get authNoOrganizationHint =>
      'Bir yöneticiden sizi kuruluşa davet etmesini isteyin';

  @override
  String get authPersonalSpace => 'Kişisel alan';

  @override
  String get authPersonalSpaceSubtitle =>
      'Arkadaş sohbetleri ve kişisel favoriler';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Alan kimliği doğrulanamadı. Tekrar deneyin.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Kişisel alan geri yüklenemedi. Tekrar deneyin.';

  @override
  String get authJoinEnterpriseFailed =>
      'Kuruma katılınamadı. Daha sonra tekrar deneyin.';

  @override
  String get homeTitle => 'Mesajlar';

  @override
  String get homeGatewayConnectingTitle => 'Bağlanıyor';

  @override
  String get homePersonalSpace => 'Kişisel';

  @override
  String get homeOfficialService => 'Resmî hizmet';

  @override
  String get homeSwitchSpace => 'Alan değiştir';

  @override
  String get homeSpaceSubtitle => 'Kişisel · Kurum';

  @override
  String get homeJoinEnterprise => 'Kuruma katıl';

  @override
  String get homeCreateGroup => 'Yeni grup';

  @override
  String get homeAddFriend => 'Kişi ekle';

  @override
  String get homeScan => 'Tara';

  @override
  String get homeJoinNewSpace => 'Yeni alana katıl';

  @override
  String get homeSearchConversation => 'Ara';

  @override
  String get homeNoMessages => 'Mesaj yok';

  @override
  String get homeDeleteConversation => 'Sohbeti sil';

  @override
  String get homeDeleteConversationConfirm =>
      'Bu sohbet silinsin mi? Sohbet geçmişi temizlenecek.';

  @override
  String get homePersonalNote => 'Ben (Kişisel notlar)';

  @override
  String get homeWorkNote => 'Ben (İş notları)';

  @override
  String homeConversationCount(int count) {
    return '$count sohbet';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count okunmamış';
  }

  @override
  String get chatInputHint => 'Bir mesaj yazın...';

  @override
  String get chatVoiceHint => 'Konuşmak için basılı tutun';

  @override
  String get chatVoiceRelease => 'Göndermek için bırakın';

  @override
  String get chatVoiceCancel => 'İptal etmek için yukarı kaydırın';

  @override
  String get chatMenuCopy => 'Kopyala';

  @override
  String get chatMenuForward => 'İlet';

  @override
  String get chatMenuRecall => 'Geri al';

  @override
  String get chatMenuDelete => 'Sil';

  @override
  String get chatMenuFavorite => 'Kaydet';

  @override
  String get chatMenuReply => 'Yanıtla';

  @override
  String get chatMenuMultiSelect => 'Seç';

  @override
  String get chatMenuTranslate => 'Çevir';

  @override
  String get chatMenuVoiceToText => 'Metne dönüştür';

  @override
  String get chatMenuTextToSpeech => 'Sesli oku';

  @override
  String get chatStatusRecalled => 'Mesaj geri alındı';

  @override
  String get chatRecallSuccess => 'Geri alındı';

  @override
  String get chatRecallFailed => 'Geri alınamadı';

  @override
  String get chatRecallTimeout => '2 dakikadan eski mesajlar geri alınamaz';

  @override
  String get chatTranslateFailed => 'Çeviri başarısız, tekrar deneyin';

  @override
  String get chatTranslateNotConfigured => 'Çeviri hizmeti kullanılamıyor';

  @override
  String get chatVoiceToTextFailed => 'Dönüştürme başarısız, tekrar deneyin';

  @override
  String get chatTextToSpeechFailed => 'Sesli okunamadı, tekrar deneyin';

  @override
  String get chatVoiceToText => 'Dönüştür';

  @override
  String get chatForwardSuccess => 'İletildi';

  @override
  String get chatForwardFailed => 'İletilemedi, tekrar deneyin';

  @override
  String get chatNoConversations => 'İletilecek sohbet yok';

  @override
  String get chatSendFailed => 'Gönderilemedi';

  @override
  String get chatResend => 'Yeniden gönder';

  @override
  String get chatNotFriend => 'Kişi listesinde değil';

  @override
  String get chatNotFriendHint =>
      'Henüz kişi listenizde değilsiniz. Mesaj gönderilemiyor.';

  @override
  String get chatMutedHint => 'Tüm üyeler susturuldu';

  @override
  String get chatFileUploadFailed => 'Dosya yüklenemedi, tekrar deneyin';

  @override
  String get chatFileStatusNotDownloaded => 'İndirilmedi';

  @override
  String get chatFileStatusDownloaded => 'İndirildi';

  @override
  String get chatFileStatusUploading => 'Yükleniyor';

  @override
  String get chatFileStatusUploadFailed => 'Yükleme Başarısız';

  @override
  String get chatCardSendFailed => 'Kişi kartı gönderilemedi';

  @override
  String get chatFavoriteSuccess => 'Kaydedildi';

  @override
  String get chatFavoriteFailed => 'Favorilere eklenemedi';

  @override
  String get chatLoadFailed => 'Yükleme başarısız oldu';

  @override
  String get chatImageMessage => '[Görsel]';

  @override
  String get chatVoiceMessage => '[Ses]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Dosya]';

  @override
  String get chatLocationMessage => '[Konum]';

  @override
  String get chatContactCardMessage => '[Kişi]';

  @override
  String get chatCallLogMessage => '[Arama]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return '$count kişi okudu';
  }

  @override
  String get chatUnread => 'Okunmadı';

  @override
  String get chatRecalledSelf => 'Bir mesajı geri aldınız';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender bir mesajı geri aldı';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Çeviri: $translation';
  }

  @override
  String get chatMessageDeleted => 'Mesaj silindi';

  @override
  String get chatPeer => 'Diğer';

  @override
  String get chatSelf => 'Ben';

  @override
  String get chatGenericMessage => '[Mesaj]';

  @override
  String get chatVoiceHideText => 'Metni gizle';

  @override
  String get chatVoiceShowText => 'Metne dönüştür';

  @override
  String get chatFileDefaultName => 'Dosya';

  @override
  String get chatContactDefaultName => 'Kişi';

  @override
  String get chatContactCardTitle => 'Kişi kartı';

  @override
  String get chatCallMissed => 'Cevapsız';

  @override
  String get chatCallCancelled => 'İptal edildi';

  @override
  String get chatCallRejected => 'Reddedildi';

  @override
  String get chatCallDisconnected => 'Bağlantı kesildi';

  @override
  String get chatCallEnded => 'Arama sona erdi';

  @override
  String get chatCallFailed => 'Arama başarısız';

  @override
  String chatCallDuration(String duration) {
    return 'Süre $duration';
  }

  @override
  String get chatVideoCallTitle => 'Görüntülü arama';

  @override
  String get chatVoiceCallTitle => 'Sesli arama';

  @override
  String get chatToolPhotos => 'Fotoğraflar';

  @override
  String get chatToolCamera => 'Kamera';

  @override
  String get chatToolFile => 'Dosya';

  @override
  String get chatToolLocation => 'Konum';

  @override
  String get chatToolContactCard => 'Kişi';

  @override
  String get chatToolVoiceCall => 'Sesli arama';

  @override
  String get chatToolVideoCall => 'Görüntülü arama';

  @override
  String get chatToolFavorites => 'Favoriler';

  @override
  String get chatToolTranslate => 'Çevir';

  @override
  String get chatTranslationChooseLanguage => 'Çeviri dili seçin';

  @override
  String get chatTranslationEnterText => 'Önce metin girin';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Bahsetme içeren mesajlar çevrilemiyor';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Zamanlanmış mesaj düzenlenirken çeviri kullanılamaz';

  @override
  String get chatTranslationFailed => 'Çeviri başarısız. Tekrar deneyin';

  @override
  String get chatTranslationEmpty => 'Çeviri dönmedi. Tekrar deneyin';

  @override
  String get chatTranslationTranslating => 'Çevriliyor…';

  @override
  String get chatTranslationSend => 'Çeviriyi gönder';

  @override
  String get chatTranslationSending => 'Gönderiliyor…';

  @override
  String get chatTranslationExpand => 'Daha fazla göster';

  @override
  String get chatTranslationCollapse => 'Daha az göster';

  @override
  String get chatFileTooLarge => 'Dosya sınırı aşıyor (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Yalnızca sahip veya seçili üyeler mesaj gönderebilir.';

  @override
  String get chatImageUploadUnsupported =>
      'Görsel yüklenemedi. Sunucu desteği henüz yok.';

  @override
  String get chatFavoriteLongPressHint =>
      'Favorilere eklemek için mesaja basılı tutun';

  @override
  String chatSelectedCount(int count) {
    return '$count seçildi';
  }

  @override
  String get chatLocationSheetTitle => 'Konum gönder';

  @override
  String get chatLocationNameLabel => 'Yer adı';

  @override
  String get chatLocationNameHint => 'ör. Ofis, müşteri adresi';

  @override
  String get chatLocationAddressLabel => 'Adres';

  @override
  String get chatLocationOptionalHint => 'İsteğe bağlı';

  @override
  String get chatLocationLatitudeLabel => 'Enlem';

  @override
  String get chatLocationLatitudeHint => '-90 ile 90';

  @override
  String get chatLocationLongitudeLabel => 'Boylam';

  @override
  String get chatLocationLongitudeHint => '-180 ile 180';

  @override
  String chatLocationValidationRequired(String label) {
    return '$label girin';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label aralık dışında';
  }

  @override
  String get chatLocationDefaultTitle => 'Konum';

  @override
  String get chatMutedFullNotice =>
      'Bu grup susturuldu. Yalnızca sahip veya seçili üyeler mesaj gönderebilir.';

  @override
  String get chatNotFriendSendBlocked =>
      'Artık arkadaş değilsiniz ve mesaj gönderemezsiniz';

  @override
  String get chatPersonalNotesTitle => 'Kişisel notlar';

  @override
  String get chatWorkNotesTitle => 'İş notları';

  @override
  String get chatPersonalNotesDescription =>
      'Kişisel düşüncelerinizi yazın ve önemli bilgileri burada saklayın\nHer zaman erişmek için cihazlar arasında eşitlenir';

  @override
  String get chatWorkNotesDescription =>
      'İş görevlerinizi yazın ve iş materyallerini burada saklayın\nEkip alanları ayrı ve güvende kalır';

  @override
  String get chatNoMessages => 'Mesaj yok';

  @override
  String chatReplyTo(String sender) {
    return '$sender kişisine yanıtla';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature yakında';
  }

  @override
  String get chatForwardSelectTitle => 'Sohbet seçin';

  @override
  String get chatContactSelectTitle => 'Kişi seçin';

  @override
  String get chatNoContacts => 'Kişi yok';

  @override
  String get contactsTitle => 'Kişiler';

  @override
  String get contactsSearch => 'Kişilerde ara';

  @override
  String get contactsNewFriends => 'Yeni arkadaşlar';

  @override
  String get contactsGroups => 'Gruplar';

  @override
  String get contactsFavorites => 'Favoriler';

  @override
  String get contactsRecent => 'Son kullanılanlar';

  @override
  String get contactsOrganization => 'Kuruluş';

  @override
  String get contactsAnnouncement => 'Duyurular';

  @override
  String get contactsNewApplications => 'Yeni başvurular';

  @override
  String get contactsCustomerGroups => 'Müşteri grupları';

  @override
  String get contactsAllCustomers => 'Tüm müşteriler';

  @override
  String get contactsMyCustomers => 'Müşterilerim';

  @override
  String get contactsViewAll => 'Tümünü gör';

  @override
  String get contactsMyContacts => 'Kişilerim';

  @override
  String get contactsMyAdvisor => 'Danışmanım';

  @override
  String get contactsNoAdvisor => 'Henüz danışman atanmadı';

  @override
  String get contactsAdvisorLoading => 'Yükleniyor...';

  @override
  String get contactsNavigateFailed => 'Sayfa açılamadı, tekrar deneyin';

  @override
  String get contactsEmpty => 'Kişi yok';

  @override
  String get contactsNoAnnouncement => 'Duyuru yok';

  @override
  String get contactsOfficialBadge => 'Resmî';

  @override
  String get contactsCustomerBadge => 'Müşteri';

  @override
  String get contactsEmptyCustomers => 'Müşteri yok';

  @override
  String get myTitle => 'Ben';

  @override
  String get myEnterpriseInfo => 'Kurum bilgileri';

  @override
  String get myEnterpriseManage => 'Kurum yönetimi';

  @override
  String get myQrCode => 'QR kodu';

  @override
  String get myFavorites => 'Favoriler';

  @override
  String get myLanguage => 'Dil';

  @override
  String get myTimezone => 'Saat dilimi';

  @override
  String get myAutoTranslate => 'Otomatik çeviri';

  @override
  String get myNetworkSwitch => 'Hattı değiştir';

  @override
  String get mySettings => 'Ayarlar';

  @override
  String get myLogout => 'Çıkış Yap';

  @override
  String get myLogoutConfirm => 'Çıkış yapmak istediğinizden emin misiniz?';

  @override
  String get myLeaveEnterprise => 'Kurumdan ayrıl';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Bu kurumdan ayrılmak istediğinizden emin misiniz? Kurum verilerine erişiminizi kaybedeceksiniz.';

  @override
  String get myLeaveEnterpriseSuccess => 'Kurumdan ayrıldınız';

  @override
  String get myLeaveEnterpriseFailed => 'Ayrılınamadı, tekrar deneyin';

  @override
  String get myLppIdCopied => 'StartLink kimliği kopyalandı';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink kimliği: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count kişi';
  }

  @override
  String get myAutoSelect => 'Otomatik';

  @override
  String get myPresenceStatus => 'Çevrim içi durumu';

  @override
  String get myPresenceStatusTitle => 'Durum belirle';

  @override
  String get myPresenceOnline => 'Çevrim içi';

  @override
  String get myPresenceBusy => 'Meşgul';

  @override
  String get myPresenceAway => 'Uzakta';

  @override
  String get myPresenceInvisible => 'Görünmez';

  @override
  String get profileTitle => 'Profilim';

  @override
  String get profileName => 'Ad';

  @override
  String get profileGender => 'Cinsiyet';

  @override
  String get profileBirthday => 'Doğum günü';

  @override
  String get profileRegion => 'Bölge';

  @override
  String get profileSignature => 'Biyografi';

  @override
  String get profileSignatureHint => 'Kendinizden bahsedin';

  @override
  String get profileTapTapText => 'Dürtme';

  @override
  String get profileTapTapHint =>
      'Dürtülünce gösterilen metin (en fazla 20 karakter)';

  @override
  String get profileAccountSection => 'Hesap';

  @override
  String get profileBasicSection => 'Temel bilgiler';

  @override
  String get profileLppId => 'StartLink kimliği';

  @override
  String get profileLppIdNotSet => 'Ayarlanmadı';

  @override
  String get profileMobile => 'Telefon';

  @override
  String get profileMobileUnbound => 'Bağlı Değil';

  @override
  String get profileEmail => 'E-posta';

  @override
  String get profileEmailUnbound => 'Bağlı Değil';

  @override
  String get profileQrCode => 'QR kodum';

  @override
  String get profileChangePassword => 'Şifreyi Değiştir';

  @override
  String get profileGenderMale => 'Erkek';

  @override
  String get profileGenderFemale => 'Kadın';

  @override
  String get profileGenderOther => 'Diğer';

  @override
  String get profileGenderUnset => 'Ayarlanmadı';

  @override
  String get profileSaveFailed => 'Kaydedilemedi, tekrar deneyin';

  @override
  String get profileLppIdTitle => 'StartLink kimliği';

  @override
  String get profileLppIdSetOnce =>
      'StartLink kimliği yalnızca bir kez değiştirilebilir. Dikkatli seçin.';

  @override
  String get profileLppIdChangeFailed =>
      'Değiştirilemedi (StartLink kimliği yalnızca bir kez değiştirilebilir)';

  @override
  String get profileChangePasswordOld => 'Mevcut parola';

  @override
  String get profileChangePasswordNew => 'Yeni Şifre';

  @override
  String get profileChangePasswordConfirm => 'Yeni Şifre Tekrar';

  @override
  String get profileChangePasswordMismatch => 'Parolalar eşleşmiyor';

  @override
  String get profileChangePasswordSuccess =>
      'Parola değiştirildi. Yeniden giriş yapın.';

  @override
  String get profileChangePasswordFailed =>
      'Parola değiştirilemedi, tekrar deneyin';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsSectionEnterprise => 'Kurum';

  @override
  String get settingsSectionAccount => 'Hesap';

  @override
  String get settingsSectionGeneral => 'Genel';

  @override
  String get settingsSectionFeatures => 'Özellikler';

  @override
  String get settingsSectionAbout => 'Hakkında';

  @override
  String get settingsEnterpriseInfo => 'Kurum bilgileri';

  @override
  String get settingsProfile => 'Profilim';

  @override
  String get settingsAccountSecurity => 'Hesap güvenliği';

  @override
  String get settingsNotification => 'Bildirimler';

  @override
  String get settingsDisplay => 'Görünüm';

  @override
  String get settingsFriendPrivacy => 'Gizlilik';

  @override
  String get settingsChat => 'Sohbet';

  @override
  String get settingsChatHistory => 'Sohbet geçmişi';

  @override
  String get settingsAbout => 'StartLink hakkında';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsTimezone => 'Saat dilimi';

  @override
  String get settingsAutoTranslate => 'Otomatik çeviri';

  @override
  String get settingsNetworkSwitch => 'Hattı değiştir';

  @override
  String get enterpriseInfoTitle => 'Kurum bilgileri';

  @override
  String get enterpriseName => 'Ad';

  @override
  String get enterpriseDescription => 'Açıklama';

  @override
  String get enterpriseUpdateSuccess => 'Başarıyla Güncellendi';

  @override
  String get enterpriseUpdateFailed => 'Güncelleme başarısız, tekrar deneyin';

  @override
  String get enterpriseLeave => 'Kurumdan ayrıl';

  @override
  String get enterpriseLeaveConfirm =>
      'Bu kurumdan ayrılmak istediğinizden emin misiniz?';

  @override
  String get enterpriseLeaveSuccess => 'Kurumdan ayrıldınız';

  @override
  String get enterpriseLeaveFailed => 'Ayrılınamadı, tekrar deneyin';

  @override
  String get enterpriseLeaveOwnerError =>
      'Sahip doğrudan ayrılamaz. Önce sahipliği devredin.';

  @override
  String get enterpriseMemberCount => 'Üyeler';

  @override
  String get enterpriseCreatedAt => 'Oluşturulma';

  @override
  String get enterpriseCode => 'Kurum kodu';

  @override
  String get enterpriseInviteMembers => 'Üye davet et';

  @override
  String get enterpriseCopyInviteCode => 'Davet kodunu kopyala';

  @override
  String get enterpriseInviteCodeCopied => 'Davet kodu kopyalandı';

  @override
  String get groupCreateTitle => 'Yeni grup';

  @override
  String get groupNameHint => 'Grup adını girin';

  @override
  String get groupCreateSuccess => 'Grup oluşturuldu';

  @override
  String get groupCreateFailed => 'Grup oluşturulamadı';

  @override
  String get groupSettings => 'Grup ayarları';

  @override
  String get groupName => 'Grup adı';

  @override
  String get groupAvatar => 'Grup avatarı';

  @override
  String get groupAnnouncement => 'Duyuru';

  @override
  String get groupMembers => 'Üyeler';

  @override
  String get groupAddMember => 'Üye ekle';

  @override
  String get groupRemoveMember => 'Üyeyi çıkar';

  @override
  String get groupRemoveMemberConfirm => 'Bu üye çıkarılsın mı?';

  @override
  String get groupSetAdmin => 'Yönetici yap';

  @override
  String get groupRemoveAdmin => 'Yöneticilikten çıkar';

  @override
  String get groupTransferOwner => 'Sahipliği devret';

  @override
  String get groupTransferOwnerConfirm =>
      'Grup sahipliği bu üyeye devredilsin mi?';

  @override
  String get groupTransferOwnerSuccess => 'Sahiplik devredildi';

  @override
  String get groupTransferOwnerFailed => 'Devir başarısız, tekrar deneyin';

  @override
  String get groupLeave => 'Gruptan ayrıl';

  @override
  String get groupLeaveConfirm => 'Bu gruptan ayrılınsın mı?';

  @override
  String get groupLeaveSuccess => 'Gruptan ayrıldınız';

  @override
  String get groupLeaveFailed => 'Ayrılınamadı, tekrar deneyin';

  @override
  String get groupDissolve => 'Grubu dağıt';

  @override
  String get groupDissolveConfirm =>
      'Bu grup dağıtılsın mı? Tüm üyeler çıkarılacak.';

  @override
  String get groupDissolveSuccess => 'Grup dağıtıldı';

  @override
  String get groupDissolveFailed => 'Dağıtılamadı, tekrar deneyin';

  @override
  String get groupQrCode => 'Grup QR kodu';

  @override
  String get groupMuteAll => 'Tümünü sustur';

  @override
  String get groupMuteAllOn => 'Tümünü susturmayı aç';

  @override
  String get groupMuteAllOff => 'Tümünü susturmayı kapat';

  @override
  String get groupAllowMemberInvite => 'Üyelerin davet etmesine izin ver';

  @override
  String get groupAllowMemberModifyTitle =>
      'Üyelerin grup adını değiştirmesine izin ver';

  @override
  String get groupAllowMemberAtAll =>
      'Üyelerin @Herkes etiketini kullanmasına izin ver';

  @override
  String get groupAllowMemberViewMemberList =>
      'Üyelerin üye listesini görmesine izin ver';

  @override
  String get groupAllowQrCodeJoin => 'QR koduyla katılmaya izin ver';

  @override
  String get groupRequireApproval => 'Katılım için onay iste';

  @override
  String get groupAllowMemberAddFriend =>
      'Üyelerin birbirini eklemesine izin ver';

  @override
  String get groupRoleOwner => 'Sahip';

  @override
  String get groupRoleAdmin => 'Yönetici';

  @override
  String get groupRoleMember => 'Üye';

  @override
  String get groupNoMembers => 'Üye yok';

  @override
  String get groupNoAnnouncements => 'Duyuru yok';

  @override
  String get groupCreateAnnouncement => 'Duyuru yayımla';

  @override
  String get groupEditAnnouncement => 'Duyuruyu düzenle';

  @override
  String get groupDeleteAnnouncement => 'Duyuruyu sil';

  @override
  String get groupDeleteAnnouncementConfirm => 'Bu duyuru silinsin mi?';

  @override
  String get groupAnnouncementTitle => 'Başlık';

  @override
  String get groupAnnouncementContent => 'İçerik';

  @override
  String get groupAnnouncementPin => 'Duyuruyu sabitle';

  @override
  String groupMemberCount(int count) {
    return '$count üye';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count seçildi';
  }

  @override
  String get groupJoinRequestApprove => 'Kabul Ediyorum';

  @override
  String get groupJoinRequestReject => 'Reddet';

  @override
  String get groupJoinRequests => 'Katılma talepleri';

  @override
  String get groupNoJoinRequests => 'Katılma talebi yok';

  @override
  String get groupReadReceipts => 'Okundu bilgisi';

  @override
  String groupReadCount(int count) {
    return '$count okudu';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count okunmamış';
  }

  @override
  String get friendAddTitle => 'Kişi ekle';

  @override
  String get friendSearchHint => 'Telefon / E-posta / StartLink kimliği';

  @override
  String get friendRequestSent => 'Arkadaşlık isteği gönderildi';

  @override
  String get friendRequestFailed => 'Gönderilemedi, tekrar deneyin';

  @override
  String get friendAlreadyFriend => 'Zaten kişi listenizde';

  @override
  String get friendNewFriendsTitle => 'Yeni arkadaşlar';

  @override
  String get friendNoRequests => 'Arkadaşlık isteği yok';

  @override
  String get friendAccept => 'Kabul et';

  @override
  String get friendReject => 'Reddet';

  @override
  String get friendAccepted => 'Kabul edildi';

  @override
  String get friendRejected => 'Reddedildi';

  @override
  String get friendDeleteConfirm => 'Bu kişi kaldırılsın mı?';

  @override
  String get friendDeleteSuccess => 'Kişi kaldırıldı';

  @override
  String get friendDeleteFailed => 'Kaldırılamadı, tekrar deneyin';

  @override
  String get friendRemarkName => 'Takma ad';

  @override
  String get friendGroupName => 'Grup';

  @override
  String get friendSendMessage => 'Mesaj';

  @override
  String get friendMatchTypeLppId => 'StartLink kimliğiyle eşleşti';

  @override
  String get friendMatchTypeMobile => 'Telefonla eşleşti';

  @override
  String get friendMatchTypeEmail => 'E-postayla eşleşti';

  @override
  String get friendSearchEmpty => 'Kullanıcı bulunamadı';

  @override
  String get friendAddMessage => 'Sizi kişilerime eklemek istiyorum';

  @override
  String get friendBlockConfirm => 'Bu kullanıcı engellensin mi?';

  @override
  String get friendUnblockConfirm => 'Bu kullanıcının engeli kaldırılsın mı?';

  @override
  String get friendBlockSuccess => 'Engellendi';

  @override
  String get friendUnblockSuccess => 'Engel kaldırıldı';

  @override
  String get profilePageTitle => 'Kişisel Bilgiler';

  @override
  String get profilePageSendMessage => 'Mesaj';

  @override
  String get profilePageAddFriend => 'Arkadaş ekle';

  @override
  String get profilePageAlreadyFriend => 'Zaten arkadaşsınız';

  @override
  String get profilePageBlocked => 'Engellendi';

  @override
  String get profilePageBlock => 'Engelle';

  @override
  String get profilePageUnblock => 'Engeli kaldır';

  @override
  String get profilePageHidden => 'Bu kullanıcı profilini gizledi';

  @override
  String get profilePageFriendsOnly =>
      'Bu kullanıcı profilini yalnızca arkadaşlarına gösteriyor';

  @override
  String get profilePageLppId => 'StartLink kimliği';

  @override
  String get profilePageRemarkName => 'Açıklama';

  @override
  String get profilePageEditRemark => 'Takma adı düzenle';

  @override
  String get profilePageSaveRemarkSuccess => 'Takma ad kaydedildi';

  @override
  String get profilePageSaveRemarkFailed => 'Kaydedilemedi, tekrar deneyin';

  @override
  String get searchTitle => 'Ara';

  @override
  String get searchHint => 'Telefon, e-posta veya StartLink kimliğiyle ara';

  @override
  String get searchNoResults => 'Sonuç bulunamadı';

  @override
  String get searchMessages => 'Mesajlar';

  @override
  String get searchUsers => 'Kullanıcılar';

  @override
  String get searchFailed => 'Arama başarısız, tekrar deneyin';

  @override
  String get scanTitle => 'Tara';

  @override
  String get scanFailed => 'Tanıma başarısız, tekrar deneyin';

  @override
  String get scanInvalidQrCode => 'Geçersiz QR kodu';

  @override
  String get scanFlashOn => 'Feneri aç';

  @override
  String get scanFlashOff => 'Feneri kapat';

  @override
  String get scanAlbum => 'Albümden Seç';

  @override
  String get favoritesTitle => 'Favoriler';

  @override
  String get favoritesEmpty => 'Henüz kaydedilmiş öğe yok.';

  @override
  String get favoritesAll => 'Tümü';

  @override
  String get favoritesText => 'Metin';

  @override
  String get favoritesImage => 'Görseller';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Ses';

  @override
  String get favoritesFile => 'Dosyalar';

  @override
  String get favoritesOther => 'Diğer';

  @override
  String get favoritesDeleteConfirm => 'Favorilerden kaldırılsın mı?';

  @override
  String get favoritesDeleteSuccess => 'Kaydedilenlerden kaldırıldı';

  @override
  String get favoritesDeleteFailed => 'Kaldırılamadı';

  @override
  String get favoritesOriginalRecalled => 'Mesaj geri alındı';

  @override
  String get favoritesViewOriginal => 'Aslını gör';

  @override
  String get favoritesSearchHint => 'Favorilerde ara';

  @override
  String get favoritesNoResults => 'Eşleşen favori yok';

  @override
  String get noticeTitle => 'Duyurular';

  @override
  String get noticeEmpty => 'Duyuru yok';

  @override
  String get noticeDetail => 'Duyuru ayrıntıları';

  @override
  String get noticePublishedAt => 'Yayımlandı';

  @override
  String get noticePriorityNormal => 'Normal';

  @override
  String get noticePriorityImportant => 'Önemli';

  @override
  String get noticePriorityUrgent => 'Acil';

  @override
  String get organizationTitle => 'Kuruluş';

  @override
  String get organizationEmpty => 'Bölüm bilgisi yok';

  @override
  String get organizationMembers => 'Üyeler';

  @override
  String get organizationDepartment => 'Bölüm';

  @override
  String get organizationPosition => 'Pozisyon';

  @override
  String get organizationLeader => 'Lider';

  @override
  String get qrCodeTitle => 'QR kodum';

  @override
  String get qrCodeSave => 'Albüme Kaydet';

  @override
  String get qrCodeShare => 'Paylaş';

  @override
  String get qrCodeSaveSuccess => 'Albüme kaydedildi';

  @override
  String get qrCodeSaveFailed => 'Kaydedilemedi, tekrar deneyin';

  @override
  String get qrCodeRefresh => 'QR kodunu yenile';

  @override
  String get qrCodeExpired => 'QR kodunun süresi doldu, yenileyin';

  @override
  String get qrCodeScanToAdd => 'Beni kişilerinize eklemek için tarayın';

  @override
  String get spacePersonal => 'Kişisel';

  @override
  String get spaceEnterprise => 'Kurum';

  @override
  String get spaceJoinByCode => 'Kurum koduyla katıl';

  @override
  String get spaceJoinByInvite => 'Davet koduyla katıl';

  @override
  String get spaceEnterCode => 'Kurum kodunu girin';

  @override
  String get spaceEnterInviteCode => 'Davet kodunu girin';

  @override
  String get spaceSearchEnterprise => 'Kurum ara';

  @override
  String get spaceJoinRequestSent => 'Talep gönderildi, onay bekleniyor';

  @override
  String get spaceJoinRequestPending => 'Onay bekleniyor';

  @override
  String get spaceJoinRequestApproved => 'Talep onaylandı';

  @override
  String get spaceJoinRequestRejected => 'Talep reddedildi';

  @override
  String get spaceAlreadyMember => 'Zaten üyesiniz';

  @override
  String get spaceAutoApproved => 'Otomatik onaylandı. Hoş geldiniz!';

  @override
  String get spacePendingApprovalHint =>
      'Kayıt başarılı. Katılma talebiniz gönderildi.';

  @override
  String get spaceNoSpaces => 'Alan yok';

  @override
  String get spaceInviteExpired => 'Davet kodunun süresi doldu';

  @override
  String get spaceInviteTargetMismatch => 'Bu davet kodu hesabınız için değil';

  @override
  String get spaceAcceptInviteSuccess => 'Kuruma başarıyla katıldınız';

  @override
  String get spaceAcceptInviteFailed => 'Katılınamadı, tekrar deneyin';

  @override
  String get spaceTenantSelectTitle => 'Alan seçin';

  @override
  String get spaceTenantSelectHint => 'Girmek istediğiniz alanı seçin';

  @override
  String get spaceEnterPersonal => 'Kişisel alana gir';

  @override
  String get spaceEnterEnterprise => 'Kurum alanına gir';

  @override
  String get aboutTitle => 'StartLink hakkında';

  @override
  String get aboutVersion => 'Sürüm';

  @override
  String get aboutTerms => 'Kullanıcı Sözleşmesi';

  @override
  String get aboutPrivacy => 'Gizlilik Politikası';

  @override
  String get aboutOpenSource => 'Açık kaynak lisansları';

  @override
  String get aboutCheckUpdate => 'Güncellemeleri kontrol et';

  @override
  String get aboutLatestVersion => 'En son sürümü kullanıyorsunuz.';

  @override
  String get aboutUpdateAvailable => 'Yeni sürüm mevcut';

  @override
  String get aboutUpdateNow => 'Şimdi Güncelle';

  @override
  String get aboutUpdateLater => 'Daha sonra';

  @override
  String get notificationTitle => 'Bildirimler';

  @override
  String get notificationGlobalMute => 'Rahatsız etmeyin';

  @override
  String get notificationSound => 'Ses';

  @override
  String get notificationVibration => 'Titreşim';

  @override
  String get notificationPreview => 'Mesaj önizlemesi';

  @override
  String get notificationDndStart => 'Rahatsız etmeyin başlangıcı';

  @override
  String get notificationDndEnd => 'Rahatsız etmeyin bitişi';

  @override
  String get blacklistTitle => 'Kara Listede';

  @override
  String get blacklistEmpty => 'Engellenen kullanıcı yok';

  @override
  String get blacklistRemove => 'Engeli kaldır';

  @override
  String get blacklistRemoveConfirm => 'Bu kullanıcının engeli kaldırılsın mı?';

  @override
  String get feedbackTitle => 'Geri bildirim';

  @override
  String get feedbackTypeComplaint => 'Şikâyet';

  @override
  String get feedbackTypeSuggestion => 'Öneri';

  @override
  String get feedbackTypeBug => 'Hata bildirimi';

  @override
  String get feedbackContent => 'Açıklama';

  @override
  String get feedbackContentHint =>
      'Sorununuzu veya önerinizi ayrıntılı açıklayın';

  @override
  String get feedbackContact => 'İletişim (isteğe bağlı)';

  @override
  String get feedbackSubmit => 'Gönder';

  @override
  String get feedbackSuccess => 'Geri bildirim gönderildi. Teşekkürler!';

  @override
  String get feedbackFailed => 'Gönderim başarısız, tekrar deneyin';

  @override
  String get networkTitle => 'Hattı değiştir';

  @override
  String get networkAutoSelect => 'Otomatik';

  @override
  String get networkManual => 'Manuel';

  @override
  String get timezoneTitle => 'Saat dilimi';

  @override
  String get timezoneAuto => 'Sistemi izle';

  @override
  String get autoTranslateTitle => 'Otomatik çeviri';

  @override
  String get autoTranslateEnabled => 'Otomatik çeviriyi aç';

  @override
  String get autoTranslateLanguage => 'Hedef dil';

  @override
  String get displayTitle => 'Görünüm';

  @override
  String get displayFontSize => 'Yazı Boyutu';

  @override
  String get displayChatBackground => 'Sohbet arka planı';

  @override
  String get displayDarkMode => 'Görünüm';

  @override
  String get displayDarkModeSystem => 'Sistemi izle';

  @override
  String get displayDarkModeSystemHint =>
      'Sistem ayarına göre otomatik geçiş yap';

  @override
  String get displayDarkModeOff => 'Açık';

  @override
  String get displayDarkModeOffHint => 'Her zaman açık tema kullan';

  @override
  String get displayDarkModeOn => 'Koyu';

  @override
  String get displayDarkModeOnHint => 'Her zaman koyu tema kullan';

  @override
  String get chatSettingsTitle => 'Sohbet';

  @override
  String get chatHistoryTitle => 'Sohbet geçmişi';

  @override
  String get chatHistoryClear => 'Tüm geçmişi temizle';

  @override
  String get chatHistoryClearConfirm =>
      'Tüm sohbet geçmişi temizlensin mi? Bu işlem geri alınamaz.';

  @override
  String get chatHistoryClearSuccess => 'Sohbet geçmişi temizlendi';

  @override
  String get accountSecurityTitle => 'Hesap güvenliği';

  @override
  String get accountSecurityChangePassword => 'Şifreyi Değiştir';

  @override
  String get accountSecurityChangeMobile => 'Telefon Numarasını Değiştir';

  @override
  String get accountSecurityChangeEmail => 'E-postayı değiştir';

  @override
  String get accountSecurityLoggedDevices => 'Giriş yapılan cihazlar';

  @override
  String get accountSecurityDeactivate => 'Hesabı kapat';

  @override
  String get accountSecurityDeactivateConfirm =>
      '7 gün sonra tüm veriler kalıcı olarak silinecek. Hesap kapatılsın mı?';

  @override
  String get loggedDevicesTitle => 'Giriş yapılan cihazlar';

  @override
  String get loggedDevicesCurrent => 'Bu cihaz';

  @override
  String get loggedDevicesRevoke => 'Çıkış yap';

  @override
  String get loggedDevicesRevokeConfirm => 'Bu cihazdan çıkış yapılsın mı?';

  @override
  String get loggedDevicesRevokeSuccess => 'Cihazdan çıkış yapıldı';

  @override
  String get loggedDevicesRevokeFailed => 'Başarısız, tekrar deneyin';

  @override
  String get loggedDevicesLastActive => 'Son etkinlik';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Masaüstü';

  @override
  String get loggedDevicesTypeUnknown => 'Bilinmeyen cihaz';

  @override
  String get privacySettingsTitle => 'Gizlilik';

  @override
  String get privacySearchableByMobile =>
      'Telefon numarasıyla aranmaya izin ver';

  @override
  String get privacySearchableByLppId =>
      'StartLink kimliğiyle aranmaya izin ver';

  @override
  String get privacyAllowFriendRequest => 'Arkadaşlık isteklerine izin ver';

  @override
  String get privacyProfileVisibility => 'Profil görünürlüğü';

  @override
  String get privacyEveryone => 'Herkes';

  @override
  String get privacyFriendsOfFriends => 'Arkadaşların arkadaşları';

  @override
  String get privacyNobody => 'Hiç kimse';

  @override
  String get privacyFriendsOnly => 'Yalnızca arkadaşlar';

  @override
  String get privacySaveSuccess => 'Ayarlar kaydedildi';

  @override
  String get privacySaveFailed => 'Kaydedilemedi, tekrar deneyin';

  @override
  String get fontSizeTitle => 'Yazı Boyutu';

  @override
  String get fontSizeSmall => 'Küçük';

  @override
  String get fontSizeNormal => 'Standart';

  @override
  String get fontSizeLarge => 'Büyük';

  @override
  String get fontSizeExtraLarge => 'Ekstra Büyük';

  @override
  String get fontSizePreview => 'Önizle';

  @override
  String get chatBackgroundTitle => 'Sohbet arka planı';

  @override
  String get chatBackgroundDefault => 'Varsayılan';

  @override
  String get chatBackgroundCustom => 'Özel';

  @override
  String get chatBackgroundReset => 'Varsayılanları Geri Yükle';

  @override
  String get termsTitle => 'Kullanıcı Sözleşmesi';

  @override
  String get privacyPolicyTitle => 'Gizlilik Politikası';

  @override
  String get recentContactsTitle => 'Son kullanılanlar';

  @override
  String get recentContactsEmpty => 'Son kullanılan kişi yok';

  @override
  String get inviteFriendsTitle => 'Arkadaş davet et';

  @override
  String get inviteFriendsCopyLink => 'Davet bağlantısını kopyala';

  @override
  String get inviteFriendsLinkCopied => 'Davet bağlantısı kopyalandı';

  @override
  String get imageViewerTitle => 'Fotoğraf';

  @override
  String get imageViewerSave => 'Albüme Kaydet';

  @override
  String get imageViewerSaveSuccess => 'Albüme kaydedildi';

  @override
  String get imageViewerSaveFailed => 'Kaydedilemedi, tekrar deneyin';

  @override
  String get customerServiceTitle => 'Hizmet masası';

  @override
  String get customerServiceQueue => 'Sırada';

  @override
  String get customerServiceActive => 'Etkin';

  @override
  String get customerServiceClaim => 'Kabul et';

  @override
  String get customerServiceTakeover => 'Devral';

  @override
  String get customerServiceClose => 'Hizmeti bitir';

  @override
  String get customerServiceCloseConfirm => 'Bu hizmet oturumu bitirilsin mi?';

  @override
  String get customerServiceNoQueue => 'Sırada oturum yok';

  @override
  String get customerServiceNoActive => 'Etkin oturum yok';

  @override
  String get customerServiceVisitor => 'Ziyaretçi';

  @override
  String get customerServiceCustomer => 'Müşteri';

  @override
  String get customerServiceAssignedTo => 'Atanan';

  @override
  String get customerServiceTransferConversation => 'Sohbeti aktar';

  @override
  String get marketingToolbar => 'Pazarlama araçları';

  @override
  String get callIncoming => 'Gelen arama';

  @override
  String get callOutgoing => 'Giden arama';

  @override
  String get callAccept => 'Kabul et';

  @override
  String get callReject => 'Reddet';

  @override
  String get callHangup => 'Bitir';

  @override
  String get callMissed => 'Cevapsız arama';

  @override
  String get callDuration => 'Süre';

  @override
  String get callAudio => 'Sesli arama';

  @override
  String get callGeneric => 'Arama';

  @override
  String get callVideo => 'Görüntülü arama';

  @override
  String get callConnecting => 'Bağlanıyor...';

  @override
  String get callRinging => 'Çalıyor...';

  @override
  String get callEnded => 'Arama sona erdi';

  @override
  String get callFailed => 'Arama başarısız';

  @override
  String get callRejected => 'Arama reddedildi';

  @override
  String get callTimeout => 'Yanıt yok';

  @override
  String get callCancelled => 'İptal edildi';

  @override
  String get callUnknownPeer => 'Bilinmeyen';

  @override
  String get callVideoInvitation => 'Görüntülü arama daveti';

  @override
  String get callAudioInvitation => 'Sesli arama daveti';

  @override
  String get callAnswerAudio => 'Sesli yanıtla';

  @override
  String get callAnswerVideo => 'Görüntülü yanıtla';

  @override
  String get callViewProfile => 'Profili gör';

  @override
  String get callOpeningCamera => 'Kamera açılıyor...';

  @override
  String get callWaitingRemoteVideo => 'Karşı tarafın görüntüsü bekleniyor...';

  @override
  String get callCameraOff => 'Kamera kapalı';

  @override
  String get callCameraOn => 'Kamera açık';

  @override
  String get callMicrophoneOff => 'Mikrofon kapalı';

  @override
  String get callMicrophoneOn => 'Mikrofon açık';

  @override
  String get callSpeakerOff => 'Hoparlör kapalı';

  @override
  String get callSpeakerOn => 'Hoparlör açık';

  @override
  String get callVideoPermissionFailure =>
      'Görüntülü arama başlatılamadı. Kamera ve mikrofon izinlerini kontrol edip tekrar deneyin.';

  @override
  String get callAudioPermissionFailure =>
      'Sesli arama başlatılamadı. Mikrofon iznini kontrol edip tekrar deneyin.';

  @override
  String get callIncompleteIncoming =>
      'Gelen arama bilgileri eksik olduğu için arama yanıtlanamıyor.';

  @override
  String get callInProgress => 'Aramada';

  @override
  String get callCalling => 'Aranıyor...';

  @override
  String callEndedMedia(String media) {
    return '$media sona erdi';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media reddedildi';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media yanıtlanmadı';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media iptal edildi';
  }

  @override
  String get callConnectionLost => 'Arama bağlantısı kesildi';

  @override
  String get callAdminEnded => 'Arama yönetici tarafından sonlandırıldı';

  @override
  String callFailedMedia(String media) {
    return '$media başarısız';
  }

  @override
  String get callBusy => 'Karşı taraf meşgul';

  @override
  String callDurationValue(String duration) {
    return 'Arama süresi $duration';
  }

  @override
  String get callNotConnected => 'Bağlı değil';

  @override
  String get callDialed => 'Giden';

  @override
  String get callAnswered => 'Yanıtlandı';

  @override
  String get callRejectedByPeer => 'Karşı taraf reddetti';

  @override
  String get callRejectedBySelf => 'Reddedildi';

  @override
  String get callPeerDidNotAnswer => 'Karşı taraf yanıtlamadı';

  @override
  String get callMissedIncoming => 'Cevapsız gelen arama';

  @override
  String get callPeerCancelled => 'Karşı taraf iptal etti';

  @override
  String get notificationNewMessageTitle => 'Yeni StartLink mesajı';

  @override
  String get notificationOnlineServiceTitle => 'Yeni müşteri hizmetleri mesajı';

  @override
  String get notificationNewMessageBody => 'Yeni bir mesaj aldınız';

  @override
  String get notificationImagePreview => 'Bir görsel gönderdi';

  @override
  String get notificationVideoPreview => 'Bir video gönderdi';

  @override
  String get notificationVoicePreview => 'Bir sesli mesaj gönderdi';

  @override
  String get notificationFilePreview => 'Bir dosya gönderdi';

  @override
  String get notificationContactPreview => 'Bir kişi kartı gönderdi';

  @override
  String get notificationCallLogPreview => 'Bir arama kaydı gönderdi';

  @override
  String get notificationLocationPreview => 'Bir konum paylaştı';

  @override
  String get notificationLinkPreview => 'Bir bağlantı paylaştı';

  @override
  String notificationMentionMe(String body) {
    return 'Sizden bahsetti: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender sizden bahsetti: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Herkesten bahsetti: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender herkesten bahsetti: $body';
  }

  @override
  String get notificationSecurityTitle => 'Hesap güvenliği uyarısı';

  @override
  String get notificationSecurityBody =>
      'StartLink hesap güvenliği ayarlarınız değişti. Şimdi inceleyin.';

  @override
  String get notificationFriendAcceptedTitle =>
      'Arkadaşlık isteği kabul edildi';

  @override
  String get notificationFriendRejectedTitle => 'Arkadaşlık isteği reddedildi';

  @override
  String get notificationFriendAcceptedBody =>
      'Karşı taraf arkadaşlık isteğinizi kabul etti';

  @override
  String get notificationFriendRejectedBody =>
      'Karşı taraf arkadaşlık isteğinizi reddetti';

  @override
  String get notificationVideoCallTitle => 'Görüntülü arama daveti';

  @override
  String get notificationAudioCallTitle => 'Sesli arama daveti';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller sizi görüntülü aramaya davet etti';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller sizi sesli aramaya davet etti';
  }

  @override
  String get notificationMessageChannelName => 'Mesajlar';

  @override
  String get notificationMessageChannelDescription =>
      'Sohbet mesajları, arama kayıtları ve sistem uyarıları';

  @override
  String get notificationCallChannelName => 'Aramalar';

  @override
  String get notificationCallChannelDescription =>
      'Sesli ve görüntülü arama uyarıları';

  @override
  String get notificationSecurityChannelName => 'Hesap güvenliği';

  @override
  String get notificationSecurityChannelDescription =>
      'Giriş, parola ve cep telefonu numarası değişikliği uyarıları';

  @override
  String get notificationUnknownCaller => 'Bilinmeyen arayan';

  @override
  String get pendingJoinRequestsTitle => 'Yeni başvurular';

  @override
  String get pendingJoinRequestsEmpty => 'Başvuru yok';

  @override
  String get pendingJoinRequestApprove => 'Kabul Ediyorum';

  @override
  String get pendingJoinRequestReject => 'Reddet';

  @override
  String get pendingJoinRequestApproveSuccess => 'Onaylandı';

  @override
  String get pendingJoinRequestRejectSuccess => 'Reddedildi';

  @override
  String get pendingJoinRequestFailed => 'İşlem başarısız, tekrar deneyin';

  @override
  String get myCustomersTitle => 'Müşterilerim';

  @override
  String get myCustomersEmpty => 'Müşteri yok';

  @override
  String get groupListTitle => 'Gruplar';

  @override
  String get groupListEmpty => 'Grup yok';

  @override
  String get addFriendTitle => 'Kişi ekle';

  @override
  String get addFriendSearchHint => 'Telefon / E-posta / StartLink kimliği';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink kimliği: $lppId';
  }

  @override
  String get addFriendButton => 'Ekle';

  @override
  String get addFriendCannotAddSelf => 'Kendinizi ekleyemezsiniz';

  @override
  String get addFriendUnsupportedUser =>
      'Bu kullanıcı eklenemez. Doğrudan mesaj gönderebilirsiniz.';

  @override
  String get addFriendMessageHint => 'Mesaj girin';

  @override
  String get addFriendSendRequest => 'İstek gönder';

  @override
  String get joinCompanyTitle => 'Kuruma katıl';

  @override
  String get joinCompanyCodeHint => 'Kurum kodunu girin';

  @override
  String get joinCompanySearchHint => 'Kurum adı ara';

  @override
  String get joinCompanyApply => 'Katılmak için başvur';

  @override
  String get joinCompanyApplySuccess => 'Başvuru gönderildi';

  @override
  String get joinCompanyApplyFailed => 'Başvurulamadı, tekrar deneyin';

  @override
  String get joinCompanyAutoApproved => 'Otomatik onaylandı. Hoş geldiniz!';

  @override
  String get joinCompanyPending => 'Başvuru gönderildi, onay bekleniyor';

  @override
  String get joinCompanyInviteCodeHint => 'Davet kodunu girin';

  @override
  String get joinCompanyAcceptInvite => 'Daveti kabul et';

  @override
  String get joinCompanyNoResults => 'Kurum bulunamadı';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count üye';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Pasifik Saati';

  @override
  String get timezoneNameMountainTime => 'Dağ Saati';

  @override
  String get timezoneNameCentralTime => 'Merkez Saati';

  @override
  String get timezoneNameEasternTime => 'Doğu Saati';

  @override
  String get timezoneNameAtlanticTime => 'Atlantik Saati';

  @override
  String get timezoneNameBrasilia => 'Brasilia';

  @override
  String get timezoneNameAzores => 'Azor Adaları';

  @override
  String get timezoneNameLondonDublin => 'Londra/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Paris/Roma';

  @override
  String get timezoneNameCairoHelsinki => 'Kahire/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moskova/Riyad';

  @override
  String get timezoneNameTehran => 'Tahran';

  @override
  String get timezoneNameDubaiBaku => 'Dubai/Bakü';

  @override
  String get timezoneNameKabul => 'Kabil';

  @override
  String get timezoneNameKarachiTashkent => 'Karaçi/Taşkent';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Mumbai/Yeni Delhi';

  @override
  String get timezoneNameKathmandu => 'Katmandu';

  @override
  String get timezoneNameDhakaAlmaty => 'Dakka/Almatı';

  @override
  String get timezoneNameYangon => 'Yangon';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hanoi/Cakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Pekin/Şanghay/Hong Kong/Taipei';

  @override
  String get timezoneNameTokyoSeoul => 'Tokyo/Seul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sidney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Solomon Adaları';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute => 'En iyi rotayı akıllıca seç';

  @override
  String get networkTesting => 'Test ediliyor...';

  @override
  String get networkTestingShort => 'Test ediliyor';

  @override
  String networkLatencyMs(int ms) {
    return 'Gecikme $ms ms';
  }

  @override
  String get networkConnectionMode => 'Bağlantı modu';

  @override
  String get networkDirectMode => 'Doğrudan mod';

  @override
  String get networkProxyMode => 'Proxy modu';

  @override
  String get networkDirectModeDesc => 'Sunucuya doğrudan bağlan';

  @override
  String get networkProxyModeDesc => 'Proxy sunucusu üzerinden bağlan';

  @override
  String get networkDirectRoutes => 'Doğrudan rotalar';

  @override
  String get networkProxyRoutes => 'Proxy rotaları';

  @override
  String get networkTestAll => 'Tümünü test et';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Hong Kong düğümü';

  @override
  String get networkSingaporeNode => 'Singapur düğümü';

  @override
  String get networkJapanNode => 'Japonya düğümü';

  @override
  String get networkUnitedStatesNode => 'ABD düğümü';

  @override
  String get networkHint =>
      'İpuçları:\n• Doğrudan mod: daha hızlıdır ve yurt içi kullanıma uygundur\n• Proxy modu: sınır ötesi iletişimde daha kararlıdır\n• Tek bir rotanın gecikmesini ölçmek için yenile simgesine dokunun';

  @override
  String get teenModeTitle => 'Genç modu';

  @override
  String get teenModeStatusOn => 'Açık';

  @override
  String get teenModeStatusOff => 'Kapalı';

  @override
  String get teenModeStatusLoading => 'Yükleniyor';

  @override
  String get teenModeUnavailable =>
      'Genç modu durumu geçici olarak kullanılamıyor';

  @override
  String get teenModeInvalidResponse => 'Genç modu geçersiz yanıt döndürdü';

  @override
  String get teenModeEnableDescription =>
      'Platform kuralları kullanım süresini ve belirli özellikleri sınırlar.';

  @override
  String get teenModePasscode => 'Geçiş kodu';

  @override
  String get teenModeCurrentPasscode => 'Mevcut geçiş kodu';

  @override
  String get teenModeNewPasscode => 'Yeni geçiş kodu';

  @override
  String get teenModePasscodeHint => '4–6 hane girin';

  @override
  String get teenModeEnable => 'Genç modunu aç';

  @override
  String get teenModeDisable => 'Genç modunu kapat';

  @override
  String get teenModeChangePasscode => 'Geçiş kodunu değiştir';

  @override
  String get teenModeSource => 'Etkinleştiren';

  @override
  String get teenModeDailyUsage => 'Bugünkü kullanım';

  @override
  String get teenModeRemaining => 'Kalan süre';

  @override
  String get teenModeMinutesUnit => 'Dakika';

  @override
  String get teenModeUnlimited => 'Sınırsız';

  @override
  String get teenModeRequestExtension => 'Ek süre iste';

  @override
  String get teenModeExtensionSubmitted => 'Süre talebi veliye gönderildi';

  @override
  String get teenModeTimeLimitReached => 'Bugünkü kullanım sınırına ulaşıldı';

  @override
  String get teenModeCurfewActive => 'Şu anda kullanım kısıtlaması var';

  @override
  String get teenModeReliefHint =>
      'Geçmişi görebilir, resmî desteğe ulaşabilir ve sorun bildirebilirsiniz.';

  @override
  String get teenModeRestrictedNotice =>
      'Genç modu şu anda mesaj göndermeyi engelliyor';

  @override
  String get teenModeActionBlocked => 'Genç modu şu anda bu işlemi engelliyor';

  @override
  String get teenModeMyRequests => 'Taleplerim';

  @override
  String get guardianCenterTitle => 'Veli merkezi';

  @override
  String get guardianRelationships => 'Veli ilişkileri';

  @override
  String get guardianMinors => 'Gözettiğim çocuklar';

  @override
  String get guardianApprovals => 'Bekleyen onaylar';

  @override
  String get guardianBind => 'Eşleştirme kodunu girin';

  @override
  String get guardianCreateMinorCode => 'Çocuğum — kod oluştur';

  @override
  String get guardianCreateGuardianCode => 'Veliyim — kod oluştur';

  @override
  String get guardianRelation => 'İlişki';

  @override
  String get guardianPrimary => 'Birincil veli';

  @override
  String get guardianCode => '6 haneli eşleştirme kodu';

  @override
  String get guardianCodeHint => 'Karşı tarafın verdiği kodu girin';

  @override
  String get guardianCodeCreated =>
      'Kod oluşturuldu. Süresi dolmadan paylaşın.';

  @override
  String get guardianEmpty => 'Veli ilişkisi yok';

  @override
  String get guardianNoMinors => 'Gözetilen çocuk yok';

  @override
  String get guardianUnbind => 'İlişkiyi kaldır';

  @override
  String get guardianExtend => 'Çocuğa süre ekle';

  @override
  String get guardianPolicyTitle => 'Kullanım kuralları';

  @override
  String get guardianPolicyLocked => 'Platform tarafından kilitlendi';

  @override
  String get approvalEmpty => 'Talep yok';

  @override
  String get approvalApprove => 'Kabul Ediyorum';

  @override
  String get approvalReject => 'Reddet';

  @override
  String get approvalPending => 'Bekliyor';

  @override
  String get approvalApproved => 'Onaylandı';

  @override
  String get approvalRejected => 'Reddedildi';

  @override
  String get approvalExpired => 'Süresi Doldu';

  @override
  String get approvalCancelled => 'İptal edildi';

  @override
  String get approvalReplayFailed =>
      'Asıl işlem başarısız oldu. Lütfen yeniden deneyin.';

  @override
  String get requestCancelled => 'Talep iptal edildi';

  @override
  String get kycTitle => 'Kimlik Doğrulama';

  @override
  String get kycNotRequired => 'Kimlik doğrulaması gerekmiyor';

  @override
  String get kycVerified => 'Kimlik doğrulandı';

  @override
  String get kycDeclared => 'Kimlik bilgileri gönderildi';

  @override
  String get kycPending => 'İnceleniyor';

  @override
  String get kycRejected => 'İnceleme reddedildi';

  @override
  String get kycNone => 'Kimlik bilgisi gönderilmedi';

  @override
  String get kycRealName => 'Adı Soyadı';

  @override
  String get kycIdNumber => 'Kimlik Numarası';

  @override
  String get kycIdType => 'Belge türü';

  @override
  String get kycApplicability =>
      'Seçilen belge için gerçek bilgilerinizi girin. Kabul edilen türler listede gösterilir.';

  @override
  String get kycCamera => 'Fotoğraf Çek';

  @override
  String get kycGallery => 'Albümden Seç';

  @override
  String get kycPhotoLimit => 'Fotoğraf başına en fazla';

  @override
  String get kycSelectPhoto => 'Fotoğraf Seç';

  @override
  String get kycPhotoSelected => 'Seçildi';

  @override
  String get kycViewPhoto => 'Fotoğrafı görmek için dokunun';

  @override
  String get kycReplacePhoto => 'Başka fotoğraf seçin';

  @override
  String get kycDisclosure =>
      'Kimliğinizi incelemek için adınızı, belge numaranızı ve belge fotoğraflarınızı kullanırız. Bunlar olmadan başvuru gönderemezsiniz ve bazı kısıtlı özellikler kullanılamayabilir.';

  @override
  String get kycConsent =>
      'Bu kimlik bilgilerinin işlenmesine ayrıca izin veriyorum';

  @override
  String get kycConsentRequired => 'Göndermeden önce ayrıca onay verin';

  @override
  String get kycResubmitTitle => 'Kimlik bilgilerini yeniden gönder';

  @override
  String get kycResubmitWarning =>
      'Yeniden göndermek bekleyen başvurunuzun yerine geçecek. Devam edilsin mi?';

  @override
  String get kycSubmitting => 'Gönderiliyor';

  @override
  String get kycSubmitFailed => 'Gönderim başarısız. Tekrar deneyin.';

  @override
  String get kycSubmitUnavailable => 'Kimlik bilgileri şu anda gönderilemiyor';

  @override
  String get kycResubmitNotAllowed =>
      'Ret sonrası yeniden gönderim kullanılamıyor. Gerekirse desteğe başvurun.';

  @override
  String get kycDailyLimit =>
      'Bugünkü gönderim sınırına ulaştınız. Yarın deneyin.';

  @override
  String get kycTypeUnavailable =>
      'Kullanılabilir belge türü yok. Daha sonra tekrar deneyin.';

  @override
  String get kycNameInvalid => 'Resmî ad 2–64 karakter olmalı';

  @override
  String get kycNumberRequired => 'Belge numaranızı girin';

  @override
  String get kycFrontRequired => 'Belgenizin ön yüzünü yükleyin';

  @override
  String get kycBackRequired => 'Belgenizin arka yüzünü yükleyin';

  @override
  String get kycPhotoTooLarge =>
      'Fotoğraf boyut sınırını aşıyor. Sıkıştırıp tekrar deneyin.';

  @override
  String get kycAccountChanged =>
      'Hesap veya alan değişti. Bu sayfayı yeniden açın.';

  @override
  String get kycPhotoInvalid => 'Geçerli bir görsel seçin';

  @override
  String get kycPortraitSide => 'Portre yüzü';

  @override
  String get kycEmblemSide => 'Amblem yüzü';

  @override
  String get kycPassportDataPage => 'Pasaport bilgi sayfası';

  @override
  String get kycPassportOtherPage => 'Pasaport vize veya boş sayfası';

  @override
  String get kycFront => 'Kimlik Ön Yüzü';

  @override
  String get kycBack => 'Kimlik Arka Yüzü';

  @override
  String get kycRequired =>
      'Grup oluşturmadan önce kimlik doğrulaması gerekiyor';

  @override
  String get kycGoVerify => 'Şimdi doğrula';

  @override
  String get kycStatusUnknown =>
      'Kimlik durumu kullanılamıyor. Daha sonra yenileyin.';

  @override
  String get kycSuperseded =>
      'Daha yeni bir gönderim bunun yerine geçti. Güncel kimlik durumunuzu kontrol edin.';

  @override
  String get kycMediaNotFound =>
      'Belge fotoğrafı bu alanda kullanılamıyor. Göndermeden önce yeniden seçin.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Müşteri toplu mesajı';

  @override
  String get officialAccountBadge => 'Resmî';

  @override
  String get officialAccountOpenConversation => 'Görüşmeyi aç';

  @override
  String get officialAccountJoinHint =>
      'Bu hesabı eklediğinizde kuruma müşteri olarak katılırsınız. Arkadaşlık onayı gerekmez.';

  @override
  String get officialAccountJoinDisabled =>
      'Bu kurum yeni müşteri kabul etmiyor. Desteğe başvurun.';

  @override
  String get officialAccountRemoved =>
      'Bu kurumdan çıkarıldınız. Kurumdan sizi yeniden davet etmesini isteyin.';

  @override
  String get officialAccountBanned =>
      'Hesabınız bu kurumda devre dışı bırakıldı.';

  @override
  String get officialAccountUnavailable =>
      'Bu resmî hesap şu anda kullanılamıyor.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Mevcut modda kuruma katılmaya izin verilmiyor.';

  @override
  String get officialAccountPlatformRequired =>
      'Bu resmî hesabı eklemek için platform hesabı kullanın.';

  @override
  String get officialAccountOpenFailed => 'Görüşme açılamadı. Tekrar deneyin.';

  @override
  String get officialAccountAccountChanged =>
      'Hesap veya alan değişti. Yeniden açın.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Kurum dizini güncel değil. Birazdan tekrar deneyin.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Resmî hesap eşitlenemedi. Yerel içerik kullanılmaya devam edebilir.';

  @override
  String get officialAccountInboxSyncing => 'Resmî hesap mesajları eşitleniyor';

  @override
  String get diagnosticsTitle => 'Tanılama';

  @override
  String get diagnosticsExplanation =>
      'Günlükler hassas bilgilerden arındırılır; bu hesap ve alanın işlem ve hata bilgileri ile herkese açık başlatma olaylarını içerir. Sohbet içeriği ve kimlik bilgileri kaydedilmez.';

  @override
  String get diagnosticsHour => 'Son saat';

  @override
  String get diagnosticsDay => 'Son 24 saat';

  @override
  String get diagnosticsWeek => '7G';

  @override
  String diagnosticsEventCount(int count) {
    return 'Kullanılabilir olay: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Günlükler bu cihaza kaydedilir ve yeniden başlatıldıktan sonra da kullanılabilir.';

  @override
  String get diagnosticsNotPersistent =>
      'Bazı günlükler kaydedilmedi. Yeniden denemek için yenileyin.';

  @override
  String get diagnosticsExport => 'Dışa aktar ve paylaş';

  @override
  String get diagnosticsRefresh => 'Yenile';

  @override
  String get diagnosticsClear => 'Bu alanın günlüklerini temizle';

  @override
  String get diagnosticsClearConfirm =>
      'Bu alanın tanılama günlükleri temizlensin mi? Sohbet geçmişi korunacak.';

  @override
  String get diagnosticsShared =>
      'Sistem paylaşımı tamamlandı. Dosyayı alıcı uygulamada doğrulayın.';

  @override
  String get diagnosticsCancelled =>
      'Paylaşım iptal edildi. Yeniden dışa aktarabilirsiniz.';

  @override
  String get diagnosticsUnconfirmed =>
      'Paylaşım doğrulanamadı. Alıcı uygulamayı kontrol edin.';

  @override
  String get diagnosticsFailed => 'İşlem başarısız. Tekrar deneyin.';
}
