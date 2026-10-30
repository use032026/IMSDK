import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_si.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('zh'),
    Locale('zh', 'TW'),
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('vi'),
    Locale('ar'),
    Locale('bg'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('es'),
    Locale('fi'),
    Locale('fil'),
    Locale('fr'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'PT'),
    Locale('ro'),
    Locale('ru'),
    Locale('si'),
    Locale('sk'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk')
  ];

  /// Workbench navigation label
  ///
  /// In zh, this message translates to:
  /// **'工作台'**
  String get navWorkbench;

  /// Overflow count shown on navigation badges
  ///
  /// In zh, this message translates to:
  /// **'99+'**
  String get navBadgeOverflow;

  /// Account runtime load failure
  ///
  /// In zh, this message translates to:
  /// **'账号数据加载失败'**
  String get appRuntimeLoadFailed;

  /// Startup failure title
  ///
  /// In zh, this message translates to:
  /// **'启动失败'**
  String get startupFailureTitle;

  /// Startup failure guidance
  ///
  /// In zh, this message translates to:
  /// **'请检查网络后重试'**
  String get startupFailureMessage;

  /// Privacy consent title
  ///
  /// In zh, this message translates to:
  /// **'服务协议与隐私政策'**
  String get privacyConsentTitle;

  /// Android pre-consent data processing disclosure
  ///
  /// In zh, this message translates to:
  /// **'欢迎使用{brand}。为向您提供账号登录、即时通讯、企业协作、在线客服、消息提醒和安全保障等服务，我们需要按照用户协议和隐私政策处理必要信息。\n\n在您点击同意前，我们不会读取剪切板信息，不会初始化极光及手机厂商推送 SDK，也不会通过这些 SDK 获取 Android ID、OAID、安装应用列表、MAC 地址等信息。若您暂不同意，我们会保存该选择；您仍可继续阅读协议，并可稍后重新选择。\n\n您同意后，为完成消息、客服和来电提醒，极光 JPush/JCore 及手机厂商推送服务可能处理设备型号、Android 版本、应用包名与版本、网络类型、IP 地址、Android ID、OAID、推送 Registration ID、厂商推送 Token 以及通知送达和点击信息。我们已关闭智能推送、安装应用列表、MAC、IMEI、IMSI、Wi-Fi 列表、自动唤醒和关联启动等非必要能力。\n\n剪切板仅在您主动使用复制或粘贴功能时调用；相机、麦克风和通知等系统权限仅在您主动使用相关功能时申请。拒绝单项权限只影响对应功能。请阅读下方完整协议后，自主选择是否同意。'**
  String privacyConsentBodyAndroid(String brand);

  /// iOS pre-consent data processing disclosure
  ///
  /// In zh, this message translates to:
  /// **'欢迎使用{brand}。为向您提供账号登录、即时通讯、企业协作、在线客服、消息提醒和安全保障等服务，我们需要按照用户协议和隐私政策处理必要信息。\n\n在您点击同意前，我们不会读取剪切板信息，不会初始化极光 JPush/JCore 或注册 Apple 推送通知服务（APNs），也不会获取极光 Registration ID、APNs 设备令牌等推送标识。若您暂不同意，我们会保存该选择；您仍可继续阅读协议，并可稍后重新选择。\n\n您同意后，为完成消息、客服和来电提醒，我们可能处理 iPhone 型号、iOS 版本、应用包名与版本、网络类型、IP 地址、IDFV、极光 Registration ID、APNs 设备令牌以及通知送达和点击信息。极光 JPush/JCore 用于连接推送服务；Apple APNs 处理 App 标识、设备令牌和通知负载以完成系统推送。当前 iOS 版不接入广告服务，不获取 IDFA。\n\n剪切板仅在您主动使用复制或粘贴功能时调用；相机、麦克风和通知等系统权限仅在您主动使用相关功能时申请。拒绝单项权限只影响对应功能。请阅读下方完整协议后，自主选择是否同意。'**
  String privacyConsentBodyIos(String brand);

  /// Terms link
  ///
  /// In zh, this message translates to:
  /// **'《用户协议》'**
  String get privacyConsentTermsLink;

  /// Terms and privacy conjunction
  ///
  /// In zh, this message translates to:
  /// **'和'**
  String get privacyConsentConjunction;

  /// Privacy policy link
  ///
  /// In zh, this message translates to:
  /// **'《隐私政策》'**
  String get privacyConsentPrivacyLink;

  /// Decline privacy consent
  ///
  /// In zh, this message translates to:
  /// **'不同意'**
  String get privacyConsentDecline;

  /// Android notice shown before exiting after privacy consent is declined
  ///
  /// In zh, this message translates to:
  /// **'您未同意服务协议和隐私政策，应用即将退出'**
  String get privacyConsentDeclinedExit;

  /// Accept privacy consent
  ///
  /// In zh, this message translates to:
  /// **'同意'**
  String get privacyConsentAccept;

  /// Authorized runtime startup failure
  ///
  /// In zh, this message translates to:
  /// **'启动失败，请检查网络后重试'**
  String get privacyConsentRuntimeFailure;

  /// Consent choice persistence failure
  ///
  /// In zh, this message translates to:
  /// **'未能保存选择，请重试'**
  String get privacyConsentSaveFailure;

  /// Required update title
  ///
  /// In zh, this message translates to:
  /// **'必须更新后继续使用'**
  String get appUpdateRequiredTitle;

  /// Optional update title
  ///
  /// In zh, this message translates to:
  /// **'发现新版本'**
  String get appUpdateOptionalTitle;

  /// Available app version
  ///
  /// In zh, this message translates to:
  /// **'{brand} {version} 已可更新'**
  String appUpdateVersionAvailable(String brand, String version);

  /// Dismiss optional update
  ///
  /// In zh, this message translates to:
  /// **'稍后'**
  String get appUpdateLater;

  /// Start app update
  ///
  /// In zh, this message translates to:
  /// **'立即更新'**
  String get appUpdateNow;

  /// App update processing
  ///
  /// In zh, this message translates to:
  /// **'处理中...'**
  String get appUpdateProcessing;

  /// Invalid update URL
  ///
  /// In zh, this message translates to:
  /// **'更新地址无效，请稍后重试'**
  String get appUpdateInvalidUrl;

  /// Open update URL failure
  ///
  /// In zh, this message translates to:
  /// **'无法打开更新链接，请稍后重试'**
  String get appUpdateOpenUrlFailed;

  /// Interrupted update download
  ///
  /// In zh, this message translates to:
  /// **'下载中断，请检查网络后重试'**
  String get appUpdateDownloadInterrupted;

  /// Update package verification failure
  ///
  /// In zh, this message translates to:
  /// **'安装包校验失败，请重新下载'**
  String get appUpdatePackageVerificationFailed;

  /// Install permission denied
  ///
  /// In zh, this message translates to:
  /// **'请在系统设置中允许{brand}安装更新'**
  String appUpdatePermissionDenied(String brand);

  /// Open system installer failure
  ///
  /// In zh, this message translates to:
  /// **'无法打开系统安装器，请检查安装权限'**
  String get appUpdateOpenInstallerFailed;

  /// Generic update failure
  ///
  /// In zh, this message translates to:
  /// **'更新失败，请检查网络后重试'**
  String get appUpdateGenericFailure;

  /// Update package unavailable
  ///
  /// In zh, this message translates to:
  /// **'新版本暂不可下载，请稍后再试'**
  String get appUpdateUnavailable;

  /// Update check failure
  ///
  /// In zh, this message translates to:
  /// **'检查更新失败，请稍后重试'**
  String get appUpdateCheckFailed;

  /// Checking for updates
  ///
  /// In zh, this message translates to:
  /// **'检查中'**
  String get appUpdateChecking;

  /// Confirm button
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get commonConfirm;

  /// Cancel button
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get commonCancel;

  /// Save button
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get commonSave;

  /// Edit button
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get commonEdit;

  /// Delete button
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get commonDelete;

  /// Search
  ///
  /// In zh, this message translates to:
  /// **'搜索'**
  String get commonSearch;

  /// Loading
  ///
  /// In zh, this message translates to:
  /// **'加载中，请稍候'**
  String get commonLoading;

  /// Load failed
  ///
  /// In zh, this message translates to:
  /// **'加载失败'**
  String get commonLoadFailed;

  /// Retry
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get commonRetry;

  /// Empty state
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get commonEmpty;

  /// Copy
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get commonCopy;

  /// Forward
  ///
  /// In zh, this message translates to:
  /// **'转发'**
  String get commonForward;

  /// Favorite
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get commonFavorite;

  /// Close
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get commonClose;

  /// Send
  ///
  /// In zh, this message translates to:
  /// **'发送'**
  String get commonSend;

  /// Done
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get commonDone;

  /// More
  ///
  /// In zh, this message translates to:
  /// **'更多'**
  String get commonMore;

  /// Settings
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get commonSettings;

  /// Copied
  ///
  /// In zh, this message translates to:
  /// **'已复制'**
  String get commonCopied;

  /// Unknown
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get commonUnknown;

  /// Not set
  ///
  /// In zh, this message translates to:
  /// **'未设置'**
  String get commonNotSet;

  /// Unbound
  ///
  /// In zh, this message translates to:
  /// **'未绑定'**
  String get commonUnbound;

  /// View all
  ///
  /// In zh, this message translates to:
  /// **'查看全部'**
  String get commonViewAll;

  /// Submit
  ///
  /// In zh, this message translates to:
  /// **'提交'**
  String get commonSubmit;

  /// Add
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get commonAdd;

  /// Remove
  ///
  /// In zh, this message translates to:
  /// **'移除'**
  String get commonRemove;

  /// Create
  ///
  /// In zh, this message translates to:
  /// **'创建'**
  String get commonCreate;

  /// Update
  ///
  /// In zh, this message translates to:
  /// **'更新'**
  String get commonUpdate;

  /// Upload
  ///
  /// In zh, this message translates to:
  /// **'上传'**
  String get commonUpload;

  /// Share
  ///
  /// In zh, this message translates to:
  /// **'分享'**
  String get commonShare;

  /// Block
  ///
  /// In zh, this message translates to:
  /// **'拉黑'**
  String get commonBlock;

  /// Unblock
  ///
  /// In zh, this message translates to:
  /// **'取消拉黑'**
  String get commonUnblock;

  /// Mute
  ///
  /// In zh, this message translates to:
  /// **'免打扰'**
  String get commonMute;

  /// Unmute
  ///
  /// In zh, this message translates to:
  /// **'取消免打扰'**
  String get commonUnmute;

  /// Pin
  ///
  /// In zh, this message translates to:
  /// **'置顶'**
  String get commonPin;

  /// Unpin
  ///
  /// In zh, this message translates to:
  /// **'取消置顶'**
  String get commonUnpin;

  /// Mark as read
  ///
  /// In zh, this message translates to:
  /// **'标为已读'**
  String get commonMarkRead;

  /// Mark as unread
  ///
  /// In zh, this message translates to:
  /// **'标为未读'**
  String get commonMarkUnread;

  /// Online
  ///
  /// In zh, this message translates to:
  /// **'在线'**
  String get commonOnline;

  /// Offline
  ///
  /// In zh, this message translates to:
  /// **'离线'**
  String get commonOffline;

  /// Operation failed
  ///
  /// In zh, this message translates to:
  /// **'操作失败，请重试'**
  String get commonOperationFailed;

  /// Network error
  ///
  /// In zh, this message translates to:
  /// **'网络错误，请检查网络连接'**
  String get commonNetworkError;

  /// Bottom nav: Messages
  ///
  /// In zh, this message translates to:
  /// **'消息'**
  String get navMessages;

  /// Bottom nav: Contacts
  ///
  /// In zh, this message translates to:
  /// **'通讯录'**
  String get navContacts;

  /// Bottom nav: Me
  ///
  /// In zh, this message translates to:
  /// **'我'**
  String get navMe;

  /// Login page title
  ///
  /// In zh, this message translates to:
  /// **'登录微界'**
  String get authLoginTitle;

  /// Login tab: mobile
  ///
  /// In zh, this message translates to:
  /// **'手机号'**
  String get authTabMobile;

  /// Login tab: email
  ///
  /// In zh, this message translates to:
  /// **'邮箱'**
  String get authTabEmail;

  /// Login tab: lpp id
  ///
  /// In zh, this message translates to:
  /// **'微界号'**
  String get authTabLoginName;

  /// Mobile hint
  ///
  /// In zh, this message translates to:
  /// **'请输入手机号'**
  String get authHintMobile;

  /// Email hint
  ///
  /// In zh, this message translates to:
  /// **'请输入邮箱'**
  String get authHintEmail;

  /// Password hint
  ///
  /// In zh, this message translates to:
  /// **'请输入密码'**
  String get authHintPassword;

  /// Code hint
  ///
  /// In zh, this message translates to:
  /// **'请输入验证码'**
  String get authHintCode;

  /// Login name hint
  ///
  /// In zh, this message translates to:
  /// **'请输入微界号（lpp_xxxxxxxx）'**
  String get authHintLoginName;

  /// Login button
  ///
  /// In zh, this message translates to:
  /// **'登录'**
  String get authLoginButton;

  /// Get verification code
  ///
  /// In zh, this message translates to:
  /// **'获取验证码'**
  String get authGetCode;

  /// Resend code countdown
  ///
  /// In zh, this message translates to:
  /// **'{seconds}s 后重发'**
  String authResendCode(int seconds);

  /// Use password login
  ///
  /// In zh, this message translates to:
  /// **'使用密码登录'**
  String get authUsePassword;

  /// Use code login
  ///
  /// In zh, this message translates to:
  /// **'使用验证码登录'**
  String get authUseCode;

  /// Agreement prefix
  ///
  /// In zh, this message translates to:
  /// **'我已阅读并同意'**
  String get authAgreementPrefix;

  /// Agreement and
  ///
  /// In zh, this message translates to:
  /// **'和'**
  String get authAgreementAnd;

  /// Terms link
  ///
  /// In zh, this message translates to:
  /// **'《用户协议》'**
  String get authTermsLink;

  /// Privacy link
  ///
  /// In zh, this message translates to:
  /// **'《隐私政策》'**
  String get authPrivacyLink;

  /// Captcha title
  ///
  /// In zh, this message translates to:
  /// **'安全验证'**
  String get authCaptchaTitle;

  /// Captcha hint
  ///
  /// In zh, this message translates to:
  /// **'请输入答案'**
  String get authCaptchaHint;

  /// Captcha failed
  ///
  /// In zh, this message translates to:
  /// **'获取验证码失败，请重试'**
  String get authCaptchaFailed;

  /// Empty code error
  ///
  /// In zh, this message translates to:
  /// **'请输入验证码'**
  String get authErrorEmptyCode;

  /// Empty password error
  ///
  /// In zh, this message translates to:
  /// **'请输入密码'**
  String get authErrorEmptyPassword;

  /// Empty login name error
  ///
  /// In zh, this message translates to:
  /// **'请输入微界号'**
  String get authErrorEmptyLoginName;

  /// Wrong credentials
  ///
  /// In zh, this message translates to:
  /// **'账号或密码错误'**
  String get authErrorWrongCredentials;

  /// Deactivating title
  ///
  /// In zh, this message translates to:
  /// **'账号注销中'**
  String get authDeactivatingTitle;

  /// Deactivating content
  ///
  /// In zh, this message translates to:
  /// **'您的账号正处于注销冷静期（7天内）。\n\n如需撤销注销，请点击「撤销注销」；否则点击「继续使用」进入应用。'**
  String get authDeactivatingContent;

  /// Continue use
  ///
  /// In zh, this message translates to:
  /// **'继续使用'**
  String get authContinueUse;

  /// Cancel deactivation
  ///
  /// In zh, this message translates to:
  /// **'撤销注销'**
  String get authCancelDeactivation;

  /// Deactivation cancelled
  ///
  /// In zh, this message translates to:
  /// **'注销已撤销，账号恢复正常'**
  String get authDeactivationCancelled;

  /// Deactivation cancel failed
  ///
  /// In zh, this message translates to:
  /// **'撤销失败，请重试'**
  String get authDeactivationCancelFailed;

  /// Logout
  ///
  /// In zh, this message translates to:
  /// **'退出登录'**
  String get authLogout;

  /// Logout confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要退出登录吗？'**
  String get authLogoutConfirm;

  /// Sending code
  ///
  /// In zh, this message translates to:
  /// **'发送中...'**
  String get authSendingCode;

  /// Code sent
  ///
  /// In zh, this message translates to:
  /// **'验证码已发送'**
  String get authCodeSent;

  /// Login failed
  ///
  /// In zh, this message translates to:
  /// **'登录失败，请重试'**
  String get authLoginFailed;

  /// Register failed
  ///
  /// In zh, this message translates to:
  /// **'注册失败，请重试'**
  String get authRegisterFailed;

  /// Enterprise code
  ///
  /// In zh, this message translates to:
  /// **'企业码'**
  String get authEnterpriseCode;

  /// Enterprise code hint
  ///
  /// In zh, this message translates to:
  /// **'请输入企业码'**
  String get authEnterpriseCodeHint;

  /// Pending approval
  ///
  /// In zh, this message translates to:
  /// **'注册成功，加入企业申请已提交，等待审批'**
  String get authPendingApproval;

  /// Login registration prompt
  ///
  /// In zh, this message translates to:
  /// **'没有账号？'**
  String get authNoAccount;

  /// Open registration
  ///
  /// In zh, this message translates to:
  /// **'立即注册'**
  String get authRegisterNow;

  /// Country picker title
  ///
  /// In zh, this message translates to:
  /// **'选择国家/地区'**
  String get authCountryPickerTitle;

  /// Country picker search hint
  ///
  /// In zh, this message translates to:
  /// **'搜索国家/地区'**
  String get authCountrySearchHint;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'中国大陆'**
  String get authCountryChinaMainland;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'中国香港'**
  String get authCountryHongKong;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'中国澳门'**
  String get authCountryMacau;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'中国台湾'**
  String get authCountryTaiwan;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'美国'**
  String get authCountryUnitedStates;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'英国'**
  String get authCountryUnitedKingdom;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'日本'**
  String get authCountryJapan;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'韩国'**
  String get authCountrySouthKorea;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'新加坡'**
  String get authCountrySingapore;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'马来西亚'**
  String get authCountryMalaysia;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'澳大利亚'**
  String get authCountryAustralia;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'加拿大'**
  String get authCountryCanada;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'德国'**
  String get authCountryGermany;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'法国'**
  String get authCountryFrance;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'印度'**
  String get authCountryIndia;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'泰国'**
  String get authCountryThailand;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'越南'**
  String get authCountryVietnam;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'印度尼西亚'**
  String get authCountryIndonesia;

  /// Country name
  ///
  /// In zh, this message translates to:
  /// **'菲律宾'**
  String get authCountryPhilippines;

  /// Developer quick login title
  ///
  /// In zh, this message translates to:
  /// **'快速登录'**
  String get authQuickLoginTitle;

  /// Developer quick login summary
  ///
  /// In zh, this message translates to:
  /// **'{count} 个快捷登录账号；凭证由宿主提供。'**
  String authQuickLoginSummary(int count);

  /// Quick login progress
  ///
  /// In zh, this message translates to:
  /// **'正在登录，请稍候'**
  String get authQuickLoginProgress;

  /// Owner role
  ///
  /// In zh, this message translates to:
  /// **'所有者'**
  String get authRoleOwner;

  /// Administrator role
  ///
  /// In zh, this message translates to:
  /// **'管理员'**
  String get authRoleAdministrator;

  /// Customer service role
  ///
  /// In zh, this message translates to:
  /// **'客服'**
  String get authRoleCustomerService;

  /// Technical support role
  ///
  /// In zh, this message translates to:
  /// **'技术支持'**
  String get authRoleTechnicalSupport;

  /// Employee role
  ///
  /// In zh, this message translates to:
  /// **'普通员工'**
  String get authRoleEmployee;

  /// Member role
  ///
  /// In zh, this message translates to:
  /// **'成员'**
  String get authRoleMember;

  /// Enterprise customer account role
  ///
  /// In zh, this message translates to:
  /// **'企业空户'**
  String get authRoleEnterpriseCustomer;

  /// Unavailable account prefix
  ///
  /// In zh, this message translates to:
  /// **'不可用 · '**
  String get authUnavailablePrefix;

  /// No assigned service staff
  ///
  /// In zh, this message translates to:
  /// **'未分配客服'**
  String get authUnassignedService;

  /// Assigned service staff
  ///
  /// In zh, this message translates to:
  /// **'归属{staff}'**
  String authAssignedService(String staff);

  /// Quick account customer identity
  ///
  /// In zh, this message translates to:
  /// **'客户 · {assignment}'**
  String authCustomerIdentity(String assignment);

  /// Quick account employee identity
  ///
  /// In zh, this message translates to:
  /// **'员工 · {tenant}'**
  String authEmployeeIdentity(String tenant);

  /// User count
  ///
  /// In zh, this message translates to:
  /// **'{count} 个用户'**
  String authUserCount(int count);

  /// Phone metadata label
  ///
  /// In zh, this message translates to:
  /// **'电话'**
  String get authMetaPhone;

  /// Identity metadata label
  ///
  /// In zh, this message translates to:
  /// **'身份'**
  String get authMetaIdentity;

  /// Registration page title
  ///
  /// In zh, this message translates to:
  /// **'注册'**
  String get authRegisterTitle;

  /// Nickname label
  ///
  /// In zh, this message translates to:
  /// **'昵称'**
  String get authNickname;

  /// Nickname hint
  ///
  /// In zh, this message translates to:
  /// **'设置昵称'**
  String get authNicknameHint;

  /// Password label
  ///
  /// In zh, this message translates to:
  /// **'密码'**
  String get authPassword;

  /// Password setup hint
  ///
  /// In zh, this message translates to:
  /// **'设置密码（至少6位）'**
  String get authPasswordSetHint;

  /// Confirm password label
  ///
  /// In zh, this message translates to:
  /// **'确认密码'**
  String get authConfirmPassword;

  /// Confirm password hint
  ///
  /// In zh, this message translates to:
  /// **'再次输入密码'**
  String get authConfirmPasswordHint;

  /// Verification code label
  ///
  /// In zh, this message translates to:
  /// **'验证码'**
  String get authVerificationCode;

  /// Register and login button
  ///
  /// In zh, this message translates to:
  /// **'注册并登录'**
  String get authRegisterAndLogin;

  /// Existing account prompt
  ///
  /// In zh, this message translates to:
  /// **'已有账户？'**
  String get authHaveAccount;

  /// Return to login
  ///
  /// In zh, this message translates to:
  /// **'去登录'**
  String get authGoLogin;

  /// Email verification unavailable
  ///
  /// In zh, this message translates to:
  /// **'邮箱验证码服务暂不可用，请改用手机号注册'**
  String get authEmailVerificationUnavailable;

  /// SMS verification unavailable
  ///
  /// In zh, this message translates to:
  /// **'短信验证码服务暂不可用，请改用邮箱注册'**
  String get authSmsVerificationUnavailable;

  /// Verification send failed
  ///
  /// In zh, this message translates to:
  /// **'发送失败，请重试'**
  String get authSendFailed;

  /// Empty nickname error
  ///
  /// In zh, this message translates to:
  /// **'请输入昵称'**
  String get authErrorEmptyNickname;

  /// Invalid mobile error
  ///
  /// In zh, this message translates to:
  /// **'手机号格式不正确'**
  String get authErrorInvalidMobile;

  /// Invalid email error
  ///
  /// In zh, this message translates to:
  /// **'邮箱格式不正确'**
  String get authErrorInvalidEmail;

  /// Short password error
  ///
  /// In zh, this message translates to:
  /// **'密码至少6位'**
  String get authErrorPasswordTooShort;

  /// Password mismatch error
  ///
  /// In zh, this message translates to:
  /// **'两次密码不一致'**
  String get authErrorPasswordMismatch;

  /// Verification required error
  ///
  /// In zh, this message translates to:
  /// **'请先获取并填写验证码'**
  String get authErrorVerificationRequired;

  /// Registration error title
  ///
  /// In zh, this message translates to:
  /// **'注册失败'**
  String get authRegisterErrorTitle;

  /// Dismiss registration error
  ///
  /// In zh, this message translates to:
  /// **'知道了'**
  String get authGotIt;

  /// Tenant or invitation code hint
  ///
  /// In zh, this message translates to:
  /// **'请输入邀请码'**
  String get authJoinCredentialHint;

  /// Tenant code not found
  ///
  /// In zh, this message translates to:
  /// **'未找到企业「{code}」，请确认企业码是否正确'**
  String authTenantNotFound(String code);

  /// Tenant search failed
  ///
  /// In zh, this message translates to:
  /// **'搜索失败，请重试'**
  String get authTenantSearchFailed;

  /// Invitation invalid
  ///
  /// In zh, this message translates to:
  /// **'邀请码无效，请确认后重试'**
  String get authInvitationInvalid;

  /// Collapse join section
  ///
  /// In zh, this message translates to:
  /// **'收起加入信息'**
  String get authCollapseJoin;

  /// Expand optional join section
  ///
  /// In zh, this message translates to:
  /// **'加入企业？输入邀请码（可选）'**
  String get authExpandJoin;

  /// Invitation preview success
  ///
  /// In zh, this message translates to:
  /// **'邀请码有效：{name}'**
  String authInvitationValid(String name);

  /// Tenant preview success
  ///
  /// In zh, this message translates to:
  /// **'找到企业：{name}'**
  String authTenantFound(String name);

  /// Join credential not found
  ///
  /// In zh, this message translates to:
  /// **'邀请码无效或不存在'**
  String get authJoinNotFound;

  /// Join credential help
  ///
  /// In zh, this message translates to:
  /// **'输入企业提供的邀请码，可在注册后加入对应企业'**
  String get authJoinHelp;

  /// Tenant selection title
  ///
  /// In zh, this message translates to:
  /// **'选择组织'**
  String get authSelectOrganization;

  /// No organization
  ///
  /// In zh, this message translates to:
  /// **'暂无可用组织'**
  String get authNoOrganization;

  /// No organization guidance
  ///
  /// In zh, this message translates to:
  /// **'请联系管理员邀请您加入组织'**
  String get authNoOrganizationHint;

  /// Personal space entry
  ///
  /// In zh, this message translates to:
  /// **'个人空间'**
  String get authPersonalSpace;

  /// Personal space description
  ///
  /// In zh, this message translates to:
  /// **'好友聊天、个人收藏'**
  String get authPersonalSpaceSubtitle;

  /// Space identity validation failure
  ///
  /// In zh, this message translates to:
  /// **'空间身份校验失败，请重试'**
  String get authSpaceIdentityValidationFailed;

  /// Personal space restore failure
  ///
  /// In zh, this message translates to:
  /// **'个人空间恢复失败，请重试'**
  String get authPersonalSpaceRestoreFailed;

  /// Join enterprise failure
  ///
  /// In zh, this message translates to:
  /// **'加入企业失败，请稍后重试'**
  String get authJoinEnterpriseFailed;

  /// Home page title
  ///
  /// In zh, this message translates to:
  /// **'消息'**
  String get homeTitle;

  /// Home title shown while chat gateway is connecting or reconnecting
  ///
  /// In zh, this message translates to:
  /// **'连接中'**
  String get homeGatewayConnectingTitle;

  /// Personal space
  ///
  /// In zh, this message translates to:
  /// **'个人空间'**
  String get homePersonalSpace;

  /// Official service space
  ///
  /// In zh, this message translates to:
  /// **'官方服务空间'**
  String get homeOfficialService;

  /// Switch space
  ///
  /// In zh, this message translates to:
  /// **'切换空间'**
  String get homeSwitchSpace;

  /// Space subtitle
  ///
  /// In zh, this message translates to:
  /// **'个人空间 · 企业空间'**
  String get homeSpaceSubtitle;

  /// Join enterprise
  ///
  /// In zh, this message translates to:
  /// **'加入企业'**
  String get homeJoinEnterprise;

  /// Create group
  ///
  /// In zh, this message translates to:
  /// **'发起群聊'**
  String get homeCreateGroup;

  /// Add friend
  ///
  /// In zh, this message translates to:
  /// **'添加朋友'**
  String get homeAddFriend;

  /// Scan
  ///
  /// In zh, this message translates to:
  /// **'扫一扫'**
  String get homeScan;

  /// Join new space
  ///
  /// In zh, this message translates to:
  /// **'加入新空间'**
  String get homeJoinNewSpace;

  /// Search conversation
  ///
  /// In zh, this message translates to:
  /// **'搜索对话'**
  String get homeSearchConversation;

  /// No messages
  ///
  /// In zh, this message translates to:
  /// **'暂无消息'**
  String get homeNoMessages;

  /// Delete conversation
  ///
  /// In zh, this message translates to:
  /// **'删除会话'**
  String get homeDeleteConversation;

  /// Delete conversation confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要删除该会话吗？聊天记录将被清空。'**
  String get homeDeleteConversationConfirm;

  /// Personal note
  ///
  /// In zh, this message translates to:
  /// **'我（个人笔记）'**
  String get homePersonalNote;

  /// Work note
  ///
  /// In zh, this message translates to:
  /// **'我（工作笔记）'**
  String get homeWorkNote;

  /// Conversation count
  ///
  /// In zh, this message translates to:
  /// **'{count} 条会话'**
  String homeConversationCount(int count);

  /// Unread count
  ///
  /// In zh, this message translates to:
  /// **'{count} 条未读'**
  String homeUnreadCount(int count);

  /// chatInputHint
  ///
  /// In zh, this message translates to:
  /// **'输入消息...'**
  String get chatInputHint;

  /// Voice hint
  ///
  /// In zh, this message translates to:
  /// **'按住说话'**
  String get chatVoiceHint;

  /// Voice release
  ///
  /// In zh, this message translates to:
  /// **'松开发送'**
  String get chatVoiceRelease;

  /// Voice cancel
  ///
  /// In zh, this message translates to:
  /// **'上滑取消'**
  String get chatVoiceCancel;

  /// Chat menu copy
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get chatMenuCopy;

  /// Chat menu forward
  ///
  /// In zh, this message translates to:
  /// **'转发'**
  String get chatMenuForward;

  /// Chat menu recall
  ///
  /// In zh, this message translates to:
  /// **'撤回'**
  String get chatMenuRecall;

  /// Chat menu delete
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get chatMenuDelete;

  /// Chat menu favorite
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get chatMenuFavorite;

  /// Chat menu reply
  ///
  /// In zh, this message translates to:
  /// **'引用'**
  String get chatMenuReply;

  /// Chat menu multi select
  ///
  /// In zh, this message translates to:
  /// **'多选'**
  String get chatMenuMultiSelect;

  /// Chat menu translate
  ///
  /// In zh, this message translates to:
  /// **'翻译'**
  String get chatMenuTranslate;

  /// Chat menu voice to text
  ///
  /// In zh, this message translates to:
  /// **'转文字'**
  String get chatMenuVoiceToText;

  /// Chat menu text to speech
  ///
  /// In zh, this message translates to:
  /// **'朗读'**
  String get chatMenuTextToSpeech;

  /// Message recalled
  ///
  /// In zh, this message translates to:
  /// **'消息已撤回'**
  String get chatStatusRecalled;

  /// Recall success
  ///
  /// In zh, this message translates to:
  /// **'已撤回'**
  String get chatRecallSuccess;

  /// Recall failed
  ///
  /// In zh, this message translates to:
  /// **'撤回失败'**
  String get chatRecallFailed;

  /// Recall timeout
  ///
  /// In zh, this message translates to:
  /// **'超过2分钟的消息无法撤回'**
  String get chatRecallTimeout;

  /// Translate failed
  ///
  /// In zh, this message translates to:
  /// **'翻译失败，请重试'**
  String get chatTranslateFailed;

  /// Translate not configured
  ///
  /// In zh, this message translates to:
  /// **'翻译服务暂未开放'**
  String get chatTranslateNotConfigured;

  /// Voice to text failed
  ///
  /// In zh, this message translates to:
  /// **'转文字失败，请重试'**
  String get chatVoiceToTextFailed;

  /// Text to speech failed
  ///
  /// In zh, this message translates to:
  /// **'朗读失败，请重试'**
  String get chatTextToSpeechFailed;

  /// No description provided for @chatVoiceToText.
  ///
  /// In zh, this message translates to:
  /// **'转文字'**
  String get chatVoiceToText;

  /// Forward success
  ///
  /// In zh, this message translates to:
  /// **'已转发'**
  String get chatForwardSuccess;

  /// Forward failed
  ///
  /// In zh, this message translates to:
  /// **'转发失败，请重试'**
  String get chatForwardFailed;

  /// No conversations to forward
  ///
  /// In zh, this message translates to:
  /// **'没有可转发的会话'**
  String get chatNoConversations;

  /// Send failed
  ///
  /// In zh, this message translates to:
  /// **'发送失败'**
  String get chatSendFailed;

  /// Resend
  ///
  /// In zh, this message translates to:
  /// **'重新发送'**
  String get chatResend;

  /// Not friend
  ///
  /// In zh, this message translates to:
  /// **'对方不是你的好友'**
  String get chatNotFriend;

  /// Not friend hint
  ///
  /// In zh, this message translates to:
  /// **'你还不是对方的好友，暂时无法发送消息'**
  String get chatNotFriendHint;

  /// Muted hint
  ///
  /// In zh, this message translates to:
  /// **'全员禁言中'**
  String get chatMutedHint;

  /// File upload failed
  ///
  /// In zh, this message translates to:
  /// **'文件上传失败，请重试'**
  String get chatFileUploadFailed;

  /// File message status when the attachment has not been downloaded
  ///
  /// In zh, this message translates to:
  /// **'未下载'**
  String get chatFileStatusNotDownloaded;

  /// File message status when the attachment is available locally
  ///
  /// In zh, this message translates to:
  /// **'已下载'**
  String get chatFileStatusDownloaded;

  /// File message status while upload is in progress
  ///
  /// In zh, this message translates to:
  /// **'上传中'**
  String get chatFileStatusUploading;

  /// File message status when upload failed
  ///
  /// In zh, this message translates to:
  /// **'上传失败'**
  String get chatFileStatusUploadFailed;

  /// Card send failed
  ///
  /// In zh, this message translates to:
  /// **'名片发送失败'**
  String get chatCardSendFailed;

  /// Favorite success
  ///
  /// In zh, this message translates to:
  /// **'已收藏'**
  String get chatFavoriteSuccess;

  /// Favorite failed
  ///
  /// In zh, this message translates to:
  /// **'收藏失败'**
  String get chatFavoriteFailed;

  /// Chat load failed
  ///
  /// In zh, this message translates to:
  /// **'加载失败'**
  String get chatLoadFailed;

  /// Image message preview
  ///
  /// In zh, this message translates to:
  /// **'[图片]'**
  String get chatImageMessage;

  /// Voice message preview
  ///
  /// In zh, this message translates to:
  /// **'[语音]'**
  String get chatVoiceMessage;

  /// Video message preview
  ///
  /// In zh, this message translates to:
  /// **'[视频]'**
  String get chatVideoMessage;

  /// File message preview
  ///
  /// In zh, this message translates to:
  /// **'[文件]'**
  String get chatFileMessage;

  /// Location message preview
  ///
  /// In zh, this message translates to:
  /// **'[位置]'**
  String get chatLocationMessage;

  /// Contact card message preview
  ///
  /// In zh, this message translates to:
  /// **'[名片]'**
  String get chatContactCardMessage;

  /// Call log message preview
  ///
  /// In zh, this message translates to:
  /// **'[通话记录]'**
  String get chatCallLogMessage;

  /// Group member count in title
  ///
  /// In zh, this message translates to:
  /// **'({count})'**
  String chatGroupMemberCount(int count);

  /// Chat read count
  ///
  /// In zh, this message translates to:
  /// **'已读 {count} 人'**
  String chatReadCount(int count);

  /// chatUnread
  ///
  /// In zh, this message translates to:
  /// **'未读'**
  String get chatUnread;

  /// chatRecalledSelf
  ///
  /// In zh, this message translates to:
  /// **'你撤回了一条消息'**
  String get chatRecalledSelf;

  /// Peer recalled message
  ///
  /// In zh, this message translates to:
  /// **'{sender}撤回了一条消息'**
  String chatRecalledPeer(String sender);

  /// Translation prefix
  ///
  /// In zh, this message translates to:
  /// **'翻译：{translation}'**
  String chatTranslationPrefix(String translation);

  /// chatMessageDeleted
  ///
  /// In zh, this message translates to:
  /// **'消息已被删除'**
  String get chatMessageDeleted;

  /// chatPeer
  ///
  /// In zh, this message translates to:
  /// **'对方'**
  String get chatPeer;

  /// chatSelf
  ///
  /// In zh, this message translates to:
  /// **'我'**
  String get chatSelf;

  /// chatGenericMessage
  ///
  /// In zh, this message translates to:
  /// **'[消息]'**
  String get chatGenericMessage;

  /// chatVoiceHideText
  ///
  /// In zh, this message translates to:
  /// **'隐藏文字'**
  String get chatVoiceHideText;

  /// chatVoiceShowText
  ///
  /// In zh, this message translates to:
  /// **'转文字'**
  String get chatVoiceShowText;

  /// chatFileDefaultName
  ///
  /// In zh, this message translates to:
  /// **'文件'**
  String get chatFileDefaultName;

  /// chatContactDefaultName
  ///
  /// In zh, this message translates to:
  /// **'联系人'**
  String get chatContactDefaultName;

  /// chatContactCardTitle
  ///
  /// In zh, this message translates to:
  /// **'个人名片'**
  String get chatContactCardTitle;

  /// chatCallMissed
  ///
  /// In zh, this message translates to:
  /// **'未接听'**
  String get chatCallMissed;

  /// chatCallCancelled
  ///
  /// In zh, this message translates to:
  /// **'已取消'**
  String get chatCallCancelled;

  /// chatCallRejected
  ///
  /// In zh, this message translates to:
  /// **'已拒接'**
  String get chatCallRejected;

  /// chatCallDisconnected
  ///
  /// In zh, this message translates to:
  /// **'连接中断'**
  String get chatCallDisconnected;

  /// chatCallEnded
  ///
  /// In zh, this message translates to:
  /// **'通话已结束'**
  String get chatCallEnded;

  /// chatCallFailed
  ///
  /// In zh, this message translates to:
  /// **'通话失败'**
  String get chatCallFailed;

  /// Call duration text
  ///
  /// In zh, this message translates to:
  /// **'通话时长 {duration}'**
  String chatCallDuration(String duration);

  /// chatVideoCallTitle
  ///
  /// In zh, this message translates to:
  /// **'视频通话'**
  String get chatVideoCallTitle;

  /// chatVoiceCallTitle
  ///
  /// In zh, this message translates to:
  /// **'语音通话'**
  String get chatVoiceCallTitle;

  /// chatToolPhotos
  ///
  /// In zh, this message translates to:
  /// **'照片'**
  String get chatToolPhotos;

  /// chatToolCamera
  ///
  /// In zh, this message translates to:
  /// **'拍摄'**
  String get chatToolCamera;

  /// chatToolFile
  ///
  /// In zh, this message translates to:
  /// **'文件'**
  String get chatToolFile;

  /// chatToolLocation
  ///
  /// In zh, this message translates to:
  /// **'位置'**
  String get chatToolLocation;

  /// chatToolContactCard
  ///
  /// In zh, this message translates to:
  /// **'名片'**
  String get chatToolContactCard;

  /// chatToolVoiceCall
  ///
  /// In zh, this message translates to:
  /// **'语音通话'**
  String get chatToolVoiceCall;

  /// chatToolVideoCall
  ///
  /// In zh, this message translates to:
  /// **'视频通话'**
  String get chatToolVideoCall;

  /// chatToolFavorites
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get chatToolFavorites;

  /// No description provided for @chatToolTranslate.
  ///
  /// In zh, this message translates to:
  /// **'翻译'**
  String get chatToolTranslate;

  /// No description provided for @chatTranslationChooseLanguage.
  ///
  /// In zh, this message translates to:
  /// **'选择翻译语言'**
  String get chatTranslationChooseLanguage;

  /// No description provided for @chatTranslationEnterText.
  ///
  /// In zh, this message translates to:
  /// **'请先输入文字'**
  String get chatTranslationEnterText;

  /// No description provided for @chatTranslationMentionsUnsupported.
  ///
  /// In zh, this message translates to:
  /// **'暂不支持翻译带有 @ 的消息'**
  String get chatTranslationMentionsUnsupported;

  /// No description provided for @chatTranslationScheduledUnsupported.
  ///
  /// In zh, this message translates to:
  /// **'暂不支持翻译定时消息'**
  String get chatTranslationScheduledUnsupported;

  /// No description provided for @chatTranslationFailed.
  ///
  /// In zh, this message translates to:
  /// **'翻译失败，请重试'**
  String get chatTranslationFailed;

  /// No description provided for @chatTranslationEmpty.
  ///
  /// In zh, this message translates to:
  /// **'未获得译文，请重试'**
  String get chatTranslationEmpty;

  /// No description provided for @chatTranslationTranslating.
  ///
  /// In zh, this message translates to:
  /// **'翻译中…'**
  String get chatTranslationTranslating;

  /// No description provided for @chatTranslationSend.
  ///
  /// In zh, this message translates to:
  /// **'发送译文'**
  String get chatTranslationSend;

  /// No description provided for @chatTranslationSending.
  ///
  /// In zh, this message translates to:
  /// **'发送中…'**
  String get chatTranslationSending;

  /// No description provided for @chatTranslationExpand.
  ///
  /// In zh, this message translates to:
  /// **'展开译文'**
  String get chatTranslationExpand;

  /// No description provided for @chatTranslationCollapse.
  ///
  /// In zh, this message translates to:
  /// **'收起译文'**
  String get chatTranslationCollapse;

  /// chatFileTooLarge
  ///
  /// In zh, this message translates to:
  /// **'文件大小超过限制（100 MB）'**
  String get chatFileTooLarge;

  /// chatInputMutedAdminOnly
  ///
  /// In zh, this message translates to:
  /// **'已开启仅群主或特定成员可发言'**
  String get chatInputMutedAdminOnly;

  /// chatImageUploadUnsupported
  ///
  /// In zh, this message translates to:
  /// **'图片上传失败，服务端暂不支持，请联系管理员'**
  String get chatImageUploadUnsupported;

  /// chatFavoriteLongPressHint
  ///
  /// In zh, this message translates to:
  /// **'请长按消息进行收藏'**
  String get chatFavoriteLongPressHint;

  /// Selected message count
  ///
  /// In zh, this message translates to:
  /// **'已选择 {count} 条'**
  String chatSelectedCount(int count);

  /// chatLocationSheetTitle
  ///
  /// In zh, this message translates to:
  /// **'发送位置'**
  String get chatLocationSheetTitle;

  /// chatLocationNameLabel
  ///
  /// In zh, this message translates to:
  /// **'地点名称'**
  String get chatLocationNameLabel;

  /// chatLocationNameHint
  ///
  /// In zh, this message translates to:
  /// **'例如：公司、客户地址'**
  String get chatLocationNameHint;

  /// chatLocationAddressLabel
  ///
  /// In zh, this message translates to:
  /// **'详细地址'**
  String get chatLocationAddressLabel;

  /// chatLocationOptionalHint
  ///
  /// In zh, this message translates to:
  /// **'选填'**
  String get chatLocationOptionalHint;

  /// chatLocationLatitudeLabel
  ///
  /// In zh, this message translates to:
  /// **'纬度'**
  String get chatLocationLatitudeLabel;

  /// chatLocationLatitudeHint
  ///
  /// In zh, this message translates to:
  /// **'-90 到 90'**
  String get chatLocationLatitudeHint;

  /// chatLocationLongitudeLabel
  ///
  /// In zh, this message translates to:
  /// **'经度'**
  String get chatLocationLongitudeLabel;

  /// chatLocationLongitudeHint
  ///
  /// In zh, this message translates to:
  /// **'-180 到 180'**
  String get chatLocationLongitudeHint;

  /// Location coordinate required
  ///
  /// In zh, this message translates to:
  /// **'请输入{label}'**
  String chatLocationValidationRequired(String label);

  /// Location coordinate invalid range
  ///
  /// In zh, this message translates to:
  /// **'{label}范围不正确'**
  String chatLocationValidationRange(String label);

  /// chatLocationDefaultTitle
  ///
  /// In zh, this message translates to:
  /// **'位置'**
  String get chatLocationDefaultTitle;

  /// chatMutedFullNotice
  ///
  /// In zh, this message translates to:
  /// **'该群已开启已开启仅群主或特定成员可发言'**
  String get chatMutedFullNotice;

  /// chatNotFriendSendBlocked
  ///
  /// In zh, this message translates to:
  /// **'你已不是对方好友，无法发送消息'**
  String get chatNotFriendSendBlocked;

  /// chatPersonalNotesTitle
  ///
  /// In zh, this message translates to:
  /// **'个人笔记'**
  String get chatPersonalNotesTitle;

  /// chatWorkNotesTitle
  ///
  /// In zh, this message translates to:
  /// **'工作笔记'**
  String get chatWorkNotesTitle;

  /// chatPersonalNotesDescription
  ///
  /// In zh, this message translates to:
  /// **'在这里记录个人想法、保存重要信息\n跨设备同步，随时随地访问'**
  String get chatPersonalNotesDescription;

  /// chatWorkNotesDescription
  ///
  /// In zh, this message translates to:
  /// **'在这里记录工作事项、保存工作资料\n团队空间独立，信息安全隔离'**
  String get chatWorkNotesDescription;

  /// chatNoMessages
  ///
  /// In zh, this message translates to:
  /// **'暂无消息'**
  String get chatNoMessages;

  /// Reply preview sender
  ///
  /// In zh, this message translates to:
  /// **'回复 {sender}'**
  String chatReplyTo(String sender);

  /// Feature coming soon
  ///
  /// In zh, this message translates to:
  /// **'{feature} 功能即将上线'**
  String chatFeatureComingSoon(String feature);

  /// chatForwardSelectTitle
  ///
  /// In zh, this message translates to:
  /// **'选择聊天'**
  String get chatForwardSelectTitle;

  /// chatContactSelectTitle
  ///
  /// In zh, this message translates to:
  /// **'选择联系人'**
  String get chatContactSelectTitle;

  /// chatNoContacts
  ///
  /// In zh, this message translates to:
  /// **'暂无联系人'**
  String get chatNoContacts;

  /// Contacts title
  ///
  /// In zh, this message translates to:
  /// **'通讯录'**
  String get contactsTitle;

  /// Search contacts
  ///
  /// In zh, this message translates to:
  /// **'搜索联系人'**
  String get contactsSearch;

  /// New friends
  ///
  /// In zh, this message translates to:
  /// **'新的朋友'**
  String get contactsNewFriends;

  /// Groups
  ///
  /// In zh, this message translates to:
  /// **'群聊'**
  String get contactsGroups;

  /// Favorites
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get contactsFavorites;

  /// Recent contacts
  ///
  /// In zh, this message translates to:
  /// **'最近联系'**
  String get contactsRecent;

  /// Organization
  ///
  /// In zh, this message translates to:
  /// **'组织架构'**
  String get contactsOrganization;

  /// Announcement
  ///
  /// In zh, this message translates to:
  /// **'企业公告'**
  String get contactsAnnouncement;

  /// New applications
  ///
  /// In zh, this message translates to:
  /// **'新的申请'**
  String get contactsNewApplications;

  /// Customer groups
  ///
  /// In zh, this message translates to:
  /// **'客户群组'**
  String get contactsCustomerGroups;

  /// All customers
  ///
  /// In zh, this message translates to:
  /// **'所有客户'**
  String get contactsAllCustomers;

  /// My customers
  ///
  /// In zh, this message translates to:
  /// **'我的客户'**
  String get contactsMyCustomers;

  /// View all
  ///
  /// In zh, this message translates to:
  /// **'查看全部'**
  String get contactsViewAll;

  /// My contacts
  ///
  /// In zh, this message translates to:
  /// **'我的联系人'**
  String get contactsMyContacts;

  /// My advisor
  ///
  /// In zh, this message translates to:
  /// **'我的专属顾问'**
  String get contactsMyAdvisor;

  /// No advisor
  ///
  /// In zh, this message translates to:
  /// **'暂未分配专属顾问'**
  String get contactsNoAdvisor;

  /// Advisor loading
  ///
  /// In zh, this message translates to:
  /// **'加载中，请稍候'**
  String get contactsAdvisorLoading;

  /// Navigate failed
  ///
  /// In zh, this message translates to:
  /// **'跳转失败，请重试'**
  String get contactsNavigateFailed;

  /// No contacts
  ///
  /// In zh, this message translates to:
  /// **'暂无联系人'**
  String get contactsEmpty;

  /// No announcement
  ///
  /// In zh, this message translates to:
  /// **'暂无公告'**
  String get contactsNoAnnouncement;

  /// Official badge
  ///
  /// In zh, this message translates to:
  /// **'官方'**
  String get contactsOfficialBadge;

  /// Customer badge
  ///
  /// In zh, this message translates to:
  /// **'客户'**
  String get contactsCustomerBadge;

  /// No customers
  ///
  /// In zh, this message translates to:
  /// **'暂无客户'**
  String get contactsEmptyCustomers;

  /// My page title
  ///
  /// In zh, this message translates to:
  /// **'我'**
  String get myTitle;

  /// Enterprise info
  ///
  /// In zh, this message translates to:
  /// **'企业信息'**
  String get myEnterpriseInfo;

  /// Enterprise management
  ///
  /// In zh, this message translates to:
  /// **'企业管理'**
  String get myEnterpriseManage;

  /// QR code card
  ///
  /// In zh, this message translates to:
  /// **'二维码名片'**
  String get myQrCode;

  /// Favorites
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get myFavorites;

  /// System language
  ///
  /// In zh, this message translates to:
  /// **'系统语言'**
  String get myLanguage;

  /// Timezone
  ///
  /// In zh, this message translates to:
  /// **'时区'**
  String get myTimezone;

  /// Auto translate
  ///
  /// In zh, this message translates to:
  /// **'自动翻译'**
  String get myAutoTranslate;

  /// Network switch
  ///
  /// In zh, this message translates to:
  /// **'线路切换'**
  String get myNetworkSwitch;

  /// Settings
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get mySettings;

  /// Logout
  ///
  /// In zh, this message translates to:
  /// **'退出登录'**
  String get myLogout;

  /// Logout confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要退出登录吗？'**
  String get myLogoutConfirm;

  /// Leave enterprise
  ///
  /// In zh, this message translates to:
  /// **'退出企业'**
  String get myLeaveEnterprise;

  /// Leave enterprise confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要退出该企业吗？退出后将无法访问企业数据。'**
  String get myLeaveEnterpriseConfirm;

  /// Leave enterprise success
  ///
  /// In zh, this message translates to:
  /// **'已退出企业'**
  String get myLeaveEnterpriseSuccess;

  /// Leave enterprise failed
  ///
  /// In zh, this message translates to:
  /// **'退出失败，请重试'**
  String get myLeaveEnterpriseFailed;

  /// StartLink ID copied
  ///
  /// In zh, this message translates to:
  /// **'微界号已复制'**
  String get myLppIdCopied;

  /// StartLink ID label
  ///
  /// In zh, this message translates to:
  /// **'微界号：{lppId}'**
  String myLppIdLabel(String lppId);

  /// Friend count
  ///
  /// In zh, this message translates to:
  /// **'{count} 个朋友'**
  String myFriendCount(int count);

  /// Auto select
  ///
  /// In zh, this message translates to:
  /// **'自动选择'**
  String get myAutoSelect;

  /// Presence status
  ///
  /// In zh, this message translates to:
  /// **'在线状态'**
  String get myPresenceStatus;

  /// Set presence status title
  ///
  /// In zh, this message translates to:
  /// **'设置在线状态'**
  String get myPresenceStatusTitle;

  /// Presence online
  ///
  /// In zh, this message translates to:
  /// **'在线'**
  String get myPresenceOnline;

  /// Presence busy
  ///
  /// In zh, this message translates to:
  /// **'忙碌'**
  String get myPresenceBusy;

  /// Presence away
  ///
  /// In zh, this message translates to:
  /// **'离开'**
  String get myPresenceAway;

  /// Presence invisible
  ///
  /// In zh, this message translates to:
  /// **'隐身'**
  String get myPresenceInvisible;

  /// Profile title
  ///
  /// In zh, this message translates to:
  /// **'个人资料'**
  String get profileTitle;

  /// Name field
  ///
  /// In zh, this message translates to:
  /// **'名字'**
  String get profileName;

  /// Gender field
  ///
  /// In zh, this message translates to:
  /// **'性别'**
  String get profileGender;

  /// Birthday field
  ///
  /// In zh, this message translates to:
  /// **'生日'**
  String get profileBirthday;

  /// Region field
  ///
  /// In zh, this message translates to:
  /// **'地区'**
  String get profileRegion;

  /// Signature field
  ///
  /// In zh, this message translates to:
  /// **'签名'**
  String get profileSignature;

  /// Signature hint
  ///
  /// In zh, this message translates to:
  /// **'介绍一下自己'**
  String get profileSignatureHint;

  /// Tap tap text field
  ///
  /// In zh, this message translates to:
  /// **'拍一拍'**
  String get profileTapTapText;

  /// Tap tap hint
  ///
  /// In zh, this message translates to:
  /// **'拍一拍时显示的文案（最多20字）'**
  String get profileTapTapHint;

  /// Account section
  ///
  /// In zh, this message translates to:
  /// **'账号'**
  String get profileAccountSection;

  /// Basic info section
  ///
  /// In zh, this message translates to:
  /// **'基本信息'**
  String get profileBasicSection;

  /// StartLink ID field
  ///
  /// In zh, this message translates to:
  /// **'微界号'**
  String get profileLppId;

  /// StartLink ID not set
  ///
  /// In zh, this message translates to:
  /// **'未设置'**
  String get profileLppIdNotSet;

  /// Mobile field
  ///
  /// In zh, this message translates to:
  /// **'手机号'**
  String get profileMobile;

  /// Mobile unbound
  ///
  /// In zh, this message translates to:
  /// **'未绑定'**
  String get profileMobileUnbound;

  /// Email field
  ///
  /// In zh, this message translates to:
  /// **'邮箱'**
  String get profileEmail;

  /// Email unbound
  ///
  /// In zh, this message translates to:
  /// **'未绑定'**
  String get profileEmailUnbound;

  /// My QR code
  ///
  /// In zh, this message translates to:
  /// **'我的二维码'**
  String get profileQrCode;

  /// Change password
  ///
  /// In zh, this message translates to:
  /// **'修改密码'**
  String get profileChangePassword;

  /// Male
  ///
  /// In zh, this message translates to:
  /// **'男'**
  String get profileGenderMale;

  /// Female
  ///
  /// In zh, this message translates to:
  /// **'女'**
  String get profileGenderFemale;

  /// Other gender
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get profileGenderOther;

  /// Gender unset
  ///
  /// In zh, this message translates to:
  /// **'未设置'**
  String get profileGenderUnset;

  /// Save failed
  ///
  /// In zh, this message translates to:
  /// **'保存失败，请重试'**
  String get profileSaveFailed;

  /// StartLink ID page title
  ///
  /// In zh, this message translates to:
  /// **'微界号'**
  String get profileLppIdTitle;

  /// StartLink ID set once warning
  ///
  /// In zh, this message translates to:
  /// **'微界号设置后只能修改一次，请谨慎填写'**
  String get profileLppIdSetOnce;

  /// StartLink ID change failed
  ///
  /// In zh, this message translates to:
  /// **'修改失败（微界号只能修改一次）'**
  String get profileLppIdChangeFailed;

  /// Old password
  ///
  /// In zh, this message translates to:
  /// **'旧密码'**
  String get profileChangePasswordOld;

  /// New password
  ///
  /// In zh, this message translates to:
  /// **'新密码'**
  String get profileChangePasswordNew;

  /// Confirm new password
  ///
  /// In zh, this message translates to:
  /// **'确认新密码'**
  String get profileChangePasswordConfirm;

  /// Password mismatch
  ///
  /// In zh, this message translates to:
  /// **'两次密码不一致'**
  String get profileChangePasswordMismatch;

  /// Password changed
  ///
  /// In zh, this message translates to:
  /// **'密码修改成功，请重新登录'**
  String get profileChangePasswordSuccess;

  /// Password change failed
  ///
  /// In zh, this message translates to:
  /// **'密码修改失败，请重试'**
  String get profileChangePasswordFailed;

  /// Settings title
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// Enterprise section
  ///
  /// In zh, this message translates to:
  /// **'企业'**
  String get settingsSectionEnterprise;

  /// Account section
  ///
  /// In zh, this message translates to:
  /// **'账号'**
  String get settingsSectionAccount;

  /// General section
  ///
  /// In zh, this message translates to:
  /// **'通用'**
  String get settingsSectionGeneral;

  /// Features section
  ///
  /// In zh, this message translates to:
  /// **'功能'**
  String get settingsSectionFeatures;

  /// About section
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get settingsSectionAbout;

  /// Enterprise info
  ///
  /// In zh, this message translates to:
  /// **'企业信息'**
  String get settingsEnterpriseInfo;

  /// Profile
  ///
  /// In zh, this message translates to:
  /// **'个人资料'**
  String get settingsProfile;

  /// Account security
  ///
  /// In zh, this message translates to:
  /// **'账号安全'**
  String get settingsAccountSecurity;

  /// Notification
  ///
  /// In zh, this message translates to:
  /// **'通知'**
  String get settingsNotification;

  /// Display
  ///
  /// In zh, this message translates to:
  /// **'界面与显示'**
  String get settingsDisplay;

  /// Friend privacy
  ///
  /// In zh, this message translates to:
  /// **'朋友权限'**
  String get settingsFriendPrivacy;

  /// Chat settings
  ///
  /// In zh, this message translates to:
  /// **'聊天'**
  String get settingsChat;

  /// Chat history
  ///
  /// In zh, this message translates to:
  /// **'聊天记录管理'**
  String get settingsChatHistory;

  /// About
  ///
  /// In zh, this message translates to:
  /// **'关于微界'**
  String get settingsAbout;

  /// Language
  ///
  /// In zh, this message translates to:
  /// **'系统语言'**
  String get settingsLanguage;

  /// Timezone
  ///
  /// In zh, this message translates to:
  /// **'时区'**
  String get settingsTimezone;

  /// Auto translate
  ///
  /// In zh, this message translates to:
  /// **'自动翻译'**
  String get settingsAutoTranslate;

  /// Network switch
  ///
  /// In zh, this message translates to:
  /// **'线路切换'**
  String get settingsNetworkSwitch;

  /// Enterprise info title
  ///
  /// In zh, this message translates to:
  /// **'企业信息'**
  String get enterpriseInfoTitle;

  /// Enterprise name
  ///
  /// In zh, this message translates to:
  /// **'企业名称'**
  String get enterpriseName;

  /// Enterprise description
  ///
  /// In zh, this message translates to:
  /// **'企业简介'**
  String get enterpriseDescription;

  /// Update success
  ///
  /// In zh, this message translates to:
  /// **'更新成功'**
  String get enterpriseUpdateSuccess;

  /// Update failed
  ///
  /// In zh, this message translates to:
  /// **'更新失败，请重试'**
  String get enterpriseUpdateFailed;

  /// Leave enterprise
  ///
  /// In zh, this message translates to:
  /// **'退出企业'**
  String get enterpriseLeave;

  /// Leave enterprise confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要退出该企业吗？'**
  String get enterpriseLeaveConfirm;

  /// Leave enterprise success
  ///
  /// In zh, this message translates to:
  /// **'已退出企业'**
  String get enterpriseLeaveSuccess;

  /// Leave enterprise failed
  ///
  /// In zh, this message translates to:
  /// **'退出失败，请重试'**
  String get enterpriseLeaveFailed;

  /// Owner cannot leave
  ///
  /// In zh, this message translates to:
  /// **'所有者不能直接退出，请先转让所有者权限'**
  String get enterpriseLeaveOwnerError;

  /// Member count
  ///
  /// In zh, this message translates to:
  /// **'成员数'**
  String get enterpriseMemberCount;

  /// Created at
  ///
  /// In zh, this message translates to:
  /// **'创建时间'**
  String get enterpriseCreatedAt;

  /// Enterprise code
  ///
  /// In zh, this message translates to:
  /// **'企业码'**
  String get enterpriseCode;

  /// Invite members
  ///
  /// In zh, this message translates to:
  /// **'邀请成员'**
  String get enterpriseInviteMembers;

  /// Copy invite code
  ///
  /// In zh, this message translates to:
  /// **'复制邀请码'**
  String get enterpriseCopyInviteCode;

  /// Invite code copied
  ///
  /// In zh, this message translates to:
  /// **'邀请码已复制'**
  String get enterpriseInviteCodeCopied;

  /// Create group title
  ///
  /// In zh, this message translates to:
  /// **'发起群聊'**
  String get groupCreateTitle;

  /// Group name hint
  ///
  /// In zh, this message translates to:
  /// **'请输入群名称'**
  String get groupNameHint;

  /// Group create success
  ///
  /// In zh, this message translates to:
  /// **'群聊创建成功'**
  String get groupCreateSuccess;

  /// Group create failed
  ///
  /// In zh, this message translates to:
  /// **'群聊创建失败'**
  String get groupCreateFailed;

  /// Group settings
  ///
  /// In zh, this message translates to:
  /// **'群聊设置'**
  String get groupSettings;

  /// Group name
  ///
  /// In zh, this message translates to:
  /// **'群名称'**
  String get groupName;

  /// Group avatar
  ///
  /// In zh, this message translates to:
  /// **'群头像'**
  String get groupAvatar;

  /// Group announcement
  ///
  /// In zh, this message translates to:
  /// **'群公告'**
  String get groupAnnouncement;

  /// Group members
  ///
  /// In zh, this message translates to:
  /// **'群成员'**
  String get groupMembers;

  /// Add member
  ///
  /// In zh, this message translates to:
  /// **'添加成员'**
  String get groupAddMember;

  /// Remove member
  ///
  /// In zh, this message translates to:
  /// **'移除成员'**
  String get groupRemoveMember;

  /// Remove member confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要移除该成员吗？'**
  String get groupRemoveMemberConfirm;

  /// Set admin
  ///
  /// In zh, this message translates to:
  /// **'设为管理员'**
  String get groupSetAdmin;

  /// Remove admin
  ///
  /// In zh, this message translates to:
  /// **'取消管理员'**
  String get groupRemoveAdmin;

  /// Transfer owner
  ///
  /// In zh, this message translates to:
  /// **'转让群主'**
  String get groupTransferOwner;

  /// Transfer owner confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要将群主转让给该成员吗？'**
  String get groupTransferOwnerConfirm;

  /// Transfer owner success
  ///
  /// In zh, this message translates to:
  /// **'群主已转让'**
  String get groupTransferOwnerSuccess;

  /// Transfer owner failed
  ///
  /// In zh, this message translates to:
  /// **'转让失败，请重试'**
  String get groupTransferOwnerFailed;

  /// Leave group
  ///
  /// In zh, this message translates to:
  /// **'退出群聊'**
  String get groupLeave;

  /// Leave group confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要退出该群聊吗？'**
  String get groupLeaveConfirm;

  /// Leave group success
  ///
  /// In zh, this message translates to:
  /// **'已退出群聊'**
  String get groupLeaveSuccess;

  /// Leave group failed
  ///
  /// In zh, this message translates to:
  /// **'退出失败，请重试'**
  String get groupLeaveFailed;

  /// Dissolve group
  ///
  /// In zh, this message translates to:
  /// **'解散群聊'**
  String get groupDissolve;

  /// Dissolve group confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要解散该群聊吗？解散后所有成员将被移除。'**
  String get groupDissolveConfirm;

  /// Dissolve group success
  ///
  /// In zh, this message translates to:
  /// **'群聊已解散'**
  String get groupDissolveSuccess;

  /// Dissolve group failed
  ///
  /// In zh, this message translates to:
  /// **'解散失败，请重试'**
  String get groupDissolveFailed;

  /// Group QR code
  ///
  /// In zh, this message translates to:
  /// **'群二维码'**
  String get groupQrCode;

  /// Mute all
  ///
  /// In zh, this message translates to:
  /// **'全员禁言'**
  String get groupMuteAll;

  /// Mute all on
  ///
  /// In zh, this message translates to:
  /// **'开启全员禁言'**
  String get groupMuteAllOn;

  /// Mute all off
  ///
  /// In zh, this message translates to:
  /// **'关闭全员禁言'**
  String get groupMuteAllOff;

  /// Allow member invite
  ///
  /// In zh, this message translates to:
  /// **'允许成员邀请'**
  String get groupAllowMemberInvite;

  /// Allow member modify title
  ///
  /// In zh, this message translates to:
  /// **'允许成员修改群名'**
  String get groupAllowMemberModifyTitle;

  /// Allow member at all
  ///
  /// In zh, this message translates to:
  /// **'允许成员@所有人'**
  String get groupAllowMemberAtAll;

  /// Allow member view member list
  ///
  /// In zh, this message translates to:
  /// **'允许成员查看成员列表'**
  String get groupAllowMemberViewMemberList;

  /// Allow QR code join
  ///
  /// In zh, this message translates to:
  /// **'允许二维码加入'**
  String get groupAllowQrCodeJoin;

  /// Require approval
  ///
  /// In zh, this message translates to:
  /// **'加群需要审批'**
  String get groupRequireApproval;

  /// Allow member add friend
  ///
  /// In zh, this message translates to:
  /// **'允许群成员互加好友'**
  String get groupAllowMemberAddFriend;

  /// Group owner
  ///
  /// In zh, this message translates to:
  /// **'群主'**
  String get groupRoleOwner;

  /// Group admin
  ///
  /// In zh, this message translates to:
  /// **'管理员'**
  String get groupRoleAdmin;

  /// Group member
  ///
  /// In zh, this message translates to:
  /// **'成员'**
  String get groupRoleMember;

  /// No members
  ///
  /// In zh, this message translates to:
  /// **'暂无成员'**
  String get groupNoMembers;

  /// No announcements
  ///
  /// In zh, this message translates to:
  /// **'暂无公告'**
  String get groupNoAnnouncements;

  /// Create announcement
  ///
  /// In zh, this message translates to:
  /// **'发布公告'**
  String get groupCreateAnnouncement;

  /// Edit announcement
  ///
  /// In zh, this message translates to:
  /// **'编辑公告'**
  String get groupEditAnnouncement;

  /// Delete announcement
  ///
  /// In zh, this message translates to:
  /// **'删除公告'**
  String get groupDeleteAnnouncement;

  /// Delete announcement confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要删除该公告吗？'**
  String get groupDeleteAnnouncementConfirm;

  /// Announcement title
  ///
  /// In zh, this message translates to:
  /// **'公告标题'**
  String get groupAnnouncementTitle;

  /// Announcement content
  ///
  /// In zh, this message translates to:
  /// **'公告内容'**
  String get groupAnnouncementContent;

  /// Pin announcement
  ///
  /// In zh, this message translates to:
  /// **'置顶公告'**
  String get groupAnnouncementPin;

  /// Group member count
  ///
  /// In zh, this message translates to:
  /// **'{count} 人'**
  String groupMemberCount(int count);

  /// Selected count
  ///
  /// In zh, this message translates to:
  /// **'已选 {count} 人'**
  String groupSelectedCount(int count);

  /// Approve join request
  ///
  /// In zh, this message translates to:
  /// **'同意'**
  String get groupJoinRequestApprove;

  /// Reject join request
  ///
  /// In zh, this message translates to:
  /// **'拒绝'**
  String get groupJoinRequestReject;

  /// Join requests
  ///
  /// In zh, this message translates to:
  /// **'入群申请'**
  String get groupJoinRequests;

  /// No join requests
  ///
  /// In zh, this message translates to:
  /// **'暂无入群申请'**
  String get groupNoJoinRequests;

  /// Read receipts
  ///
  /// In zh, this message translates to:
  /// **'消息已读回执'**
  String get groupReadReceipts;

  /// Read count
  ///
  /// In zh, this message translates to:
  /// **'{count} 人已读'**
  String groupReadCount(int count);

  /// Unread count
  ///
  /// In zh, this message translates to:
  /// **'{count} 人未读'**
  String groupUnreadCount(int count);

  /// Add friend title
  ///
  /// In zh, this message translates to:
  /// **'添加朋友'**
  String get friendAddTitle;

  /// Friend search hint
  ///
  /// In zh, this message translates to:
  /// **'手机号 / 邮箱 / 微界号'**
  String get friendSearchHint;

  /// Friend request sent
  ///
  /// In zh, this message translates to:
  /// **'已发送好友申请'**
  String get friendRequestSent;

  /// Friend request failed
  ///
  /// In zh, this message translates to:
  /// **'发送失败，请重试'**
  String get friendRequestFailed;

  /// Already friend
  ///
  /// In zh, this message translates to:
  /// **'你们已经是好友了'**
  String get friendAlreadyFriend;

  /// New friends title
  ///
  /// In zh, this message translates to:
  /// **'新的朋友'**
  String get friendNewFriendsTitle;

  /// No friend requests
  ///
  /// In zh, this message translates to:
  /// **'暂无好友申请'**
  String get friendNoRequests;

  /// Accept friend request
  ///
  /// In zh, this message translates to:
  /// **'接受'**
  String get friendAccept;

  /// Reject friend request
  ///
  /// In zh, this message translates to:
  /// **'拒绝'**
  String get friendReject;

  /// Friend request accepted
  ///
  /// In zh, this message translates to:
  /// **'已接受'**
  String get friendAccepted;

  /// Friend request rejected
  ///
  /// In zh, this message translates to:
  /// **'已拒绝'**
  String get friendRejected;

  /// Delete friend confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要删除该好友吗？'**
  String get friendDeleteConfirm;

  /// Delete friend success
  ///
  /// In zh, this message translates to:
  /// **'已删除好友'**
  String get friendDeleteSuccess;

  /// Delete friend failed
  ///
  /// In zh, this message translates to:
  /// **'删除失败，请重试'**
  String get friendDeleteFailed;

  /// Remark name
  ///
  /// In zh, this message translates to:
  /// **'备注名'**
  String get friendRemarkName;

  /// Friend group name
  ///
  /// In zh, this message translates to:
  /// **'分组'**
  String get friendGroupName;

  /// Send message
  ///
  /// In zh, this message translates to:
  /// **'发消息'**
  String get friendSendMessage;

  /// Match by lpp id
  ///
  /// In zh, this message translates to:
  /// **'微界号匹配'**
  String get friendMatchTypeLppId;

  /// Match by mobile
  ///
  /// In zh, this message translates to:
  /// **'手机号匹配'**
  String get friendMatchTypeMobile;

  /// Match by email
  ///
  /// In zh, this message translates to:
  /// **'邮箱匹配'**
  String get friendMatchTypeEmail;

  /// Search empty
  ///
  /// In zh, this message translates to:
  /// **'未找到相关用户'**
  String get friendSearchEmpty;

  /// Add friend message
  ///
  /// In zh, this message translates to:
  /// **'请求添加你为好友'**
  String get friendAddMessage;

  /// Block confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要拉黑该用户吗？'**
  String get friendBlockConfirm;

  /// Unblock confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要取消拉黑吗？'**
  String get friendUnblockConfirm;

  /// Block success
  ///
  /// In zh, this message translates to:
  /// **'已拉黑'**
  String get friendBlockSuccess;

  /// Unblock success
  ///
  /// In zh, this message translates to:
  /// **'已取消拉黑'**
  String get friendUnblockSuccess;

  /// Profile page title
  ///
  /// In zh, this message translates to:
  /// **'个人信息'**
  String get profilePageTitle;

  /// Send message
  ///
  /// In zh, this message translates to:
  /// **'发消息'**
  String get profilePageSendMessage;

  /// Add friend
  ///
  /// In zh, this message translates to:
  /// **'加好友'**
  String get profilePageAddFriend;

  /// Already friend
  ///
  /// In zh, this message translates to:
  /// **'已是好友'**
  String get profilePageAlreadyFriend;

  /// Blocked
  ///
  /// In zh, this message translates to:
  /// **'已拉黑'**
  String get profilePageBlocked;

  /// Block
  ///
  /// In zh, this message translates to:
  /// **'拉黑'**
  String get profilePageBlock;

  /// Unblock
  ///
  /// In zh, this message translates to:
  /// **'取消拉黑'**
  String get profilePageUnblock;

  /// Profile hidden
  ///
  /// In zh, this message translates to:
  /// **'该用户已设置不对外展示资料'**
  String get profilePageHidden;

  /// Profile friends only
  ///
  /// In zh, this message translates to:
  /// **'该用户仅对好友展示资料'**
  String get profilePageFriendsOnly;

  /// StartLink ID
  ///
  /// In zh, this message translates to:
  /// **'微界号'**
  String get profilePageLppId;

  /// Remark name
  ///
  /// In zh, this message translates to:
  /// **'备注'**
  String get profilePageRemarkName;

  /// Edit remark
  ///
  /// In zh, this message translates to:
  /// **'修改备注'**
  String get profilePageEditRemark;

  /// Remark saved
  ///
  /// In zh, this message translates to:
  /// **'备注已保存'**
  String get profilePageSaveRemarkSuccess;

  /// Save remark failed
  ///
  /// In zh, this message translates to:
  /// **'保存失败，请重试'**
  String get profilePageSaveRemarkFailed;

  /// Search title
  ///
  /// In zh, this message translates to:
  /// **'搜索'**
  String get searchTitle;

  /// Search hint
  ///
  /// In zh, this message translates to:
  /// **'输入完整手机号、邮箱或微界号搜索'**
  String get searchHint;

  /// No search results
  ///
  /// In zh, this message translates to:
  /// **'未找到相关结果'**
  String get searchNoResults;

  /// Search messages
  ///
  /// In zh, this message translates to:
  /// **'消息'**
  String get searchMessages;

  /// Search users
  ///
  /// In zh, this message translates to:
  /// **'用户'**
  String get searchUsers;

  /// Search failed
  ///
  /// In zh, this message translates to:
  /// **'搜索失败，请重试'**
  String get searchFailed;

  /// Scan title
  ///
  /// In zh, this message translates to:
  /// **'扫一扫'**
  String get scanTitle;

  /// Scan failed
  ///
  /// In zh, this message translates to:
  /// **'识别失败，请重试'**
  String get scanFailed;

  /// Invalid QR code
  ///
  /// In zh, this message translates to:
  /// **'无效的二维码'**
  String get scanInvalidQrCode;

  /// Flash on
  ///
  /// In zh, this message translates to:
  /// **'打开手电筒'**
  String get scanFlashOn;

  /// Flash off
  ///
  /// In zh, this message translates to:
  /// **'关闭手电筒'**
  String get scanFlashOff;

  /// Scan from album
  ///
  /// In zh, this message translates to:
  /// **'从相册选择'**
  String get scanAlbum;

  /// Favorites title
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get favoritesTitle;

  /// No favorites
  ///
  /// In zh, this message translates to:
  /// **'暂无收藏'**
  String get favoritesEmpty;

  /// All favorites
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get favoritesAll;

  /// Text favorites
  ///
  /// In zh, this message translates to:
  /// **'文字'**
  String get favoritesText;

  /// Image favorites
  ///
  /// In zh, this message translates to:
  /// **'图片'**
  String get favoritesImage;

  /// Video favorites
  ///
  /// In zh, this message translates to:
  /// **'视频'**
  String get favoritesVideo;

  /// Voice favorites
  ///
  /// In zh, this message translates to:
  /// **'语音'**
  String get favoritesVoice;

  /// File favorites
  ///
  /// In zh, this message translates to:
  /// **'文件'**
  String get favoritesFile;

  /// Other favorites
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get favoritesOther;

  /// Delete favorite confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要取消收藏吗？'**
  String get favoritesDeleteConfirm;

  /// Delete favorite success
  ///
  /// In zh, this message translates to:
  /// **'已取消收藏'**
  String get favoritesDeleteSuccess;

  /// Delete favorite failed
  ///
  /// In zh, this message translates to:
  /// **'取消收藏失败'**
  String get favoritesDeleteFailed;

  /// Original recalled
  ///
  /// In zh, this message translates to:
  /// **'消息已撤回'**
  String get favoritesOriginalRecalled;

  /// View original
  ///
  /// In zh, this message translates to:
  /// **'查看原消息'**
  String get favoritesViewOriginal;

  /// Search favorites hint
  ///
  /// In zh, this message translates to:
  /// **'搜索收藏内容'**
  String get favoritesSearchHint;

  /// No favorites results
  ///
  /// In zh, this message translates to:
  /// **'没有找到相关收藏'**
  String get favoritesNoResults;

  /// Notice title
  ///
  /// In zh, this message translates to:
  /// **'企业公告'**
  String get noticeTitle;

  /// No notices
  ///
  /// In zh, this message translates to:
  /// **'暂无公告'**
  String get noticeEmpty;

  /// Notice detail
  ///
  /// In zh, this message translates to:
  /// **'公告详情'**
  String get noticeDetail;

  /// Published at
  ///
  /// In zh, this message translates to:
  /// **'发布时间'**
  String get noticePublishedAt;

  /// Normal priority
  ///
  /// In zh, this message translates to:
  /// **'普通'**
  String get noticePriorityNormal;

  /// Important priority
  ///
  /// In zh, this message translates to:
  /// **'重要'**
  String get noticePriorityImportant;

  /// Urgent priority
  ///
  /// In zh, this message translates to:
  /// **'紧急'**
  String get noticePriorityUrgent;

  /// Organization title
  ///
  /// In zh, this message translates to:
  /// **'组织架构'**
  String get organizationTitle;

  /// No organization
  ///
  /// In zh, this message translates to:
  /// **'暂无部门信息'**
  String get organizationEmpty;

  /// Organization members
  ///
  /// In zh, this message translates to:
  /// **'成员'**
  String get organizationMembers;

  /// Department
  ///
  /// In zh, this message translates to:
  /// **'部门'**
  String get organizationDepartment;

  /// Position
  ///
  /// In zh, this message translates to:
  /// **'职位'**
  String get organizationPosition;

  /// Leader
  ///
  /// In zh, this message translates to:
  /// **'负责人'**
  String get organizationLeader;

  /// QR code title
  ///
  /// In zh, this message translates to:
  /// **'我的二维码'**
  String get qrCodeTitle;

  /// Save QR code
  ///
  /// In zh, this message translates to:
  /// **'保存到相册'**
  String get qrCodeSave;

  /// Share QR code
  ///
  /// In zh, this message translates to:
  /// **'分享'**
  String get qrCodeShare;

  /// QR code saved
  ///
  /// In zh, this message translates to:
  /// **'已保存到相册'**
  String get qrCodeSaveSuccess;

  /// QR code save failed
  ///
  /// In zh, this message translates to:
  /// **'保存失败，请重试'**
  String get qrCodeSaveFailed;

  /// Refresh QR code
  ///
  /// In zh, this message translates to:
  /// **'刷新二维码'**
  String get qrCodeRefresh;

  /// QR code expired
  ///
  /// In zh, this message translates to:
  /// **'二维码已过期，请刷新'**
  String get qrCodeExpired;

  /// Scan to add friend
  ///
  /// In zh, this message translates to:
  /// **'扫一扫上面的二维码，添加我为好友'**
  String get qrCodeScanToAdd;

  /// Personal space
  ///
  /// In zh, this message translates to:
  /// **'个人空间'**
  String get spacePersonal;

  /// Enterprise space
  ///
  /// In zh, this message translates to:
  /// **'企业空间'**
  String get spaceEnterprise;

  /// Join by code
  ///
  /// In zh, this message translates to:
  /// **'通过企业码加入'**
  String get spaceJoinByCode;

  /// Join by invite
  ///
  /// In zh, this message translates to:
  /// **'通过邀请码加入'**
  String get spaceJoinByInvite;

  /// Enter enterprise code
  ///
  /// In zh, this message translates to:
  /// **'请输入企业码'**
  String get spaceEnterCode;

  /// Enter invite code
  ///
  /// In zh, this message translates to:
  /// **'请输入邀请码'**
  String get spaceEnterInviteCode;

  /// Search enterprise
  ///
  /// In zh, this message translates to:
  /// **'搜索企业'**
  String get spaceSearchEnterprise;

  /// Join request sent
  ///
  /// In zh, this message translates to:
  /// **'申请已提交，等待审批'**
  String get spaceJoinRequestSent;

  /// Join request pending
  ///
  /// In zh, this message translates to:
  /// **'申请审批中'**
  String get spaceJoinRequestPending;

  /// Join request approved
  ///
  /// In zh, this message translates to:
  /// **'申请已通过'**
  String get spaceJoinRequestApproved;

  /// Join request rejected
  ///
  /// In zh, this message translates to:
  /// **'申请已拒绝'**
  String get spaceJoinRequestRejected;

  /// Already member
  ///
  /// In zh, this message translates to:
  /// **'你已经是该企业成员'**
  String get spaceAlreadyMember;

  /// Auto approved
  ///
  /// In zh, this message translates to:
  /// **'已自动通过，欢迎加入'**
  String get spaceAutoApproved;

  /// Pending approval hint
  ///
  /// In zh, this message translates to:
  /// **'注册成功，加入企业申请已提交，等待审批'**
  String get spacePendingApprovalHint;

  /// No spaces
  ///
  /// In zh, this message translates to:
  /// **'暂无空间'**
  String get spaceNoSpaces;

  /// Invite expired
  ///
  /// In zh, this message translates to:
  /// **'邀请码已过期'**
  String get spaceInviteExpired;

  /// Invite target mismatch
  ///
  /// In zh, this message translates to:
  /// **'该邀请码不适用于你的账号'**
  String get spaceInviteTargetMismatch;

  /// Accept invite success
  ///
  /// In zh, this message translates to:
  /// **'已成功加入企业'**
  String get spaceAcceptInviteSuccess;

  /// Accept invite failed
  ///
  /// In zh, this message translates to:
  /// **'加入失败，请重试'**
  String get spaceAcceptInviteFailed;

  /// Tenant select title
  ///
  /// In zh, this message translates to:
  /// **'选择空间'**
  String get spaceTenantSelectTitle;

  /// Tenant select hint
  ///
  /// In zh, this message translates to:
  /// **'请选择要进入的空间'**
  String get spaceTenantSelectHint;

  /// Enter personal space
  ///
  /// In zh, this message translates to:
  /// **'进入个人空间'**
  String get spaceEnterPersonal;

  /// Enter enterprise space
  ///
  /// In zh, this message translates to:
  /// **'进入企业空间'**
  String get spaceEnterEnterprise;

  /// About title
  ///
  /// In zh, this message translates to:
  /// **'关于微界'**
  String get aboutTitle;

  /// Version
  ///
  /// In zh, this message translates to:
  /// **'版本'**
  String get aboutVersion;

  /// Terms
  ///
  /// In zh, this message translates to:
  /// **'用户协议'**
  String get aboutTerms;

  /// Privacy
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get aboutPrivacy;

  /// Open source
  ///
  /// In zh, this message translates to:
  /// **'开源许可'**
  String get aboutOpenSource;

  /// Check update
  ///
  /// In zh, this message translates to:
  /// **'检查更新'**
  String get aboutCheckUpdate;

  /// Latest version
  ///
  /// In zh, this message translates to:
  /// **'已是最新版本'**
  String get aboutLatestVersion;

  /// Update available
  ///
  /// In zh, this message translates to:
  /// **'发现新版本'**
  String get aboutUpdateAvailable;

  /// Update now
  ///
  /// In zh, this message translates to:
  /// **'立即更新'**
  String get aboutUpdateNow;

  /// Update later
  ///
  /// In zh, this message translates to:
  /// **'稍后再说'**
  String get aboutUpdateLater;

  /// Notification title
  ///
  /// In zh, this message translates to:
  /// **'通知'**
  String get notificationTitle;

  /// Global mute
  ///
  /// In zh, this message translates to:
  /// **'全局静音'**
  String get notificationGlobalMute;

  /// Sound
  ///
  /// In zh, this message translates to:
  /// **'声音'**
  String get notificationSound;

  /// Vibration
  ///
  /// In zh, this message translates to:
  /// **'振动'**
  String get notificationVibration;

  /// Notification preview
  ///
  /// In zh, this message translates to:
  /// **'通知预览'**
  String get notificationPreview;

  /// DND start
  ///
  /// In zh, this message translates to:
  /// **'免打扰开始时间'**
  String get notificationDndStart;

  /// DND end
  ///
  /// In zh, this message translates to:
  /// **'免打扰结束时间'**
  String get notificationDndEnd;

  /// Blacklist title
  ///
  /// In zh, this message translates to:
  /// **'黑名单'**
  String get blacklistTitle;

  /// Blacklist empty
  ///
  /// In zh, this message translates to:
  /// **'黑名单为空'**
  String get blacklistEmpty;

  /// Remove from blacklist
  ///
  /// In zh, this message translates to:
  /// **'移出黑名单'**
  String get blacklistRemove;

  /// Remove from blacklist confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要将该用户移出黑名单吗？'**
  String get blacklistRemoveConfirm;

  /// Feedback title
  ///
  /// In zh, this message translates to:
  /// **'意见反馈'**
  String get feedbackTitle;

  /// Complaint
  ///
  /// In zh, this message translates to:
  /// **'投诉'**
  String get feedbackTypeComplaint;

  /// Suggestion
  ///
  /// In zh, this message translates to:
  /// **'建议'**
  String get feedbackTypeSuggestion;

  /// Bug report
  ///
  /// In zh, this message translates to:
  /// **'Bug 报告'**
  String get feedbackTypeBug;

  /// Feedback content
  ///
  /// In zh, this message translates to:
  /// **'反馈内容'**
  String get feedbackContent;

  /// Feedback content hint
  ///
  /// In zh, this message translates to:
  /// **'请详细描述您的问题或建议'**
  String get feedbackContentHint;

  /// Feedback contact
  ///
  /// In zh, this message translates to:
  /// **'联系方式（选填）'**
  String get feedbackContact;

  /// Submit feedback
  ///
  /// In zh, this message translates to:
  /// **'提交'**
  String get feedbackSubmit;

  /// Feedback success
  ///
  /// In zh, this message translates to:
  /// **'反馈已提交，感谢您的建议'**
  String get feedbackSuccess;

  /// Feedback failed
  ///
  /// In zh, this message translates to:
  /// **'提交失败，请重试'**
  String get feedbackFailed;

  /// Network title
  ///
  /// In zh, this message translates to:
  /// **'线路切换'**
  String get networkTitle;

  /// Auto select
  ///
  /// In zh, this message translates to:
  /// **'自动选择'**
  String get networkAutoSelect;

  /// Manual select
  ///
  /// In zh, this message translates to:
  /// **'手动选择'**
  String get networkManual;

  /// Timezone title
  ///
  /// In zh, this message translates to:
  /// **'时区'**
  String get timezoneTitle;

  /// Auto timezone
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get timezoneAuto;

  /// Auto translate title
  ///
  /// In zh, this message translates to:
  /// **'自动翻译'**
  String get autoTranslateTitle;

  /// Auto translate enabled
  ///
  /// In zh, this message translates to:
  /// **'开启自动翻译'**
  String get autoTranslateEnabled;

  /// Auto translate language
  ///
  /// In zh, this message translates to:
  /// **'翻译目标语言'**
  String get autoTranslateLanguage;

  /// Display title
  ///
  /// In zh, this message translates to:
  /// **'界面与显示'**
  String get displayTitle;

  /// Font size
  ///
  /// In zh, this message translates to:
  /// **'字体大小'**
  String get displayFontSize;

  /// Chat background
  ///
  /// In zh, this message translates to:
  /// **'聊天背景'**
  String get displayChatBackground;

  /// Dark mode
  ///
  /// In zh, this message translates to:
  /// **'深色模式'**
  String get displayDarkMode;

  /// Dark mode system
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get displayDarkModeSystem;

  /// Dark mode system hint
  ///
  /// In zh, this message translates to:
  /// **'根据系统设置自动切换'**
  String get displayDarkModeSystemHint;

  /// Light mode
  ///
  /// In zh, this message translates to:
  /// **'浅色模式'**
  String get displayDarkModeOff;

  /// Light mode hint
  ///
  /// In zh, this message translates to:
  /// **'始终使用浅色主题'**
  String get displayDarkModeOffHint;

  /// Dark mode on
  ///
  /// In zh, this message translates to:
  /// **'深色模式'**
  String get displayDarkModeOn;

  /// Dark mode on hint
  ///
  /// In zh, this message translates to:
  /// **'始终使用深色主题'**
  String get displayDarkModeOnHint;

  /// Chat settings title
  ///
  /// In zh, this message translates to:
  /// **'聊天'**
  String get chatSettingsTitle;

  /// Chat history title
  ///
  /// In zh, this message translates to:
  /// **'聊天记录管理'**
  String get chatHistoryTitle;

  /// Clear chat history
  ///
  /// In zh, this message translates to:
  /// **'清空聊天记录'**
  String get chatHistoryClear;

  /// Clear chat history confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要清空所有聊天记录吗？此操作不可恢复。'**
  String get chatHistoryClearConfirm;

  /// Clear chat history success
  ///
  /// In zh, this message translates to:
  /// **'聊天记录已清空'**
  String get chatHistoryClearSuccess;

  /// Account security title
  ///
  /// In zh, this message translates to:
  /// **'账号安全'**
  String get accountSecurityTitle;

  /// Change password
  ///
  /// In zh, this message translates to:
  /// **'修改密码'**
  String get accountSecurityChangePassword;

  /// Change mobile
  ///
  /// In zh, this message translates to:
  /// **'更换手机号'**
  String get accountSecurityChangeMobile;

  /// Change email
  ///
  /// In zh, this message translates to:
  /// **'更换邮箱'**
  String get accountSecurityChangeEmail;

  /// Logged devices
  ///
  /// In zh, this message translates to:
  /// **'已登录设备'**
  String get accountSecurityLoggedDevices;

  /// Deactivate account
  ///
  /// In zh, this message translates to:
  /// **'注销账号'**
  String get accountSecurityDeactivate;

  /// Deactivate confirm
  ///
  /// In zh, this message translates to:
  /// **'注销账号后，所有数据将在7天后永久删除，确定要注销吗？'**
  String get accountSecurityDeactivateConfirm;

  /// Logged devices title
  ///
  /// In zh, this message translates to:
  /// **'已登录设备'**
  String get loggedDevicesTitle;

  /// Current device
  ///
  /// In zh, this message translates to:
  /// **'当前设备'**
  String get loggedDevicesCurrent;

  /// Revoke device
  ///
  /// In zh, this message translates to:
  /// **'退出该设备'**
  String get loggedDevicesRevoke;

  /// Revoke device confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要退出该设备吗？'**
  String get loggedDevicesRevokeConfirm;

  /// Revoke device success
  ///
  /// In zh, this message translates to:
  /// **'已退出该设备'**
  String get loggedDevicesRevokeSuccess;

  /// Revoke device failed
  ///
  /// In zh, this message translates to:
  /// **'退出失败，请重试'**
  String get loggedDevicesRevokeFailed;

  /// Last active
  ///
  /// In zh, this message translates to:
  /// **'最后活跃'**
  String get loggedDevicesLastActive;

  /// iOS device
  ///
  /// In zh, this message translates to:
  /// **'iOS'**
  String get loggedDevicesTypeIos;

  /// Android device
  ///
  /// In zh, this message translates to:
  /// **'Android'**
  String get loggedDevicesTypeAndroid;

  /// Web device
  ///
  /// In zh, this message translates to:
  /// **'网页端'**
  String get loggedDevicesTypeWeb;

  /// Desktop device
  ///
  /// In zh, this message translates to:
  /// **'桌面端'**
  String get loggedDevicesTypeDesktop;

  /// Unknown device
  ///
  /// In zh, this message translates to:
  /// **'未知设备'**
  String get loggedDevicesTypeUnknown;

  /// Privacy settings title
  ///
  /// In zh, this message translates to:
  /// **'朋友权限'**
  String get privacySettingsTitle;

  /// Searchable by mobile
  ///
  /// In zh, this message translates to:
  /// **'允许通过手机号搜索'**
  String get privacySearchableByMobile;

  /// Searchable by lpp id
  ///
  /// In zh, this message translates to:
  /// **'允许通过微界号搜索'**
  String get privacySearchableByLppId;

  /// Allow friend request
  ///
  /// In zh, this message translates to:
  /// **'加我为好友'**
  String get privacyAllowFriendRequest;

  /// Profile visibility
  ///
  /// In zh, this message translates to:
  /// **'个人资料可见性'**
  String get privacyProfileVisibility;

  /// Everyone
  ///
  /// In zh, this message translates to:
  /// **'所有人'**
  String get privacyEveryone;

  /// Friends of friends
  ///
  /// In zh, this message translates to:
  /// **'有共同好友的人'**
  String get privacyFriendsOfFriends;

  /// Nobody
  ///
  /// In zh, this message translates to:
  /// **'不允许'**
  String get privacyNobody;

  /// Friends only
  ///
  /// In zh, this message translates to:
  /// **'仅好友'**
  String get privacyFriendsOnly;

  /// Privacy save success
  ///
  /// In zh, this message translates to:
  /// **'设置已保存'**
  String get privacySaveSuccess;

  /// Privacy save failed
  ///
  /// In zh, this message translates to:
  /// **'保存失败，请重试'**
  String get privacySaveFailed;

  /// Font size title
  ///
  /// In zh, this message translates to:
  /// **'字体大小'**
  String get fontSizeTitle;

  /// Small font
  ///
  /// In zh, this message translates to:
  /// **'小'**
  String get fontSizeSmall;

  /// Normal font
  ///
  /// In zh, this message translates to:
  /// **'标准'**
  String get fontSizeNormal;

  /// Large font
  ///
  /// In zh, this message translates to:
  /// **'大'**
  String get fontSizeLarge;

  /// Extra large font
  ///
  /// In zh, this message translates to:
  /// **'超大'**
  String get fontSizeExtraLarge;

  /// Font size preview
  ///
  /// In zh, this message translates to:
  /// **'字体预览'**
  String get fontSizePreview;

  /// Chat background title
  ///
  /// In zh, this message translates to:
  /// **'聊天背景'**
  String get chatBackgroundTitle;

  /// Default background
  ///
  /// In zh, this message translates to:
  /// **'默认'**
  String get chatBackgroundDefault;

  /// Custom background
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get chatBackgroundCustom;

  /// Reset background
  ///
  /// In zh, this message translates to:
  /// **'恢复默认'**
  String get chatBackgroundReset;

  /// Terms title
  ///
  /// In zh, this message translates to:
  /// **'用户协议'**
  String get termsTitle;

  /// Privacy policy title
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get privacyPolicyTitle;

  /// Recent contacts title
  ///
  /// In zh, this message translates to:
  /// **'最近联系'**
  String get recentContactsTitle;

  /// No recent contacts
  ///
  /// In zh, this message translates to:
  /// **'暂无最近联系人'**
  String get recentContactsEmpty;

  /// Invite friends title
  ///
  /// In zh, this message translates to:
  /// **'邀请朋友'**
  String get inviteFriendsTitle;

  /// Copy invite link
  ///
  /// In zh, this message translates to:
  /// **'复制邀请链接'**
  String get inviteFriendsCopyLink;

  /// Invite link copied
  ///
  /// In zh, this message translates to:
  /// **'邀请链接已复制'**
  String get inviteFriendsLinkCopied;

  /// Image viewer title
  ///
  /// In zh, this message translates to:
  /// **'图片'**
  String get imageViewerTitle;

  /// Save image
  ///
  /// In zh, this message translates to:
  /// **'保存到相册'**
  String get imageViewerSave;

  /// Image saved
  ///
  /// In zh, this message translates to:
  /// **'已保存到相册'**
  String get imageViewerSaveSuccess;

  /// Image save failed
  ///
  /// In zh, this message translates to:
  /// **'保存失败，请重试'**
  String get imageViewerSaveFailed;

  /// Customer service title
  ///
  /// In zh, this message translates to:
  /// **'客服工作台'**
  String get customerServiceTitle;

  /// Queue
  ///
  /// In zh, this message translates to:
  /// **'排队中'**
  String get customerServiceQueue;

  /// Active
  ///
  /// In zh, this message translates to:
  /// **'服务中'**
  String get customerServiceActive;

  /// Claim
  ///
  /// In zh, this message translates to:
  /// **'接入'**
  String get customerServiceClaim;

  /// Takeover
  ///
  /// In zh, this message translates to:
  /// **'接管'**
  String get customerServiceTakeover;

  /// Close service
  ///
  /// In zh, this message translates to:
  /// **'结束服务'**
  String get customerServiceClose;

  /// Close service confirm
  ///
  /// In zh, this message translates to:
  /// **'确定要结束该服务吗？'**
  String get customerServiceCloseConfirm;

  /// No queue
  ///
  /// In zh, this message translates to:
  /// **'暂无排队'**
  String get customerServiceNoQueue;

  /// No active service
  ///
  /// In zh, this message translates to:
  /// **'暂无进行中的服务'**
  String get customerServiceNoActive;

  /// Visitor
  ///
  /// In zh, this message translates to:
  /// **'访客'**
  String get customerServiceVisitor;

  /// Customer
  ///
  /// In zh, this message translates to:
  /// **'客户'**
  String get customerServiceCustomer;

  /// Assigned to
  ///
  /// In zh, this message translates to:
  /// **'负责客服'**
  String get customerServiceAssignedTo;

  /// Transfer conversation
  ///
  /// In zh, this message translates to:
  /// **'转交会话'**
  String get customerServiceTransferConversation;

  /// Marketing toolbar
  ///
  /// In zh, this message translates to:
  /// **'营销工具'**
  String get marketingToolbar;

  /// Incoming call
  ///
  /// In zh, this message translates to:
  /// **'来电'**
  String get callIncoming;

  /// Outgoing call
  ///
  /// In zh, this message translates to:
  /// **'去电'**
  String get callOutgoing;

  /// Accept call
  ///
  /// In zh, this message translates to:
  /// **'接听'**
  String get callAccept;

  /// Reject call
  ///
  /// In zh, this message translates to:
  /// **'拒绝'**
  String get callReject;

  /// Hangup
  ///
  /// In zh, this message translates to:
  /// **'挂断'**
  String get callHangup;

  /// Missed call
  ///
  /// In zh, this message translates to:
  /// **'未接来电'**
  String get callMissed;

  /// Call duration
  ///
  /// In zh, this message translates to:
  /// **'通话时长'**
  String get callDuration;

  /// Audio call
  ///
  /// In zh, this message translates to:
  /// **'语音通话'**
  String get callAudio;

  /// Generic call label used when media mode is unavailable
  ///
  /// In zh, this message translates to:
  /// **'通话'**
  String get callGeneric;

  /// Video call
  ///
  /// In zh, this message translates to:
  /// **'视频通话'**
  String get callVideo;

  /// Connecting
  ///
  /// In zh, this message translates to:
  /// **'连接中...'**
  String get callConnecting;

  /// Ringing
  ///
  /// In zh, this message translates to:
  /// **'等待接听...'**
  String get callRinging;

  /// Call ended
  ///
  /// In zh, this message translates to:
  /// **'通话已结束'**
  String get callEnded;

  /// Call failed
  ///
  /// In zh, this message translates to:
  /// **'通话失败'**
  String get callFailed;

  /// Call rejected
  ///
  /// In zh, this message translates to:
  /// **'对方已拒绝'**
  String get callRejected;

  /// Call timeout
  ///
  /// In zh, this message translates to:
  /// **'对方无应答'**
  String get callTimeout;

  /// Call cancelled
  ///
  /// In zh, this message translates to:
  /// **'已取消'**
  String get callCancelled;

  /// Unknown call peer
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get callUnknownPeer;

  /// Video call invitation
  ///
  /// In zh, this message translates to:
  /// **'视频通话邀请'**
  String get callVideoInvitation;

  /// Audio call invitation
  ///
  /// In zh, this message translates to:
  /// **'语音通话邀请'**
  String get callAudioInvitation;

  /// Answer without video
  ///
  /// In zh, this message translates to:
  /// **'语音接听'**
  String get callAnswerAudio;

  /// Answer with video
  ///
  /// In zh, this message translates to:
  /// **'视频接听'**
  String get callAnswerVideo;

  /// View peer profile
  ///
  /// In zh, this message translates to:
  /// **'看他的近况'**
  String get callViewProfile;

  /// Opening camera
  ///
  /// In zh, this message translates to:
  /// **'正在打开摄像头...'**
  String get callOpeningCamera;

  /// Waiting for remote video
  ///
  /// In zh, this message translates to:
  /// **'等待远端视频...'**
  String get callWaitingRemoteVideo;

  /// Camera is off
  ///
  /// In zh, this message translates to:
  /// **'摄像头已关闭'**
  String get callCameraOff;

  /// Camera is on
  ///
  /// In zh, this message translates to:
  /// **'摄像头已开'**
  String get callCameraOn;

  /// Microphone is off
  ///
  /// In zh, this message translates to:
  /// **'麦克风已关'**
  String get callMicrophoneOff;

  /// Microphone is on
  ///
  /// In zh, this message translates to:
  /// **'麦克风已开'**
  String get callMicrophoneOn;

  /// Speaker is off
  ///
  /// In zh, this message translates to:
  /// **'扬声器已关'**
  String get callSpeakerOff;

  /// Speaker is on
  ///
  /// In zh, this message translates to:
  /// **'扬声器已开'**
  String get callSpeakerOn;

  /// Video media permission failure
  ///
  /// In zh, this message translates to:
  /// **'视频通话无法建立，请检查摄像头或麦克风权限后重试'**
  String get callVideoPermissionFailure;

  /// Audio media permission failure
  ///
  /// In zh, this message translates to:
  /// **'语音通话无法建立，请检查麦克风权限后重试'**
  String get callAudioPermissionFailure;

  /// Incomplete incoming call
  ///
  /// In zh, this message translates to:
  /// **'来电信息不完整，无法接听'**
  String get callIncompleteIncoming;

  /// Call in progress
  ///
  /// In zh, this message translates to:
  /// **'通话中'**
  String get callInProgress;

  /// Calling status
  ///
  /// In zh, this message translates to:
  /// **'呼叫中...'**
  String get callCalling;

  /// Ended call title
  ///
  /// In zh, this message translates to:
  /// **'{media}已结束'**
  String callEndedMedia(String media);

  /// Rejected call title
  ///
  /// In zh, this message translates to:
  /// **'{media}已被拒绝'**
  String callRejectedMedia(String media);

  /// Unanswered call title
  ///
  /// In zh, this message translates to:
  /// **'{media}无人接听'**
  String callUnansweredMedia(String media);

  /// Cancelled call title
  ///
  /// In zh, this message translates to:
  /// **'{media}已取消'**
  String callCancelledMedia(String media);

  /// Call connection lost
  ///
  /// In zh, this message translates to:
  /// **'通话连接中断'**
  String get callConnectionLost;

  /// Call ended by administrator
  ///
  /// In zh, this message translates to:
  /// **'通话已被结束'**
  String get callAdminEnded;

  /// Failed call title
  ///
  /// In zh, this message translates to:
  /// **'{media}失败'**
  String callFailedMedia(String media);

  /// Peer is busy
  ///
  /// In zh, this message translates to:
  /// **'对方忙线中'**
  String get callBusy;

  /// Call duration value
  ///
  /// In zh, this message translates to:
  /// **'通话时长 {duration}'**
  String callDurationValue(String duration);

  /// Call did not connect
  ///
  /// In zh, this message translates to:
  /// **'未接通'**
  String get callNotConnected;

  /// No description provided for @callDialed.
  ///
  /// In zh, this message translates to:
  /// **'已拨出'**
  String get callDialed;

  /// No description provided for @callAnswered.
  ///
  /// In zh, this message translates to:
  /// **'已接听'**
  String get callAnswered;

  /// No description provided for @callRejectedByPeer.
  ///
  /// In zh, this message translates to:
  /// **'对方已拒绝'**
  String get callRejectedByPeer;

  /// No description provided for @callRejectedBySelf.
  ///
  /// In zh, this message translates to:
  /// **'已拒绝'**
  String get callRejectedBySelf;

  /// No description provided for @callPeerDidNotAnswer.
  ///
  /// In zh, this message translates to:
  /// **'对方未接听'**
  String get callPeerDidNotAnswer;

  /// No description provided for @callMissedIncoming.
  ///
  /// In zh, this message translates to:
  /// **'未接来电'**
  String get callMissedIncoming;

  /// No description provided for @callPeerCancelled.
  ///
  /// In zh, this message translates to:
  /// **'对方已取消'**
  String get callPeerCancelled;

  /// No description provided for @notificationNewMessageTitle.
  ///
  /// In zh, this message translates to:
  /// **'微界新消息'**
  String get notificationNewMessageTitle;

  /// No description provided for @notificationOnlineServiceTitle.
  ///
  /// In zh, this message translates to:
  /// **'在线客服新消息'**
  String get notificationOnlineServiceTitle;

  /// No description provided for @notificationNewMessageBody.
  ///
  /// In zh, this message translates to:
  /// **'你收到一条新消息'**
  String get notificationNewMessageBody;

  /// No description provided for @notificationImagePreview.
  ///
  /// In zh, this message translates to:
  /// **'发来了一张图片'**
  String get notificationImagePreview;

  /// No description provided for @notificationVideoPreview.
  ///
  /// In zh, this message translates to:
  /// **'发来了一段视频'**
  String get notificationVideoPreview;

  /// No description provided for @notificationVoicePreview.
  ///
  /// In zh, this message translates to:
  /// **'发来了一条语音消息'**
  String get notificationVoicePreview;

  /// No description provided for @notificationFilePreview.
  ///
  /// In zh, this message translates to:
  /// **'发来了一个文件'**
  String get notificationFilePreview;

  /// No description provided for @notificationContactPreview.
  ///
  /// In zh, this message translates to:
  /// **'发来了一张名片'**
  String get notificationContactPreview;

  /// No description provided for @notificationCallLogPreview.
  ///
  /// In zh, this message translates to:
  /// **'发来了一条通话记录'**
  String get notificationCallLogPreview;

  /// No description provided for @notificationLocationPreview.
  ///
  /// In zh, this message translates to:
  /// **'分享了一个位置'**
  String get notificationLocationPreview;

  /// No description provided for @notificationLinkPreview.
  ///
  /// In zh, this message translates to:
  /// **'分享了一个链接'**
  String get notificationLinkPreview;

  /// No description provided for @notificationMentionMe.
  ///
  /// In zh, this message translates to:
  /// **'@了你：{body}'**
  String notificationMentionMe(String body);

  /// No description provided for @notificationMentionMeBy.
  ///
  /// In zh, this message translates to:
  /// **'{sender} @了你：{body}'**
  String notificationMentionMeBy(String sender, String body);

  /// No description provided for @notificationMentionAll.
  ///
  /// In zh, this message translates to:
  /// **'@所有人：{body}'**
  String notificationMentionAll(String body);

  /// No description provided for @notificationMentionAllBy.
  ///
  /// In zh, this message translates to:
  /// **'{sender} @所有人：{body}'**
  String notificationMentionAllBy(String sender, String body);

  /// No description provided for @notificationSecurityTitle.
  ///
  /// In zh, this message translates to:
  /// **'账号安全提醒'**
  String get notificationSecurityTitle;

  /// No description provided for @notificationSecurityBody.
  ///
  /// In zh, this message translates to:
  /// **'你的微界账号出现安全变更，请及时查看。'**
  String get notificationSecurityBody;

  /// No description provided for @notificationFriendAcceptedTitle.
  ///
  /// In zh, this message translates to:
  /// **'好友申请已通过'**
  String get notificationFriendAcceptedTitle;

  /// No description provided for @notificationFriendRejectedTitle.
  ///
  /// In zh, this message translates to:
  /// **'好友申请已被拒绝'**
  String get notificationFriendRejectedTitle;

  /// No description provided for @notificationFriendAcceptedBody.
  ///
  /// In zh, this message translates to:
  /// **'对方已通过你的好友申请'**
  String get notificationFriendAcceptedBody;

  /// No description provided for @notificationFriendRejectedBody.
  ///
  /// In zh, this message translates to:
  /// **'对方拒绝了你的好友申请'**
  String get notificationFriendRejectedBody;

  /// No description provided for @notificationVideoCallTitle.
  ///
  /// In zh, this message translates to:
  /// **'视频通话邀请'**
  String get notificationVideoCallTitle;

  /// No description provided for @notificationAudioCallTitle.
  ///
  /// In zh, this message translates to:
  /// **'语音通话邀请'**
  String get notificationAudioCallTitle;

  /// No description provided for @notificationVideoCallBody.
  ///
  /// In zh, this message translates to:
  /// **'{caller}邀请你进行视频通话'**
  String notificationVideoCallBody(String caller);

  /// No description provided for @notificationAudioCallBody.
  ///
  /// In zh, this message translates to:
  /// **'{caller}邀请你进行语音通话'**
  String notificationAudioCallBody(String caller);

  /// No description provided for @notificationMessageChannelName.
  ///
  /// In zh, this message translates to:
  /// **'消息通知'**
  String get notificationMessageChannelName;

  /// No description provided for @notificationMessageChannelDescription.
  ///
  /// In zh, this message translates to:
  /// **'聊天消息、通话记录和系统消息提醒'**
  String get notificationMessageChannelDescription;

  /// No description provided for @notificationCallChannelName.
  ///
  /// In zh, this message translates to:
  /// **'通话通知'**
  String get notificationCallChannelName;

  /// No description provided for @notificationCallChannelDescription.
  ///
  /// In zh, this message translates to:
  /// **'语音和视频来电提醒'**
  String get notificationCallChannelDescription;

  /// No description provided for @notificationSecurityChannelName.
  ///
  /// In zh, this message translates to:
  /// **'账号安全通知'**
  String get notificationSecurityChannelName;

  /// No description provided for @notificationSecurityChannelDescription.
  ///
  /// In zh, this message translates to:
  /// **'账号登录、密码和手机号变更提醒'**
  String get notificationSecurityChannelDescription;

  /// No description provided for @notificationUnknownCaller.
  ///
  /// In zh, this message translates to:
  /// **'未知来电人'**
  String get notificationUnknownCaller;

  /// Pending join requests title
  ///
  /// In zh, this message translates to:
  /// **'新的申请'**
  String get pendingJoinRequestsTitle;

  /// No pending requests
  ///
  /// In zh, this message translates to:
  /// **'暂无申请'**
  String get pendingJoinRequestsEmpty;

  /// Approve request
  ///
  /// In zh, this message translates to:
  /// **'同意'**
  String get pendingJoinRequestApprove;

  /// Reject request
  ///
  /// In zh, this message translates to:
  /// **'拒绝'**
  String get pendingJoinRequestReject;

  /// Approve success
  ///
  /// In zh, this message translates to:
  /// **'已同意申请'**
  String get pendingJoinRequestApproveSuccess;

  /// Reject success
  ///
  /// In zh, this message translates to:
  /// **'已拒绝申请'**
  String get pendingJoinRequestRejectSuccess;

  /// Request operation failed
  ///
  /// In zh, this message translates to:
  /// **'操作失败，请重试'**
  String get pendingJoinRequestFailed;

  /// My customers title
  ///
  /// In zh, this message translates to:
  /// **'我的客户'**
  String get myCustomersTitle;

  /// No customers
  ///
  /// In zh, this message translates to:
  /// **'暂无客户'**
  String get myCustomersEmpty;

  /// Group list title
  ///
  /// In zh, this message translates to:
  /// **'群聊列表'**
  String get groupListTitle;

  /// No groups
  ///
  /// In zh, this message translates to:
  /// **'暂无群聊'**
  String get groupListEmpty;

  /// Add friend page title
  ///
  /// In zh, this message translates to:
  /// **'添加朋友'**
  String get addFriendTitle;

  /// Add friend search hint
  ///
  /// In zh, this message translates to:
  /// **'手机号 / 邮箱 / 微界号'**
  String get addFriendSearchHint;

  /// StartLink ID label in search result
  ///
  /// In zh, this message translates to:
  /// **'微界号：{lppId}'**
  String addFriendLppIdLabel(String lppId);

  /// Add friend button
  ///
  /// In zh, this message translates to:
  /// **'加好友'**
  String get addFriendButton;

  /// Cannot add yourself as a friend
  ///
  /// In zh, this message translates to:
  /// **'不能添加自己'**
  String get addFriendCannotAddSelf;

  /// Target user cannot be added as a friend
  ///
  /// In zh, this message translates to:
  /// **'当前用户不支持添加好友，可直接发消息'**
  String get addFriendUnsupportedUser;

  /// Add friend message hint
  ///
  /// In zh, this message translates to:
  /// **'请输入验证消息'**
  String get addFriendMessageHint;

  /// Send friend request
  ///
  /// In zh, this message translates to:
  /// **'发送申请'**
  String get addFriendSendRequest;

  /// Join company title
  ///
  /// In zh, this message translates to:
  /// **'加入企业'**
  String get joinCompanyTitle;

  /// Join company code hint
  ///
  /// In zh, this message translates to:
  /// **'请输入企业码'**
  String get joinCompanyCodeHint;

  /// Join company search hint
  ///
  /// In zh, this message translates to:
  /// **'搜索企业名称'**
  String get joinCompanySearchHint;

  /// Apply to join
  ///
  /// In zh, this message translates to:
  /// **'申请加入'**
  String get joinCompanyApply;

  /// Apply success
  ///
  /// In zh, this message translates to:
  /// **'申请已提交'**
  String get joinCompanyApplySuccess;

  /// Apply failed
  ///
  /// In zh, this message translates to:
  /// **'申请失败，请重试'**
  String get joinCompanyApplyFailed;

  /// Auto approved
  ///
  /// In zh, this message translates to:
  /// **'已自动通过，欢迎加入'**
  String get joinCompanyAutoApproved;

  /// Join company pending
  ///
  /// In zh, this message translates to:
  /// **'申请已提交，等待审批'**
  String get joinCompanyPending;

  /// Invite code hint
  ///
  /// In zh, this message translates to:
  /// **'请输入邀请码'**
  String get joinCompanyInviteCodeHint;

  /// Accept invite
  ///
  /// In zh, this message translates to:
  /// **'接受邀请'**
  String get joinCompanyAcceptInvite;

  /// No company results
  ///
  /// In zh, this message translates to:
  /// **'未找到相关企业'**
  String get joinCompanyNoResults;

  /// Member count
  ///
  /// In zh, this message translates to:
  /// **'{count} 名成员'**
  String joinCompanyMemberCount(int count);

  /// No description provided for @timezoneNameHawaii.
  ///
  /// In zh, this message translates to:
  /// **'夏威夷'**
  String get timezoneNameHawaii;

  /// No description provided for @timezoneNameAlaska.
  ///
  /// In zh, this message translates to:
  /// **'阿拉斯加'**
  String get timezoneNameAlaska;

  /// No description provided for @timezoneNamePacificTime.
  ///
  /// In zh, this message translates to:
  /// **'太平洋时间'**
  String get timezoneNamePacificTime;

  /// No description provided for @timezoneNameMountainTime.
  ///
  /// In zh, this message translates to:
  /// **'山地时间'**
  String get timezoneNameMountainTime;

  /// No description provided for @timezoneNameCentralTime.
  ///
  /// In zh, this message translates to:
  /// **'中部时间'**
  String get timezoneNameCentralTime;

  /// No description provided for @timezoneNameEasternTime.
  ///
  /// In zh, this message translates to:
  /// **'东部时间'**
  String get timezoneNameEasternTime;

  /// No description provided for @timezoneNameAtlanticTime.
  ///
  /// In zh, this message translates to:
  /// **'大西洋时间'**
  String get timezoneNameAtlanticTime;

  /// No description provided for @timezoneNameBrasilia.
  ///
  /// In zh, this message translates to:
  /// **'巴西利亚'**
  String get timezoneNameBrasilia;

  /// No description provided for @timezoneNameAzores.
  ///
  /// In zh, this message translates to:
  /// **'亚速尔群岛'**
  String get timezoneNameAzores;

  /// No description provided for @timezoneNameLondonDublin.
  ///
  /// In zh, this message translates to:
  /// **'伦敦/都柏林'**
  String get timezoneNameLondonDublin;

  /// No description provided for @timezoneNameBerlinParisRome.
  ///
  /// In zh, this message translates to:
  /// **'柏林/巴黎/罗马'**
  String get timezoneNameBerlinParisRome;

  /// No description provided for @timezoneNameCairoHelsinki.
  ///
  /// In zh, this message translates to:
  /// **'开罗/赫尔辛基'**
  String get timezoneNameCairoHelsinki;

  /// No description provided for @timezoneNameMoscowRiyadh.
  ///
  /// In zh, this message translates to:
  /// **'莫斯科/利雅得'**
  String get timezoneNameMoscowRiyadh;

  /// No description provided for @timezoneNameTehran.
  ///
  /// In zh, this message translates to:
  /// **'德黑兰'**
  String get timezoneNameTehran;

  /// No description provided for @timezoneNameDubaiBaku.
  ///
  /// In zh, this message translates to:
  /// **'迪拜/巴库'**
  String get timezoneNameDubaiBaku;

  /// No description provided for @timezoneNameKabul.
  ///
  /// In zh, this message translates to:
  /// **'喀布尔'**
  String get timezoneNameKabul;

  /// No description provided for @timezoneNameKarachiTashkent.
  ///
  /// In zh, this message translates to:
  /// **'卡拉奇/塔什干'**
  String get timezoneNameKarachiTashkent;

  /// No description provided for @timezoneNameMumbaiNewDelhi.
  ///
  /// In zh, this message translates to:
  /// **'孟买/新德里'**
  String get timezoneNameMumbaiNewDelhi;

  /// No description provided for @timezoneNameKathmandu.
  ///
  /// In zh, this message translates to:
  /// **'加德满都'**
  String get timezoneNameKathmandu;

  /// No description provided for @timezoneNameDhakaAlmaty.
  ///
  /// In zh, this message translates to:
  /// **'达卡/阿拉木图'**
  String get timezoneNameDhakaAlmaty;

  /// No description provided for @timezoneNameYangon.
  ///
  /// In zh, this message translates to:
  /// **'仰光'**
  String get timezoneNameYangon;

  /// No description provided for @timezoneNameBangkokHanoiJakarta.
  ///
  /// In zh, this message translates to:
  /// **'曼谷/河内/雅加达'**
  String get timezoneNameBangkokHanoiJakarta;

  /// No description provided for @timezoneNameBeijingShanghaiHongKongTaipei.
  ///
  /// In zh, this message translates to:
  /// **'北京/上海/香港/台北'**
  String get timezoneNameBeijingShanghaiHongKongTaipei;

  /// No description provided for @timezoneNameTokyoSeoul.
  ///
  /// In zh, this message translates to:
  /// **'东京/首尔'**
  String get timezoneNameTokyoSeoul;

  /// No description provided for @timezoneNameAdelaide.
  ///
  /// In zh, this message translates to:
  /// **'阿德莱德'**
  String get timezoneNameAdelaide;

  /// No description provided for @timezoneNameSydneyMelbourne.
  ///
  /// In zh, this message translates to:
  /// **'悉尼/墨尔本'**
  String get timezoneNameSydneyMelbourne;

  /// No description provided for @timezoneNameSolomonIslands.
  ///
  /// In zh, this message translates to:
  /// **'所罗门群岛'**
  String get timezoneNameSolomonIslands;

  /// No description provided for @timezoneNameAucklandFiji.
  ///
  /// In zh, this message translates to:
  /// **'奥克兰/斐济'**
  String get timezoneNameAucklandFiji;

  /// No description provided for @networkSmartSelectBestRoute.
  ///
  /// In zh, this message translates to:
  /// **'智能选择最优线路'**
  String get networkSmartSelectBestRoute;

  /// No description provided for @networkTesting.
  ///
  /// In zh, this message translates to:
  /// **'测试中...'**
  String get networkTesting;

  /// No description provided for @networkTestingShort.
  ///
  /// In zh, this message translates to:
  /// **'测试中'**
  String get networkTestingShort;

  /// Network latency in milliseconds
  ///
  /// In zh, this message translates to:
  /// **'延迟 {ms}ms'**
  String networkLatencyMs(int ms);

  /// No description provided for @networkConnectionMode.
  ///
  /// In zh, this message translates to:
  /// **'连接模式'**
  String get networkConnectionMode;

  /// No description provided for @networkDirectMode.
  ///
  /// In zh, this message translates to:
  /// **'直连模式'**
  String get networkDirectMode;

  /// No description provided for @networkProxyMode.
  ///
  /// In zh, this message translates to:
  /// **'代理模式'**
  String get networkProxyMode;

  /// No description provided for @networkDirectModeDesc.
  ///
  /// In zh, this message translates to:
  /// **'直接连接服务器'**
  String get networkDirectModeDesc;

  /// No description provided for @networkProxyModeDesc.
  ///
  /// In zh, this message translates to:
  /// **'通过代理服务器连接'**
  String get networkProxyModeDesc;

  /// No description provided for @networkDirectRoutes.
  ///
  /// In zh, this message translates to:
  /// **'直连线路'**
  String get networkDirectRoutes;

  /// No description provided for @networkProxyRoutes.
  ///
  /// In zh, this message translates to:
  /// **'代理线路'**
  String get networkProxyRoutes;

  /// No description provided for @networkTestAll.
  ///
  /// In zh, this message translates to:
  /// **'测试全部'**
  String get networkTestAll;

  /// No description provided for @networkChinaTelecom.
  ///
  /// In zh, this message translates to:
  /// **'中国电信'**
  String get networkChinaTelecom;

  /// No description provided for @networkChinaUnicom.
  ///
  /// In zh, this message translates to:
  /// **'中国联通'**
  String get networkChinaUnicom;

  /// No description provided for @networkChinaMobile.
  ///
  /// In zh, this message translates to:
  /// **'中国移动'**
  String get networkChinaMobile;

  /// No description provided for @networkHongKongNode.
  ///
  /// In zh, this message translates to:
  /// **'香港节点'**
  String get networkHongKongNode;

  /// No description provided for @networkSingaporeNode.
  ///
  /// In zh, this message translates to:
  /// **'新加坡节点'**
  String get networkSingaporeNode;

  /// No description provided for @networkJapanNode.
  ///
  /// In zh, this message translates to:
  /// **'日本节点'**
  String get networkJapanNode;

  /// No description provided for @networkUnitedStatesNode.
  ///
  /// In zh, this message translates to:
  /// **'美国节点'**
  String get networkUnitedStatesNode;

  /// No description provided for @networkHint.
  ///
  /// In zh, this message translates to:
  /// **'提示：\n• 直连模式：速度快，适合国内使用\n• 代理模式：稳定性高，适合跨境通信\n• 点击刷新图标可测试单个线路延迟'**
  String get networkHint;

  /// No description provided for @teenModeTitle.
  ///
  /// In zh, this message translates to:
  /// **'青少年模式'**
  String get teenModeTitle;

  /// No description provided for @teenModeStatusOn.
  ///
  /// In zh, this message translates to:
  /// **'已开启'**
  String get teenModeStatusOn;

  /// No description provided for @teenModeStatusOff.
  ///
  /// In zh, this message translates to:
  /// **'未开启'**
  String get teenModeStatusOff;

  /// No description provided for @teenModeStatusLoading.
  ///
  /// In zh, this message translates to:
  /// **'获取中'**
  String get teenModeStatusLoading;

  /// No description provided for @teenModeUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'暂时无法获取青少年模式状态'**
  String get teenModeUnavailable;

  /// No description provided for @teenModeInvalidResponse.
  ///
  /// In zh, this message translates to:
  /// **'青少年模式服务返回了无效响应'**
  String get teenModeInvalidResponse;

  /// No description provided for @teenModeEnableDescription.
  ///
  /// In zh, this message translates to:
  /// **'开启后将按平台规则限制使用时长和部分功能。'**
  String get teenModeEnableDescription;

  /// No description provided for @teenModePasscode.
  ///
  /// In zh, this message translates to:
  /// **'口令'**
  String get teenModePasscode;

  /// No description provided for @teenModeCurrentPasscode.
  ///
  /// In zh, this message translates to:
  /// **'当前口令'**
  String get teenModeCurrentPasscode;

  /// No description provided for @teenModeNewPasscode.
  ///
  /// In zh, this message translates to:
  /// **'新口令'**
  String get teenModeNewPasscode;

  /// No description provided for @teenModePasscodeHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入 4–6 位数字'**
  String get teenModePasscodeHint;

  /// No description provided for @teenModeEnable.
  ///
  /// In zh, this message translates to:
  /// **'开启青少年模式'**
  String get teenModeEnable;

  /// No description provided for @teenModeDisable.
  ///
  /// In zh, this message translates to:
  /// **'关闭青少年模式'**
  String get teenModeDisable;

  /// No description provided for @teenModeChangePasscode.
  ///
  /// In zh, this message translates to:
  /// **'修改口令'**
  String get teenModeChangePasscode;

  /// No description provided for @teenModeSource.
  ///
  /// In zh, this message translates to:
  /// **'开启来源'**
  String get teenModeSource;

  /// No description provided for @teenModeDailyUsage.
  ///
  /// In zh, this message translates to:
  /// **'今日已使用'**
  String get teenModeDailyUsage;

  /// No description provided for @teenModeRemaining.
  ///
  /// In zh, this message translates to:
  /// **'剩余时间'**
  String get teenModeRemaining;

  /// No description provided for @teenModeMinutesUnit.
  ///
  /// In zh, this message translates to:
  /// **'分钟'**
  String get teenModeMinutesUnit;

  /// No description provided for @teenModeUnlimited.
  ///
  /// In zh, this message translates to:
  /// **'不限时'**
  String get teenModeUnlimited;

  /// No description provided for @teenModeRequestExtension.
  ///
  /// In zh, this message translates to:
  /// **'申请加时'**
  String get teenModeRequestExtension;

  /// No description provided for @teenModeExtensionSubmitted.
  ///
  /// In zh, this message translates to:
  /// **'加时申请已提交给监护人'**
  String get teenModeExtensionSubmitted;

  /// No description provided for @teenModeTimeLimitReached.
  ///
  /// In zh, this message translates to:
  /// **'今日使用时长已用完'**
  String get teenModeTimeLimitReached;

  /// No description provided for @teenModeCurfewActive.
  ///
  /// In zh, this message translates to:
  /// **'当前处于限制使用时段'**
  String get teenModeCurfewActive;

  /// No description provided for @teenModeReliefHint.
  ///
  /// In zh, this message translates to:
  /// **'仍可查看历史消息、联系官方客服和提交举报。'**
  String get teenModeReliefHint;

  /// No description provided for @teenModeRestrictedNotice.
  ///
  /// In zh, this message translates to:
  /// **'青少年模式当前限制发送消息'**
  String get teenModeRestrictedNotice;

  /// No description provided for @teenModeActionBlocked.
  ///
  /// In zh, this message translates to:
  /// **'青少年模式当前限制此操作'**
  String get teenModeActionBlocked;

  /// No description provided for @teenModeMyRequests.
  ///
  /// In zh, this message translates to:
  /// **'我的申请'**
  String get teenModeMyRequests;

  /// No description provided for @guardianCenterTitle.
  ///
  /// In zh, this message translates to:
  /// **'监护中心'**
  String get guardianCenterTitle;

  /// No description provided for @guardianRelationships.
  ///
  /// In zh, this message translates to:
  /// **'监护关系'**
  String get guardianRelationships;

  /// No description provided for @guardianMinors.
  ///
  /// In zh, this message translates to:
  /// **'我监护的孩子'**
  String get guardianMinors;

  /// No description provided for @guardianApprovals.
  ///
  /// In zh, this message translates to:
  /// **'待我审批'**
  String get guardianApprovals;

  /// No description provided for @guardianBind.
  ///
  /// In zh, this message translates to:
  /// **'输入绑定码'**
  String get guardianBind;

  /// No description provided for @guardianCreateMinorCode.
  ///
  /// In zh, this message translates to:
  /// **'我是孩子，生成绑定码'**
  String get guardianCreateMinorCode;

  /// No description provided for @guardianCreateGuardianCode.
  ///
  /// In zh, this message translates to:
  /// **'我是监护人，生成绑定码'**
  String get guardianCreateGuardianCode;

  /// No description provided for @guardianRelation.
  ///
  /// In zh, this message translates to:
  /// **'称谓或关系'**
  String get guardianRelation;

  /// No description provided for @guardianPrimary.
  ///
  /// In zh, this message translates to:
  /// **'主要监护人'**
  String get guardianPrimary;

  /// No description provided for @guardianCode.
  ///
  /// In zh, this message translates to:
  /// **'6 位绑定码'**
  String get guardianCode;

  /// No description provided for @guardianCodeHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入对方提供的绑定码'**
  String get guardianCodeHint;

  /// No description provided for @guardianCodeCreated.
  ///
  /// In zh, this message translates to:
  /// **'绑定码已生成，请在过期前交给对方'**
  String get guardianCodeCreated;

  /// No description provided for @guardianEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无监护关系'**
  String get guardianEmpty;

  /// No description provided for @guardianNoMinors.
  ///
  /// In zh, this message translates to:
  /// **'暂无受监护人'**
  String get guardianNoMinors;

  /// No description provided for @guardianUnbind.
  ///
  /// In zh, this message translates to:
  /// **'解除监护关系'**
  String get guardianUnbind;

  /// No description provided for @guardianExtend.
  ///
  /// In zh, this message translates to:
  /// **'为孩子加时'**
  String get guardianExtend;

  /// No description provided for @guardianPolicyTitle.
  ///
  /// In zh, this message translates to:
  /// **'使用规则'**
  String get guardianPolicyTitle;

  /// No description provided for @guardianPolicyLocked.
  ///
  /// In zh, this message translates to:
  /// **'平台已锁定'**
  String get guardianPolicyLocked;

  /// No description provided for @approvalEmpty.
  ///
  /// In zh, this message translates to:
  /// **'暂无申请'**
  String get approvalEmpty;

  /// No description provided for @approvalApprove.
  ///
  /// In zh, this message translates to:
  /// **'同意'**
  String get approvalApprove;

  /// No description provided for @approvalReject.
  ///
  /// In zh, this message translates to:
  /// **'拒绝'**
  String get approvalReject;

  /// No description provided for @approvalPending.
  ///
  /// In zh, this message translates to:
  /// **'待审批'**
  String get approvalPending;

  /// No description provided for @approvalApproved.
  ///
  /// In zh, this message translates to:
  /// **'已同意'**
  String get approvalApproved;

  /// No description provided for @approvalRejected.
  ///
  /// In zh, this message translates to:
  /// **'已拒绝'**
  String get approvalRejected;

  /// No description provided for @approvalExpired.
  ///
  /// In zh, this message translates to:
  /// **'已过期'**
  String get approvalExpired;

  /// No description provided for @approvalCancelled.
  ///
  /// In zh, this message translates to:
  /// **'已撤销'**
  String get approvalCancelled;

  /// No description provided for @approvalReplayFailed.
  ///
  /// In zh, this message translates to:
  /// **'原操作执行失败，请重新发起'**
  String get approvalReplayFailed;

  /// No description provided for @requestCancelled.
  ///
  /// In zh, this message translates to:
  /// **'申请已撤销'**
  String get requestCancelled;

  /// No description provided for @kycTitle.
  ///
  /// In zh, this message translates to:
  /// **'实名认证'**
  String get kycTitle;

  /// No description provided for @kycNotRequired.
  ///
  /// In zh, this message translates to:
  /// **'当前无需实名认证'**
  String get kycNotRequired;

  /// No description provided for @kycVerified.
  ///
  /// In zh, this message translates to:
  /// **'已实名认证'**
  String get kycVerified;

  /// No description provided for @kycDeclared.
  ///
  /// In zh, this message translates to:
  /// **'实名信息已提交'**
  String get kycDeclared;

  /// No description provided for @kycPending.
  ///
  /// In zh, this message translates to:
  /// **'审核中'**
  String get kycPending;

  /// No description provided for @kycRejected.
  ///
  /// In zh, this message translates to:
  /// **'审核未通过'**
  String get kycRejected;

  /// No description provided for @kycNone.
  ///
  /// In zh, this message translates to:
  /// **'尚未提交实名信息'**
  String get kycNone;

  /// No description provided for @kycRealName.
  ///
  /// In zh, this message translates to:
  /// **'真实姓名'**
  String get kycRealName;

  /// No description provided for @kycIdNumber.
  ///
  /// In zh, this message translates to:
  /// **'证件号码'**
  String get kycIdNumber;

  /// No description provided for @kycIdType.
  ///
  /// In zh, this message translates to:
  /// **'证件类型'**
  String get kycIdType;

  /// No description provided for @kycApplicability.
  ///
  /// In zh, this message translates to:
  /// **'请按证件类型填写真实信息；当前受理证件以列表为准。'**
  String get kycApplicability;

  /// No description provided for @kycCamera.
  ///
  /// In zh, this message translates to:
  /// **'拍照'**
  String get kycCamera;

  /// No description provided for @kycGallery.
  ///
  /// In zh, this message translates to:
  /// **'从相册选择'**
  String get kycGallery;

  /// No description provided for @kycPhotoLimit.
  ///
  /// In zh, this message translates to:
  /// **'单张照片上限'**
  String get kycPhotoLimit;

  /// No description provided for @kycSelectPhoto.
  ///
  /// In zh, this message translates to:
  /// **'选择照片'**
  String get kycSelectPhoto;

  /// No description provided for @kycPhotoSelected.
  ///
  /// In zh, this message translates to:
  /// **'已选择'**
  String get kycPhotoSelected;

  /// No description provided for @kycViewPhoto.
  ///
  /// In zh, this message translates to:
  /// **'点击查看照片'**
  String get kycViewPhoto;

  /// No description provided for @kycReplacePhoto.
  ///
  /// In zh, this message translates to:
  /// **'重选照片'**
  String get kycReplacePhoto;

  /// No description provided for @kycDisclosure.
  ///
  /// In zh, this message translates to:
  /// **'平台将使用姓名、证件号码和证件照片审核身份；不提供将无法提交，受实名门槛限制的功能可能不可用。'**
  String get kycDisclosure;

  /// No description provided for @kycConsent.
  ///
  /// In zh, this message translates to:
  /// **'我单独同意本次实名信息处理'**
  String get kycConsent;

  /// No description provided for @kycConsentRequired.
  ///
  /// In zh, this message translates to:
  /// **'请先单独同意实名信息处理'**
  String get kycConsentRequired;

  /// No description provided for @kycResubmitTitle.
  ///
  /// In zh, this message translates to:
  /// **'重新提交实名信息'**
  String get kycResubmitTitle;

  /// No description provided for @kycResubmitWarning.
  ///
  /// In zh, this message translates to:
  /// **'重新提交会作废当前待审申请，是否继续？'**
  String get kycResubmitWarning;

  /// No description provided for @kycSubmitting.
  ///
  /// In zh, this message translates to:
  /// **'提交中'**
  String get kycSubmitting;

  /// No description provided for @kycSubmitFailed.
  ///
  /// In zh, this message translates to:
  /// **'提交失败，请重试'**
  String get kycSubmitFailed;

  /// No description provided for @kycSubmitUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'当前无法提交实名信息'**
  String get kycSubmitUnavailable;

  /// No description provided for @kycResubmitNotAllowed.
  ///
  /// In zh, this message translates to:
  /// **'驳回后暂不允许重新提交，如有疑问请联系客服'**
  String get kycResubmitNotAllowed;

  /// No description provided for @kycDailyLimit.
  ///
  /// In zh, this message translates to:
  /// **'今日提交次数已用完，请明天再试'**
  String get kycDailyLimit;

  /// No description provided for @kycTypeUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'暂无可用证件类型，请稍后重试'**
  String get kycTypeUnavailable;

  /// No description provided for @kycNameInvalid.
  ///
  /// In zh, this message translates to:
  /// **'真实姓名需为 2–64 个字符'**
  String get kycNameInvalid;

  /// No description provided for @kycNumberRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入证件号码'**
  String get kycNumberRequired;

  /// No description provided for @kycFrontRequired.
  ///
  /// In zh, this message translates to:
  /// **'请上传证件正面照片'**
  String get kycFrontRequired;

  /// No description provided for @kycBackRequired.
  ///
  /// In zh, this message translates to:
  /// **'请上传证件背面照片'**
  String get kycBackRequired;

  /// No description provided for @kycPhotoTooLarge.
  ///
  /// In zh, this message translates to:
  /// **'照片超过单张上限，请压缩后重试'**
  String get kycPhotoTooLarge;

  /// No description provided for @kycAccountChanged.
  ///
  /// In zh, this message translates to:
  /// **'账号或空间已切换，请重新进入实名页'**
  String get kycAccountChanged;

  /// No description provided for @kycPhotoInvalid.
  ///
  /// In zh, this message translates to:
  /// **'请选择有效的图片'**
  String get kycPhotoInvalid;

  /// No description provided for @kycPortraitSide.
  ///
  /// In zh, this message translates to:
  /// **'人像面'**
  String get kycPortraitSide;

  /// No description provided for @kycEmblemSide.
  ///
  /// In zh, this message translates to:
  /// **'国徽面'**
  String get kycEmblemSide;

  /// No description provided for @kycPassportDataPage.
  ///
  /// In zh, this message translates to:
  /// **'护照资料页'**
  String get kycPassportDataPage;

  /// No description provided for @kycPassportOtherPage.
  ///
  /// In zh, this message translates to:
  /// **'护照签证页／备用页'**
  String get kycPassportOtherPage;

  /// No description provided for @kycFront.
  ///
  /// In zh, this message translates to:
  /// **'证件正面'**
  String get kycFront;

  /// No description provided for @kycBack.
  ///
  /// In zh, this message translates to:
  /// **'证件背面'**
  String get kycBack;

  /// No description provided for @kycRequired.
  ///
  /// In zh, this message translates to:
  /// **'创建群聊前需先完成实名认证'**
  String get kycRequired;

  /// No description provided for @kycGoVerify.
  ///
  /// In zh, this message translates to:
  /// **'去实名'**
  String get kycGoVerify;

  /// No description provided for @kycStatusUnknown.
  ///
  /// In zh, this message translates to:
  /// **'实名状态暂不可用，请稍后刷新'**
  String get kycStatusUnknown;

  /// No description provided for @kycSuperseded.
  ///
  /// In zh, this message translates to:
  /// **'这次申请已被后续提交替代，请查看最新实名状态'**
  String get kycSuperseded;

  /// No description provided for @kycMediaNotFound.
  ///
  /// In zh, this message translates to:
  /// **'当前空间找不到证件照，请重新选择后提交'**
  String get kycMediaNotFound;

  /// No description provided for @customerServiceBroadcastDirectTitle.
  ///
  /// In zh, this message translates to:
  /// **'客户群发'**
  String get customerServiceBroadcastDirectTitle;

  /// No description provided for @officialAccountBadge.
  ///
  /// In zh, this message translates to:
  /// **'官方'**
  String get officialAccountBadge;

  /// No description provided for @officialAccountOpenConversation.
  ///
  /// In zh, this message translates to:
  /// **'进入会话'**
  String get officialAccountOpenConversation;

  /// No description provided for @officialAccountJoinHint.
  ///
  /// In zh, this message translates to:
  /// **'添加后将以客户身份加入该企业，无需好友验证。'**
  String get officialAccountJoinHint;

  /// No description provided for @officialAccountJoinDisabled.
  ///
  /// In zh, this message translates to:
  /// **'该企业暂未开放添加，请联系客服'**
  String get officialAccountJoinDisabled;

  /// No description provided for @officialAccountRemoved.
  ///
  /// In zh, this message translates to:
  /// **'你已被该企业移除，需要企业重新邀请'**
  String get officialAccountRemoved;

  /// No description provided for @officialAccountBanned.
  ///
  /// In zh, this message translates to:
  /// **'你的账号在该企业已被停用'**
  String get officialAccountBanned;

  /// No description provided for @officialAccountUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'该官方号暂不可用'**
  String get officialAccountUnavailable;

  /// No description provided for @officialAccountJoinBindingDisabled.
  ///
  /// In zh, this message translates to:
  /// **'当前模式不允许加入企业'**
  String get officialAccountJoinBindingDisabled;

  /// No description provided for @officialAccountPlatformRequired.
  ///
  /// In zh, this message translates to:
  /// **'请使用平台账号添加该官方号'**
  String get officialAccountPlatformRequired;

  /// No description provided for @officialAccountOpenFailed.
  ///
  /// In zh, this message translates to:
  /// **'打开会话失败，请重试'**
  String get officialAccountOpenFailed;

  /// No description provided for @officialAccountAccountChanged.
  ///
  /// In zh, this message translates to:
  /// **'账号或空间已切换，请重新打开'**
  String get officialAccountAccountChanged;

  /// No description provided for @officialAccountDirectoryUnavailable.
  ///
  /// In zh, this message translates to:
  /// **'企业目录暂未更新，请稍后重试'**
  String get officialAccountDirectoryUnavailable;

  /// No description provided for @officialAccountInboxSyncFailed.
  ///
  /// In zh, this message translates to:
  /// **'官方号消息同步失败，已保留本地内容'**
  String get officialAccountInboxSyncFailed;

  /// No description provided for @officialAccountInboxSyncing.
  ///
  /// In zh, this message translates to:
  /// **'正在同步官方号消息'**
  String get officialAccountInboxSyncing;

  /// No description provided for @diagnosticsTitle.
  ///
  /// In zh, this message translates to:
  /// **'问题诊断'**
  String get diagnosticsTitle;

  /// No description provided for @diagnosticsExplanation.
  ///
  /// In zh, this message translates to:
  /// **'日志已脱敏，仅包含运行和错误信息。默认导出当前账号、当前空间及公共启动记录，不包含聊天正文或登录凭证。'**
  String get diagnosticsExplanation;

  /// No description provided for @diagnosticsHour.
  ///
  /// In zh, this message translates to:
  /// **'最近1小时'**
  String get diagnosticsHour;

  /// No description provided for @diagnosticsDay.
  ///
  /// In zh, this message translates to:
  /// **'最近24小时'**
  String get diagnosticsDay;

  /// No description provided for @diagnosticsWeek.
  ///
  /// In zh, this message translates to:
  /// **'最近7天'**
  String get diagnosticsWeek;

  /// No description provided for @diagnosticsEventCount.
  ///
  /// In zh, this message translates to:
  /// **'可用记录：{count}条'**
  String diagnosticsEventCount(int count);

  /// No description provided for @diagnosticsPersistent.
  ///
  /// In zh, this message translates to:
  /// **'日志已保存在本机，重启后可继续导出。'**
  String get diagnosticsPersistent;

  /// No description provided for @diagnosticsNotPersistent.
  ///
  /// In zh, this message translates to:
  /// **'部分日志尚未持久化，请稍后刷新。'**
  String get diagnosticsNotPersistent;

  /// No description provided for @diagnosticsExport.
  ///
  /// In zh, this message translates to:
  /// **'导出并分享'**
  String get diagnosticsExport;

  /// No description provided for @diagnosticsRefresh.
  ///
  /// In zh, this message translates to:
  /// **'刷新'**
  String get diagnosticsRefresh;

  /// No description provided for @diagnosticsClear.
  ///
  /// In zh, this message translates to:
  /// **'清除当前空间日志'**
  String get diagnosticsClear;

  /// No description provided for @diagnosticsClearConfirm.
  ///
  /// In zh, this message translates to:
  /// **'清除当前空间的诊断日志？此操作不会删除聊天记录。'**
  String get diagnosticsClearConfirm;

  /// No description provided for @diagnosticsShared.
  ///
  /// In zh, this message translates to:
  /// **'已完成系统分享操作，请在目标应用确认文件。'**
  String get diagnosticsShared;

  /// No description provided for @diagnosticsCancelled.
  ///
  /// In zh, this message translates to:
  /// **'已取消分享，可再次导出。'**
  String get diagnosticsCancelled;

  /// No description provided for @diagnosticsUnconfirmed.
  ///
  /// In zh, this message translates to:
  /// **'无法确认分享结果，请在目标应用检查。'**
  String get diagnosticsUnconfirmed;

  /// No description provided for @diagnosticsFailed.
  ///
  /// In zh, this message translates to:
  /// **'操作失败，请重试。'**
  String get diagnosticsFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bg',
        'cs',
        'da',
        'de',
        'el',
        'en',
        'es',
        'fi',
        'fil',
        'fr',
        'hi',
        'hr',
        'hu',
        'id',
        'it',
        'ja',
        'ko',
        'ms',
        'nb',
        'nl',
        'pl',
        'pt',
        'ro',
        'ru',
        'si',
        'sk',
        'sv',
        'th',
        'tr',
        'uk',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'PT':
            return AppLocalizationsPtPt();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bg':
      return AppLocalizationsBg();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fil':
      return AppLocalizationsFil();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'si':
      return AppLocalizationsSi();
    case 'sk':
      return AppLocalizationsSk();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
