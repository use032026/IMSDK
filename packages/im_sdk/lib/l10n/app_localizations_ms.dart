// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get navWorkbench => 'Ruang kerja';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Data akaun gagal dimuatkan';

  @override
  String get startupFailureTitle => 'Gagal memulakan';

  @override
  String get startupFailureMessage => 'Semak rangkaian dan cuba lagi';

  @override
  String get privacyConsentTitle =>
      'Perjanjian Perkhidmatan dan Polisi Privasi';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Selamat datang ke $brand. Untuk menyediakan log masuk akaun, pemesejan segera, kerjasama syarikat, perkhidmatan pelanggan dalam talian, pemberitahuan mesej dan perlindungan keselamatan, kami perlu memproses maklumat yang diperlukan mengikut Terma Perkhidmatan dan Dasar Privasi.\n\nSebelum anda mengetik Setuju, kami tidak akan membaca papan keratan, memulakan JPush/JCore atau SDK pemberitahuan tolak pengeluar peranti, atau menggunakan SDK tersebut untuk mengakses Android ID, OAID, senarai aplikasi yang dipasang, alamat MAC atau maklumat seumpamanya. Jika anda belum bersetuju, kami akan menyimpan pilihan itu; anda masih boleh membaca dokumen dan membuat pilihan semula kemudian.\n\nSelepas anda bersetuju, untuk menghantar pemberitahuan mesej, perkhidmatan pelanggan dan panggilan masuk, JPush/JCore serta perkhidmatan pemberitahuan tolak pengeluar peranti mungkin memproses model peranti, versi Android, nama pakej dan versi aplikasi, jenis rangkaian, alamat IP, Android ID, OAID, Registration ID, token pemberitahuan tolak pengeluar serta maklumat penghantaran dan klik pemberitahuan. Kami telah melumpuhkan keupayaan yang tidak diperlukan, termasuk pemberitahuan tolak pintar, senarai aplikasi yang dipasang, MAC, IMEI, IMSI, senarai Wi-Fi, pengaktifan automatik dan pelancaran berkaitan.\n\nPapan keratan hanya diakses apabila anda menggunakan fungsi salin atau tampal. Kebenaran kamera, mikrofon, pemberitahuan dan kebenaran sistem lain hanya diminta apabila anda menggunakan ciri berkaitan. Penolakan satu kebenaran hanya menjejaskan ciri tersebut. Sila baca dokumen penuh di bawah dan pilih sama ada anda bersetuju.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Selamat datang ke $brand. Untuk menyediakan log masuk akaun, pemesejan segera, kerjasama syarikat, perkhidmatan pelanggan dalam talian, pemberitahuan mesej dan perlindungan keselamatan, kami perlu memproses maklumat yang diperlukan mengikut Terma Perkhidmatan dan Dasar Privasi.\n\nSebelum anda mengetik Setuju, kami tidak akan membaca papan keratan, memulakan JPush/JCore, mendaftar dengan Apple Push Notification service (APNs) atau mendapatkan pengecam pemberitahuan tolak seperti Registration ID JPush atau token peranti APNs. Jika anda belum bersetuju, kami akan menyimpan pilihan itu; anda masih boleh membaca dokumen dan membuat pilihan semula kemudian.\n\nSelepas anda bersetuju, untuk menghantar pemberitahuan mesej, perkhidmatan pelanggan dan panggilan masuk, kami mungkin memproses model iPhone, versi iOS, nama pakej dan versi aplikasi, jenis rangkaian, alamat IP, IDFV, Registration ID JPush, token peranti APNs serta maklumat penghantaran dan klik pemberitahuan. JPush/JCore bersambung ke perkhidmatan pemberitahuan tolak; Apple APNs memproses pengecam aplikasi, token peranti dan muatan pemberitahuan untuk menghantar pemberitahuan sistem. Aplikasi iOS semasa tidak menggunakan perkhidmatan iklan atau mendapatkan IDFA.\n\nPapan keratan hanya diakses apabila anda menggunakan fungsi salin atau tampal. Kebenaran kamera, mikrofon, pemberitahuan dan kebenaran sistem lain hanya diminta apabila anda menggunakan ciri berkaitan. Penolakan satu kebenaran hanya menjejaskan ciri tersebut. Sila baca dokumen penuh di bawah dan pilih sama ada anda bersetuju.';
  }

  @override
  String get privacyConsentTermsLink => 'Perjanjian Pengguna';

  @override
  String get privacyConsentConjunction => 'dan';

  @override
  String get privacyConsentPrivacyLink => 'Dasar Privasi';

  @override
  String get privacyConsentDecline => 'Tidak bersetuju';

  @override
  String get privacyConsentDeclinedExit =>
      'Anda tidak bersetuju dengan Terma Perkhidmatan dan Dasar Privasi. Aplikasi akan ditutup.';

  @override
  String get privacyConsentAccept => 'Setuju';

  @override
  String get privacyConsentRuntimeFailure =>
      'Gagal memulakan. Semak rangkaian dan cuba lagi.';

  @override
  String get privacyConsentSaveFailure =>
      'Pilihan tidak dapat disimpan. Cuba lagi.';

  @override
  String get appUpdateRequiredTitle => 'Kemas kini untuk meneruskan';

  @override
  String get appUpdateOptionalTitle => 'Versi baru ditemui';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version tersedia';
  }

  @override
  String get appUpdateLater => 'Nanti';

  @override
  String get appUpdateNow => 'Kemas kini sekarang';

  @override
  String get appUpdateProcessing => 'Memproses...';

  @override
  String get appUpdateInvalidUrl =>
      'Alamat kemas kini tidak sah. Cuba lagi nanti.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Pautan kemas kini tidak dapat dibuka. Cuba lagi nanti.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Muat turun terputus. Semak rangkaian dan cuba lagi.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Pengesahan pakej gagal. Muat turun semula.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Benarkan $brand memasang kemas kini dalam tetapan sistem.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Pemasang sistem tidak dapat dibuka. Semak kebenaran pemasangan.';

  @override
  String get appUpdateGenericFailure =>
      'Kemas kini gagal. Semak rangkaian dan cuba lagi.';

  @override
  String get appUpdateUnavailable =>
      'Versi baharu belum tersedia untuk dimuat turun. Cuba lagi nanti.';

  @override
  String get appUpdateCheckFailed =>
      'Kemas kini tidak dapat disemak. Cuba lagi nanti.';

  @override
  String get appUpdateChecking => 'Menyemak';

  @override
  String get commonConfirm => 'Sahkan';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonSave => 'Simpan';

  @override
  String get commonEdit => 'Sunting';

  @override
  String get commonDelete => 'Padam';

  @override
  String get commonSearch => 'cari';

  @override
  String get commonLoading => 'Memuatkan...';

  @override
  String get commonLoadFailed => 'Gagal memuat';

  @override
  String get commonRetry => 'Cuba lagi';

  @override
  String get commonEmpty => 'Tiada data';

  @override
  String get commonCopy => 'Salin';

  @override
  String get commonForward => 'Majukan';

  @override
  String get commonFavorite => 'Simpan';

  @override
  String get commonClose => 'Tutup';

  @override
  String get commonSend => 'Hantar';

  @override
  String get commonDone => 'Selesai';

  @override
  String get commonMore => 'Lagi';

  @override
  String get commonSettings => 'Tetapan';

  @override
  String get commonCopied => 'Disalin';

  @override
  String get commonUnknown => 'Tidak Diketahui';

  @override
  String get commonNotSet => 'Belum ditetapkan';

  @override
  String get commonUnbound => 'Belum disambungkan';

  @override
  String get commonViewAll => 'Lihat semua';

  @override
  String get commonSubmit => 'Hantar';

  @override
  String get commonAdd => 'Tambah';

  @override
  String get commonRemove => 'Hapus';

  @override
  String get commonCreate => 'Cipta';

  @override
  String get commonUpdate => 'Kemas kini';

  @override
  String get commonUpload => 'Muat naik';

  @override
  String get commonShare => 'Kongsi';

  @override
  String get commonBlock => 'Sekat';

  @override
  String get commonUnblock => 'Nyahsekat';

  @override
  String get commonMute => 'Senyapkan';

  @override
  String get commonUnmute => 'Nyahsenyap';

  @override
  String get commonPin => 'Tetapkan di Atas';

  @override
  String get commonUnpin => 'Nyahpin';

  @override
  String get commonMarkRead => 'Tandakan sebagai dibaca';

  @override
  String get commonMarkUnread => 'Tandakan sebagai belum dibaca';

  @override
  String get commonOnline => 'Dalam talian';

  @override
  String get commonOffline => 'Luar talian';

  @override
  String get commonOperationFailed => 'Operasi gagal, cuba lagi';

  @override
  String get commonNetworkError => 'Ralat rangkaian, semak sambungan anda';

  @override
  String get navMessages => 'Mesej';

  @override
  String get navContacts => 'Kenalan';

  @override
  String get navMe => 'Saya';

  @override
  String get authLoginTitle => 'Log masuk ke StartLink';

  @override
  String get authTabMobile => 'Telefon';

  @override
  String get authTabEmail => 'Emel';

  @override
  String get authTabLoginName => 'ID StartLink';

  @override
  String get authHintMobile => 'Masukkan nombor telefon';

  @override
  String get authHintEmail => 'Sila masukkan emel';

  @override
  String get authHintPassword => 'Sila masukkan kata laluan';

  @override
  String get authHintCode => 'Masukkan kod pengesahan';

  @override
  String get authHintLoginName => 'Masukkan ID StartLink (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Log Masuk';

  @override
  String get authGetCode => 'Dapatkan Kod Pengesahan';

  @override
  String authResendCode(int seconds) {
    return 'Hantar semula dalam ${seconds}s';
  }

  @override
  String get authUsePassword => 'Gunakan kata laluan';

  @override
  String get authUseCode => 'Gunakan kod pengesahan';

  @override
  String get authAgreementPrefix => 'Saya telah membaca dan bersetuju';

  @override
  String get authAgreementAnd => 'dan';

  @override
  String get authTermsLink => 'Perjanjian Pengguna';

  @override
  String get authPrivacyLink => 'Dasar Privasi';

  @override
  String get authCaptchaTitle => 'Pengesahan keselamatan';

  @override
  String get authCaptchaHint => 'Masukkan jawapan';

  @override
  String get authCaptchaFailed => 'Gagal mendapatkan captcha, cuba lagi';

  @override
  String get authErrorEmptyCode => 'Sila masukkan kod pengesahan';

  @override
  String get authErrorEmptyPassword => 'Sila masukkan kata laluan';

  @override
  String get authErrorEmptyLoginName => 'Sila masukkan ID StartLink';

  @override
  String get authErrorWrongCredentials => 'Akaun atau kata laluan salah';

  @override
  String get authDeactivatingTitle => 'Penutupan akaun';

  @override
  String get authDeactivatingContent =>
      'Akaun anda sedang dalam tempoh bertenang penutupan (7 hari).\n\nUntuk membatalkan penutupan, ketik \"Batalkan penutupan\"; jika tidak, ketik \"Teruskan\" untuk memasuki aplikasi.';

  @override
  String get authContinueUse => 'Teruskan';

  @override
  String get authCancelDeactivation => 'Batalkan penutupan';

  @override
  String get authDeactivationCancelled =>
      'Penutupan dibatalkan, akaun dipulihkan';

  @override
  String get authDeactivationCancelFailed => 'Gagal membatalkan, cuba lagi';

  @override
  String get authLogout => 'Log Keluar';

  @override
  String get authLogoutConfirm => 'Adakah anda pasti mahu log keluar?';

  @override
  String get authSendingCode => 'Menghantar...';

  @override
  String get authCodeSent => 'Kod pengesahan berjaya dihantar';

  @override
  String get authLoginFailed => 'Gagal log masuk, cuba lagi';

  @override
  String get authRegisterFailed => 'Pendaftaran gagal, cuba lagi';

  @override
  String get authEnterpriseCode => 'Kod syarikat';

  @override
  String get authEnterpriseCodeHint => 'Masukkan kod syarikat';

  @override
  String get authPendingApproval =>
      'Pendaftaran berjaya. Permohonan anda untuk menyertai syarikat telah dihantar dan sedang menunggu kelulusan.';

  @override
  String get authNoAccount => 'Tiada akaun?';

  @override
  String get authRegisterNow => 'Daftar sekarang';

  @override
  String get authCountryPickerTitle => 'Pilih negara/wilayah';

  @override
  String get authCountrySearchHint => 'Cari negara/wilayah';

  @override
  String get authCountryChinaMainland => 'Tanah Besar China';

  @override
  String get authCountryHongKong => 'Hong Kong, China';

  @override
  String get authCountryMacau => 'Macau, China';

  @override
  String get authCountryTaiwan => 'Taiwan, China';

  @override
  String get authCountryUnitedStates => 'Amerika Syarikat';

  @override
  String get authCountryUnitedKingdom => 'United Kingdom';

  @override
  String get authCountryJapan => 'Jepun';

  @override
  String get authCountrySouthKorea => 'Korea Selatan';

  @override
  String get authCountrySingapore => 'Singapura';

  @override
  String get authCountryMalaysia => 'Malaysia';

  @override
  String get authCountryAustralia => 'Australia';

  @override
  String get authCountryCanada => 'Kanada';

  @override
  String get authCountryGermany => 'Jerman';

  @override
  String get authCountryFrance => 'Perancis';

  @override
  String get authCountryIndia => 'India';

  @override
  String get authCountryThailand => 'Thailand';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonesia';

  @override
  String get authCountryPhilippines => 'Filipina';

  @override
  String get authQuickLoginTitle => 'Log masuk pantas';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Sedang log masuk. Sila tunggu.';

  @override
  String get authRoleOwner => 'Pemilik';

  @override
  String get authRoleAdministrator => 'Pentadbir';

  @override
  String get authRoleCustomerService => 'Khidmat pelanggan';

  @override
  String get authRoleTechnicalSupport => 'Sokongan teknikal';

  @override
  String get authRoleEmployee => 'Pekerja';

  @override
  String get authRoleMember => 'Ahli';

  @override
  String get authRoleEnterpriseCustomer => 'Pelanggan syarikat';

  @override
  String get authUnavailablePrefix => 'Tidak tersedia · ';

  @override
  String get authUnassignedService => 'Tiada ejen ditugaskan';

  @override
  String authAssignedService(String staff) {
    return 'Ditugaskan kepada $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Pelanggan · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Pekerja · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count pengguna';
  }

  @override
  String get authMetaPhone => 'Telefon';

  @override
  String get authMetaIdentity => 'Identiti';

  @override
  String get authRegisterTitle => 'Daftar';

  @override
  String get authNickname => 'Nama panggilan';

  @override
  String get authNicknameHint => 'Tetapkan nama panggilan';

  @override
  String get authPassword => 'kata laluan';

  @override
  String get authPasswordSetHint =>
      'Tetapkan kata laluan (sekurang-kurangnya 6 aksara)';

  @override
  String get authConfirmPassword => 'Sahkan kata laluan';

  @override
  String get authConfirmPasswordHint => 'Masukkan kata laluan sekali lagi';

  @override
  String get authVerificationCode => 'Kod pengesahan';

  @override
  String get authRegisterAndLogin => 'Daftar dan log masuk';

  @override
  String get authHaveAccount => 'Sudah mempunyai akaun?';

  @override
  String get authGoLogin => 'Log Masuk';

  @override
  String get authEmailVerificationUnavailable =>
      'Pengesahan e-mel tidak tersedia. Daftar dengan nombor telefon mudah alih.';

  @override
  String get authSmsVerificationUnavailable =>
      'Pengesahan SMS tidak tersedia. Daftar dengan e-mel.';

  @override
  String get authSendFailed => 'Tidak dapat menghantar. Cuba lagi.';

  @override
  String get authErrorEmptyNickname => 'Masukkan nama panggilan';

  @override
  String get authErrorInvalidMobile =>
      'Masukkan nombor telefon mudah alih yang sah';

  @override
  String get authErrorInvalidEmail => 'Format emel tidak betul';

  @override
  String get authErrorPasswordTooShort =>
      'Kata laluan mesti mengandungi sekurang-kurangnya 6 aksara';

  @override
  String get authErrorPasswordMismatch => 'Kata laluan tidak sepadan';

  @override
  String get authErrorVerificationRequired =>
      'Dapatkan dan masukkan kod pengesahan terlebih dahulu';

  @override
  String get authRegisterErrorTitle => 'Pendaftaran gagal';

  @override
  String get authGotIt => 'Tahu';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Syarikat \"$code\" tidak ditemui. Semak kod syarikat.';
  }

  @override
  String get authTenantSearchFailed => 'Carian gagal. Cuba lagi.';

  @override
  String get authInvitationInvalid =>
      'Kod jemputan tidak sah. Semak dan cuba lagi.';

  @override
  String get authCollapseJoin => 'Sembunyikan maklumat penyertaan';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Jemputan sah: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Syarikat ditemui: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Pilih organisasi';

  @override
  String get authNoOrganization => 'Tiada organisasi tersedia';

  @override
  String get authNoOrganizationHint =>
      'Minta pentadbir menjemput anda ke organisasi';

  @override
  String get authPersonalSpace => 'Ruang peribadi';

  @override
  String get authPersonalSpaceSubtitle =>
      'Sembang rakan dan kegemaran peribadi';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Identiti ruang tidak dapat disahkan. Cuba lagi.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Ruang peribadi tidak dapat dipulihkan. Cuba lagi.';

  @override
  String get authJoinEnterpriseFailed =>
      'Tidak dapat menyertai syarikat. Cuba lagi nanti.';

  @override
  String get homeTitle => 'Mesej';

  @override
  String get homeGatewayConnectingTitle => 'Menyambung';

  @override
  String get homePersonalSpace => 'Peribadi';

  @override
  String get homeOfficialService => 'Perkhidmatan rasmi';

  @override
  String get homeSwitchSpace => 'Tukar ruang';

  @override
  String get homeSpaceSubtitle => 'Peribadi · Syarikat';

  @override
  String get homeJoinEnterprise => 'Sertai syarikat';

  @override
  String get homeCreateGroup => 'Kumpulan baharu';

  @override
  String get homeAddFriend => 'Tambah kenalan';

  @override
  String get homeScan => 'Imbas';

  @override
  String get homeJoinNewSpace => 'Sertai ruang baharu';

  @override
  String get homeSearchConversation => 'Cari';

  @override
  String get homeNoMessages => 'Tiada Mesej';

  @override
  String get homeDeleteConversation => 'Padam sembang';

  @override
  String get homeDeleteConversationConfirm =>
      'Padam sembang ini? Sejarah sembang akan dikosongkan.';

  @override
  String get homePersonalNote => 'Saya (Nota peribadi)';

  @override
  String get homeWorkNote => 'Saya (Nota kerja)';

  @override
  String homeConversationCount(int count) {
    return '$count sembang';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count belum dibaca';
  }

  @override
  String get chatInputHint => 'Taip mesej...';

  @override
  String get chatVoiceHint => 'Tahan untuk bercakap';

  @override
  String get chatVoiceRelease => 'Lepaskan untuk menghantar';

  @override
  String get chatVoiceCancel => 'Leret ke atas untuk membatalkan';

  @override
  String get chatMenuCopy => 'Salin';

  @override
  String get chatMenuForward => 'Majukan';

  @override
  String get chatMenuRecall => 'Tarik balik';

  @override
  String get chatMenuDelete => 'Padam';

  @override
  String get chatMenuFavorite => 'Simpan';

  @override
  String get chatMenuReply => 'Balas';

  @override
  String get chatMenuMultiSelect => 'Pilih';

  @override
  String get chatMenuTranslate => 'Terjemah';

  @override
  String get chatMenuVoiceToText => 'Tukar kepada teks';

  @override
  String get chatMenuTextToSpeech => 'Baca lantang';

  @override
  String get chatStatusRecalled => 'Mesej ditarik balik';

  @override
  String get chatRecallSuccess => 'Ditarik balik';

  @override
  String get chatRecallFailed => 'Gagal menarik balik';

  @override
  String get chatRecallTimeout =>
      'Mesej yang berusia lebih 2 minit tidak dapat ditarik balik';

  @override
  String get chatTranslateFailed => 'Terjemahan gagal, cuba lagi';

  @override
  String get chatTranslateNotConfigured =>
      'Perkhidmatan terjemahan tidak tersedia';

  @override
  String get chatVoiceToTextFailed => 'Penukaran gagal, cuba lagi';

  @override
  String get chatTextToSpeechFailed => 'Gagal membaca lantang, cuba lagi';

  @override
  String get chatVoiceToText => 'Tukar';

  @override
  String get chatForwardSuccess => 'Dimajukan';

  @override
  String get chatForwardFailed => 'Gagal memajukan, cuba lagi';

  @override
  String get chatNoConversations => 'Tiada sembang untuk dimajukan';

  @override
  String get chatSendFailed => 'Gagal menghantar';

  @override
  String get chatResend => 'Hantar semula';

  @override
  String get chatNotFriend => 'Tiada dalam senarai kenalan';

  @override
  String get chatNotFriendHint =>
      'Anda belum menjadi kenalan. Tidak dapat menghantar mesej.';

  @override
  String get chatMutedHint => 'Semua ahli disenyapkan';

  @override
  String get chatFileUploadFailed => 'Muat naik fail gagal, cuba lagi';

  @override
  String get chatFileStatusNotDownloaded => 'Belum dimuat turun';

  @override
  String get chatFileStatusDownloaded => 'Telah dimuat turun';

  @override
  String get chatFileStatusUploading => 'Memuat naik';

  @override
  String get chatFileStatusUploadFailed => 'Muat naik gagal';

  @override
  String get chatCardSendFailed => 'Gagal menghantar kad kenalan';

  @override
  String get chatFavoriteSuccess => 'Disimpan';

  @override
  String get chatFavoriteFailed => 'Gagal menambah ke kegemaran';

  @override
  String get chatLoadFailed => 'Gagal memuat';

  @override
  String get chatImageMessage => '[Imej]';

  @override
  String get chatVoiceMessage => '[Suara]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Fail]';

  @override
  String get chatLocationMessage => '[Lokasi]';

  @override
  String get chatContactCardMessage => '[Kenalan]';

  @override
  String get chatCallLogMessage => '[Panggilan]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Dibaca oleh $count';
  }

  @override
  String get chatUnread => 'Belum dibaca';

  @override
  String get chatRecalledSelf => 'Anda menarik balik mesej';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender menarik balik mesej';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Terjemahan: $translation';
  }

  @override
  String get chatMessageDeleted => 'Mesej dipadam';

  @override
  String get chatPeer => 'Lain-lain';

  @override
  String get chatSelf => 'Saya';

  @override
  String get chatGenericMessage => '[Mesej]';

  @override
  String get chatVoiceHideText => 'Sembunyikan teks';

  @override
  String get chatVoiceShowText => 'Tukar kepada teks';

  @override
  String get chatFileDefaultName => 'Fail';

  @override
  String get chatContactDefaultName => 'Kenalan';

  @override
  String get chatContactCardTitle => 'Kad kenalan';

  @override
  String get chatCallMissed => 'Tidak dijawab';

  @override
  String get chatCallCancelled => 'Dibatalkan';

  @override
  String get chatCallRejected => 'Ditolak';

  @override
  String get chatCallDisconnected => 'Terputus';

  @override
  String get chatCallEnded => 'Panggilan tamat';

  @override
  String get chatCallFailed => 'Panggilan gagal';

  @override
  String chatCallDuration(String duration) {
    return 'Tempoh $duration';
  }

  @override
  String get chatVideoCallTitle => 'Panggilan video';

  @override
  String get chatVoiceCallTitle => 'Panggilan suara';

  @override
  String get chatToolPhotos => 'Foto';

  @override
  String get chatToolCamera => 'Kamera';

  @override
  String get chatToolFile => 'Fail';

  @override
  String get chatToolLocation => 'Lokasi';

  @override
  String get chatToolContactCard => 'Kenalan';

  @override
  String get chatToolVoiceCall => 'Panggilan suara';

  @override
  String get chatToolVideoCall => 'Panggilan video';

  @override
  String get chatToolFavorites => 'Kegemaran';

  @override
  String get chatToolTranslate => 'Terjemah';

  @override
  String get chatTranslationChooseLanguage => 'Pilih bahasa terjemahan';

  @override
  String get chatTranslationEnterText => 'Masukkan teks dahulu';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Terjemahan tidak tersedia untuk mesej yang mengandungi sebutan';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Terjemahan tidak tersedia semasa menyunting mesej berjadual';

  @override
  String get chatTranslationFailed => 'Terjemahan gagal. Cuba lagi';

  @override
  String get chatTranslationEmpty => 'Tiada terjemahan diterima. Cuba lagi';

  @override
  String get chatTranslationTranslating => 'Menterjemah…';

  @override
  String get chatTranslationSend => 'Hantar terjemahan';

  @override
  String get chatTranslationSending => 'Menghantar…';

  @override
  String get chatTranslationExpand => 'Tunjukkan lebih banyak';

  @override
  String get chatTranslationCollapse => 'Tunjukkan lebih sedikit';

  @override
  String get chatFileTooLarge => 'Fail melebihi had (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Hanya pemilik atau ahli terpilih boleh menghantar mesej.';

  @override
  String get chatImageUploadUnsupported =>
      'Muat naik imej gagal. Sokongan pelayan belum tersedia.';

  @override
  String get chatFavoriteLongPressHint =>
      'Tekan lama mesej untuk menambahnya ke kegemaran';

  @override
  String chatSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get chatLocationSheetTitle => 'Hantar lokasi';

  @override
  String get chatLocationNameLabel => 'Nama tempat';

  @override
  String get chatLocationNameHint => 'cth. Pejabat, alamat pelanggan';

  @override
  String get chatLocationAddressLabel => 'Alamat';

  @override
  String get chatLocationOptionalHint => 'Pilihan';

  @override
  String get chatLocationLatitudeLabel => 'Latitud';

  @override
  String get chatLocationLatitudeHint => '-90 hingga 90';

  @override
  String get chatLocationLongitudeLabel => 'Longitud';

  @override
  String get chatLocationLongitudeHint => '-180 hingga 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Masukkan $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label di luar julat';
  }

  @override
  String get chatLocationDefaultTitle => 'Lokasi';

  @override
  String get chatMutedFullNotice =>
      'Kumpulan ini disenyapkan. Hanya pemilik atau ahli terpilih boleh menghantar mesej.';

  @override
  String get chatNotFriendSendBlocked =>
      'Anda tidak lagi berkawan dan tidak dapat menghantar mesej';

  @override
  String get chatPersonalNotesTitle => 'Nota peribadi';

  @override
  String get chatWorkNotesTitle => 'Nota kerja';

  @override
  String get chatPersonalNotesDescription =>
      'Catat fikiran peribadi dan simpan maklumat penting di sini\nDisegerakkan antara peranti untuk akses pada bila-bila masa';

  @override
  String get chatWorkNotesDescription =>
      'Catat tugas kerja dan simpan bahan kerja di sini\nRuang pasukan kekal berasingan dan selamat';

  @override
  String get chatNoMessages => 'Tiada Mesej';

  @override
  String chatReplyTo(String sender) {
    return 'Balas kepada $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature akan datang';
  }

  @override
  String get chatForwardSelectTitle => 'Pilih sembang';

  @override
  String get chatContactSelectTitle => 'Pilih kenalan';

  @override
  String get chatNoContacts => 'Tiada kenalan';

  @override
  String get contactsTitle => 'Kenalan';

  @override
  String get contactsSearch => 'Cari kenalan';

  @override
  String get contactsNewFriends => 'Rakan baharu';

  @override
  String get contactsGroups => 'Kumpulan';

  @override
  String get contactsFavorites => 'Kegemaran';

  @override
  String get contactsRecent => 'Terkini';

  @override
  String get contactsOrganization => 'Organisasi';

  @override
  String get contactsAnnouncement => 'Pengumuman';

  @override
  String get contactsNewApplications => 'Permohonan baharu';

  @override
  String get contactsCustomerGroups => 'Kumpulan pelanggan';

  @override
  String get contactsAllCustomers => 'Semua pelanggan';

  @override
  String get contactsMyCustomers => 'Pelanggan saya';

  @override
  String get contactsViewAll => 'Lihat semua';

  @override
  String get contactsMyContacts => 'Kenalan saya';

  @override
  String get contactsMyAdvisor => 'Penasihat saya';

  @override
  String get contactsNoAdvisor => 'Belum ada penasihat ditugaskan';

  @override
  String get contactsAdvisorLoading => 'Memuatkan...';

  @override
  String get contactsNavigateFailed => 'Navigasi gagal, cuba lagi';

  @override
  String get contactsEmpty => 'Tiada kenalan';

  @override
  String get contactsNoAnnouncement => 'Tiada pengumuman';

  @override
  String get contactsOfficialBadge => 'Rasmi';

  @override
  String get contactsCustomerBadge => 'Pelanggan';

  @override
  String get contactsEmptyCustomers => 'Tiada pelanggan';

  @override
  String get myTitle => 'Saya';

  @override
  String get myEnterpriseInfo => 'Maklumat syarikat';

  @override
  String get myEnterpriseManage => 'Pengurusan syarikat';

  @override
  String get myQrCode => 'Kod QR';

  @override
  String get myFavorites => 'Kegemaran';

  @override
  String get myLanguage => 'Bahasa Sistem';

  @override
  String get myTimezone => 'Zon waktu';

  @override
  String get myAutoTranslate => 'Terjemahan automatik';

  @override
  String get myNetworkSwitch => 'Tukar Saluran';

  @override
  String get mySettings => 'Tetapan';

  @override
  String get myLogout => 'Log Keluar';

  @override
  String get myLogoutConfirm => 'Adakah anda pasti mahu log keluar?';

  @override
  String get myLeaveEnterprise => 'Keluar daripada syarikat';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Adakah anda pasti mahu keluar daripada syarikat ini? Anda akan kehilangan akses kepada data syarikat.';

  @override
  String get myLeaveEnterpriseSuccess => 'Telah keluar daripada syarikat';

  @override
  String get myLeaveEnterpriseFailed => 'Gagal keluar, cuba lagi';

  @override
  String get myLppIdCopied => 'ID StartLink disalin';

  @override
  String myLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count kenalan';
  }

  @override
  String get myAutoSelect => 'Automatik';

  @override
  String get myPresenceStatus => 'Status kehadiran';

  @override
  String get myPresenceStatusTitle => 'Tetapkan status kehadiran';

  @override
  String get myPresenceOnline => 'Dalam talian';

  @override
  String get myPresenceBusy => 'Sibuk';

  @override
  String get myPresenceAway => 'Tiada di tempat';

  @override
  String get myPresenceInvisible => 'Halimunan';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileName => 'Nama';

  @override
  String get profileGender => 'Jantina';

  @override
  String get profileBirthday => 'Tarikh lahir';

  @override
  String get profileRegion => 'Wilayah';

  @override
  String get profileSignature => 'Biodata';

  @override
  String get profileSignatureHint => 'Ceritakan tentang diri anda';

  @override
  String get profileTapTapText => 'Cuitan';

  @override
  String get profileTapTapHint =>
      'Teks yang dipaparkan apabila dicuit (maks. 20 aksara)';

  @override
  String get profileAccountSection => 'Akaun';

  @override
  String get profileBasicSection => 'Maklumat asas';

  @override
  String get profileLppId => 'ID StartLink';

  @override
  String get profileLppIdNotSet => 'Belum ditetapkan';

  @override
  String get profileMobile => 'Telefon';

  @override
  String get profileMobileUnbound => 'Belum disambungkan';

  @override
  String get profileEmail => 'Emel';

  @override
  String get profileEmailUnbound => 'Belum disambungkan';

  @override
  String get profileQrCode => 'Kod QR saya';

  @override
  String get profileChangePassword => 'Ubah kata laluan';

  @override
  String get profileGenderMale => 'Lelaki';

  @override
  String get profileGenderFemale => 'Perempuan';

  @override
  String get profileGenderOther => 'Lain-lain';

  @override
  String get profileGenderUnset => 'Belum ditetapkan';

  @override
  String get profileSaveFailed => 'Gagal menyimpan, cuba lagi';

  @override
  String get profileLppIdTitle => 'ID StartLink';

  @override
  String get profileLppIdSetOnce =>
      'ID StartLink hanya boleh ditukar sekali. Pilih dengan teliti.';

  @override
  String get profileLppIdChangeFailed =>
      'Gagal menukar (ID StartLink hanya boleh ditukar sekali)';

  @override
  String get profileChangePasswordOld => 'Kata laluan semasa';

  @override
  String get profileChangePasswordNew => 'Kata Laluan Baru';

  @override
  String get profileChangePasswordConfirm => 'Sahkan kata laluan baru';

  @override
  String get profileChangePasswordMismatch => 'Kata laluan tidak sepadan';

  @override
  String get profileChangePasswordSuccess =>
      'Kata laluan ditukar. Sila log masuk semula.';

  @override
  String get profileChangePasswordFailed =>
      'Gagal menukar kata laluan, cuba lagi';

  @override
  String get settingsTitle => 'Tetapan';

  @override
  String get settingsSectionEnterprise => 'Syarikat';

  @override
  String get settingsSectionAccount => 'Akaun';

  @override
  String get settingsSectionGeneral => 'Umum';

  @override
  String get settingsSectionFeatures => 'Ciri';

  @override
  String get settingsSectionAbout => 'Tentang';

  @override
  String get settingsEnterpriseInfo => 'Maklumat syarikat';

  @override
  String get settingsProfile => 'Profil';

  @override
  String get settingsAccountSecurity => 'Keselamatan akaun';

  @override
  String get settingsNotification => 'Pemberitahuan';

  @override
  String get settingsDisplay => 'Paparan';

  @override
  String get settingsFriendPrivacy => 'Privasi';

  @override
  String get settingsChat => 'Sembang';

  @override
  String get settingsChatHistory => 'Sejarah sembang';

  @override
  String get settingsAbout => 'Tentang StartLink';

  @override
  String get settingsLanguage => 'Bahasa Sistem';

  @override
  String get settingsTimezone => 'Zon waktu';

  @override
  String get settingsAutoTranslate => 'Terjemahan automatik';

  @override
  String get settingsNetworkSwitch => 'Tukar Saluran';

  @override
  String get enterpriseInfoTitle => 'Maklumat syarikat';

  @override
  String get enterpriseName => 'Nama';

  @override
  String get enterpriseDescription => 'Penerangan';

  @override
  String get enterpriseUpdateSuccess => 'Kemas kini berjaya';

  @override
  String get enterpriseUpdateFailed => 'Kemas kini gagal, cuba lagi';

  @override
  String get enterpriseLeave => 'Keluar daripada syarikat';

  @override
  String get enterpriseLeaveConfirm =>
      'Adakah anda pasti mahu keluar daripada syarikat ini?';

  @override
  String get enterpriseLeaveSuccess => 'Telah keluar daripada syarikat';

  @override
  String get enterpriseLeaveFailed => 'Gagal keluar, cuba lagi';

  @override
  String get enterpriseLeaveOwnerError =>
      'Pemilik tidak boleh terus keluar. Pindahkan pemilikan dahulu.';

  @override
  String get enterpriseMemberCount => 'Ahli';

  @override
  String get enterpriseCreatedAt => 'Dicipta';

  @override
  String get enterpriseCode => 'Kod syarikat';

  @override
  String get enterpriseInviteMembers => 'Jemput ahli';

  @override
  String get enterpriseCopyInviteCode => 'Salin kod jemputan';

  @override
  String get enterpriseInviteCodeCopied => 'Kod jemputan disalin';

  @override
  String get groupCreateTitle => 'Kumpulan baharu';

  @override
  String get groupNameHint => 'Masukkan nama kumpulan';

  @override
  String get groupCreateSuccess => 'Kumpulan dicipta';

  @override
  String get groupCreateFailed => 'Gagal mencipta kumpulan';

  @override
  String get groupSettings => 'Tetapan kumpulan';

  @override
  String get groupName => 'Nama kumpulan';

  @override
  String get groupAvatar => 'Avatar kumpulan';

  @override
  String get groupAnnouncement => 'Pengumuman';

  @override
  String get groupMembers => 'Ahli';

  @override
  String get groupAddMember => 'Tambah ahli';

  @override
  String get groupRemoveMember => 'Keluarkan ahli';

  @override
  String get groupRemoveMemberConfirm => 'Keluarkan ahli ini?';

  @override
  String get groupSetAdmin => 'Jadikan pentadbir';

  @override
  String get groupRemoveAdmin => 'Buang pentadbir';

  @override
  String get groupTransferOwner => 'Pindahkan pemilikan';

  @override
  String get groupTransferOwnerConfirm =>
      'Pindahkan pemilikan kumpulan kepada ahli ini?';

  @override
  String get groupTransferOwnerSuccess => 'Pemilikan dipindahkan';

  @override
  String get groupTransferOwnerFailed => 'Pemindahan gagal, cuba lagi';

  @override
  String get groupLeave => 'Keluar daripada kumpulan';

  @override
  String get groupLeaveConfirm => 'Keluar daripada kumpulan ini?';

  @override
  String get groupLeaveSuccess => 'Telah keluar daripada kumpulan';

  @override
  String get groupLeaveFailed => 'Gagal keluar, cuba lagi';

  @override
  String get groupDissolve => 'Bubarkan kumpulan';

  @override
  String get groupDissolveConfirm =>
      'Bubarkan kumpulan ini? Semua ahli akan dikeluarkan.';

  @override
  String get groupDissolveSuccess => 'Kumpulan dibubarkan';

  @override
  String get groupDissolveFailed => 'Gagal membubarkan, cuba lagi';

  @override
  String get groupQrCode => 'Kod QR kumpulan';

  @override
  String get groupMuteAll => 'Senyapkan semua';

  @override
  String get groupMuteAllOn => 'Dayakan senyapkan semua';

  @override
  String get groupMuteAllOff => 'Lumpuhkan senyapkan semua';

  @override
  String get groupAllowMemberInvite => 'Benarkan ahli menjemput';

  @override
  String get groupAllowMemberModifyTitle =>
      'Benarkan ahli menukar nama kumpulan';

  @override
  String get groupAllowMemberAtAll => 'Benarkan ahli menyebut @Semua';

  @override
  String get groupAllowMemberViewMemberList =>
      'Benarkan ahli melihat senarai ahli';

  @override
  String get groupAllowQrCodeJoin => 'Benarkan penyertaan melalui kod QR';

  @override
  String get groupRequireApproval => 'Perlukan kelulusan untuk menyertai';

  @override
  String get groupAllowMemberAddFriend =>
      'Benarkan ahli menambah satu sama lain';

  @override
  String get groupRoleOwner => 'Pemilik';

  @override
  String get groupRoleAdmin => 'Pentadbir';

  @override
  String get groupRoleMember => 'Ahli';

  @override
  String get groupNoMembers => 'Tiada ahli';

  @override
  String get groupNoAnnouncements => 'Tiada pengumuman';

  @override
  String get groupCreateAnnouncement => 'Siarkan pengumuman';

  @override
  String get groupEditAnnouncement => 'Sunting pengumuman';

  @override
  String get groupDeleteAnnouncement => 'Padam pengumuman';

  @override
  String get groupDeleteAnnouncementConfirm => 'Padam pengumuman ini?';

  @override
  String get groupAnnouncementTitle => 'Tajuk';

  @override
  String get groupAnnouncementContent => 'Kandungan';

  @override
  String get groupAnnouncementPin => 'Pin pengumuman';

  @override
  String groupMemberCount(int count) {
    return '$count ahli';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get groupJoinRequestApprove => 'Setuju';

  @override
  String get groupJoinRequestReject => 'Tolak';

  @override
  String get groupJoinRequests => 'Permohonan menyertai';

  @override
  String get groupNoJoinRequests => 'Tiada permohonan menyertai';

  @override
  String get groupReadReceipts => 'Resit baca';

  @override
  String groupReadCount(int count) {
    return '$count telah membaca';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count belum dibaca';
  }

  @override
  String get friendAddTitle => 'Tambah kenalan';

  @override
  String get friendSearchHint => 'Telefon / E-mel / ID StartLink';

  @override
  String get friendRequestSent => 'Permintaan rakan dihantar';

  @override
  String get friendRequestFailed => 'Gagal menghantar, cuba lagi';

  @override
  String get friendAlreadyFriend => 'Sudah menjadi kenalan';

  @override
  String get friendNewFriendsTitle => 'Rakan baharu';

  @override
  String get friendNoRequests => 'Tiada permintaan rakan';

  @override
  String get friendAccept => 'Terima';

  @override
  String get friendReject => 'Tolak';

  @override
  String get friendAccepted => 'Diterima';

  @override
  String get friendRejected => 'Ditolak';

  @override
  String get friendDeleteConfirm => 'Padam kenalan ini?';

  @override
  String get friendDeleteSuccess => 'Kenalan dipadam';

  @override
  String get friendDeleteFailed => 'Gagal memadam, cuba lagi';

  @override
  String get friendRemarkName => 'Nama panggilan';

  @override
  String get friendGroupName => 'Kumpulan';

  @override
  String get friendSendMessage => 'Mesej';

  @override
  String get friendMatchTypeLppId => 'Dipadankan melalui ID StartLink';

  @override
  String get friendMatchTypeMobile => 'Dipadankan melalui telefon';

  @override
  String get friendMatchTypeEmail => 'Dipadankan melalui e-mel';

  @override
  String get friendSearchEmpty => 'Tiada pengguna ditemui';

  @override
  String get friendAddMessage => 'Saya ingin menambah anda sebagai kenalan';

  @override
  String get friendBlockConfirm => 'Sekat pengguna ini?';

  @override
  String get friendUnblockConfirm => 'Nyahsekat pengguna ini?';

  @override
  String get friendBlockSuccess => 'Disekat';

  @override
  String get friendUnblockSuccess => 'Dinyahsekat';

  @override
  String get profilePageTitle => 'Maklumat Peribadi';

  @override
  String get profilePageSendMessage => 'Mesej';

  @override
  String get profilePageAddFriend => 'Tambah rakan';

  @override
  String get profilePageAlreadyFriend => 'Sudah berkawan';

  @override
  String get profilePageBlocked => 'Disekat';

  @override
  String get profilePageBlock => 'Sekat';

  @override
  String get profilePageUnblock => 'Nyahsekat';

  @override
  String get profilePageHidden => 'Pengguna ini menyembunyikan profil mereka';

  @override
  String get profilePageFriendsOnly =>
      'Pengguna ini hanya menunjukkan profil kepada rakan';

  @override
  String get profilePageLppId => 'ID StartLink';

  @override
  String get profilePageRemarkName => 'catatan';

  @override
  String get profilePageEditRemark => 'Sunting nama panggilan';

  @override
  String get profilePageSaveRemarkSuccess => 'Nama panggilan disimpan';

  @override
  String get profilePageSaveRemarkFailed => 'Gagal menyimpan, cuba lagi';

  @override
  String get searchTitle => 'cari';

  @override
  String get searchHint => 'Cari menggunakan telefon, e-mel atau ID StartLink';

  @override
  String get searchNoResults => 'Tiada hasil ditemui';

  @override
  String get searchMessages => 'Mesej';

  @override
  String get searchUsers => 'Pengguna';

  @override
  String get searchFailed => 'Carian gagal, cuba lagi';

  @override
  String get scanTitle => 'Imbas';

  @override
  String get scanFailed => 'Pengecaman gagal, cuba lagi';

  @override
  String get scanInvalidQrCode => 'Kod QR tidak sah';

  @override
  String get scanFlashOn => 'Hidupkan lampu suluh';

  @override
  String get scanFlashOff => 'Matikan lampu suluh';

  @override
  String get scanAlbum => 'Pilih daripada album';

  @override
  String get favoritesTitle => 'Kegemaran';

  @override
  String get favoritesEmpty => 'Tiada disimpan';

  @override
  String get favoritesAll => 'Semua';

  @override
  String get favoritesText => 'teks';

  @override
  String get favoritesImage => 'Imej';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Suara';

  @override
  String get favoritesFile => 'Fail';

  @override
  String get favoritesOther => 'Lain-lain';

  @override
  String get favoritesDeleteConfirm => 'Padam daripada kegemaran?';

  @override
  String get favoritesDeleteSuccess => 'Berjaya menghapus favorit';

  @override
  String get favoritesDeleteFailed => 'Gagal memadam';

  @override
  String get favoritesOriginalRecalled => 'Mesej ditarik balik';

  @override
  String get favoritesViewOriginal => 'Lihat asal';

  @override
  String get favoritesSearchHint => 'Cari kegemaran';

  @override
  String get favoritesNoResults => 'Tiada kegemaran yang sepadan';

  @override
  String get noticeTitle => 'Pengumuman';

  @override
  String get noticeEmpty => 'Tiada pengumuman';

  @override
  String get noticeDetail => 'Butiran pengumuman';

  @override
  String get noticePublishedAt => 'Diterbitkan';

  @override
  String get noticePriorityNormal => 'Biasa';

  @override
  String get noticePriorityImportant => 'Penting';

  @override
  String get noticePriorityUrgent => 'Segera';

  @override
  String get organizationTitle => 'Organisasi';

  @override
  String get organizationEmpty => 'Tiada maklumat jabatan';

  @override
  String get organizationMembers => 'Ahli';

  @override
  String get organizationDepartment => 'Jabatan';

  @override
  String get organizationPosition => 'Jawatan';

  @override
  String get organizationLeader => 'Ketua';

  @override
  String get qrCodeTitle => 'Kod QR saya';

  @override
  String get qrCodeSave => 'simpan ke album';

  @override
  String get qrCodeShare => 'Kongsi';

  @override
  String get qrCodeSaveSuccess => 'berjaya disimpan ke album';

  @override
  String get qrCodeSaveFailed => 'Gagal menyimpan, cuba lagi';

  @override
  String get qrCodeRefresh => 'Segarkan kod QR';

  @override
  String get qrCodeExpired => 'Kod QR tamat tempoh, sila segarkan';

  @override
  String get qrCodeScanToAdd => 'Imbas untuk menambah saya sebagai kenalan';

  @override
  String get spacePersonal => 'Peribadi';

  @override
  String get spaceEnterprise => 'Syarikat';

  @override
  String get spaceJoinByCode => 'Sertai dengan kod syarikat';

  @override
  String get spaceJoinByInvite => 'Sertai dengan kod jemputan';

  @override
  String get spaceEnterCode => 'Masukkan kod syarikat';

  @override
  String get spaceEnterInviteCode => 'Masukkan kod jemputan';

  @override
  String get spaceSearchEnterprise => 'Cari syarikat';

  @override
  String get spaceJoinRequestSent => 'Permohonan dihantar, menunggu kelulusan';

  @override
  String get spaceJoinRequestPending => 'Menunggu kelulusan';

  @override
  String get spaceJoinRequestApproved => 'Permohonan diluluskan';

  @override
  String get spaceJoinRequestRejected => 'Permohonan ditolak';

  @override
  String get spaceAlreadyMember => 'Anda sudah menjadi ahli';

  @override
  String get spaceAutoApproved =>
      'Diluluskan secara automatik. Selamat datang!';

  @override
  String get spacePendingApprovalHint =>
      'Pendaftaran berjaya. Permohonan anda untuk menyertai telah dihantar.';

  @override
  String get spaceNoSpaces => 'Tiada ruang';

  @override
  String get spaceInviteExpired => 'Kod jemputan tamat tempoh';

  @override
  String get spaceInviteTargetMismatch =>
      'Kod jemputan ini bukan untuk akaun anda';

  @override
  String get spaceAcceptInviteSuccess => 'Berjaya menyertai syarikat';

  @override
  String get spaceAcceptInviteFailed => 'Gagal menyertai, cuba lagi';

  @override
  String get spaceTenantSelectTitle => 'Pilih ruang';

  @override
  String get spaceTenantSelectHint => 'Pilih ruang untuk dimasuki';

  @override
  String get spaceEnterPersonal => 'Masuk ruang peribadi';

  @override
  String get spaceEnterEnterprise => 'Masuk ruang syarikat';

  @override
  String get aboutTitle => 'Tentang StartLink';

  @override
  String get aboutVersion => 'Versi';

  @override
  String get aboutTerms => 'Perjanjian Pengguna';

  @override
  String get aboutPrivacy => 'Dasar Privasi';

  @override
  String get aboutOpenSource => 'Lesen sumber terbuka';

  @override
  String get aboutCheckUpdate => 'Semak kemas kini';

  @override
  String get aboutLatestVersion => 'Sudah versi terkini';

  @override
  String get aboutUpdateAvailable => 'Versi baru ditemui';

  @override
  String get aboutUpdateNow => 'Kemas kini sekarang';

  @override
  String get aboutUpdateLater => 'Kemudian';

  @override
  String get notificationTitle => 'Pemberitahuan';

  @override
  String get notificationGlobalMute => 'Jangan ganggu';

  @override
  String get notificationSound => 'Suara';

  @override
  String get notificationVibration => 'Getaran';

  @override
  String get notificationPreview => 'Pratonton mesej';

  @override
  String get notificationDndStart => 'Waktu mula jangan ganggu';

  @override
  String get notificationDndEnd => 'Waktu tamat jangan ganggu';

  @override
  String get blacklistTitle => 'Senarai Hitam';

  @override
  String get blacklistEmpty => 'Tiada pengguna disekat';

  @override
  String get blacklistRemove => 'Nyahsekat';

  @override
  String get blacklistRemoveConfirm => 'Nyahsekat pengguna ini?';

  @override
  String get feedbackTitle => 'Maklum Balas';

  @override
  String get feedbackTypeComplaint => 'Aduan';

  @override
  String get feedbackTypeSuggestion => 'Cadangan';

  @override
  String get feedbackTypeBug => 'Laporan pepijat';

  @override
  String get feedbackContent => 'Penerangan';

  @override
  String get feedbackContentHint =>
      'Terangkan masalah atau cadangan anda dengan terperinci';

  @override
  String get feedbackContact => 'Maklumat hubungan (pilihan)';

  @override
  String get feedbackSubmit => 'Hantar';

  @override
  String get feedbackSuccess => 'Maklum balas dihantar. Terima kasih!';

  @override
  String get feedbackFailed => 'Penghantaran gagal, cuba lagi';

  @override
  String get networkTitle => 'Tukar Saluran';

  @override
  String get networkAutoSelect => 'Automatik';

  @override
  String get networkManual => 'Manual';

  @override
  String get timezoneTitle => 'Zon waktu';

  @override
  String get timezoneAuto => 'Ikut sistem';

  @override
  String get autoTranslateTitle => 'Terjemahan automatik';

  @override
  String get autoTranslateEnabled => 'Dayakan terjemahan automatik';

  @override
  String get autoTranslateLanguage => 'Bahasa sasaran';

  @override
  String get displayTitle => 'Paparan';

  @override
  String get displayFontSize => 'saiz fon';

  @override
  String get displayChatBackground => 'Latar sembang';

  @override
  String get displayDarkMode => 'Rupa';

  @override
  String get displayDarkModeSystem => 'Ikut sistem';

  @override
  String get displayDarkModeSystemHint =>
      'Tukar secara automatik mengikut tetapan sistem';

  @override
  String get displayDarkModeOff => 'Cerah';

  @override
  String get displayDarkModeOffHint => 'Sentiasa gunakan tema cerah';

  @override
  String get displayDarkModeOn => 'Gelap';

  @override
  String get displayDarkModeOnHint => 'Sentiasa gunakan tema gelap';

  @override
  String get chatSettingsTitle => 'Sembang';

  @override
  String get chatHistoryTitle => 'Sejarah sembang';

  @override
  String get chatHistoryClear => 'Padam semua sejarah';

  @override
  String get chatHistoryClearConfirm =>
      'Padam semua sejarah sembang? Tindakan ini tidak dapat dibuat asal.';

  @override
  String get chatHistoryClearSuccess => 'Sejarah sembang dipadam';

  @override
  String get accountSecurityTitle => 'Keselamatan akaun';

  @override
  String get accountSecurityChangePassword => 'Ubah kata laluan';

  @override
  String get accountSecurityChangeMobile => 'Tukar Nombor Telefon';

  @override
  String get accountSecurityChangeEmail => 'Tukar e-mel';

  @override
  String get accountSecurityLoggedDevices => 'Peranti yang dilog masuk';

  @override
  String get accountSecurityDeactivate => 'Tutup akaun';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Semua data akan dipadam secara kekal selepas 7 hari. Tutup akaun?';

  @override
  String get loggedDevicesTitle => 'Peranti yang dilog masuk';

  @override
  String get loggedDevicesCurrent => 'Peranti ini';

  @override
  String get loggedDevicesRevoke => 'Log keluar';

  @override
  String get loggedDevicesRevokeConfirm => 'Log keluar daripada peranti ini?';

  @override
  String get loggedDevicesRevokeSuccess => 'Telah log keluar daripada peranti';

  @override
  String get loggedDevicesRevokeFailed => 'Gagal, cuba lagi';

  @override
  String get loggedDevicesLastActive => 'Kali terakhir aktif';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Desktop';

  @override
  String get loggedDevicesTypeUnknown => 'Peranti tidak diketahui';

  @override
  String get privacySettingsTitle => 'Privasi';

  @override
  String get privacySearchableByMobile =>
      'Benarkan carian menggunakan nombor telefon';

  @override
  String get privacySearchableByLppId =>
      'Benarkan carian menggunakan ID StartLink';

  @override
  String get privacyAllowFriendRequest => 'Benarkan permintaan rakan';

  @override
  String get privacyProfileVisibility => 'Keterlihatan profil';

  @override
  String get privacyEveryone => 'Semua orang';

  @override
  String get privacyFriendsOfFriends => 'Rakan kepada rakan';

  @override
  String get privacyNobody => 'Tiada sesiapa';

  @override
  String get privacyFriendsOnly => 'Rakan sahaja';

  @override
  String get privacySaveSuccess => 'Tetapan disimpan';

  @override
  String get privacySaveFailed => 'Gagal menyimpan, cuba lagi';

  @override
  String get fontSizeTitle => 'saiz fon';

  @override
  String get fontSizeSmall => 'Kecil';

  @override
  String get fontSizeNormal => 'Standard';

  @override
  String get fontSizeLarge => 'Besar';

  @override
  String get fontSizeExtraLarge => 'Sangat Besar';

  @override
  String get fontSizePreview => 'Pratonton';

  @override
  String get chatBackgroundTitle => 'Latar sembang';

  @override
  String get chatBackgroundDefault => 'Lalai';

  @override
  String get chatBackgroundCustom => 'Tersuai';

  @override
  String get chatBackgroundReset => 'Pulihkan Lalai';

  @override
  String get termsTitle => 'Perjanjian Pengguna';

  @override
  String get privacyPolicyTitle => 'Dasar Privasi';

  @override
  String get recentContactsTitle => 'Terkini';

  @override
  String get recentContactsEmpty => 'Tiada kenalan terkini';

  @override
  String get inviteFriendsTitle => 'Jemput rakan';

  @override
  String get inviteFriendsCopyLink => 'Salin pautan jemputan';

  @override
  String get inviteFriendsLinkCopied => 'Pautan jemputan disalin';

  @override
  String get imageViewerTitle => 'Foto';

  @override
  String get imageViewerSave => 'simpan ke album';

  @override
  String get imageViewerSaveSuccess => 'berjaya disimpan ke album';

  @override
  String get imageViewerSaveFailed => 'Gagal menyimpan, cuba lagi';

  @override
  String get customerServiceTitle => 'Meja khidmat';

  @override
  String get customerServiceQueue => 'Dalam baris gilir';

  @override
  String get customerServiceActive => 'Aktif';

  @override
  String get customerServiceClaim => 'Terima';

  @override
  String get customerServiceTakeover => 'Ambil alih';

  @override
  String get customerServiceClose => 'Tamatkan perkhidmatan';

  @override
  String get customerServiceCloseConfirm => 'Tamatkan sesi perkhidmatan ini?';

  @override
  String get customerServiceNoQueue => 'Tiada sesi dalam baris gilir';

  @override
  String get customerServiceNoActive => 'Tiada sesi aktif';

  @override
  String get customerServiceVisitor => 'Pelawat';

  @override
  String get customerServiceCustomer => 'Pelanggan';

  @override
  String get customerServiceAssignedTo => 'Ditugaskan kepada';

  @override
  String get customerServiceTransferConversation => 'Pindahkan sembang';

  @override
  String get marketingToolbar => 'Alat pemasaran';

  @override
  String get callIncoming => 'Panggilan masuk';

  @override
  String get callOutgoing => 'Panggilan keluar';

  @override
  String get callAccept => 'Terima';

  @override
  String get callReject => 'Tolak';

  @override
  String get callHangup => 'Tamatkan';

  @override
  String get callMissed => 'Panggilan tidak dijawab';

  @override
  String get callDuration => 'Tempoh';

  @override
  String get callAudio => 'Panggilan suara';

  @override
  String get callGeneric => 'Panggilan';

  @override
  String get callVideo => 'Panggilan video';

  @override
  String get callConnecting => 'Menyambung...';

  @override
  String get callRinging => 'Berdering...';

  @override
  String get callEnded => 'Panggilan tamat';

  @override
  String get callFailed => 'Panggilan gagal';

  @override
  String get callRejected => 'Panggilan ditolak';

  @override
  String get callTimeout => 'Tiada jawapan';

  @override
  String get callCancelled => 'Dibatalkan';

  @override
  String get callUnknownPeer => 'Tidak Diketahui';

  @override
  String get callVideoInvitation => 'Jemputan panggilan video';

  @override
  String get callAudioInvitation => 'Jemputan panggilan suara';

  @override
  String get callAnswerAudio => 'Jawab dengan suara';

  @override
  String get callAnswerVideo => 'Jawab dengan video';

  @override
  String get callViewProfile => 'Lihat profil';

  @override
  String get callOpeningCamera => 'Membuka kamera...';

  @override
  String get callWaitingRemoteVideo => 'Menunggu video pihak satu lagi...';

  @override
  String get callCameraOff => 'Kamera dimatikan';

  @override
  String get callCameraOn => 'Kamera dihidupkan';

  @override
  String get callMicrophoneOff => 'Mikrofon dimatikan';

  @override
  String get callMicrophoneOn => 'Mikrofon dihidupkan';

  @override
  String get callSpeakerOff => 'Pembesar suara dimatikan';

  @override
  String get callSpeakerOn => 'Pembesar suara dihidupkan';

  @override
  String get callVideoPermissionFailure =>
      'Tidak dapat memulakan panggilan video. Semak kebenaran kamera dan mikrofon, kemudian cuba lagi.';

  @override
  String get callAudioPermissionFailure =>
      'Tidak dapat memulakan panggilan suara. Semak kebenaran mikrofon dan cuba lagi.';

  @override
  String get callIncompleteIncoming =>
      'Maklumat panggilan masuk tidak lengkap dan panggilan tidak dapat dijawab.';

  @override
  String get callInProgress => 'Dalam panggilan';

  @override
  String get callCalling => 'Memanggil...';

  @override
  String callEndedMedia(String media) {
    return '$media tamat';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media ditolak';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media tidak dijawab';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media dibatalkan';
  }

  @override
  String get callConnectionLost => 'Sambungan panggilan terputus';

  @override
  String get callAdminEnded => 'Panggilan ditamatkan oleh pentadbir';

  @override
  String callFailedMedia(String media) {
    return '$media gagal';
  }

  @override
  String get callBusy => 'Pihak satu lagi sibuk';

  @override
  String callDurationValue(String duration) {
    return 'Tempoh panggilan $duration';
  }

  @override
  String get callNotConnected => 'Belum bersambung';

  @override
  String get callDialed => 'Keluar';

  @override
  String get callAnswered => 'Dijawab';

  @override
  String get callRejectedByPeer => 'Ditolak oleh pihak satu lagi';

  @override
  String get callRejectedBySelf => 'Ditolak';

  @override
  String get callPeerDidNotAnswer => 'Pihak satu lagi tidak menjawab';

  @override
  String get callMissedIncoming => 'Panggilan masuk tidak dijawab';

  @override
  String get callPeerCancelled => 'Dibatalkan oleh pihak satu lagi';

  @override
  String get notificationNewMessageTitle => 'Mesej StartLink baharu';

  @override
  String get notificationOnlineServiceTitle => 'Mesej khidmat pelanggan baharu';

  @override
  String get notificationNewMessageBody => 'Anda menerima mesej baharu';

  @override
  String get notificationImagePreview => 'Menghantar imej';

  @override
  String get notificationVideoPreview => 'Menghantar video';

  @override
  String get notificationVoicePreview => 'Menghantar mesej suara';

  @override
  String get notificationFilePreview => 'Menghantar fail';

  @override
  String get notificationContactPreview => 'Menghantar kad kenalan';

  @override
  String get notificationCallLogPreview => 'Menghantar rekod panggilan';

  @override
  String get notificationLocationPreview => 'Berkongsi lokasi';

  @override
  String get notificationLinkPreview => 'Berkongsi pautan';

  @override
  String notificationMentionMe(String body) {
    return 'Menyebut anda: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender menyebut anda: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Menyebut semua orang: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender menyebut semua orang: $body';
  }

  @override
  String get notificationSecurityTitle => 'Amaran keselamatan akaun';

  @override
  String get notificationSecurityBody =>
      'Tetapan keselamatan akaun StartLink anda telah berubah. Semak sekarang.';

  @override
  String get notificationFriendAcceptedTitle => 'Permintaan rakan diterima';

  @override
  String get notificationFriendRejectedTitle => 'Permintaan rakan ditolak';

  @override
  String get notificationFriendAcceptedBody =>
      'Pihak satu lagi menerima permintaan rakan anda';

  @override
  String get notificationFriendRejectedBody =>
      'Pihak satu lagi menolak permintaan rakan anda';

  @override
  String get notificationVideoCallTitle => 'Jemputan panggilan video';

  @override
  String get notificationAudioCallTitle => 'Jemputan panggilan suara';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller menjemput anda ke panggilan video';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller menjemput anda ke panggilan suara';
  }

  @override
  String get notificationMessageChannelName => 'Mesej';

  @override
  String get notificationMessageChannelDescription =>
      'Mesej sembang, rekod panggilan dan amaran sistem';

  @override
  String get notificationCallChannelName => 'Panggilan';

  @override
  String get notificationCallChannelDescription =>
      'Amaran panggilan suara dan video';

  @override
  String get notificationSecurityChannelName => 'Keselamatan akaun';

  @override
  String get notificationSecurityChannelDescription =>
      'Amaran log masuk serta perubahan kata laluan dan nombor telefon mudah alih';

  @override
  String get notificationUnknownCaller => 'Pemanggil tidak diketahui';

  @override
  String get pendingJoinRequestsTitle => 'Permohonan baharu';

  @override
  String get pendingJoinRequestsEmpty => 'Tiada permohonan';

  @override
  String get pendingJoinRequestApprove => 'Setuju';

  @override
  String get pendingJoinRequestReject => 'Tolak';

  @override
  String get pendingJoinRequestApproveSuccess => 'Diluluskan';

  @override
  String get pendingJoinRequestRejectSuccess => 'Ditolak';

  @override
  String get pendingJoinRequestFailed => 'Operasi gagal, cuba lagi';

  @override
  String get myCustomersTitle => 'Pelanggan saya';

  @override
  String get myCustomersEmpty => 'Tiada pelanggan';

  @override
  String get groupListTitle => 'Kumpulan';

  @override
  String get groupListEmpty => 'Tiada kumpulan';

  @override
  String get addFriendTitle => 'Tambah kenalan';

  @override
  String get addFriendSearchHint => 'Telefon / E-mel / ID StartLink';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String get addFriendButton => 'Tambah';

  @override
  String get addFriendCannotAddSelf => 'Anda tidak boleh menambah diri sendiri';

  @override
  String get addFriendUnsupportedUser =>
      'Pengguna ini tidak boleh ditambah. Anda boleh menghantar mesej terus kepada mereka.';

  @override
  String get addFriendMessageHint => 'Masukkan mesej';

  @override
  String get addFriendSendRequest => 'Hantar permintaan';

  @override
  String get joinCompanyTitle => 'Sertai syarikat';

  @override
  String get joinCompanyCodeHint => 'Masukkan kod syarikat';

  @override
  String get joinCompanySearchHint => 'Cari nama syarikat';

  @override
  String get joinCompanyApply => 'Mohon menyertai';

  @override
  String get joinCompanyApplySuccess => 'Permohonan dihantar';

  @override
  String get joinCompanyApplyFailed => 'Gagal memohon, cuba lagi';

  @override
  String get joinCompanyAutoApproved =>
      'Diluluskan secara automatik. Selamat datang!';

  @override
  String get joinCompanyPending => 'Permohonan dihantar, menunggu kelulusan';

  @override
  String get joinCompanyInviteCodeHint => 'Masukkan kod jemputan';

  @override
  String get joinCompanyAcceptInvite => 'Terima jemputan';

  @override
  String get joinCompanyNoResults => 'Tiada syarikat ditemui';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count ahli';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Waktu Pasifik';

  @override
  String get timezoneNameMountainTime => 'Waktu Pergunungan';

  @override
  String get timezoneNameCentralTime => 'Waktu Tengah';

  @override
  String get timezoneNameEasternTime => 'Waktu Timur';

  @override
  String get timezoneNameAtlanticTime => 'Waktu Atlantik';

  @override
  String get timezoneNameBrasilia => 'Brasilia';

  @override
  String get timezoneNameAzores => 'Azores';

  @override
  String get timezoneNameLondonDublin => 'London/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Paris/Rom';

  @override
  String get timezoneNameCairoHelsinki => 'Kaherah/Helsinki';

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
  String get timezoneNameSolomonIslands => 'Kepulauan Solomon';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute =>
      'Pilih laluan terbaik secara pintar';

  @override
  String get networkTesting => 'Menguji...';

  @override
  String get networkTestingShort => 'Menguji';

  @override
  String networkLatencyMs(int ms) {
    return 'Kependaman ${ms}ms';
  }

  @override
  String get networkConnectionMode => 'Mod sambungan';

  @override
  String get networkDirectMode => 'Mod terus';

  @override
  String get networkProxyMode => 'Mod proksi';

  @override
  String get networkDirectModeDesc => 'Sambung terus ke pelayan';

  @override
  String get networkProxyModeDesc => 'Sambung melalui pelayan proksi';

  @override
  String get networkDirectRoutes => 'Laluan terus';

  @override
  String get networkProxyRoutes => 'Laluan proksi';

  @override
  String get networkTestAll => 'Uji semua';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Nod Hong Kong';

  @override
  String get networkSingaporeNode => 'Nod Singapura';

  @override
  String get networkJapanNode => 'Nod Jepun';

  @override
  String get networkUnitedStatesNode => 'Nod Amerika Syarikat';

  @override
  String get networkHint =>
      'Petua:\n• Mod terus: lebih pantas dan sesuai untuk kegunaan domestik\n• Mod proksi: lebih stabil untuk komunikasi rentas sempadan\n• Ketik ikon segar semula untuk menguji kependaman satu laluan';

  @override
  String get teenModeTitle => 'Mod remaja';

  @override
  String get teenModeStatusOn => 'Telah Dihidupkan';

  @override
  String get teenModeStatusOff => 'Dimatikan';

  @override
  String get teenModeStatusLoading => 'Memuatkan';

  @override
  String get teenModeUnavailable =>
      'Status mod remaja tidak tersedia buat sementara waktu';

  @override
  String get teenModeInvalidResponse =>
      'Mod remaja mengembalikan respons tidak sah';

  @override
  String get teenModeEnableDescription =>
      'Peraturan platform akan mengehadkan masa penggunaan dan ciri tertentu.';

  @override
  String get teenModePasscode => 'Kod laluan';

  @override
  String get teenModeCurrentPasscode => 'Kod laluan semasa';

  @override
  String get teenModeNewPasscode => 'Kod laluan baharu';

  @override
  String get teenModePasscodeHint => 'Masukkan 4–6 digit';

  @override
  String get teenModeEnable => 'Hidupkan mod remaja';

  @override
  String get teenModeDisable => 'Matikan mod remaja';

  @override
  String get teenModeChangePasscode => 'Tukar kod laluan';

  @override
  String get teenModeSource => 'Didayakan oleh';

  @override
  String get teenModeDailyUsage => 'Digunakan hari ini';

  @override
  String get teenModeRemaining => 'Baki masa';

  @override
  String get teenModeMinutesUnit => 'Minit';

  @override
  String get teenModeUnlimited => 'Tanpa had';

  @override
  String get teenModeRequestExtension => 'Minta masa tambahan';

  @override
  String get teenModeExtensionSubmitted =>
      'Permintaan masa dihantar kepada penjaga';

  @override
  String get teenModeTimeLimitReached =>
      'Had penggunaan hari ini telah dicapai';

  @override
  String get teenModeCurfewActive => 'Ini ialah tempoh penggunaan terhad';

  @override
  String get teenModeReliefHint =>
      'Anda masih boleh melihat sejarah, menghubungi sokongan rasmi dan melaporkan masalah.';

  @override
  String get teenModeRestrictedNotice =>
      'Mod remaja sedang menyekat penghantaran mesej';

  @override
  String get teenModeActionBlocked => 'Mod remaja sedang menyekat tindakan ini';

  @override
  String get teenModeMyRequests => 'Permintaan saya';

  @override
  String get guardianCenterTitle => 'Pusat penjaga';

  @override
  String get guardianRelationships => 'Hubungan penjagaan';

  @override
  String get guardianMinors => 'Anak di bawah pengawasan saya';

  @override
  String get guardianApprovals => 'Menunggu kelulusan';

  @override
  String get guardianBind => 'Masukkan kod pemautan';

  @override
  String get guardianCreateMinorCode => 'Saya anak — cipta kod';

  @override
  String get guardianCreateGuardianCode => 'Saya penjaga — cipta kod';

  @override
  String get guardianRelation => 'Hubungan';

  @override
  String get guardianPrimary => 'Penjaga utama';

  @override
  String get guardianCode => 'Kod pemautan 6 digit';

  @override
  String get guardianCodeHint =>
      'Masukkan kod yang diberikan oleh pihak satu lagi';

  @override
  String get guardianCodeCreated => 'Kod dicipta. Kongsi sebelum tamat tempoh.';

  @override
  String get guardianEmpty => 'Tiada hubungan penjagaan';

  @override
  String get guardianNoMinors => 'Tiada anak di bawah pengawasan';

  @override
  String get guardianUnbind => 'Buang hubungan';

  @override
  String get guardianExtend => 'Tambah masa untuk anak';

  @override
  String get guardianPolicyTitle => 'Peraturan penggunaan';

  @override
  String get guardianPolicyLocked => 'Dikunci oleh platform';

  @override
  String get approvalEmpty => 'Tiada permintaan';

  @override
  String get approvalApprove => 'Setuju';

  @override
  String get approvalReject => 'Tolak';

  @override
  String get approvalPending => 'Menunggu';

  @override
  String get approvalApproved => 'Diluluskan';

  @override
  String get approvalRejected => 'Ditolak';

  @override
  String get approvalExpired => 'Tamat';

  @override
  String get approvalCancelled => 'Dibatalkan';

  @override
  String get approvalReplayFailed => 'Tindakan asal gagal. Sila cuba lagi.';

  @override
  String get requestCancelled => 'Permintaan dibatalkan';

  @override
  String get kycTitle => 'Pengesahan Nama Sebenar';

  @override
  String get kycNotRequired => 'Pengesahan identiti tidak diperlukan';

  @override
  String get kycVerified => 'Identiti disahkan';

  @override
  String get kycDeclared => 'Maklumat identiti dihantar';

  @override
  String get kycPending => 'Sedang disemak';

  @override
  String get kycRejected => 'Semakan ditolak';

  @override
  String get kycNone => 'Tiada maklumat identiti dihantar';

  @override
  String get kycRealName => 'Nama Sebenar';

  @override
  String get kycIdNumber => 'nombor kad pengenalan';

  @override
  String get kycIdType => 'Jenis dokumen';

  @override
  String get kycApplicability =>
      'Masukkan butiran sebenar bagi dokumen yang dipilih. Jenis yang diterima dipaparkan dalam senarai.';

  @override
  String get kycCamera => 'Ambil Gambar';

  @override
  String get kycGallery => 'Pilih daripada galeri';

  @override
  String get kycPhotoLimit => 'Maksimum setiap foto';

  @override
  String get kycSelectPhoto => 'Pilih Gambar';

  @override
  String get kycPhotoSelected => 'Dipilih';

  @override
  String get kycViewPhoto => 'Ketik untuk melihat foto';

  @override
  String get kycReplacePhoto => 'Pilih foto lain';

  @override
  String get kycDisclosure =>
      'Kami menggunakan nama, nombor dokumen dan foto dokumen anda untuk menyemak identiti anda. Tanpa maklumat ini, anda tidak boleh menghantar permohonan dan sesetengah ciri terhad mungkin tidak tersedia.';

  @override
  String get kycConsent =>
      'Saya memberikan persetujuan berasingan untuk pemprosesan maklumat identiti ini';

  @override
  String get kycConsentRequired =>
      'Sila berikan persetujuan berasingan sebelum menghantar';

  @override
  String get kycResubmitTitle => 'Hantar semula maklumat identiti';

  @override
  String get kycResubmitWarning =>
      'Penghantaran semula akan menggantikan permohonan yang menunggu semakan. Teruskan?';

  @override
  String get kycSubmitting => 'Menghantar';

  @override
  String get kycSubmitFailed => 'Penghantaran gagal. Cuba lagi.';

  @override
  String get kycSubmitUnavailable =>
      'Maklumat identiti tidak boleh dihantar sekarang';

  @override
  String get kycResubmitNotAllowed =>
      'Penghantaran semula tidak tersedia selepas penolakan. Hubungi sokongan jika perlu.';

  @override
  String get kycDailyLimit =>
      'Anda telah mencapai had penghantaran hari ini. Cuba esok.';

  @override
  String get kycTypeUnavailable =>
      'Tiada jenis dokumen tersedia. Cuba lagi nanti.';

  @override
  String get kycNameInvalid => 'Nama sah mesti mengandungi 2–64 aksara';

  @override
  String get kycNumberRequired => 'Masukkan nombor dokumen';

  @override
  String get kycFrontRequired => 'Muat naik bahagian hadapan dokumen';

  @override
  String get kycBackRequired => 'Muat naik bahagian belakang dokumen';

  @override
  String get kycPhotoTooLarge =>
      'Foto melebihi had saiz. Mampatkan dan cuba lagi.';

  @override
  String get kycAccountChanged =>
      'Akaun atau ruang berubah. Buka semula halaman ini.';

  @override
  String get kycPhotoInvalid => 'Pilih imej yang sah';

  @override
  String get kycPortraitSide => 'Muka Foto';

  @override
  String get kycEmblemSide => 'Muka Lambang Negara';

  @override
  String get kycPassportDataPage => 'Halaman data pasport';

  @override
  String get kycPassportOtherPage => 'Halaman visa atau halaman kosong pasport';

  @override
  String get kycFront => 'Muka depan kad pengenalan';

  @override
  String get kycBack => 'Belakang Kad Pengenalan';

  @override
  String get kycRequired =>
      'Pengesahan identiti diperlukan sebelum mencipta kumpulan';

  @override
  String get kycGoVerify => 'Sahkan sekarang';

  @override
  String get kycStatusUnknown =>
      'Status identiti tidak tersedia. Segarkan semula nanti.';

  @override
  String get kycSuperseded =>
      'Penghantaran yang lebih baharu telah menggantikan penghantaran ini. Semak status identiti terkini anda.';

  @override
  String get kycMediaNotFound =>
      'Foto dokumen tidak tersedia dalam ruang ini. Pilih semula sebelum menghantar.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Siaran pelanggan';

  @override
  String get officialAccountBadge => 'Rasmi';

  @override
  String get officialAccountOpenConversation => 'Buka perbualan';

  @override
  String get officialAccountJoinHint =>
      'Menambah akaun ini akan menyertakan anda dalam syarikat sebagai pelanggan. Kelulusan rakan tidak diperlukan.';

  @override
  String get officialAccountJoinDisabled =>
      'Syarikat ini tidak menerima pelanggan baharu. Sila hubungi sokongan.';

  @override
  String get officialAccountRemoved =>
      'Anda telah dikeluarkan daripada syarikat ini. Minta syarikat menjemput anda semula.';

  @override
  String get officialAccountBanned =>
      'Akaun anda telah dilumpuhkan dalam syarikat ini.';

  @override
  String get officialAccountUnavailable =>
      'Akaun rasmi ini tidak tersedia buat masa ini.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Menyertai syarikat tidak dibenarkan dalam mod semasa.';

  @override
  String get officialAccountPlatformRequired =>
      'Gunakan akaun platform untuk menambah akaun rasmi ini.';

  @override
  String get officialAccountOpenFailed =>
      'Perbualan tidak dapat dibuka. Sila cuba lagi.';

  @override
  String get officialAccountAccountChanged =>
      'Akaun atau ruang berubah. Sila buka semula.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Direktori syarikat belum dikemas kini. Sila cuba sebentar lagi.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Penyegerakan akaun rasmi gagal. Kandungan setempat masih tersedia.';

  @override
  String get officialAccountInboxSyncing => 'Menyegerakkan mesej akaun rasmi';

  @override
  String get diagnosticsTitle => 'Diagnostik';

  @override
  String get diagnosticsExplanation =>
      'Log telah disunting untuk privasi dan mengandungi maklumat operasi serta ralat bagi akaun dan ruang ini, bersama peristiwa permulaan awam. Kandungan sembang dan maklumat pengesahan tidak disertakan.';

  @override
  String get diagnosticsHour => 'Jam terakhir';

  @override
  String get diagnosticsDay => '24 jam terakhir';

  @override
  String get diagnosticsWeek => '7 hari terakhir';

  @override
  String diagnosticsEventCount(int count) {
    return 'Peristiwa tersedia: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Log disimpan pada peranti ini dan kekal tersedia selepas dimulakan semula.';

  @override
  String get diagnosticsNotPersistent =>
      'Sesetengah log belum disimpan. Segarkan semula untuk mencuba lagi.';

  @override
  String get diagnosticsExport => 'Eksport dan kongsi';

  @override
  String get diagnosticsRefresh => 'Muat Semula';

  @override
  String get diagnosticsClear => 'Padam log ruang ini';

  @override
  String get diagnosticsClearConfirm =>
      'Padam log diagnostik untuk ruang ini? Sejarah sembang akan dikekalkan.';

  @override
  String get diagnosticsShared =>
      'Perkongsian sistem selesai. Sahkan fail dalam aplikasi penerima.';

  @override
  String get diagnosticsCancelled =>
      'Perkongsian dibatalkan. Anda boleh mengeksport semula.';

  @override
  String get diagnosticsUnconfirmed =>
      'Perkongsian tidak dapat disahkan. Semak aplikasi penerima.';

  @override
  String get diagnosticsFailed => 'Operasi gagal. Sila cuba lagi.';
}
