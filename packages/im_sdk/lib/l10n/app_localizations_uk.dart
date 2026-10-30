// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get navWorkbench => 'Робоче місце';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed =>
      'Не вдалося завантажити дані облікового запису';

  @override
  String get startupFailureTitle => 'Помилка запуску';

  @override
  String get startupFailureMessage => 'Перевірте мережу та спробуйте ще раз';

  @override
  String get privacyConsentTitle =>
      'Умови надання послуг та Політика конфіденційності';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Вітаємо в $brand. Для входу в обліковий запис, обміну миттєвими повідомленнями, корпоративної співпраці, онлайн-підтримки, сповіщень і захисту безпеки нам потрібно обробляти необхідну інформацію відповідно до Умов використання та Політики конфіденційності.\n\nДо натискання «Погоджуюся» ми не читаємо буфер обміну, не ініціалізуємо JPush/JCore або SDK push-сповіщень виробників пристроїв і не використовуємо ці SDK для доступу до Android ID, OAID, списку встановлених застосунків, MAC-адрес та подібних даних. Якщо ви поки відмовитеся, ми збережемо цей вибір; ви зможете продовжити читання документів і змінити рішення пізніше.\n\nПісля згоди для доставлення сповіщень про повідомлення, підтримку та вхідні дзвінки JPush/JCore і push-сервіси виробників пристроїв можуть обробляти модель пристрою, версію Android, назву пакета й версію застосунку, тип мережі, IP-адресу, Android ID, OAID, Registration ID, push-токен виробника та дані доставлення сповіщень і натискань на них. Ми вимкнули необов’язкові можливості: розумні push-сповіщення, список встановлених застосунків, MAC, IMEI, IMSI, списки Wi-Fi, автоматичне пробудження та пов’язаний запуск.\n\nДоступ до буфера обміну здійснюється лише під час копіювання або вставлення. Дозволи на камеру, мікрофон, сповіщення та інші системні функції запитуються лише під час використання відповідної функції. Відмова в одному дозволі впливає лише на пов’язану функцію. Прочитайте повні документи нижче та вирішіть, чи погоджуєтеся ви.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Вітаємо в $brand. Для входу в обліковий запис, обміну миттєвими повідомленнями, корпоративної співпраці, онлайн-підтримки, сповіщень і захисту безпеки нам потрібно обробляти необхідну інформацію відповідно до Умов використання та Політики конфіденційності.\n\nДо натискання «Погоджуюся» ми не читаємо буфер обміну, не ініціалізуємо JPush/JCore, не реєструємося в Apple Push Notification service (APNs) і не отримуємо push-ідентифікатори, наприклад JPush Registration ID або токен пристрою APNs. Якщо ви поки відмовитеся, ми збережемо цей вибір; ви зможете продовжити читання документів і змінити рішення пізніше.\n\nПісля згоди для доставлення сповіщень про повідомлення, підтримку та вхідні дзвінки ми можемо обробляти модель iPhone, версію iOS, назву пакета й версію застосунку, тип мережі, IP-адресу, IDFV, JPush Registration ID, токен пристрою APNs, дані доставлення сповіщень і натискань на них. JPush/JCore підключається до push-сервісу; Apple APNs обробляє ідентифікатор застосунку, токен пристрою та вміст сповіщення для доставлення системних сповіщень. Поточний застосунок для iOS не використовує рекламних сервісів і не отримує IDFA.\n\nДоступ до буфера обміну здійснюється лише під час копіювання або вставлення. Дозволи на камеру, мікрофон, сповіщення та інші системні функції запитуються лише під час використання відповідної функції. Відмова в одному дозволі впливає лише на пов’язану функцію. Прочитайте повні документи нижче та вирішіть, чи погоджуєтеся ви.';
  }

  @override
  String get privacyConsentTermsLink => 'Угода користувача';

  @override
  String get privacyConsentConjunction => 'і';

  @override
  String get privacyConsentPrivacyLink => 'Політика конфіденційності';

  @override
  String get privacyConsentDecline => 'Не погоджуюсь';

  @override
  String get privacyConsentDeclinedExit =>
      'Ви не прийняли Умови використання та Політику конфіденційності. Застосунок закриється.';

  @override
  String get privacyConsentAccept => 'Погодитися';

  @override
  String get privacyConsentRuntimeFailure =>
      'Помилка запуску. Перевірте мережу та спробуйте ще раз.';

  @override
  String get privacyConsentSaveFailure =>
      'Не вдалося зберегти вибір. Спробуйте ще раз.';

  @override
  String get appUpdateRequiredTitle => 'Оновіть застосунок, щоб продовжити';

  @override
  String get appUpdateOptionalTitle => 'Доступна нова версія';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Доступна версія $brand $version';
  }

  @override
  String get appUpdateLater => 'Пізніше';

  @override
  String get appUpdateNow => 'Оновити зараз';

  @override
  String get appUpdateProcessing => 'Обробка...';

  @override
  String get appUpdateInvalidUrl =>
      'Недійсна адреса оновлення. Спробуйте пізніше.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Не вдалося відкрити посилання оновлення. Спробуйте пізніше.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Завантаження перервано. Перевірте мережу та спробуйте ще раз.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Пакет не пройшов перевірку. Завантажте його знову.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Дозвольте $brand встановлювати оновлення в системних налаштуваннях.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Не вдалося відкрити системний інсталятор. Перевірте дозволи на встановлення.';

  @override
  String get appUpdateGenericFailure =>
      'Помилка оновлення. Перевірте мережу та спробуйте ще раз.';

  @override
  String get appUpdateUnavailable =>
      'Нова версія поки недоступна для завантаження. Спробуйте пізніше.';

  @override
  String get appUpdateCheckFailed =>
      'Не вдалося перевірити оновлення. Спробуйте пізніше.';

  @override
  String get appUpdateChecking => 'Перевірка';

  @override
  String get commonConfirm => 'Гаразд';

  @override
  String get commonCancel => 'Скасувати';

  @override
  String get commonSave => 'Зберегти';

  @override
  String get commonEdit => 'Редагувати';

  @override
  String get commonDelete => 'Видалити';

  @override
  String get commonSearch => 'Пошук';

  @override
  String get commonLoading => 'Завантаження...';

  @override
  String get commonLoadFailed => 'Не вдалося завантажити';

  @override
  String get commonRetry => 'Повторити';

  @override
  String get commonEmpty => 'Немає даних';

  @override
  String get commonCopy => 'Копіювати';

  @override
  String get commonForward => 'Переслати';

  @override
  String get commonFavorite => 'Зберегти';

  @override
  String get commonClose => 'Закрити';

  @override
  String get commonSend => 'Надіслати';

  @override
  String get commonDone => 'Готово';

  @override
  String get commonMore => 'Більше';

  @override
  String get commonSettings => 'Налаштування';

  @override
  String get commonCopied => 'Скопійовано';

  @override
  String get commonUnknown => 'Невідомо';

  @override
  String get commonNotSet => 'Не задано';

  @override
  String get commonUnbound => 'Не прив\'язано';

  @override
  String get commonViewAll => 'Показати все';

  @override
  String get commonSubmit => 'Надіслати';

  @override
  String get commonAdd => 'Додати';

  @override
  String get commonRemove => 'Видалити';

  @override
  String get commonCreate => 'Створити';

  @override
  String get commonUpdate => 'Оновити';

  @override
  String get commonUpload => 'Завантажити';

  @override
  String get commonShare => 'Поділитися';

  @override
  String get commonBlock => 'Заблокувати';

  @override
  String get commonUnblock => 'Розблокувати';

  @override
  String get commonMute => 'Без звуку';

  @override
  String get commonUnmute => 'Увімкнути звук';

  @override
  String get commonPin => 'Закріплено';

  @override
  String get commonUnpin => 'Відкріпити';

  @override
  String get commonMarkRead => 'Позначити прочитаним';

  @override
  String get commonMarkUnread => 'Позначити непрочитаним';

  @override
  String get commonOnline => 'У мережі';

  @override
  String get commonOffline => 'Не в мережі';

  @override
  String get commonOperationFailed =>
      'Не вдалося виконати дію. Спробуйте ще раз';

  @override
  String get commonNetworkError => 'Помилка мережі. Перевірте підключення';

  @override
  String get navMessages => 'Повідомлення';

  @override
  String get navContacts => 'Контакти';

  @override
  String get navMe => 'Я';

  @override
  String get authLoginTitle => 'Увійти в StartLink';

  @override
  String get authTabMobile => 'Телефон';

  @override
  String get authTabEmail => 'Електронна пошта';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'Введіть номер телефону';

  @override
  String get authHintEmail => 'Введіть свою електронну адресу';

  @override
  String get authHintPassword => 'Введіть пароль';

  @override
  String get authHintCode => 'Введіть код підтвердження';

  @override
  String get authHintLoginName => 'Введіть StartLink ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Увійти';

  @override
  String get authGetCode => 'Отримати код';

  @override
  String authResendCode(int seconds) {
    return 'Надіслати повторно через $seconds с';
  }

  @override
  String get authUsePassword => 'Використати пароль';

  @override
  String get authUseCode => 'Використати код підтвердження';

  @override
  String get authAgreementPrefix => 'Я прочитав(-ла) та погоджуюся з ';

  @override
  String get authAgreementAnd => 'і';

  @override
  String get authTermsLink => 'Угода користувача';

  @override
  String get authPrivacyLink => 'Політика конфіденційності';

  @override
  String get authCaptchaTitle => 'Перевірка безпеки';

  @override
  String get authCaptchaHint => 'Введіть відповідь';

  @override
  String get authCaptchaFailed => 'Не вдалося отримати капчу. Спробуйте ще раз';

  @override
  String get authErrorEmptyCode => 'Введіть код підтвердження';

  @override
  String get authErrorEmptyPassword => 'Введіть пароль';

  @override
  String get authErrorEmptyLoginName => 'Введіть StartLink ID';

  @override
  String get authErrorWrongCredentials =>
      'Неправильний обліковий запис або пароль';

  @override
  String get authDeactivatingTitle => 'Видалення облікового запису';

  @override
  String get authDeactivatingContent =>
      'Ваш обліковий запис перебуває в періоді очікування видалення (7 днів).\n\nЩоб скасувати видалення, натисніть «Скасувати видалення». Щоб увійти в застосунок, натисніть «Продовжити».';

  @override
  String get authContinueUse => 'Продовжити';

  @override
  String get authCancelDeactivation => 'Скасувати видалення';

  @override
  String get authDeactivationCancelled =>
      'Видалення скасовано, обліковий запис відновлено';

  @override
  String get authDeactivationCancelFailed =>
      'Не вдалося скасувати. Спробуйте ще раз';

  @override
  String get authLogout => 'Вийти';

  @override
  String get authLogoutConfirm => 'Справді бажаєте вийти?';

  @override
  String get authSendingCode => 'Надсилання...';

  @override
  String get authCodeSent => 'Код підтвердження надіслано';

  @override
  String get authLoginFailed => 'Не вдалося ввійти. Спробуйте ще раз';

  @override
  String get authRegisterFailed => 'Помилка реєстрації. Спробуйте ще раз';

  @override
  String get authEnterpriseCode => 'Код компанії';

  @override
  String get authEnterpriseCodeHint => 'Введіть код компанії';

  @override
  String get authPendingApproval =>
      'Реєстрацію завершено. Заявку на вступ до компанії надіслано, вона очікує схвалення.';

  @override
  String get authNoAccount => 'Ще не маєте акаунту?';

  @override
  String get authRegisterNow => 'Зареєструватися';

  @override
  String get authCountryPickerTitle => 'Виберіть країну/регіон';

  @override
  String get authCountrySearchHint => 'Знайти країну/регіон';

  @override
  String get authCountryChinaMainland => 'Материковий Китай';

  @override
  String get authCountryHongKong => 'Гонконг, Китай';

  @override
  String get authCountryMacau => 'Макао, Китай';

  @override
  String get authCountryTaiwan => 'Тайвань, Китай';

  @override
  String get authCountryUnitedStates => 'США';

  @override
  String get authCountryUnitedKingdom => 'Велика Британія';

  @override
  String get authCountryJapan => 'Японія';

  @override
  String get authCountrySouthKorea => 'Південна Корея';

  @override
  String get authCountrySingapore => 'Сінгапур';

  @override
  String get authCountryMalaysia => 'Малайзія';

  @override
  String get authCountryAustralia => 'Австралія';

  @override
  String get authCountryCanada => 'Канада';

  @override
  String get authCountryGermany => 'Німеччина';

  @override
  String get authCountryFrance => 'Франція';

  @override
  String get authCountryIndia => 'Індія';

  @override
  String get authCountryThailand => 'Таїланд';

  @override
  String get authCountryVietnam => 'В’єтнам';

  @override
  String get authCountryIndonesia => 'Індонезія';

  @override
  String get authCountryPhilippines => 'Філіппіни';

  @override
  String get authQuickLoginTitle => 'Швидкий вхід';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Вхід. Зачекайте.';

  @override
  String get authRoleOwner => 'Власник';

  @override
  String get authRoleAdministrator => 'Адміністратор';

  @override
  String get authRoleCustomerService => 'Підтримка клієнтів';

  @override
  String get authRoleTechnicalSupport => 'Технічна підтримка';

  @override
  String get authRoleEmployee => 'Працівник';

  @override
  String get authRoleMember => 'Учасник';

  @override
  String get authRoleEnterpriseCustomer => 'Клієнт компанії';

  @override
  String get authUnavailablePrefix => 'Недоступно · ';

  @override
  String get authUnassignedService => 'Оператора не призначено';

  @override
  String authAssignedService(String staff) {
    return 'Призначено: $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Клієнт · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Працівник · $tenant';
  }

  @override
  String authUserCount(int count) {
    return 'Користувачів: $count';
  }

  @override
  String get authMetaPhone => 'Телефон';

  @override
  String get authMetaIdentity => 'Статус';

  @override
  String get authRegisterTitle => 'Зареєструватися';

  @override
  String get authNickname => 'Псевдонім';

  @override
  String get authNicknameHint => 'Задайте псевдонім';

  @override
  String get authPassword => 'Пароль';

  @override
  String get authPasswordSetHint => 'Задайте пароль (щонайменше 6 символів)';

  @override
  String get authConfirmPassword => 'Підтвердження паролю';

  @override
  String get authConfirmPasswordHint => 'Введіть пароль ще раз';

  @override
  String get authVerificationCode => 'Код підтвердження';

  @override
  String get authRegisterAndLogin => 'Зареєструватися та ввійти';

  @override
  String get authHaveAccount => 'Уже маєте обліковий запис?';

  @override
  String get authGoLogin => 'Увійти';

  @override
  String get authEmailVerificationUnavailable =>
      'Підтвердження через email недоступне. Зареєструйтеся за номером мобільного телефону.';

  @override
  String get authSmsVerificationUnavailable =>
      'Підтвердження через SMS недоступне. Зареєструйтеся через email.';

  @override
  String get authSendFailed => 'Не вдалося надіслати. Спробуйте ще раз.';

  @override
  String get authErrorEmptyNickname => 'Введіть псевдонім';

  @override
  String get authErrorInvalidMobile =>
      'Введіть коректний номер мобільного телефону';

  @override
  String get authErrorInvalidEmail => 'Введіть коректну адресу email';

  @override
  String get authErrorPasswordTooShort =>
      'Пароль має містити щонайменше 6 символів';

  @override
  String get authErrorPasswordMismatch => 'Паролі не збігаються';

  @override
  String get authErrorVerificationRequired =>
      'Спочатку отримайте та введіть код підтвердження';

  @override
  String get authRegisterErrorTitle => 'Помилка реєстрації';

  @override
  String get authGotIt => 'Зрозуміло';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Компанію «$code» не знайдено. Перевірте код компанії.';
  }

  @override
  String get authTenantSearchFailed => 'Помилка пошуку. Спробуйте ще раз.';

  @override
  String get authInvitationInvalid =>
      'Недійсний код запрошення. Перевірте його та спробуйте ще раз.';

  @override
  String get authCollapseJoin => 'Сховати відомості про вступ';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Дійсне запрошення: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Знайдено компанію: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Виберіть організацію';

  @override
  String get authNoOrganization => 'Немає доступних організацій';

  @override
  String get authNoOrganizationHint =>
      'Попросіть адміністратора запросити вас до організації';

  @override
  String get authPersonalSpace => 'Особистий простір';

  @override
  String get authPersonalSpaceSubtitle => 'Чати з друзями та особисте вибране';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Не вдалося перевірити належність простору. Спробуйте ще раз.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Не вдалося відновити особистий простір. Спробуйте ще раз.';

  @override
  String get authJoinEnterpriseFailed =>
      'Не вдалося вступити до компанії. Спробуйте пізніше.';

  @override
  String get homeTitle => 'Повідомлення';

  @override
  String get homeGatewayConnectingTitle => 'Підключення';

  @override
  String get homePersonalSpace => 'Особистий';

  @override
  String get homeOfficialService => 'Офіційний сервіс';

  @override
  String get homeSwitchSpace => 'Змінити простір';

  @override
  String get homeSpaceSubtitle => 'Особистий · Компанія';

  @override
  String get homeJoinEnterprise => 'Вступити до компанії';

  @override
  String get homeCreateGroup => 'Нова група';

  @override
  String get homeAddFriend => 'Додати контакт';

  @override
  String get homeScan => 'Сканувати';

  @override
  String get homeJoinNewSpace => 'Вступити до нового простору';

  @override
  String get homeSearchConversation => 'Пошук';

  @override
  String get homeNoMessages => 'Немає повідомлень';

  @override
  String get homeDeleteConversation => 'Видалити чат';

  @override
  String get homeDeleteConversationConfirm =>
      'Видалити цей чат? Історію чату буде очищено.';

  @override
  String get homePersonalNote => 'Я (Особисті нотатки)';

  @override
  String get homeWorkNote => 'Я (Робочі нотатки)';

  @override
  String homeConversationCount(int count) {
    return 'Чатів: $count';
  }

  @override
  String homeUnreadCount(int count) {
    return 'Непрочитаних: $count';
  }

  @override
  String get chatInputHint => 'Введіть повідомлення...';

  @override
  String get chatVoiceHint => 'Утримуйте, щоб говорити';

  @override
  String get chatVoiceRelease => 'Відпустіть для надсилання';

  @override
  String get chatVoiceCancel => 'Посуньте вгору для скасування';

  @override
  String get chatMenuCopy => 'Копіювати';

  @override
  String get chatMenuForward => 'Переслати';

  @override
  String get chatMenuRecall => 'Відкликати';

  @override
  String get chatMenuDelete => 'Видалити';

  @override
  String get chatMenuFavorite => 'Зберегти';

  @override
  String get chatMenuReply => 'Відповісти';

  @override
  String get chatMenuMultiSelect => 'Вибрати';

  @override
  String get chatMenuTranslate => 'Перекласти';

  @override
  String get chatMenuVoiceToText => 'Перетворити на текст';

  @override
  String get chatMenuTextToSpeech => 'Прочитати вголос';

  @override
  String get chatStatusRecalled => 'Повідомлення відкликано';

  @override
  String get chatRecallSuccess => 'Відкликано';

  @override
  String get chatRecallFailed => 'Не вдалося відкликати';

  @override
  String get chatRecallTimeout =>
      'Повідомлення, старші за 2 хвилини, не можна відкликати';

  @override
  String get chatTranslateFailed => 'Помилка перекладу. Спробуйте ще раз';

  @override
  String get chatTranslateNotConfigured => 'Сервіс перекладу недоступний';

  @override
  String get chatVoiceToTextFailed => 'Помилка перетворення. Спробуйте ще раз';

  @override
  String get chatTextToSpeechFailed =>
      'Не вдалося прочитати вголос. Спробуйте ще раз';

  @override
  String get chatVoiceToText => 'Перетворити';

  @override
  String get chatForwardSuccess => 'Переслано';

  @override
  String get chatForwardFailed => 'Не вдалося переслати. Спробуйте ще раз';

  @override
  String get chatNoConversations => 'Немає чатів для пересилання';

  @override
  String get chatSendFailed => 'Не вдалося надіслати';

  @override
  String get chatResend => 'Надіслати повторно';

  @override
  String get chatNotFriend => 'Немає у списку контактів';

  @override
  String get chatNotFriendHint =>
      'Ви ще не додані до контактів. Надсилання повідомлень недоступне.';

  @override
  String get chatMutedHint => 'Усім учасникам заборонено писати';

  @override
  String get chatFileUploadFailed =>
      'Не вдалося завантажити файл. Спробуйте ще раз';

  @override
  String get chatFileStatusNotDownloaded => 'Не завантажено';

  @override
  String get chatFileStatusDownloaded => 'Завантажено';

  @override
  String get chatFileStatusUploading => 'Завантаження';

  @override
  String get chatFileStatusUploadFailed => 'Завантаження не вдалося';

  @override
  String get chatCardSendFailed => 'Не вдалося надіслати картку контакту';

  @override
  String get chatFavoriteSuccess => 'Збережено';

  @override
  String get chatFavoriteFailed => 'Не вдалося додати до вибраного';

  @override
  String get chatLoadFailed => 'Не вдалося завантажити';

  @override
  String get chatImageMessage => '[Зображення]';

  @override
  String get chatVoiceMessage => '[Голосове повідомлення]';

  @override
  String get chatVideoMessage => '[Відео]';

  @override
  String get chatFileMessage => '[Файл]';

  @override
  String get chatLocationMessage => '[Місцезнаходження]';

  @override
  String get chatContactCardMessage => '[Контакт]';

  @override
  String get chatCallLogMessage => '[Дзвінок]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Прочитали: $count';
  }

  @override
  String get chatUnread => 'Не прочитано';

  @override
  String get chatRecalledSelf => 'Ви відкликали повідомлення';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender відкликає повідомлення';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Переклад: $translation';
  }

  @override
  String get chatMessageDeleted => 'Повідомлення видалено';

  @override
  String get chatPeer => 'Інше';

  @override
  String get chatSelf => 'Я';

  @override
  String get chatGenericMessage => '[Повідомлення]';

  @override
  String get chatVoiceHideText => 'Сховати текст';

  @override
  String get chatVoiceShowText => 'Перетворити на текст';

  @override
  String get chatFileDefaultName => 'Файл';

  @override
  String get chatContactDefaultName => 'Контакт';

  @override
  String get chatContactCardTitle => 'Картка контакту';

  @override
  String get chatCallMissed => 'Пропущено';

  @override
  String get chatCallCancelled => 'Скасовано';

  @override
  String get chatCallRejected => 'Відхилено';

  @override
  String get chatCallDisconnected => 'З’єднання розірвано';

  @override
  String get chatCallEnded => 'Дзвінок завершено';

  @override
  String get chatCallFailed => 'Помилка дзвінка';

  @override
  String chatCallDuration(String duration) {
    return 'Тривалість $duration';
  }

  @override
  String get chatVideoCallTitle => 'Відеодзвінок';

  @override
  String get chatVoiceCallTitle => 'Голосовий дзвінок';

  @override
  String get chatToolPhotos => 'Фото';

  @override
  String get chatToolCamera => 'Камера';

  @override
  String get chatToolFile => 'Файл';

  @override
  String get chatToolLocation => 'Місцезнаходження';

  @override
  String get chatToolContactCard => 'Контакт';

  @override
  String get chatToolVoiceCall => 'Голосовий дзвінок';

  @override
  String get chatToolVideoCall => 'Відеодзвінок';

  @override
  String get chatToolFavorites => 'Вибране';

  @override
  String get chatToolTranslate => 'Перекласти';

  @override
  String get chatTranslationChooseLanguage => 'Виберіть мову перекладу';

  @override
  String get chatTranslationEnterText => 'Спочатку введіть текст';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Переклад недоступний для повідомлень зі згадками';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Переклад недоступний під час редагування відкладеного повідомлення';

  @override
  String get chatTranslationFailed => 'Помилка перекладу. Спробуйте ще раз';

  @override
  String get chatTranslationEmpty => 'Переклад не отримано. Спробуйте ще раз';

  @override
  String get chatTranslationTranslating => 'Переклад…';

  @override
  String get chatTranslationSend => 'Надіслати переклад';

  @override
  String get chatTranslationSending => 'Надсилання…';

  @override
  String get chatTranslationExpand => 'Показати більше';

  @override
  String get chatTranslationCollapse => 'Показати менше';

  @override
  String get chatFileTooLarge => 'Розмір файлу перевищує ліміт (100 МБ)';

  @override
  String get chatInputMutedAdminOnly =>
      'Писати можуть лише власник і вибрані учасники.';

  @override
  String get chatImageUploadUnsupported =>
      'Не вдалося завантажити зображення. Сервер поки не підтримує цю функцію.';

  @override
  String get chatFavoriteLongPressHint =>
      'Утримуйте повідомлення, щоб додати до вибраного';

  @override
  String chatSelectedCount(int count) {
    return 'Вибрано: $count';
  }

  @override
  String get chatLocationSheetTitle => 'Надіслати місцезнаходження';

  @override
  String get chatLocationNameLabel => 'Назва місця';

  @override
  String get chatLocationNameHint => 'Наприклад, офіс або адреса клієнта';

  @override
  String get chatLocationAddressLabel => 'Адреса';

  @override
  String get chatLocationOptionalHint => 'Необов’язково';

  @override
  String get chatLocationLatitudeLabel => 'Широта';

  @override
  String get chatLocationLatitudeHint => 'Від -90 до 90';

  @override
  String get chatLocationLongitudeLabel => 'Довгота';

  @override
  String get chatLocationLongitudeHint => 'Від -180 до 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Введіть $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label поза допустимим діапазоном';
  }

  @override
  String get chatLocationDefaultTitle => 'Місцезнаходження';

  @override
  String get chatMutedFullNotice =>
      'У групі заборонено писати. Писати можуть лише власник і вибрані учасники.';

  @override
  String get chatNotFriendSendBlocked =>
      'Ви більше не друзі та не можете надсилати повідомлення';

  @override
  String get chatPersonalNotesTitle => 'Особисті нотатки';

  @override
  String get chatWorkNotesTitle => 'Робочі нотатки';

  @override
  String get chatPersonalNotesDescription =>
      'Записуйте особисті думки та зберігайте важливу інформацію\nСинхронізація між пристроями для доступу будь-коли';

  @override
  String get chatWorkNotesDescription =>
      'Записуйте робочі завдання та зберігайте матеріали\nПростори команд залишаються окремими й захищеними';

  @override
  String get chatNoMessages => 'Немає повідомлень';

  @override
  String chatReplyTo(String sender) {
    return 'Відповісти: $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature незабаром з’явиться';
  }

  @override
  String get chatForwardSelectTitle => 'Виберіть чат';

  @override
  String get chatContactSelectTitle => 'Виберіть контакт';

  @override
  String get chatNoContacts => 'Немає контактів';

  @override
  String get contactsTitle => 'Контакти';

  @override
  String get contactsSearch => 'Пошук контактів';

  @override
  String get contactsNewFriends => 'Нові друзі';

  @override
  String get contactsGroups => 'Групи';

  @override
  String get contactsFavorites => 'Вибране';

  @override
  String get contactsRecent => 'Нещодавні';

  @override
  String get contactsOrganization => 'Організація';

  @override
  String get contactsAnnouncement => 'Оголошення';

  @override
  String get contactsNewApplications => 'Нові заявки';

  @override
  String get contactsCustomerGroups => 'Групи клієнтів';

  @override
  String get contactsAllCustomers => 'Усі клієнти';

  @override
  String get contactsMyCustomers => 'Мої клієнти';

  @override
  String get contactsViewAll => 'Показати все';

  @override
  String get contactsMyContacts => 'Мої контакти';

  @override
  String get contactsMyAdvisor => 'Мій консультант';

  @override
  String get contactsNoAdvisor => 'Консультанта ще не призначено';

  @override
  String get contactsAdvisorLoading => 'Завантаження...';

  @override
  String get contactsNavigateFailed =>
      'Не вдалося відкрити сторінку. Спробуйте ще раз';

  @override
  String get contactsEmpty => 'Немає контактів';

  @override
  String get contactsNoAnnouncement => 'Немає оголошень';

  @override
  String get contactsOfficialBadge => 'Офіційний';

  @override
  String get contactsCustomerBadge => 'Клієнт';

  @override
  String get contactsEmptyCustomers => 'Немає клієнтів';

  @override
  String get myTitle => 'Я';

  @override
  String get myEnterpriseInfo => 'Інформація про компанію';

  @override
  String get myEnterpriseManage => 'Керування компанією';

  @override
  String get myQrCode => 'QR-код';

  @override
  String get myFavorites => 'Вибране';

  @override
  String get myLanguage => 'Мова';

  @override
  String get myTimezone => 'Часовий пояс';

  @override
  String get myAutoTranslate => 'Автопереклад';

  @override
  String get myNetworkSwitch => 'Змінити лінію';

  @override
  String get mySettings => 'Налаштування';

  @override
  String get myLogout => 'Вийти';

  @override
  String get myLogoutConfirm => 'Справді бажаєте вийти?';

  @override
  String get myLeaveEnterprise => 'Вийти з компанії';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Справді бажаєте вийти з цієї компанії? Ви втратите доступ до її даних.';

  @override
  String get myLeaveEnterpriseSuccess => 'Ви вийшли з компанії';

  @override
  String get myLeaveEnterpriseFailed => 'Не вдалося вийти. Спробуйте ще раз';

  @override
  String get myLppIdCopied => 'StartLink ID скопійовано';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return 'Контактів: $count';
  }

  @override
  String get myAutoSelect => 'Авто';

  @override
  String get myPresenceStatus => 'Статус присутності';

  @override
  String get myPresenceStatusTitle => 'Задати статус';

  @override
  String get myPresenceOnline => 'У мережі';

  @override
  String get myPresenceBusy => 'Зайнятий';

  @override
  String get myPresenceAway => 'Відійшов';

  @override
  String get myPresenceInvisible => 'Невидимий';

  @override
  String get profileTitle => 'Мій профіль';

  @override
  String get profileName => 'Ім’я';

  @override
  String get profileGender => 'Стать';

  @override
  String get profileBirthday => 'Дата народження';

  @override
  String get profileRegion => 'Регіон';

  @override
  String get profileSignature => 'Про себе';

  @override
  String get profileSignatureHint => 'Розкажіть про себе';

  @override
  String get profileTapTapText => 'Поплескування';

  @override
  String get profileTapTapHint =>
      'Текст під час поплескування (до 20 символів)';

  @override
  String get profileAccountSection => 'Обліковий запис';

  @override
  String get profileBasicSection => 'Основна інформація';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'Не задано';

  @override
  String get profileMobile => 'Телефон';

  @override
  String get profileMobileUnbound => 'Не прив\'язано';

  @override
  String get profileEmail => 'Електронна пошта';

  @override
  String get profileEmailUnbound => 'Не прив\'язано';

  @override
  String get profileQrCode => 'Мій QR-код';

  @override
  String get profileChangePassword => 'Змінити пароль';

  @override
  String get profileGenderMale => 'Чоловік';

  @override
  String get profileGenderFemale => 'Жінка';

  @override
  String get profileGenderOther => 'Інше';

  @override
  String get profileGenderUnset => 'Не задано';

  @override
  String get profileSaveFailed => 'Не вдалося зберегти. Спробуйте ще раз';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'StartLink ID можна змінити лише один раз. Обирайте уважно.';

  @override
  String get profileLppIdChangeFailed =>
      'Не вдалося змінити (StartLink ID можна змінити лише один раз)';

  @override
  String get profileChangePasswordOld => 'Поточний пароль';

  @override
  String get profileChangePasswordNew => 'Новий пароль';

  @override
  String get profileChangePasswordConfirm => 'Підтвердження нового пароля';

  @override
  String get profileChangePasswordMismatch => 'Паролі не збігаються';

  @override
  String get profileChangePasswordSuccess => 'Пароль змінено. Увійдіть знову.';

  @override
  String get profileChangePasswordFailed =>
      'Не вдалося змінити пароль. Спробуйте ще раз';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsSectionEnterprise => 'Компанія';

  @override
  String get settingsSectionAccount => 'Обліковий запис';

  @override
  String get settingsSectionGeneral => 'Основні';

  @override
  String get settingsSectionFeatures => 'Можливості';

  @override
  String get settingsSectionAbout => 'Про додаток';

  @override
  String get settingsEnterpriseInfo => 'Інформація про компанію';

  @override
  String get settingsProfile => 'Мій профіль';

  @override
  String get settingsAccountSecurity => 'Безпека облікового запису';

  @override
  String get settingsNotification => 'Сповіщення';

  @override
  String get settingsDisplay => 'Відображення';

  @override
  String get settingsFriendPrivacy => 'Конфіденційність';

  @override
  String get settingsChat => 'Чат';

  @override
  String get settingsChatHistory => 'Історія чату';

  @override
  String get settingsAbout => 'Про StartLink';

  @override
  String get settingsLanguage => 'Мова';

  @override
  String get settingsTimezone => 'Часовий пояс';

  @override
  String get settingsAutoTranslate => 'Автопереклад';

  @override
  String get settingsNetworkSwitch => 'Змінити лінію';

  @override
  String get enterpriseInfoTitle => 'Інформація про компанію';

  @override
  String get enterpriseName => 'Ім’я';

  @override
  String get enterpriseDescription => 'Опис';

  @override
  String get enterpriseUpdateSuccess => 'Успішно оновлено';

  @override
  String get enterpriseUpdateFailed => 'Помилка оновлення. Спробуйте ще раз';

  @override
  String get enterpriseLeave => 'Вийти з компанії';

  @override
  String get enterpriseLeaveConfirm => 'Справді бажаєте вийти з цієї компанії?';

  @override
  String get enterpriseLeaveSuccess => 'Ви вийшли з компанії';

  @override
  String get enterpriseLeaveFailed => 'Не вдалося вийти. Спробуйте ще раз';

  @override
  String get enterpriseLeaveOwnerError =>
      'Власник не може вийти безпосередньо. Спочатку передайте права власника.';

  @override
  String get enterpriseMemberCount => 'Учасники';

  @override
  String get enterpriseCreatedAt => 'Створено';

  @override
  String get enterpriseCode => 'Код компанії';

  @override
  String get enterpriseInviteMembers => 'Запросити учасників';

  @override
  String get enterpriseCopyInviteCode => 'Копіювати код запрошення';

  @override
  String get enterpriseInviteCodeCopied => 'Код запрошення скопійовано';

  @override
  String get groupCreateTitle => 'Нова група';

  @override
  String get groupNameHint => 'Введіть назву групи';

  @override
  String get groupCreateSuccess => 'Групу створено';

  @override
  String get groupCreateFailed => 'Не вдалося створити групу';

  @override
  String get groupSettings => 'Налаштування групи';

  @override
  String get groupName => 'Назва групи';

  @override
  String get groupAvatar => 'Аватар групи';

  @override
  String get groupAnnouncement => 'Оголошення';

  @override
  String get groupMembers => 'Учасники';

  @override
  String get groupAddMember => 'Додати учасників';

  @override
  String get groupRemoveMember => 'Видалити учасника';

  @override
  String get groupRemoveMemberConfirm => 'Видалити цього учасника?';

  @override
  String get groupSetAdmin => 'Призначити адміністратором';

  @override
  String get groupRemoveAdmin => 'Зняти права адміністратора';

  @override
  String get groupTransferOwner => 'Передати права власника';

  @override
  String get groupTransferOwnerConfirm =>
      'Передати права власника групи цьому учаснику?';

  @override
  String get groupTransferOwnerSuccess => 'Права власника передано';

  @override
  String get groupTransferOwnerFailed =>
      'Не вдалося передати. Спробуйте ще раз';

  @override
  String get groupLeave => 'Вийти з групи';

  @override
  String get groupLeaveConfirm => 'Вийти з цієї групи?';

  @override
  String get groupLeaveSuccess => 'Ви вийшли з групи';

  @override
  String get groupLeaveFailed => 'Не вдалося вийти. Спробуйте ще раз';

  @override
  String get groupDissolve => 'Розпустити групу';

  @override
  String get groupDissolveConfirm =>
      'Розпустити цю групу? Усіх учасників буде видалено.';

  @override
  String get groupDissolveSuccess => 'Групу розпущено';

  @override
  String get groupDissolveFailed => 'Не вдалося розпустити. Спробуйте ще раз';

  @override
  String get groupQrCode => 'QR-код групи';

  @override
  String get groupMuteAll => 'Заборонити писати всім';

  @override
  String get groupMuteAllOn => 'Увімкнути заборону для всіх';

  @override
  String get groupMuteAllOff => 'Вимкнути заборону для всіх';

  @override
  String get groupAllowMemberInvite => 'Дозволити учасникам запрошувати';

  @override
  String get groupAllowMemberModifyTitle =>
      'Дозволити учасникам змінювати назву групи';

  @override
  String get groupAllowMemberAtAll => 'Дозволити учасникам згадувати @Всіх';

  @override
  String get groupAllowMemberViewMemberList =>
      'Дозволити учасникам бачити список учасників';

  @override
  String get groupAllowQrCodeJoin => 'Дозволити вступ за QR-кодом';

  @override
  String get groupRequireApproval => 'Вимагати схвалення для вступу';

  @override
  String get groupAllowMemberAddFriend =>
      'Дозволити учасникам додавати одне одного';

  @override
  String get groupRoleOwner => 'Власник';

  @override
  String get groupRoleAdmin => 'Адміністратор';

  @override
  String get groupRoleMember => 'Учасник';

  @override
  String get groupNoMembers => 'Немає учасників';

  @override
  String get groupNoAnnouncements => 'Немає оголошень';

  @override
  String get groupCreateAnnouncement => 'Опублікувати оголошення';

  @override
  String get groupEditAnnouncement => 'Редагувати оголошення';

  @override
  String get groupDeleteAnnouncement => 'Видалити оголошення';

  @override
  String get groupDeleteAnnouncementConfirm => 'Видалити це оголошення?';

  @override
  String get groupAnnouncementTitle => 'Заголовок';

  @override
  String get groupAnnouncementContent => 'Вміст';

  @override
  String get groupAnnouncementPin => 'Закріпити оголошення';

  @override
  String groupMemberCount(int count) {
    return 'Учасників: $count';
  }

  @override
  String groupSelectedCount(int count) {
    return 'Вибрано: $count';
  }

  @override
  String get groupJoinRequestApprove => 'Погодитися';

  @override
  String get groupJoinRequestReject => 'Відхилити';

  @override
  String get groupJoinRequests => 'Заявки на вступ';

  @override
  String get groupNoJoinRequests => 'Немає заявок на вступ';

  @override
  String get groupReadReceipts => 'Звіти про прочитання';

  @override
  String groupReadCount(int count) {
    return 'Прочитали: $count';
  }

  @override
  String groupUnreadCount(int count) {
    return 'Непрочитаних: $count';
  }

  @override
  String get friendAddTitle => 'Додати контакт';

  @override
  String get friendSearchHint => 'Телефон / Email / StartLink ID';

  @override
  String get friendRequestSent => 'Запит у друзі надіслано';

  @override
  String get friendRequestFailed => 'Не вдалося надіслати. Спробуйте ще раз';

  @override
  String get friendAlreadyFriend => 'Уже в контактах';

  @override
  String get friendNewFriendsTitle => 'Нові друзі';

  @override
  String get friendNoRequests => 'Немає запитів у друзі';

  @override
  String get friendAccept => 'Прийняти';

  @override
  String get friendReject => 'Відхилити';

  @override
  String get friendAccepted => 'Прийнято';

  @override
  String get friendRejected => 'відхилено';

  @override
  String get friendDeleteConfirm => 'Видалити цей контакт?';

  @override
  String get friendDeleteSuccess => 'Контакт видалено';

  @override
  String get friendDeleteFailed => 'Не вдалося видалити. Спробуйте ще раз';

  @override
  String get friendRemarkName => 'Псевдонім';

  @override
  String get friendGroupName => 'Група';

  @override
  String get friendSendMessage => 'Повідомлення';

  @override
  String get friendMatchTypeLppId => 'Збіг за StartLink ID';

  @override
  String get friendMatchTypeMobile => 'Збіг за телефоном';

  @override
  String get friendMatchTypeEmail => 'Збіг за email';

  @override
  String get friendSearchEmpty => 'Користувачів не знайдено';

  @override
  String get friendAddMessage => 'Хочу додати вас до контактів';

  @override
  String get friendBlockConfirm => 'Заблокувати цього користувача?';

  @override
  String get friendUnblockConfirm => 'Розблокувати цього користувача?';

  @override
  String get friendBlockSuccess => 'Заблоковано';

  @override
  String get friendUnblockSuccess => 'Розблоковано';

  @override
  String get profilePageTitle => 'Персональні дані';

  @override
  String get profilePageSendMessage => 'Повідомлення';

  @override
  String get profilePageAddFriend => 'Додати в друзі';

  @override
  String get profilePageAlreadyFriend => 'Уже друзі';

  @override
  String get profilePageBlocked => 'Заблоковано';

  @override
  String get profilePageBlock => 'Заблокувати';

  @override
  String get profilePageUnblock => 'Розблокувати';

  @override
  String get profilePageHidden => 'Цей користувач приховав свій профіль';

  @override
  String get profilePageFriendsOnly =>
      'Цей користувач показує профіль лише друзям';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'Примітки';

  @override
  String get profilePageEditRemark => 'Змінити псевдонім';

  @override
  String get profilePageSaveRemarkSuccess => 'Псевдонім збережено';

  @override
  String get profilePageSaveRemarkFailed =>
      'Не вдалося зберегти. Спробуйте ще раз';

  @override
  String get searchTitle => 'Пошук';

  @override
  String get searchHint => 'Пошук за телефоном, email або StartLink ID';

  @override
  String get searchNoResults => 'Нічого не знайдено';

  @override
  String get searchMessages => 'Повідомлення';

  @override
  String get searchUsers => 'Користувачі';

  @override
  String get searchFailed => 'Помилка пошуку. Спробуйте ще раз';

  @override
  String get scanTitle => 'Сканувати';

  @override
  String get scanFailed => 'Помилка розпізнавання. Спробуйте ще раз';

  @override
  String get scanInvalidQrCode => 'Недійсний QR-код';

  @override
  String get scanFlashOn => 'Увімкнути ліхтарик';

  @override
  String get scanFlashOff => 'Вимкнути ліхтарик';

  @override
  String get scanAlbum => 'Вибрати з альбому';

  @override
  String get favoritesTitle => 'Вибране';

  @override
  String get favoritesEmpty => 'Ще нічого не збережено';

  @override
  String get favoritesAll => 'Всі';

  @override
  String get favoritesText => 'Текст';

  @override
  String get favoritesImage => 'Зображення';

  @override
  String get favoritesVideo => 'Відео';

  @override
  String get favoritesVoice => 'Голосові повідомлення';

  @override
  String get favoritesFile => 'Файли';

  @override
  String get favoritesOther => 'Інше';

  @override
  String get favoritesDeleteConfirm => 'Видалити з вибраного?';

  @override
  String get favoritesDeleteSuccess => 'Видалено зі збереженого';

  @override
  String get favoritesDeleteFailed => 'Не вдалося видалити';

  @override
  String get favoritesOriginalRecalled => 'Повідомлення відкликано';

  @override
  String get favoritesViewOriginal => 'Переглянути оригінал';

  @override
  String get favoritesSearchHint => 'Пошук у вибраному';

  @override
  String get favoritesNoResults => 'Немає відповідних елементів вибраного';

  @override
  String get noticeTitle => 'Оголошення';

  @override
  String get noticeEmpty => 'Немає оголошень';

  @override
  String get noticeDetail => 'Подробиці оголошення';

  @override
  String get noticePublishedAt => 'Опубліковано';

  @override
  String get noticePriorityNormal => 'Звичайний';

  @override
  String get noticePriorityImportant => 'Важливе';

  @override
  String get noticePriorityUrgent => 'Термінове';

  @override
  String get organizationTitle => 'Організація';

  @override
  String get organizationEmpty => 'Немає інформації про відділ';

  @override
  String get organizationMembers => 'Учасники';

  @override
  String get organizationDepartment => 'Відділ';

  @override
  String get organizationPosition => 'Посада';

  @override
  String get organizationLeader => 'Керівник';

  @override
  String get qrCodeTitle => 'Мій QR-код';

  @override
  String get qrCodeSave => 'Зберегти в альбом';

  @override
  String get qrCodeShare => 'Поділитися';

  @override
  String get qrCodeSaveSuccess => 'Збережено в альбомі';

  @override
  String get qrCodeSaveFailed => 'Не вдалося зберегти. Спробуйте ще раз';

  @override
  String get qrCodeRefresh => 'Оновити QR-код';

  @override
  String get qrCodeExpired => 'Строк QR-коду минув. Оновіть його';

  @override
  String get qrCodeScanToAdd => 'Скануйте, щоб додати мене до контактів';

  @override
  String get spacePersonal => 'Особистий';

  @override
  String get spaceEnterprise => 'Компанія';

  @override
  String get spaceJoinByCode => 'Вступити за кодом компанії';

  @override
  String get spaceJoinByInvite => 'Вступити за кодом запрошення';

  @override
  String get spaceEnterCode => 'Введіть код компанії';

  @override
  String get spaceEnterInviteCode => 'Введіть код запрошення';

  @override
  String get spaceSearchEnterprise => 'Знайти компанію';

  @override
  String get spaceJoinRequestSent => 'Заявку надіслано, очікує схвалення';

  @override
  String get spaceJoinRequestPending => 'Очікує схвалення';

  @override
  String get spaceJoinRequestApproved => 'Заявку схвалено';

  @override
  String get spaceJoinRequestRejected => 'Заявку відхилено';

  @override
  String get spaceAlreadyMember => 'Ви вже учасник';

  @override
  String get spaceAutoApproved => 'Схвалено автоматично. Вітаємо!';

  @override
  String get spacePendingApprovalHint =>
      'Реєстрацію завершено. Заявку на вступ надіслано.';

  @override
  String get spaceNoSpaces => 'Немає просторів';

  @override
  String get spaceInviteExpired => 'Строк коду запрошення минув';

  @override
  String get spaceInviteTargetMismatch =>
      'Цей код запрошення призначено не для вашого облікового запису';

  @override
  String get spaceAcceptInviteSuccess => 'Ви успішно вступили до компанії';

  @override
  String get spaceAcceptInviteFailed => 'Не вдалося вступити. Спробуйте ще раз';

  @override
  String get spaceTenantSelectTitle => 'Виберіть простір';

  @override
  String get spaceTenantSelectHint => 'Виберіть простір для входу';

  @override
  String get spaceEnterPersonal => 'Увійти до особистого простору';

  @override
  String get spaceEnterEnterprise => 'Увійти до простору компанії';

  @override
  String get aboutTitle => 'Про StartLink';

  @override
  String get aboutVersion => 'Версія';

  @override
  String get aboutTerms => 'Угода користувача';

  @override
  String get aboutPrivacy => 'Політика конфіденційності';

  @override
  String get aboutOpenSource => 'Ліцензії відкритого ПЗ';

  @override
  String get aboutCheckUpdate => 'Перевірити оновлення';

  @override
  String get aboutLatestVersion => 'Ви використовуєте останню версію';

  @override
  String get aboutUpdateAvailable => 'Доступна нова версія';

  @override
  String get aboutUpdateNow => 'Оновити зараз';

  @override
  String get aboutUpdateLater => 'Пізніше';

  @override
  String get notificationTitle => 'Сповіщення';

  @override
  String get notificationGlobalMute => 'Не турбувати';

  @override
  String get notificationSound => 'Звук';

  @override
  String get notificationVibration => 'Вібрація';

  @override
  String get notificationPreview => 'Попередній перегляд повідомлень';

  @override
  String get notificationDndStart => 'Початок режиму «Не турбувати»';

  @override
  String get notificationDndEnd => 'Завершення режиму «Не турбувати»';

  @override
  String get blacklistTitle => 'У чорному списку';

  @override
  String get blacklistEmpty => 'Немає заблокованих користувачів';

  @override
  String get blacklistRemove => 'Розблокувати';

  @override
  String get blacklistRemoveConfirm => 'Розблокувати цього користувача?';

  @override
  String get feedbackTitle => 'Зворотний зв’язок';

  @override
  String get feedbackTypeComplaint => 'Скарга';

  @override
  String get feedbackTypeSuggestion => 'Пропозиція';

  @override
  String get feedbackTypeBug => 'Повідомити про помилку';

  @override
  String get feedbackContent => 'Опис';

  @override
  String get feedbackContentHint => 'Докладно опишіть проблему або пропозицію';

  @override
  String get feedbackContact => 'Контакт (необов’язково)';

  @override
  String get feedbackSubmit => 'Надіслати';

  @override
  String get feedbackSuccess => 'Відгук надіслано. Дякуємо!';

  @override
  String get feedbackFailed => 'Не вдалося надіслати. Спробуйте ще раз';

  @override
  String get networkTitle => 'Змінити лінію';

  @override
  String get networkAutoSelect => 'Авто';

  @override
  String get networkManual => 'Вручну';

  @override
  String get timezoneTitle => 'Часовий пояс';

  @override
  String get timezoneAuto => 'Як у системі';

  @override
  String get autoTranslateTitle => 'Автопереклад';

  @override
  String get autoTranslateEnabled => 'Увімкнути автопереклад';

  @override
  String get autoTranslateLanguage => 'Мова перекладу';

  @override
  String get displayTitle => 'Відображення';

  @override
  String get displayFontSize => 'Розмір шрифту';

  @override
  String get displayChatBackground => 'Тло чату';

  @override
  String get displayDarkMode => 'Оформлення';

  @override
  String get displayDarkModeSystem => 'Як у системі';

  @override
  String get displayDarkModeSystemHint =>
      'Автоматично змінювати за налаштуваннями системи';

  @override
  String get displayDarkModeOff => 'Світла';

  @override
  String get displayDarkModeOffHint => 'Завжди використовувати світлу тему';

  @override
  String get displayDarkModeOn => 'Темна';

  @override
  String get displayDarkModeOnHint => 'Завжди використовувати темну тему';

  @override
  String get chatSettingsTitle => 'Чат';

  @override
  String get chatHistoryTitle => 'Історія чату';

  @override
  String get chatHistoryClear => 'Очистити всю історію';

  @override
  String get chatHistoryClearConfirm =>
      'Очистити всю історію чатів? Ця дія незворотна.';

  @override
  String get chatHistoryClearSuccess => 'Історію чатів очищено';

  @override
  String get accountSecurityTitle => 'Безпека облікового запису';

  @override
  String get accountSecurityChangePassword => 'Змінити пароль';

  @override
  String get accountSecurityChangeMobile => 'Змінити номер телефону';

  @override
  String get accountSecurityChangeEmail => 'Змінити email';

  @override
  String get accountSecurityLoggedDevices => 'Пристрої з виконаним входом';

  @override
  String get accountSecurityDeactivate => 'Видалити обліковий запис';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Усі дані буде безповоротно видалено через 7 днів. Видалити обліковий запис?';

  @override
  String get loggedDevicesTitle => 'Пристрої з виконаним входом';

  @override
  String get loggedDevicesCurrent => 'Цей пристрій';

  @override
  String get loggedDevicesRevoke => 'Вийти';

  @override
  String get loggedDevicesRevokeConfirm => 'Вийти на цьому пристрої?';

  @override
  String get loggedDevicesRevokeSuccess => 'Виконано вихід на пристрої';

  @override
  String get loggedDevicesRevokeFailed => 'Не вдалося. Спробуйте ще раз';

  @override
  String get loggedDevicesLastActive => 'Остання активність';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Веб';

  @override
  String get loggedDevicesTypeDesktop => 'Комп’ютер';

  @override
  String get loggedDevicesTypeUnknown => 'Невідомий пристрій';

  @override
  String get privacySettingsTitle => 'Конфіденційність';

  @override
  String get privacySearchableByMobile => 'Дозволити пошук за номером телефону';

  @override
  String get privacySearchableByLppId => 'Дозволити пошук за StartLink ID';

  @override
  String get privacyAllowFriendRequest => 'Дозволити запити в друзі';

  @override
  String get privacyProfileVisibility => 'Видимість профілю';

  @override
  String get privacyEveryone => 'Усі';

  @override
  String get privacyFriendsOfFriends => 'Друзі друзів';

  @override
  String get privacyNobody => 'Ніхто';

  @override
  String get privacyFriendsOnly => 'Лише друзі';

  @override
  String get privacySaveSuccess => 'Налаштування збережено';

  @override
  String get privacySaveFailed => 'Не вдалося зберегти. Спробуйте ще раз';

  @override
  String get fontSizeTitle => 'Розмір шрифту';

  @override
  String get fontSizeSmall => 'Малий';

  @override
  String get fontSizeNormal => 'Стандартний';

  @override
  String get fontSizeLarge => 'Великий';

  @override
  String get fontSizeExtraLarge => 'Надвеликий';

  @override
  String get fontSizePreview => 'Перегляд';

  @override
  String get chatBackgroundTitle => 'Тло чату';

  @override
  String get chatBackgroundDefault => 'За замовчуванням';

  @override
  String get chatBackgroundCustom => 'Власне';

  @override
  String get chatBackgroundReset => 'Відновити типові налаштування';

  @override
  String get termsTitle => 'Угода користувача';

  @override
  String get privacyPolicyTitle => 'Політика конфіденційності';

  @override
  String get recentContactsTitle => 'Нещодавні';

  @override
  String get recentContactsEmpty => 'Немає нещодавніх контактів';

  @override
  String get inviteFriendsTitle => 'Запросити друзів';

  @override
  String get inviteFriendsCopyLink => 'Копіювати посилання запрошення';

  @override
  String get inviteFriendsLinkCopied => 'Посилання запрошення скопійовано';

  @override
  String get imageViewerTitle => 'Фото';

  @override
  String get imageViewerSave => 'Зберегти в альбом';

  @override
  String get imageViewerSaveSuccess => 'Збережено в альбомі';

  @override
  String get imageViewerSaveFailed => 'Не вдалося зберегти. Спробуйте ще раз';

  @override
  String get customerServiceTitle => 'Служба підтримки';

  @override
  String get customerServiceQueue => 'У черзі';

  @override
  String get customerServiceActive => 'Активні';

  @override
  String get customerServiceClaim => 'Прийняти';

  @override
  String get customerServiceTakeover => 'Перехопити';

  @override
  String get customerServiceClose => 'Завершити обслуговування';

  @override
  String get customerServiceCloseConfirm =>
      'Завершити цей сеанс обслуговування?';

  @override
  String get customerServiceNoQueue => 'Немає сеансів у черзі';

  @override
  String get customerServiceNoActive => 'Немає активних сеансів';

  @override
  String get customerServiceVisitor => 'Відвідувач';

  @override
  String get customerServiceCustomer => 'Клієнт';

  @override
  String get customerServiceAssignedTo => 'Призначено';

  @override
  String get customerServiceTransferConversation => 'Передати чат';

  @override
  String get marketingToolbar => 'Маркетингові інструменти';

  @override
  String get callIncoming => 'Вхідний дзвінок';

  @override
  String get callOutgoing => 'Вихідний дзвінок';

  @override
  String get callAccept => 'Прийняти';

  @override
  String get callReject => 'Відхилити';

  @override
  String get callHangup => 'Завершити';

  @override
  String get callMissed => 'Пропущений дзвінок';

  @override
  String get callDuration => 'Тривалість';

  @override
  String get callAudio => 'Голосовий дзвінок';

  @override
  String get callGeneric => 'Дзвінок';

  @override
  String get callVideo => 'Відеодзвінок';

  @override
  String get callConnecting => 'Підключення...';

  @override
  String get callRinging => 'Виклик...';

  @override
  String get callEnded => 'Дзвінок завершено';

  @override
  String get callFailed => 'Помилка дзвінка';

  @override
  String get callRejected => 'Дзвінок відхилено';

  @override
  String get callTimeout => 'Немає відповіді';

  @override
  String get callCancelled => 'Скасовано';

  @override
  String get callUnknownPeer => 'Невідомо';

  @override
  String get callVideoInvitation => 'Запрошення на відеодзвінок';

  @override
  String get callAudioInvitation => 'Запрошення на голосовий дзвінок';

  @override
  String get callAnswerAudio => 'Відповісти голосом';

  @override
  String get callAnswerVideo => 'Відповісти з відео';

  @override
  String get callViewProfile => 'Переглянути профіль';

  @override
  String get callOpeningCamera => 'Увімкнення камери...';

  @override
  String get callWaitingRemoteVideo => 'Очікування відео співрозмовника...';

  @override
  String get callCameraOff => 'Камеру вимкнено';

  @override
  String get callCameraOn => 'Камеру ввімкнено';

  @override
  String get callMicrophoneOff => 'Мікрофон вимкнено';

  @override
  String get callMicrophoneOn => 'Мікрофон увімкнено';

  @override
  String get callSpeakerOff => 'Динамік вимкнено';

  @override
  String get callSpeakerOn => 'Динамік увімкнено';

  @override
  String get callVideoPermissionFailure =>
      'Не вдалося почати відеодзвінок. Перевірте дозволи на камеру й мікрофон і спробуйте ще раз.';

  @override
  String get callAudioPermissionFailure =>
      'Не вдалося почати голосовий дзвінок. Перевірте дозвіл на мікрофон і спробуйте ще раз.';

  @override
  String get callIncompleteIncoming =>
      'Інформація про вхідний дзвінок неповна. Відповісти неможливо.';

  @override
  String get callInProgress => 'Розмова';

  @override
  String get callCalling => 'Виклик...';

  @override
  String callEndedMedia(String media) {
    return '$media завершено';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media відхилено';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media залишився без відповіді';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media скасовано';
  }

  @override
  String get callConnectionLost => 'З’єднання дзвінка втрачено';

  @override
  String get callAdminEnded => 'Дзвінок завершив адміністратор';

  @override
  String callFailedMedia(String media) {
    return '$media: помилка';
  }

  @override
  String get callBusy => 'Співрозмовник зайнятий';

  @override
  String callDurationValue(String duration) {
    return 'Тривалість дзвінка $duration';
  }

  @override
  String get callNotConnected => 'Немає з’єднання';

  @override
  String get callDialed => 'Вихідний';

  @override
  String get callAnswered => 'Прийнято';

  @override
  String get callRejectedByPeer => 'Відхилено співрозмовником';

  @override
  String get callRejectedBySelf => 'відхилено';

  @override
  String get callPeerDidNotAnswer => 'Співрозмовник не відповів';

  @override
  String get callMissedIncoming => 'Пропущений вхідний дзвінок';

  @override
  String get callPeerCancelled => 'Скасовано співрозмовником';

  @override
  String get notificationNewMessageTitle => 'Нове повідомлення StartLink';

  @override
  String get notificationOnlineServiceTitle => 'Нове повідомлення підтримки';

  @override
  String get notificationNewMessageBody => 'Ви отримали нове повідомлення';

  @override
  String get notificationImagePreview => 'Надіслано зображення';

  @override
  String get notificationVideoPreview => 'Надіслано відео';

  @override
  String get notificationVoicePreview => 'Надіслано голосове повідомлення';

  @override
  String get notificationFilePreview => 'Надіслано файл';

  @override
  String get notificationContactPreview => 'Надіслано картку контакту';

  @override
  String get notificationCallLogPreview => 'Надіслано запис дзвінка';

  @override
  String get notificationLocationPreview => 'Надіслано місцезнаходження';

  @override
  String get notificationLinkPreview => 'Надіслано посилання';

  @override
  String notificationMentionMe(String body) {
    return 'Вас згадали: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender згадує вас: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Згадали всіх: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender згадує всіх: $body';
  }

  @override
  String get notificationSecurityTitle =>
      'Попередження безпеки облікового запису';

  @override
  String get notificationSecurityBody =>
      'Налаштування безпеки облікового запису StartLink змінено. Перевірте їх зараз.';

  @override
  String get notificationFriendAcceptedTitle => 'Запит у друзі прийнято';

  @override
  String get notificationFriendRejectedTitle => 'Запит у друзі відхилено';

  @override
  String get notificationFriendAcceptedBody =>
      'Співрозмовник прийняв ваш запит у друзі';

  @override
  String get notificationFriendRejectedBody =>
      'Співрозмовник відхилив ваш запит у друзі';

  @override
  String get notificationVideoCallTitle => 'Запрошення на відеодзвінок';

  @override
  String get notificationAudioCallTitle => 'Запрошення на голосовий дзвінок';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller запрошує вас на відеодзвінок';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller запрошує вас на голосовий дзвінок';
  }

  @override
  String get notificationMessageChannelName => 'Повідомлення';

  @override
  String get notificationMessageChannelDescription =>
      'Повідомлення чатів, записи дзвінків і системні сповіщення';

  @override
  String get notificationCallChannelName => 'Дзвінки';

  @override
  String get notificationCallChannelDescription =>
      'Сповіщення про голосові та відеодзвінки';

  @override
  String get notificationSecurityChannelName => 'Безпека облікового запису';

  @override
  String get notificationSecurityChannelDescription =>
      'Сповіщення про вхід, зміну пароля й номера телефону';

  @override
  String get notificationUnknownCaller => 'Невідомий абонент';

  @override
  String get pendingJoinRequestsTitle => 'Нові заявки';

  @override
  String get pendingJoinRequestsEmpty => 'Немає заявок';

  @override
  String get pendingJoinRequestApprove => 'Погодитися';

  @override
  String get pendingJoinRequestReject => 'Відхилити';

  @override
  String get pendingJoinRequestApproveSuccess => 'Схвалено';

  @override
  String get pendingJoinRequestRejectSuccess => 'Відхилено';

  @override
  String get pendingJoinRequestFailed =>
      'Не вдалося виконати дію. Спробуйте ще раз';

  @override
  String get myCustomersTitle => 'Мої клієнти';

  @override
  String get myCustomersEmpty => 'Немає клієнтів';

  @override
  String get groupListTitle => 'Групи';

  @override
  String get groupListEmpty => 'Немає груп';

  @override
  String get addFriendTitle => 'Додати контакт';

  @override
  String get addFriendSearchHint => 'Телефон / Email / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'Додати';

  @override
  String get addFriendCannotAddSelf => 'Не можна додати себе';

  @override
  String get addFriendUnsupportedUser =>
      'Цього користувача не можна додати. Ви можете написати йому безпосередньо.';

  @override
  String get addFriendMessageHint => 'Введіть повідомлення';

  @override
  String get addFriendSendRequest => 'Надіслати запит';

  @override
  String get joinCompanyTitle => 'Вступити до компанії';

  @override
  String get joinCompanyCodeHint => 'Введіть код компанії';

  @override
  String get joinCompanySearchHint => 'Пошук за назвою компанії';

  @override
  String get joinCompanyApply => 'Подати заявку на вступ';

  @override
  String get joinCompanyApplySuccess => 'Заявку надіслано';

  @override
  String get joinCompanyApplyFailed =>
      'Не вдалося подати заявку. Спробуйте ще раз';

  @override
  String get joinCompanyAutoApproved => 'Схвалено автоматично. Вітаємо!';

  @override
  String get joinCompanyPending => 'Заявку надіслано, очікує схвалення';

  @override
  String get joinCompanyInviteCodeHint => 'Введіть код запрошення';

  @override
  String get joinCompanyAcceptInvite => 'Прийняти запрошення';

  @override
  String get joinCompanyNoResults => 'Компаній не знайдено';

  @override
  String joinCompanyMemberCount(int count) {
    return 'Учасників: $count';
  }

  @override
  String get timezoneNameHawaii => 'Гаваї';

  @override
  String get timezoneNameAlaska => 'Аляска';

  @override
  String get timezoneNamePacificTime => 'Тихоокеанський час';

  @override
  String get timezoneNameMountainTime => 'Гірський час';

  @override
  String get timezoneNameCentralTime => 'Центральний час';

  @override
  String get timezoneNameEasternTime => 'Східний час';

  @override
  String get timezoneNameAtlanticTime => 'Атлантичний час';

  @override
  String get timezoneNameBrasilia => 'Бразиліа';

  @override
  String get timezoneNameAzores => 'Азорські острови';

  @override
  String get timezoneNameLondonDublin => 'Лондон/Дублін';

  @override
  String get timezoneNameBerlinParisRome => 'Берлін/Париж/Рим';

  @override
  String get timezoneNameCairoHelsinki => 'Каїр/Гельсінкі';

  @override
  String get timezoneNameMoscowRiyadh => 'Москва/Ер-Ріяд';

  @override
  String get timezoneNameTehran => 'Тегеран';

  @override
  String get timezoneNameDubaiBaku => 'Дубай/Баку';

  @override
  String get timezoneNameKabul => 'Кабул';

  @override
  String get timezoneNameKarachiTashkent => 'Карачі/Ташкент';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Мумбаї/Нью-Делі';

  @override
  String get timezoneNameKathmandu => 'Катманду';

  @override
  String get timezoneNameDhakaAlmaty => 'Дакка/Алмати';

  @override
  String get timezoneNameYangon => 'Янгон';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Бангкок/Ханой/Джакарта';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Пекін/Шанхай/Гонконг/Тайбей';

  @override
  String get timezoneNameTokyoSeoul => 'Токіо/Сеул';

  @override
  String get timezoneNameAdelaide => 'Аделаїда';

  @override
  String get timezoneNameSydneyMelbourne => 'Сідней/Мельбурн';

  @override
  String get timezoneNameSolomonIslands => 'Соломонові Острови';

  @override
  String get timezoneNameAucklandFiji => 'Окленд/Фіджі';

  @override
  String get networkSmartSelectBestRoute =>
      'Розумний вибір найкращого маршруту';

  @override
  String get networkTesting => 'Перевірка...';

  @override
  String get networkTestingShort => 'Перевірка';

  @override
  String networkLatencyMs(int ms) {
    return 'Затримка $ms мс';
  }

  @override
  String get networkConnectionMode => 'Режим підключення';

  @override
  String get networkDirectMode => 'Прямий режим';

  @override
  String get networkProxyMode => 'Через проксі';

  @override
  String get networkDirectModeDesc => 'Пряме підключення до сервера';

  @override
  String get networkProxyModeDesc => 'Підключення через проксі-сервер';

  @override
  String get networkDirectRoutes => 'Прямі маршрути';

  @override
  String get networkProxyRoutes => 'Проксі-маршрути';

  @override
  String get networkTestAll => 'Перевірити всі';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Вузол у Гонконгу';

  @override
  String get networkSingaporeNode => 'Вузол у Сінгапурі';

  @override
  String get networkJapanNode => 'Вузол у Японії';

  @override
  String get networkUnitedStatesNode => 'Вузол у США';

  @override
  String get networkHint =>
      'Поради:\n• Прямий режим швидший і підходить для використання всередині країни\n• Проксі-режим стабільніший для міжнародного зв’язку\n• Натисніть значок оновлення, щоб перевірити затримку окремого маршруту';

  @override
  String get teenModeTitle => 'Підлітковий режим';

  @override
  String get teenModeStatusOn => 'Увімкнено';

  @override
  String get teenModeStatusOff => 'Вимкнено';

  @override
  String get teenModeStatusLoading => 'Завантаження';

  @override
  String get teenModeUnavailable =>
      'Статус підліткового режиму тимчасово недоступний';

  @override
  String get teenModeInvalidResponse =>
      'Підлітковий режим повернув некоректну відповідь';

  @override
  String get teenModeEnableDescription =>
      'Правила платформи обмежать час використання та окремі функції.';

  @override
  String get teenModePasscode => 'Код-пароль';

  @override
  String get teenModeCurrentPasscode => 'Поточний код-пароль';

  @override
  String get teenModeNewPasscode => 'Новий код-пароль';

  @override
  String get teenModePasscodeHint => 'Введіть 4–6 цифр';

  @override
  String get teenModeEnable => 'Увімкнути підлітковий режим';

  @override
  String get teenModeDisable => 'Вимкнути підлітковий режим';

  @override
  String get teenModeChangePasscode => 'Змінити код-пароль';

  @override
  String get teenModeSource => 'Увімкнено користувачем';

  @override
  String get teenModeDailyUsage => 'Використано сьогодні';

  @override
  String get teenModeRemaining => 'Залишилося часу';

  @override
  String get teenModeMinutesUnit => 'Хвилини';

  @override
  String get teenModeUnlimited => 'Без обмежень';

  @override
  String get teenModeRequestExtension => 'Запросити більше часу';

  @override
  String get teenModeExtensionSubmitted => 'Запит часу надіслано опікуну';

  @override
  String get teenModeTimeLimitReached => 'Денний ліміт використання вичерпано';

  @override
  String get teenModeCurfewActive => 'Зараз період обмеженого використання';

  @override
  String get teenModeReliefHint =>
      'Ви й далі можете переглядати історію, звертатися до офіційної підтримки та повідомляти про проблеми.';

  @override
  String get teenModeRestrictedNotice =>
      'Підлітковий режим зараз забороняє надсилати повідомлення';

  @override
  String get teenModeActionBlocked =>
      'Підлітковий режим зараз забороняє цю дію';

  @override
  String get teenModeMyRequests => 'Мої запити';

  @override
  String get guardianCenterTitle => 'Центр опікуна';

  @override
  String get guardianRelationships => 'Зв’язки з опікунами';

  @override
  String get guardianMinors => 'Діти під моїм наглядом';

  @override
  String get guardianApprovals => 'Очікують схвалення';

  @override
  String get guardianBind => 'Введіть код прив’язки';

  @override
  String get guardianCreateMinorCode => 'Я дитина — створити код';

  @override
  String get guardianCreateGuardianCode => 'Я опікун — створити код';

  @override
  String get guardianRelation => 'Зв’язок';

  @override
  String get guardianPrimary => 'Основний опікун';

  @override
  String get guardianCode => '6-значний код прив’язки';

  @override
  String get guardianCodeHint => 'Введіть код від іншої людини';

  @override
  String get guardianCodeCreated =>
      'Код створено. Поділіться ним до завершення строку дії.';

  @override
  String get guardianEmpty => 'Немає зв’язків з опікунами';

  @override
  String get guardianNoMinors => 'Немає дітей під наглядом';

  @override
  String get guardianUnbind => 'Видалити зв’язок';

  @override
  String get guardianExtend => 'Додати час дитині';

  @override
  String get guardianPolicyTitle => 'Правила використання';

  @override
  String get guardianPolicyLocked => 'Заблоковано платформою';

  @override
  String get approvalEmpty => 'Немає запитів';

  @override
  String get approvalApprove => 'Погодитися';

  @override
  String get approvalReject => 'Відхилити';

  @override
  String get approvalPending => 'Очікує';

  @override
  String get approvalApproved => 'Схвалено';

  @override
  String get approvalRejected => 'відхилено';

  @override
  String get approvalExpired => 'просрочений';

  @override
  String get approvalCancelled => 'Скасовано';

  @override
  String get approvalReplayFailed => 'Початкову дію не виконано. Повторіть її.';

  @override
  String get requestCancelled => 'Запит скасовано';

  @override
  String get kycTitle => 'Підтвердження особи';

  @override
  String get kycNotRequired => 'Підтвердження особи не потрібне';

  @override
  String get kycVerified => 'Особу підтверджено';

  @override
  String get kycDeclared => 'Дані про особу надіслано';

  @override
  String get kycPending => 'На розгляді';

  @override
  String get kycRejected => 'Перевірку відхилено';

  @override
  String get kycNone => 'Дані про особу не надіслано';

  @override
  String get kycRealName => 'Повне ім\'я';

  @override
  String get kycIdNumber => 'Номер ідентифікаційного документа';

  @override
  String get kycIdType => 'Тип документа';

  @override
  String get kycApplicability =>
      'Введіть справжні дані для вибраного документа. Допустимі типи вказано у списку.';

  @override
  String get kycCamera => 'Зробити фото';

  @override
  String get kycGallery => 'Вибрати з галереї';

  @override
  String get kycPhotoLimit => 'Максимум на фото';

  @override
  String get kycSelectPhoto => 'Вибрати фото';

  @override
  String get kycPhotoSelected => 'Вибрано';

  @override
  String get kycViewPhoto => 'Натисніть, щоб переглянути фото';

  @override
  String get kycReplacePhoto => 'Вибрати інше фото';

  @override
  String get kycDisclosure =>
      'Ми використовуємо ім’я, номер документа й фотографії документа для перевірки особи. Без них не можна подати заявку, а деякі обмежені функції можуть бути недоступні.';

  @override
  String get kycConsent => 'Я окремо погоджуюся на обробку цих даних про особу';

  @override
  String get kycConsentRequired => 'Перед надсиланням надайте окрему згоду';

  @override
  String get kycResubmitTitle => 'Повторно надіслати дані про особу';

  @override
  String get kycResubmitWarning =>
      'Повторне надсилання замінить заявку, що очікує. Продовжити?';

  @override
  String get kycSubmitting => 'Надсилання';

  @override
  String get kycSubmitFailed => 'Не вдалося надіслати. Спробуйте ще раз.';

  @override
  String get kycSubmitUnavailable => 'Зараз не можна надіслати дані про особу';

  @override
  String get kycResubmitNotAllowed =>
      'Повторне надсилання після відмови недоступне. За потреби зверніться до підтримки.';

  @override
  String get kycDailyLimit =>
      'Денний ліміт надсилань вичерпано. Спробуйте завтра.';

  @override
  String get kycTypeUnavailable =>
      'Немає доступних типів документів. Спробуйте пізніше.';

  @override
  String get kycNameInvalid => 'Офіційне ім’я має містити 2–64 символи';

  @override
  String get kycNumberRequired => 'Введіть номер документа';

  @override
  String get kycFrontRequired => 'Завантажте лицьовий бік документа';

  @override
  String get kycBackRequired => 'Завантажте зворотний бік документа';

  @override
  String get kycPhotoTooLarge =>
      'Фото перевищує допустимий розмір. Стисніть його та спробуйте ще раз.';

  @override
  String get kycAccountChanged =>
      'Обліковий запис або простір змінився. Відкрийте сторінку знову.';

  @override
  String get kycPhotoInvalid => 'Виберіть коректне зображення';

  @override
  String get kycPortraitSide => 'Бік із портретом';

  @override
  String get kycEmblemSide => 'Бік із гербом';

  @override
  String get kycPassportDataPage => 'Сторінка паспорта з даними';

  @override
  String get kycPassportOtherPage => 'Візова або порожня сторінка паспорта';

  @override
  String get kycFront => 'Лицьова сторона посвідчення';

  @override
  String get kycBack => 'Зворотний бік посвідчення';

  @override
  String get kycRequired => 'Перед створенням групи потрібно підтвердити особу';

  @override
  String get kycGoVerify => 'Підтвердити зараз';

  @override
  String get kycStatusUnknown => 'Статус особи недоступний. Оновіть пізніше.';

  @override
  String get kycSuperseded =>
      'Пізніше надсилання замінило це. Перевірте актуальний статус особи.';

  @override
  String get kycMediaNotFound =>
      'Фото документа недоступне в цьому просторі. Виберіть його повторно перед надсиланням.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Розсилка клієнтам';

  @override
  String get officialAccountBadge => 'Офіційний';

  @override
  String get officialAccountOpenConversation => 'Відкрити розмову';

  @override
  String get officialAccountJoinHint =>
      'Додавання цього облікового запису приєднає вас до компанії як клієнта. Схвалення дружби не потрібне.';

  @override
  String get officialAccountJoinDisabled =>
      'Ця компанія не приймає нових клієнтів. Зверніться до підтримки.';

  @override
  String get officialAccountRemoved =>
      'Вас видалено з цієї компанії. Попросіть компанію запросити вас знову.';

  @override
  String get officialAccountBanned =>
      'Ваш обліковий запис вимкнено в цій компанії.';

  @override
  String get officialAccountUnavailable =>
      'Цей офіційний обліковий запис зараз недоступний.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'У поточному режимі не можна вступати до компаній.';

  @override
  String get officialAccountPlatformRequired =>
      'Використайте обліковий запис платформи для додавання цього офіційного облікового запису.';

  @override
  String get officialAccountOpenFailed =>
      'Не вдалося відкрити розмову. Спробуйте ще раз.';

  @override
  String get officialAccountAccountChanged =>
      'Обліковий запис або простір змінився. Відкрийте знову.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Каталог компанії не оновлено. Спробуйте трохи пізніше.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Не вдалося синхронізувати офіційний обліковий запис. Локальні дані доступні.';

  @override
  String get officialAccountInboxSyncing =>
      'Синхронізація повідомлень офіційного облікового запису';

  @override
  String get diagnosticsTitle => 'Діагностика';

  @override
  String get diagnosticsExplanation =>
      'Журнали очищено від чутливих даних; вони містять відомості про операції та помилки цього облікового запису й простору, а також спільні події запуску. Вміст чатів і облікові дані не додаються.';

  @override
  String get diagnosticsHour => 'За останню годину';

  @override
  String get diagnosticsDay => 'За останні 24 години';

  @override
  String get diagnosticsWeek => '7 дн.';

  @override
  String diagnosticsEventCount(int count) {
    return 'Доступно подій: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Журнали зберігаються на цьому пристрої та доступні після перезапуску.';

  @override
  String get diagnosticsNotPersistent =>
      'Деякі записи не збережено. Оновіть для повторної спроби.';

  @override
  String get diagnosticsExport => 'Експортувати й поділитися';

  @override
  String get diagnosticsRefresh => 'Оновити';

  @override
  String get diagnosticsClear => 'Очистити журнали цього простору';

  @override
  String get diagnosticsClearConfirm =>
      'Очистити діагностичні журнали цього простору? Історія чатів збережеться.';

  @override
  String get diagnosticsShared =>
      'Системне поширення завершено. Перевірте файл у застосунку-одержувачі.';

  @override
  String get diagnosticsCancelled =>
      'Поширення скасовано. Можна експортувати знову.';

  @override
  String get diagnosticsUnconfirmed =>
      'Не вдалося підтвердити поширення. Перевірте застосунок-одержувач.';

  @override
  String get diagnosticsFailed => 'Не вдалося виконати дію. Спробуйте ще раз.';
}
