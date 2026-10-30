// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get navWorkbench => 'พื้นที่ทำงาน';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'โหลดข้อมูลบัญชีไม่สำเร็จ';

  @override
  String get startupFailureTitle => 'เริ่มต้นไม่สำเร็จ';

  @override
  String get startupFailureMessage => 'ตรวจสอบเครือข่ายแล้วลองอีกครั้ง';

  @override
  String get privacyConsentTitle =>
      'ข้อกำหนดการให้บริการและนโยบายความเป็นส่วนตัว';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'ยินดีต้อนรับสู่ $brand เพื่อให้บริการเข้าสู่ระบบ การส่งข้อความโต้ตอบแบบทันที การทำงานร่วมกันในองค์กร บริการลูกค้าออนไลน์ การแจ้งเตือนข้อความ และการรักษาความปลอดภัย เราจำเป็นต้องประมวลผลข้อมูลที่จำเป็นตามข้อกำหนดการให้บริการและนโยบายความเป็นส่วนตัว\n\nก่อนที่คุณจะแตะยอมรับ เราจะไม่อ่านคลิปบอร์ด ไม่เริ่มต้น JPush/JCore หรือ SDK การแจ้งเตือนแบบพุชของผู้ผลิตอุปกรณ์ และไม่ใช้ SDK เหล่านี้เข้าถึง Android ID, OAID, รายการแอปที่ติดตั้ง, ที่อยู่ MAC หรือข้อมูลลักษณะเดียวกัน หากคุณยังไม่ยอมรับ เราจะบันทึกตัวเลือกนี้ไว้ คุณยังสามารถอ่านเอกสารต่อและเลือกใหม่ภายหลังได้\n\nหลังจากคุณยอมรับ เพื่อส่งการแจ้งเตือนข้อความ บริการลูกค้า และสายเรียกเข้า JPush/JCore และบริการพุชของผู้ผลิตอุปกรณ์อาจประมวลผลรุ่นอุปกรณ์ เวอร์ชัน Android ชื่อแพ็กเกจและเวอร์ชันแอป ประเภทเครือข่าย ที่อยู่ IP, Android ID, OAID, Registration ID, โทเค็นพุชของผู้ผลิต และข้อมูลการส่งและการกดการแจ้งเตือน เราปิดความสามารถที่ไม่จำเป็นแล้ว ได้แก่ พุชอัจฉริยะ รายการแอปที่ติดตั้ง MAC, IMEI, IMSI, รายการ Wi-Fi การปลุกอัตโนมัติ และการเริ่มต้นแบบเชื่อมโยง\n\nเราจะเข้าถึงคลิปบอร์ดเฉพาะเมื่อคุณใช้การคัดลอกหรือวาง และจะขอสิทธิ์กล้อง ไมโครโฟน การแจ้งเตือน และสิทธิ์ระบบอื่นเฉพาะเมื่อคุณใช้ฟีเจอร์ที่เกี่ยวข้อง การปฏิเสธสิทธิ์ใดจะกระทบเฉพาะฟีเจอร์นั้น โปรดอ่านเอกสารฉบับเต็มด้านล่างแล้วเลือกว่าจะยอมรับหรือไม่';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'ยินดีต้อนรับสู่ $brand เพื่อให้บริการเข้าสู่ระบบ การส่งข้อความโต้ตอบแบบทันที การทำงานร่วมกันในองค์กร บริการลูกค้าออนไลน์ การแจ้งเตือนข้อความ และการรักษาความปลอดภัย เราจำเป็นต้องประมวลผลข้อมูลที่จำเป็นตามข้อกำหนดการให้บริการและนโยบายความเป็นส่วนตัว\n\nก่อนที่คุณจะแตะยอมรับ เราจะไม่อ่านคลิปบอร์ด ไม่เริ่มต้น JPush/JCore ไม่ลงทะเบียนกับ Apple Push Notification service (APNs) และไม่รับตัวระบุพุช เช่น JPush Registration ID หรือโทเค็นอุปกรณ์ APNs หากคุณยังไม่ยอมรับ เราจะบันทึกตัวเลือกนี้ไว้ คุณยังสามารถอ่านเอกสารต่อและเลือกใหม่ภายหลังได้\n\nหลังจากคุณยอมรับ เพื่อส่งการแจ้งเตือนข้อความ บริการลูกค้า และสายเรียกเข้า เราอาจประมวลผลรุ่น iPhone เวอร์ชัน iOS ชื่อแพ็กเกจและเวอร์ชันแอป ประเภทเครือข่าย ที่อยู่ IP, IDFV, JPush Registration ID, โทเค็นอุปกรณ์ APNs และข้อมูลการส่งและการกดการแจ้งเตือน JPush/JCore เชื่อมต่อกับบริการพุช ส่วน Apple APNs ประมวลผลตัวระบุแอป โทเค็นอุปกรณ์ และเนื้อหาการแจ้งเตือนเพื่อส่งการแจ้งเตือนของระบบ แอป iOS ปัจจุบันไม่ใช้บริการโฆษณาและไม่รับ IDFA\n\nเราจะเข้าถึงคลิปบอร์ดเฉพาะเมื่อคุณใช้การคัดลอกหรือวาง และจะขอสิทธิ์กล้อง ไมโครโฟน การแจ้งเตือน และสิทธิ์ระบบอื่นเฉพาะเมื่อคุณใช้ฟีเจอร์ที่เกี่ยวข้อง การปฏิเสธสิทธิ์ใดจะกระทบเฉพาะฟีเจอร์นั้น โปรดอ่านเอกสารฉบับเต็มด้านล่างแล้วเลือกว่าจะยอมรับหรือไม่';
  }

  @override
  String get privacyConsentTermsLink => 'ข้อตกลงการใช้งาน';

  @override
  String get privacyConsentConjunction => 'และ';

  @override
  String get privacyConsentPrivacyLink => 'นโยบายความเป็นส่วนตัว';

  @override
  String get privacyConsentDecline => 'ไม่ตกลง';

  @override
  String get privacyConsentDeclinedExit =>
      'คุณไม่ได้ยอมรับข้อกำหนดการให้บริการและนโยบายความเป็นส่วนตัว แอปจะปิดลง';

  @override
  String get privacyConsentAccept => 'ตกลง';

  @override
  String get privacyConsentRuntimeFailure =>
      'เริ่มต้นไม่สำเร็จ ตรวจสอบเครือข่ายแล้วลองอีกครั้ง';

  @override
  String get privacyConsentSaveFailure =>
      'บันทึกตัวเลือกไม่ได้ โปรดลองอีกครั้ง';

  @override
  String get appUpdateRequiredTitle => 'ต้องอัปเดตเพื่อใช้งานต่อ';

  @override
  String get appUpdateOptionalTitle => 'มีเวอร์ชันใหม่พร้อมใช้งาน';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'มี $brand $version พร้อมใช้งาน';
  }

  @override
  String get appUpdateLater => 'ภายหลัง';

  @override
  String get appUpdateNow => 'อัปเดตเดี๋ยวนี้';

  @override
  String get appUpdateProcessing => 'กำลังประมวลผล...';

  @override
  String get appUpdateInvalidUrl => 'ที่อยู่อัปเดตไม่ถูกต้อง โปรดลองภายหลัง';

  @override
  String get appUpdateOpenUrlFailed => 'เปิดลิงก์อัปเดตไม่ได้ โปรดลองภายหลัง';

  @override
  String get appUpdateDownloadInterrupted =>
      'การดาวน์โหลดขัดข้อง ตรวจสอบเครือข่ายแล้วลองอีกครั้ง';

  @override
  String get appUpdatePackageVerificationFailed =>
      'ตรวจสอบแพ็กเกจไม่สำเร็จ โปรดดาวน์โหลดใหม่';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'อนุญาตให้ $brand ติดตั้งอัปเดตในการตั้งค่าระบบ';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'เปิดตัวติดตั้งของระบบไม่ได้ ตรวจสอบสิทธิ์การติดตั้ง';

  @override
  String get appUpdateGenericFailure =>
      'อัปเดตไม่สำเร็จ ตรวจสอบเครือข่ายแล้วลองอีกครั้ง';

  @override
  String get appUpdateUnavailable =>
      'เวอร์ชันใหม่ยังดาวน์โหลดไม่ได้ โปรดลองภายหลัง';

  @override
  String get appUpdateCheckFailed => 'ตรวจสอบอัปเดตไม่ได้ โปรดลองภายหลัง';

  @override
  String get appUpdateChecking => 'กำลังตรวจสอบ';

  @override
  String get commonConfirm => 'ตกลง';

  @override
  String get commonCancel => 'ยกเลิก';

  @override
  String get commonSave => 'บันทึก';

  @override
  String get commonEdit => 'แก้ไข';

  @override
  String get commonDelete => 'ลบ';

  @override
  String get commonSearch => 'ค้นหา';

  @override
  String get commonLoading => 'กำลังโหลด...';

  @override
  String get commonLoadFailed => 'ไม่สามารถโหลดได้';

  @override
  String get commonRetry => 'ลองใหม่';

  @override
  String get commonEmpty => 'ไม่มีข้อมูล';

  @override
  String get commonCopy => 'คัดลอก';

  @override
  String get commonForward => 'ส่งต่อ';

  @override
  String get commonFavorite => 'บันทึก';

  @override
  String get commonClose => 'ปิด';

  @override
  String get commonSend => 'ส่ง';

  @override
  String get commonDone => 'เสร็จสิ้น';

  @override
  String get commonMore => 'เพิ่มเติม';

  @override
  String get commonSettings => 'การตั้งค่า';

  @override
  String get commonCopied => 'คัดลอกแล้ว';

  @override
  String get commonUnknown => 'ไม่ทราบ';

  @override
  String get commonNotSet => 'ยังไม่ได้ตั้งค่า';

  @override
  String get commonUnbound => 'ยังไม่ได้ผูกบัญชี';

  @override
  String get commonViewAll => 'ดูทั้งหมด';

  @override
  String get commonSubmit => 'ส่ง';

  @override
  String get commonAdd => 'เพิ่ม';

  @override
  String get commonRemove => 'ลบ';

  @override
  String get commonCreate => 'สร้าง';

  @override
  String get commonUpdate => 'อัปเดต';

  @override
  String get commonUpload => 'อัปโหลด';

  @override
  String get commonShare => 'แชร์';

  @override
  String get commonBlock => 'บล็อก';

  @override
  String get commonUnblock => 'เลิกบล็อก';

  @override
  String get commonMute => 'ปิดเสียง';

  @override
  String get commonUnmute => 'เปิดเสียง';

  @override
  String get commonPin => 'ปักหมุด';

  @override
  String get commonUnpin => 'เลิกปักหมุด';

  @override
  String get commonMarkRead => 'ทำเครื่องหมายว่าอ่านแล้ว';

  @override
  String get commonMarkUnread => 'ทำเครื่องหมายว่ายังไม่อ่าน';

  @override
  String get commonOnline => 'ออนไลน์';

  @override
  String get commonOffline => 'ออฟไลน์';

  @override
  String get commonOperationFailed => 'ดำเนินการไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get commonNetworkError => 'เครือข่ายผิดพลาด โปรดตรวจสอบการเชื่อมต่อ';

  @override
  String get navMessages => 'ข้อความ';

  @override
  String get navContacts => 'รายชื่อผู้ติดต่อ';

  @override
  String get navMe => 'ฉัน';

  @override
  String get authLoginTitle => 'เข้าสู่ระบบ StartLink';

  @override
  String get authTabMobile => 'โทรศัพท์';

  @override
  String get authTabEmail => 'อีเมล';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'ป้อนหมายเลขโทรศัพท์';

  @override
  String get authHintEmail => 'ป้อนที่อยู่อีเมลของคุณ';

  @override
  String get authHintPassword => 'ป้อนรหัสผ่าน';

  @override
  String get authHintCode => 'ป้อนรหัสยืนยัน';

  @override
  String get authHintLoginName => 'ป้อน StartLink ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'เข้าสู่ระบบ';

  @override
  String get authGetCode => 'รับรหัส';

  @override
  String authResendCode(int seconds) {
    return 'ส่งอีกครั้งใน $seconds วินาที';
  }

  @override
  String get authUsePassword => 'ใช้รหัสผ่าน';

  @override
  String get authUseCode => 'ใช้รหัสยืนยัน';

  @override
  String get authAgreementPrefix => 'ฉันได้อ่านและยอมรับ';

  @override
  String get authAgreementAnd => 'และ';

  @override
  String get authTermsLink => 'ข้อตกลงการใช้งาน';

  @override
  String get authPrivacyLink => 'นโยบายความเป็นส่วนตัว';

  @override
  String get authCaptchaTitle => 'การยืนยันความปลอดภัย';

  @override
  String get authCaptchaHint => 'ป้อนคำตอบ';

  @override
  String get authCaptchaFailed => 'รับแคปต์ชาไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get authErrorEmptyCode => 'โปรดป้อนรหัสยืนยัน';

  @override
  String get authErrorEmptyPassword => 'ป้อนรหัสผ่าน';

  @override
  String get authErrorEmptyLoginName => 'โปรดป้อน StartLink ID';

  @override
  String get authErrorWrongCredentials => 'บัญชีหรือรหัสผ่านไม่ถูกต้อง';

  @override
  String get authDeactivatingTitle => 'การปิดบัญชี';

  @override
  String get authDeactivatingContent =>
      'บัญชีของคุณอยู่ในช่วงรอปิดบัญชี (7 วัน)\n\nหากต้องการยกเลิกการปิดบัญชี ให้แตะ \"ยกเลิกการปิดบัญชี\" หรือแตะ \"ใช้งานต่อ\" เพื่อเข้าสู่แอป';

  @override
  String get authContinueUse => 'ใช้งานต่อ';

  @override
  String get authCancelDeactivation => 'ยกเลิกการปิดบัญชี';

  @override
  String get authDeactivationCancelled =>
      'ยกเลิกการปิดบัญชีและคืนสถานะบัญชีแล้ว';

  @override
  String get authDeactivationCancelFailed => 'ยกเลิกไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get authLogout => 'ออกจากระบบ';

  @override
  String get authLogoutConfirm => 'ต้องการออกจากระบบหรือไม่?';

  @override
  String get authSendingCode => 'กำลังส่ง...';

  @override
  String get authCodeSent => 'ส่งรหัสยืนยันแล้ว';

  @override
  String get authLoginFailed => 'เข้าสู่ระบบไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get authRegisterFailed => 'ลงทะเบียนไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get authEnterpriseCode => 'รหัสองค์กร';

  @override
  String get authEnterpriseCodeHint => 'ป้อนรหัสองค์กร';

  @override
  String get authPendingApproval =>
      'ลงทะเบียนสำเร็จ ส่งคำขอเข้าร่วมองค์กรแล้วและกำลังรออนุมัติ';

  @override
  String get authNoAccount => 'ยังไม่มีบัญชีใช่ไหม?';

  @override
  String get authRegisterNow => 'ลงทะเบียนตอนนี้';

  @override
  String get authCountryPickerTitle => 'เลือกประเทศ/ภูมิภาค';

  @override
  String get authCountrySearchHint => 'ค้นหาประเทศ/ภูมิภาค';

  @override
  String get authCountryChinaMainland => 'จีนแผ่นดินใหญ่';

  @override
  String get authCountryHongKong => 'ฮ่องกง จีน';

  @override
  String get authCountryMacau => 'มาเก๊า จีน';

  @override
  String get authCountryTaiwan => 'ไต้หวัน จีน';

  @override
  String get authCountryUnitedStates => 'สหรัฐอเมริกา';

  @override
  String get authCountryUnitedKingdom => 'สหราชอาณาจักร';

  @override
  String get authCountryJapan => 'ญี่ปุ่น';

  @override
  String get authCountrySouthKorea => 'เกาหลีใต้';

  @override
  String get authCountrySingapore => 'สิงคโปร์';

  @override
  String get authCountryMalaysia => 'มาเลเซีย';

  @override
  String get authCountryAustralia => 'ออสเตรเลีย';

  @override
  String get authCountryCanada => 'แคนาดา';

  @override
  String get authCountryGermany => 'เยอรมนี';

  @override
  String get authCountryFrance => 'ฝรั่งเศส';

  @override
  String get authCountryIndia => 'อินเดีย';

  @override
  String get authCountryThailand => 'ไทย';

  @override
  String get authCountryVietnam => 'เวียดนาม';

  @override
  String get authCountryIndonesia => 'อินโดนีเซีย';

  @override
  String get authCountryPhilippines => 'ฟิลิปปินส์';

  @override
  String get authQuickLoginTitle => 'เข้าสู่ระบบด่วน';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'กำลังเข้าสู่ระบบ โปรดรอสักครู่';

  @override
  String get authRoleOwner => 'เจ้าของ';

  @override
  String get authRoleAdministrator => 'ผู้ดูแลระบบ';

  @override
  String get authRoleCustomerService => 'บริการลูกค้า';

  @override
  String get authRoleTechnicalSupport => 'ฝ่ายสนับสนุนทางเทคนิค';

  @override
  String get authRoleEmployee => 'พนักงาน';

  @override
  String get authRoleMember => 'สมาชิก';

  @override
  String get authRoleEnterpriseCustomer => 'ลูกค้าองค์กร';

  @override
  String get authUnavailablePrefix => 'ไม่พร้อมใช้งาน · ';

  @override
  String get authUnassignedService => 'ยังไม่ได้มอบหมายเจ้าหน้าที่';

  @override
  String authAssignedService(String staff) {
    return 'มอบหมายให้ $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'ลูกค้า · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'พนักงาน · $tenant';
  }

  @override
  String authUserCount(int count) {
    return 'ผู้ใช้ $count คน';
  }

  @override
  String get authMetaPhone => 'โทรศัพท์';

  @override
  String get authMetaIdentity => 'สถานะ';

  @override
  String get authRegisterTitle => 'สมัครสมาชิก';

  @override
  String get authNickname => 'ชื่อเล่น';

  @override
  String get authNicknameHint => 'ตั้งชื่อเล่น';

  @override
  String get authPassword => 'รหัสผ่าน';

  @override
  String get authPasswordSetHint => 'ตั้งรหัสผ่าน (อย่างน้อย 6 อักขระ)';

  @override
  String get authConfirmPassword => 'ยืนยันรหัสผ่าน';

  @override
  String get authConfirmPasswordHint => 'ป้อนรหัสผ่านอีกครั้ง';

  @override
  String get authVerificationCode => 'รหัสยืนยัน';

  @override
  String get authRegisterAndLogin => 'ลงทะเบียนและเข้าสู่ระบบ';

  @override
  String get authHaveAccount => 'มีบัญชีอยู่แล้ว?';

  @override
  String get authGoLogin => 'เข้าสู่ระบบ';

  @override
  String get authEmailVerificationUnavailable =>
      'การยืนยันอีเมลไม่พร้อมใช้งาน โปรดลงทะเบียนด้วยหมายเลขมือถือ';

  @override
  String get authSmsVerificationUnavailable =>
      'การยืนยัน SMS ไม่พร้อมใช้งาน โปรดลงทะเบียนด้วยอีเมล';

  @override
  String get authSendFailed => 'ส่งไม่ได้ โปรดลองอีกครั้ง';

  @override
  String get authErrorEmptyNickname => 'ป้อนชื่อเล่น';

  @override
  String get authErrorInvalidMobile => 'ป้อนหมายเลขมือถือที่ถูกต้อง';

  @override
  String get authErrorInvalidEmail => 'ป้อนที่อยู่อีเมลที่ถูกต้อง';

  @override
  String get authErrorPasswordTooShort => 'รหัสผ่านต้องมีอย่างน้อย 6 อักขระ';

  @override
  String get authErrorPasswordMismatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get authErrorVerificationRequired => 'ขอและป้อนรหัสยืนยันก่อน';

  @override
  String get authRegisterErrorTitle => 'ลงทะเบียนไม่สำเร็จ';

  @override
  String get authGotIt => 'เข้าใจแล้ว';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'ไม่พบองค์กร \"$code\" โปรดตรวจสอบรหัสองค์กร';
  }

  @override
  String get authTenantSearchFailed => 'ค้นหาไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get authInvitationInvalid =>
      'รหัสเชิญไม่ถูกต้อง ตรวจสอบแล้วลองอีกครั้ง';

  @override
  String get authCollapseJoin => 'ซ่อนข้อมูลการเข้าร่วม';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'คำเชิญถูกต้อง: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'พบองค์กร: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'เลือกองค์กร';

  @override
  String get authNoOrganization => 'ไม่มีองค์กรที่พร้อมใช้งาน';

  @override
  String get authNoOrganizationHint => 'ขอให้ผู้ดูแลระบบเชิญคุณเข้าองค์กร';

  @override
  String get authPersonalSpace => 'พื้นที่ส่วนตัว';

  @override
  String get authPersonalSpaceSubtitle => 'แชทกับเพื่อนและรายการโปรดส่วนตัว';

  @override
  String get authSpaceIdentityValidationFailed =>
      'ตรวจสอบตัวตนในพื้นที่ไม่ได้ โปรดลองอีกครั้ง';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'คืนค่าพื้นที่ส่วนตัวไม่ได้ โปรดลองอีกครั้ง';

  @override
  String get authJoinEnterpriseFailed => 'เข้าร่วมองค์กรไม่ได้ โปรดลองภายหลัง';

  @override
  String get homeTitle => 'ข้อความ';

  @override
  String get homeGatewayConnectingTitle => 'กำลังเชื่อมต่อ';

  @override
  String get homePersonalSpace => 'ส่วนตัว';

  @override
  String get homeOfficialService => 'บริการอย่างเป็นทางการ';

  @override
  String get homeSwitchSpace => 'สลับพื้นที่';

  @override
  String get homeSpaceSubtitle => 'ส่วนตัว · องค์กร';

  @override
  String get homeJoinEnterprise => 'เข้าร่วมองค์กร';

  @override
  String get homeCreateGroup => 'กลุ่มใหม่';

  @override
  String get homeAddFriend => 'เพิ่มผู้ติดต่อ';

  @override
  String get homeScan => 'สแกน';

  @override
  String get homeJoinNewSpace => 'เข้าร่วมพื้นที่ใหม่';

  @override
  String get homeSearchConversation => 'ค้นหา';

  @override
  String get homeNoMessages => 'ไม่มีข้อความ';

  @override
  String get homeDeleteConversation => 'ลบแชท';

  @override
  String get homeDeleteConversationConfirm =>
      'ลบแชทนี้หรือไม่? ประวัติแชทจะถูกล้าง';

  @override
  String get homePersonalNote => 'ฉัน (บันทึกส่วนตัว)';

  @override
  String get homeWorkNote => 'ฉัน (บันทึกงาน)';

  @override
  String homeConversationCount(int count) {
    return 'แชท $count รายการ';
  }

  @override
  String homeUnreadCount(int count) {
    return 'ยังไม่อ่าน $count รายการ';
  }

  @override
  String get chatInputHint => 'พิมพ์ข้อความ...';

  @override
  String get chatVoiceHint => 'กดค้างเพื่อพูด';

  @override
  String get chatVoiceRelease => 'ปล่อยเพื่อส่ง';

  @override
  String get chatVoiceCancel => 'เลื่อนขึ้นเพื่อยกเลิก';

  @override
  String get chatMenuCopy => 'คัดลอก';

  @override
  String get chatMenuForward => 'ส่งต่อ';

  @override
  String get chatMenuRecall => 'เรียกคืน';

  @override
  String get chatMenuDelete => 'ลบ';

  @override
  String get chatMenuFavorite => 'บันทึก';

  @override
  String get chatMenuReply => 'ตอบกลับ';

  @override
  String get chatMenuMultiSelect => 'เลือก';

  @override
  String get chatMenuTranslate => 'แปล';

  @override
  String get chatMenuVoiceToText => 'แปลงเป็นข้อความ';

  @override
  String get chatMenuTextToSpeech => 'อ่านออกเสียง';

  @override
  String get chatStatusRecalled => 'เรียกคืนข้อความแล้ว';

  @override
  String get chatRecallSuccess => 'เรียกคืนแล้ว';

  @override
  String get chatRecallFailed => 'เรียกคืนไม่สำเร็จ';

  @override
  String get chatRecallTimeout => 'เรียกคืนข้อความที่เกิน 2 นาทีไม่ได้';

  @override
  String get chatTranslateFailed => 'แปลไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get chatTranslateNotConfigured => 'บริการแปลไม่พร้อมใช้งาน';

  @override
  String get chatVoiceToTextFailed => 'แปลงไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get chatTextToSpeechFailed => 'อ่านออกเสียงไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get chatVoiceToText => 'แปลง';

  @override
  String get chatForwardSuccess => 'ส่งต่อแล้ว';

  @override
  String get chatForwardFailed => 'ส่งต่อไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get chatNoConversations => 'ไม่มีแชทสำหรับส่งต่อ';

  @override
  String get chatSendFailed => 'ส่งไม่สำเร็จ';

  @override
  String get chatResend => 'ส่งอีกครั้ง';

  @override
  String get chatNotFriend => 'ไม่อยู่ในรายชื่อผู้ติดต่อ';

  @override
  String get chatNotFriendHint =>
      'คุณยังไม่ได้เป็นผู้ติดต่อกัน ส่งข้อความไม่ได้';

  @override
  String get chatMutedHint => 'สมาชิกทุกคนถูกปิดสิทธิ์ส่งข้อความ';

  @override
  String get chatFileUploadFailed => 'อัปโหลดไฟล์ไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get chatFileStatusNotDownloaded => 'ยังไม่ได้ดาวน์โหลด';

  @override
  String get chatFileStatusDownloaded => 'ดาวน์โหลดแล้ว';

  @override
  String get chatFileStatusUploading => 'กำลังอัปโหลด';

  @override
  String get chatFileStatusUploadFailed => 'อัปโหลดล้มเหลว';

  @override
  String get chatCardSendFailed => 'ส่งบัตรผู้ติดต่อไม่สำเร็จ';

  @override
  String get chatFavoriteSuccess => 'บันทึกแล้ว';

  @override
  String get chatFavoriteFailed => 'เพิ่มในรายการโปรดไม่สำเร็จ';

  @override
  String get chatLoadFailed => 'ไม่สามารถโหลดได้';

  @override
  String get chatImageMessage => '[รูปภาพ]';

  @override
  String get chatVoiceMessage => '[ข้อความเสียง]';

  @override
  String get chatVideoMessage => '[วิดีโอ]';

  @override
  String get chatFileMessage => '[ไฟล์]';

  @override
  String get chatLocationMessage => '[ตำแหน่ง]';

  @override
  String get chatContactCardMessage => '[ผู้ติดต่อ]';

  @override
  String get chatCallLogMessage => '[การโทร]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'อ่านแล้ว $count คน';
  }

  @override
  String get chatUnread => 'ยังไม่อ่าน';

  @override
  String get chatRecalledSelf => 'คุณเรียกคืนข้อความ';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender เรียกคืนข้อความ';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'คำแปล: $translation';
  }

  @override
  String get chatMessageDeleted => 'ลบข้อความแล้ว';

  @override
  String get chatPeer => 'อื่นๆ';

  @override
  String get chatSelf => 'ฉัน';

  @override
  String get chatGenericMessage => '[ข้อความ]';

  @override
  String get chatVoiceHideText => 'ซ่อนข้อความ';

  @override
  String get chatVoiceShowText => 'แปลงเป็นข้อความ';

  @override
  String get chatFileDefaultName => 'ไฟล์';

  @override
  String get chatContactDefaultName => 'ผู้ติดต่อ';

  @override
  String get chatContactCardTitle => 'บัตรผู้ติดต่อ';

  @override
  String get chatCallMissed => 'ไม่ได้รับสาย';

  @override
  String get chatCallCancelled => 'ยกเลิกแล้ว';

  @override
  String get chatCallRejected => 'ปฏิเสธแล้ว';

  @override
  String get chatCallDisconnected => 'การเชื่อมต่อขาดหาย';

  @override
  String get chatCallEnded => 'สิ้นสุดการโทร';

  @override
  String get chatCallFailed => 'โทรไม่สำเร็จ';

  @override
  String chatCallDuration(String duration) {
    return 'ระยะเวลา $duration';
  }

  @override
  String get chatVideoCallTitle => 'วิดีโอคอล';

  @override
  String get chatVoiceCallTitle => 'โทรด้วยเสียง';

  @override
  String get chatToolPhotos => 'รูปภาพ';

  @override
  String get chatToolCamera => 'กล้อง';

  @override
  String get chatToolFile => 'ไฟล์';

  @override
  String get chatToolLocation => 'ตำแหน่ง';

  @override
  String get chatToolContactCard => 'ผู้ติดต่อ';

  @override
  String get chatToolVoiceCall => 'โทรด้วยเสียง';

  @override
  String get chatToolVideoCall => 'วิดีโอคอล';

  @override
  String get chatToolFavorites => 'รายการโปรด';

  @override
  String get chatToolTranslate => 'แปล';

  @override
  String get chatTranslationChooseLanguage => 'เลือกภาษาที่จะแปล';

  @override
  String get chatTranslationEnterText => 'ป้อนข้อความก่อน';

  @override
  String get chatTranslationMentionsUnsupported =>
      'ไม่รองรับการแปลข้อความที่มีการกล่าวถึง';

  @override
  String get chatTranslationScheduledUnsupported =>
      'แปลไม่ได้ขณะแก้ไขข้อความที่ตั้งเวลาส่ง';

  @override
  String get chatTranslationFailed => 'แปลไม่สำเร็จ ลองอีกครั้ง';

  @override
  String get chatTranslationEmpty => 'ไม่ได้รับคำแปล ลองอีกครั้ง';

  @override
  String get chatTranslationTranslating => 'กำลังแปล…';

  @override
  String get chatTranslationSend => 'ส่งคำแปล';

  @override
  String get chatTranslationSending => 'กำลังส่ง…';

  @override
  String get chatTranslationExpand => 'แสดงเพิ่มเติม';

  @override
  String get chatTranslationCollapse => 'แสดงน้อยลง';

  @override
  String get chatFileTooLarge => 'ไฟล์เกินขนาดที่กำหนด (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'มีเพียงเจ้าของหรือสมาชิกที่เลือกไว้เท่านั้นที่ส่งข้อความได้';

  @override
  String get chatImageUploadUnsupported =>
      'อัปโหลดรูปภาพไม่สำเร็จ เซิร์ฟเวอร์ยังไม่รองรับ';

  @override
  String get chatFavoriteLongPressHint => 'กดข้อความค้างเพื่อเพิ่มในรายการโปรด';

  @override
  String chatSelectedCount(int count) {
    return 'เลือกแล้ว $count รายการ';
  }

  @override
  String get chatLocationSheetTitle => 'ส่งตำแหน่ง';

  @override
  String get chatLocationNameLabel => 'ชื่อสถานที่';

  @override
  String get chatLocationNameHint => 'เช่น สำนักงาน ที่อยู่ลูกค้า';

  @override
  String get chatLocationAddressLabel => 'ที่อยู่';

  @override
  String get chatLocationOptionalHint => 'ไม่บังคับ';

  @override
  String get chatLocationLatitudeLabel => 'ละติจูด';

  @override
  String get chatLocationLatitudeHint => '-90 ถึง 90';

  @override
  String get chatLocationLongitudeLabel => 'ลองจิจูด';

  @override
  String get chatLocationLongitudeHint => '-180 ถึง 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'ป้อน $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label อยู่นอกช่วงที่กำหนด';
  }

  @override
  String get chatLocationDefaultTitle => 'ตำแหน่ง';

  @override
  String get chatMutedFullNotice =>
      'กลุ่มนี้ปิดสิทธิ์ส่งข้อความ มีเพียงเจ้าของหรือสมาชิกที่เลือกไว้เท่านั้นที่ส่งได้';

  @override
  String get chatNotFriendSendBlocked =>
      'คุณไม่ได้เป็นเพื่อนกันแล้วและส่งข้อความไม่ได้';

  @override
  String get chatPersonalNotesTitle => 'บันทึกส่วนตัว';

  @override
  String get chatWorkNotesTitle => 'บันทึกงาน';

  @override
  String get chatPersonalNotesDescription =>
      'จดความคิดส่วนตัวและบันทึกข้อมูลสำคัญไว้ที่นี่\nซิงค์ระหว่างอุปกรณ์เพื่อเข้าถึงได้ทุกเมื่อ';

  @override
  String get chatWorkNotesDescription =>
      'จดงานและเก็บเอกสารการทำงานไว้ที่นี่\nพื้นที่ของทีมแยกจากกันและปลอดภัย';

  @override
  String get chatNoMessages => 'ไม่มีข้อความ';

  @override
  String chatReplyTo(String sender) {
    return 'ตอบกลับ $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature เร็วๆ นี้';
  }

  @override
  String get chatForwardSelectTitle => 'เลือกแชท';

  @override
  String get chatContactSelectTitle => 'เลือกผู้ติดต่อ';

  @override
  String get chatNoContacts => 'ไม่มีผู้ติดต่อ';

  @override
  String get contactsTitle => 'รายชื่อผู้ติดต่อ';

  @override
  String get contactsSearch => 'ค้นหาผู้ติดต่อ';

  @override
  String get contactsNewFriends => 'เพื่อนใหม่';

  @override
  String get contactsGroups => 'กลุ่ม';

  @override
  String get contactsFavorites => 'รายการโปรด';

  @override
  String get contactsRecent => 'ล่าสุด';

  @override
  String get contactsOrganization => 'องค์กร';

  @override
  String get contactsAnnouncement => 'ประกาศ';

  @override
  String get contactsNewApplications => 'คำขอใหม่';

  @override
  String get contactsCustomerGroups => 'กลุ่มลูกค้า';

  @override
  String get contactsAllCustomers => 'ลูกค้าทั้งหมด';

  @override
  String get contactsMyCustomers => 'ลูกค้าของฉัน';

  @override
  String get contactsViewAll => 'ดูทั้งหมด';

  @override
  String get contactsMyContacts => 'ผู้ติดต่อของฉัน';

  @override
  String get contactsMyAdvisor => 'ที่ปรึกษาของฉัน';

  @override
  String get contactsNoAdvisor => 'ยังไม่ได้มอบหมายที่ปรึกษา';

  @override
  String get contactsAdvisorLoading => 'กำลังโหลด...';

  @override
  String get contactsNavigateFailed => 'เปิดหน้าไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get contactsEmpty => 'ไม่มีผู้ติดต่อ';

  @override
  String get contactsNoAnnouncement => 'ไม่มีประกาศ';

  @override
  String get contactsOfficialBadge => 'ทางการ';

  @override
  String get contactsCustomerBadge => 'ลูกค้า';

  @override
  String get contactsEmptyCustomers => 'ไม่มีลูกค้า';

  @override
  String get myTitle => 'ฉัน';

  @override
  String get myEnterpriseInfo => 'ข้อมูลองค์กร';

  @override
  String get myEnterpriseManage => 'จัดการองค์กร';

  @override
  String get myQrCode => 'คิวอาร์โค้ด';

  @override
  String get myFavorites => 'รายการโปรด';

  @override
  String get myLanguage => 'ภาษา';

  @override
  String get myTimezone => 'เขตเวลา';

  @override
  String get myAutoTranslate => 'แปลอัตโนมัติ';

  @override
  String get myNetworkSwitch => 'สลับสาย';

  @override
  String get mySettings => 'การตั้งค่า';

  @override
  String get myLogout => 'ออกจากระบบ';

  @override
  String get myLogoutConfirm => 'ต้องการออกจากระบบหรือไม่?';

  @override
  String get myLeaveEnterprise => 'ออกจากองค์กร';

  @override
  String get myLeaveEnterpriseConfirm =>
      'ต้องการออกจากองค์กรนี้หรือไม่? คุณจะเสียสิทธิ์เข้าถึงข้อมูลขององค์กร';

  @override
  String get myLeaveEnterpriseSuccess => 'ออกจากองค์กรแล้ว';

  @override
  String get myLeaveEnterpriseFailed => 'ออกจากองค์กรไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get myLppIdCopied => 'คัดลอก StartLink ID แล้ว';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return 'ผู้ติดต่อ $count คน';
  }

  @override
  String get myAutoSelect => 'อัตโนมัติ';

  @override
  String get myPresenceStatus => 'สถานะการใช้งาน';

  @override
  String get myPresenceStatusTitle => 'ตั้งสถานะการใช้งาน';

  @override
  String get myPresenceOnline => 'ออนไลน์';

  @override
  String get myPresenceBusy => 'ไม่ว่าง';

  @override
  String get myPresenceAway => 'ไม่อยู่';

  @override
  String get myPresenceInvisible => 'ไม่แสดงตัว';

  @override
  String get profileTitle => 'โปรไฟล์ของฉัน';

  @override
  String get profileName => 'ชื่อ';

  @override
  String get profileGender => 'เพศ';

  @override
  String get profileBirthday => 'วันเกิด';

  @override
  String get profileRegion => 'ภูมิภาค';

  @override
  String get profileSignature => 'ประวัติย่อ';

  @override
  String get profileSignatureHint => 'เล่าเกี่ยวกับตัวคุณ';

  @override
  String get profileTapTapText => 'สะกิด';

  @override
  String get profileTapTapHint => 'ข้อความเมื่อถูกสะกิด (สูงสุด 20 อักขระ)';

  @override
  String get profileAccountSection => 'บัญชี';

  @override
  String get profileBasicSection => 'ข้อมูลพื้นฐาน';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'ยังไม่ได้ตั้งค่า';

  @override
  String get profileMobile => 'โทรศัพท์';

  @override
  String get profileMobileUnbound => 'ยังไม่ได้ผูกบัญชี';

  @override
  String get profileEmail => 'อีเมล';

  @override
  String get profileEmailUnbound => 'ยังไม่ได้ผูกบัญชี';

  @override
  String get profileQrCode => 'คิวอาร์โค้ดของฉัน';

  @override
  String get profileChangePassword => 'เปลี่ยนรหัสผ่าน';

  @override
  String get profileGenderMale => 'ชาย';

  @override
  String get profileGenderFemale => 'หญิง';

  @override
  String get profileGenderOther => 'อื่นๆ';

  @override
  String get profileGenderUnset => 'ยังไม่ได้ตั้งค่า';

  @override
  String get profileSaveFailed => 'บันทึกไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'เปลี่ยน StartLink ID ได้เพียงครั้งเดียว โปรดเลือกอย่างรอบคอบ';

  @override
  String get profileLppIdChangeFailed =>
      'เปลี่ยนไม่สำเร็จ (เปลี่ยน StartLink ID ได้เพียงครั้งเดียว)';

  @override
  String get profileChangePasswordOld => 'รหัสผ่านปัจจุบัน';

  @override
  String get profileChangePasswordNew => 'รหัสผ่านใหม่';

  @override
  String get profileChangePasswordConfirm => 'ยืนยันรหัสผ่านใหม่';

  @override
  String get profileChangePasswordMismatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get profileChangePasswordSuccess =>
      'เปลี่ยนรหัสผ่านแล้ว โปรดเข้าสู่ระบบใหม่';

  @override
  String get profileChangePasswordFailed =>
      'เปลี่ยนรหัสผ่านไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get settingsSectionEnterprise => 'องค์กร';

  @override
  String get settingsSectionAccount => 'บัญชี';

  @override
  String get settingsSectionGeneral => 'ทั่วไป';

  @override
  String get settingsSectionFeatures => 'ฟีเจอร์';

  @override
  String get settingsSectionAbout => 'เกี่ยวกับ';

  @override
  String get settingsEnterpriseInfo => 'ข้อมูลองค์กร';

  @override
  String get settingsProfile => 'โปรไฟล์ของฉัน';

  @override
  String get settingsAccountSecurity => 'ความปลอดภัยของบัญชี';

  @override
  String get settingsNotification => 'การแจ้งเตือน';

  @override
  String get settingsDisplay => 'การแสดงผล';

  @override
  String get settingsFriendPrivacy => 'ความเป็นส่วนตัว';

  @override
  String get settingsChat => 'แชท';

  @override
  String get settingsChatHistory => 'ประวัติแชท';

  @override
  String get settingsAbout => 'เกี่ยวกับ StartLink';

  @override
  String get settingsLanguage => 'ภาษา';

  @override
  String get settingsTimezone => 'เขตเวลา';

  @override
  String get settingsAutoTranslate => 'แปลอัตโนมัติ';

  @override
  String get settingsNetworkSwitch => 'สลับสาย';

  @override
  String get enterpriseInfoTitle => 'ข้อมูลองค์กร';

  @override
  String get enterpriseName => 'ชื่อ';

  @override
  String get enterpriseDescription => 'คำอธิบาย';

  @override
  String get enterpriseUpdateSuccess => 'อัปเดตเรียบร้อยแล้ว';

  @override
  String get enterpriseUpdateFailed => 'อัปเดตไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get enterpriseLeave => 'ออกจากองค์กร';

  @override
  String get enterpriseLeaveConfirm => 'ต้องการออกจากองค์กรนี้หรือไม่?';

  @override
  String get enterpriseLeaveSuccess => 'ออกจากองค์กรแล้ว';

  @override
  String get enterpriseLeaveFailed => 'ออกจากองค์กรไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get enterpriseLeaveOwnerError =>
      'เจ้าของออกจากองค์กรโดยตรงไม่ได้ โปรดโอนความเป็นเจ้าของก่อน';

  @override
  String get enterpriseMemberCount => 'สมาชิก';

  @override
  String get enterpriseCreatedAt => 'วันที่สร้าง';

  @override
  String get enterpriseCode => 'รหัสองค์กร';

  @override
  String get enterpriseInviteMembers => 'เชิญสมาชิก';

  @override
  String get enterpriseCopyInviteCode => 'คัดลอกรหัสเชิญ';

  @override
  String get enterpriseInviteCodeCopied => 'คัดลอกรหัสเชิญแล้ว';

  @override
  String get groupCreateTitle => 'กลุ่มใหม่';

  @override
  String get groupNameHint => 'ป้อนชื่อกลุ่ม';

  @override
  String get groupCreateSuccess => 'สร้างกลุ่มแล้ว';

  @override
  String get groupCreateFailed => 'สร้างกลุ่มไม่สำเร็จ';

  @override
  String get groupSettings => 'การตั้งค่ากลุ่ม';

  @override
  String get groupName => 'ชื่อกลุ่ม';

  @override
  String get groupAvatar => 'รูปประจำกลุ่ม';

  @override
  String get groupAnnouncement => 'ประกาศ';

  @override
  String get groupMembers => 'สมาชิก';

  @override
  String get groupAddMember => 'เพิ่มสมาชิก';

  @override
  String get groupRemoveMember => 'นำสมาชิกออก';

  @override
  String get groupRemoveMemberConfirm => 'นำสมาชิกคนนี้ออกหรือไม่?';

  @override
  String get groupSetAdmin => 'ตั้งเป็นผู้ดูแล';

  @override
  String get groupRemoveAdmin => 'ยกเลิกผู้ดูแล';

  @override
  String get groupTransferOwner => 'โอนความเป็นเจ้าของ';

  @override
  String get groupTransferOwnerConfirm =>
      'โอนความเป็นเจ้าของกลุ่มให้สมาชิกคนนี้หรือไม่?';

  @override
  String get groupTransferOwnerSuccess => 'โอนความเป็นเจ้าของแล้ว';

  @override
  String get groupTransferOwnerFailed => 'โอนไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get groupLeave => 'ออกจากกลุ่ม';

  @override
  String get groupLeaveConfirm => 'ออกจากกลุ่มนี้หรือไม่?';

  @override
  String get groupLeaveSuccess => 'ออกจากกลุ่มแล้ว';

  @override
  String get groupLeaveFailed => 'ออกจากองค์กรไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get groupDissolve => 'ยุบกลุ่ม';

  @override
  String get groupDissolveConfirm =>
      'ยุบกลุ่มนี้หรือไม่? สมาชิกทั้งหมดจะถูกนำออก';

  @override
  String get groupDissolveSuccess => 'ยุบกลุ่มแล้ว';

  @override
  String get groupDissolveFailed => 'ยุบกลุ่มไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get groupQrCode => 'คิวอาร์โค้ดของกลุ่ม';

  @override
  String get groupMuteAll => 'ปิดสิทธิ์ส่งข้อความทั้งหมด';

  @override
  String get groupMuteAllOn => 'เปิดการปิดสิทธิ์ส่งข้อความทั้งหมด';

  @override
  String get groupMuteAllOff => 'ปิดการปิดสิทธิ์ส่งข้อความทั้งหมด';

  @override
  String get groupAllowMemberInvite => 'อนุญาตให้สมาชิกเชิญผู้อื่น';

  @override
  String get groupAllowMemberModifyTitle => 'อนุญาตให้สมาชิกเปลี่ยนชื่อกลุ่ม';

  @override
  String get groupAllowMemberAtAll => 'อนุญาตให้สมาชิกกล่าวถึง @ทุกคน';

  @override
  String get groupAllowMemberViewMemberList => 'อนุญาตให้สมาชิกดูรายชื่อสมาชิก';

  @override
  String get groupAllowQrCodeJoin => 'อนุญาตให้เข้าร่วมด้วยคิวอาร์โค้ด';

  @override
  String get groupRequireApproval => 'ต้องอนุมัติก่อนเข้าร่วม';

  @override
  String get groupAllowMemberAddFriend => 'อนุญาตให้สมาชิกเพิ่มกันเป็นเพื่อน';

  @override
  String get groupRoleOwner => 'เจ้าของ';

  @override
  String get groupRoleAdmin => 'ผู้ดูแล';

  @override
  String get groupRoleMember => 'สมาชิก';

  @override
  String get groupNoMembers => 'ไม่มีสมาชิก';

  @override
  String get groupNoAnnouncements => 'ไม่มีประกาศ';

  @override
  String get groupCreateAnnouncement => 'โพสต์ประกาศ';

  @override
  String get groupEditAnnouncement => 'แก้ไขประกาศ';

  @override
  String get groupDeleteAnnouncement => 'ลบประกาศ';

  @override
  String get groupDeleteAnnouncementConfirm => 'ลบประกาศนี้หรือไม่?';

  @override
  String get groupAnnouncementTitle => 'หัวข้อ';

  @override
  String get groupAnnouncementContent => 'เนื้อหา';

  @override
  String get groupAnnouncementPin => 'ปักหมุดประกาศ';

  @override
  String groupMemberCount(int count) {
    return 'สมาชิก $count คน';
  }

  @override
  String groupSelectedCount(int count) {
    return 'เลือกแล้ว $count รายการ';
  }

  @override
  String get groupJoinRequestApprove => 'ตกลง';

  @override
  String get groupJoinRequestReject => 'ปฏิเสธ';

  @override
  String get groupJoinRequests => 'คำขอเข้าร่วม';

  @override
  String get groupNoJoinRequests => 'ไม่มีคำขอเข้าร่วม';

  @override
  String get groupReadReceipts => 'สถานะการอ่าน';

  @override
  String groupReadCount(int count) {
    return 'อ่านแล้ว $count คน';
  }

  @override
  String groupUnreadCount(int count) {
    return 'ยังไม่อ่าน $count รายการ';
  }

  @override
  String get friendAddTitle => 'เพิ่มผู้ติดต่อ';

  @override
  String get friendSearchHint => 'โทรศัพท์ / อีเมล / StartLink ID';

  @override
  String get friendRequestSent => 'ส่งคำขอเป็นเพื่อนแล้ว';

  @override
  String get friendRequestFailed => 'ส่งไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get friendAlreadyFriend => 'เป็นผู้ติดต่อกันแล้ว';

  @override
  String get friendNewFriendsTitle => 'เพื่อนใหม่';

  @override
  String get friendNoRequests => 'ไม่มีคำขอเป็นเพื่อน';

  @override
  String get friendAccept => 'ยอมรับ';

  @override
  String get friendReject => 'ปฏิเสธ';

  @override
  String get friendAccepted => 'ยอมรับแล้ว';

  @override
  String get friendRejected => 'ถูกปฏิเสธ';

  @override
  String get friendDeleteConfirm => 'ลบผู้ติดต่อนี้หรือไม่?';

  @override
  String get friendDeleteSuccess => 'ลบผู้ติดต่อแล้ว';

  @override
  String get friendDeleteFailed => 'ลบไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get friendRemarkName => 'ชื่อเล่น';

  @override
  String get friendGroupName => 'กลุ่ม';

  @override
  String get friendSendMessage => 'ข้อความ';

  @override
  String get friendMatchTypeLppId => 'พบจาก StartLink ID';

  @override
  String get friendMatchTypeMobile => 'พบจากโทรศัพท์';

  @override
  String get friendMatchTypeEmail => 'พบจากอีเมล';

  @override
  String get friendSearchEmpty => 'ไม่พบผู้ใช้';

  @override
  String get friendAddMessage => 'ฉันต้องการเพิ่มคุณเป็นผู้ติดต่อ';

  @override
  String get friendBlockConfirm => 'บล็อกผู้ใช้นี้หรือไม่?';

  @override
  String get friendUnblockConfirm => 'เลิกบล็อกผู้ใช้นี้หรือไม่?';

  @override
  String get friendBlockSuccess => 'บล็อกแล้ว';

  @override
  String get friendUnblockSuccess => 'เลิกบล็อกแล้ว';

  @override
  String get profilePageTitle => 'ข้อมูลส่วนตัว';

  @override
  String get profilePageSendMessage => 'ข้อความ';

  @override
  String get profilePageAddFriend => 'เพิ่มเพื่อน';

  @override
  String get profilePageAlreadyFriend => 'เป็นเพื่อนกันแล้ว';

  @override
  String get profilePageBlocked => 'บล็อกแล้ว';

  @override
  String get profilePageBlock => 'บล็อก';

  @override
  String get profilePageUnblock => 'เลิกบล็อก';

  @override
  String get profilePageHidden => 'ผู้ใช้นี้ซ่อนโปรไฟล์';

  @override
  String get profilePageFriendsOnly => 'ผู้ใช้นี้แสดงโปรไฟล์ให้เพื่อนเท่านั้น';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'หมายเหตุ';

  @override
  String get profilePageEditRemark => 'แก้ไขชื่อเล่น';

  @override
  String get profilePageSaveRemarkSuccess => 'บันทึกชื่อเล่นแล้ว';

  @override
  String get profilePageSaveRemarkFailed => 'บันทึกไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get searchTitle => 'ค้นหา';

  @override
  String get searchHint => 'ค้นหาด้วยโทรศัพท์ อีเมล หรือ StartLink ID';

  @override
  String get searchNoResults => 'ไม่พบผลลัพธ์';

  @override
  String get searchMessages => 'ข้อความ';

  @override
  String get searchUsers => 'ผู้ใช้';

  @override
  String get searchFailed => 'ค้นหาไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get scanTitle => 'สแกน';

  @override
  String get scanFailed => 'รู้จำไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get scanInvalidQrCode => 'คิวอาร์โค้ดไม่ถูกต้อง';

  @override
  String get scanFlashOn => 'เปิดไฟฉาย';

  @override
  String get scanFlashOff => 'ปิดไฟฉาย';

  @override
  String get scanAlbum => 'เลือกจากอัลบั้ม';

  @override
  String get favoritesTitle => 'รายการโปรด';

  @override
  String get favoritesEmpty => 'ยังไม่ได้บันทึกอะไรไว้';

  @override
  String get favoritesAll => 'ทั้งหมด';

  @override
  String get favoritesText => 'ข้อความ';

  @override
  String get favoritesImage => 'รูปภาพ';

  @override
  String get favoritesVideo => 'วิดีโอ';

  @override
  String get favoritesVoice => 'เสียง';

  @override
  String get favoritesFile => 'ไฟล์';

  @override
  String get favoritesOther => 'อื่นๆ';

  @override
  String get favoritesDeleteConfirm => 'นำออกจากรายการโปรดหรือไม่?';

  @override
  String get favoritesDeleteSuccess => 'ลบออกจากบันทึกแล้ว';

  @override
  String get favoritesDeleteFailed => 'นำออกไม่สำเร็จ';

  @override
  String get favoritesOriginalRecalled => 'เรียกคืนข้อความแล้ว';

  @override
  String get favoritesViewOriginal => 'ดูต้นฉบับ';

  @override
  String get favoritesSearchHint => 'ค้นหารายการโปรด';

  @override
  String get favoritesNoResults => 'ไม่มีรายการโปรดที่ตรงกัน';

  @override
  String get noticeTitle => 'ประกาศ';

  @override
  String get noticeEmpty => 'ไม่มีประกาศ';

  @override
  String get noticeDetail => 'รายละเอียดประกาศ';

  @override
  String get noticePublishedAt => 'เผยแพร่แล้ว';

  @override
  String get noticePriorityNormal => 'ปกติ';

  @override
  String get noticePriorityImportant => 'สำคัญ';

  @override
  String get noticePriorityUrgent => 'ด่วน';

  @override
  String get organizationTitle => 'องค์กร';

  @override
  String get organizationEmpty => 'ไม่มีข้อมูลแผนก';

  @override
  String get organizationMembers => 'สมาชิก';

  @override
  String get organizationDepartment => 'แผนก';

  @override
  String get organizationPosition => 'ตำแหน่ง';

  @override
  String get organizationLeader => 'หัวหน้า';

  @override
  String get qrCodeTitle => 'คิวอาร์โค้ดของฉัน';

  @override
  String get qrCodeSave => 'บันทึกไปยังอัลบั้ม';

  @override
  String get qrCodeShare => 'แชร์';

  @override
  String get qrCodeSaveSuccess => 'บันทึกลงอัลบั้มเรียบร้อยแล้ว';

  @override
  String get qrCodeSaveFailed => 'บันทึกไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get qrCodeRefresh => 'รีเฟรชคิวอาร์โค้ด';

  @override
  String get qrCodeExpired => 'คิวอาร์โค้ดหมดอายุ โปรดรีเฟรช';

  @override
  String get qrCodeScanToAdd => 'สแกนเพื่อเพิ่มฉันเป็นผู้ติดต่อ';

  @override
  String get spacePersonal => 'ส่วนตัว';

  @override
  String get spaceEnterprise => 'องค์กร';

  @override
  String get spaceJoinByCode => 'เข้าร่วมด้วยรหัสองค์กร';

  @override
  String get spaceJoinByInvite => 'เข้าร่วมด้วยรหัสเชิญ';

  @override
  String get spaceEnterCode => 'ป้อนรหัสองค์กร';

  @override
  String get spaceEnterInviteCode => 'ป้อนรหัสเชิญ';

  @override
  String get spaceSearchEnterprise => 'ค้นหาองค์กร';

  @override
  String get spaceJoinRequestSent => 'ส่งคำขอแล้ว รออนุมัติ';

  @override
  String get spaceJoinRequestPending => 'รออนุมัติ';

  @override
  String get spaceJoinRequestApproved => 'อนุมัติคำขอแล้ว';

  @override
  String get spaceJoinRequestRejected => 'ปฏิเสธคำขอแล้ว';

  @override
  String get spaceAlreadyMember => 'คุณเป็นสมาชิกอยู่แล้ว';

  @override
  String get spaceAutoApproved => 'อนุมัติอัตโนมัติ ยินดีต้อนรับ!';

  @override
  String get spacePendingApprovalHint => 'ลงทะเบียนสำเร็จ ส่งคำขอเข้าร่วมแล้ว';

  @override
  String get spaceNoSpaces => 'ไม่มีพื้นที่';

  @override
  String get spaceInviteExpired => 'รหัสเชิญหมดอายุ';

  @override
  String get spaceInviteTargetMismatch => 'รหัสเชิญนี้ไม่ใช่สำหรับบัญชีของคุณ';

  @override
  String get spaceAcceptInviteSuccess => 'เข้าร่วมองค์กรสำเร็จ';

  @override
  String get spaceAcceptInviteFailed => 'เข้าร่วมไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get spaceTenantSelectTitle => 'เลือกพื้นที่';

  @override
  String get spaceTenantSelectHint => 'เลือกพื้นที่ที่จะเข้า';

  @override
  String get spaceEnterPersonal => 'เข้าสู่พื้นที่ส่วนตัว';

  @override
  String get spaceEnterEnterprise => 'เข้าสู่พื้นที่องค์กร';

  @override
  String get aboutTitle => 'เกี่ยวกับ StartLink';

  @override
  String get aboutVersion => 'เวอร์ชัน';

  @override
  String get aboutTerms => 'ข้อตกลงผู้ใช้';

  @override
  String get aboutPrivacy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get aboutOpenSource => 'ใบอนุญาตโอเพนซอร์ส';

  @override
  String get aboutCheckUpdate => 'ตรวจสอบอัปเดต';

  @override
  String get aboutLatestVersion => 'คุณกำลังใช้เวอร์ชันล่าสุด';

  @override
  String get aboutUpdateAvailable => 'มีเวอร์ชันใหม่พร้อมใช้งาน';

  @override
  String get aboutUpdateNow => 'อัปเดตเดี๋ยวนี้';

  @override
  String get aboutUpdateLater => 'ภายหลัง';

  @override
  String get notificationTitle => 'การแจ้งเตือน';

  @override
  String get notificationGlobalMute => 'ห้ามรบกวน';

  @override
  String get notificationSound => 'เสียง';

  @override
  String get notificationVibration => 'การสั่น';

  @override
  String get notificationPreview => 'ตัวอย่างข้อความ';

  @override
  String get notificationDndStart => 'เวลาเริ่มห้ามรบกวน';

  @override
  String get notificationDndEnd => 'เวลาสิ้นสุดห้ามรบกวน';

  @override
  String get blacklistTitle => 'อยู่ในบัญชีดำ';

  @override
  String get blacklistEmpty => 'ไม่มีผู้ใช้ที่ถูกบล็อก';

  @override
  String get blacklistRemove => 'เลิกบล็อก';

  @override
  String get blacklistRemoveConfirm => 'เลิกบล็อกผู้ใช้นี้หรือไม่?';

  @override
  String get feedbackTitle => 'ข้อเสนอแนะ';

  @override
  String get feedbackTypeComplaint => 'ข้อร้องเรียน';

  @override
  String get feedbackTypeSuggestion => 'คำแนะนำ';

  @override
  String get feedbackTypeBug => 'รายงานข้อผิดพลาด';

  @override
  String get feedbackContent => 'คำอธิบาย';

  @override
  String get feedbackContentHint => 'โปรดอธิบายปัญหาหรือข้อเสนอแนะโดยละเอียด';

  @override
  String get feedbackContact => 'ข้อมูลติดต่อ (ไม่บังคับ)';

  @override
  String get feedbackSubmit => 'ส่ง';

  @override
  String get feedbackSuccess => 'ส่งข้อเสนอแนะแล้ว ขอบคุณ!';

  @override
  String get feedbackFailed => 'ส่งไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get networkTitle => 'สลับสาย';

  @override
  String get networkAutoSelect => 'อัตโนมัติ';

  @override
  String get networkManual => 'กำหนดเอง';

  @override
  String get timezoneTitle => 'เขตเวลา';

  @override
  String get timezoneAuto => 'ตามระบบ';

  @override
  String get autoTranslateTitle => 'แปลอัตโนมัติ';

  @override
  String get autoTranslateEnabled => 'เปิดแปลอัตโนมัติ';

  @override
  String get autoTranslateLanguage => 'ภาษาเป้าหมาย';

  @override
  String get displayTitle => 'การแสดงผล';

  @override
  String get displayFontSize => 'ขนาดตัวอักษร';

  @override
  String get displayChatBackground => 'พื้นหลังแชท';

  @override
  String get displayDarkMode => 'รูปลักษณ์';

  @override
  String get displayDarkModeSystem => 'ตามระบบ';

  @override
  String get displayDarkModeSystemHint => 'สลับอัตโนมัติตามการตั้งค่าระบบ';

  @override
  String get displayDarkModeOff => 'สว่าง';

  @override
  String get displayDarkModeOffHint => 'ใช้ธีมสว่างเสมอ';

  @override
  String get displayDarkModeOn => 'มืด';

  @override
  String get displayDarkModeOnHint => 'ใช้ธีมมืดเสมอ';

  @override
  String get chatSettingsTitle => 'แชท';

  @override
  String get chatHistoryTitle => 'ประวัติแชท';

  @override
  String get chatHistoryClear => 'ล้างประวัติทั้งหมด';

  @override
  String get chatHistoryClearConfirm =>
      'ล้างประวัติแชททั้งหมดหรือไม่? การดำเนินการนี้ย้อนกลับไม่ได้';

  @override
  String get chatHistoryClearSuccess => 'ล้างประวัติแชทแล้ว';

  @override
  String get accountSecurityTitle => 'ความปลอดภัยของบัญชี';

  @override
  String get accountSecurityChangePassword => 'เปลี่ยนรหัสผ่าน';

  @override
  String get accountSecurityChangeMobile => 'เปลี่ยนหมายเลขโทรศัพท์';

  @override
  String get accountSecurityChangeEmail => 'เปลี่ยนอีเมล';

  @override
  String get accountSecurityLoggedDevices => 'อุปกรณ์ที่เข้าสู่ระบบ';

  @override
  String get accountSecurityDeactivate => 'ปิดบัญชี';

  @override
  String get accountSecurityDeactivateConfirm =>
      'ข้อมูลทั้งหมดจะถูกลบถาวรหลัง 7 วัน ต้องการปิดบัญชีหรือไม่?';

  @override
  String get loggedDevicesTitle => 'อุปกรณ์ที่เข้าสู่ระบบ';

  @override
  String get loggedDevicesCurrent => 'อุปกรณ์นี้';

  @override
  String get loggedDevicesRevoke => 'ออกจากระบบ';

  @override
  String get loggedDevicesRevokeConfirm => 'ออกจากระบบในอุปกรณ์นี้หรือไม่?';

  @override
  String get loggedDevicesRevokeSuccess => 'ออกจากระบบในอุปกรณ์แล้ว';

  @override
  String get loggedDevicesRevokeFailed => 'ไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get loggedDevicesLastActive => 'ใช้งานล่าสุด';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'เว็บ';

  @override
  String get loggedDevicesTypeDesktop => 'เดสก์ท็อป';

  @override
  String get loggedDevicesTypeUnknown => 'อุปกรณ์ไม่ทราบชื่อ';

  @override
  String get privacySettingsTitle => 'ความเป็นส่วนตัว';

  @override
  String get privacySearchableByMobile => 'อนุญาตให้ค้นหาด้วยหมายเลขโทรศัพท์';

  @override
  String get privacySearchableByLppId => 'อนุญาตให้ค้นหาด้วย StartLink ID';

  @override
  String get privacyAllowFriendRequest => 'อนุญาตคำขอเป็นเพื่อน';

  @override
  String get privacyProfileVisibility => 'การมองเห็นโปรไฟล์';

  @override
  String get privacyEveryone => 'ทุกคน';

  @override
  String get privacyFriendsOfFriends => 'เพื่อนของเพื่อน';

  @override
  String get privacyNobody => 'ไม่มีใคร';

  @override
  String get privacyFriendsOnly => 'เพื่อนเท่านั้น';

  @override
  String get privacySaveSuccess => 'บันทึกการตั้งค่าแล้ว';

  @override
  String get privacySaveFailed => 'บันทึกไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get fontSizeTitle => 'ขนาดตัวอักษร';

  @override
  String get fontSizeSmall => 'เล็ก';

  @override
  String get fontSizeNormal => 'ปกติ';

  @override
  String get fontSizeLarge => 'ใหญ่';

  @override
  String get fontSizeExtraLarge => 'ใหญ่พิเศษ';

  @override
  String get fontSizePreview => 'ตัวอย่าง';

  @override
  String get chatBackgroundTitle => 'พื้นหลังแชท';

  @override
  String get chatBackgroundDefault => 'ค่าเริ่มต้น';

  @override
  String get chatBackgroundCustom => 'กำหนดเอง';

  @override
  String get chatBackgroundReset => 'คืนค่าเริ่มต้น';

  @override
  String get termsTitle => 'ข้อตกลงผู้ใช้';

  @override
  String get privacyPolicyTitle => 'นโยบายความเป็นส่วนตัว';

  @override
  String get recentContactsTitle => 'ล่าสุด';

  @override
  String get recentContactsEmpty => 'ไม่มีผู้ติดต่อล่าสุด';

  @override
  String get inviteFriendsTitle => 'เชิญเพื่อน';

  @override
  String get inviteFriendsCopyLink => 'คัดลอกลิงก์เชิญ';

  @override
  String get inviteFriendsLinkCopied => 'คัดลอกลิงก์เชิญแล้ว';

  @override
  String get imageViewerTitle => 'รูปภาพ';

  @override
  String get imageViewerSave => 'บันทึกไปยังอัลบั้ม';

  @override
  String get imageViewerSaveSuccess => 'บันทึกลงอัลบั้มเรียบร้อยแล้ว';

  @override
  String get imageViewerSaveFailed => 'บันทึกไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get customerServiceTitle => 'ศูนย์บริการ';

  @override
  String get customerServiceQueue => 'อยู่ในคิว';

  @override
  String get customerServiceActive => 'กำลังให้บริการ';

  @override
  String get customerServiceClaim => 'ยอมรับ';

  @override
  String get customerServiceTakeover => 'รับช่วงต่อ';

  @override
  String get customerServiceClose => 'สิ้นสุดบริการ';

  @override
  String get customerServiceCloseConfirm => 'สิ้นสุดเซสชันบริการนี้หรือไม่?';

  @override
  String get customerServiceNoQueue => 'ไม่มีเซสชันในคิว';

  @override
  String get customerServiceNoActive => 'ไม่มีเซสชันที่กำลังให้บริการ';

  @override
  String get customerServiceVisitor => 'ผู้เยี่ยมชม';

  @override
  String get customerServiceCustomer => 'ลูกค้า';

  @override
  String get customerServiceAssignedTo => 'มอบหมายให้';

  @override
  String get customerServiceTransferConversation => 'โอนแชท';

  @override
  String get marketingToolbar => 'เครื่องมือการตลาด';

  @override
  String get callIncoming => 'สายเรียกเข้า';

  @override
  String get callOutgoing => 'สายโทรออก';

  @override
  String get callAccept => 'ยอมรับ';

  @override
  String get callReject => 'ปฏิเสธ';

  @override
  String get callHangup => 'สิ้นสุด';

  @override
  String get callMissed => 'สายที่ไม่ได้รับ';

  @override
  String get callDuration => 'ระยะเวลา';

  @override
  String get callAudio => 'โทรด้วยเสียง';

  @override
  String get callGeneric => 'โทร';

  @override
  String get callVideo => 'วิดีโอคอล';

  @override
  String get callConnecting => 'กำลังเชื่อมต่อ...';

  @override
  String get callRinging => 'กำลังเรียก...';

  @override
  String get callEnded => 'สิ้นสุดการโทร';

  @override
  String get callFailed => 'โทรไม่สำเร็จ';

  @override
  String get callRejected => 'ปฏิเสธสายแล้ว';

  @override
  String get callTimeout => 'ไม่มีผู้รับสาย';

  @override
  String get callCancelled => 'ยกเลิกแล้ว';

  @override
  String get callUnknownPeer => 'ไม่ทราบ';

  @override
  String get callVideoInvitation => 'คำเชิญวิดีโอคอล';

  @override
  String get callAudioInvitation => 'คำเชิญโทรด้วยเสียง';

  @override
  String get callAnswerAudio => 'รับสายด้วยเสียง';

  @override
  String get callAnswerVideo => 'รับสายด้วยวิดีโอ';

  @override
  String get callViewProfile => 'ดูโปรไฟล์';

  @override
  String get callOpeningCamera => 'กำลังเปิดกล้อง...';

  @override
  String get callWaitingRemoteVideo => 'กำลังรอวิดีโอของอีกฝ่าย...';

  @override
  String get callCameraOff => 'กล้องปิด';

  @override
  String get callCameraOn => 'กล้องเปิด';

  @override
  String get callMicrophoneOff => 'ไมโครโฟนปิด';

  @override
  String get callMicrophoneOn => 'ไมโครโฟนเปิด';

  @override
  String get callSpeakerOff => 'ลำโพงปิด';

  @override
  String get callSpeakerOn => 'ลำโพงเปิด';

  @override
  String get callVideoPermissionFailure =>
      'เริ่มวิดีโอคอลไม่ได้ ตรวจสอบสิทธิ์กล้องและไมโครโฟนแล้วลองอีกครั้ง';

  @override
  String get callAudioPermissionFailure =>
      'เริ่มโทรด้วยเสียงไม่ได้ ตรวจสอบสิทธิ์ไมโครโฟนแล้วลองอีกครั้ง';

  @override
  String get callIncompleteIncoming =>
      'ข้อมูลสายเรียกเข้าไม่ครบถ้วน จึงรับสายไม่ได้';

  @override
  String get callInProgress => 'อยู่ระหว่างการโทร';

  @override
  String get callCalling => 'กำลังโทร...';

  @override
  String callEndedMedia(String media) {
    return 'สิ้นสุด$media';
  }

  @override
  String callRejectedMedia(String media) {
    return 'ปฏิเสธ$media';
  }

  @override
  String callUnansweredMedia(String media) {
    return 'ไม่มีผู้รับ$media';
  }

  @override
  String callCancelledMedia(String media) {
    return 'ยกเลิก$media';
  }

  @override
  String get callConnectionLost => 'การเชื่อมต่อสายขาดหาย';

  @override
  String get callAdminEnded => 'ผู้ดูแลระบบสิ้นสุดการโทร';

  @override
  String callFailedMedia(String media) {
    return '$mediaไม่สำเร็จ';
  }

  @override
  String get callBusy => 'อีกฝ่ายไม่ว่าง';

  @override
  String callDurationValue(String duration) {
    return 'ระยะเวลาการโทร $duration';
  }

  @override
  String get callNotConnected => 'ยังไม่ได้เชื่อมต่อ';

  @override
  String get callDialed => 'โทรออก';

  @override
  String get callAnswered => 'รับสายแล้ว';

  @override
  String get callRejectedByPeer => 'อีกฝ่ายปฏิเสธ';

  @override
  String get callRejectedBySelf => 'ถูกปฏิเสธ';

  @override
  String get callPeerDidNotAnswer => 'อีกฝ่ายไม่รับสาย';

  @override
  String get callMissedIncoming => 'สายเรียกเข้าที่ไม่ได้รับ';

  @override
  String get callPeerCancelled => 'อีกฝ่ายยกเลิก';

  @override
  String get notificationNewMessageTitle => 'ข้อความใหม่จาก StartLink';

  @override
  String get notificationOnlineServiceTitle => 'ข้อความใหม่จากฝ่ายบริการลูกค้า';

  @override
  String get notificationNewMessageBody => 'คุณได้รับข้อความใหม่';

  @override
  String get notificationImagePreview => 'ส่งรูปภาพ';

  @override
  String get notificationVideoPreview => 'ส่งวิดีโอ';

  @override
  String get notificationVoicePreview => 'ส่งข้อความเสียง';

  @override
  String get notificationFilePreview => 'ส่งไฟล์';

  @override
  String get notificationContactPreview => 'ส่งบัตรผู้ติดต่อ';

  @override
  String get notificationCallLogPreview => 'ส่งบันทึกการโทร';

  @override
  String get notificationLocationPreview => 'แชร์ตำแหน่ง';

  @override
  String get notificationLinkPreview => 'แชร์ลิงก์';

  @override
  String notificationMentionMe(String body) {
    return 'กล่าวถึงคุณ: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender กล่าวถึงคุณ: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'กล่าวถึงทุกคน: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender กล่าวถึงทุกคน: $body';
  }

  @override
  String get notificationSecurityTitle => 'แจ้งเตือนความปลอดภัยของบัญชี';

  @override
  String get notificationSecurityBody =>
      'การตั้งค่าความปลอดภัยบัญชี StartLink ของคุณเปลี่ยนแปลง โปรดตรวจสอบทันที';

  @override
  String get notificationFriendAcceptedTitle => 'ยอมรับคำขอเป็นเพื่อนแล้ว';

  @override
  String get notificationFriendRejectedTitle => 'ปฏิเสธคำขอเป็นเพื่อนแล้ว';

  @override
  String get notificationFriendAcceptedBody =>
      'อีกฝ่ายยอมรับคำขอเป็นเพื่อนของคุณ';

  @override
  String get notificationFriendRejectedBody =>
      'อีกฝ่ายปฏิเสธคำขอเป็นเพื่อนของคุณ';

  @override
  String get notificationVideoCallTitle => 'คำเชิญวิดีโอคอล';

  @override
  String get notificationAudioCallTitle => 'คำเชิญโทรด้วยเสียง';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller เชิญคุณเข้าร่วมวิดีโอคอล';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller เชิญคุณเข้าร่วมการโทรด้วยเสียง';
  }

  @override
  String get notificationMessageChannelName => 'ข้อความ';

  @override
  String get notificationMessageChannelDescription =>
      'ข้อความแชท บันทึกการโทร และการแจ้งเตือนระบบ';

  @override
  String get notificationCallChannelName => 'การโทร';

  @override
  String get notificationCallChannelDescription =>
      'การแจ้งเตือนสายโทรด้วยเสียงและวิดีโอ';

  @override
  String get notificationSecurityChannelName => 'ความปลอดภัยของบัญชี';

  @override
  String get notificationSecurityChannelDescription =>
      'แจ้งเตือนการเข้าสู่ระบบ การเปลี่ยนรหัสผ่านและหมายเลขมือถือ';

  @override
  String get notificationUnknownCaller => 'ผู้โทรไม่ทราบชื่อ';

  @override
  String get pendingJoinRequestsTitle => 'คำขอใหม่';

  @override
  String get pendingJoinRequestsEmpty => 'ไม่มีคำขอ';

  @override
  String get pendingJoinRequestApprove => 'ตกลง';

  @override
  String get pendingJoinRequestReject => 'ปฏิเสธ';

  @override
  String get pendingJoinRequestApproveSuccess => 'อนุมัติแล้ว';

  @override
  String get pendingJoinRequestRejectSuccess => 'ปฏิเสธแล้ว';

  @override
  String get pendingJoinRequestFailed => 'ดำเนินการไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get myCustomersTitle => 'ลูกค้าของฉัน';

  @override
  String get myCustomersEmpty => 'ไม่มีลูกค้า';

  @override
  String get groupListTitle => 'กลุ่ม';

  @override
  String get groupListEmpty => 'ไม่มีกลุ่ม';

  @override
  String get addFriendTitle => 'เพิ่มผู้ติดต่อ';

  @override
  String get addFriendSearchHint => 'โทรศัพท์ / อีเมล / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'เพิ่ม';

  @override
  String get addFriendCannotAddSelf => 'เพิ่มตัวเองไม่ได้';

  @override
  String get addFriendUnsupportedUser =>
      'เพิ่มผู้ใช้นี้ไม่ได้ คุณสามารถส่งข้อความถึงเขาโดยตรงได้';

  @override
  String get addFriendMessageHint => 'ป้อนข้อความ';

  @override
  String get addFriendSendRequest => 'ส่งคำขอ';

  @override
  String get joinCompanyTitle => 'เข้าร่วมองค์กร';

  @override
  String get joinCompanyCodeHint => 'ป้อนรหัสองค์กร';

  @override
  String get joinCompanySearchHint => 'ค้นหาชื่อองค์กร';

  @override
  String get joinCompanyApply => 'สมัครเข้าร่วม';

  @override
  String get joinCompanyApplySuccess => 'ส่งคำขอแล้ว';

  @override
  String get joinCompanyApplyFailed => 'สมัครไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get joinCompanyAutoApproved => 'อนุมัติอัตโนมัติ ยินดีต้อนรับ!';

  @override
  String get joinCompanyPending => 'ส่งคำขอแล้ว รออนุมัติ';

  @override
  String get joinCompanyInviteCodeHint => 'ป้อนรหัสเชิญ';

  @override
  String get joinCompanyAcceptInvite => 'ยอมรับคำเชิญ';

  @override
  String get joinCompanyNoResults => 'ไม่พบองค์กร';

  @override
  String joinCompanyMemberCount(int count) {
    return 'สมาชิก $count คน';
  }

  @override
  String get timezoneNameHawaii => 'ฮาวาย';

  @override
  String get timezoneNameAlaska => 'อะแลสกา';

  @override
  String get timezoneNamePacificTime => 'เวลาแปซิฟิก';

  @override
  String get timezoneNameMountainTime => 'เวลาเขตภูเขา';

  @override
  String get timezoneNameCentralTime => 'เวลาภาคกลาง';

  @override
  String get timezoneNameEasternTime => 'เวลาฝั่งตะวันออก';

  @override
  String get timezoneNameAtlanticTime => 'เวลาแอตแลนติก';

  @override
  String get timezoneNameBrasilia => 'บราซิเลีย';

  @override
  String get timezoneNameAzores => 'อะซอเรส';

  @override
  String get timezoneNameLondonDublin => 'ลอนดอน/ดับลิน';

  @override
  String get timezoneNameBerlinParisRome => 'เบอร์ลิน/ปารีส/โรม';

  @override
  String get timezoneNameCairoHelsinki => 'ไคโร/เฮลซิงกิ';

  @override
  String get timezoneNameMoscowRiyadh => 'มอสโก/ริยาด';

  @override
  String get timezoneNameTehran => 'เตหะราน';

  @override
  String get timezoneNameDubaiBaku => 'ดูไบ/บากู';

  @override
  String get timezoneNameKabul => 'คาบูล';

  @override
  String get timezoneNameKarachiTashkent => 'การาจี/ทาชเคนต์';

  @override
  String get timezoneNameMumbaiNewDelhi => 'มุมไบ/นิวเดลี';

  @override
  String get timezoneNameKathmandu => 'กาฐมาณฑุ';

  @override
  String get timezoneNameDhakaAlmaty => 'ธากา/อัลมาตี';

  @override
  String get timezoneNameYangon => 'ย่างกุ้ง';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'กรุงเทพฯ/ฮานอย/จาการ์ตา';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'ปักกิ่ง/เซี่ยงไฮ้/ฮ่องกง/ไทเป';

  @override
  String get timezoneNameTokyoSeoul => 'โตเกียว/โซล';

  @override
  String get timezoneNameAdelaide => 'แอดิเลด';

  @override
  String get timezoneNameSydneyMelbourne => 'ซิดนีย์/เมลเบิร์น';

  @override
  String get timezoneNameSolomonIslands => 'หมู่เกาะโซโลมอน';

  @override
  String get timezoneNameAucklandFiji => 'โอ๊คแลนด์/ฟิจิ';

  @override
  String get networkSmartSelectBestRoute =>
      'เลือกเส้นทางที่ดีที่สุดอย่างชาญฉลาด';

  @override
  String get networkTesting => 'กำลังทดสอบ...';

  @override
  String get networkTestingShort => 'กำลังทดสอบ';

  @override
  String networkLatencyMs(int ms) {
    return 'ความหน่วง $ms มิลลิวินาที';
  }

  @override
  String get networkConnectionMode => 'โหมดการเชื่อมต่อ';

  @override
  String get networkDirectMode => 'โหมดตรง';

  @override
  String get networkProxyMode => 'โหมดพร็อกซี';

  @override
  String get networkDirectModeDesc => 'เชื่อมต่อเซิร์ฟเวอร์โดยตรง';

  @override
  String get networkProxyModeDesc => 'เชื่อมต่อผ่านเซิร์ฟเวอร์พร็อกซี';

  @override
  String get networkDirectRoutes => 'เส้นทางตรง';

  @override
  String get networkProxyRoutes => 'เส้นทางพร็อกซี';

  @override
  String get networkTestAll => 'ทดสอบทั้งหมด';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'โหนดฮ่องกง';

  @override
  String get networkSingaporeNode => 'โหนดสิงคโปร์';

  @override
  String get networkJapanNode => 'โหนดญี่ปุ่น';

  @override
  String get networkUnitedStatesNode => 'โหนดสหรัฐอเมริกา';

  @override
  String get networkHint =>
      'คำแนะนำ:\n• โหมดตรง: เร็วกว่า เหมาะกับการใช้งานภายในประเทศ\n• โหมดพร็อกซี: เสถียรกว่าสำหรับการสื่อสารข้ามประเทศ\n• แตะไอคอนรีเฟรชเพื่อทดสอบความหน่วงของเส้นทางเดียว';

  @override
  String get teenModeTitle => 'โหมดเยาวชน';

  @override
  String get teenModeStatusOn => 'เปิด';

  @override
  String get teenModeStatusOff => 'ปิด';

  @override
  String get teenModeStatusLoading => 'กำลังโหลด';

  @override
  String get teenModeUnavailable => 'สถานะโหมดเยาวชนไม่พร้อมใช้งานชั่วคราว';

  @override
  String get teenModeInvalidResponse => 'โหมดเยาวชนส่งคืนคำตอบที่ไม่ถูกต้อง';

  @override
  String get teenModeEnableDescription =>
      'กฎของแพลตฟอร์มจะจำกัดเวลาใช้งานและบางฟีเจอร์';

  @override
  String get teenModePasscode => 'รหัสผ่านโหมด';

  @override
  String get teenModeCurrentPasscode => 'รหัสผ่านโหมดปัจจุบัน';

  @override
  String get teenModeNewPasscode => 'รหัสผ่านโหมดใหม่';

  @override
  String get teenModePasscodeHint => 'ป้อนตัวเลข 4–6 หลัก';

  @override
  String get teenModeEnable => 'เปิดโหมดเยาวชน';

  @override
  String get teenModeDisable => 'ปิดโหมดเยาวชน';

  @override
  String get teenModeChangePasscode => 'เปลี่ยนรหัสผ่านโหมด';

  @override
  String get teenModeSource => 'เปิดโดย';

  @override
  String get teenModeDailyUsage => 'ใช้ไปวันนี้';

  @override
  String get teenModeRemaining => 'เวลาที่เหลือ';

  @override
  String get teenModeMinutesUnit => 'นาที';

  @override
  String get teenModeUnlimited => 'ไม่จำกัด';

  @override
  String get teenModeRequestExtension => 'ขอเวลาเพิ่ม';

  @override
  String get teenModeExtensionSubmitted => 'ส่งคำขอเวลาไปยังผู้ปกครองแล้ว';

  @override
  String get teenModeTimeLimitReached => 'ใช้เวลาถึงขีดจำกัดของวันนี้แล้ว';

  @override
  String get teenModeCurfewActive => 'ขณะนี้เป็นช่วงเวลาจำกัดการใช้งาน';

  @override
  String get teenModeReliefHint =>
      'คุณยังดูประวัติ ติดต่อฝ่ายสนับสนุนทางการ และรายงานปัญหาได้';

  @override
  String get teenModeRestrictedNotice =>
      'โหมดเยาวชนป้องกันการส่งข้อความในขณะนี้';

  @override
  String get teenModeActionBlocked =>
      'โหมดเยาวชนป้องกันการดำเนินการนี้ในขณะนี้';

  @override
  String get teenModeMyRequests => 'คำขอของฉัน';

  @override
  String get guardianCenterTitle => 'ศูนย์ผู้ปกครอง';

  @override
  String get guardianRelationships => 'ความสัมพันธ์ผู้ปกครอง';

  @override
  String get guardianMinors => 'เด็กที่ฉันดูแล';

  @override
  String get guardianApprovals => 'รอการอนุมัติ';

  @override
  String get guardianBind => 'ป้อนรหัสเชื่อมโยง';

  @override
  String get guardianCreateMinorCode => 'ฉันเป็นเด็ก — สร้างรหัส';

  @override
  String get guardianCreateGuardianCode => 'ฉันเป็นผู้ปกครอง — สร้างรหัส';

  @override
  String get guardianRelation => 'ความสัมพันธ์';

  @override
  String get guardianPrimary => 'ผู้ปกครองหลัก';

  @override
  String get guardianCode => 'รหัสเชื่อมโยง 6 หลัก';

  @override
  String get guardianCodeHint => 'ป้อนรหัสที่อีกฝ่ายให้มา';

  @override
  String get guardianCodeCreated => 'สร้างรหัสแล้ว แชร์ก่อนหมดอายุ';

  @override
  String get guardianEmpty => 'ไม่มีความสัมพันธ์ผู้ปกครอง';

  @override
  String get guardianNoMinors => 'ไม่มีเด็กในความดูแล';

  @override
  String get guardianUnbind => 'ยกเลิกความสัมพันธ์';

  @override
  String get guardianExtend => 'เพิ่มเวลาให้เด็ก';

  @override
  String get guardianPolicyTitle => 'กฎการใช้งาน';

  @override
  String get guardianPolicyLocked => 'ล็อกโดยแพลตฟอร์ม';

  @override
  String get approvalEmpty => 'ไม่มีคำขอ';

  @override
  String get approvalApprove => 'ตกลง';

  @override
  String get approvalReject => 'ปฏิเสธ';

  @override
  String get approvalPending => 'รอดำเนินการ';

  @override
  String get approvalApproved => 'อนุมัติแล้ว';

  @override
  String get approvalRejected => 'ถูกปฏิเสธ';

  @override
  String get approvalExpired => 'หมดอายุ';

  @override
  String get approvalCancelled => 'ยกเลิก';

  @override
  String get approvalReplayFailed => 'การดำเนินการเดิมไม่สำเร็จ โปรดลองใหม่';

  @override
  String get requestCancelled => 'ยกเลิกคำขอแล้ว';

  @override
  String get kycTitle => 'การยืนยันตัวตน';

  @override
  String get kycNotRequired => 'ไม่จำเป็นต้องยืนยันตัวตน';

  @override
  String get kycVerified => 'ยืนยันตัวตนแล้ว';

  @override
  String get kycDeclared => 'ส่งข้อมูลยืนยันตัวตนแล้ว';

  @override
  String get kycPending => 'อยู่ระหว่างตรวจสอบ';

  @override
  String get kycRejected => 'ไม่ผ่านการตรวจสอบ';

  @override
  String get kycNone => 'ยังไม่ได้ส่งข้อมูลยืนยันตัวตน';

  @override
  String get kycRealName => 'ชื่อเต็ม';

  @override
  String get kycIdNumber => 'หมายเลขบัตรประจำตัว';

  @override
  String get kycIdType => 'ประเภทเอกสาร';

  @override
  String get kycApplicability =>
      'ป้อนข้อมูลจริงตามเอกสารที่เลือก ประเภทที่รองรับจะแสดงในรายการ';

  @override
  String get kycCamera => 'ถ่ายรูป';

  @override
  String get kycGallery => 'เลือกจากอัลบั้ม';

  @override
  String get kycPhotoLimit => 'สูงสุดต่อรูป';

  @override
  String get kycSelectPhoto => 'เลือกรูปภาพ';

  @override
  String get kycPhotoSelected => 'เลือกแล้ว';

  @override
  String get kycViewPhoto => 'แตะเพื่อดูรูป';

  @override
  String get kycReplacePhoto => 'เลือกรูปอื่น';

  @override
  String get kycDisclosure =>
      'เราใช้ชื่อ หมายเลขเอกสาร และรูปเอกสารเพื่อตรวจสอบตัวตน หากไม่มีข้อมูลเหล่านี้ คุณจะส่งคำขอไม่ได้ และบางฟีเจอร์ที่มีข้อจำกัดอาจใช้งานไม่ได้';

  @override
  String get kycConsent => 'ฉันยินยอมแยกต่างหากให้ประมวลผลข้อมูลยืนยันตัวตนนี้';

  @override
  String get kycConsentRequired => 'โปรดให้ความยินยอมแยกต่างหากก่อนส่ง';

  @override
  String get kycResubmitTitle => 'ส่งข้อมูลยืนยันตัวตนอีกครั้ง';

  @override
  String get kycResubmitWarning =>
      'การส่งใหม่จะแทนที่คำขอที่รอตรวจสอบ ต้องการดำเนินการต่อหรือไม่?';

  @override
  String get kycSubmitting => 'กำลังส่ง';

  @override
  String get kycSubmitFailed => 'ส่งไม่สำเร็จ ลองอีกครั้ง';

  @override
  String get kycSubmitUnavailable => 'ยังส่งข้อมูลยืนยันตัวตนไม่ได้ในขณะนี้';

  @override
  String get kycResubmitNotAllowed =>
      'ไม่สามารถส่งใหม่หลังถูกปฏิเสธ ติดต่อฝ่ายสนับสนุนหากจำเป็น';

  @override
  String get kycDailyLimit =>
      'คุณส่งถึงขีดจำกัดของวันนี้แล้ว ลองอีกครั้งพรุ่งนี้';

  @override
  String get kycTypeUnavailable =>
      'ไม่มีประเภทเอกสารที่พร้อมใช้งาน โปรดลองภายหลัง';

  @override
  String get kycNameInvalid => 'ชื่อตามกฎหมายต้องมี 2–64 อักขระ';

  @override
  String get kycNumberRequired => 'ป้อนหมายเลขเอกสาร';

  @override
  String get kycFrontRequired => 'อัปโหลดด้านหน้าเอกสาร';

  @override
  String get kycBackRequired => 'อัปโหลดด้านหลังเอกสาร';

  @override
  String get kycPhotoTooLarge =>
      'รูปเกินขนาดที่กำหนด โปรดบีบอัดแล้วลองอีกครั้ง';

  @override
  String get kycAccountChanged =>
      'บัญชีหรือพื้นที่เปลี่ยนไป โปรดเปิดหน้านี้ใหม่';

  @override
  String get kycPhotoInvalid => 'เลือกรูปที่ถูกต้อง';

  @override
  String get kycPortraitSide => 'ด้านรูปบุคคล';

  @override
  String get kycEmblemSide => 'ด้านตราสัญลักษณ์';

  @override
  String get kycPassportDataPage => 'หน้าข้อมูลหนังสือเดินทาง';

  @override
  String get kycPassportOtherPage => 'หน้าวีซ่าหรือหน้าว่างของหนังสือเดินทาง';

  @override
  String get kycFront => 'ด้านหน้าบัตรประจำตัว';

  @override
  String get kycBack => 'ด้านหลังบัตรประจำตัว';

  @override
  String get kycRequired => 'ต้องยืนยันตัวตนก่อนสร้างกลุ่ม';

  @override
  String get kycGoVerify => 'ยืนยันตอนนี้';

  @override
  String get kycStatusUnknown => 'สถานะตัวตนไม่พร้อมใช้งาน โปรดรีเฟรชภายหลัง';

  @override
  String get kycSuperseded =>
      'มีการส่งใหม่มาแทนที่รายการนี้ โปรดตรวจสอบสถานะตัวตนล่าสุด';

  @override
  String get kycMediaNotFound =>
      'รูปเอกสารไม่พร้อมใช้งานในพื้นที่นี้ โปรดเลือกใหม่ก่อนส่ง';

  @override
  String get customerServiceBroadcastDirectTitle => 'ส่งข้อความกลุ่มถึงลูกค้า';

  @override
  String get officialAccountBadge => 'ทางการ';

  @override
  String get officialAccountOpenConversation => 'เปิดการสนทนา';

  @override
  String get officialAccountJoinHint =>
      'การเพิ่มบัญชีนี้จะทำให้คุณเข้าร่วมองค์กรในฐานะลูกค้า ไม่ต้องรออนุมัติเพื่อน';

  @override
  String get officialAccountJoinDisabled =>
      'องค์กรนี้ไม่รับลูกค้าใหม่ โปรดติดต่อฝ่ายสนับสนุน';

  @override
  String get officialAccountRemoved =>
      'คุณถูกนำออกจากองค์กรนี้ ขอให้องค์กรเชิญคุณอีกครั้ง';

  @override
  String get officialAccountBanned => 'บัญชีของคุณถูกปิดใช้งานในองค์กรนี้';

  @override
  String get officialAccountUnavailable =>
      'บัญชีทางการนี้ไม่พร้อมใช้งานในขณะนี้';

  @override
  String get officialAccountJoinBindingDisabled =>
      'โหมดปัจจุบันไม่อนุญาตให้เข้าร่วมองค์กร';

  @override
  String get officialAccountPlatformRequired =>
      'ใช้บัญชีแพลตฟอร์มเพื่อเพิ่มบัญชีทางการนี้';

  @override
  String get officialAccountOpenFailed => 'เปิดการสนทนาไม่ได้ โปรดลองอีกครั้ง';

  @override
  String get officialAccountAccountChanged =>
      'บัญชีหรือพื้นที่เปลี่ยนไป โปรดเปิดใหม่';

  @override
  String get officialAccountDirectoryUnavailable =>
      'รายชื่อองค์กรยังไม่เป็นปัจจุบัน โปรดลองอีกสักครู่';

  @override
  String get officialAccountInboxSyncFailed =>
      'ซิงค์บัญชีทางการไม่สำเร็จ เนื้อหาในเครื่องยังพร้อมใช้งาน';

  @override
  String get officialAccountInboxSyncing => 'กำลังซิงค์ข้อความบัญชีทางการ';

  @override
  String get diagnosticsTitle => 'การวินิจฉัย';

  @override
  String get diagnosticsExplanation =>
      'บันทึกถูกปกปิดข้อมูลอ่อนไหว และมีข้อมูลการดำเนินการกับข้อผิดพลาดของบัญชีและพื้นที่นี้ รวมถึงเหตุการณ์เริ่มต้นทั่วไป ไม่รวมเนื้อหาแชทและข้อมูลรับรอง';

  @override
  String get diagnosticsHour => 'ชั่วโมงที่ผ่านมา';

  @override
  String get diagnosticsDay => '24 ชั่วโมงที่ผ่านมา';

  @override
  String get diagnosticsWeek => '7D';

  @override
  String diagnosticsEventCount(int count) {
    return 'เหตุการณ์ที่มี: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'บันทึกถูกเก็บไว้ในอุปกรณ์นี้และยังใช้ได้หลังเริ่มใหม่';

  @override
  String get diagnosticsNotPersistent =>
      'บันทึกบางส่วนยังไม่ถูกเก็บ โปรดรีเฟรชเพื่อลองอีกครั้ง';

  @override
  String get diagnosticsExport => 'ส่งออกและแชร์';

  @override
  String get diagnosticsRefresh => 'รีเฟรช';

  @override
  String get diagnosticsClear => 'ล้างบันทึกของพื้นที่นี้';

  @override
  String get diagnosticsClearConfirm =>
      'ล้างบันทึกวินิจฉัยของพื้นที่นี้หรือไม่? ประวัติแชทจะยังอยู่';

  @override
  String get diagnosticsShared =>
      'แชร์ผ่านระบบเสร็จแล้ว โปรดตรวจสอบไฟล์ในแอปผู้รับ';

  @override
  String get diagnosticsCancelled => 'ยกเลิกการแชร์แล้ว คุณส่งออกใหม่ได้';

  @override
  String get diagnosticsUnconfirmed =>
      'ยืนยันการแชร์ไม่ได้ โปรดตรวจสอบแอปผู้รับ';

  @override
  String get diagnosticsFailed => 'ดำเนินการไม่สำเร็จ โปรดลองอีกครั้ง';
}
