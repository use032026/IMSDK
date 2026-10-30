// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get navWorkbench => 'Meja kerja';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Data akun gagal dimuat';

  @override
  String get startupFailureTitle => 'Gagal memulai';

  @override
  String get startupFailureMessage => 'Periksa jaringan lalu coba lagi';

  @override
  String get privacyConsentTitle => 'Ketentuan Layanan & Kebijakan Privasi';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Selamat datang di $brand. Untuk menyediakan login akun, pesan instan, kolaborasi perusahaan, layanan pelanggan daring, notifikasi pesan, dan perlindungan keamanan, kami perlu memproses informasi yang diperlukan sesuai Ketentuan Layanan dan Kebijakan Privasi.\n\nSebelum Anda mengetuk Setuju, kami tidak akan membaca papan klip, menginisialisasi JPush/JCore atau SDK push produsen perangkat, maupun menggunakan SDK tersebut untuk mengakses Android ID, OAID, daftar aplikasi terinstal, alamat MAC, atau informasi serupa. Jika Anda belum setuju, pilihan itu akan disimpan; Anda tetap dapat membaca dokumen dan memilih kembali nanti.\n\nSetelah Anda setuju, untuk mengirim notifikasi pesan, layanan pelanggan, dan panggilan masuk, JPush/JCore serta layanan push produsen perangkat dapat memproses model perangkat, versi Android, nama paket dan versi aplikasi, jenis jaringan, alamat IP, Android ID, OAID, Registration ID push, token push produsen, serta data penerimaan dan klik notifikasi. Kami telah menonaktifkan kemampuan yang tidak diperlukan, termasuk push cerdas, daftar aplikasi terinstal, MAC, IMEI, IMSI, daftar Wi-Fi, aktivasi otomatis, dan peluncuran terkait.\n\nPapan klip hanya diakses saat Anda menggunakan fungsi salin atau tempel. Izin kamera, mikrofon, notifikasi, dan izin sistem lainnya hanya diminta saat Anda menggunakan fitur terkait. Penolakan satu izin hanya memengaruhi fitur tersebut. Silakan baca dokumen lengkap di bawah lalu pilih apakah Anda setuju.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Selamat datang di $brand. Untuk menyediakan login akun, pesan instan, kolaborasi perusahaan, layanan pelanggan daring, notifikasi pesan, dan perlindungan keamanan, kami perlu memproses informasi yang diperlukan sesuai Ketentuan Layanan dan Kebijakan Privasi.\n\nSebelum Anda mengetuk Setuju, kami tidak akan membaca papan klip, menginisialisasi JPush/JCore, mendaftar ke Apple Push Notification service (APNs), maupun memperoleh pengenal push seperti Registration ID JPush atau token perangkat APNs. Jika Anda belum setuju, pilihan itu akan disimpan; Anda tetap dapat membaca dokumen dan memilih kembali nanti.\n\nSetelah Anda setuju, untuk mengirim notifikasi pesan, layanan pelanggan, dan panggilan masuk, kami dapat memproses model iPhone, versi iOS, nama paket dan versi aplikasi, jenis jaringan, alamat IP, IDFV, Registration ID JPush, token perangkat APNs, serta data penerimaan dan klik notifikasi. JPush/JCore menghubungkan ke layanan push; Apple APNs memproses pengenal aplikasi, token perangkat, dan isi notifikasi untuk mengirim notifikasi sistem. Aplikasi iOS saat ini tidak menggunakan layanan iklan atau mengambil IDFA.\n\nPapan klip hanya diakses saat Anda menggunakan fungsi salin atau tempel. Izin kamera, mikrofon, notifikasi, dan izin sistem lainnya hanya diminta saat Anda menggunakan fitur terkait. Penolakan satu izin hanya memengaruhi fitur tersebut. Silakan baca dokumen lengkap di bawah lalu pilih apakah Anda setuju.';
  }

  @override
  String get privacyConsentTermsLink => 'Perjanjian Pengguna';

  @override
  String get privacyConsentConjunction => 'dan';

  @override
  String get privacyConsentPrivacyLink => 'Kebijakan Privasi';

  @override
  String get privacyConsentDecline => 'Tidak Setuju';

  @override
  String get privacyConsentDeclinedExit =>
      'Anda belum menyetujui Ketentuan Layanan dan Kebijakan Privasi. Aplikasi akan ditutup.';

  @override
  String get privacyConsentAccept => 'Setuju';

  @override
  String get privacyConsentRuntimeFailure =>
      'Gagal memulai. Periksa jaringan lalu coba lagi.';

  @override
  String get privacyConsentSaveFailure =>
      'Pilihan tidak dapat disimpan. Coba lagi.';

  @override
  String get appUpdateRequiredTitle => 'Perbarui untuk melanjutkan';

  @override
  String get appUpdateOptionalTitle => 'Versi Baru Tersedia';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version tersedia';
  }

  @override
  String get appUpdateLater => 'Nanti';

  @override
  String get appUpdateNow => 'Perbarui Sekarang';

  @override
  String get appUpdateProcessing => 'Memproses...';

  @override
  String get appUpdateInvalidUrl =>
      'Alamat pembaruan tidak valid. Coba lagi nanti.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Tautan pembaruan tidak dapat dibuka. Coba lagi nanti.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Unduhan terputus. Periksa jaringan lalu coba lagi.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Verifikasi paket gagal. Unduh kembali.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Izinkan $brand menginstal pembaruan di pengaturan sistem.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Penginstal sistem tidak dapat dibuka. Periksa izin instalasi.';

  @override
  String get appUpdateGenericFailure =>
      'Pembaruan gagal. Periksa jaringan lalu coba lagi.';

  @override
  String get appUpdateUnavailable =>
      'Versi baru belum dapat diunduh. Coba lagi nanti.';

  @override
  String get appUpdateCheckFailed =>
      'Pembaruan tidak dapat diperiksa. Coba lagi nanti.';

  @override
  String get appUpdateChecking => 'Memeriksa';

  @override
  String get commonConfirm => 'Oke';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonSave => 'Simpan';

  @override
  String get commonEdit => 'Sunting';

  @override
  String get commonDelete => 'Hapus';

  @override
  String get commonSearch => 'Cari';

  @override
  String get commonLoading => 'Memuat...';

  @override
  String get commonLoadFailed => 'Gagal memuat';

  @override
  String get commonRetry => 'Coba Lagi';

  @override
  String get commonEmpty => 'Tidak Ada Data';

  @override
  String get commonCopy => 'Salin';

  @override
  String get commonForward => 'Teruskan';

  @override
  String get commonFavorite => 'Simpan';

  @override
  String get commonClose => 'Tutup';

  @override
  String get commonSend => 'Kirim';

  @override
  String get commonDone => 'Selesai';

  @override
  String get commonMore => 'Lainnya';

  @override
  String get commonSettings => 'Pengaturan';

  @override
  String get commonCopied => 'Disalin';

  @override
  String get commonUnknown => 'Tidak Diketahui';

  @override
  String get commonNotSet => 'Belum diatur';

  @override
  String get commonUnbound => 'Tidak Terhubung';

  @override
  String get commonViewAll => 'Lihat semua';

  @override
  String get commonSubmit => 'Kirim';

  @override
  String get commonAdd => 'Tambah';

  @override
  String get commonRemove => 'Hapus';

  @override
  String get commonCreate => 'Buat';

  @override
  String get commonUpdate => 'Perbarui';

  @override
  String get commonUpload => 'Unggah';

  @override
  String get commonShare => 'Bagikan';

  @override
  String get commonBlock => 'Blokir';

  @override
  String get commonUnblock => 'Buka blokir';

  @override
  String get commonMute => 'Bisukan';

  @override
  String get commonUnmute => 'Bunyikan';

  @override
  String get commonPin => 'Disematkan';

  @override
  String get commonUnpin => 'Lepas sematan';

  @override
  String get commonMarkRead => 'Tandai sudah dibaca';

  @override
  String get commonMarkUnread => 'Tandai belum dibaca';

  @override
  String get commonOnline => 'Daring';

  @override
  String get commonOffline => 'Luring';

  @override
  String get commonOperationFailed => 'Operasi gagal, coba lagi';

  @override
  String get commonNetworkError => 'Kesalahan jaringan, periksa koneksi Anda';

  @override
  String get navMessages => 'Pesan';

  @override
  String get navContacts => 'Kontak';

  @override
  String get navMe => 'Saya';

  @override
  String get authLoginTitle => 'Masuk ke StartLink';

  @override
  String get authTabMobile => 'Telepon';

  @override
  String get authTabEmail => 'Email';

  @override
  String get authTabLoginName => 'ID StartLink';

  @override
  String get authHintMobile => 'Masukkan nomor telepon';

  @override
  String get authHintEmail => 'Masukkan alamat email Anda';

  @override
  String get authHintPassword => 'Masukkan kata sandi';

  @override
  String get authHintCode => 'Masukkan kode verifikasi';

  @override
  String get authHintLoginName => 'Masukkan ID StartLink (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Masuk';

  @override
  String get authGetCode => 'Kirim Kode';

  @override
  String authResendCode(int seconds) {
    return 'Kirim ulang dalam $seconds dtk';
  }

  @override
  String get authUsePassword => 'Gunakan kata sandi';

  @override
  String get authUseCode => 'Gunakan kode verifikasi';

  @override
  String get authAgreementPrefix => 'Saya telah membaca dan menyetujui';

  @override
  String get authAgreementAnd => 'dan';

  @override
  String get authTermsLink => 'Perjanjian Pengguna';

  @override
  String get authPrivacyLink => 'Kebijakan Privasi';

  @override
  String get authCaptchaTitle => 'Verifikasi keamanan';

  @override
  String get authCaptchaHint => 'Masukkan jawaban';

  @override
  String get authCaptchaFailed => 'Captcha tidak dapat diperoleh, coba lagi';

  @override
  String get authErrorEmptyCode => 'Silakan masukkan kode verifikasi';

  @override
  String get authErrorEmptyPassword => 'Masukkan kata sandi';

  @override
  String get authErrorEmptyLoginName => 'Silakan masukkan ID StartLink';

  @override
  String get authErrorWrongCredentials => 'Akun atau kata sandi salah';

  @override
  String get authDeactivatingTitle => 'Penutupan akun';

  @override
  String get authDeactivatingContent =>
      'Akun Anda sedang dalam masa tunggu penutupan (7 hari).\n\nUntuk membatalkan penutupan, ketuk \"Batalkan penutupan\"; jika tidak, ketuk \"Lanjutkan\" untuk masuk ke aplikasi.';

  @override
  String get authContinueUse => 'Lanjutkan';

  @override
  String get authCancelDeactivation => 'Batalkan penutupan';

  @override
  String get authDeactivationCancelled =>
      'Penutupan dibatalkan, akun dipulihkan';

  @override
  String get authDeactivationCancelFailed => 'Pembatalan gagal, coba lagi';

  @override
  String get authLogout => 'Keluar';

  @override
  String get authLogoutConfirm => 'Yakin ingin keluar?';

  @override
  String get authSendingCode => 'Mengirim...';

  @override
  String get authCodeSent => 'Kode verifikasi berhasil dikirim';

  @override
  String get authLoginFailed => 'Gagal masuk, coba lagi';

  @override
  String get authRegisterFailed => 'Pendaftaran gagal, coba lagi';

  @override
  String get authEnterpriseCode => 'Kode perusahaan';

  @override
  String get authEnterpriseCodeHint => 'Masukkan kode perusahaan';

  @override
  String get authPendingApproval =>
      'Pendaftaran berhasil. Permintaan bergabung ke perusahaan telah dikirim dan menunggu persetujuan.';

  @override
  String get authNoAccount => 'Belum punya akun?';

  @override
  String get authRegisterNow => 'Daftar sekarang';

  @override
  String get authCountryPickerTitle => 'Pilih negara/wilayah';

  @override
  String get authCountrySearchHint => 'Cari negara/wilayah';

  @override
  String get authCountryChinaMainland => 'Tiongkok Daratan';

  @override
  String get authCountryHongKong => 'Hong Kong, Tiongkok';

  @override
  String get authCountryMacau => 'Makau, Tiongkok';

  @override
  String get authCountryTaiwan => 'Taiwan, Tiongkok';

  @override
  String get authCountryUnitedStates => 'Amerika Serikat';

  @override
  String get authCountryUnitedKingdom => 'Britania Raya';

  @override
  String get authCountryJapan => 'Jepang';

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
  String get authCountryFrance => 'Prancis';

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
  String get authQuickLoginTitle => 'Login cepat';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Sedang masuk. Mohon tunggu.';

  @override
  String get authRoleOwner => 'Pemilik';

  @override
  String get authRoleAdministrator => 'Administrator';

  @override
  String get authRoleCustomerService => 'Layanan pelanggan';

  @override
  String get authRoleTechnicalSupport => 'Dukungan teknis';

  @override
  String get authRoleEmployee => 'Karyawan';

  @override
  String get authRoleMember => 'Anggota';

  @override
  String get authRoleEnterpriseCustomer => 'Pelanggan perusahaan';

  @override
  String get authUnavailablePrefix => 'Tidak tersedia · ';

  @override
  String get authUnassignedService => 'Belum ada agen yang ditugaskan';

  @override
  String authAssignedService(String staff) {
    return 'Ditugaskan ke $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Pelanggan · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Karyawan · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count pengguna';
  }

  @override
  String get authMetaPhone => 'Telepon';

  @override
  String get authMetaIdentity => 'Identitas';

  @override
  String get authRegisterTitle => 'Daftar';

  @override
  String get authNickname => 'Nama Panggilan';

  @override
  String get authNicknameHint => 'Atur nama panggilan';

  @override
  String get authPassword => 'Kata Sandi';

  @override
  String get authPasswordSetHint => 'Atur kata sandi (minimal 6 karakter)';

  @override
  String get authConfirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get authConfirmPasswordHint => 'Masukkan kata sandi lagi';

  @override
  String get authVerificationCode => 'Kode Verifikasi';

  @override
  String get authRegisterAndLogin => 'Daftar dan masuk';

  @override
  String get authHaveAccount => 'Sudah punya akun?';

  @override
  String get authGoLogin => 'Masuk';

  @override
  String get authEmailVerificationUnavailable =>
      'Verifikasi email tidak tersedia. Daftar menggunakan nomor ponsel.';

  @override
  String get authSmsVerificationUnavailable =>
      'Verifikasi SMS tidak tersedia. Daftar menggunakan email.';

  @override
  String get authSendFailed => 'Tidak dapat mengirim. Coba lagi.';

  @override
  String get authErrorEmptyNickname => 'Masukkan nama panggilan';

  @override
  String get authErrorInvalidMobile => 'Masukkan nomor ponsel yang valid';

  @override
  String get authErrorInvalidEmail => 'Masukkan alamat email yang valid';

  @override
  String get authErrorPasswordTooShort =>
      'Kata sandi harus berisi minimal 6 karakter';

  @override
  String get authErrorPasswordMismatch => 'Kata sandi tidak sama';

  @override
  String get authErrorVerificationRequired =>
      'Dapatkan dan masukkan kode verifikasi terlebih dahulu';

  @override
  String get authRegisterErrorTitle => 'Pendaftaran gagal';

  @override
  String get authGotIt => 'Mengerti';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Perusahaan \"$code\" tidak ditemukan. Periksa kode perusahaan.';
  }

  @override
  String get authTenantSearchFailed => 'Pencarian gagal. Coba lagi.';

  @override
  String get authInvitationInvalid =>
      'Kode undangan tidak valid. Periksa lalu coba lagi.';

  @override
  String get authCollapseJoin => 'Sembunyikan informasi bergabung';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Undangan valid: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Perusahaan ditemukan: $name';
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
  String get authNoOrganization => 'Tidak ada organisasi tersedia';

  @override
  String get authNoOrganizationHint =>
      'Minta administrator mengundang Anda ke organisasi';

  @override
  String get authPersonalSpace => 'Ruang pribadi';

  @override
  String get authPersonalSpaceSubtitle => 'Obrolan teman dan favorit pribadi';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Identitas ruang tidak dapat diverifikasi. Coba lagi.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Ruang pribadi tidak dapat dipulihkan. Coba lagi.';

  @override
  String get authJoinEnterpriseFailed =>
      'Tidak dapat bergabung ke perusahaan. Coba lagi nanti.';

  @override
  String get homeTitle => 'Pesan';

  @override
  String get homeGatewayConnectingTitle => 'Menghubungkan';

  @override
  String get homePersonalSpace => 'Pribadi';

  @override
  String get homeOfficialService => 'Layanan resmi';

  @override
  String get homeSwitchSpace => 'Ganti ruang';

  @override
  String get homeSpaceSubtitle => 'Pribadi · Perusahaan';

  @override
  String get homeJoinEnterprise => 'Gabung perusahaan';

  @override
  String get homeCreateGroup => 'Grup baru';

  @override
  String get homeAddFriend => 'Tambah kontak';

  @override
  String get homeScan => 'Pindai';

  @override
  String get homeJoinNewSpace => 'Gabung ruang baru';

  @override
  String get homeSearchConversation => 'Cari';

  @override
  String get homeNoMessages => 'Tidak ada pesan';

  @override
  String get homeDeleteConversation => 'Hapus obrolan';

  @override
  String get homeDeleteConversationConfirm =>
      'Hapus obrolan ini? Riwayat obrolan akan dihapus.';

  @override
  String get homePersonalNote => 'Saya (Catatan pribadi)';

  @override
  String get homeWorkNote => 'Saya (Catatan kerja)';

  @override
  String homeConversationCount(int count) {
    return '$count obrolan';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count belum dibaca';
  }

  @override
  String get chatInputHint => 'Ketik pesan...';

  @override
  String get chatVoiceHint => 'Tahan untuk bicara';

  @override
  String get chatVoiceRelease => 'Lepas untuk mengirim';

  @override
  String get chatVoiceCancel => 'Geser ke atas untuk membatalkan';

  @override
  String get chatMenuCopy => 'Salin';

  @override
  String get chatMenuForward => 'Teruskan';

  @override
  String get chatMenuRecall => 'Tarik kembali';

  @override
  String get chatMenuDelete => 'Hapus';

  @override
  String get chatMenuFavorite => 'Simpan';

  @override
  String get chatMenuReply => 'Balas';

  @override
  String get chatMenuMultiSelect => 'Pilih';

  @override
  String get chatMenuTranslate => 'Terjemahkan';

  @override
  String get chatMenuVoiceToText => 'Ubah ke teks';

  @override
  String get chatMenuTextToSpeech => 'Bacakan';

  @override
  String get chatStatusRecalled => 'Pesan ditarik kembali';

  @override
  String get chatRecallSuccess => 'Ditarik kembali';

  @override
  String get chatRecallFailed => 'Gagal menarik kembali';

  @override
  String get chatRecallTimeout =>
      'Pesan yang lebih lama dari 2 menit tidak dapat ditarik kembali';

  @override
  String get chatTranslateFailed => 'Terjemahan gagal, coba lagi';

  @override
  String get chatTranslateNotConfigured => 'Layanan terjemahan tidak tersedia';

  @override
  String get chatVoiceToTextFailed => 'Konversi gagal, coba lagi';

  @override
  String get chatTextToSpeechFailed => 'Gagal membacakan, coba lagi';

  @override
  String get chatVoiceToText => 'Konversi';

  @override
  String get chatForwardSuccess => 'Diteruskan';

  @override
  String get chatForwardFailed => 'Gagal meneruskan, coba lagi';

  @override
  String get chatNoConversations => 'Tidak ada obrolan tujuan';

  @override
  String get chatSendFailed => 'Gagal mengirim';

  @override
  String get chatResend => 'Kirim Ulang Kode';

  @override
  String get chatNotFriend => 'Tidak ada dalam daftar kontak';

  @override
  String get chatNotFriendHint =>
      'Anda belum berteman. Tidak dapat mengirim pesan.';

  @override
  String get chatMutedHint => 'Semua anggota dibisukan';

  @override
  String get chatFileUploadFailed => 'Unggah berkas gagal, coba lagi';

  @override
  String get chatFileStatusNotDownloaded => 'Belum diunduh';

  @override
  String get chatFileStatusDownloaded => 'Sudah diunduh';

  @override
  String get chatFileStatusUploading => 'Mengunggah';

  @override
  String get chatFileStatusUploadFailed => 'Unggah Gagal';

  @override
  String get chatCardSendFailed => 'Gagal mengirim kartu kontak';

  @override
  String get chatFavoriteSuccess => 'Tersimpan';

  @override
  String get chatFavoriteFailed => 'Gagal menambahkan ke favorit';

  @override
  String get chatLoadFailed => 'Gagal memuat';

  @override
  String get chatImageMessage => '[Gambar]';

  @override
  String get chatVoiceMessage => '[Suara]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[Berkas]';

  @override
  String get chatLocationMessage => '[Lokasi]';

  @override
  String get chatContactCardMessage => '[Kontak]';

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
  String get chatRecalledSelf => 'Anda menarik kembali sebuah pesan';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender menarik kembali sebuah pesan';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Terjemahan: $translation';
  }

  @override
  String get chatMessageDeleted => 'Pesan dihapus';

  @override
  String get chatPeer => 'Lainnya';

  @override
  String get chatSelf => 'Saya';

  @override
  String get chatGenericMessage => '[Pesan]';

  @override
  String get chatVoiceHideText => 'Sembunyikan teks';

  @override
  String get chatVoiceShowText => 'Ubah menjadi teks';

  @override
  String get chatFileDefaultName => 'Berkas';

  @override
  String get chatContactDefaultName => 'Kontak';

  @override
  String get chatContactCardTitle => 'Kartu kontak';

  @override
  String get chatCallMissed => 'Tak terjawab';

  @override
  String get chatCallCancelled => 'Dibatalkan';

  @override
  String get chatCallRejected => 'Ditolak';

  @override
  String get chatCallDisconnected => 'Terputus';

  @override
  String get chatCallEnded => 'Panggilan berakhir';

  @override
  String get chatCallFailed => 'Panggilan gagal';

  @override
  String chatCallDuration(String duration) {
    return 'Durasi $duration';
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
  String get chatToolFile => 'Berkas';

  @override
  String get chatToolLocation => 'Lokasi';

  @override
  String get chatToolContactCard => 'Kontak';

  @override
  String get chatToolVoiceCall => 'Panggilan suara';

  @override
  String get chatToolVideoCall => 'Panggilan video';

  @override
  String get chatToolFavorites => 'Favorit';

  @override
  String get chatToolTranslate => 'Terjemahkan';

  @override
  String get chatTranslationChooseLanguage => 'Pilih bahasa terjemahan';

  @override
  String get chatTranslationEnterText => 'Masukkan teks terlebih dahulu';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Terjemahan tidak tersedia untuk pesan yang berisi sebutan';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Terjemahan tidak tersedia saat mengedit pesan terjadwal';

  @override
  String get chatTranslationFailed => 'Terjemahan gagal. Coba lagi';

  @override
  String get chatTranslationEmpty => 'Tidak ada hasil terjemahan. Coba lagi';

  @override
  String get chatTranslationTranslating => 'Menerjemahkan…';

  @override
  String get chatTranslationSend => 'Kirim terjemahan';

  @override
  String get chatTranslationSending => 'Mengirim…';

  @override
  String get chatTranslationExpand => 'Tampilkan lebih banyak';

  @override
  String get chatTranslationCollapse => 'Tampilkan lebih sedikit';

  @override
  String get chatFileTooLarge => 'Berkas melebihi batas (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Hanya pemilik atau anggota terpilih yang dapat mengirim pesan.';

  @override
  String get chatImageUploadUnsupported =>
      'Unggah gambar gagal. Dukungan server belum tersedia.';

  @override
  String get chatFavoriteLongPressHint =>
      'Tekan lama pesan untuk menambahkannya ke favorit';

  @override
  String chatSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get chatLocationSheetTitle => 'Kirim lokasi';

  @override
  String get chatLocationNameLabel => 'Nama tempat';

  @override
  String get chatLocationNameHint => 'mis. Kantor, alamat pelanggan';

  @override
  String get chatLocationAddressLabel => 'Alamat';

  @override
  String get chatLocationOptionalHint => 'Opsional';

  @override
  String get chatLocationLatitudeLabel => 'Lintang';

  @override
  String get chatLocationLatitudeHint => '-90 hingga 90';

  @override
  String get chatLocationLongitudeLabel => 'Bujur';

  @override
  String get chatLocationLongitudeHint => '-180 hingga 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Masukkan $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label di luar rentang';
  }

  @override
  String get chatLocationDefaultTitle => 'Lokasi';

  @override
  String get chatMutedFullNotice =>
      'Grup ini dibisukan. Hanya pemilik atau anggota terpilih yang dapat mengirim pesan.';

  @override
  String get chatNotFriendSendBlocked =>
      'Anda sudah tidak berteman dan tidak dapat mengirim pesan';

  @override
  String get chatPersonalNotesTitle => 'Catatan pribadi';

  @override
  String get chatWorkNotesTitle => 'Catatan kerja';

  @override
  String get chatPersonalNotesDescription =>
      'Catat pikiran pribadi dan simpan informasi penting di sini\nDisinkronkan antarperangkat untuk diakses kapan saja';

  @override
  String get chatWorkNotesDescription =>
      'Catat tugas dan simpan materi kerja di sini\nRuang tim tetap terpisah dan aman';

  @override
  String get chatNoMessages => 'Tidak ada pesan';

  @override
  String chatReplyTo(String sender) {
    return 'Balas $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature segera hadir';
  }

  @override
  String get chatForwardSelectTitle => 'Pilih obrolan';

  @override
  String get chatContactSelectTitle => 'Pilih kontak';

  @override
  String get chatNoContacts => 'Tidak ada kontak';

  @override
  String get contactsTitle => 'Kontak';

  @override
  String get contactsSearch => 'Cari kontak';

  @override
  String get contactsNewFriends => 'Teman baru';

  @override
  String get contactsGroups => 'Grup';

  @override
  String get contactsFavorites => 'Favorit';

  @override
  String get contactsRecent => 'Terbaru';

  @override
  String get contactsOrganization => 'Organisasi';

  @override
  String get contactsAnnouncement => 'Pengumuman';

  @override
  String get contactsNewApplications => 'Permohonan baru';

  @override
  String get contactsCustomerGroups => 'Grup pelanggan';

  @override
  String get contactsAllCustomers => 'Semua pelanggan';

  @override
  String get contactsMyCustomers => 'Pelanggan saya';

  @override
  String get contactsViewAll => 'Lihat semua';

  @override
  String get contactsMyContacts => 'Kontak saya';

  @override
  String get contactsMyAdvisor => 'Penasihat saya';

  @override
  String get contactsNoAdvisor => 'Belum ada penasihat yang ditugaskan';

  @override
  String get contactsAdvisorLoading => 'Memuat...';

  @override
  String get contactsNavigateFailed => 'Navigasi gagal, coba lagi';

  @override
  String get contactsEmpty => 'Tidak ada kontak';

  @override
  String get contactsNoAnnouncement => 'Tidak ada pengumuman';

  @override
  String get contactsOfficialBadge => 'Resmi';

  @override
  String get contactsCustomerBadge => 'Pelanggan';

  @override
  String get contactsEmptyCustomers => 'Tidak ada pelanggan';

  @override
  String get myTitle => 'Saya';

  @override
  String get myEnterpriseInfo => 'Informasi perusahaan';

  @override
  String get myEnterpriseManage => 'Manajemen perusahaan';

  @override
  String get myQrCode => 'Kode QR';

  @override
  String get myFavorites => 'Favorit';

  @override
  String get myLanguage => 'Bahasa';

  @override
  String get myTimezone => 'Zona waktu';

  @override
  String get myAutoTranslate => 'Terjemahan otomatis';

  @override
  String get myNetworkSwitch => 'Ganti jalur';

  @override
  String get mySettings => 'Pengaturan';

  @override
  String get myLogout => 'Keluar';

  @override
  String get myLogoutConfirm => 'Yakin ingin keluar?';

  @override
  String get myLeaveEnterprise => 'Keluar dari perusahaan';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Yakin ingin keluar dari perusahaan ini? Anda akan kehilangan akses ke data perusahaan.';

  @override
  String get myLeaveEnterpriseSuccess => 'Telah keluar dari perusahaan';

  @override
  String get myLeaveEnterpriseFailed => 'Gagal keluar, coba lagi';

  @override
  String get myLppIdCopied => 'ID StartLink disalin';

  @override
  String myLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count kontak';
  }

  @override
  String get myAutoSelect => 'Otomatis';

  @override
  String get myPresenceStatus => 'Status kehadiran';

  @override
  String get myPresenceStatusTitle => 'Atur status kehadiran';

  @override
  String get myPresenceOnline => 'Daring';

  @override
  String get myPresenceBusy => 'Sibuk';

  @override
  String get myPresenceAway => 'Tidak di tempat';

  @override
  String get myPresenceInvisible => 'Tak terlihat';

  @override
  String get profileTitle => 'Profil Saya';

  @override
  String get profileName => 'Nama';

  @override
  String get profileGender => 'Jenis Kelamin';

  @override
  String get profileBirthday => 'Tanggal lahir';

  @override
  String get profileRegion => 'Wilayah';

  @override
  String get profileSignature => 'Bio';

  @override
  String get profileSignatureHint => 'Ceritakan tentang diri Anda';

  @override
  String get profileTapTapText => 'Colekan';

  @override
  String get profileTapTapHint =>
      'Teks yang muncul saat dicolek (maks. 20 karakter)';

  @override
  String get profileAccountSection => 'Akun';

  @override
  String get profileBasicSection => 'Informasi dasar';

  @override
  String get profileLppId => 'ID StartLink';

  @override
  String get profileLppIdNotSet => 'Belum diatur';

  @override
  String get profileMobile => 'Telepon';

  @override
  String get profileMobileUnbound => 'Tidak Terhubung';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailUnbound => 'Tidak Terhubung';

  @override
  String get profileQrCode => 'Kode QR saya';

  @override
  String get profileChangePassword => 'Ubah Kata Sandi';

  @override
  String get profileGenderMale => 'Pria';

  @override
  String get profileGenderFemale => 'Wanita';

  @override
  String get profileGenderOther => 'Lainnya';

  @override
  String get profileGenderUnset => 'Belum diatur';

  @override
  String get profileSaveFailed => 'Gagal menyimpan, coba lagi';

  @override
  String get profileLppIdTitle => 'ID StartLink';

  @override
  String get profileLppIdSetOnce =>
      'ID StartLink hanya dapat diubah sekali. Pilih dengan cermat.';

  @override
  String get profileLppIdChangeFailed =>
      'Gagal mengubah (ID StartLink hanya dapat diubah sekali)';

  @override
  String get profileChangePasswordOld => 'Kata sandi saat ini';

  @override
  String get profileChangePasswordNew => 'Kata Sandi Baru';

  @override
  String get profileChangePasswordConfirm => 'Konfirmasi Kata Sandi Baru';

  @override
  String get profileChangePasswordMismatch => 'Kata sandi tidak cocok';

  @override
  String get profileChangePasswordSuccess =>
      'Kata sandi diubah. Silakan masuk kembali.';

  @override
  String get profileChangePasswordFailed =>
      'Gagal mengubah kata sandi, coba lagi';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsSectionEnterprise => 'Perusahaan';

  @override
  String get settingsSectionAccount => 'Akun';

  @override
  String get settingsSectionGeneral => 'Umum';

  @override
  String get settingsSectionFeatures => 'Fitur';

  @override
  String get settingsSectionAbout => 'Tentang';

  @override
  String get settingsEnterpriseInfo => 'Informasi perusahaan';

  @override
  String get settingsProfile => 'Profil Saya';

  @override
  String get settingsAccountSecurity => 'Keamanan akun';

  @override
  String get settingsNotification => 'Notifikasi';

  @override
  String get settingsDisplay => 'Tampilan';

  @override
  String get settingsFriendPrivacy => 'Privasi';

  @override
  String get settingsChat => 'Obrolan';

  @override
  String get settingsChatHistory => 'Riwayat obrolan';

  @override
  String get settingsAbout => 'Tentang StartLink';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsTimezone => 'Zona waktu';

  @override
  String get settingsAutoTranslate => 'Terjemahan otomatis';

  @override
  String get settingsNetworkSwitch => 'Ganti jalur';

  @override
  String get enterpriseInfoTitle => 'Informasi perusahaan';

  @override
  String get enterpriseName => 'Nama';

  @override
  String get enterpriseDescription => 'Deskripsi';

  @override
  String get enterpriseUpdateSuccess => 'Berhasil Diperbarui';

  @override
  String get enterpriseUpdateFailed => 'Pembaruan gagal, coba lagi';

  @override
  String get enterpriseLeave => 'Keluar dari perusahaan';

  @override
  String get enterpriseLeaveConfirm =>
      'Yakin ingin keluar dari perusahaan ini?';

  @override
  String get enterpriseLeaveSuccess => 'Telah keluar dari perusahaan';

  @override
  String get enterpriseLeaveFailed => 'Gagal keluar, coba lagi';

  @override
  String get enterpriseLeaveOwnerError =>
      'Pemilik tidak dapat langsung keluar. Alihkan kepemilikan terlebih dahulu.';

  @override
  String get enterpriseMemberCount => 'Anggota';

  @override
  String get enterpriseCreatedAt => 'Dibuat';

  @override
  String get enterpriseCode => 'Kode perusahaan';

  @override
  String get enterpriseInviteMembers => 'Undang anggota';

  @override
  String get enterpriseCopyInviteCode => 'Salin kode undangan';

  @override
  String get enterpriseInviteCodeCopied => 'Kode undangan disalin';

  @override
  String get groupCreateTitle => 'Grup baru';

  @override
  String get groupNameHint => 'Masukkan nama grup';

  @override
  String get groupCreateSuccess => 'Grup dibuat';

  @override
  String get groupCreateFailed => 'Gagal membuat grup';

  @override
  String get groupSettings => 'Pengaturan grup';

  @override
  String get groupName => 'Nama grup';

  @override
  String get groupAvatar => 'Avatar grup';

  @override
  String get groupAnnouncement => 'Pengumuman';

  @override
  String get groupMembers => 'Anggota';

  @override
  String get groupAddMember => 'Tambah anggota';

  @override
  String get groupRemoveMember => 'Hapus anggota';

  @override
  String get groupRemoveMemberConfirm => 'Hapus anggota ini?';

  @override
  String get groupSetAdmin => 'Jadikan admin';

  @override
  String get groupRemoveAdmin => 'Hapus admin';

  @override
  String get groupTransferOwner => 'Alihkan kepemilikan';

  @override
  String get groupTransferOwnerConfirm =>
      'Alihkan kepemilikan grup ke anggota ini?';

  @override
  String get groupTransferOwnerSuccess => 'Kepemilikan dialihkan';

  @override
  String get groupTransferOwnerFailed => 'Pengalihan gagal, coba lagi';

  @override
  String get groupLeave => 'Keluar dari grup';

  @override
  String get groupLeaveConfirm => 'Keluar dari grup ini?';

  @override
  String get groupLeaveSuccess => 'Telah keluar dari grup';

  @override
  String get groupLeaveFailed => 'Gagal keluar, coba lagi';

  @override
  String get groupDissolve => 'Bubarkan grup';

  @override
  String get groupDissolveConfirm =>
      'Bubarkan grup ini? Semua anggota akan dikeluarkan.';

  @override
  String get groupDissolveSuccess => 'Grup dibubarkan';

  @override
  String get groupDissolveFailed => 'Gagal membubarkan, coba lagi';

  @override
  String get groupQrCode => 'Kode QR grup';

  @override
  String get groupMuteAll => 'Bisukan semua';

  @override
  String get groupMuteAllOn => 'Aktifkan bisukan semua';

  @override
  String get groupMuteAllOff => 'Nonaktifkan bisukan semua';

  @override
  String get groupAllowMemberInvite => 'Izinkan anggota mengundang';

  @override
  String get groupAllowMemberModifyTitle =>
      'Izinkan anggota mengubah nama grup';

  @override
  String get groupAllowMemberAtAll => 'Izinkan anggota menyebut @Semua';

  @override
  String get groupAllowMemberViewMemberList =>
      'Izinkan anggota melihat daftar anggota';

  @override
  String get groupAllowQrCodeJoin => 'Izinkan bergabung melalui kode QR';

  @override
  String get groupRequireApproval => 'Wajibkan persetujuan untuk bergabung';

  @override
  String get groupAllowMemberAddFriend => 'Izinkan anggota saling menambahkan';

  @override
  String get groupRoleOwner => 'Pemilik';

  @override
  String get groupRoleAdmin => 'Admin';

  @override
  String get groupRoleMember => 'Anggota';

  @override
  String get groupNoMembers => 'Tidak ada anggota';

  @override
  String get groupNoAnnouncements => 'Tidak ada pengumuman';

  @override
  String get groupCreateAnnouncement => 'Kirim pengumuman';

  @override
  String get groupEditAnnouncement => 'Edit pengumuman';

  @override
  String get groupDeleteAnnouncement => 'Hapus pengumuman';

  @override
  String get groupDeleteAnnouncementConfirm => 'Hapus pengumuman ini?';

  @override
  String get groupAnnouncementTitle => 'Judul';

  @override
  String get groupAnnouncementContent => 'Isi';

  @override
  String get groupAnnouncementPin => 'Sematkan pengumuman';

  @override
  String groupMemberCount(int count) {
    return '$count anggota';
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
  String get groupJoinRequests => 'Permintaan bergabung';

  @override
  String get groupNoJoinRequests => 'Tidak ada permintaan bergabung';

  @override
  String get groupReadReceipts => 'Tanda sudah dibaca';

  @override
  String groupReadCount(int count) {
    return '$count sudah membaca';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count belum dibaca';
  }

  @override
  String get friendAddTitle => 'Tambah kontak';

  @override
  String get friendSearchHint => 'Telepon / Email / ID StartLink';

  @override
  String get friendRequestSent => 'Permintaan pertemanan dikirim';

  @override
  String get friendRequestFailed => 'Gagal mengirim, coba lagi';

  @override
  String get friendAlreadyFriend => 'Sudah menjadi kontak';

  @override
  String get friendNewFriendsTitle => 'Teman baru';

  @override
  String get friendNoRequests => 'Tidak ada permintaan pertemanan';

  @override
  String get friendAccept => 'Terima';

  @override
  String get friendReject => 'Tolak';

  @override
  String get friendAccepted => 'Diterima';

  @override
  String get friendRejected => 'Ditolak';

  @override
  String get friendDeleteConfirm => 'Hapus kontak ini?';

  @override
  String get friendDeleteSuccess => 'Kontak dihapus';

  @override
  String get friendDeleteFailed => 'Gagal menghapus, coba lagi';

  @override
  String get friendRemarkName => 'Nama panggilan';

  @override
  String get friendGroupName => 'Grup';

  @override
  String get friendSendMessage => 'Pesan';

  @override
  String get friendMatchTypeLppId => 'Ditemukan melalui ID StartLink';

  @override
  String get friendMatchTypeMobile => 'Ditemukan melalui telepon';

  @override
  String get friendMatchTypeEmail => 'Ditemukan melalui email';

  @override
  String get friendSearchEmpty => 'Tidak ada pengguna ditemukan';

  @override
  String get friendAddMessage => 'Saya ingin menambahkan Anda sebagai kontak';

  @override
  String get friendBlockConfirm => 'Blokir pengguna ini?';

  @override
  String get friendUnblockConfirm => 'Buka blokir pengguna ini?';

  @override
  String get friendBlockSuccess => 'Diblokir';

  @override
  String get friendUnblockSuccess => 'Blokir dibuka';

  @override
  String get profilePageTitle => 'Informasi Pribadi';

  @override
  String get profilePageSendMessage => 'Pesan';

  @override
  String get profilePageAddFriend => 'Tambah teman';

  @override
  String get profilePageAlreadyFriend => 'Sudah berteman';

  @override
  String get profilePageBlocked => 'Diblokir';

  @override
  String get profilePageBlock => 'Blokir';

  @override
  String get profilePageUnblock => 'Buka blokir';

  @override
  String get profilePageHidden => 'Pengguna ini menyembunyikan profilnya';

  @override
  String get profilePageFriendsOnly =>
      'Pengguna ini hanya menampilkan profil kepada teman';

  @override
  String get profilePageLppId => 'ID StartLink';

  @override
  String get profilePageRemarkName => 'Keterangan';

  @override
  String get profilePageEditRemark => 'Edit nama panggilan';

  @override
  String get profilePageSaveRemarkSuccess => 'Nama panggilan disimpan';

  @override
  String get profilePageSaveRemarkFailed => 'Gagal menyimpan, coba lagi';

  @override
  String get searchTitle => 'Cari';

  @override
  String get searchHint => 'Cari berdasarkan telepon, email, atau ID StartLink';

  @override
  String get searchNoResults => 'Tidak ada hasil ditemukan';

  @override
  String get searchMessages => 'Pesan';

  @override
  String get searchUsers => 'Pengguna';

  @override
  String get searchFailed => 'Pencarian gagal, coba lagi';

  @override
  String get scanTitle => 'Pindai';

  @override
  String get scanFailed => 'Pengenalan gagal, coba lagi';

  @override
  String get scanInvalidQrCode => 'Kode QR tidak valid';

  @override
  String get scanFlashOn => 'Nyalakan senter';

  @override
  String get scanFlashOff => 'Matikan senter';

  @override
  String get scanAlbum => 'Pilih dari Album';

  @override
  String get favoritesTitle => 'Favorit';

  @override
  String get favoritesEmpty => 'Belum ada yang disimpan';

  @override
  String get favoritesAll => 'Semua';

  @override
  String get favoritesText => 'Teks';

  @override
  String get favoritesImage => 'Gambar';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Suara';

  @override
  String get favoritesFile => 'Berkas';

  @override
  String get favoritesOther => 'Lainnya';

  @override
  String get favoritesDeleteConfirm => 'Hapus dari favorit?';

  @override
  String get favoritesDeleteSuccess => 'Dihapus dari tersimpan';

  @override
  String get favoritesDeleteFailed => 'Gagal menghapus';

  @override
  String get favoritesOriginalRecalled => 'Pesan ditarik kembali';

  @override
  String get favoritesViewOriginal => 'Lihat asli';

  @override
  String get favoritesSearchHint => 'Cari favorit';

  @override
  String get favoritesNoResults => 'Tidak ada favorit yang cocok';

  @override
  String get noticeTitle => 'Pengumuman';

  @override
  String get noticeEmpty => 'Tidak ada pengumuman';

  @override
  String get noticeDetail => 'Detail pengumuman';

  @override
  String get noticePublishedAt => 'Diterbitkan';

  @override
  String get noticePriorityNormal => 'Normal';

  @override
  String get noticePriorityImportant => 'Penting';

  @override
  String get noticePriorityUrgent => 'Mendesak';

  @override
  String get organizationTitle => 'Organisasi';

  @override
  String get organizationEmpty => 'Tidak ada informasi departemen';

  @override
  String get organizationMembers => 'Anggota';

  @override
  String get organizationDepartment => 'Departemen';

  @override
  String get organizationPosition => 'Jabatan';

  @override
  String get organizationLeader => 'Pimpinan';

  @override
  String get qrCodeTitle => 'Kode QR saya';

  @override
  String get qrCodeSave => 'Simpan ke Album';

  @override
  String get qrCodeShare => 'Bagikan';

  @override
  String get qrCodeSaveSuccess => 'Disimpan ke album';

  @override
  String get qrCodeSaveFailed => 'Gagal menyimpan, coba lagi';

  @override
  String get qrCodeRefresh => 'Perbarui kode QR';

  @override
  String get qrCodeExpired => 'Kode QR kedaluwarsa, silakan perbarui';

  @override
  String get qrCodeScanToAdd => 'Pindai untuk menambahkan saya sebagai kontak';

  @override
  String get spacePersonal => 'Pribadi';

  @override
  String get spaceEnterprise => 'Perusahaan';

  @override
  String get spaceJoinByCode => 'Gabung dengan kode perusahaan';

  @override
  String get spaceJoinByInvite => 'Gabung dengan kode undangan';

  @override
  String get spaceEnterCode => 'Masukkan kode perusahaan';

  @override
  String get spaceEnterInviteCode => 'Masukkan kode undangan';

  @override
  String get spaceSearchEnterprise => 'Cari perusahaan';

  @override
  String get spaceJoinRequestSent => 'Permintaan dikirim, menunggu persetujuan';

  @override
  String get spaceJoinRequestPending => 'Menunggu persetujuan';

  @override
  String get spaceJoinRequestApproved => 'Permintaan disetujui';

  @override
  String get spaceJoinRequestRejected => 'Permintaan ditolak';

  @override
  String get spaceAlreadyMember => 'Anda sudah menjadi anggota';

  @override
  String get spaceAutoApproved => 'Disetujui otomatis. Selamat datang!';

  @override
  String get spacePendingApprovalHint =>
      'Pendaftaran berhasil. Permintaan bergabung Anda telah dikirim.';

  @override
  String get spaceNoSpaces => 'Tidak ada ruang';

  @override
  String get spaceInviteExpired => 'Kode undangan kedaluwarsa';

  @override
  String get spaceInviteTargetMismatch =>
      'Kode undangan ini bukan untuk akun Anda';

  @override
  String get spaceAcceptInviteSuccess => 'Berhasil bergabung ke perusahaan';

  @override
  String get spaceAcceptInviteFailed => 'Gagal bergabung, coba lagi';

  @override
  String get spaceTenantSelectTitle => 'Pilih ruang';

  @override
  String get spaceTenantSelectHint => 'Pilih ruang yang ingin dimasuki';

  @override
  String get spaceEnterPersonal => 'Masuk ruang pribadi';

  @override
  String get spaceEnterEnterprise => 'Masuk ruang perusahaan';

  @override
  String get aboutTitle => 'Tentang StartLink';

  @override
  String get aboutVersion => 'Versi';

  @override
  String get aboutTerms => 'Perjanjian Pengguna';

  @override
  String get aboutPrivacy => 'Kebijakan Privasi';

  @override
  String get aboutOpenSource => 'Lisensi sumber terbuka';

  @override
  String get aboutCheckUpdate => 'Periksa pembaruan';

  @override
  String get aboutLatestVersion => 'Anda menggunakan versi terbaru';

  @override
  String get aboutUpdateAvailable => 'Versi Baru Tersedia';

  @override
  String get aboutUpdateNow => 'Perbarui Sekarang';

  @override
  String get aboutUpdateLater => 'Nanti';

  @override
  String get notificationTitle => 'Notifikasi';

  @override
  String get notificationGlobalMute => 'Jangan ganggu';

  @override
  String get notificationSound => 'Suara';

  @override
  String get notificationVibration => 'Getaran';

  @override
  String get notificationPreview => 'Pratinjau pesan';

  @override
  String get notificationDndStart => 'Waktu mulai jangan ganggu';

  @override
  String get notificationDndEnd => 'Waktu selesai jangan ganggu';

  @override
  String get blacklistTitle => 'Masuk Daftar Hitam';

  @override
  String get blacklistEmpty => 'Tidak ada pengguna diblokir';

  @override
  String get blacklistRemove => 'Buka blokir';

  @override
  String get blacklistRemoveConfirm => 'Buka blokir pengguna ini?';

  @override
  String get feedbackTitle => 'Masukan';

  @override
  String get feedbackTypeComplaint => 'Keluhan';

  @override
  String get feedbackTypeSuggestion => 'Saran';

  @override
  String get feedbackTypeBug => 'Laporan bug';

  @override
  String get feedbackContent => 'Deskripsi';

  @override
  String get feedbackContentHint =>
      'Jelaskan masalah atau saran Anda secara terperinci';

  @override
  String get feedbackContact => 'Kontak (opsional)';

  @override
  String get feedbackSubmit => 'Kirim';

  @override
  String get feedbackSuccess => 'Masukan dikirim. Terima kasih!';

  @override
  String get feedbackFailed => 'Pengiriman gagal, coba lagi';

  @override
  String get networkTitle => 'Ganti jalur';

  @override
  String get networkAutoSelect => 'Otomatis';

  @override
  String get networkManual => 'Manual';

  @override
  String get timezoneTitle => 'Zona waktu';

  @override
  String get timezoneAuto => 'Ikuti sistem';

  @override
  String get autoTranslateTitle => 'Terjemahan otomatis';

  @override
  String get autoTranslateEnabled => 'Aktifkan terjemahan otomatis';

  @override
  String get autoTranslateLanguage => 'Bahasa tujuan';

  @override
  String get displayTitle => 'Tampilan';

  @override
  String get displayFontSize => 'Ukuran Font';

  @override
  String get displayChatBackground => 'Latar obrolan';

  @override
  String get displayDarkMode => 'Tampilan';

  @override
  String get displayDarkModeSystem => 'Ikuti sistem';

  @override
  String get displayDarkModeSystemHint =>
      'Beralih otomatis sesuai pengaturan sistem';

  @override
  String get displayDarkModeOff => 'Terang';

  @override
  String get displayDarkModeOffHint => 'Selalu gunakan tema terang';

  @override
  String get displayDarkModeOn => 'Gelap';

  @override
  String get displayDarkModeOnHint => 'Selalu gunakan tema gelap';

  @override
  String get chatSettingsTitle => 'Obrolan';

  @override
  String get chatHistoryTitle => 'Riwayat obrolan';

  @override
  String get chatHistoryClear => 'Hapus semua riwayat';

  @override
  String get chatHistoryClearConfirm =>
      'Hapus semua riwayat obrolan? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get chatHistoryClearSuccess => 'Riwayat obrolan dihapus';

  @override
  String get accountSecurityTitle => 'Keamanan akun';

  @override
  String get accountSecurityChangePassword => 'Ubah Kata Sandi';

  @override
  String get accountSecurityChangeMobile => 'Ubah Nomor Telepon';

  @override
  String get accountSecurityChangeEmail => 'Ubah email';

  @override
  String get accountSecurityLoggedDevices => 'Perangkat yang masuk';

  @override
  String get accountSecurityDeactivate => 'Tutup akun';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Semua data akan dihapus permanen setelah 7 hari. Tutup akun?';

  @override
  String get loggedDevicesTitle => 'Perangkat yang masuk';

  @override
  String get loggedDevicesCurrent => 'Perangkat ini';

  @override
  String get loggedDevicesRevoke => 'Keluar';

  @override
  String get loggedDevicesRevokeConfirm => 'Keluar dari perangkat ini?';

  @override
  String get loggedDevicesRevokeSuccess => 'Telah keluar dari perangkat';

  @override
  String get loggedDevicesRevokeFailed => 'Gagal, coba lagi';

  @override
  String get loggedDevicesLastActive => 'Terakhir aktif';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Desktop';

  @override
  String get loggedDevicesTypeUnknown => 'Perangkat tidak dikenal';

  @override
  String get privacySettingsTitle => 'Privasi';

  @override
  String get privacySearchableByMobile =>
      'Izinkan pencarian melalui nomor telepon';

  @override
  String get privacySearchableByLppId =>
      'Izinkan pencarian melalui ID StartLink';

  @override
  String get privacyAllowFriendRequest => 'Izinkan permintaan pertemanan';

  @override
  String get privacyProfileVisibility => 'Visibilitas profil';

  @override
  String get privacyEveryone => 'Semua orang';

  @override
  String get privacyFriendsOfFriends => 'Teman dari teman';

  @override
  String get privacyNobody => 'Tidak seorang pun';

  @override
  String get privacyFriendsOnly => 'Hanya teman';

  @override
  String get privacySaveSuccess => 'Pengaturan disimpan';

  @override
  String get privacySaveFailed => 'Gagal menyimpan, coba lagi';

  @override
  String get fontSizeTitle => 'Ukuran Font';

  @override
  String get fontSizeSmall => 'Kecil';

  @override
  String get fontSizeNormal => 'Standar';

  @override
  String get fontSizeLarge => 'Besar';

  @override
  String get fontSizeExtraLarge => 'Ekstra Besar';

  @override
  String get fontSizePreview => 'Pratinjau';

  @override
  String get chatBackgroundTitle => 'Latar obrolan';

  @override
  String get chatBackgroundDefault => 'Bawaan';

  @override
  String get chatBackgroundCustom => 'Kustom';

  @override
  String get chatBackgroundReset => 'Kembalikan ke Default';

  @override
  String get termsTitle => 'Perjanjian Pengguna';

  @override
  String get privacyPolicyTitle => 'Kebijakan Privasi';

  @override
  String get recentContactsTitle => 'Terbaru';

  @override
  String get recentContactsEmpty => 'Tidak ada kontak terbaru';

  @override
  String get inviteFriendsTitle => 'Undang teman';

  @override
  String get inviteFriendsCopyLink => 'Salin tautan undangan';

  @override
  String get inviteFriendsLinkCopied => 'Tautan undangan disalin';

  @override
  String get imageViewerTitle => 'Foto';

  @override
  String get imageViewerSave => 'Simpan ke Album';

  @override
  String get imageViewerSaveSuccess => 'Disimpan ke album';

  @override
  String get imageViewerSaveFailed => 'Gagal menyimpan, coba lagi';

  @override
  String get customerServiceTitle => 'Meja layanan';

  @override
  String get customerServiceQueue => 'Antrean';

  @override
  String get customerServiceActive => 'Aktif';

  @override
  String get customerServiceClaim => 'Terima';

  @override
  String get customerServiceTakeover => 'Ambil alih';

  @override
  String get customerServiceClose => 'Akhiri layanan';

  @override
  String get customerServiceCloseConfirm => 'Akhiri sesi layanan ini?';

  @override
  String get customerServiceNoQueue => 'Tidak ada sesi dalam antrean';

  @override
  String get customerServiceNoActive => 'Tidak ada sesi aktif';

  @override
  String get customerServiceVisitor => 'Pengunjung';

  @override
  String get customerServiceCustomer => 'Pelanggan';

  @override
  String get customerServiceAssignedTo => 'Ditugaskan kepada';

  @override
  String get customerServiceTransferConversation => 'Alihkan obrolan';

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
  String get callHangup => 'Akhiri';

  @override
  String get callMissed => 'Panggilan tak terjawab';

  @override
  String get callDuration => 'Durasi';

  @override
  String get callAudio => 'Panggilan suara';

  @override
  String get callGeneric => 'Panggilan';

  @override
  String get callVideo => 'Panggilan video';

  @override
  String get callConnecting => 'Menghubungkan...';

  @override
  String get callRinging => 'Berdering...';

  @override
  String get callEnded => 'Panggilan berakhir';

  @override
  String get callFailed => 'Panggilan gagal';

  @override
  String get callRejected => 'Panggilan ditolak';

  @override
  String get callTimeout => 'Tidak dijawab';

  @override
  String get callCancelled => 'Dibatalkan';

  @override
  String get callUnknownPeer => 'Tidak Diketahui';

  @override
  String get callVideoInvitation => 'Undangan panggilan video';

  @override
  String get callAudioInvitation => 'Undangan panggilan suara';

  @override
  String get callAnswerAudio => 'Jawab dengan suara';

  @override
  String get callAnswerVideo => 'Jawab dengan video';

  @override
  String get callViewProfile => 'Lihat profil';

  @override
  String get callOpeningCamera => 'Membuka kamera...';

  @override
  String get callWaitingRemoteVideo => 'Menunggu video lawan bicara...';

  @override
  String get callCameraOff => 'Kamera mati';

  @override
  String get callCameraOn => 'Kamera menyala';

  @override
  String get callMicrophoneOff => 'Mikrofon mati';

  @override
  String get callMicrophoneOn => 'Mikrofon menyala';

  @override
  String get callSpeakerOff => 'Pengeras suara mati';

  @override
  String get callSpeakerOn => 'Pengeras suara menyala';

  @override
  String get callVideoPermissionFailure =>
      'Tidak dapat memulai panggilan video. Periksa izin kamera dan mikrofon lalu coba lagi.';

  @override
  String get callAudioPermissionFailure =>
      'Tidak dapat memulai panggilan suara. Periksa izin mikrofon lalu coba lagi.';

  @override
  String get callIncompleteIncoming =>
      'Informasi panggilan masuk tidak lengkap dan tidak dapat dijawab.';

  @override
  String get callInProgress => 'Sedang menelepon';

  @override
  String get callCalling => 'Memanggil...';

  @override
  String callEndedMedia(String media) {
    return '$media berakhir';
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
  String get callConnectionLost => 'Koneksi panggilan terputus';

  @override
  String get callAdminEnded => 'Panggilan diakhiri oleh administrator';

  @override
  String callFailedMedia(String media) {
    return '$media gagal';
  }

  @override
  String get callBusy => 'Lawan bicara sedang sibuk';

  @override
  String callDurationValue(String duration) {
    return 'Durasi panggilan $duration';
  }

  @override
  String get callNotConnected => 'Belum terhubung';

  @override
  String get callDialed => 'Keluar';

  @override
  String get callAnswered => 'Dijawab';

  @override
  String get callRejectedByPeer => 'Ditolak oleh lawan bicara';

  @override
  String get callRejectedBySelf => 'Ditolak';

  @override
  String get callPeerDidNotAnswer => 'Lawan bicara tidak menjawab';

  @override
  String get callMissedIncoming => 'Panggilan masuk tak terjawab';

  @override
  String get callPeerCancelled => 'Dibatalkan oleh lawan bicara';

  @override
  String get notificationNewMessageTitle => 'Pesan StartLink baru';

  @override
  String get notificationOnlineServiceTitle => 'Pesan layanan pelanggan baru';

  @override
  String get notificationNewMessageBody => 'Anda menerima pesan baru';

  @override
  String get notificationImagePreview => 'Mengirim gambar';

  @override
  String get notificationVideoPreview => 'Mengirim video';

  @override
  String get notificationVoicePreview => 'Mengirim pesan suara';

  @override
  String get notificationFilePreview => 'Mengirim berkas';

  @override
  String get notificationContactPreview => 'Mengirim kartu kontak';

  @override
  String get notificationCallLogPreview => 'Mengirim catatan panggilan';

  @override
  String get notificationLocationPreview => 'Berbagi lokasi';

  @override
  String get notificationLinkPreview => 'Berbagi tautan';

  @override
  String notificationMentionMe(String body) {
    return 'Menyebut Anda: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender menyebut Anda: $body';
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
  String get notificationSecurityTitle => 'Peringatan keamanan akun';

  @override
  String get notificationSecurityBody =>
      'Pengaturan keamanan akun StartLink Anda berubah. Periksa sekarang.';

  @override
  String get notificationFriendAcceptedTitle =>
      'Permintaan pertemanan diterima';

  @override
  String get notificationFriendRejectedTitle => 'Permintaan pertemanan ditolak';

  @override
  String get notificationFriendAcceptedBody =>
      'Lawan bicara menerima permintaan pertemanan Anda';

  @override
  String get notificationFriendRejectedBody =>
      'Lawan bicara menolak permintaan pertemanan Anda';

  @override
  String get notificationVideoCallTitle => 'Undangan panggilan video';

  @override
  String get notificationAudioCallTitle => 'Undangan panggilan suara';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller mengundang Anda ke panggilan video';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller mengundang Anda ke panggilan suara';
  }

  @override
  String get notificationMessageChannelName => 'Pesan';

  @override
  String get notificationMessageChannelDescription =>
      'Pesan obrolan, catatan panggilan, dan peringatan sistem';

  @override
  String get notificationCallChannelName => 'Panggilan';

  @override
  String get notificationCallChannelDescription =>
      'Peringatan panggilan suara dan video';

  @override
  String get notificationSecurityChannelName => 'Keamanan akun';

  @override
  String get notificationSecurityChannelDescription =>
      'Peringatan login, perubahan kata sandi, dan nomor ponsel';

  @override
  String get notificationUnknownCaller => 'Penelepon tidak dikenal';

  @override
  String get pendingJoinRequestsTitle => 'Permohonan baru';

  @override
  String get pendingJoinRequestsEmpty => 'Tidak ada permohonan';

  @override
  String get pendingJoinRequestApprove => 'Setuju';

  @override
  String get pendingJoinRequestReject => 'Tolak';

  @override
  String get pendingJoinRequestApproveSuccess => 'Disetujui';

  @override
  String get pendingJoinRequestRejectSuccess => 'Ditolak';

  @override
  String get pendingJoinRequestFailed => 'Operasi gagal, coba lagi';

  @override
  String get myCustomersTitle => 'Pelanggan saya';

  @override
  String get myCustomersEmpty => 'Tidak ada pelanggan';

  @override
  String get groupListTitle => 'Grup';

  @override
  String get groupListEmpty => 'Tidak ada grup';

  @override
  String get addFriendTitle => 'Tambah kontak';

  @override
  String get addFriendSearchHint => 'Telepon / Email / ID StartLink';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'ID StartLink: $lppId';
  }

  @override
  String get addFriendButton => 'Tambah';

  @override
  String get addFriendCannotAddSelf =>
      'Anda tidak dapat menambahkan diri sendiri';

  @override
  String get addFriendUnsupportedUser =>
      'Pengguna ini tidak dapat ditambahkan. Anda dapat mengirim pesan langsung.';

  @override
  String get addFriendMessageHint => 'Masukkan pesan';

  @override
  String get addFriendSendRequest => 'Kirim permintaan';

  @override
  String get joinCompanyTitle => 'Gabung perusahaan';

  @override
  String get joinCompanyCodeHint => 'Masukkan kode perusahaan';

  @override
  String get joinCompanySearchHint => 'Cari nama perusahaan';

  @override
  String get joinCompanyApply => 'Ajukan bergabung';

  @override
  String get joinCompanyApplySuccess => 'Permohonan dikirim';

  @override
  String get joinCompanyApplyFailed => 'Gagal mengajukan, coba lagi';

  @override
  String get joinCompanyAutoApproved => 'Disetujui otomatis. Selamat datang!';

  @override
  String get joinCompanyPending => 'Permohonan dikirim, menunggu persetujuan';

  @override
  String get joinCompanyInviteCodeHint => 'Masukkan kode undangan';

  @override
  String get joinCompanyAcceptInvite => 'Terima undangan';

  @override
  String get joinCompanyNoResults => 'Tidak ada perusahaan ditemukan';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count anggota';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Waktu Pasifik';

  @override
  String get timezoneNameMountainTime => 'Waktu Pegunungan';

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
  String get timezoneNameBerlinParisRome => 'Berlin/Paris/Roma';

  @override
  String get timezoneNameCairoHelsinki => 'Kairo/Helsinki';

  @override
  String get timezoneNameMoscowRiyadh => 'Moskwa/Riyadh';

  @override
  String get timezoneNameTehran => 'Teheran';

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
  String get networkSmartSelectBestRoute => 'Pilih jalur terbaik secara cerdas';

  @override
  String get networkTesting => 'Menguji...';

  @override
  String get networkTestingShort => 'Menguji';

  @override
  String networkLatencyMs(int ms) {
    return 'Latensi $ms md';
  }

  @override
  String get networkConnectionMode => 'Mode koneksi';

  @override
  String get networkDirectMode => 'Mode langsung';

  @override
  String get networkProxyMode => 'Mode proksi';

  @override
  String get networkDirectModeDesc => 'Hubungkan langsung ke server';

  @override
  String get networkProxyModeDesc => 'Hubungkan melalui server proksi';

  @override
  String get networkDirectRoutes => 'Jalur langsung';

  @override
  String get networkProxyRoutes => 'Jalur proksi';

  @override
  String get networkTestAll => 'Uji semua';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Simpul Hong Kong';

  @override
  String get networkSingaporeNode => 'Simpul Singapura';

  @override
  String get networkJapanNode => 'Simpul Jepang';

  @override
  String get networkUnitedStatesNode => 'Simpul Amerika Serikat';

  @override
  String get networkHint =>
      'Tips:\n• Mode langsung: lebih cepat dan cocok untuk penggunaan domestik\n• Mode proksi: lebih stabil untuk komunikasi lintas negara\n• Ketuk ikon segarkan untuk menguji latensi satu jalur';

  @override
  String get teenModeTitle => 'Mode remaja';

  @override
  String get teenModeStatusOn => 'Aktif';

  @override
  String get teenModeStatusOff => 'Nonaktif';

  @override
  String get teenModeStatusLoading => 'Memuat';

  @override
  String get teenModeUnavailable =>
      'Status mode remaja sementara tidak tersedia';

  @override
  String get teenModeInvalidResponse =>
      'Mode remaja mengembalikan respons tidak valid';

  @override
  String get teenModeEnableDescription =>
      'Aturan platform akan membatasi waktu penggunaan dan fitur tertentu.';

  @override
  String get teenModePasscode => 'Kode sandi';

  @override
  String get teenModeCurrentPasscode => 'Kode sandi saat ini';

  @override
  String get teenModeNewPasscode => 'Kode sandi baru';

  @override
  String get teenModePasscodeHint => 'Masukkan 4–6 digit';

  @override
  String get teenModeEnable => 'Aktifkan mode remaja';

  @override
  String get teenModeDisable => 'Nonaktifkan mode remaja';

  @override
  String get teenModeChangePasscode => 'Ubah kode sandi';

  @override
  String get teenModeSource => 'Diaktifkan oleh';

  @override
  String get teenModeDailyUsage => 'Digunakan hari ini';

  @override
  String get teenModeRemaining => 'Waktu tersisa';

  @override
  String get teenModeMinutesUnit => 'Menit';

  @override
  String get teenModeUnlimited => 'Tanpa batas';

  @override
  String get teenModeRequestExtension => 'Minta tambahan waktu';

  @override
  String get teenModeExtensionSubmitted => 'Permintaan waktu dikirim ke wali';

  @override
  String get teenModeTimeLimitReached =>
      'Batas penggunaan hari ini telah tercapai';

  @override
  String get teenModeCurfewActive =>
      'Saat ini dalam periode penggunaan terbatas';

  @override
  String get teenModeReliefHint =>
      'Anda tetap dapat melihat riwayat, menghubungi dukungan resmi, dan melaporkan masalah.';

  @override
  String get teenModeRestrictedNotice =>
      'Mode remaja saat ini melarang pengiriman pesan';

  @override
  String get teenModeActionBlocked =>
      'Mode remaja saat ini melarang tindakan ini';

  @override
  String get teenModeMyRequests => 'Permintaan saya';

  @override
  String get guardianCenterTitle => 'Pusat wali';

  @override
  String get guardianRelationships => 'Hubungan perwalian';

  @override
  String get guardianMinors => 'Anak yang saya awasi';

  @override
  String get guardianApprovals => 'Persetujuan tertunda';

  @override
  String get guardianBind => 'Masukkan kode pengaitan';

  @override
  String get guardianCreateMinorCode => 'Saya anak — buat kode';

  @override
  String get guardianCreateGuardianCode => 'Saya wali — buat kode';

  @override
  String get guardianRelation => 'Hubungan';

  @override
  String get guardianPrimary => 'Wali utama';

  @override
  String get guardianCode => 'Kode pengaitan 6 digit';

  @override
  String get guardianCodeHint => 'Masukkan kode dari pihak lain';

  @override
  String get guardianCodeCreated => 'Kode dibuat. Bagikan sebelum kedaluwarsa.';

  @override
  String get guardianEmpty => 'Tidak ada hubungan perwalian';

  @override
  String get guardianNoMinors => 'Tidak ada anak yang diawasi';

  @override
  String get guardianUnbind => 'Hapus hubungan';

  @override
  String get guardianExtend => 'Tambah waktu untuk anak';

  @override
  String get guardianPolicyTitle => 'Aturan penggunaan';

  @override
  String get guardianPolicyLocked => 'Dikunci oleh platform';

  @override
  String get approvalEmpty => 'Tidak ada permintaan';

  @override
  String get approvalApprove => 'Setuju';

  @override
  String get approvalReject => 'Tolak';

  @override
  String get approvalPending => 'Tertunda';

  @override
  String get approvalApproved => 'Disetujui';

  @override
  String get approvalRejected => 'Ditolak';

  @override
  String get approvalExpired => 'Kadaluwarsa';

  @override
  String get approvalCancelled => 'Dibatalkan';

  @override
  String get approvalReplayFailed => 'Tindakan awal gagal. Silakan coba lagi.';

  @override
  String get requestCancelled => 'Permintaan dibatalkan';

  @override
  String get kycTitle => 'Verifikasi Identitas';

  @override
  String get kycNotRequired => 'Verifikasi identitas tidak diperlukan';

  @override
  String get kycVerified => 'Identitas terverifikasi';

  @override
  String get kycDeclared => 'Informasi identitas dikirim';

  @override
  String get kycPending => 'Sedang ditinjau';

  @override
  String get kycRejected => 'Peninjauan ditolak';

  @override
  String get kycNone => 'Belum ada informasi identitas dikirim';

  @override
  String get kycRealName => 'Nama Lengkap';

  @override
  String get kycIdNumber => 'Nomor ID';

  @override
  String get kycIdType => 'Jenis dokumen';

  @override
  String get kycApplicability =>
      'Masukkan data asli sesuai dokumen yang dipilih. Jenis yang diterima tercantum dalam daftar.';

  @override
  String get kycCamera => 'Ambil Foto';

  @override
  String get kycGallery => 'Pilih dari Album';

  @override
  String get kycPhotoLimit => 'Maksimum per foto';

  @override
  String get kycSelectPhoto => 'Pilih Foto';

  @override
  String get kycPhotoSelected => 'Dipilih';

  @override
  String get kycViewPhoto => 'Ketuk untuk melihat foto';

  @override
  String get kycReplacePhoto => 'Pilih foto lain';

  @override
  String get kycDisclosure =>
      'Kami menggunakan nama, nomor dokumen, dan foto dokumen untuk meninjau identitas Anda. Tanpanya, permohonan tidak dapat dikirim dan beberapa fitur terbatas mungkin tidak tersedia.';

  @override
  String get kycConsent =>
      'Saya memberikan persetujuan terpisah untuk pemrosesan informasi identitas ini';

  @override
  String get kycConsentRequired =>
      'Berikan persetujuan terpisah sebelum mengirim';

  @override
  String get kycResubmitTitle => 'Kirim ulang informasi identitas';

  @override
  String get kycResubmitWarning =>
      'Pengiriman ulang akan mengganti permohonan yang sedang diproses. Lanjutkan?';

  @override
  String get kycSubmitting => 'Mengirim';

  @override
  String get kycSubmitFailed => 'Pengiriman gagal. Coba lagi.';

  @override
  String get kycSubmitUnavailable =>
      'Informasi identitas tidak dapat dikirim saat ini';

  @override
  String get kycResubmitNotAllowed =>
      'Pengiriman ulang tidak tersedia setelah penolakan. Hubungi dukungan jika diperlukan.';

  @override
  String get kycDailyLimit => 'Batas pengiriman hari ini tercapai. Coba besok.';

  @override
  String get kycTypeUnavailable =>
      'Tidak ada jenis dokumen tersedia. Coba lagi nanti.';

  @override
  String get kycNameInvalid => 'Nama resmi harus terdiri dari 2–64 karakter';

  @override
  String get kycNumberRequired => 'Masukkan nomor dokumen';

  @override
  String get kycFrontRequired => 'Unggah bagian depan dokumen';

  @override
  String get kycBackRequired => 'Unggah bagian belakang dokumen';

  @override
  String get kycPhotoTooLarge =>
      'Foto melebihi batas ukuran. Kompres lalu coba lagi.';

  @override
  String get kycAccountChanged =>
      'Akun atau ruang berubah. Buka kembali halaman ini.';

  @override
  String get kycPhotoInvalid => 'Pilih gambar yang valid';

  @override
  String get kycPortraitSide => 'Sisi foto wajah';

  @override
  String get kycEmblemSide => 'Sisi lambang';

  @override
  String get kycPassportDataPage => 'Halaman data paspor';

  @override
  String get kycPassportOtherPage => 'Halaman visa atau halaman kosong paspor';

  @override
  String get kycFront => 'Sisi depan ID';

  @override
  String get kycBack => 'Sisi belakang ID';

  @override
  String get kycRequired =>
      'Verifikasi identitas diperlukan sebelum membuat grup';

  @override
  String get kycGoVerify => 'Verifikasi sekarang';

  @override
  String get kycStatusUnknown =>
      'Status identitas tidak tersedia. Segarkan nanti.';

  @override
  String get kycSuperseded =>
      'Pengiriman yang lebih baru menggantikan ini. Periksa status identitas terbaru Anda.';

  @override
  String get kycMediaNotFound =>
      'Foto dokumen tidak tersedia di ruang ini. Pilih kembali sebelum mengirim.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Siaran pelanggan';

  @override
  String get officialAccountBadge => 'Resmi';

  @override
  String get officialAccountOpenConversation => 'Buka percakapan';

  @override
  String get officialAccountJoinHint =>
      'Menambahkan akun ini akan membuat Anda bergabung ke perusahaan sebagai pelanggan. Tidak perlu persetujuan pertemanan.';

  @override
  String get officialAccountJoinDisabled =>
      'Perusahaan ini tidak menerima pelanggan baru. Hubungi dukungan.';

  @override
  String get officialAccountRemoved =>
      'Anda dikeluarkan dari perusahaan ini. Minta perusahaan mengundang Anda lagi.';

  @override
  String get officialAccountBanned =>
      'Akun Anda dinonaktifkan di perusahaan ini.';

  @override
  String get officialAccountUnavailable =>
      'Akun resmi ini sedang tidak tersedia.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Bergabung ke perusahaan tidak diizinkan dalam mode saat ini.';

  @override
  String get officialAccountPlatformRequired =>
      'Gunakan akun platform untuk menambahkan akun resmi ini.';

  @override
  String get officialAccountOpenFailed =>
      'Percakapan tidak dapat dibuka. Coba lagi.';

  @override
  String get officialAccountAccountChanged =>
      'Akun atau ruang berubah. Silakan buka kembali.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Direktori perusahaan belum mutakhir. Coba sebentar lagi.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Sinkronisasi akun resmi gagal. Konten lokal tetap tersedia.';

  @override
  String get officialAccountInboxSyncing => 'Menyinkronkan pesan akun resmi';

  @override
  String get diagnosticsTitle => 'Diagnostik';

  @override
  String get diagnosticsExplanation =>
      'Log telah disamarkan dan berisi informasi operasi dan kesalahan untuk akun serta ruang ini, beserta peristiwa startup publik. Isi obrolan dan kredensial tidak disertakan.';

  @override
  String get diagnosticsHour => 'Satu jam terakhir';

  @override
  String get diagnosticsDay => '24 jam terakhir';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'Peristiwa tersedia: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Log disimpan di perangkat ini dan tetap tersedia setelah dimulai ulang.';

  @override
  String get diagnosticsNotPersistent =>
      'Sebagian log belum tersimpan. Segarkan untuk mencoba lagi.';

  @override
  String get diagnosticsExport => 'Ekspor dan bagikan';

  @override
  String get diagnosticsRefresh => 'Segarkan';

  @override
  String get diagnosticsClear => 'Hapus log ruang ini';

  @override
  String get diagnosticsClearConfirm =>
      'Hapus log diagnostik ruang ini? Riwayat obrolan tetap disimpan.';

  @override
  String get diagnosticsShared =>
      'Berbagi melalui sistem selesai. Pastikan berkas ada di aplikasi penerima.';

  @override
  String get diagnosticsCancelled =>
      'Berbagi dibatalkan. Anda dapat mengekspor lagi.';

  @override
  String get diagnosticsUnconfirmed =>
      'Berbagi tidak dapat dikonfirmasi. Periksa aplikasi penerima.';

  @override
  String get diagnosticsFailed => 'Operasi gagal. Silakan coba lagi.';
}
