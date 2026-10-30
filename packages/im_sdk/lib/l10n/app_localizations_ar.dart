// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navWorkbench => 'لوحة العمل';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'تعذّر تحميل بيانات الحساب';

  @override
  String get startupFailureTitle => 'تعذّر بدء التشغيل';

  @override
  String get startupFailureMessage => 'تحقق من الشبكة وحاول مجددًا';

  @override
  String get privacyConsentTitle => 'شروط الخدمة وسياسة الخصوصية';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'مرحبًا بك في $brand. لتوفير تسجيل الدخول والمراسلة الفورية والتعاون المؤسسي وخدمة العملاء عبر الإنترنت وإشعارات الرسائل والحماية الأمنية، نحتاج إلى معالجة المعلومات اللازمة وفقًا لشروط الخدمة وسياسة الخصوصية.\n\nقبل النقر على «أوافق»، لن نقرأ الحافظة أو نهيئ JPush/JCore أو حزم SDK لإشعارات الدفع الخاصة بمصنّعي الأجهزة، ولن نستخدم هذه الحزم للوصول إلى Android ID أو OAID أو قائمة التطبيقات المثبتة أو عناوين MAC أو معلومات مشابهة. إذا لم توافق حاليًا، فسنحفظ اختيارك؛ ويمكنك متابعة قراءة المستندات واتخاذ قرار آخر لاحقًا.\n\nبعد الموافقة، ولإيصال إشعارات الرسائل وخدمة العملاء والمكالمات الواردة، قد تعالج JPush/JCore وخدمات الدفع الخاصة بمصنّعي الأجهزة طراز الجهاز وإصدار Android واسم حزمة التطبيق وإصدارها ونوع الشبكة وعنوان IP وAndroid ID وOAID وRegistration ID ورمز الدفع الخاص بالمصنّع وبيانات تسليم الإشعارات والنقر عليها. لقد عطّلنا الإمكانات غير الضرورية، بما فيها الدفع الذكي وقوائم التطبيقات المثبتة وMAC وIMEI وIMSI وقوائم Wi-Fi والتنشيط التلقائي والتشغيل المرتبط.\n\nلا نصل إلى الحافظة إلا عندما تستخدم النسخ أو اللصق. ولا نطلب أذونات الكاميرا والميكروفون والإشعارات وغيرها من أذونات النظام إلا عند استخدام الميزة ذات الصلة. رفض إذن واحد يؤثر في الميزة المرتبطة به فقط. يُرجى قراءة المستندات الكاملة أدناه ثم اختيار الموافقة أو الرفض.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'مرحبًا بك في $brand. لتوفير تسجيل الدخول والمراسلة الفورية والتعاون المؤسسي وخدمة العملاء عبر الإنترنت وإشعارات الرسائل والحماية الأمنية، نحتاج إلى معالجة المعلومات اللازمة وفقًا لشروط الخدمة وسياسة الخصوصية.\n\nقبل النقر على «أوافق»، لن نقرأ الحافظة أو نهيئ JPush/JCore أو نسجّل في خدمة إشعارات Apple ‏(APNs)، ولن نحصل على معرّفات الدفع مثل JPush Registration ID أو رمز جهاز APNs. إذا لم توافق حاليًا، فسنحفظ اختيارك؛ ويمكنك متابعة قراءة المستندات واتخاذ قرار آخر لاحقًا.\n\nبعد الموافقة، ولإيصال إشعارات الرسائل وخدمة العملاء والمكالمات الواردة، قد نعالج طراز iPhone وإصدار iOS واسم حزمة التطبيق وإصدارها ونوع الشبكة وعنوان IP وIDFV وJPush Registration ID ورمز جهاز APNs وبيانات تسليم الإشعارات والنقر عليها. تتصل JPush/JCore بخدمة الدفع؛ وتعالج Apple APNs معرّف التطبيق ورمز الجهاز ومحتوى الإشعار لإيصال إشعارات النظام. لا يستخدم تطبيق iOS الحالي خدمات إعلانية ولا يحصل على IDFA.\n\nلا نصل إلى الحافظة إلا عندما تستخدم النسخ أو اللصق. ولا نطلب أذونات الكاميرا والميكروفون والإشعارات وغيرها من أذونات النظام إلا عند استخدام الميزة ذات الصلة. رفض إذن واحد يؤثر في الميزة المرتبطة به فقط. يُرجى قراءة المستندات الكاملة أدناه ثم اختيار الموافقة أو الرفض.';
  }

  @override
  String get privacyConsentTermsLink => 'اتفاقية المستخدم';

  @override
  String get privacyConsentConjunction => 'و';

  @override
  String get privacyConsentPrivacyLink => 'سياسة الخصوصية';

  @override
  String get privacyConsentDecline => 'غير موافق';

  @override
  String get privacyConsentDeclinedExit =>
      'لم توافق على شروط الخدمة وسياسة الخصوصية. سيُغلق التطبيق الآن.';

  @override
  String get privacyConsentAccept => 'موافق';

  @override
  String get privacyConsentRuntimeFailure =>
      'تعذّر بدء التشغيل. تحقق من الشبكة وحاول مجددًا.';

  @override
  String get privacyConsentSaveFailure => 'تعذّر حفظ اختيارك. حاول مجددًا.';

  @override
  String get appUpdateRequiredTitle => 'التحديث مطلوب للمتابعة';

  @override
  String get appUpdateOptionalTitle => 'الإصدار الجديد متوفر';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'يتوفر $brand $version';
  }

  @override
  String get appUpdateLater => 'لاحقًا';

  @override
  String get appUpdateNow => 'التحديث الآن';

  @override
  String get appUpdateProcessing => 'جارٍ المعالجة...';

  @override
  String get appUpdateInvalidUrl => 'عنوان التحديث غير صالح. حاول لاحقًا.';

  @override
  String get appUpdateOpenUrlFailed => 'تعذّر فتح رابط التحديث. حاول لاحقًا.';

  @override
  String get appUpdateDownloadInterrupted =>
      'انقطع التنزيل. تحقق من الشبكة وحاول مجددًا.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'فشل التحقق من الحزمة. نزّلها مجددًا.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'اسمح لتطبيق $brand بتثبيت التحديثات في إعدادات النظام.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'تعذّر فتح مثبّت النظام. تحقق من أذونات التثبيت.';

  @override
  String get appUpdateGenericFailure =>
      'فشل التحديث. تحقق من الشبكة وحاول مجددًا.';

  @override
  String get appUpdateUnavailable =>
      'الإصدار الجديد غير متاح للتنزيل بعد. حاول لاحقًا.';

  @override
  String get appUpdateCheckFailed => 'تعذّر البحث عن تحديثات. حاول لاحقًا.';

  @override
  String get appUpdateChecking => 'جارٍ التحقق';

  @override
  String get commonConfirm => 'حسنًا';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonSearch => 'بحث';

  @override
  String get commonLoading => 'جارٍ التحميل...';

  @override
  String get commonLoadFailed => 'فشل التحميل';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonEmpty => 'لا توجد بيانات';

  @override
  String get commonCopy => 'نسخ';

  @override
  String get commonForward => 'إعادة توجيه';

  @override
  String get commonFavorite => 'حفظ';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonSend => 'إرسال';

  @override
  String get commonDone => 'تم';

  @override
  String get commonMore => 'المزيد';

  @override
  String get commonSettings => 'الإعدادات';

  @override
  String get commonCopied => 'تم النسخ';

  @override
  String get commonUnknown => 'غير معروف';

  @override
  String get commonNotSet => 'غير محدد';

  @override
  String get commonUnbound => 'غير مرتبط';

  @override
  String get commonViewAll => 'عرض الكل';

  @override
  String get commonSubmit => 'إرسال';

  @override
  String get commonAdd => 'إضافة';

  @override
  String get commonRemove => 'إزالة';

  @override
  String get commonCreate => 'إنشاء';

  @override
  String get commonUpdate => 'تحديث';

  @override
  String get commonUpload => 'رفع';

  @override
  String get commonShare => 'مشاركة';

  @override
  String get commonBlock => 'حظر';

  @override
  String get commonUnblock => 'إلغاء الحظر';

  @override
  String get commonMute => 'كتم';

  @override
  String get commonUnmute => 'إلغاء الكتم';

  @override
  String get commonPin => 'مثبت';

  @override
  String get commonUnpin => 'إلغاء التثبيت';

  @override
  String get commonMarkRead => 'وضع علامة مقروء';

  @override
  String get commonMarkUnread => 'وضع علامة غير مقروء';

  @override
  String get commonOnline => 'متصل';

  @override
  String get commonOffline => 'غير متصل';

  @override
  String get commonOperationFailed => 'فشلت العملية، حاول مجددًا';

  @override
  String get commonNetworkError => 'خطأ في الشبكة، تحقق من اتصالك';

  @override
  String get navMessages => 'الرسائل';

  @override
  String get navContacts => 'جهات الاتصال';

  @override
  String get navMe => 'أنا';

  @override
  String get authLoginTitle => 'تسجيل الدخول إلى StartLink';

  @override
  String get authTabMobile => 'الهاتف';

  @override
  String get authTabEmail => 'البريد الإلكتروني';

  @override
  String get authTabLoginName => 'معرّف StartLink';

  @override
  String get authHintMobile => 'أدخل رقم الهاتف';

  @override
  String get authHintEmail => 'أدخل عنوان بريدك الإلكتروني';

  @override
  String get authHintPassword => 'أدخل كلمة المرور';

  @override
  String get authHintCode => 'أدخل رمز التحقق';

  @override
  String get authHintLoginName => 'أدخل معرّف StartLink ‏(lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'تسجيل الدخول';

  @override
  String get authGetCode => 'إرسال الرمز';

  @override
  String authResendCode(int seconds) {
    return 'إعادة الإرسال بعد $seconds ث';
  }

  @override
  String get authUsePassword => 'استخدام كلمة المرور';

  @override
  String get authUseCode => 'استخدام رمز التحقق';

  @override
  String get authAgreementPrefix => 'قرأت وأوافق على ';

  @override
  String get authAgreementAnd => 'و';

  @override
  String get authTermsLink => 'اتفاقية المستخدم';

  @override
  String get authPrivacyLink => 'سياسة الخصوصية';

  @override
  String get authCaptchaTitle => 'التحقق الأمني';

  @override
  String get authCaptchaHint => 'أدخل الإجابة';

  @override
  String get authCaptchaFailed =>
      'تعذّر الحصول على رمز التحقق الأمني، حاول مجددًا';

  @override
  String get authErrorEmptyCode => 'يُرجى إدخال رمز التحقق';

  @override
  String get authErrorEmptyPassword => 'أدخل كلمة المرور';

  @override
  String get authErrorEmptyLoginName => 'يُرجى إدخال معرّف StartLink';

  @override
  String get authErrorWrongCredentials => 'الحساب أو كلمة المرور غير صحيحة';

  @override
  String get authDeactivatingTitle => 'إلغاء تنشيط الحساب';

  @override
  String get authDeactivatingContent =>
      'حسابك في فترة الانتظار لإغلاقه (7 أيام).\n\nللتراجع عن إغلاق الحساب، انقر على «إلغاء طلب الإغلاق»؛ أو انقر على «متابعة» للدخول إلى التطبيق.';

  @override
  String get authContinueUse => 'متابعة';

  @override
  String get authCancelDeactivation => 'إلغاء طلب الإغلاق';

  @override
  String get authDeactivationCancelled => 'أُلغي طلب الإغلاق واستُعيد الحساب';

  @override
  String get authDeactivationCancelFailed => 'تعذّر الإلغاء، حاول مجددًا';

  @override
  String get authLogout => 'تسجيل الخروج';

  @override
  String get authLogoutConfirm => 'هل تريد تسجيل الخروج بالتأكيد؟';

  @override
  String get authSendingCode => 'جارٍ الإرسال...';

  @override
  String get authCodeSent => 'تم إرسال رمز التحقق';

  @override
  String get authLoginFailed => 'فشل تسجيل الدخول، حاول مجددًا';

  @override
  String get authRegisterFailed => 'فشل التسجيل، حاول مجددًا';

  @override
  String get authEnterpriseCode => 'رمز المؤسسة';

  @override
  String get authEnterpriseCodeHint => 'أدخل رمز المؤسسة';

  @override
  String get authPendingApproval =>
      'تم التسجيل. أُرسل طلب انضمامك إلى المؤسسة وهو في انتظار الموافقة.';

  @override
  String get authNoAccount => 'لا تملك حسابًا؟';

  @override
  String get authRegisterNow => 'التسجيل الآن';

  @override
  String get authCountryPickerTitle => 'اختر البلد/المنطقة';

  @override
  String get authCountrySearchHint => 'ابحث عن بلد/منطقة';

  @override
  String get authCountryChinaMainland => 'البر الرئيسي للصين';

  @override
  String get authCountryHongKong => 'هونغ كونغ، الصين';

  @override
  String get authCountryMacau => 'ماكاو، الصين';

  @override
  String get authCountryTaiwan => 'تايوان، الصين';

  @override
  String get authCountryUnitedStates => 'الولايات المتحدة';

  @override
  String get authCountryUnitedKingdom => 'المملكة المتحدة';

  @override
  String get authCountryJapan => 'اليابان';

  @override
  String get authCountrySouthKorea => 'كوريا الجنوبية';

  @override
  String get authCountrySingapore => 'سنغافورة';

  @override
  String get authCountryMalaysia => 'ماليزيا';

  @override
  String get authCountryAustralia => 'أستراليا';

  @override
  String get authCountryCanada => 'كندا';

  @override
  String get authCountryGermany => 'ألمانيا';

  @override
  String get authCountryFrance => 'فرنسا';

  @override
  String get authCountryIndia => 'الهند';

  @override
  String get authCountryThailand => 'تايلاند';

  @override
  String get authCountryVietnam => 'فيتنام';

  @override
  String get authCountryIndonesia => 'إندونيسيا';

  @override
  String get authCountryPhilippines => 'الفلبين';

  @override
  String get authQuickLoginTitle => 'تسجيل الدخول السريع';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'جارٍ تسجيل الدخول. يُرجى الانتظار.';

  @override
  String get authRoleOwner => 'المالك';

  @override
  String get authRoleAdministrator => 'المسؤول';

  @override
  String get authRoleCustomerService => 'خدمة العملاء';

  @override
  String get authRoleTechnicalSupport => 'الدعم الفني';

  @override
  String get authRoleEmployee => 'موظف';

  @override
  String get authRoleMember => 'عضو';

  @override
  String get authRoleEnterpriseCustomer => 'عميل مؤسسة';

  @override
  String get authUnavailablePrefix => 'غير متاح · ';

  @override
  String get authUnassignedService => 'لا يوجد موظف خدمة معيّن';

  @override
  String authAssignedService(String staff) {
    return 'مُسند إلى $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'عميل · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'موظف · $tenant';
  }

  @override
  String authUserCount(int count) {
    return 'المستخدمون: $count';
  }

  @override
  String get authMetaPhone => 'الهاتف';

  @override
  String get authMetaIdentity => 'الهوية';

  @override
  String get authRegisterTitle => 'التسجيل';

  @override
  String get authNickname => 'الاسم المستعار';

  @override
  String get authNicknameHint => 'عيّن اسمًا مستعارًا';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authPasswordSetHint => 'عيّن كلمة مرور (6 أحرف على الأقل)';

  @override
  String get authConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get authConfirmPasswordHint => 'أدخل كلمة المرور مجددًا';

  @override
  String get authVerificationCode => 'رمز التحقق';

  @override
  String get authRegisterAndLogin => 'التسجيل وتسجيل الدخول';

  @override
  String get authHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get authGoLogin => 'تسجيل الدخول';

  @override
  String get authEmailVerificationUnavailable =>
      'التحقق بالبريد الإلكتروني غير متاح. سجّل برقم هاتف محمول.';

  @override
  String get authSmsVerificationUnavailable =>
      'التحقق بالرسائل النصية غير متاح. سجّل بالبريد الإلكتروني.';

  @override
  String get authSendFailed => 'تعذّر الإرسال. حاول مجددًا.';

  @override
  String get authErrorEmptyNickname => 'أدخل اسمًا مستعارًا';

  @override
  String get authErrorInvalidMobile => 'أدخل رقم هاتف محمول صالحًا';

  @override
  String get authErrorInvalidEmail => 'أدخل عنوان بريد إلكتروني صالحًا';

  @override
  String get authErrorPasswordTooShort =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get authErrorPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get authErrorVerificationRequired =>
      'احصل على رمز التحقق وأدخله أولًا';

  @override
  String get authRegisterErrorTitle => 'فشل التسجيل';

  @override
  String get authGotIt => 'فهمت';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'لم يُعثر على المؤسسة «$code». تحقق من رمز المؤسسة.';
  }

  @override
  String get authTenantSearchFailed => 'فشل البحث. حاول مجددًا.';

  @override
  String get authInvitationInvalid =>
      'رمز الدعوة غير صالح. تحقّق منه وحاول مجددًا.';

  @override
  String get authCollapseJoin => 'إخفاء معلومات الانضمام';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'دعوة صالحة: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'عُثر على المؤسسة: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'اختر منظمة';

  @override
  String get authNoOrganization => 'لا توجد منظمات متاحة';

  @override
  String get authNoOrganizationHint => 'اطلب من المسؤول دعوتك إلى منظمة';

  @override
  String get authPersonalSpace => 'المساحة الشخصية';

  @override
  String get authPersonalSpaceSubtitle => 'محادثات الأصدقاء والمفضلة الشخصية';

  @override
  String get authSpaceIdentityValidationFailed =>
      'تعذّر التحقق من هوية المساحة. حاول مجددًا.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'تعذّر استعادة المساحة الشخصية. حاول مجددًا.';

  @override
  String get authJoinEnterpriseFailed =>
      'تعذّر الانضمام إلى المؤسسة. حاول لاحقًا.';

  @override
  String get homeTitle => 'الرسائل';

  @override
  String get homeGatewayConnectingTitle => 'جارٍ الاتصال';

  @override
  String get homePersonalSpace => 'شخصي';

  @override
  String get homeOfficialService => 'الخدمة الرسمية';

  @override
  String get homeSwitchSpace => 'تبديل المساحة';

  @override
  String get homeSpaceSubtitle => 'شخصي · مؤسسة';

  @override
  String get homeJoinEnterprise => 'الانضمام إلى مؤسسة';

  @override
  String get homeCreateGroup => 'مجموعة جديدة';

  @override
  String get homeAddFriend => 'إضافة جهة اتصال';

  @override
  String get homeScan => 'مسح';

  @override
  String get homeJoinNewSpace => 'الانضمام إلى مساحة جديدة';

  @override
  String get homeSearchConversation => 'بحث';

  @override
  String get homeNoMessages => 'لا توجد رسائل';

  @override
  String get homeDeleteConversation => 'حذف المحادثة';

  @override
  String get homeDeleteConversationConfirm =>
      'هل تريد حذف هذه المحادثة؟ سيُمسح سجلها.';

  @override
  String get homePersonalNote => 'أنا (ملاحظات شخصية)';

  @override
  String get homeWorkNote => 'أنا (ملاحظات العمل)';

  @override
  String homeConversationCount(int count) {
    return 'المحادثات: $count';
  }

  @override
  String homeUnreadCount(int count) {
    return 'غير المقروءة: $count';
  }

  @override
  String get chatInputHint => 'اكتب رسالة...';

  @override
  String get chatVoiceHint => 'اضغط مطولًا للتحدث';

  @override
  String get chatVoiceRelease => 'أفلت للإرسال';

  @override
  String get chatVoiceCancel => 'اسحب لأعلى للإلغاء';

  @override
  String get chatMenuCopy => 'نسخ';

  @override
  String get chatMenuForward => 'إعادة توجيه';

  @override
  String get chatMenuRecall => 'سحب';

  @override
  String get chatMenuDelete => 'حذف';

  @override
  String get chatMenuFavorite => 'حفظ';

  @override
  String get chatMenuReply => 'رد';

  @override
  String get chatMenuMultiSelect => 'تحديد';

  @override
  String get chatMenuTranslate => 'ترجمة';

  @override
  String get chatMenuVoiceToText => 'تحويل إلى نص';

  @override
  String get chatMenuTextToSpeech => 'قراءة بصوت عالٍ';

  @override
  String get chatStatusRecalled => 'سُحبت الرسالة';

  @override
  String get chatRecallSuccess => 'تم السحب';

  @override
  String get chatRecallFailed => 'تعذّر السحب';

  @override
  String get chatRecallTimeout => 'لا يمكن سحب الرسائل الأقدم من دقيقتين';

  @override
  String get chatTranslateFailed => 'فشلت الترجمة، حاول مجددًا';

  @override
  String get chatTranslateNotConfigured => 'خدمة الترجمة غير متاحة';

  @override
  String get chatVoiceToTextFailed => 'فشل التحويل، حاول مجددًا';

  @override
  String get chatTextToSpeechFailed => 'تعذّرت القراءة بصوت عالٍ، حاول مجددًا';

  @override
  String get chatVoiceToText => 'تحويل';

  @override
  String get chatForwardSuccess => 'أُعيد التوجيه';

  @override
  String get chatForwardFailed => 'تعذّرت إعادة التوجيه، حاول مجددًا';

  @override
  String get chatNoConversations => 'لا توجد محادثات لإعادة التوجيه إليها';

  @override
  String get chatSendFailed => 'فشل الإرسال';

  @override
  String get chatResend => 'إعادة إرسال الرمز';

  @override
  String get chatNotFriend => 'ليست في جهات الاتصال';

  @override
  String get chatNotFriendHint =>
      'لستما ضمن جهات اتصال بعضكما بعد. لا يمكن إرسال الرسائل.';

  @override
  String get chatMutedHint => 'جميع الأعضاء ممنوعون من إرسال الرسائل';

  @override
  String get chatFileUploadFailed => 'فشل رفع الملف، حاول مجددًا';

  @override
  String get chatFileStatusNotDownloaded => 'لم يُنزّل';

  @override
  String get chatFileStatusDownloaded => 'تم التنزيل';

  @override
  String get chatFileStatusUploading => 'جارٍ الرفع';

  @override
  String get chatFileStatusUploadFailed => 'فشل التحميل';

  @override
  String get chatCardSendFailed => 'فشل إرسال بطاقة جهة الاتصال';

  @override
  String get chatFavoriteSuccess => 'تم الحفظ';

  @override
  String get chatFavoriteFailed => 'تعذّرت الإضافة إلى المفضلة';

  @override
  String get chatLoadFailed => 'فشل التحميل';

  @override
  String get chatImageMessage => '[صورة]';

  @override
  String get chatVoiceMessage => '[رسالة صوتية]';

  @override
  String get chatVideoMessage => '[فيديو]';

  @override
  String get chatFileMessage => '[ملف]';

  @override
  String get chatLocationMessage => '[موقع]';

  @override
  String get chatContactCardMessage => '[جهة اتصال]';

  @override
  String get chatCallLogMessage => '[مكالمة]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'قرأها: $count';
  }

  @override
  String get chatUnread => 'غير مقروءة';

  @override
  String get chatRecalledSelf => 'سحبتَ رسالة';

  @override
  String chatRecalledPeer(String sender) {
    return 'سحب $sender رسالة';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'الترجمة: $translation';
  }

  @override
  String get chatMessageDeleted => 'حُذفت الرسالة';

  @override
  String get chatPeer => 'أخرى';

  @override
  String get chatSelf => 'أنا';

  @override
  String get chatGenericMessage => '[رسالة]';

  @override
  String get chatVoiceHideText => 'إخفاء النص';

  @override
  String get chatVoiceShowText => 'تحويل إلى نص';

  @override
  String get chatFileDefaultName => 'ملف';

  @override
  String get chatContactDefaultName => 'جهة اتصال';

  @override
  String get chatContactCardTitle => 'بطاقة جهة اتصال';

  @override
  String get chatCallMissed => 'فائتة';

  @override
  String get chatCallCancelled => 'ملغاة';

  @override
  String get chatCallRejected => 'مرفوضة';

  @override
  String get chatCallDisconnected => 'انقطع الاتصال';

  @override
  String get chatCallEnded => 'انتهت المكالمة';

  @override
  String get chatCallFailed => 'فشلت المكالمة';

  @override
  String chatCallDuration(String duration) {
    return 'المدة $duration';
  }

  @override
  String get chatVideoCallTitle => 'مكالمة فيديو';

  @override
  String get chatVoiceCallTitle => 'مكالمة صوتية';

  @override
  String get chatToolPhotos => 'الصور';

  @override
  String get chatToolCamera => 'الكاميرا';

  @override
  String get chatToolFile => 'ملف';

  @override
  String get chatToolLocation => 'الموقع';

  @override
  String get chatToolContactCard => 'جهة اتصال';

  @override
  String get chatToolVoiceCall => 'مكالمة صوتية';

  @override
  String get chatToolVideoCall => 'مكالمة فيديو';

  @override
  String get chatToolFavorites => 'المفضلة';

  @override
  String get chatToolTranslate => 'ترجمة';

  @override
  String get chatTranslationChooseLanguage => 'اختر لغة الترجمة';

  @override
  String get chatTranslationEnterText => 'أدخل نصًا أولًا';

  @override
  String get chatTranslationMentionsUnsupported =>
      'الترجمة غير متاحة للرسائل التي تحتوي على إشارات';

  @override
  String get chatTranslationScheduledUnsupported =>
      'الترجمة غير متاحة أثناء تعديل رسالة مجدولة';

  @override
  String get chatTranslationFailed => 'فشلت الترجمة. حاول مجددًا';

  @override
  String get chatTranslationEmpty => 'لم تُعد أي ترجمة. حاول مجددًا';

  @override
  String get chatTranslationTranslating => 'جارٍ الترجمة…';

  @override
  String get chatTranslationSend => 'إرسال الترجمة';

  @override
  String get chatTranslationSending => 'جارٍ الإرسال…';

  @override
  String get chatTranslationExpand => 'عرض المزيد';

  @override
  String get chatTranslationCollapse => 'عرض أقل';

  @override
  String get chatFileTooLarge => 'يتجاوز الملف الحد المسموح (100 ميغابايت)';

  @override
  String get chatInputMutedAdminOnly =>
      'يمكن للمالك أو الأعضاء المحددين فقط إرسال الرسائل.';

  @override
  String get chatImageUploadUnsupported =>
      'فشل رفع الصورة. دعم الخادم غير متاح بعد.';

  @override
  String get chatFavoriteLongPressHint =>
      'اضغط مطولًا على رسالة لإضافتها إلى المفضلة';

  @override
  String chatSelectedCount(int count) {
    return 'المحدد: $count';
  }

  @override
  String get chatLocationSheetTitle => 'إرسال موقع';

  @override
  String get chatLocationNameLabel => 'اسم المكان';

  @override
  String get chatLocationNameHint => 'مثل المكتب أو عنوان العميل';

  @override
  String get chatLocationAddressLabel => 'العنوان';

  @override
  String get chatLocationOptionalHint => 'اختياري';

  @override
  String get chatLocationLatitudeLabel => 'خط العرض';

  @override
  String get chatLocationLatitudeHint => 'من -90 إلى 90';

  @override
  String get chatLocationLongitudeLabel => 'خط الطول';

  @override
  String get chatLocationLongitudeHint => 'من -180 إلى 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'أدخل $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label خارج النطاق';
  }

  @override
  String get chatLocationDefaultTitle => 'الموقع';

  @override
  String get chatMutedFullNotice =>
      'هذه المجموعة ممنوعة من إرسال الرسائل. يمكن للمالك أو الأعضاء المحددين فقط إرسالها.';

  @override
  String get chatNotFriendSendBlocked =>
      'لم تعودا صديقين ولا يمكنك إرسال الرسائل';

  @override
  String get chatPersonalNotesTitle => 'ملاحظات شخصية';

  @override
  String get chatWorkNotesTitle => 'ملاحظات العمل';

  @override
  String get chatPersonalNotesDescription =>
      'دوّن أفكارك الشخصية واحفظ المعلومات المهمة هنا\nتُزامن بين الأجهزة للوصول إليها في أي وقت';

  @override
  String get chatWorkNotesDescription =>
      'دوّن مهام العمل واحفظ مواده هنا\nتبقى مساحات الفرق منفصلة وآمنة';

  @override
  String get chatNoMessages => 'لا توجد رسائل';

  @override
  String chatReplyTo(String sender) {
    return 'الرد على $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature قريبًا';
  }

  @override
  String get chatForwardSelectTitle => 'اختر محادثة';

  @override
  String get chatContactSelectTitle => 'اختر جهة اتصال';

  @override
  String get chatNoContacts => 'لا توجد جهات اتصال';

  @override
  String get contactsTitle => 'جهات الاتصال';

  @override
  String get contactsSearch => 'بحث في جهات الاتصال';

  @override
  String get contactsNewFriends => 'أصدقاء جدد';

  @override
  String get contactsGroups => 'المجموعات';

  @override
  String get contactsFavorites => 'المفضلة';

  @override
  String get contactsRecent => 'الأخيرة';

  @override
  String get contactsOrganization => 'المنظمة';

  @override
  String get contactsAnnouncement => 'الإعلانات';

  @override
  String get contactsNewApplications => 'طلبات جديدة';

  @override
  String get contactsCustomerGroups => 'مجموعات العملاء';

  @override
  String get contactsAllCustomers => 'جميع العملاء';

  @override
  String get contactsMyCustomers => 'عملائي';

  @override
  String get contactsViewAll => 'عرض الكل';

  @override
  String get contactsMyContacts => 'جهات اتصالي';

  @override
  String get contactsMyAdvisor => 'مستشاري';

  @override
  String get contactsNoAdvisor => 'لم يُعيّن مستشار بعد';

  @override
  String get contactsAdvisorLoading => 'جارٍ التحميل...';

  @override
  String get contactsNavigateFailed => 'تعذّر فتح الصفحة، حاول مجددًا';

  @override
  String get contactsEmpty => 'لا توجد جهات اتصال';

  @override
  String get contactsNoAnnouncement => 'لا توجد إعلانات';

  @override
  String get contactsOfficialBadge => 'رسمي';

  @override
  String get contactsCustomerBadge => 'عميل';

  @override
  String get contactsEmptyCustomers => 'لا يوجد عملاء';

  @override
  String get myTitle => 'أنا';

  @override
  String get myEnterpriseInfo => 'معلومات المؤسسة';

  @override
  String get myEnterpriseManage => 'إدارة المؤسسة';

  @override
  String get myQrCode => 'رمز QR';

  @override
  String get myFavorites => 'المفضلة';

  @override
  String get myLanguage => 'اللغة';

  @override
  String get myTimezone => 'المنطقة الزمنية';

  @override
  String get myAutoTranslate => 'الترجمة التلقائية';

  @override
  String get myNetworkSwitch => 'تبديل الخط';

  @override
  String get mySettings => 'الإعدادات';

  @override
  String get myLogout => 'تسجيل الخروج';

  @override
  String get myLogoutConfirm => 'هل تريد تسجيل الخروج بالتأكيد؟';

  @override
  String get myLeaveEnterprise => 'مغادرة المؤسسة';

  @override
  String get myLeaveEnterpriseConfirm =>
      'هل تريد مغادرة هذه المؤسسة بالتأكيد؟ ستفقد الوصول إلى بياناتها.';

  @override
  String get myLeaveEnterpriseSuccess => 'غادرت المؤسسة';

  @override
  String get myLeaveEnterpriseFailed => 'تعذّرت المغادرة، حاول مجددًا';

  @override
  String get myLppIdCopied => 'نُسخ معرّف StartLink';

  @override
  String myLppIdLabel(String lppId) {
    return 'معرّف StartLink: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return 'جهات الاتصال: $count';
  }

  @override
  String get myAutoSelect => 'تلقائي';

  @override
  String get myPresenceStatus => 'حالة التواجد';

  @override
  String get myPresenceStatusTitle => 'تعيين حالة التواجد';

  @override
  String get myPresenceOnline => 'متصل';

  @override
  String get myPresenceBusy => 'مشغول';

  @override
  String get myPresenceAway => 'بعيد';

  @override
  String get myPresenceInvisible => 'غير مرئي';

  @override
  String get profileTitle => 'ملفي';

  @override
  String get profileName => 'الاسم';

  @override
  String get profileGender => 'النوع';

  @override
  String get profileBirthday => 'تاريخ الميلاد';

  @override
  String get profileRegion => 'المنطقة';

  @override
  String get profileSignature => 'نبذة';

  @override
  String get profileSignatureHint => 'حدّثنا عن نفسك';

  @override
  String get profileTapTapText => 'نقرة';

  @override
  String get profileTapTapHint => 'النص المعروض عند النقر (20 حرفًا كحد أقصى)';

  @override
  String get profileAccountSection => 'الحساب';

  @override
  String get profileBasicSection => 'المعلومات الأساسية';

  @override
  String get profileLppId => 'معرّف StartLink';

  @override
  String get profileLppIdNotSet => 'غير محدد';

  @override
  String get profileMobile => 'الهاتف';

  @override
  String get profileMobileUnbound => 'غير مرتبط';

  @override
  String get profileEmail => 'البريد الإلكتروني';

  @override
  String get profileEmailUnbound => 'غير مرتبط';

  @override
  String get profileQrCode => 'رمز QR الخاص بي';

  @override
  String get profileChangePassword => 'تغيير كلمة المرور';

  @override
  String get profileGenderMale => 'ذكر';

  @override
  String get profileGenderFemale => 'أنثى';

  @override
  String get profileGenderOther => 'أخرى';

  @override
  String get profileGenderUnset => 'غير محدد';

  @override
  String get profileSaveFailed => 'تعذّر الحفظ، حاول مجددًا';

  @override
  String get profileLppIdTitle => 'معرّف StartLink';

  @override
  String get profileLppIdSetOnce =>
      'يمكن تغيير معرّف StartLink مرة واحدة فقط. اختر بعناية.';

  @override
  String get profileLppIdChangeFailed =>
      'تعذّر التغيير (يمكن تغيير معرّف StartLink مرة واحدة فقط)';

  @override
  String get profileChangePasswordOld => 'كلمة المرور الحالية';

  @override
  String get profileChangePasswordNew => 'كلمة المرور الجديدة';

  @override
  String get profileChangePasswordConfirm => 'تأكيد كلمة المرور الجديدة';

  @override
  String get profileChangePasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get profileChangePasswordSuccess =>
      'تغيّرت كلمة المرور. سجّل الدخول مجددًا.';

  @override
  String get profileChangePasswordFailed =>
      'تعذّر تغيير كلمة المرور، حاول مجددًا';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSectionEnterprise => 'المؤسسة';

  @override
  String get settingsSectionAccount => 'الحساب';

  @override
  String get settingsSectionGeneral => 'عام';

  @override
  String get settingsSectionFeatures => 'الميزات';

  @override
  String get settingsSectionAbout => 'حول';

  @override
  String get settingsEnterpriseInfo => 'معلومات المؤسسة';

  @override
  String get settingsProfile => 'ملفي';

  @override
  String get settingsAccountSecurity => 'أمان الحساب';

  @override
  String get settingsNotification => 'الإشعارات';

  @override
  String get settingsDisplay => 'العرض';

  @override
  String get settingsFriendPrivacy => 'الخصوصية';

  @override
  String get settingsChat => 'المحادثة';

  @override
  String get settingsChatHistory => 'سجل المحادثات';

  @override
  String get settingsAbout => 'حول StartLink';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsTimezone => 'المنطقة الزمنية';

  @override
  String get settingsAutoTranslate => 'الترجمة التلقائية';

  @override
  String get settingsNetworkSwitch => 'تبديل الخط';

  @override
  String get enterpriseInfoTitle => 'معلومات المؤسسة';

  @override
  String get enterpriseName => 'الاسم';

  @override
  String get enterpriseDescription => 'الوصف';

  @override
  String get enterpriseUpdateSuccess => 'تم التحديث بنجاح';

  @override
  String get enterpriseUpdateFailed => 'فشل التحديث، حاول مجددًا';

  @override
  String get enterpriseLeave => 'مغادرة المؤسسة';

  @override
  String get enterpriseLeaveConfirm => 'هل تريد مغادرة هذه المؤسسة بالتأكيد؟';

  @override
  String get enterpriseLeaveSuccess => 'غادرت المؤسسة';

  @override
  String get enterpriseLeaveFailed => 'تعذّرت المغادرة، حاول مجددًا';

  @override
  String get enterpriseLeaveOwnerError =>
      'لا يمكن للمالك المغادرة مباشرة. انقل الملكية أولًا.';

  @override
  String get enterpriseMemberCount => 'الأعضاء';

  @override
  String get enterpriseCreatedAt => 'تاريخ الإنشاء';

  @override
  String get enterpriseCode => 'رمز المؤسسة';

  @override
  String get enterpriseInviteMembers => 'دعوة أعضاء';

  @override
  String get enterpriseCopyInviteCode => 'نسخ رمز الدعوة';

  @override
  String get enterpriseInviteCodeCopied => 'نُسخ رمز الدعوة';

  @override
  String get groupCreateTitle => 'مجموعة جديدة';

  @override
  String get groupNameHint => 'أدخل اسم المجموعة';

  @override
  String get groupCreateSuccess => 'أُنشئت المجموعة';

  @override
  String get groupCreateFailed => 'تعذّر إنشاء المجموعة';

  @override
  String get groupSettings => 'إعدادات المجموعة';

  @override
  String get groupName => 'اسم المجموعة';

  @override
  String get groupAvatar => 'صورة المجموعة';

  @override
  String get groupAnnouncement => 'إعلان';

  @override
  String get groupMembers => 'الأعضاء';

  @override
  String get groupAddMember => 'إضافة أعضاء';

  @override
  String get groupRemoveMember => 'إزالة عضو';

  @override
  String get groupRemoveMemberConfirm => 'هل تريد إزالة هذا العضو؟';

  @override
  String get groupSetAdmin => 'تعيين مسؤول';

  @override
  String get groupRemoveAdmin => 'إزالة صلاحية المسؤول';

  @override
  String get groupTransferOwner => 'نقل الملكية';

  @override
  String get groupTransferOwnerConfirm =>
      'هل تريد نقل ملكية المجموعة إلى هذا العضو؟';

  @override
  String get groupTransferOwnerSuccess => 'نُقلت الملكية';

  @override
  String get groupTransferOwnerFailed => 'فشل النقل، حاول مجددًا';

  @override
  String get groupLeave => 'مغادرة المجموعة';

  @override
  String get groupLeaveConfirm => 'هل تريد مغادرة هذه المجموعة؟';

  @override
  String get groupLeaveSuccess => 'غادرت المجموعة';

  @override
  String get groupLeaveFailed => 'تعذّرت المغادرة، حاول مجددًا';

  @override
  String get groupDissolve => 'حل المجموعة';

  @override
  String get groupDissolveConfirm =>
      'هل تريد حل هذه المجموعة؟ سيُزال جميع الأعضاء.';

  @override
  String get groupDissolveSuccess => 'حُلّت المجموعة';

  @override
  String get groupDissolveFailed => 'تعذّر حل المجموعة، حاول مجددًا';

  @override
  String get groupQrCode => 'رمز QR للمجموعة';

  @override
  String get groupMuteAll => 'منع الجميع من الإرسال';

  @override
  String get groupMuteAllOn => 'تفعيل منع الجميع من الإرسال';

  @override
  String get groupMuteAllOff => 'إيقاف منع الجميع من الإرسال';

  @override
  String get groupAllowMemberInvite => 'السماح للأعضاء بالدعوة';

  @override
  String get groupAllowMemberModifyTitle =>
      'السماح للأعضاء بتغيير اسم المجموعة';

  @override
  String get groupAllowMemberAtAll => 'السماح للأعضاء بالإشارة إلى @الجميع';

  @override
  String get groupAllowMemberViewMemberList =>
      'السماح للأعضاء بعرض قائمة الأعضاء';

  @override
  String get groupAllowQrCodeJoin => 'السماح بالانضمام عبر رمز QR';

  @override
  String get groupRequireApproval => 'اشتراط الموافقة للانضمام';

  @override
  String get groupAllowMemberAddFriend => 'السماح للأعضاء بإضافة بعضهم';

  @override
  String get groupRoleOwner => 'المالك';

  @override
  String get groupRoleAdmin => 'مسؤول';

  @override
  String get groupRoleMember => 'عضو';

  @override
  String get groupNoMembers => 'لا يوجد أعضاء';

  @override
  String get groupNoAnnouncements => 'لا توجد إعلانات';

  @override
  String get groupCreateAnnouncement => 'نشر إعلان';

  @override
  String get groupEditAnnouncement => 'تعديل إعلان';

  @override
  String get groupDeleteAnnouncement => 'حذف إعلان';

  @override
  String get groupDeleteAnnouncementConfirm => 'هل تريد حذف هذا الإعلان؟';

  @override
  String get groupAnnouncementTitle => 'العنوان';

  @override
  String get groupAnnouncementContent => 'المحتوى';

  @override
  String get groupAnnouncementPin => 'تثبيت الإعلان';

  @override
  String groupMemberCount(int count) {
    return 'الأعضاء: $count';
  }

  @override
  String groupSelectedCount(int count) {
    return 'المحدد: $count';
  }

  @override
  String get groupJoinRequestApprove => 'موافق';

  @override
  String get groupJoinRequestReject => 'رفض';

  @override
  String get groupJoinRequests => 'طلبات الانضمام';

  @override
  String get groupNoJoinRequests => 'لا توجد طلبات انضمام';

  @override
  String get groupReadReceipts => 'إيصالات القراءة';

  @override
  String groupReadCount(int count) {
    return 'قرأها: $count';
  }

  @override
  String groupUnreadCount(int count) {
    return 'غير المقروءة: $count';
  }

  @override
  String get friendAddTitle => 'إضافة جهة اتصال';

  @override
  String get friendSearchHint => 'الهاتف / البريد الإلكتروني / معرّف StartLink';

  @override
  String get friendRequestSent => 'أُرسل طلب الصداقة';

  @override
  String get friendRequestFailed => 'فشل الإرسال، حاول مجددًا';

  @override
  String get friendAlreadyFriend => 'ضمن جهات الاتصال بالفعل';

  @override
  String get friendNewFriendsTitle => 'أصدقاء جدد';

  @override
  String get friendNoRequests => 'لا توجد طلبات صداقة';

  @override
  String get friendAccept => 'قبول';

  @override
  String get friendReject => 'رفض';

  @override
  String get friendAccepted => 'مقبول';

  @override
  String get friendRejected => 'مرفوض';

  @override
  String get friendDeleteConfirm => 'هل تريد إزالة جهة الاتصال هذه؟';

  @override
  String get friendDeleteSuccess => 'أُزيلت جهة الاتصال';

  @override
  String get friendDeleteFailed => 'تعذّرت الإزالة، حاول مجددًا';

  @override
  String get friendRemarkName => 'الاسم المستعار';

  @override
  String get friendGroupName => 'المجموعة';

  @override
  String get friendSendMessage => 'رسالة';

  @override
  String get friendMatchTypeLppId => 'مطابقة بمعرّف StartLink';

  @override
  String get friendMatchTypeMobile => 'مطابقة بالهاتف';

  @override
  String get friendMatchTypeEmail => 'مطابقة بالبريد الإلكتروني';

  @override
  String get friendSearchEmpty => 'لم يُعثر على مستخدمين';

  @override
  String get friendAddMessage => 'أود إضافتك إلى جهات اتصالي';

  @override
  String get friendBlockConfirm => 'هل تريد حظر هذا المستخدم؟';

  @override
  String get friendUnblockConfirm => 'هل تريد إلغاء حظر هذا المستخدم؟';

  @override
  String get friendBlockSuccess => 'محظور';

  @override
  String get friendUnblockSuccess => 'أُلغي الحظر';

  @override
  String get profilePageTitle => 'المعلومات الشخصية';

  @override
  String get profilePageSendMessage => 'رسالة';

  @override
  String get profilePageAddFriend => 'إضافة صديق';

  @override
  String get profilePageAlreadyFriend => 'أصدقاء بالفعل';

  @override
  String get profilePageBlocked => 'محظور';

  @override
  String get profilePageBlock => 'حظر';

  @override
  String get profilePageUnblock => 'إلغاء الحظر';

  @override
  String get profilePageHidden => 'أخفى هذا المستخدم ملفه الشخصي';

  @override
  String get profilePageFriendsOnly =>
      'يعرض هذا المستخدم ملفه الشخصي للأصدقاء فقط';

  @override
  String get profilePageLppId => 'معرّف StartLink';

  @override
  String get profilePageRemarkName => 'ملاحظات';

  @override
  String get profilePageEditRemark => 'تعديل الاسم المستعار';

  @override
  String get profilePageSaveRemarkSuccess => 'حُفظ الاسم المستعار';

  @override
  String get profilePageSaveRemarkFailed => 'تعذّر الحفظ، حاول مجددًا';

  @override
  String get searchTitle => 'بحث';

  @override
  String get searchHint =>
      'ابحث بالهاتف أو البريد الإلكتروني أو معرّف StartLink';

  @override
  String get searchNoResults => 'لم يُعثر على نتائج';

  @override
  String get searchMessages => 'الرسائل';

  @override
  String get searchUsers => 'المستخدمون';

  @override
  String get searchFailed => 'فشل البحث، حاول مجددًا';

  @override
  String get scanTitle => 'مسح';

  @override
  String get scanFailed => 'فشل التعرّف، حاول مجددًا';

  @override
  String get scanInvalidQrCode => 'رمز QR غير صالح';

  @override
  String get scanFlashOn => 'تشغيل المصباح';

  @override
  String get scanFlashOff => 'إطفاء المصباح';

  @override
  String get scanAlbum => 'اختر من الألبوم';

  @override
  String get favoritesTitle => 'المفضلة';

  @override
  String get favoritesEmpty => 'لا توجد عناصر محفوظة بعد';

  @override
  String get favoritesAll => 'الكل';

  @override
  String get favoritesText => 'نص';

  @override
  String get favoritesImage => 'الصور';

  @override
  String get favoritesVideo => 'فيديو';

  @override
  String get favoritesVoice => 'الصوت';

  @override
  String get favoritesFile => 'الملفات';

  @override
  String get favoritesOther => 'أخرى';

  @override
  String get favoritesDeleteConfirm => 'هل تريد الإزالة من المفضلة؟';

  @override
  String get favoritesDeleteSuccess => 'تمت إزالتها من المحفوظات';

  @override
  String get favoritesDeleteFailed => 'تعذّرت الإزالة';

  @override
  String get favoritesOriginalRecalled => 'سُحبت الرسالة';

  @override
  String get favoritesViewOriginal => 'عرض الأصل';

  @override
  String get favoritesSearchHint => 'بحث في المفضلة';

  @override
  String get favoritesNoResults => 'لا توجد عناصر مفضلة مطابقة';

  @override
  String get noticeTitle => 'الإعلانات';

  @override
  String get noticeEmpty => 'لا توجد إعلانات';

  @override
  String get noticeDetail => 'تفاصيل الإعلان';

  @override
  String get noticePublishedAt => 'تاريخ النشر';

  @override
  String get noticePriorityNormal => 'عادي';

  @override
  String get noticePriorityImportant => 'مهم';

  @override
  String get noticePriorityUrgent => 'عاجل';

  @override
  String get organizationTitle => 'المنظمة';

  @override
  String get organizationEmpty => 'لا توجد معلومات عن القسم';

  @override
  String get organizationMembers => 'الأعضاء';

  @override
  String get organizationDepartment => 'القسم';

  @override
  String get organizationPosition => 'المنصب';

  @override
  String get organizationLeader => 'المسؤول المباشر';

  @override
  String get qrCodeTitle => 'رمز QR الخاص بي';

  @override
  String get qrCodeSave => 'حفظ في الألبوم';

  @override
  String get qrCodeShare => 'مشاركة';

  @override
  String get qrCodeSaveSuccess => 'تم الحفظ في الألبوم';

  @override
  String get qrCodeSaveFailed => 'تعذّر الحفظ، حاول مجددًا';

  @override
  String get qrCodeRefresh => 'تحديث رمز QR';

  @override
  String get qrCodeExpired => 'انتهت صلاحية رمز QR، يُرجى تحديثه';

  @override
  String get qrCodeScanToAdd => 'امسح لإضافتي إلى جهات الاتصال';

  @override
  String get spacePersonal => 'شخصي';

  @override
  String get spaceEnterprise => 'المؤسسة';

  @override
  String get spaceJoinByCode => 'الانضمام برمز المؤسسة';

  @override
  String get spaceJoinByInvite => 'الانضمام برمز الدعوة';

  @override
  String get spaceEnterCode => 'أدخل رمز المؤسسة';

  @override
  String get spaceEnterInviteCode => 'أدخل رمز الدعوة';

  @override
  String get spaceSearchEnterprise => 'بحث عن مؤسسة';

  @override
  String get spaceJoinRequestSent => 'أُرسل الطلب، في انتظار الموافقة';

  @override
  String get spaceJoinRequestPending => 'في انتظار الموافقة';

  @override
  String get spaceJoinRequestApproved => 'تمت الموافقة على الطلب';

  @override
  String get spaceJoinRequestRejected => 'رُفض الطلب';

  @override
  String get spaceAlreadyMember => 'أنت عضو بالفعل';

  @override
  String get spaceAutoApproved => 'تمت الموافقة تلقائيًا. أهلًا بك!';

  @override
  String get spacePendingApprovalHint => 'تم التسجيل. أُرسل طلب انضمامك.';

  @override
  String get spaceNoSpaces => 'لا توجد مساحات';

  @override
  String get spaceInviteExpired => 'انتهت صلاحية رمز الدعوة';

  @override
  String get spaceInviteTargetMismatch => 'رمز الدعوة هذا غير مخصص لحسابك';

  @override
  String get spaceAcceptInviteSuccess => 'تم الانضمام إلى المؤسسة';

  @override
  String get spaceAcceptInviteFailed => 'تعذّر الانضمام، حاول مجددًا';

  @override
  String get spaceTenantSelectTitle => 'اختر مساحة';

  @override
  String get spaceTenantSelectHint => 'اختر مساحة للدخول';

  @override
  String get spaceEnterPersonal => 'دخول المساحة الشخصية';

  @override
  String get spaceEnterEnterprise => 'دخول مساحة المؤسسة';

  @override
  String get aboutTitle => 'حول StartLink';

  @override
  String get aboutVersion => 'الإصدار';

  @override
  String get aboutTerms => 'اتفاقية المستخدم';

  @override
  String get aboutPrivacy => 'سياسة الخصوصية';

  @override
  String get aboutOpenSource => 'تراخيص المصادر المفتوحة';

  @override
  String get aboutCheckUpdate => 'البحث عن تحديثات';

  @override
  String get aboutLatestVersion => 'أنت تستخدم أحدث إصدار';

  @override
  String get aboutUpdateAvailable => 'الإصدار الجديد متوفر';

  @override
  String get aboutUpdateNow => 'التحديث الآن';

  @override
  String get aboutUpdateLater => 'لاحقًا';

  @override
  String get notificationTitle => 'الإشعارات';

  @override
  String get notificationGlobalMute => 'عدم الإزعاج';

  @override
  String get notificationSound => 'صوت';

  @override
  String get notificationVibration => 'الاهتزاز';

  @override
  String get notificationPreview => 'معاينة الرسائل';

  @override
  String get notificationDndStart => 'وقت بدء عدم الإزعاج';

  @override
  String get notificationDndEnd => 'وقت انتهاء عدم الإزعاج';

  @override
  String get blacklistTitle => 'مُدرج في القائمة السوداء';

  @override
  String get blacklistEmpty => 'لا يوجد مستخدمون محظورون';

  @override
  String get blacklistRemove => 'إلغاء الحظر';

  @override
  String get blacklistRemoveConfirm => 'هل تريد إلغاء حظر هذا المستخدم؟';

  @override
  String get feedbackTitle => 'الملاحظات';

  @override
  String get feedbackTypeComplaint => 'شكوى';

  @override
  String get feedbackTypeSuggestion => 'اقتراح';

  @override
  String get feedbackTypeBug => 'بلاغ عن خلل';

  @override
  String get feedbackContent => 'الوصف';

  @override
  String get feedbackContentHint => 'صف المشكلة أو الاقتراح بالتفصيل';

  @override
  String get feedbackContact => 'معلومات التواصل (اختياري)';

  @override
  String get feedbackSubmit => 'إرسال';

  @override
  String get feedbackSuccess => 'أُرسلت الملاحظات. شكرًا لك!';

  @override
  String get feedbackFailed => 'فشل الإرسال، حاول مجددًا';

  @override
  String get networkTitle => 'تبديل الخط';

  @override
  String get networkAutoSelect => 'تلقائي';

  @override
  String get networkManual => 'يدوي';

  @override
  String get timezoneTitle => 'المنطقة الزمنية';

  @override
  String get timezoneAuto => 'اتباع النظام';

  @override
  String get autoTranslateTitle => 'الترجمة التلقائية';

  @override
  String get autoTranslateEnabled => 'تفعيل الترجمة التلقائية';

  @override
  String get autoTranslateLanguage => 'اللغة المستهدفة';

  @override
  String get displayTitle => 'العرض';

  @override
  String get displayFontSize => 'حجم الخط';

  @override
  String get displayChatBackground => 'خلفية المحادثة';

  @override
  String get displayDarkMode => 'المظهر';

  @override
  String get displayDarkModeSystem => 'اتباع النظام';

  @override
  String get displayDarkModeSystemHint => 'التبديل تلقائيًا حسب إعداد النظام';

  @override
  String get displayDarkModeOff => 'فاتح';

  @override
  String get displayDarkModeOffHint => 'استخدام المظهر الفاتح دائمًا';

  @override
  String get displayDarkModeOn => 'داكن';

  @override
  String get displayDarkModeOnHint => 'استخدام المظهر الداكن دائمًا';

  @override
  String get chatSettingsTitle => 'المحادثة';

  @override
  String get chatHistoryTitle => 'سجل المحادثات';

  @override
  String get chatHistoryClear => 'مسح كل السجل';

  @override
  String get chatHistoryClearConfirm =>
      'هل تريد مسح سجل جميع المحادثات؟ لا يمكن التراجع عن ذلك.';

  @override
  String get chatHistoryClearSuccess => 'مُسح سجل المحادثات';

  @override
  String get accountSecurityTitle => 'أمان الحساب';

  @override
  String get accountSecurityChangePassword => 'تغيير كلمة المرور';

  @override
  String get accountSecurityChangeMobile => 'تغيير رقم الجوال';

  @override
  String get accountSecurityChangeEmail => 'تغيير البريد الإلكتروني';

  @override
  String get accountSecurityLoggedDevices => 'الأجهزة المسجّل دخولها';

  @override
  String get accountSecurityDeactivate => 'إغلاق الحساب';

  @override
  String get accountSecurityDeactivateConfirm =>
      'ستُحذف جميع البيانات نهائيًا بعد 7 أيام. هل تريد إغلاق الحساب؟';

  @override
  String get loggedDevicesTitle => 'الأجهزة المسجّل دخولها';

  @override
  String get loggedDevicesCurrent => 'هذا الجهاز';

  @override
  String get loggedDevicesRevoke => 'تسجيل الخروج';

  @override
  String get loggedDevicesRevokeConfirm =>
      'هل تريد تسجيل الخروج من هذا الجهاز؟';

  @override
  String get loggedDevicesRevokeSuccess => 'تم تسجيل الخروج من الجهاز';

  @override
  String get loggedDevicesRevokeFailed => 'فشلت العملية، حاول مجددًا';

  @override
  String get loggedDevicesLastActive => 'آخر نشاط';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'الويب';

  @override
  String get loggedDevicesTypeDesktop => 'سطح المكتب';

  @override
  String get loggedDevicesTypeUnknown => 'جهاز غير معروف';

  @override
  String get privacySettingsTitle => 'الخصوصية';

  @override
  String get privacySearchableByMobile => 'السماح بالبحث برقم الهاتف';

  @override
  String get privacySearchableByLppId => 'السماح بالبحث بمعرّف StartLink';

  @override
  String get privacyAllowFriendRequest => 'السماح بطلبات الصداقة';

  @override
  String get privacyProfileVisibility => 'ظهور الملف الشخصي';

  @override
  String get privacyEveryone => 'الجميع';

  @override
  String get privacyFriendsOfFriends => 'أصدقاء الأصدقاء';

  @override
  String get privacyNobody => 'لا أحد';

  @override
  String get privacyFriendsOnly => 'الأصدقاء فقط';

  @override
  String get privacySaveSuccess => 'حُفظت الإعدادات';

  @override
  String get privacySaveFailed => 'تعذّر الحفظ، حاول مجددًا';

  @override
  String get fontSizeTitle => 'حجم الخط';

  @override
  String get fontSizeSmall => 'صغير';

  @override
  String get fontSizeNormal => 'عادي';

  @override
  String get fontSizeLarge => 'كبير';

  @override
  String get fontSizeExtraLarge => 'كبير جدًا';

  @override
  String get fontSizePreview => 'معاينة';

  @override
  String get chatBackgroundTitle => 'خلفية المحادثة';

  @override
  String get chatBackgroundDefault => 'افتراضي';

  @override
  String get chatBackgroundCustom => 'مخصص';

  @override
  String get chatBackgroundReset => 'استعادة الإعدادات الافتراضية';

  @override
  String get termsTitle => 'اتفاقية المستخدم';

  @override
  String get privacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get recentContactsTitle => 'الأخيرة';

  @override
  String get recentContactsEmpty => 'لا توجد جهات اتصال حديثة';

  @override
  String get inviteFriendsTitle => 'دعوة أصدقاء';

  @override
  String get inviteFriendsCopyLink => 'نسخ رابط الدعوة';

  @override
  String get inviteFriendsLinkCopied => 'نُسخ رابط الدعوة';

  @override
  String get imageViewerTitle => 'صورة';

  @override
  String get imageViewerSave => 'حفظ في الألبوم';

  @override
  String get imageViewerSaveSuccess => 'تم الحفظ في الألبوم';

  @override
  String get imageViewerSaveFailed => 'تعذّر الحفظ، حاول مجددًا';

  @override
  String get customerServiceTitle => 'مكتب الخدمة';

  @override
  String get customerServiceQueue => 'في الانتظار';

  @override
  String get customerServiceActive => 'نشطة';

  @override
  String get customerServiceClaim => 'قبول';

  @override
  String get customerServiceTakeover => 'تولّي المحادثة';

  @override
  String get customerServiceClose => 'إنهاء الخدمة';

  @override
  String get customerServiceCloseConfirm => 'هل تريد إنهاء جلسة الخدمة هذه؟';

  @override
  String get customerServiceNoQueue => 'لا توجد جلسات في الانتظار';

  @override
  String get customerServiceNoActive => 'لا توجد جلسات نشطة';

  @override
  String get customerServiceVisitor => 'زائر';

  @override
  String get customerServiceCustomer => 'عميل';

  @override
  String get customerServiceAssignedTo => 'مُسند إلى';

  @override
  String get customerServiceTransferConversation => 'نقل المحادثة';

  @override
  String get marketingToolbar => 'أدوات التسويق';

  @override
  String get callIncoming => 'مكالمة واردة';

  @override
  String get callOutgoing => 'مكالمة صادرة';

  @override
  String get callAccept => 'قبول';

  @override
  String get callReject => 'رفض';

  @override
  String get callHangup => 'إنهاء';

  @override
  String get callMissed => 'مكالمة فائتة';

  @override
  String get callDuration => 'المدة';

  @override
  String get callAudio => 'مكالمة صوتية';

  @override
  String get callGeneric => 'مكالمة';

  @override
  String get callVideo => 'مكالمة فيديو';

  @override
  String get callConnecting => 'جارٍ الاتصال...';

  @override
  String get callRinging => 'جارٍ الرنين...';

  @override
  String get callEnded => 'انتهت المكالمة';

  @override
  String get callFailed => 'فشلت المكالمة';

  @override
  String get callRejected => 'رُفضت المكالمة';

  @override
  String get callTimeout => 'لا توجد إجابة';

  @override
  String get callCancelled => 'ملغاة';

  @override
  String get callUnknownPeer => 'غير معروف';

  @override
  String get callVideoInvitation => 'دعوة إلى مكالمة فيديو';

  @override
  String get callAudioInvitation => 'دعوة إلى مكالمة صوتية';

  @override
  String get callAnswerAudio => 'الرد بالصوت';

  @override
  String get callAnswerVideo => 'الرد بالفيديو';

  @override
  String get callViewProfile => 'عرض الملف الشخصي';

  @override
  String get callOpeningCamera => 'جارٍ فتح الكاميرا...';

  @override
  String get callWaitingRemoteVideo => 'في انتظار فيديو الطرف الآخر...';

  @override
  String get callCameraOff => 'الكاميرا متوقفة';

  @override
  String get callCameraOn => 'الكاميرا مفعّلة';

  @override
  String get callMicrophoneOff => 'الميكروفون متوقف';

  @override
  String get callMicrophoneOn => 'الميكروفون مفعّل';

  @override
  String get callSpeakerOff => 'مكبر الصوت متوقف';

  @override
  String get callSpeakerOn => 'مكبر الصوت مفعّل';

  @override
  String get callVideoPermissionFailure =>
      'تعذّر بدء مكالمة الفيديو. تحقق من إذني الكاميرا والميكروفون وحاول مجددًا.';

  @override
  String get callAudioPermissionFailure =>
      'تعذّر بدء المكالمة الصوتية. تحقق من إذن الميكروفون وحاول مجددًا.';

  @override
  String get callIncompleteIncoming =>
      'معلومات المكالمة الواردة غير مكتملة ولا يمكن الرد عليها.';

  @override
  String get callInProgress => 'في مكالمة';

  @override
  String get callCalling => 'جارٍ الاتصال...';

  @override
  String callEndedMedia(String media) {
    return 'انتهت $media';
  }

  @override
  String callRejectedMedia(String media) {
    return 'رُفضت $media';
  }

  @override
  String callUnansweredMedia(String media) {
    return 'لم يُرد على $media';
  }

  @override
  String callCancelledMedia(String media) {
    return 'أُلغيت $media';
  }

  @override
  String get callConnectionLost => 'انقطع اتصال المكالمة';

  @override
  String get callAdminEnded => 'أنهى المسؤول المكالمة';

  @override
  String callFailedMedia(String media) {
    return 'فشلت $media';
  }

  @override
  String get callBusy => 'الطرف الآخر مشغول';

  @override
  String callDurationValue(String duration) {
    return 'مدة المكالمة $duration';
  }

  @override
  String get callNotConnected => 'غير متصل';

  @override
  String get callDialed => 'صادرة';

  @override
  String get callAnswered => 'تم الرد';

  @override
  String get callRejectedByPeer => 'رفض الطرف الآخر';

  @override
  String get callRejectedBySelf => 'مرفوض';

  @override
  String get callPeerDidNotAnswer => 'لم يرد الطرف الآخر';

  @override
  String get callMissedIncoming => 'مكالمة واردة فائتة';

  @override
  String get callPeerCancelled => 'ألغى الطرف الآخر';

  @override
  String get notificationNewMessageTitle => 'رسالة جديدة من StartLink';

  @override
  String get notificationOnlineServiceTitle => 'رسالة جديدة من خدمة العملاء';

  @override
  String get notificationNewMessageBody => 'تلقيت رسالة جديدة';

  @override
  String get notificationImagePreview => 'أرسل صورة';

  @override
  String get notificationVideoPreview => 'أرسل فيديو';

  @override
  String get notificationVoicePreview => 'أرسل رسالة صوتية';

  @override
  String get notificationFilePreview => 'أرسل ملفًا';

  @override
  String get notificationContactPreview => 'أرسل بطاقة جهة اتصال';

  @override
  String get notificationCallLogPreview => 'أرسل سجل مكالمة';

  @override
  String get notificationLocationPreview => 'شارك موقعًا';

  @override
  String get notificationLinkPreview => 'شارك رابطًا';

  @override
  String notificationMentionMe(String body) {
    return 'أشار إليك: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return 'أشار إليك $sender: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'أشار إلى الجميع: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return 'أشار $sender إلى الجميع: $body';
  }

  @override
  String get notificationSecurityTitle => 'تنبيه أمان الحساب';

  @override
  String get notificationSecurityBody =>
      'تغيّرت إعدادات أمان حسابك في StartLink. راجعها الآن.';

  @override
  String get notificationFriendAcceptedTitle => 'قُبل طلب الصداقة';

  @override
  String get notificationFriendRejectedTitle => 'رُفض طلب الصداقة';

  @override
  String get notificationFriendAcceptedBody => 'قبل الطرف الآخر طلب صداقتك';

  @override
  String get notificationFriendRejectedBody => 'رفض الطرف الآخر طلب صداقتك';

  @override
  String get notificationVideoCallTitle => 'دعوة إلى مكالمة فيديو';

  @override
  String get notificationAudioCallTitle => 'دعوة إلى مكالمة صوتية';

  @override
  String notificationVideoCallBody(String caller) {
    return 'دعاك $caller إلى مكالمة فيديو';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return 'دعاك $caller إلى مكالمة صوتية';
  }

  @override
  String get notificationMessageChannelName => 'الرسائل';

  @override
  String get notificationMessageChannelDescription =>
      'رسائل المحادثات وسجلات المكالمات وتنبيهات النظام';

  @override
  String get notificationCallChannelName => 'المكالمات';

  @override
  String get notificationCallChannelDescription =>
      'تنبيهات المكالمات الصوتية ومكالمات الفيديو';

  @override
  String get notificationSecurityChannelName => 'أمان الحساب';

  @override
  String get notificationSecurityChannelDescription =>
      'تنبيهات تسجيل الدخول وتغيير كلمة المرور ورقم الهاتف المحمول';

  @override
  String get notificationUnknownCaller => 'متصل غير معروف';

  @override
  String get pendingJoinRequestsTitle => 'طلبات جديدة';

  @override
  String get pendingJoinRequestsEmpty => 'لا توجد طلبات';

  @override
  String get pendingJoinRequestApprove => 'موافق';

  @override
  String get pendingJoinRequestReject => 'رفض';

  @override
  String get pendingJoinRequestApproveSuccess => 'تمت الموافقة';

  @override
  String get pendingJoinRequestRejectSuccess => 'مرفوض';

  @override
  String get pendingJoinRequestFailed => 'فشلت العملية، حاول مجددًا';

  @override
  String get myCustomersTitle => 'عملائي';

  @override
  String get myCustomersEmpty => 'لا يوجد عملاء';

  @override
  String get groupListTitle => 'المجموعات';

  @override
  String get groupListEmpty => 'لا توجد مجموعات';

  @override
  String get addFriendTitle => 'إضافة جهة اتصال';

  @override
  String get addFriendSearchHint =>
      'الهاتف / البريد الإلكتروني / معرّف StartLink';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'معرّف StartLink: $lppId';
  }

  @override
  String get addFriendButton => 'إضافة';

  @override
  String get addFriendCannotAddSelf => 'لا يمكنك إضافة نفسك';

  @override
  String get addFriendUnsupportedUser =>
      'لا يمكن إضافة هذا المستخدم. يمكنك مراسلته مباشرة.';

  @override
  String get addFriendMessageHint => 'أدخل رسالة';

  @override
  String get addFriendSendRequest => 'إرسال الطلب';

  @override
  String get joinCompanyTitle => 'الانضمام إلى مؤسسة';

  @override
  String get joinCompanyCodeHint => 'أدخل رمز المؤسسة';

  @override
  String get joinCompanySearchHint => 'ابحث باسم المؤسسة';

  @override
  String get joinCompanyApply => 'طلب الانضمام';

  @override
  String get joinCompanyApplySuccess => 'أُرسل الطلب';

  @override
  String get joinCompanyApplyFailed => 'تعذّر تقديم الطلب، حاول مجددًا';

  @override
  String get joinCompanyAutoApproved => 'تمت الموافقة تلقائيًا. أهلًا بك!';

  @override
  String get joinCompanyPending => 'أُرسل الطلب، في انتظار الموافقة';

  @override
  String get joinCompanyInviteCodeHint => 'أدخل رمز الدعوة';

  @override
  String get joinCompanyAcceptInvite => 'قبول الدعوة';

  @override
  String get joinCompanyNoResults => 'لم يُعثر على مؤسسات';

  @override
  String joinCompanyMemberCount(int count) {
    return 'الأعضاء: $count';
  }

  @override
  String get timezoneNameHawaii => 'هاواي';

  @override
  String get timezoneNameAlaska => 'ألاسكا';

  @override
  String get timezoneNamePacificTime => 'توقيت المحيط الهادئ';

  @override
  String get timezoneNameMountainTime => 'التوقيت الجبلي';

  @override
  String get timezoneNameCentralTime => 'التوقيت المركزي';

  @override
  String get timezoneNameEasternTime => 'التوقيت الشرقي';

  @override
  String get timezoneNameAtlanticTime => 'توقيت المحيط الأطلسي';

  @override
  String get timezoneNameBrasilia => 'برازيليا';

  @override
  String get timezoneNameAzores => 'الأزور';

  @override
  String get timezoneNameLondonDublin => 'لندن/دبلن';

  @override
  String get timezoneNameBerlinParisRome => 'برلين/باريس/روما';

  @override
  String get timezoneNameCairoHelsinki => 'القاهرة/هلسنكي';

  @override
  String get timezoneNameMoscowRiyadh => 'موسكو/الرياض';

  @override
  String get timezoneNameTehran => 'طهران';

  @override
  String get timezoneNameDubaiBaku => 'دبي/باكو';

  @override
  String get timezoneNameKabul => 'كابول';

  @override
  String get timezoneNameKarachiTashkent => 'كراتشي/طشقند';

  @override
  String get timezoneNameMumbaiNewDelhi => 'مومباي/نيودلهي';

  @override
  String get timezoneNameKathmandu => 'كاتماندو';

  @override
  String get timezoneNameDhakaAlmaty => 'دكا/ألماتي';

  @override
  String get timezoneNameYangon => 'يانغون';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'بانكوك/هانوي/جاكرتا';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'بكين/شنغهاي/هونغ كونغ/تايبيه';

  @override
  String get timezoneNameTokyoSeoul => 'طوكيو/سيول';

  @override
  String get timezoneNameAdelaide => 'أديلايد';

  @override
  String get timezoneNameSydneyMelbourne => 'سيدني/ملبورن';

  @override
  String get timezoneNameSolomonIslands => 'جزر سليمان';

  @override
  String get timezoneNameAucklandFiji => 'أوكلاند/فيجي';

  @override
  String get networkSmartSelectBestRoute => 'اختيار أفضل مسار بذكاء';

  @override
  String get networkTesting => 'جارٍ الاختبار...';

  @override
  String get networkTestingShort => 'جارٍ الاختبار';

  @override
  String networkLatencyMs(int ms) {
    return 'زمن الاستجابة $ms مللي ثانية';
  }

  @override
  String get networkConnectionMode => 'وضع الاتصال';

  @override
  String get networkDirectMode => 'الوضع المباشر';

  @override
  String get networkProxyMode => 'وضع الوكيل';

  @override
  String get networkDirectModeDesc => 'الاتصال بالخادم مباشرة';

  @override
  String get networkProxyModeDesc => 'الاتصال عبر خادم وكيل';

  @override
  String get networkDirectRoutes => 'المسارات المباشرة';

  @override
  String get networkProxyRoutes => 'مسارات الوكيل';

  @override
  String get networkTestAll => 'اختبار الكل';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'عقدة هونغ كونغ';

  @override
  String get networkSingaporeNode => 'عقدة سنغافورة';

  @override
  String get networkJapanNode => 'عقدة اليابان';

  @override
  String get networkUnitedStatesNode => 'عقدة الولايات المتحدة';

  @override
  String get networkHint =>
      'نصائح:\n• الوضع المباشر: أسرع ومناسب للاستخدام المحلي\n• وضع الوكيل: أكثر استقرارًا للتواصل عبر الحدود\n• انقر على أيقونة التحديث لاختبار زمن استجابة مسار واحد';

  @override
  String get teenModeTitle => 'وضع المراهقين';

  @override
  String get teenModeStatusOn => 'تشغيل';

  @override
  String get teenModeStatusOff => 'متوقف';

  @override
  String get teenModeStatusLoading => 'جارٍ التحميل';

  @override
  String get teenModeUnavailable => 'حالة وضع المراهقين غير متاحة مؤقتًا';

  @override
  String get teenModeInvalidResponse => 'أعاد وضع المراهقين استجابة غير صالحة';

  @override
  String get teenModeEnableDescription =>
      'ستحد قواعد المنصة من وقت الاستخدام وبعض الميزات.';

  @override
  String get teenModePasscode => 'رمز المرور';

  @override
  String get teenModeCurrentPasscode => 'رمز المرور الحالي';

  @override
  String get teenModeNewPasscode => 'رمز مرور جديد';

  @override
  String get teenModePasscodeHint => 'أدخل 4–6 أرقام';

  @override
  String get teenModeEnable => 'تفعيل وضع المراهقين';

  @override
  String get teenModeDisable => 'إيقاف وضع المراهقين';

  @override
  String get teenModeChangePasscode => 'تغيير رمز المرور';

  @override
  String get teenModeSource => 'تم التفعيل بواسطة';

  @override
  String get teenModeDailyUsage => 'المستخدم اليوم';

  @override
  String get teenModeRemaining => 'الوقت المتبقي';

  @override
  String get teenModeMinutesUnit => 'دقيقة';

  @override
  String get teenModeUnlimited => 'غير محدود';

  @override
  String get teenModeRequestExtension => 'طلب وقت إضافي';

  @override
  String get teenModeExtensionSubmitted => 'أُرسل طلب الوقت إلى ولي الأمر';

  @override
  String get teenModeTimeLimitReached => 'وصلت إلى حد الاستخدام اليومي';

  @override
  String get teenModeCurfewActive => 'هذه فترة استخدام مقيّد';

  @override
  String get teenModeReliefHint =>
      'لا يزال بإمكانك عرض السجل والتواصل مع الدعم الرسمي والإبلاغ عن المشكلات.';

  @override
  String get teenModeRestrictedNotice =>
      'يمنع وضع المراهقين إرسال الرسائل حاليًا';

  @override
  String get teenModeActionBlocked => 'يمنع وضع المراهقين هذا الإجراء حاليًا';

  @override
  String get teenModeMyRequests => 'طلباتي';

  @override
  String get guardianCenterTitle => 'مركز ولي الأمر';

  @override
  String get guardianRelationships => 'علاقات الوصاية';

  @override
  String get guardianMinors => 'الأطفال الذين أشرف عليهم';

  @override
  String get guardianApprovals => 'موافقات معلقة';

  @override
  String get guardianBind => 'أدخل رمز الربط';

  @override
  String get guardianCreateMinorCode => 'أنا طفل — إنشاء رمز';

  @override
  String get guardianCreateGuardianCode => 'أنا ولي أمر — إنشاء رمز';

  @override
  String get guardianRelation => 'العلاقة';

  @override
  String get guardianPrimary => 'ولي الأمر الأساسي';

  @override
  String get guardianCode => 'رمز ربط من 6 أرقام';

  @override
  String get guardianCodeHint => 'أدخل الرمز الذي يقدّمه الطرف الآخر';

  @override
  String get guardianCodeCreated => 'أُنشئ الرمز. شاركه قبل انتهاء صلاحيته.';

  @override
  String get guardianEmpty => 'لا توجد علاقات وصاية';

  @override
  String get guardianNoMinors => 'لا يوجد أطفال تحت الإشراف';

  @override
  String get guardianUnbind => 'إزالة العلاقة';

  @override
  String get guardianExtend => 'إضافة وقت للطفل';

  @override
  String get guardianPolicyTitle => 'قواعد الاستخدام';

  @override
  String get guardianPolicyLocked => 'مقفل بواسطة المنصة';

  @override
  String get approvalEmpty => 'لا توجد طلبات';

  @override
  String get approvalApprove => 'موافق';

  @override
  String get approvalReject => 'رفض';

  @override
  String get approvalPending => 'معلق';

  @override
  String get approvalApproved => 'تمت الموافقة';

  @override
  String get approvalRejected => 'مرفوض';

  @override
  String get approvalExpired => 'منتهي';

  @override
  String get approvalCancelled => 'ملغاة';

  @override
  String get approvalReplayFailed => 'فشل الإجراء الأصلي. يُرجى تكراره.';

  @override
  String get requestCancelled => 'أُلغي الطلب';

  @override
  String get kycTitle => 'التحقق من الهوية';

  @override
  String get kycNotRequired => 'التحقق من الهوية غير مطلوب';

  @override
  String get kycVerified => 'تم التحقق من الهوية';

  @override
  String get kycDeclared => 'أُرسلت معلومات الهوية';

  @override
  String get kycPending => 'قيد المراجعة';

  @override
  String get kycRejected => 'رُفضت المراجعة';

  @override
  String get kycNone => 'لم تُرسل معلومات هوية';

  @override
  String get kycRealName => 'الاسم الكامل';

  @override
  String get kycIdNumber => 'رقم الهوية';

  @override
  String get kycIdType => 'نوع الوثيقة';

  @override
  String get kycApplicability =>
      'أدخل بياناتك الحقيقية للوثيقة المختارة. تظهر الأنواع المقبولة في القائمة.';

  @override
  String get kycCamera => 'التقاط صورة';

  @override
  String get kycGallery => 'اختر من الألبوم';

  @override
  String get kycPhotoLimit => 'الحد الأقصى لكل صورة';

  @override
  String get kycSelectPhoto => 'اختر صورة';

  @override
  String get kycPhotoSelected => 'محدد';

  @override
  String get kycViewPhoto => 'انقر لعرض الصورة';

  @override
  String get kycReplacePhoto => 'اختيار صورة أخرى';

  @override
  String get kycDisclosure =>
      'نستخدم اسمك ورقم وثيقتك وصورها لمراجعة هويتك. من دونها لا يمكنك تقديم الطلب، وقد لا تتاح بعض الميزات المقيّدة.';

  @override
  String get kycConsent => 'أوافق بشكل منفصل على معالجة معلومات الهوية هذه';

  @override
  String get kycConsentRequired => 'يُرجى منح موافقة منفصلة قبل الإرسال';

  @override
  String get kycResubmitTitle => 'إعادة إرسال معلومات الهوية';

  @override
  String get kycResubmitWarning =>
      'ستحل إعادة الإرسال محل طلبك المعلق. هل تريد المتابعة؟';

  @override
  String get kycSubmitting => 'جارٍ الإرسال';

  @override
  String get kycSubmitFailed => 'فشل الإرسال. حاول مجددًا.';

  @override
  String get kycSubmitUnavailable => 'لا يمكن إرسال معلومات الهوية الآن';

  @override
  String get kycResubmitNotAllowed =>
      'إعادة الإرسال غير متاحة بعد الرفض. تواصل مع الدعم عند الحاجة.';

  @override
  String get kycDailyLimit => 'وصلت إلى حد الإرسال اليومي. حاول غدًا.';

  @override
  String get kycTypeUnavailable => 'لا توجد أنواع وثائق متاحة. حاول لاحقًا.';

  @override
  String get kycNameInvalid => 'يجب أن يتكون الاسم القانوني من 2–64 حرفًا';

  @override
  String get kycNumberRequired => 'أدخل رقم وثيقتك';

  @override
  String get kycFrontRequired => 'ارفع الوجه الأمامي لوثيقتك';

  @override
  String get kycBackRequired => 'ارفع الوجه الخلفي لوثيقتك';

  @override
  String get kycPhotoTooLarge => 'تتجاوز الصورة حد الحجم. اضغطها وحاول مجددًا.';

  @override
  String get kycAccountChanged =>
      'تغيّر الحساب أو المساحة. أعد فتح هذه الصفحة.';

  @override
  String get kycPhotoInvalid => 'اختر صورة صالحة';

  @override
  String get kycPortraitSide => 'الوجه الذي يحتوي على الصورة الشخصية';

  @override
  String get kycEmblemSide => 'الوجه الذي يحتوي على الشعار';

  @override
  String get kycPassportDataPage => 'صفحة بيانات جواز السفر';

  @override
  String get kycPassportOtherPage =>
      'صفحة التأشيرة أو صفحة فارغة من جواز السفر';

  @override
  String get kycFront => 'الوجه الأمامي للهوية الوطنية';

  @override
  String get kycBack => 'الوجه الخلفي للهوية الوطنية';

  @override
  String get kycRequired => 'يجب التحقق من الهوية قبل إنشاء مجموعة';

  @override
  String get kycGoVerify => 'التحقق الآن';

  @override
  String get kycStatusUnknown => 'حالة الهوية غير متاحة. حدّث لاحقًا.';

  @override
  String get kycSuperseded =>
      'حل إرسال أحدث محل هذا الإرسال. تحقق من حالة هويتك الأحدث.';

  @override
  String get kycMediaNotFound =>
      'صورة الوثيقة غير متاحة في هذه المساحة. اخترها مجددًا قبل الإرسال.';

  @override
  String get customerServiceBroadcastDirectTitle => 'إرسال جماعي للعملاء';

  @override
  String get officialAccountBadge => 'رسمي';

  @override
  String get officialAccountOpenConversation => 'فتح المحادثة';

  @override
  String get officialAccountJoinHint =>
      'بإضافة هذا الحساب تنضم إلى المؤسسة بصفتك عميلًا. لا حاجة إلى الموافقة على الصداقة.';

  @override
  String get officialAccountJoinDisabled =>
      'هذه المؤسسة لا تقبل عملاء جددًا. يُرجى التواصل مع الدعم.';

  @override
  String get officialAccountRemoved =>
      'أُزلت من هذه المؤسسة. اطلب منها دعوتك مجددًا.';

  @override
  String get officialAccountBanned => 'عُطّل حسابك في هذه المؤسسة.';

  @override
  String get officialAccountUnavailable => 'هذا الحساب الرسمي غير متاح حاليًا.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'لا يُسمح بالانضمام إلى مؤسسة في الوضع الحالي.';

  @override
  String get officialAccountPlatformRequired =>
      'استخدم حساب المنصة لإضافة هذا الحساب الرسمي.';

  @override
  String get officialAccountOpenFailed => 'تعذّر فتح المحادثة. حاول مجددًا.';

  @override
  String get officialAccountAccountChanged =>
      'تغيّر الحساب أو المساحة. أعد الفتح.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'دليل المؤسسة غير محدّث. حاول بعد قليل.';

  @override
  String get officialAccountInboxSyncFailed =>
      'فشلت مزامنة الحساب الرسمي. لا يزال المحتوى المحلي متاحًا.';

  @override
  String get officialAccountInboxSyncing => 'جارٍ مزامنة رسائل الحساب الرسمي';

  @override
  String get diagnosticsTitle => 'التشخيص';

  @override
  String get diagnosticsExplanation =>
      'أُخفيت البيانات الحساسة في السجلات، وهي تحتوي على معلومات العمليات والأخطاء لهذا الحساب والمساحة، بالإضافة إلى أحداث بدء التشغيل العامة. ولا تشمل محتوى المحادثات أو بيانات الاعتماد.';

  @override
  String get diagnosticsHour => 'آخر ساعة';

  @override
  String get diagnosticsDay => 'آخر 24 ساعة';

  @override
  String get diagnosticsWeek => '7 أيام';

  @override
  String diagnosticsEventCount(int count) {
    return 'الأحداث المتاحة: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'تُحفظ السجلات على هذا الجهاز وتبقى متاحة بعد إعادة التشغيل.';

  @override
  String get diagnosticsNotPersistent =>
      'لم تُحفظ بعض السجلات. حدّث لإعادة المحاولة.';

  @override
  String get diagnosticsExport => 'تصدير ومشاركة';

  @override
  String get diagnosticsRefresh => 'تحديث';

  @override
  String get diagnosticsClear => 'مسح سجلات هذه المساحة';

  @override
  String get diagnosticsClearConfirm =>
      'هل تريد مسح سجلات التشخيص لهذه المساحة؟ سيُحتفظ بسجل المحادثات.';

  @override
  String get diagnosticsShared =>
      'اكتملت مشاركة النظام. تحقق من الملف في التطبيق المستلِم.';

  @override
  String get diagnosticsCancelled => 'أُلغيت المشاركة. يمكنك التصدير مجددًا.';

  @override
  String get diagnosticsUnconfirmed =>
      'تعذّر تأكيد المشاركة. تحقق من التطبيق المستلِم.';

  @override
  String get diagnosticsFailed => 'فشلت العملية. حاول مجددًا.';
}
