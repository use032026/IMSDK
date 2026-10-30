// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get navWorkbench => 'Работен панел';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Данните на профила не бяха заредени';

  @override
  String get startupFailureTitle => 'Стартирането е неуспешно';

  @override
  String get startupFailureMessage => 'Проверете мрежата и опитайте отново';

  @override
  String get privacyConsentTitle => 'Общи условия и Политика за поверителност';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Добре дошли в $brand. За да предоставяме вход в профила, незабавни съобщения, фирмено сътрудничество, онлайн обслужване на клиенти, известия за съобщения и защита, трябва да обработваме необходимата информация съгласно Условията за ползване и Политиката за поверителност.\n\nПреди да натиснете „Съгласен съм“, няма да четем клипборда, да инициализираме JPush/JCore или SDK за известия на производителите на устройства, нито чрез тях да получаваме Android ID, OAID, списъци с инсталирани приложения, MAC адреси или подобна информация. Ако засега откажете, ще запазим избора ви; можете да продължите да четете документите и да решите по-късно.\n\nСлед съгласие, за известия за съобщения, обслужване и входящи повиквания, JPush/JCore и услугите на производителите могат да обработват модел на устройството, версия на Android, име на пакета и версия на приложението, тип мрежа, IP адрес, Android ID, OAID, Registration ID за известия, токен на производителя и данни за доставяне и отваряне на известия. Изключили сме ненужните възможности, включително интелигентни известия, списъци с инсталирани приложения, MAC, IMEI, IMSI, Wi-Fi списъци, автоматично събуждане и свързано стартиране.\n\nКлипбордът се използва само когато сами използвате копиране или поставяне. Разрешения за камера, микрофон, известия и други системни функции се искат само при използване на съответната функция. Отказът на отделно разрешение засяга само нея. Прочетете пълните документи по-долу и сами решете дали сте съгласни.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Добре дошли в $brand. За да предоставяме вход в профила, незабавни съобщения, фирмено сътрудничество, онлайн обслужване на клиенти, известия за съобщения и защита, трябва да обработваме необходимата информация съгласно Условията за ползване и Политиката за поверителност.\n\nПреди да натиснете „Съгласен съм“, няма да четем клипборда, да инициализираме JPush/JCore, да се регистрираме в Apple Push Notification service (APNs), нито да получаваме идентификатори за известия като JPush Registration ID или APNs токен на устройството. Ако засега откажете, ще запазим избора ви; можете да продължите да четете документите и да решите по-късно.\n\nСлед съгласие, за известия за съобщения, обслужване и входящи повиквания можем да обработваме модел на iPhone, версия на iOS, име на пакета и версия на приложението, тип мрежа, IP адрес, IDFV, JPush Registration ID, APNs токен на устройството и данни за доставяне и отваряне на известия. JPush/JCore осъществява връзката с услугата за известия; Apple APNs обработва идентификатора на приложението, токена на устройството и съдържанието на известието за системното му доставяне. Текущото приложение за iOS не използва рекламни услуги и не получава IDFA.\n\nКлипбордът се използва само когато сами използвате копиране или поставяне. Разрешения за камера, микрофон, известия и други системни функции се искат само при използване на съответната функция. Отказът на отделно разрешение засяга само нея. Прочетете пълните документи по-долу и сами решете дали сте съгласни.';
  }

  @override
  String get privacyConsentTermsLink => 'Потребителско споразумение';

  @override
  String get privacyConsentConjunction => 'и';

  @override
  String get privacyConsentPrivacyLink => 'Политика за поверителност';

  @override
  String get privacyConsentDecline => 'Не съм съгласен';

  @override
  String get privacyConsentDeclinedExit =>
      'Не приехте Условията за ползване и Политиката за поверителност. Приложението ще се затвори.';

  @override
  String get privacyConsentAccept => 'Съгласен съм';

  @override
  String get privacyConsentRuntimeFailure =>
      'Стартирането е неуспешно. Проверете мрежата и опитайте отново.';

  @override
  String get privacyConsentSaveFailure =>
      'Изборът ви не беше запазен. Опитайте отново.';

  @override
  String get appUpdateRequiredTitle =>
      'Необходима е актуализация, за да продължите';

  @override
  String get appUpdateOptionalTitle => 'Налична е нова версия';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Налична е версия $brand $version';
  }

  @override
  String get appUpdateLater => 'По-късно';

  @override
  String get appUpdateNow => 'Обновете сега';

  @override
  String get appUpdateProcessing => 'Обработка...';

  @override
  String get appUpdateInvalidUrl =>
      'Адресът за актуализация е невалиден. Опитайте по-късно.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Връзката за актуализация не беше отворена. Опитайте по-късно.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Изтеглянето е прекъснато. Проверете мрежата и опитайте отново.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Проверката на пакета е неуспешна. Изтеглете го отново.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Разрешете на $brand да инсталира актуализации в системните настройки.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Системният инсталатор не беше отворен. Проверете разрешенията за инсталиране.';

  @override
  String get appUpdateGenericFailure =>
      'Актуализацията е неуспешна. Проверете мрежата и опитайте отново.';

  @override
  String get appUpdateUnavailable =>
      'Новата версия все още не може да се изтегли. Опитайте по-късно.';

  @override
  String get appUpdateCheckFailed =>
      'Неуспешна проверка за актуализации. Опитайте по-късно.';

  @override
  String get appUpdateChecking => 'Проверка';

  @override
  String get commonConfirm => 'ОК';

  @override
  String get commonCancel => 'Отказ';

  @override
  String get commonSave => 'Запази';

  @override
  String get commonEdit => 'Редактиране';

  @override
  String get commonDelete => 'Изтрий';

  @override
  String get commonSearch => 'Търсене';

  @override
  String get commonLoading => 'Зареждане...';

  @override
  String get commonLoadFailed => 'Неуспешно зареждане';

  @override
  String get commonRetry => 'Опитай отново';

  @override
  String get commonEmpty => 'Няма данни';

  @override
  String get commonCopy => 'Копиране';

  @override
  String get commonForward => 'Препрати';

  @override
  String get commonFavorite => 'Запази';

  @override
  String get commonClose => 'Затвори';

  @override
  String get commonSend => 'Изпрати';

  @override
  String get commonDone => 'Готово';

  @override
  String get commonMore => 'Още';

  @override
  String get commonSettings => 'Настройки';

  @override
  String get commonCopied => 'Копирано';

  @override
  String get commonUnknown => 'Неизвестно';

  @override
  String get commonNotSet => 'Не е зададено';

  @override
  String get commonUnbound => 'Не е свързана';

  @override
  String get commonViewAll => 'Виж всички';

  @override
  String get commonSubmit => 'Изпрати';

  @override
  String get commonAdd => 'Добави';

  @override
  String get commonRemove => 'Премахни';

  @override
  String get commonCreate => 'Създай';

  @override
  String get commonUpdate => 'Актуализирай';

  @override
  String get commonUpload => 'Качи';

  @override
  String get commonShare => 'Сподели';

  @override
  String get commonBlock => 'Блокирай';

  @override
  String get commonUnblock => 'Отблокирай';

  @override
  String get commonMute => 'Заглуши';

  @override
  String get commonUnmute => 'Включи известията';

  @override
  String get commonPin => 'Закачен';

  @override
  String get commonUnpin => 'Откачи';

  @override
  String get commonMarkRead => 'Маркирай като прочетено';

  @override
  String get commonMarkUnread => 'Маркирай като непрочетено';

  @override
  String get commonOnline => 'На линия';

  @override
  String get commonOffline => 'Извън линия';

  @override
  String get commonOperationFailed =>
      'Операцията е неуспешна. Опитайте отново.';

  @override
  String get commonNetworkError => 'Мрежова грешка. Проверете връзката.';

  @override
  String get navMessages => 'Съобщения';

  @override
  String get navContacts => 'Контакти';

  @override
  String get navMe => 'Аз';

  @override
  String get authLoginTitle => 'Вход в StartLink';

  @override
  String get authTabMobile => 'Телефон';

  @override
  String get authTabEmail => 'Имейл';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'Въведете телефонен номер';

  @override
  String get authHintEmail => 'Въведете Вашия имейл адрес';

  @override
  String get authHintPassword => 'Въведете паролата';

  @override
  String get authHintCode => 'Въведете кода за потвърждение';

  @override
  String get authHintLoginName => 'Въведете StartLink ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Вход';

  @override
  String get authGetCode => 'Изпрати код';

  @override
  String authResendCode(int seconds) {
    return 'Изпрати отново след $seconds сек';
  }

  @override
  String get authUsePassword => 'Използвай парола';

  @override
  String get authUseCode => 'Използвай код за потвърждение';

  @override
  String get authAgreementPrefix => 'Прочетох и приемам ';

  @override
  String get authAgreementAnd => 'и';

  @override
  String get authTermsLink => 'Потребителско споразумение';

  @override
  String get authPrivacyLink => 'Политика за поверителност';

  @override
  String get authCaptchaTitle => 'Проверка за сигурност';

  @override
  String get authCaptchaHint => 'Въведете отговора';

  @override
  String get authCaptchaFailed =>
      'Кодът за сигурност не беше получен. Опитайте отново.';

  @override
  String get authErrorEmptyCode => 'Въведете кода за потвърждение';

  @override
  String get authErrorEmptyPassword => 'Въведете паролата';

  @override
  String get authErrorEmptyLoginName => 'Въведете StartLink ID';

  @override
  String get authErrorWrongCredentials => 'Неправилен профил или парола';

  @override
  String get authDeactivatingTitle => 'Деактивиране на профила';

  @override
  String get authDeactivatingContent =>
      'Профилът ви е в периода за размисъл преди деактивиране (7 дни).\n\nЗа отмяна натиснете „Отмени деактивирането“; за вход в приложението натиснете „Продължи“.';

  @override
  String get authContinueUse => 'Продължи';

  @override
  String get authCancelDeactivation => 'Отмени деактивирането';

  @override
  String get authDeactivationCancelled =>
      'Деактивирането е отменено, профилът е възстановен';

  @override
  String get authDeactivationCancelFailed =>
      'Отмяната е неуспешна. Опитайте отново.';

  @override
  String get authLogout => 'Изход';

  @override
  String get authLogoutConfirm => 'Сигурни ли сте, че искате да излезете?';

  @override
  String get authSendingCode => 'Изпращане...';

  @override
  String get authCodeSent => 'Кодът за потвърждение е изпратен';

  @override
  String get authLoginFailed => 'Входът е неуспешен. Опитайте отново.';

  @override
  String get authRegisterFailed =>
      'Регистрацията е неуспешна. Опитайте отново.';

  @override
  String get authEnterpriseCode => 'Фирмен код';

  @override
  String get authEnterpriseCodeHint => 'Въведете фирмения код';

  @override
  String get authPendingApproval =>
      'Успешна регистрация. Заявката ви за присъединяване към фирмата е изпратена и чака одобрение.';

  @override
  String get authNoAccount => 'Нямате профил?';

  @override
  String get authRegisterNow => 'Регистрирай се сега';

  @override
  String get authCountryPickerTitle => 'Изберете държава/регион';

  @override
  String get authCountrySearchHint => 'Търси държава/регион';

  @override
  String get authCountryChinaMainland => 'Континентален Китай';

  @override
  String get authCountryHongKong => 'Хонконг, Китай';

  @override
  String get authCountryMacau => 'Макао, Китай';

  @override
  String get authCountryTaiwan => 'Тайван, Китай';

  @override
  String get authCountryUnitedStates => 'Съединени щати';

  @override
  String get authCountryUnitedKingdom => 'Обединено кралство';

  @override
  String get authCountryJapan => 'Япония';

  @override
  String get authCountrySouthKorea => 'Южна Корея';

  @override
  String get authCountrySingapore => 'Сингапур';

  @override
  String get authCountryMalaysia => 'Малайзия';

  @override
  String get authCountryAustralia => 'Австралия';

  @override
  String get authCountryCanada => 'Канада';

  @override
  String get authCountryGermany => 'Германия';

  @override
  String get authCountryFrance => 'Франция';

  @override
  String get authCountryIndia => 'Индия';

  @override
  String get authCountryThailand => 'Тайланд';

  @override
  String get authCountryVietnam => 'Виетнам';

  @override
  String get authCountryIndonesia => 'Индонезия';

  @override
  String get authCountryPhilippines => 'Филипини';

  @override
  String get authQuickLoginTitle => 'Бърз вход';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Влизане. Моля, изчакайте.';

  @override
  String get authRoleOwner => 'Собственик';

  @override
  String get authRoleAdministrator => 'Администратор';

  @override
  String get authRoleCustomerService => 'Обслужване на клиенти';

  @override
  String get authRoleTechnicalSupport => 'Техническа поддръжка';

  @override
  String get authRoleEmployee => 'Служител';

  @override
  String get authRoleMember => 'Член';

  @override
  String get authRoleEnterpriseCustomer => 'Фирмен клиент';

  @override
  String get authUnavailablePrefix => 'Недостъпно · ';

  @override
  String get authUnassignedService => 'Няма назначен агент';

  @override
  String authAssignedService(String staff) {
    return 'Назначен: $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Клиент · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Служител · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count потребители';
  }

  @override
  String get authMetaPhone => 'Телефон';

  @override
  String get authMetaIdentity => 'Самоличност';

  @override
  String get authRegisterTitle => 'Регистрация';

  @override
  String get authNickname => 'Псевдоним';

  @override
  String get authNicknameHint => 'Задайте псевдоним';

  @override
  String get authPassword => 'Парола';

  @override
  String get authPasswordSetHint => 'Задайте парола (поне 6 знака)';

  @override
  String get authConfirmPassword => 'Потвърди паролата';

  @override
  String get authConfirmPasswordHint => 'Въведете паролата отново';

  @override
  String get authVerificationCode => 'Код за потвърждение';

  @override
  String get authRegisterAndLogin => 'Регистрация и вход';

  @override
  String get authHaveAccount => 'Вече имате профил?';

  @override
  String get authGoLogin => 'Вход';

  @override
  String get authEmailVerificationUnavailable =>
      'Потвърждението по имейл е недостъпно. Регистрирайте се с мобилен номер.';

  @override
  String get authSmsVerificationUnavailable =>
      'Потвърждението чрез SMS е недостъпно. Регистрирайте се с имейл.';

  @override
  String get authSendFailed => 'Изпращането е неуспешно. Опитайте отново.';

  @override
  String get authErrorEmptyNickname => 'Въведете псевдоним';

  @override
  String get authErrorInvalidMobile => 'Въведете валиден мобилен номер';

  @override
  String get authErrorInvalidEmail => 'Въведете валиден имейл адрес';

  @override
  String get authErrorPasswordTooShort =>
      'Паролата трябва да съдържа поне 6 знака';

  @override
  String get authErrorPasswordMismatch => 'Паролите не съвпадат';

  @override
  String get authErrorVerificationRequired =>
      'Първо поискайте и въведете кода за потвърждение';

  @override
  String get authRegisterErrorTitle => 'Регистрацията е неуспешна';

  @override
  String get authGotIt => 'Разбрах';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Фирма „$code“ не е намерена. Проверете фирмения код.';
  }

  @override
  String get authTenantSearchFailed =>
      'Търсенето е неуспешно. Опитайте отново.';

  @override
  String get authInvitationInvalid =>
      'Кодът за покана е невалиден. Проверете го и опитайте отново.';

  @override
  String get authCollapseJoin => 'Скрий информацията за присъединяване';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Валидна покана: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Намерена фирма: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Изберете организация';

  @override
  String get authNoOrganization => 'Няма достъпни организации';

  @override
  String get authNoOrganizationHint =>
      'Помолете администратор да ви покани в организация';

  @override
  String get authPersonalSpace => 'Лично пространство';

  @override
  String get authPersonalSpaceSubtitle => 'Разговори с приятели и лични любими';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Идентичността на пространството не беше потвърдена. Опитайте отново.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Личното пространство не беше възстановено. Опитайте отново.';

  @override
  String get authJoinEnterpriseFailed =>
      'Присъединяването към фирмата е неуспешно. Опитайте по-късно.';

  @override
  String get homeTitle => 'Съобщения';

  @override
  String get homeGatewayConnectingTitle => 'Свързване';

  @override
  String get homePersonalSpace => 'Лично';

  @override
  String get homeOfficialService => 'Официално обслужване';

  @override
  String get homeSwitchSpace => 'Смени пространство';

  @override
  String get homeSpaceSubtitle => 'Лично · Фирмено';

  @override
  String get homeJoinEnterprise => 'Присъедини се към фирма';

  @override
  String get homeCreateGroup => 'Нова група';

  @override
  String get homeAddFriend => 'Добави контакт';

  @override
  String get homeScan => 'Сканирай';

  @override
  String get homeJoinNewSpace => 'Присъедини се към ново пространство';

  @override
  String get homeSearchConversation => 'Търси';

  @override
  String get homeNoMessages => 'Няма съобщения';

  @override
  String get homeDeleteConversation => 'Изтрий разговор';

  @override
  String get homeDeleteConversationConfirm =>
      'Да се изтрие ли този разговор? Историята ще бъде изчистена.';

  @override
  String get homePersonalNote => 'Аз (лични бележки)';

  @override
  String get homeWorkNote => 'Аз (служебни бележки)';

  @override
  String homeConversationCount(int count) {
    return '$count разговора';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count непрочетени';
  }

  @override
  String get chatInputHint => 'Напишете съобщение...';

  @override
  String get chatVoiceHint => 'Задръжте, за да говорите';

  @override
  String get chatVoiceRelease => 'Отпуснете за изпращане';

  @override
  String get chatVoiceCancel => 'Плъзнете нагоре за отказ';

  @override
  String get chatMenuCopy => 'Копиране';

  @override
  String get chatMenuForward => 'Препрати';

  @override
  String get chatMenuRecall => 'Оттегли съобщението';

  @override
  String get chatMenuDelete => 'Изтрий';

  @override
  String get chatMenuFavorite => 'Запази';

  @override
  String get chatMenuReply => 'Отговори';

  @override
  String get chatMenuMultiSelect => 'Избери';

  @override
  String get chatMenuTranslate => 'Преведи';

  @override
  String get chatMenuVoiceToText => 'Преобразувай в текст';

  @override
  String get chatMenuTextToSpeech => 'Прочети на глас';

  @override
  String get chatStatusRecalled => 'Съобщението е оттеглено';

  @override
  String get chatRecallSuccess => 'Оттеглено';

  @override
  String get chatRecallFailed => 'Оттеглянето е неуспешно';

  @override
  String get chatRecallTimeout =>
      'Съобщения, по-стари от 2 минути, не могат да се оттеглят';

  @override
  String get chatTranslateFailed => 'Преводът е неуспешен. Опитайте отново.';

  @override
  String get chatTranslateNotConfigured => 'Услугата за превод не е достъпна';

  @override
  String get chatVoiceToTextFailed =>
      'Преобразуването е неуспешно. Опитайте отново.';

  @override
  String get chatTextToSpeechFailed =>
      'Прочитането на глас е неуспешно. Опитайте отново.';

  @override
  String get chatVoiceToText => 'Преобразувай';

  @override
  String get chatForwardSuccess => 'Препратено';

  @override
  String get chatForwardFailed => 'Препращането е неуспешно. Опитайте отново.';

  @override
  String get chatNoConversations => 'Няма разговори за препращане';

  @override
  String get chatSendFailed => 'Изпращането е неуспешно';

  @override
  String get chatResend => 'Изпрати отново';

  @override
  String get chatNotFriend => 'Не е в списъка с контакти';

  @override
  String get chatNotFriendHint =>
      'Все още не сте контакти. Изпращането на съобщения е невъзможно.';

  @override
  String get chatMutedHint => 'Всички членове са заглушени';

  @override
  String get chatFileUploadFailed =>
      'Качването на файла е неуспешно. Опитайте отново.';

  @override
  String get chatFileStatusNotDownloaded => 'Не е изтеглено';

  @override
  String get chatFileStatusDownloaded => 'Изтеглено';

  @override
  String get chatFileStatusUploading => 'Качване';

  @override
  String get chatFileStatusUploadFailed => 'Неуспешно качване';

  @override
  String get chatCardSendFailed =>
      'Изпращането на контактната карта е неуспешно';

  @override
  String get chatFavoriteSuccess => 'Запазено';

  @override
  String get chatFavoriteFailed => 'Добавянето в любими е неуспешно';

  @override
  String get chatLoadFailed => 'Неуспешно зареждане';

  @override
  String get chatImageMessage => '[Изображение]';

  @override
  String get chatVoiceMessage => '[Гласово съобщение]';

  @override
  String get chatVideoMessage => '[Видео]';

  @override
  String get chatFileMessage => '[Файл]';

  @override
  String get chatLocationMessage => '[Местоположение]';

  @override
  String get chatContactCardMessage => '[Контакт]';

  @override
  String get chatCallLogMessage => '[Обаждане]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Прочетено от $count';
  }

  @override
  String get chatUnread => 'Непрочетено';

  @override
  String get chatRecalledSelf => 'Оттеглихте съобщение';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender оттегли съобщение';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Превод: $translation';
  }

  @override
  String get chatMessageDeleted => 'Съобщението е изтрито';

  @override
  String get chatPeer => 'Друго';

  @override
  String get chatSelf => 'Аз';

  @override
  String get chatGenericMessage => '[Съобщение]';

  @override
  String get chatVoiceHideText => 'Скрий текста';

  @override
  String get chatVoiceShowText => 'Преобразувай в текст';

  @override
  String get chatFileDefaultName => 'Файл';

  @override
  String get chatContactDefaultName => 'Контакт';

  @override
  String get chatContactCardTitle => 'Контактна карта';

  @override
  String get chatCallMissed => 'Пропуснато';

  @override
  String get chatCallCancelled => 'Отменено';

  @override
  String get chatCallRejected => 'Отказано';

  @override
  String get chatCallDisconnected => 'Връзката е прекъсната';

  @override
  String get chatCallEnded => 'Разговорът приключи';

  @override
  String get chatCallFailed => 'Обаждането е неуспешно';

  @override
  String chatCallDuration(String duration) {
    return 'Продължителност $duration';
  }

  @override
  String get chatVideoCallTitle => 'Видеоразговор';

  @override
  String get chatVoiceCallTitle => 'Гласово обаждане';

  @override
  String get chatToolPhotos => 'Снимки';

  @override
  String get chatToolCamera => 'Камера';

  @override
  String get chatToolFile => 'Файл';

  @override
  String get chatToolLocation => 'Местоположение';

  @override
  String get chatToolContactCard => 'Контакт';

  @override
  String get chatToolVoiceCall => 'Гласово обаждане';

  @override
  String get chatToolVideoCall => 'Видеоразговор';

  @override
  String get chatToolFavorites => 'Любими';

  @override
  String get chatToolTranslate => 'Преведи';

  @override
  String get chatTranslationChooseLanguage => 'Изберете език за превод';

  @override
  String get chatTranslationEnterText => 'Първо въведете текст';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Преводът е недостъпен за съобщения със споменавания';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Преводът е недостъпен при редактиране на насрочено съобщение';

  @override
  String get chatTranslationFailed => 'Преводът е неуспешен. Опитайте отново.';

  @override
  String get chatTranslationEmpty => 'Не е получен превод. Опитайте отново.';

  @override
  String get chatTranslationTranslating => 'Превеждане…';

  @override
  String get chatTranslationSend => 'Изпрати превода';

  @override
  String get chatTranslationSending => 'Изпращане…';

  @override
  String get chatTranslationExpand => 'Покажи още';

  @override
  String get chatTranslationCollapse => 'Покажи по-малко';

  @override
  String get chatFileTooLarge => 'Файлът надвишава ограничението (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Само собственикът или избраните членове могат да пишат.';

  @override
  String get chatImageUploadUnsupported =>
      'Качването на изображението е неуспешно. Сървърът все още не поддържа тази функция.';

  @override
  String get chatFavoriteLongPressHint =>
      'Задръжте съобщение, за да го добавите в любими';

  @override
  String chatSelectedCount(int count) {
    return 'Избрани: $count';
  }

  @override
  String get chatLocationSheetTitle => 'Изпрати местоположение';

  @override
  String get chatLocationNameLabel => 'Име на мястото';

  @override
  String get chatLocationNameHint => 'напр. офис, адрес на клиент';

  @override
  String get chatLocationAddressLabel => 'Адрес';

  @override
  String get chatLocationOptionalHint => 'По избор';

  @override
  String get chatLocationLatitudeLabel => 'Географска ширина';

  @override
  String get chatLocationLatitudeHint => 'От -90 до 90';

  @override
  String get chatLocationLongitudeLabel => 'Географска дължина';

  @override
  String get chatLocationLongitudeHint => 'От -180 до 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Въведете $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label е извън допустимия диапазон';
  }

  @override
  String get chatLocationDefaultTitle => 'Местоположение';

  @override
  String get chatMutedFullNotice =>
      'Тази група е заглушена. Само собственикът или избраните членове могат да пишат.';

  @override
  String get chatNotFriendSendBlocked =>
      'Вече не сте приятели и не можете да изпращате съобщения';

  @override
  String get chatPersonalNotesTitle => 'Лични бележки';

  @override
  String get chatWorkNotesTitle => 'Служебни бележки';

  @override
  String get chatPersonalNotesDescription =>
      'Записвайте лични мисли и важна информация тук\nСинхронизирани между устройствата за достъп по всяко време';

  @override
  String get chatWorkNotesDescription =>
      'Записвайте служебни задачи и материали тук\nЕкипните пространства остават отделни и защитени';

  @override
  String get chatNoMessages => 'Няма съобщения';

  @override
  String chatReplyTo(String sender) {
    return 'Отговори на $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return 'Функцията $feature предстои скоро';
  }

  @override
  String get chatForwardSelectTitle => 'Изберете разговор';

  @override
  String get chatContactSelectTitle => 'Изберете контакт';

  @override
  String get chatNoContacts => 'Няма контакти';

  @override
  String get contactsTitle => 'Контакти';

  @override
  String get contactsSearch => 'Търси контакти';

  @override
  String get contactsNewFriends => 'Нови приятели';

  @override
  String get contactsGroups => 'Групи';

  @override
  String get contactsFavorites => 'Любими';

  @override
  String get contactsRecent => 'Скорошни';

  @override
  String get contactsOrganization => 'Организация';

  @override
  String get contactsAnnouncement => 'Обявления';

  @override
  String get contactsNewApplications => 'Нови заявления';

  @override
  String get contactsCustomerGroups => 'Клиентски групи';

  @override
  String get contactsAllCustomers => 'Всички клиенти';

  @override
  String get contactsMyCustomers => 'Моите клиенти';

  @override
  String get contactsViewAll => 'Виж всички';

  @override
  String get contactsMyContacts => 'Моите контакти';

  @override
  String get contactsMyAdvisor => 'Моят консултант';

  @override
  String get contactsNoAdvisor => 'Все още няма назначен консултант';

  @override
  String get contactsAdvisorLoading => 'Зареждане...';

  @override
  String get contactsNavigateFailed =>
      'Преминаването към страницата е неуспешно. Опитайте отново.';

  @override
  String get contactsEmpty => 'Няма контакти';

  @override
  String get contactsNoAnnouncement => 'Няма обявления';

  @override
  String get contactsOfficialBadge => 'Официално';

  @override
  String get contactsCustomerBadge => 'Клиент';

  @override
  String get contactsEmptyCustomers => 'Няма клиенти';

  @override
  String get myTitle => 'Аз';

  @override
  String get myEnterpriseInfo => 'Информация за фирмата';

  @override
  String get myEnterpriseManage => 'Управление на фирмата';

  @override
  String get myQrCode => 'QR код';

  @override
  String get myFavorites => 'Любими';

  @override
  String get myLanguage => 'Език';

  @override
  String get myTimezone => 'Часова зона';

  @override
  String get myAutoTranslate => 'Автоматичен превод';

  @override
  String get myNetworkSwitch => 'Смяна на линия';

  @override
  String get mySettings => 'Настройки';

  @override
  String get myLogout => 'Изход';

  @override
  String get myLogoutConfirm => 'Сигурни ли сте, че искате да излезете?';

  @override
  String get myLeaveEnterprise => 'Напусни фирмата';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Сигурни ли сте, че искате да напуснете тази фирма? Ще изгубите достъпа до фирмените данни.';

  @override
  String get myLeaveEnterpriseSuccess => 'Напуснахте фирмата';

  @override
  String get myLeaveEnterpriseFailed =>
      'Напускането е неуспешно. Опитайте отново.';

  @override
  String get myLppIdCopied => 'StartLink ID е копиран';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count контакта';
  }

  @override
  String get myAutoSelect => 'Автоматично';

  @override
  String get myPresenceStatus => 'Достъпност';

  @override
  String get myPresenceStatusTitle => 'Задай достъпност';

  @override
  String get myPresenceOnline => 'На линия';

  @override
  String get myPresenceBusy => 'Зает';

  @override
  String get myPresenceAway => 'Отсъстващ';

  @override
  String get myPresenceInvisible => 'Невидим';

  @override
  String get profileTitle => 'Моят профил';

  @override
  String get profileName => 'Име';

  @override
  String get profileGender => 'Пол';

  @override
  String get profileBirthday => 'Рожден ден';

  @override
  String get profileRegion => 'Регион';

  @override
  String get profileSignature => 'За мен';

  @override
  String get profileSignatureHint => 'Разкажете нещо за себе си';

  @override
  String get profileTapTapText => 'Потупване';

  @override
  String get profileTapTapHint => 'Текст при потупване (до 20 знака)';

  @override
  String get profileAccountSection => 'Профил';

  @override
  String get profileBasicSection => 'Основна информация';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'Не е зададено';

  @override
  String get profileMobile => 'Телефон';

  @override
  String get profileMobileUnbound => 'Не е свързана';

  @override
  String get profileEmail => 'Имейл';

  @override
  String get profileEmailUnbound => 'Не е свързана';

  @override
  String get profileQrCode => 'Моят QR код';

  @override
  String get profileChangePassword => 'Промени паролата';

  @override
  String get profileGenderMale => 'Мъж';

  @override
  String get profileGenderFemale => 'Жена';

  @override
  String get profileGenderOther => 'Друго';

  @override
  String get profileGenderUnset => 'Не е зададено';

  @override
  String get profileSaveFailed => 'Запазването е неуспешно. Опитайте отново.';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'StartLink ID може да се промени само веднъж. Изберете внимателно.';

  @override
  String get profileLppIdChangeFailed =>
      'Промяната е неуспешна (StartLink ID може да се промени само веднъж)';

  @override
  String get profileChangePasswordOld => 'Текуща парола';

  @override
  String get profileChangePasswordNew => 'Нова парола';

  @override
  String get profileChangePasswordConfirm => 'Потвърдете новата парола';

  @override
  String get profileChangePasswordMismatch => 'Паролите не съвпадат';

  @override
  String get profileChangePasswordSuccess =>
      'Паролата е променена. Влезте отново.';

  @override
  String get profileChangePasswordFailed =>
      'Промяната на паролата е неуспешна. Опитайте отново.';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionEnterprise => 'Фирма';

  @override
  String get settingsSectionAccount => 'Профил';

  @override
  String get settingsSectionGeneral => 'Общи';

  @override
  String get settingsSectionFeatures => 'Функции';

  @override
  String get settingsSectionAbout => 'Относно';

  @override
  String get settingsEnterpriseInfo => 'Информация за фирмата';

  @override
  String get settingsProfile => 'Моят профил';

  @override
  String get settingsAccountSecurity => 'Сигурност на профила';

  @override
  String get settingsNotification => 'Известия';

  @override
  String get settingsDisplay => 'Екран';

  @override
  String get settingsFriendPrivacy => 'Поверителност';

  @override
  String get settingsChat => 'Разговор';

  @override
  String get settingsChatHistory => 'История на разговорите';

  @override
  String get settingsAbout => 'За StartLink';

  @override
  String get settingsLanguage => 'Език';

  @override
  String get settingsTimezone => 'Часова зона';

  @override
  String get settingsAutoTranslate => 'Автоматичен превод';

  @override
  String get settingsNetworkSwitch => 'Смяна на линия';

  @override
  String get enterpriseInfoTitle => 'Информация за фирмата';

  @override
  String get enterpriseName => 'Име';

  @override
  String get enterpriseDescription => 'Описание';

  @override
  String get enterpriseUpdateSuccess => 'Успешно актуализирано';

  @override
  String get enterpriseUpdateFailed =>
      'Актуализацията е неуспешна. Опитайте отново.';

  @override
  String get enterpriseLeave => 'Напусни фирмата';

  @override
  String get enterpriseLeaveConfirm =>
      'Сигурни ли сте, че искате да напуснете тази фирма?';

  @override
  String get enterpriseLeaveSuccess => 'Напуснахте фирмата';

  @override
  String get enterpriseLeaveFailed =>
      'Напускането е неуспешно. Опитайте отново.';

  @override
  String get enterpriseLeaveOwnerError =>
      'Собственикът не може да напусне директно. Първо прехвърлете собствеността.';

  @override
  String get enterpriseMemberCount => 'Членове';

  @override
  String get enterpriseCreatedAt => 'Създадено';

  @override
  String get enterpriseCode => 'Фирмен код';

  @override
  String get enterpriseInviteMembers => 'Покани членове';

  @override
  String get enterpriseCopyInviteCode => 'Копирай кода за покана';

  @override
  String get enterpriseInviteCodeCopied => 'Кодът за покана е копиран';

  @override
  String get groupCreateTitle => 'Нова група';

  @override
  String get groupNameHint => 'Въведете име на групата';

  @override
  String get groupCreateSuccess => 'Групата е създадена';

  @override
  String get groupCreateFailed => 'Създаването на групата е неуспешно';

  @override
  String get groupSettings => 'Настройки на групата';

  @override
  String get groupName => 'Име на групата';

  @override
  String get groupAvatar => 'Снимка на групата';

  @override
  String get groupAnnouncement => 'Обявление';

  @override
  String get groupMembers => 'Членове';

  @override
  String get groupAddMember => 'Добави членове';

  @override
  String get groupRemoveMember => 'Премахни член';

  @override
  String get groupRemoveMemberConfirm => 'Да се премахне ли този член?';

  @override
  String get groupSetAdmin => 'Назначи за администратор';

  @override
  String get groupRemoveAdmin => 'Премахни администраторските права';

  @override
  String get groupTransferOwner => 'Прехвърли собствеността';

  @override
  String get groupTransferOwnerConfirm =>
      'Да се прехвърли ли собствеността на групата на този член?';

  @override
  String get groupTransferOwnerSuccess => 'Собствеността е прехвърлена';

  @override
  String get groupTransferOwnerFailed =>
      'Прехвърлянето е неуспешно. Опитайте отново.';

  @override
  String get groupLeave => 'Напусни групата';

  @override
  String get groupLeaveConfirm => 'Да се напусне ли тази група?';

  @override
  String get groupLeaveSuccess => 'Напуснахте групата';

  @override
  String get groupLeaveFailed => 'Напускането е неуспешно. Опитайте отново.';

  @override
  String get groupDissolve => 'Разпусни групата';

  @override
  String get groupDissolveConfirm =>
      'Да се разпусне ли тази група? Всички членове ще бъдат премахнати.';

  @override
  String get groupDissolveSuccess => 'Групата е разпусната';

  @override
  String get groupDissolveFailed =>
      'Разпускането е неуспешно. Опитайте отново.';

  @override
  String get groupQrCode => 'QR код на групата';

  @override
  String get groupMuteAll => 'Заглуши всички';

  @override
  String get groupMuteAllOn => 'Включи заглушаване на всички';

  @override
  String get groupMuteAllOff => 'Изключи заглушаване на всички';

  @override
  String get groupAllowMemberInvite => 'Разреши на членовете да канят други';

  @override
  String get groupAllowMemberModifyTitle =>
      'Разреши на членовете да променят името на групата';

  @override
  String get groupAllowMemberAtAll =>
      'Разреши на членовете да споменават всички';

  @override
  String get groupAllowMemberViewMemberList =>
      'Разреши на членовете да виждат списъка с членове';

  @override
  String get groupAllowQrCodeJoin => 'Разреши присъединяване чрез QR код';

  @override
  String get groupRequireApproval => 'Изисквай одобрение за присъединяване';

  @override
  String get groupAllowMemberAddFriend =>
      'Разреши на членовете да се добавят взаимно';

  @override
  String get groupRoleOwner => 'Собственик';

  @override
  String get groupRoleAdmin => 'Администратор';

  @override
  String get groupRoleMember => 'Член';

  @override
  String get groupNoMembers => 'Няма членове';

  @override
  String get groupNoAnnouncements => 'Няма обявления';

  @override
  String get groupCreateAnnouncement => 'Публикувай обявление';

  @override
  String get groupEditAnnouncement => 'Редактирай обявление';

  @override
  String get groupDeleteAnnouncement => 'Изтрий обявление';

  @override
  String get groupDeleteAnnouncementConfirm =>
      'Да се изтрие ли това обявление?';

  @override
  String get groupAnnouncementTitle => 'Заглавие';

  @override
  String get groupAnnouncementContent => 'Съдържание';

  @override
  String get groupAnnouncementPin => 'Закачи обявление';

  @override
  String groupMemberCount(int count) {
    return '$count членове';
  }

  @override
  String groupSelectedCount(int count) {
    return 'Избрани: $count';
  }

  @override
  String get groupJoinRequestApprove => 'Съгласен съм';

  @override
  String get groupJoinRequestReject => 'Отказ';

  @override
  String get groupJoinRequests => 'Заявки за присъединяване';

  @override
  String get groupNoJoinRequests => 'Няма заявки за присъединяване';

  @override
  String get groupReadReceipts => 'Потвърждения за прочитане';

  @override
  String groupReadCount(int count) {
    return 'Прочетено: $count';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count непрочетени';
  }

  @override
  String get friendAddTitle => 'Добави контакт';

  @override
  String get friendSearchHint => 'Телефон / имейл / StartLink ID';

  @override
  String get friendRequestSent => 'Заявката за приятелство е изпратена';

  @override
  String get friendRequestFailed => 'Изпращането е неуспешно. Опитайте отново.';

  @override
  String get friendAlreadyFriend => 'Вече сте контакти';

  @override
  String get friendNewFriendsTitle => 'Нови приятели';

  @override
  String get friendNoRequests => 'Няма заявки за приятелство';

  @override
  String get friendAccept => 'Приеми';

  @override
  String get friendReject => 'Отказ';

  @override
  String get friendAccepted => 'Прието';

  @override
  String get friendRejected => 'Отказан';

  @override
  String get friendDeleteConfirm => 'Да се премахне ли този контакт?';

  @override
  String get friendDeleteSuccess => 'Контактът е премахнат';

  @override
  String get friendDeleteFailed => 'Премахването е неуспешно. Опитайте отново.';

  @override
  String get friendRemarkName => 'Псевдоним';

  @override
  String get friendGroupName => 'Група';

  @override
  String get friendSendMessage => 'Съобщение';

  @override
  String get friendMatchTypeLppId => 'Намерено по StartLink ID';

  @override
  String get friendMatchTypeMobile => 'Намерено по телефон';

  @override
  String get friendMatchTypeEmail => 'Намерено по имейл';

  @override
  String get friendSearchEmpty => 'Няма намерени потребители';

  @override
  String get friendAddMessage => 'Бих искал да ви добавя като контакт';

  @override
  String get friendBlockConfirm => 'Да се блокира ли този потребител?';

  @override
  String get friendUnblockConfirm => 'Да се отблокира ли този потребител?';

  @override
  String get friendBlockSuccess => 'Блокиран';

  @override
  String get friendUnblockSuccess => 'Отблокиран';

  @override
  String get profilePageTitle => 'Лична информация';

  @override
  String get profilePageSendMessage => 'Съобщение';

  @override
  String get profilePageAddFriend => 'Добави приятел';

  @override
  String get profilePageAlreadyFriend => 'Вече сте приятели';

  @override
  String get profilePageBlocked => 'Блокиран';

  @override
  String get profilePageBlock => 'Блокирай';

  @override
  String get profilePageUnblock => 'Отблокирай';

  @override
  String get profilePageHidden => 'Този потребител е скрил профила си';

  @override
  String get profilePageFriendsOnly =>
      'Този потребител показва профила си само на приятели';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'Забележки';

  @override
  String get profilePageEditRemark => 'Редактирай псевдоним';

  @override
  String get profilePageSaveRemarkSuccess => 'Псевдонимът е запазен';

  @override
  String get profilePageSaveRemarkFailed =>
      'Запазването е неуспешно. Опитайте отново.';

  @override
  String get searchTitle => 'Търсене';

  @override
  String get searchHint => 'Търси по телефон, имейл или StartLink ID';

  @override
  String get searchNoResults => 'Няма резултати';

  @override
  String get searchMessages => 'Съобщения';

  @override
  String get searchUsers => 'Потребители';

  @override
  String get searchFailed => 'Търсенето е неуспешно. Опитайте отново.';

  @override
  String get scanTitle => 'Сканирай';

  @override
  String get scanFailed => 'Разпознаването е неуспешно. Опитайте отново.';

  @override
  String get scanInvalidQrCode => 'Невалиден QR код';

  @override
  String get scanFlashOn => 'Включи фенерчето';

  @override
  String get scanFlashOff => 'Изключи фенерчето';

  @override
  String get scanAlbum => 'Изберете от албума';

  @override
  String get favoritesTitle => 'Любими';

  @override
  String get favoritesEmpty => 'Все още няма запазени елементи';

  @override
  String get favoritesAll => 'Всички';

  @override
  String get favoritesText => 'Текст';

  @override
  String get favoritesImage => 'Изображения';

  @override
  String get favoritesVideo => 'Видео';

  @override
  String get favoritesVoice => 'Гласови съобщения';

  @override
  String get favoritesFile => 'Файлове';

  @override
  String get favoritesOther => 'Друго';

  @override
  String get favoritesDeleteConfirm => 'Да се премахне ли от любими?';

  @override
  String get favoritesDeleteSuccess => 'Премахнато от запазените';

  @override
  String get favoritesDeleteFailed => 'Премахването е неуспешно';

  @override
  String get favoritesOriginalRecalled => 'Съобщението е оттеглено';

  @override
  String get favoritesViewOriginal => 'Виж оригинала';

  @override
  String get favoritesSearchHint => 'Търси в любими';

  @override
  String get favoritesNoResults => 'Няма съответстващи любими';

  @override
  String get noticeTitle => 'Обявления';

  @override
  String get noticeEmpty => 'Няма обявления';

  @override
  String get noticeDetail => 'Подробности за обявлението';

  @override
  String get noticePublishedAt => 'Публикувано';

  @override
  String get noticePriorityNormal => 'Нормален';

  @override
  String get noticePriorityImportant => 'Важно';

  @override
  String get noticePriorityUrgent => 'Спешно';

  @override
  String get organizationTitle => 'Организация';

  @override
  String get organizationEmpty => 'Няма информация за отдела';

  @override
  String get organizationMembers => 'Членове';

  @override
  String get organizationDepartment => 'Отдел';

  @override
  String get organizationPosition => 'Длъжност';

  @override
  String get organizationLeader => 'Ръководител';

  @override
  String get qrCodeTitle => 'Моят QR код';

  @override
  String get qrCodeSave => 'Запази в албума';

  @override
  String get qrCodeShare => 'Сподели';

  @override
  String get qrCodeSaveSuccess => 'Запазено в албума';

  @override
  String get qrCodeSaveFailed => 'Запазването е неуспешно. Опитайте отново.';

  @override
  String get qrCodeRefresh => 'Обнови QR кода';

  @override
  String get qrCodeExpired => 'QR кодът е изтекъл. Обновете го.';

  @override
  String get qrCodeScanToAdd => 'Сканирайте, за да ме добавите като контакт';

  @override
  String get spacePersonal => 'Лично';

  @override
  String get spaceEnterprise => 'Фирма';

  @override
  String get spaceJoinByCode => 'Присъедини се с фирмен код';

  @override
  String get spaceJoinByInvite => 'Присъедини се с код за покана';

  @override
  String get spaceEnterCode => 'Въведете фирмения код';

  @override
  String get spaceEnterInviteCode => 'Въведете кода за покана';

  @override
  String get spaceSearchEnterprise => 'Търси фирма';

  @override
  String get spaceJoinRequestSent => 'Заявката е изпратена и чака одобрение';

  @override
  String get spaceJoinRequestPending => 'Чака одобрение';

  @override
  String get spaceJoinRequestApproved => 'Заявката е одобрена';

  @override
  String get spaceJoinRequestRejected => 'Заявката е отхвърлена';

  @override
  String get spaceAlreadyMember => 'Вече сте член';

  @override
  String get spaceAutoApproved => 'Автоматично одобрение. Добре дошли!';

  @override
  String get spacePendingApprovalHint =>
      'Успешна регистрация. Заявката ви за присъединяване е изпратена.';

  @override
  String get spaceNoSpaces => 'Няма пространства';

  @override
  String get spaceInviteExpired => 'Кодът за покана е изтекъл';

  @override
  String get spaceInviteTargetMismatch =>
      'Този код за покана не е за вашия профил';

  @override
  String get spaceAcceptInviteSuccess => 'Успешно се присъединихте към фирмата';

  @override
  String get spaceAcceptInviteFailed =>
      'Присъединяването е неуспешно. Опитайте отново.';

  @override
  String get spaceTenantSelectTitle => 'Изберете пространство';

  @override
  String get spaceTenantSelectHint =>
      'Изберете пространство, в което да влезете';

  @override
  String get spaceEnterPersonal => 'Влез в личното пространство';

  @override
  String get spaceEnterEnterprise => 'Влез във фирменото пространство';

  @override
  String get aboutTitle => 'За StartLink';

  @override
  String get aboutVersion => 'Версия';

  @override
  String get aboutTerms => 'Потребителско споразумение';

  @override
  String get aboutPrivacy => 'Политика за поверителност';

  @override
  String get aboutOpenSource => 'Лицензи с отворен код';

  @override
  String get aboutCheckUpdate => 'Провери за актуализации';

  @override
  String get aboutLatestVersion => 'Използвате най-новата версия';

  @override
  String get aboutUpdateAvailable => 'Налична е нова версия';

  @override
  String get aboutUpdateNow => 'Обновете сега';

  @override
  String get aboutUpdateLater => 'По-късно';

  @override
  String get notificationTitle => 'Известия';

  @override
  String get notificationGlobalMute => 'Не безпокой';

  @override
  String get notificationSound => 'Звук';

  @override
  String get notificationVibration => 'Вибрация';

  @override
  String get notificationPreview => 'Преглед на съобщение';

  @override
  String get notificationDndStart => 'Начало на „Не безпокой“';

  @override
  String get notificationDndEnd => 'Край на „Не безпокой“';

  @override
  String get blacklistTitle => 'В черен списък';

  @override
  String get blacklistEmpty => 'Няма блокирани потребители';

  @override
  String get blacklistRemove => 'Отблокирай';

  @override
  String get blacklistRemoveConfirm => 'Да се отблокира ли този потребител?';

  @override
  String get feedbackTitle => 'Обратна връзка';

  @override
  String get feedbackTypeComplaint => 'Жалба';

  @override
  String get feedbackTypeSuggestion => 'Предложение';

  @override
  String get feedbackTypeBug => 'Доклад за грешка';

  @override
  String get feedbackContent => 'Описание';

  @override
  String get feedbackContentHint =>
      'Опишете подробно проблема или предложението';

  @override
  String get feedbackContact => 'Контакт (по избор)';

  @override
  String get feedbackSubmit => 'Изпрати';

  @override
  String get feedbackSuccess => 'Обратната връзка е изпратена. Благодарим!';

  @override
  String get feedbackFailed => 'Изпращането е неуспешно. Опитайте отново.';

  @override
  String get networkTitle => 'Смяна на линия';

  @override
  String get networkAutoSelect => 'Автоматично';

  @override
  String get networkManual => 'Ръчно';

  @override
  String get timezoneTitle => 'Часова зона';

  @override
  String get timezoneAuto => 'Според системата';

  @override
  String get autoTranslateTitle => 'Автоматичен превод';

  @override
  String get autoTranslateEnabled => 'Включи автоматичен превод';

  @override
  String get autoTranslateLanguage => 'Целеви език';

  @override
  String get displayTitle => 'Екран';

  @override
  String get displayFontSize => 'Размер на шрифта';

  @override
  String get displayChatBackground => 'Фон на разговора';

  @override
  String get displayDarkMode => 'Външен вид';

  @override
  String get displayDarkModeSystem => 'Според системата';

  @override
  String get displayDarkModeSystemHint =>
      'Автоматична промяна според системните настройки';

  @override
  String get displayDarkModeOff => 'Светла';

  @override
  String get displayDarkModeOffHint => 'Винаги използвай светла тема';

  @override
  String get displayDarkModeOn => 'Тъмна';

  @override
  String get displayDarkModeOnHint => 'Винаги използвай тъмна тема';

  @override
  String get chatSettingsTitle => 'Разговор';

  @override
  String get chatHistoryTitle => 'История на разговорите';

  @override
  String get chatHistoryClear => 'Изчисти цялата история';

  @override
  String get chatHistoryClearConfirm =>
      'Да се изчисти ли цялата история на разговорите? Това не може да се отмени.';

  @override
  String get chatHistoryClearSuccess => 'Историята на разговорите е изчистена';

  @override
  String get accountSecurityTitle => 'Сигурност на профила';

  @override
  String get accountSecurityChangePassword => 'Промени паролата';

  @override
  String get accountSecurityChangeMobile => 'Промяна на телефонен номер';

  @override
  String get accountSecurityChangeEmail => 'Промени имейл';

  @override
  String get accountSecurityLoggedDevices => 'Устройства с активен вход';

  @override
  String get accountSecurityDeactivate => 'Деактивирай профила';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Всички данни ще бъдат изтрити окончателно след 7 дни. Да се деактивира ли?';

  @override
  String get loggedDevicesTitle => 'Устройства с активен вход';

  @override
  String get loggedDevicesCurrent => 'Това устройство';

  @override
  String get loggedDevicesRevoke => 'Изход';

  @override
  String get loggedDevicesRevokeConfirm =>
      'Да се излезе ли от това устройство?';

  @override
  String get loggedDevicesRevokeSuccess => 'Излязохте от устройството';

  @override
  String get loggedDevicesRevokeFailed => 'Неуспешно. Опитайте отново.';

  @override
  String get loggedDevicesLastActive => 'Последна активност';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Уеб';

  @override
  String get loggedDevicesTypeDesktop => 'Компютър';

  @override
  String get loggedDevicesTypeUnknown => 'Непознато устройство';

  @override
  String get privacySettingsTitle => 'Поверителност';

  @override
  String get privacySearchableByMobile => 'Разреши търсене по телефонен номер';

  @override
  String get privacySearchableByLppId => 'Разреши търсене по StartLink ID';

  @override
  String get privacyAllowFriendRequest => 'Разреши заявки за приятелство';

  @override
  String get privacyProfileVisibility => 'Видимост на профила';

  @override
  String get privacyEveryone => 'Всички';

  @override
  String get privacyFriendsOfFriends => 'Приятели на приятели';

  @override
  String get privacyNobody => 'Никой';

  @override
  String get privacyFriendsOnly => 'Само приятели';

  @override
  String get privacySaveSuccess => 'Настройките са запазени';

  @override
  String get privacySaveFailed => 'Запазването е неуспешно. Опитайте отново.';

  @override
  String get fontSizeTitle => 'Размер на шрифта';

  @override
  String get fontSizeSmall => 'Малък';

  @override
  String get fontSizeNormal => 'Нормален';

  @override
  String get fontSizeLarge => 'Голям';

  @override
  String get fontSizeExtraLarge => 'Екстра голям';

  @override
  String get fontSizePreview => 'Предварителен преглед';

  @override
  String get chatBackgroundTitle => 'Фон на разговора';

  @override
  String get chatBackgroundDefault => 'По подразбиране';

  @override
  String get chatBackgroundCustom => 'Персонализирано';

  @override
  String get chatBackgroundReset => 'Възстанови стандартните настройки';

  @override
  String get termsTitle => 'Потребителско споразумение';

  @override
  String get privacyPolicyTitle => 'Политика за поверителност';

  @override
  String get recentContactsTitle => 'Скорошни';

  @override
  String get recentContactsEmpty => 'Няма скорошни контакти';

  @override
  String get inviteFriendsTitle => 'Покани приятели';

  @override
  String get inviteFriendsCopyLink => 'Копирай връзката за покана';

  @override
  String get inviteFriendsLinkCopied => 'Връзката за покана е копирана';

  @override
  String get imageViewerTitle => 'Снимка';

  @override
  String get imageViewerSave => 'Запази в албума';

  @override
  String get imageViewerSaveSuccess => 'Запазено в албума';

  @override
  String get imageViewerSaveFailed =>
      'Запазването е неуспешно. Опитайте отново.';

  @override
  String get customerServiceTitle => 'Център за обслужване';

  @override
  String get customerServiceQueue => 'В опашката';

  @override
  String get customerServiceActive => 'Активно';

  @override
  String get customerServiceClaim => 'Приеми';

  @override
  String get customerServiceTakeover => 'Поеми';

  @override
  String get customerServiceClose => 'Завърши обслужването';

  @override
  String get customerServiceCloseConfirm =>
      'Да се завърши ли тази сесия за обслужване?';

  @override
  String get customerServiceNoQueue => 'Няма чакащи сесии';

  @override
  String get customerServiceNoActive => 'Няма активни сесии';

  @override
  String get customerServiceVisitor => 'Посетител';

  @override
  String get customerServiceCustomer => 'Клиент';

  @override
  String get customerServiceAssignedTo => 'Назначен на';

  @override
  String get customerServiceTransferConversation => 'Прехвърли разговор';

  @override
  String get marketingToolbar => 'Маркетингови инструменти';

  @override
  String get callIncoming => 'Входящо повикване';

  @override
  String get callOutgoing => 'Изходящо повикване';

  @override
  String get callAccept => 'Приеми';

  @override
  String get callReject => 'Отказ';

  @override
  String get callHangup => 'Край';

  @override
  String get callMissed => 'Пропуснато повикване';

  @override
  String get callDuration => 'Продължителност';

  @override
  String get callAudio => 'Гласово обаждане';

  @override
  String get callGeneric => 'Обаждане';

  @override
  String get callVideo => 'Видеоразговор';

  @override
  String get callConnecting => 'Свързване...';

  @override
  String get callRinging => 'Звъни...';

  @override
  String get callEnded => 'Разговорът приключи';

  @override
  String get callFailed => 'Обаждането е неуспешно';

  @override
  String get callRejected => 'Обаждането е отказано';

  @override
  String get callTimeout => 'Няма отговор';

  @override
  String get callCancelled => 'Отменено';

  @override
  String get callUnknownPeer => 'Неизвестно';

  @override
  String get callVideoInvitation => 'Покана за видеоразговор';

  @override
  String get callAudioInvitation => 'Покана за аудиоразговор';

  @override
  String get callAnswerAudio => 'Отговори с аудио';

  @override
  String get callAnswerVideo => 'Отговори с видео';

  @override
  String get callViewProfile => 'Виж профила';

  @override
  String get callOpeningCamera => 'Отваряне на камерата...';

  @override
  String get callWaitingRemoteVideo => 'Изчакване на видеото на събеседника...';

  @override
  String get callCameraOff => 'Камерата е изключена';

  @override
  String get callCameraOn => 'Камерата е включена';

  @override
  String get callMicrophoneOff => 'Микрофонът е изключен';

  @override
  String get callMicrophoneOn => 'Микрофонът е включен';

  @override
  String get callSpeakerOff => 'Високоговорителят е изключен';

  @override
  String get callSpeakerOn => 'Високоговорителят е включен';

  @override
  String get callVideoPermissionFailure =>
      'Видеоразговорът не беше стартиран. Проверете разрешенията за камера и микрофон и опитайте отново.';

  @override
  String get callAudioPermissionFailure =>
      'Аудиоразговорът не беше стартиран. Проверете разрешението за микрофон и опитайте отново.';

  @override
  String get callIncompleteIncoming =>
      'Информацията за входящото повикване е непълна и то не може да бъде прието.';

  @override
  String get callInProgress => 'В разговор';

  @override
  String get callCalling => 'Набиране...';

  @override
  String callEndedMedia(String media) {
    return '$media приключи';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media беше отказано';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media остана без отговор';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media беше отменено';
  }

  @override
  String get callConnectionLost => 'Връзката на обаждането е изгубена';

  @override
  String get callAdminEnded => 'Обаждането е прекратено от администратор';

  @override
  String callFailedMedia(String media) {
    return '$media е неуспешно';
  }

  @override
  String get callBusy => 'Събеседникът е зает';

  @override
  String callDurationValue(String duration) {
    return 'Продължителност на разговора $duration';
  }

  @override
  String get callNotConnected => 'Няма връзка';

  @override
  String get callDialed => 'Изходящо';

  @override
  String get callAnswered => 'Прието';

  @override
  String get callRejectedByPeer => 'Отказано от събеседника';

  @override
  String get callRejectedBySelf => 'Отказан';

  @override
  String get callPeerDidNotAnswer => 'Събеседникът не отговори';

  @override
  String get callMissedIncoming => 'Пропуснато входящо повикване';

  @override
  String get callPeerCancelled => 'Отменено от събеседника';

  @override
  String get notificationNewMessageTitle => 'Ново съобщение в StartLink';

  @override
  String get notificationOnlineServiceTitle =>
      'Ново съобщение от обслужването на клиенти';

  @override
  String get notificationNewMessageBody => 'Получихте ново съобщение';

  @override
  String get notificationImagePreview => 'Изпрати изображение';

  @override
  String get notificationVideoPreview => 'Изпрати видео';

  @override
  String get notificationVoicePreview => 'Изпрати гласово съобщение';

  @override
  String get notificationFilePreview => 'Изпрати файл';

  @override
  String get notificationContactPreview => 'Изпрати контактна карта';

  @override
  String get notificationCallLogPreview => 'Изпрати запис за обаждане';

  @override
  String get notificationLocationPreview => 'Сподели местоположение';

  @override
  String get notificationLinkPreview => 'Сподели връзка';

  @override
  String notificationMentionMe(String body) {
    return 'Спомена ви: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender ви спомена: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Спомена всички: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender спомена всички: $body';
  }

  @override
  String get notificationSecurityTitle => 'Сигнал за сигурността на профила';

  @override
  String get notificationSecurityBody =>
      'Настройките за сигурност на StartLink профила ви са променени. Проверете ги сега.';

  @override
  String get notificationFriendAcceptedTitle =>
      'Заявката за приятелство е приета';

  @override
  String get notificationFriendRejectedTitle =>
      'Заявката за приятелство е отказана';

  @override
  String get notificationFriendAcceptedBody =>
      'Събеседникът прие заявката ви за приятелство';

  @override
  String get notificationFriendRejectedBody =>
      'Събеседникът отказа заявката ви за приятелство';

  @override
  String get notificationVideoCallTitle => 'Покана за видеоразговор';

  @override
  String get notificationAudioCallTitle => 'Покана за гласово обаждане';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller ви покани на видеоразговор';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller ви покани на гласово обаждане';
  }

  @override
  String get notificationMessageChannelName => 'Съобщения';

  @override
  String get notificationMessageChannelDescription =>
      'Съобщения от разговори, записи за обаждания и системни сигнали';

  @override
  String get notificationCallChannelName => 'Обаждания';

  @override
  String get notificationCallChannelDescription =>
      'Сигнали за гласови и видеообаждания';

  @override
  String get notificationSecurityChannelName => 'Сигурност на профила';

  @override
  String get notificationSecurityChannelDescription =>
      'Сигнали за вход и промени на парола и мобилен номер';

  @override
  String get notificationUnknownCaller => 'Непознат обаждащ се';

  @override
  String get pendingJoinRequestsTitle => 'Нови заявления';

  @override
  String get pendingJoinRequestsEmpty => 'Няма заявления';

  @override
  String get pendingJoinRequestApprove => 'Съгласен съм';

  @override
  String get pendingJoinRequestReject => 'Отказ';

  @override
  String get pendingJoinRequestApproveSuccess => 'Одобрено';

  @override
  String get pendingJoinRequestRejectSuccess => 'Отхвърлено';

  @override
  String get pendingJoinRequestFailed =>
      'Операцията е неуспешна. Опитайте отново.';

  @override
  String get myCustomersTitle => 'Моите клиенти';

  @override
  String get myCustomersEmpty => 'Няма клиенти';

  @override
  String get groupListTitle => 'Групи';

  @override
  String get groupListEmpty => 'Няма групи';

  @override
  String get addFriendTitle => 'Добави контакт';

  @override
  String get addFriendSearchHint => 'Телефон / имейл / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'Добави';

  @override
  String get addFriendCannotAddSelf => 'Не можете да добавите себе си';

  @override
  String get addFriendUnsupportedUser =>
      'Този потребител не може да бъде добавен. Можете да му пишете директно.';

  @override
  String get addFriendMessageHint => 'Въведете съобщение';

  @override
  String get addFriendSendRequest => 'Изпрати заявка';

  @override
  String get joinCompanyTitle => 'Присъедини се към фирма';

  @override
  String get joinCompanyCodeHint => 'Въведете фирмения код';

  @override
  String get joinCompanySearchHint => 'Търси име на фирма';

  @override
  String get joinCompanyApply => 'Кандидатствай за присъединяване';

  @override
  String get joinCompanyApplySuccess => 'Заявлението е изпратено';

  @override
  String get joinCompanyApplyFailed =>
      'Кандидатстването е неуспешно. Опитайте отново.';

  @override
  String get joinCompanyAutoApproved => 'Автоматично одобрение. Добре дошли!';

  @override
  String get joinCompanyPending => 'Заявлението е изпратено и чака одобрение';

  @override
  String get joinCompanyInviteCodeHint => 'Въведете кода за покана';

  @override
  String get joinCompanyAcceptInvite => 'Приеми поканата';

  @override
  String get joinCompanyNoResults => 'Няма намерени фирми';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count членове';
  }

  @override
  String get timezoneNameHawaii => 'Хавай';

  @override
  String get timezoneNameAlaska => 'Аляска';

  @override
  String get timezoneNamePacificTime => 'Тихоокеанско време';

  @override
  String get timezoneNameMountainTime => 'Планинско време';

  @override
  String get timezoneNameCentralTime => 'Централно време';

  @override
  String get timezoneNameEasternTime => 'Източно време';

  @override
  String get timezoneNameAtlanticTime => 'Атлантическо време';

  @override
  String get timezoneNameBrasilia => 'Бразилия';

  @override
  String get timezoneNameAzores => 'Азорски острови';

  @override
  String get timezoneNameLondonDublin => 'Лондон/Дъблин';

  @override
  String get timezoneNameBerlinParisRome => 'Берлин/Париж/Рим';

  @override
  String get timezoneNameCairoHelsinki => 'Кайро/Хелзинки';

  @override
  String get timezoneNameMoscowRiyadh => 'Москва/Рияд';

  @override
  String get timezoneNameTehran => 'Техеран';

  @override
  String get timezoneNameDubaiBaku => 'Дубай/Баку';

  @override
  String get timezoneNameKabul => 'Кабул';

  @override
  String get timezoneNameKarachiTashkent => 'Карачи/Ташкент';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Мумбай/Ню Делхи';

  @override
  String get timezoneNameKathmandu => 'Катманду';

  @override
  String get timezoneNameDhakaAlmaty => 'Дака/Алмати';

  @override
  String get timezoneNameYangon => 'Янгон';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Банкок/Ханой/Джакарта';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Пекин/Шанхай/Хонконг/Тайпе';

  @override
  String get timezoneNameTokyoSeoul => 'Токио/Сеул';

  @override
  String get timezoneNameAdelaide => 'Аделаида';

  @override
  String get timezoneNameSydneyMelbourne => 'Сидни/Мелбърн';

  @override
  String get timezoneNameSolomonIslands => 'Соломонови острови';

  @override
  String get timezoneNameAucklandFiji => 'Окланд/Фиджи';

  @override
  String get networkSmartSelectBestRoute =>
      'Интелигентен избор на най-добрия маршрут';

  @override
  String get networkTesting => 'Тестване...';

  @override
  String get networkTestingShort => 'Тестване';

  @override
  String networkLatencyMs(int ms) {
    return 'Закъснение $ms мс';
  }

  @override
  String get networkConnectionMode => 'Режим на свързване';

  @override
  String get networkDirectMode => 'Директен режим';

  @override
  String get networkProxyMode => 'Режим с прокси';

  @override
  String get networkDirectModeDesc => 'Директно свързване със сървъра';

  @override
  String get networkProxyModeDesc => 'Свързване чрез прокси сървър';

  @override
  String get networkDirectRoutes => 'Директни маршрути';

  @override
  String get networkProxyRoutes => 'Маршрути с прокси';

  @override
  String get networkTestAll => 'Тествай всички';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Възел в Хонконг';

  @override
  String get networkSingaporeNode => 'Възел в Сингапур';

  @override
  String get networkJapanNode => 'Възел в Япония';

  @override
  String get networkUnitedStatesNode => 'Възел в САЩ';

  @override
  String get networkHint =>
      'Съвети:\n• Директен режим: по-бърз и подходящ за използване в страната\n• Режим с прокси: по-стабилен за международна комуникация\n• Докоснете иконата за опресняване, за да тествате закъснението на отделен маршрут';

  @override
  String get teenModeTitle => 'Режим за непълнолетни';

  @override
  String get teenModeStatusOn => 'Включено';

  @override
  String get teenModeStatusOff => 'Изключен';

  @override
  String get teenModeStatusLoading => 'Зареждане';

  @override
  String get teenModeUnavailable =>
      'Състоянието на режима за непълнолетни временно не е достъпно';

  @override
  String get teenModeInvalidResponse =>
      'Режимът за непълнолетни върна невалиден отговор';

  @override
  String get teenModeEnableDescription =>
      'Правилата на платформата ограничават времето на използване и определени функции.';

  @override
  String get teenModePasscode => 'Код за достъп';

  @override
  String get teenModeCurrentPasscode => 'Текущ код за достъп';

  @override
  String get teenModeNewPasscode => 'Нов код за достъп';

  @override
  String get teenModePasscodeHint => 'Въведете 4–6 цифри';

  @override
  String get teenModeEnable => 'Включи режима за непълнолетни';

  @override
  String get teenModeDisable => 'Изключи режима за непълнолетни';

  @override
  String get teenModeChangePasscode => 'Промени кода за достъп';

  @override
  String get teenModeSource => 'Включен от';

  @override
  String get teenModeDailyUsage => 'Използвано днес';

  @override
  String get teenModeRemaining => 'Оставащо време';

  @override
  String get teenModeMinutesUnit => 'Минути';

  @override
  String get teenModeUnlimited => 'Без ограничение';

  @override
  String get teenModeRequestExtension => 'Поискай още време';

  @override
  String get teenModeExtensionSubmitted =>
      'Заявката за допълнително време е изпратена до настойник';

  @override
  String get teenModeTimeLimitReached =>
      'Днешното ограничение за използване е достигнато';

  @override
  String get teenModeCurfewActive =>
      'В момента използването е ограничено по график';

  @override
  String get teenModeReliefHint =>
      'Все още можете да преглеждате историята, да се свързвате с официалната поддръжка и да съобщавате за проблеми.';

  @override
  String get teenModeRestrictedNotice =>
      'Режимът за непълнолетни в момента не позволява изпращане на съобщения';

  @override
  String get teenModeActionBlocked =>
      'Режимът за непълнолетни в момента не позволява това действие';

  @override
  String get teenModeMyRequests => 'Моите заявки';

  @override
  String get guardianCenterTitle => 'Център за настойници';

  @override
  String get guardianRelationships => 'Връзки с настойници';

  @override
  String get guardianMinors => 'Деца под мой надзор';

  @override
  String get guardianApprovals => 'Чакащи одобрения';

  @override
  String get guardianBind => 'Въведи код за свързване';

  @override
  String get guardianCreateMinorCode => 'Аз съм дете — създай код';

  @override
  String get guardianCreateGuardianCode => 'Аз съм настойник — създай код';

  @override
  String get guardianRelation => 'Връзка';

  @override
  String get guardianPrimary => 'Основен настойник';

  @override
  String get guardianCode => '6-цифрен код за свързване';

  @override
  String get guardianCodeHint => 'Въведете кода, предоставен от другия човек';

  @override
  String get guardianCodeCreated =>
      'Кодът е създаден. Споделете го, преди да изтече.';

  @override
  String get guardianEmpty => 'Няма връзки с настойници';

  @override
  String get guardianNoMinors => 'Няма деца под надзор';

  @override
  String get guardianUnbind => 'Премахни връзката';

  @override
  String get guardianExtend => 'Добави време за детето';

  @override
  String get guardianPolicyTitle => 'Правила за използване';

  @override
  String get guardianPolicyLocked => 'Заключено от платформата';

  @override
  String get approvalEmpty => 'Няма заявки';

  @override
  String get approvalApprove => 'Съгласен съм';

  @override
  String get approvalReject => 'Отказ';

  @override
  String get approvalPending => 'Чакаща';

  @override
  String get approvalApproved => 'Одобрено';

  @override
  String get approvalRejected => 'Отказан';

  @override
  String get approvalExpired => 'Изтекъл';

  @override
  String get approvalCancelled => 'Отменено';

  @override
  String get approvalReplayFailed =>
      'Първоначалното действие е неуспешно. Опитайте отново.';

  @override
  String get requestCancelled => 'Заявката е отменена';

  @override
  String get kycTitle => 'Потвърждаване на самоличността';

  @override
  String get kycNotRequired => 'Не се изисква потвърждаване на самоличността';

  @override
  String get kycVerified => 'Самоличността е потвърдена';

  @override
  String get kycDeclared => 'Данните за самоличността са изпратени';

  @override
  String get kycPending => 'В процес на преглед';

  @override
  String get kycRejected => 'Заявката е отхвърлена';

  @override
  String get kycNone => 'Не са подадени данни за самоличността';

  @override
  String get kycRealName => 'Пълно име';

  @override
  String get kycIdNumber => 'Номер на документа';

  @override
  String get kycIdType => 'Тип на документа';

  @override
  String get kycApplicability =>
      'Въведете истинските си данни за избрания документ. Приеманите видове са показани в списъка.';

  @override
  String get kycCamera => 'Снимай';

  @override
  String get kycGallery => 'Изберете от албума';

  @override
  String get kycPhotoLimit => 'Максимум за снимка';

  @override
  String get kycSelectPhoto => 'Изберете снимка';

  @override
  String get kycPhotoSelected => 'Избрано';

  @override
  String get kycViewPhoto => 'Докоснете, за да видите снимката';

  @override
  String get kycReplacePhoto => 'Избери друга снимка';

  @override
  String get kycDisclosure =>
      'Използваме името ви, номера на документа и снимките на документа, за да проверим самоличността ви. Без тях не можете да подадете заявка и някои ограничени функции може да са недостъпни.';

  @override
  String get kycConsent =>
      'Давам отделно съгласие за това обработване на данните за самоличността ми';

  @override
  String get kycConsentRequired =>
      'Моля, дайте отделно съгласие преди изпращане';

  @override
  String get kycResubmitTitle => 'Подай данните за самоличността отново';

  @override
  String get kycResubmitWarning =>
      'Повторното подаване ще замени чакащата ви заявка. Продължаване?';

  @override
  String get kycSubmitting => 'Изпращане';

  @override
  String get kycSubmitFailed => 'Изпращането е неуспешно. Опитайте отново.';

  @override
  String get kycSubmitUnavailable =>
      'В момента не могат да бъдат подадени данни за самоличността';

  @override
  String get kycResubmitNotAllowed =>
      'След отхвърляне не е възможно повторно подаване. При нужда се свържете с поддръжката.';

  @override
  String get kycDailyLimit =>
      'Достигнахте днешния лимит за подаване на заявки. Опитайте утре.';

  @override
  String get kycTypeUnavailable =>
      'Няма налични видове документи. Опитайте по-късно.';

  @override
  String get kycNameInvalid => 'Името по документ трябва да е от 2 до 64 знака';

  @override
  String get kycNumberRequired => 'Въведете номера на документа си';

  @override
  String get kycFrontRequired => 'Качете лицевата страна на документа';

  @override
  String get kycBackRequired => 'Качете обратната страна на документа';

  @override
  String get kycPhotoTooLarge =>
      'Снимката надвишава допустимия размер. Компресирайте я и опитайте отново.';

  @override
  String get kycAccountChanged =>
      'Профилът или пространството е променено. Отворете отново тази страница.';

  @override
  String get kycPhotoInvalid => 'Изберете валидно изображение';

  @override
  String get kycPortraitSide => 'Страна със снимката';

  @override
  String get kycEmblemSide => 'Страна с емблемата';

  @override
  String get kycPassportDataPage => 'Страница с данни в паспорта';

  @override
  String get kycPassportOtherPage =>
      'Страница за визи или празна страница в паспорта';

  @override
  String get kycFront => 'Предна страна на личната карта';

  @override
  String get kycBack => 'Задна страна на личната карта';

  @override
  String get kycRequired =>
      'Преди създаване на група трябва да потвърдите самоличността си';

  @override
  String get kycGoVerify => 'Потвърди сега';

  @override
  String get kycStatusUnknown =>
      'Състоянието на проверката е недостъпно. Опреснете по-късно.';

  @override
  String get kycSuperseded =>
      'Тази заявка е заменена с по-нова. Проверете последното състояние на самоличността си.';

  @override
  String get kycMediaNotFound =>
      'Снимката на документа е недостъпна в това пространство. Изберете я отново преди подаване.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Известия до клиенти';

  @override
  String get officialAccountBadge => 'Официално';

  @override
  String get officialAccountOpenConversation => 'Отвори разговора';

  @override
  String get officialAccountJoinHint =>
      'Добавянето на този профил ви присъединява към фирмата като клиент. Не е нужно одобрение за приятелство.';

  @override
  String get officialAccountJoinDisabled =>
      'Тази фирма не приема нови клиенти. Свържете се с поддръжката.';

  @override
  String get officialAccountRemoved =>
      'Отстранени сте от тази фирма. Помолете фирмата да ви покани отново.';

  @override
  String get officialAccountBanned => 'Профилът ви е деактивиран в тази фирма.';

  @override
  String get officialAccountUnavailable =>
      'Този официален профил в момента е недостъпен.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Присъединяването към фирма не е разрешено в текущия режим.';

  @override
  String get officialAccountPlatformRequired =>
      'Използвайте профил в платформата, за да добавите този официален профил.';

  @override
  String get officialAccountOpenFailed =>
      'Разговорът не можа да се отвори. Опитайте отново.';

  @override
  String get officialAccountAccountChanged =>
      'Профилът или пространството е променено. Отворете отново.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Фирменият указател не е актуален. Опитайте след малко.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Синхронизирането на официалния профил е неуспешно. Локалното съдържание остава достъпно.';

  @override
  String get officialAccountInboxSyncing =>
      'Синхронизиране на съобщенията от официалния профил';

  @override
  String get diagnosticsTitle => 'Диагностика';

  @override
  String get diagnosticsExplanation =>
      'Поверителните данни в дневниците са скрити. Те съдържат информация за работата и грешките на този профил и пространство, както и общи събития при стартиране. Съдържанието на разговорите и данните за достъп са изключени.';

  @override
  String get diagnosticsHour => 'Последният час';

  @override
  String get diagnosticsDay => 'Последните 24 часа';

  @override
  String get diagnosticsWeek => '7 дн.';

  @override
  String diagnosticsEventCount(int count) {
    return 'Налични събития: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Дневниците се запазват на това устройство и остават достъпни след рестартиране.';

  @override
  String get diagnosticsNotPersistent =>
      'Някои записи не са запазени. Опреснете, за да опитате отново.';

  @override
  String get diagnosticsExport => 'Експортирай и сподели';

  @override
  String get diagnosticsRefresh => 'Обнови';

  @override
  String get diagnosticsClear => 'Изчисти дневниците на това пространство';

  @override
  String get diagnosticsClearConfirm =>
      'Да се изчистят ли диагностичните дневници за това пространство? Историята на разговорите ще се запази.';

  @override
  String get diagnosticsShared =>
      'Системното споделяне е завършено. Проверете файла в приемащото приложение.';

  @override
  String get diagnosticsCancelled =>
      'Споделянето е отменено. Можете да експортирате отново.';

  @override
  String get diagnosticsUnconfirmed =>
      'Споделянето не можа да бъде потвърдено. Проверете приемащото приложение.';

  @override
  String get diagnosticsFailed => 'Действието е неуспешно. Опитайте отново.';
}
