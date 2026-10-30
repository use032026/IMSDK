// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get navWorkbench => 'Рабочее место';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Не удалось загрузить данные аккаунта';

  @override
  String get startupFailureTitle => 'Ошибка запуска';

  @override
  String get startupFailureMessage => 'Проверьте сеть и повторите попытку';

  @override
  String get privacyConsentTitle =>
      'Условия использования и Политика конфиденциальности';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Добро пожаловать в $brand. Для входа в аккаунт, обмена сообщениями, корпоративного взаимодействия, онлайн-поддержки, уведомлений и защиты безопасности нам необходимо обрабатывать нужную информацию в соответствии с Условиями использования и Политикой конфиденциальности.\n\nДо нажатия «Принимаю» мы не читаем буфер обмена, не инициализируем JPush/JCore или SDK push-уведомлений производителей устройств и не используем эти SDK для доступа к Android ID, OAID, списку установленных приложений, MAC-адресам и подобным данным. Если вы пока откажетесь, мы сохраним этот выбор; вы сможете продолжить чтение документов и изменить решение позже.\n\nПосле согласия для доставки уведомлений о сообщениях, поддержке и входящих звонках JPush/JCore и push-сервисы производителей устройств могут обрабатывать модель устройства, версию Android, имя пакета и версию приложения, тип сети, IP-адрес, Android ID, OAID, Registration ID, push-токен производителя, данные доставки уведомлений и нажатий на них. Мы отключили необязательные возможности: умные push-уведомления, список установленных приложений, MAC, IMEI, IMSI, списки Wi-Fi, автоматическое пробуждение и связанный запуск.\n\nБуфер обмена доступен только при использовании копирования или вставки. Разрешения на камеру, микрофон, уведомления и другие системные функции запрашиваются только при использовании соответствующей функции. Отказ в одном разрешении затронет только связанную с ним функцию. Ознакомьтесь с полными документами ниже и решите, согласны ли вы.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Добро пожаловать в $brand. Для входа в аккаунт, обмена сообщениями, корпоративного взаимодействия, онлайн-поддержки, уведомлений и защиты безопасности нам необходимо обрабатывать нужную информацию в соответствии с Условиями использования и Политикой конфиденциальности.\n\nДо нажатия «Принимаю» мы не читаем буфер обмена, не инициализируем JPush/JCore, не регистрируемся в Apple Push Notification service (APNs) и не получаем push-идентификаторы, например JPush Registration ID или токен устройства APNs. Если вы пока откажетесь, мы сохраним этот выбор; вы сможете продолжить чтение документов и изменить решение позже.\n\nПосле согласия для доставки уведомлений о сообщениях, поддержке и входящих звонках мы можем обрабатывать модель iPhone, версию iOS, имя пакета и версию приложения, тип сети, IP-адрес, IDFV, JPush Registration ID, токен устройства APNs, данные доставки уведомлений и нажатий на них. JPush/JCore подключается к push-сервису; Apple APNs обрабатывает идентификатор приложения, токен устройства и содержимое уведомления для доставки системных уведомлений. Текущая версия приложения для iOS не использует рекламные сервисы и не получает IDFA.\n\nБуфер обмена доступен только при использовании копирования или вставки. Разрешения на камеру, микрофон, уведомления и другие системные функции запрашиваются только при использовании соответствующей функции. Отказ в одном разрешении затронет только связанную с ним функцию. Ознакомьтесь с полными документами ниже и решите, согласны ли вы.';
  }

  @override
  String get privacyConsentTermsLink => 'Пользовательское соглашение';

  @override
  String get privacyConsentConjunction => 'и';

  @override
  String get privacyConsentPrivacyLink => 'Политика конфиденциальности';

  @override
  String get privacyConsentDecline => 'Не согласен';

  @override
  String get privacyConsentDeclinedExit =>
      'Вы не приняли Условия использования и Политику конфиденциальности. Приложение закроется.';

  @override
  String get privacyConsentAccept => 'Согласен';

  @override
  String get privacyConsentRuntimeFailure =>
      'Ошибка запуска. Проверьте сеть и повторите попытку.';

  @override
  String get privacyConsentSaveFailure =>
      'Не удалось сохранить выбор. Повторите попытку.';

  @override
  String get appUpdateRequiredTitle => 'Обновите приложение, чтобы продолжить';

  @override
  String get appUpdateOptionalTitle => 'Доступна новая версия';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Доступна версия $brand $version';
  }

  @override
  String get appUpdateLater => 'Позже';

  @override
  String get appUpdateNow => 'Обновить сейчас';

  @override
  String get appUpdateProcessing => 'Обработка...';

  @override
  String get appUpdateInvalidUrl =>
      'Недействительный адрес обновления. Повторите попытку позже.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Не удалось открыть ссылку обновления. Повторите попытку позже.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Загрузка прервана. Проверьте сеть и повторите попытку.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Проверка пакета не пройдена. Загрузите его ещё раз.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Разрешите $brand устанавливать обновления в системных настройках.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Не удалось открыть системный установщик. Проверьте разрешения на установку.';

  @override
  String get appUpdateGenericFailure =>
      'Ошибка обновления. Проверьте сеть и повторите попытку.';

  @override
  String get appUpdateUnavailable =>
      'Новая версия пока недоступна для загрузки. Повторите попытку позже.';

  @override
  String get appUpdateCheckFailed =>
      'Не удалось проверить обновления. Повторите попытку позже.';

  @override
  String get appUpdateChecking => 'Проверка';

  @override
  String get commonConfirm => 'ОК';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonEdit => 'Редактировать';

  @override
  String get commonDelete => 'Удалить';

  @override
  String get commonSearch => 'Поиск';

  @override
  String get commonLoading => 'Загрузка...';

  @override
  String get commonLoadFailed => 'Не удалось загрузить';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonEmpty => 'Нет данных';

  @override
  String get commonCopy => 'Копировать';

  @override
  String get commonForward => 'Переслать';

  @override
  String get commonFavorite => 'Сохранить';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonSend => 'Отправить';

  @override
  String get commonDone => 'Готово';

  @override
  String get commonMore => 'Еще';

  @override
  String get commonSettings => 'Настройки';

  @override
  String get commonCopied => 'Скопировано';

  @override
  String get commonUnknown => 'Неизвестно';

  @override
  String get commonNotSet => 'Не задано';

  @override
  String get commonUnbound => 'Не привязано';

  @override
  String get commonViewAll => 'Показать всё';

  @override
  String get commonSubmit => 'Отправить';

  @override
  String get commonAdd => 'Добавить';

  @override
  String get commonRemove => 'Удалить';

  @override
  String get commonCreate => 'Создать';

  @override
  String get commonUpdate => 'Обновить';

  @override
  String get commonUpload => 'Загрузить';

  @override
  String get commonShare => 'Поделиться';

  @override
  String get commonBlock => 'Заблокировать';

  @override
  String get commonUnblock => 'Разблокировать';

  @override
  String get commonMute => 'Без звука';

  @override
  String get commonUnmute => 'Включить звук';

  @override
  String get commonPin => 'Закрепленные';

  @override
  String get commonUnpin => 'Открепить';

  @override
  String get commonMarkRead => 'Отметить прочитанным';

  @override
  String get commonMarkUnread => 'Отметить непрочитанным';

  @override
  String get commonOnline => 'В сети';

  @override
  String get commonOffline => 'Не в сети';

  @override
  String get commonOperationFailed =>
      'Не удалось выполнить действие. Повторите попытку';

  @override
  String get commonNetworkError => 'Ошибка сети. Проверьте подключение';

  @override
  String get navMessages => 'Сообщения';

  @override
  String get navContacts => 'Контакты';

  @override
  String get navMe => 'Я';

  @override
  String get authLoginTitle => 'Войти в StartLink';

  @override
  String get authTabMobile => 'Телефон';

  @override
  String get authTabEmail => 'Электронная почта';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'Введите номер телефона';

  @override
  String get authHintEmail => 'Введите ваш адрес электронной почты';

  @override
  String get authHintPassword => 'Введите пароль';

  @override
  String get authHintCode => 'Введите код подтверждения';

  @override
  String get authHintLoginName => 'Введите StartLink ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Войти';

  @override
  String get authGetCode => 'Получить код';

  @override
  String authResendCode(int seconds) {
    return 'Отправить повторно через $seconds с';
  }

  @override
  String get authUsePassword => 'Использовать пароль';

  @override
  String get authUseCode => 'Использовать код подтверждения';

  @override
  String get authAgreementPrefix => 'Я ознакомился и соглашаюсь с';

  @override
  String get authAgreementAnd => 'и';

  @override
  String get authTermsLink => 'Пользовательское соглашение';

  @override
  String get authPrivacyLink => 'Политика конфиденциальности';

  @override
  String get authCaptchaTitle => 'Проверка безопасности';

  @override
  String get authCaptchaHint => 'Введите ответ';

  @override
  String get authCaptchaFailed =>
      'Не удалось получить капчу. Повторите попытку';

  @override
  String get authErrorEmptyCode => 'Введите код подтверждения';

  @override
  String get authErrorEmptyPassword => 'Введите пароль';

  @override
  String get authErrorEmptyLoginName => 'Введите StartLink ID';

  @override
  String get authErrorWrongCredentials => 'Неверный аккаунт или пароль';

  @override
  String get authDeactivatingTitle => 'Удаление аккаунта';

  @override
  String get authDeactivatingContent =>
      'Ваш аккаунт находится в периоде ожидания удаления (7 дней).\n\nЧтобы отменить удаление, нажмите «Отменить удаление». Чтобы войти в приложение, нажмите «Продолжить».';

  @override
  String get authContinueUse => 'Продолжить';

  @override
  String get authCancelDeactivation => 'Отменить удаление';

  @override
  String get authDeactivationCancelled =>
      'Удаление отменено, аккаунт восстановлен';

  @override
  String get authDeactivationCancelFailed =>
      'Не удалось отменить. Повторите попытку';

  @override
  String get authLogout => 'Выйти из системы';

  @override
  String get authLogoutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get authSendingCode => 'Отправка...';

  @override
  String get authCodeSent => 'Код подтверждения отправлен';

  @override
  String get authLoginFailed => 'Не удалось войти. Повторите попытку';

  @override
  String get authRegisterFailed => 'Ошибка регистрации. Повторите попытку';

  @override
  String get authEnterpriseCode => 'Код компании';

  @override
  String get authEnterpriseCodeHint => 'Введите код компании';

  @override
  String get authPendingApproval =>
      'Регистрация завершена. Заявка на вступление в компанию отправлена и ожидает одобрения.';

  @override
  String get authNoAccount => 'Нет аккаунта?';

  @override
  String get authRegisterNow => 'Зарегистрироваться';

  @override
  String get authCountryPickerTitle => 'Выберите страну/регион';

  @override
  String get authCountrySearchHint => 'Найти страну/регион';

  @override
  String get authCountryChinaMainland => 'Материковый Китай';

  @override
  String get authCountryHongKong => 'Гонконг, Китай';

  @override
  String get authCountryMacau => 'Макао, Китай';

  @override
  String get authCountryTaiwan => 'Тайвань, Китай';

  @override
  String get authCountryUnitedStates => 'США';

  @override
  String get authCountryUnitedKingdom => 'Великобритания';

  @override
  String get authCountryJapan => 'Япония';

  @override
  String get authCountrySouthKorea => 'Южная Корея';

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
  String get authCountryThailand => 'Таиланд';

  @override
  String get authCountryVietnam => 'Вьетнам';

  @override
  String get authCountryIndonesia => 'Индонезия';

  @override
  String get authCountryPhilippines => 'Филиппины';

  @override
  String get authQuickLoginTitle => 'Быстрый вход';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Вход. Подождите.';

  @override
  String get authRoleOwner => 'Владелец';

  @override
  String get authRoleAdministrator => 'Администратор';

  @override
  String get authRoleCustomerService => 'Поддержка клиентов';

  @override
  String get authRoleTechnicalSupport => 'Техническая поддержка';

  @override
  String get authRoleEmployee => 'Сотрудник';

  @override
  String get authRoleMember => 'Участник';

  @override
  String get authRoleEnterpriseCustomer => 'Клиент компании';

  @override
  String get authUnavailablePrefix => 'Недоступно · ';

  @override
  String get authUnassignedService => 'Оператор не назначен';

  @override
  String authAssignedService(String staff) {
    return 'Назначено: $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Клиент · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Сотрудник · $tenant';
  }

  @override
  String authUserCount(int count) {
    return 'Пользователей: $count';
  }

  @override
  String get authMetaPhone => 'Телефон';

  @override
  String get authMetaIdentity => 'Статус';

  @override
  String get authRegisterTitle => 'Зарегистрироваться';

  @override
  String get authNickname => 'Псевдоним';

  @override
  String get authNicknameHint => 'Задайте псевдоним';

  @override
  String get authPassword => 'Пароль';

  @override
  String get authPasswordSetHint => 'Задайте пароль (не менее 6 символов)';

  @override
  String get authConfirmPassword => 'Повторите пароль';

  @override
  String get authConfirmPasswordHint => 'Введите пароль ещё раз';

  @override
  String get authVerificationCode => 'Код подтверждения';

  @override
  String get authRegisterAndLogin => 'Зарегистрироваться и войти';

  @override
  String get authHaveAccount => 'Уже есть аккаунт?';

  @override
  String get authGoLogin => 'Войти';

  @override
  String get authEmailVerificationUnavailable =>
      'Подтверждение по email недоступно. Зарегистрируйтесь по номеру мобильного телефона.';

  @override
  String get authSmsVerificationUnavailable =>
      'Подтверждение по SMS недоступно. Зарегистрируйтесь по email.';

  @override
  String get authSendFailed => 'Не удалось отправить. Повторите попытку.';

  @override
  String get authErrorEmptyNickname => 'Введите псевдоним';

  @override
  String get authErrorInvalidMobile =>
      'Введите корректный номер мобильного телефона';

  @override
  String get authErrorInvalidEmail => 'Введите корректный адрес email';

  @override
  String get authErrorPasswordTooShort =>
      'Пароль должен содержать не менее 6 символов';

  @override
  String get authErrorPasswordMismatch => 'Пароли не совпадают';

  @override
  String get authErrorVerificationRequired =>
      'Сначала получите и введите код подтверждения';

  @override
  String get authRegisterErrorTitle => 'Ошибка регистрации';

  @override
  String get authGotIt => 'Понятно';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Компания «$code» не найдена. Проверьте код компании.';
  }

  @override
  String get authTenantSearchFailed => 'Ошибка поиска. Повторите попытку.';

  @override
  String get authInvitationInvalid =>
      'Недействительный код приглашения. Проверьте его и повторите попытку.';

  @override
  String get authCollapseJoin => 'Скрыть сведения о вступлении';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Действительное приглашение: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Найдена компания: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Выберите организацию';

  @override
  String get authNoOrganization => 'Нет доступных организаций';

  @override
  String get authNoOrganizationHint =>
      'Попросите администратора пригласить вас в организацию';

  @override
  String get authPersonalSpace => 'Личное пространство';

  @override
  String get authPersonalSpaceSubtitle => 'Чаты с друзьями и личное избранное';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Не удалось проверить принадлежность пространства. Повторите попытку.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Не удалось восстановить личное пространство. Повторите попытку.';

  @override
  String get authJoinEnterpriseFailed =>
      'Не удалось вступить в компанию. Повторите попытку позже.';

  @override
  String get homeTitle => 'Сообщения';

  @override
  String get homeGatewayConnectingTitle => 'Подключение';

  @override
  String get homePersonalSpace => 'Личное';

  @override
  String get homeOfficialService => 'Официальный сервис';

  @override
  String get homeSwitchSpace => 'Сменить пространство';

  @override
  String get homeSpaceSubtitle => 'Личное · Компания';

  @override
  String get homeJoinEnterprise => 'Вступить в компанию';

  @override
  String get homeCreateGroup => 'Новая группа';

  @override
  String get homeAddFriend => 'Добавить контакт';

  @override
  String get homeScan => 'Сканировать';

  @override
  String get homeJoinNewSpace => 'Вступить в новое пространство';

  @override
  String get homeSearchConversation => 'Поиск';

  @override
  String get homeNoMessages => 'Нет сообщений';

  @override
  String get homeDeleteConversation => 'Удалить чат';

  @override
  String get homeDeleteConversationConfirm =>
      'Удалить этот чат? История чата будет очищена.';

  @override
  String get homePersonalNote => 'Я (Личные заметки)';

  @override
  String get homeWorkNote => 'Я (Рабочие заметки)';

  @override
  String homeConversationCount(int count) {
    return 'Чатов: $count';
  }

  @override
  String homeUnreadCount(int count) {
    return 'Непрочитанных: $count';
  }

  @override
  String get chatInputHint => 'Введите сообщение...';

  @override
  String get chatVoiceHint => 'Удерживайте, чтобы говорить';

  @override
  String get chatVoiceRelease => 'Отпустите для отправки';

  @override
  String get chatVoiceCancel => 'Сдвиньте вверх для отмены';

  @override
  String get chatMenuCopy => 'Копировать';

  @override
  String get chatMenuForward => 'Переслать';

  @override
  String get chatMenuRecall => 'Отозвать';

  @override
  String get chatMenuDelete => 'Удалить';

  @override
  String get chatMenuFavorite => 'Сохранить';

  @override
  String get chatMenuReply => 'Ответить';

  @override
  String get chatMenuMultiSelect => 'Выбрать';

  @override
  String get chatMenuTranslate => 'Перевести';

  @override
  String get chatMenuVoiceToText => 'Преобразовать в текст';

  @override
  String get chatMenuTextToSpeech => 'Прочитать вслух';

  @override
  String get chatStatusRecalled => 'Сообщение отозвано';

  @override
  String get chatRecallSuccess => 'Отозвано';

  @override
  String get chatRecallFailed => 'Не удалось отозвать';

  @override
  String get chatRecallTimeout => 'Сообщения старше 2 минут нельзя отозвать';

  @override
  String get chatTranslateFailed => 'Ошибка перевода. Повторите попытку';

  @override
  String get chatTranslateNotConfigured => 'Сервис перевода недоступен';

  @override
  String get chatVoiceToTextFailed =>
      'Ошибка преобразования. Повторите попытку';

  @override
  String get chatTextToSpeechFailed =>
      'Не удалось прочитать вслух. Повторите попытку';

  @override
  String get chatVoiceToText => 'Преобразовать';

  @override
  String get chatForwardSuccess => 'Переслано';

  @override
  String get chatForwardFailed => 'Не удалось переслать. Повторите попытку';

  @override
  String get chatNoConversations => 'Нет чатов для пересылки';

  @override
  String get chatSendFailed => 'Не удалось отправить';

  @override
  String get chatResend => 'Отправить повторно';

  @override
  String get chatNotFriend => 'Нет в списке контактов';

  @override
  String get chatNotFriendHint =>
      'Вы ещё не добавлены в контакты. Отправка сообщений недоступна.';

  @override
  String get chatMutedHint => 'Всем участникам запрещено писать';

  @override
  String get chatFileUploadFailed =>
      'Не удалось загрузить файл. Повторите попытку';

  @override
  String get chatFileStatusNotDownloaded => 'Не скачано';

  @override
  String get chatFileStatusDownloaded => 'Скачано';

  @override
  String get chatFileStatusUploading => 'Загрузка';

  @override
  String get chatFileStatusUploadFailed => 'Загрузка не удалась';

  @override
  String get chatCardSendFailed => 'Не удалось отправить карточку контакта';

  @override
  String get chatFavoriteSuccess => 'Сохранено';

  @override
  String get chatFavoriteFailed => 'Не удалось добавить в избранное';

  @override
  String get chatLoadFailed => 'Не удалось загрузить';

  @override
  String get chatImageMessage => '[Изображение]';

  @override
  String get chatVoiceMessage => '[Голосовое сообщение]';

  @override
  String get chatVideoMessage => '[Видео]';

  @override
  String get chatFileMessage => '[Файл]';

  @override
  String get chatLocationMessage => '[Местоположение]';

  @override
  String get chatContactCardMessage => '[Контакт]';

  @override
  String get chatCallLogMessage => '[Звонок]';

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
  String get chatRecalledSelf => 'Вы отозвали сообщение';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender отозвал(а) сообщение';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Перевод: $translation';
  }

  @override
  String get chatMessageDeleted => 'Сообщение удалено';

  @override
  String get chatPeer => 'Другое';

  @override
  String get chatSelf => 'Я';

  @override
  String get chatGenericMessage => '[Сообщение]';

  @override
  String get chatVoiceHideText => 'Скрыть текст';

  @override
  String get chatVoiceShowText => 'Преобразовать в текст';

  @override
  String get chatFileDefaultName => 'Файл';

  @override
  String get chatContactDefaultName => 'Контакт';

  @override
  String get chatContactCardTitle => 'Карточка контакта';

  @override
  String get chatCallMissed => 'Пропущен';

  @override
  String get chatCallCancelled => 'Отменён';

  @override
  String get chatCallRejected => 'Отклонён';

  @override
  String get chatCallDisconnected => 'Соединение разорвано';

  @override
  String get chatCallEnded => 'Звонок завершён';

  @override
  String get chatCallFailed => 'Ошибка звонка';

  @override
  String chatCallDuration(String duration) {
    return 'Длительность $duration';
  }

  @override
  String get chatVideoCallTitle => 'Видеозвонок';

  @override
  String get chatVoiceCallTitle => 'Голосовой звонок';

  @override
  String get chatToolPhotos => 'Фото';

  @override
  String get chatToolCamera => 'Камера';

  @override
  String get chatToolFile => 'Файл';

  @override
  String get chatToolLocation => 'Местоположение';

  @override
  String get chatToolContactCard => 'Контакт';

  @override
  String get chatToolVoiceCall => 'Голосовой звонок';

  @override
  String get chatToolVideoCall => 'Видеозвонок';

  @override
  String get chatToolFavorites => 'Избранное';

  @override
  String get chatToolTranslate => 'Перевести';

  @override
  String get chatTranslationChooseLanguage => 'Выберите язык перевода';

  @override
  String get chatTranslationEnterText => 'Сначала введите текст';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Перевод недоступен для сообщений с упоминаниями';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Перевод недоступен при редактировании отложенного сообщения';

  @override
  String get chatTranslationFailed => 'Ошибка перевода. Повторите попытку';

  @override
  String get chatTranslationEmpty => 'Перевод не получен. Повторите попытку';

  @override
  String get chatTranslationTranslating => 'Перевод…';

  @override
  String get chatTranslationSend => 'Отправить перевод';

  @override
  String get chatTranslationSending => 'Отправка…';

  @override
  String get chatTranslationExpand => 'Показать больше';

  @override
  String get chatTranslationCollapse => 'Показать меньше';

  @override
  String get chatFileTooLarge => 'Размер файла превышает лимит (100 МБ)';

  @override
  String get chatInputMutedAdminOnly =>
      'Писать могут только владелец и выбранные участники.';

  @override
  String get chatImageUploadUnsupported =>
      'Не удалось загрузить изображение. Сервер пока не поддерживает эту функцию.';

  @override
  String get chatFavoriteLongPressHint =>
      'Удерживайте сообщение, чтобы добавить его в избранное';

  @override
  String chatSelectedCount(int count) {
    return 'Выбрано: $count';
  }

  @override
  String get chatLocationSheetTitle => 'Отправить местоположение';

  @override
  String get chatLocationNameLabel => 'Название места';

  @override
  String get chatLocationNameHint => 'Например, офис или адрес клиента';

  @override
  String get chatLocationAddressLabel => 'Адрес';

  @override
  String get chatLocationOptionalHint => 'Необязательно';

  @override
  String get chatLocationLatitudeLabel => 'Широта';

  @override
  String get chatLocationLatitudeHint => 'От -90 до 90';

  @override
  String get chatLocationLongitudeLabel => 'Долгота';

  @override
  String get chatLocationLongitudeHint => 'От -180 до 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Введите $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label вне допустимого диапазона';
  }

  @override
  String get chatLocationDefaultTitle => 'Местоположение';

  @override
  String get chatMutedFullNotice =>
      'В группе запрещено писать. Писать могут только владелец и выбранные участники.';

  @override
  String get chatNotFriendSendBlocked =>
      'Вы больше не друзья и не можете отправлять сообщения';

  @override
  String get chatPersonalNotesTitle => 'Личные заметки';

  @override
  String get chatWorkNotesTitle => 'Рабочие заметки';

  @override
  String get chatPersonalNotesDescription =>
      'Записывайте личные мысли и сохраняйте важную информацию\nСинхронизация между устройствами для доступа в любое время';

  @override
  String get chatWorkNotesDescription =>
      'Записывайте рабочие задачи и сохраняйте материалы\nПространства команд остаются раздельными и защищёнными';

  @override
  String get chatNoMessages => 'Нет сообщений';

  @override
  String chatReplyTo(String sender) {
    return 'Ответить: $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature скоро появится';
  }

  @override
  String get chatForwardSelectTitle => 'Выберите чат';

  @override
  String get chatContactSelectTitle => 'Выберите контакт';

  @override
  String get chatNoContacts => 'Нет контактов';

  @override
  String get contactsTitle => 'Контакты';

  @override
  String get contactsSearch => 'Поиск контактов';

  @override
  String get contactsNewFriends => 'Новые друзья';

  @override
  String get contactsGroups => 'Группы';

  @override
  String get contactsFavorites => 'Избранное';

  @override
  String get contactsRecent => 'Недавние';

  @override
  String get contactsOrganization => 'Организация';

  @override
  String get contactsAnnouncement => 'Объявления';

  @override
  String get contactsNewApplications => 'Новые заявки';

  @override
  String get contactsCustomerGroups => 'Группы клиентов';

  @override
  String get contactsAllCustomers => 'Все клиенты';

  @override
  String get contactsMyCustomers => 'Мои клиенты';

  @override
  String get contactsViewAll => 'Показать всё';

  @override
  String get contactsMyContacts => 'Мои контакты';

  @override
  String get contactsMyAdvisor => 'Мой консультант';

  @override
  String get contactsNoAdvisor => 'Консультант ещё не назначен';

  @override
  String get contactsAdvisorLoading => 'Загрузка...';

  @override
  String get contactsNavigateFailed =>
      'Не удалось открыть страницу. Повторите попытку';

  @override
  String get contactsEmpty => 'Нет контактов';

  @override
  String get contactsNoAnnouncement => 'Нет объявлений';

  @override
  String get contactsOfficialBadge => 'Официальный';

  @override
  String get contactsCustomerBadge => 'Клиент';

  @override
  String get contactsEmptyCustomers => 'Нет клиентов';

  @override
  String get myTitle => 'Я';

  @override
  String get myEnterpriseInfo => 'Информация о компании';

  @override
  String get myEnterpriseManage => 'Управление компанией';

  @override
  String get myQrCode => 'QR-код';

  @override
  String get myFavorites => 'Избранное';

  @override
  String get myLanguage => 'Язык';

  @override
  String get myTimezone => 'Часовой пояс';

  @override
  String get myAutoTranslate => 'Автоперевод';

  @override
  String get myNetworkSwitch => 'Сменить линию';

  @override
  String get mySettings => 'Настройки';

  @override
  String get myLogout => 'Выйти из системы';

  @override
  String get myLogoutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get myLeaveEnterprise => 'Выйти из компании';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Вы уверены, что хотите выйти из этой компании? Вы потеряете доступ к её данным.';

  @override
  String get myLeaveEnterpriseSuccess => 'Вы вышли из компании';

  @override
  String get myLeaveEnterpriseFailed => 'Не удалось выйти. Повторите попытку';

  @override
  String get myLppIdCopied => 'StartLink ID скопирован';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return 'Контактов: $count';
  }

  @override
  String get myAutoSelect => 'Авто';

  @override
  String get myPresenceStatus => 'Статус присутствия';

  @override
  String get myPresenceStatusTitle => 'Задать статус';

  @override
  String get myPresenceOnline => 'В сети';

  @override
  String get myPresenceBusy => 'Занят';

  @override
  String get myPresenceAway => 'Отошёл';

  @override
  String get myPresenceInvisible => 'Невидимый';

  @override
  String get profileTitle => 'Мой профиль';

  @override
  String get profileName => 'Имя';

  @override
  String get profileGender => 'Пол';

  @override
  String get profileBirthday => 'Дата рождения';

  @override
  String get profileRegion => 'Регион';

  @override
  String get profileSignature => 'О себе';

  @override
  String get profileSignatureHint => 'Расскажите о себе';

  @override
  String get profileTapTapText => 'Похлопывание';

  @override
  String get profileTapTapHint => 'Текст при похлопывании (до 20 символов)';

  @override
  String get profileAccountSection => 'Аккаунт';

  @override
  String get profileBasicSection => 'Основная информация';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'Не задано';

  @override
  String get profileMobile => 'Телефон';

  @override
  String get profileMobileUnbound => 'Не привязано';

  @override
  String get profileEmail => 'Электронная почта';

  @override
  String get profileEmailUnbound => 'Не привязано';

  @override
  String get profileQrCode => 'Мой QR-код';

  @override
  String get profileChangePassword => 'Изменить пароль';

  @override
  String get profileGenderMale => 'Мужской';

  @override
  String get profileGenderFemale => 'Женский';

  @override
  String get profileGenderOther => 'Другое';

  @override
  String get profileGenderUnset => 'Не задано';

  @override
  String get profileSaveFailed => 'Не удалось сохранить. Повторите попытку';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'StartLink ID можно изменить только один раз. Выбирайте внимательно.';

  @override
  String get profileLppIdChangeFailed =>
      'Не удалось изменить (StartLink ID можно изменить только один раз)';

  @override
  String get profileChangePasswordOld => 'Текущий пароль';

  @override
  String get profileChangePasswordNew => 'Новый пароль';

  @override
  String get profileChangePasswordConfirm => 'Подтвердите новый пароль';

  @override
  String get profileChangePasswordMismatch => 'Пароли не совпадают';

  @override
  String get profileChangePasswordSuccess => 'Пароль изменён. Войдите снова.';

  @override
  String get profileChangePasswordFailed =>
      'Не удалось изменить пароль. Повторите попытку';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionEnterprise => 'Компания';

  @override
  String get settingsSectionAccount => 'Аккаунт';

  @override
  String get settingsSectionGeneral => 'Основные';

  @override
  String get settingsSectionFeatures => 'Возможности';

  @override
  String get settingsSectionAbout => 'О приложении';

  @override
  String get settingsEnterpriseInfo => 'Информация о компании';

  @override
  String get settingsProfile => 'Мой профиль';

  @override
  String get settingsAccountSecurity => 'Безопасность аккаунта';

  @override
  String get settingsNotification => 'Уведомления';

  @override
  String get settingsDisplay => 'Отображение';

  @override
  String get settingsFriendPrivacy => 'Конфиденциальность';

  @override
  String get settingsChat => 'Чат';

  @override
  String get settingsChatHistory => 'История чата';

  @override
  String get settingsAbout => 'О StartLink';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsTimezone => 'Часовой пояс';

  @override
  String get settingsAutoTranslate => 'Автоперевод';

  @override
  String get settingsNetworkSwitch => 'Сменить линию';

  @override
  String get enterpriseInfoTitle => 'Информация о компании';

  @override
  String get enterpriseName => 'Имя';

  @override
  String get enterpriseDescription => 'Описание';

  @override
  String get enterpriseUpdateSuccess => 'Успешно обновлено';

  @override
  String get enterpriseUpdateFailed => 'Ошибка обновления. Повторите попытку';

  @override
  String get enterpriseLeave => 'Выйти из компании';

  @override
  String get enterpriseLeaveConfirm =>
      'Вы уверены, что хотите выйти из этой компании?';

  @override
  String get enterpriseLeaveSuccess => 'Вы вышли из компании';

  @override
  String get enterpriseLeaveFailed => 'Не удалось выйти. Повторите попытку';

  @override
  String get enterpriseLeaveOwnerError =>
      'Владелец не может выйти напрямую. Сначала передайте права владельца.';

  @override
  String get enterpriseMemberCount => 'Участники';

  @override
  String get enterpriseCreatedAt => 'Создано';

  @override
  String get enterpriseCode => 'Код компании';

  @override
  String get enterpriseInviteMembers => 'Пригласить участников';

  @override
  String get enterpriseCopyInviteCode => 'Копировать код приглашения';

  @override
  String get enterpriseInviteCodeCopied => 'Код приглашения скопирован';

  @override
  String get groupCreateTitle => 'Новая группа';

  @override
  String get groupNameHint => 'Введите название группы';

  @override
  String get groupCreateSuccess => 'Группа создана';

  @override
  String get groupCreateFailed => 'Не удалось создать группу';

  @override
  String get groupSettings => 'Настройки группы';

  @override
  String get groupName => 'Название группы';

  @override
  String get groupAvatar => 'Аватар группы';

  @override
  String get groupAnnouncement => 'Объявление';

  @override
  String get groupMembers => 'Участники';

  @override
  String get groupAddMember => 'Добавить участников';

  @override
  String get groupRemoveMember => 'Удалить участника';

  @override
  String get groupRemoveMemberConfirm => 'Удалить этого участника?';

  @override
  String get groupSetAdmin => 'Назначить администратором';

  @override
  String get groupRemoveAdmin => 'Снять права администратора';

  @override
  String get groupTransferOwner => 'Передать права владельца';

  @override
  String get groupTransferOwnerConfirm =>
      'Передать права владельца группы этому участнику?';

  @override
  String get groupTransferOwnerSuccess => 'Права владельца переданы';

  @override
  String get groupTransferOwnerFailed =>
      'Не удалось передать. Повторите попытку';

  @override
  String get groupLeave => 'Выйти из группы';

  @override
  String get groupLeaveConfirm => 'Выйти из этой группы?';

  @override
  String get groupLeaveSuccess => 'Вы вышли из группы';

  @override
  String get groupLeaveFailed => 'Не удалось выйти. Повторите попытку';

  @override
  String get groupDissolve => 'Распустить группу';

  @override
  String get groupDissolveConfirm =>
      'Распустить эту группу? Все участники будут удалены.';

  @override
  String get groupDissolveSuccess => 'Группа распущена';

  @override
  String get groupDissolveFailed => 'Не удалось распустить. Повторите попытку';

  @override
  String get groupQrCode => 'QR-код группы';

  @override
  String get groupMuteAll => 'Запретить писать всем';

  @override
  String get groupMuteAllOn => 'Включить запрет для всех';

  @override
  String get groupMuteAllOff => 'Выключить запрет для всех';

  @override
  String get groupAllowMemberInvite => 'Разрешить участникам приглашать';

  @override
  String get groupAllowMemberModifyTitle =>
      'Разрешить участникам менять название группы';

  @override
  String get groupAllowMemberAtAll => 'Разрешить участникам упоминать @Всех';

  @override
  String get groupAllowMemberViewMemberList =>
      'Разрешить участникам видеть список участников';

  @override
  String get groupAllowQrCodeJoin => 'Разрешить вход по QR-коду';

  @override
  String get groupRequireApproval => 'Требовать одобрение для вступления';

  @override
  String get groupAllowMemberAddFriend =>
      'Разрешить участникам добавлять друг друга';

  @override
  String get groupRoleOwner => 'Владелец';

  @override
  String get groupRoleAdmin => 'Администратор';

  @override
  String get groupRoleMember => 'Участник';

  @override
  String get groupNoMembers => 'Нет участников';

  @override
  String get groupNoAnnouncements => 'Нет объявлений';

  @override
  String get groupCreateAnnouncement => 'Опубликовать объявление';

  @override
  String get groupEditAnnouncement => 'Изменить объявление';

  @override
  String get groupDeleteAnnouncement => 'Удалить объявление';

  @override
  String get groupDeleteAnnouncementConfirm => 'Удалить это объявление?';

  @override
  String get groupAnnouncementTitle => 'Заголовок';

  @override
  String get groupAnnouncementContent => 'Содержание';

  @override
  String get groupAnnouncementPin => 'Закрепить объявление';

  @override
  String groupMemberCount(int count) {
    return 'Участников: $count';
  }

  @override
  String groupSelectedCount(int count) {
    return 'Выбрано: $count';
  }

  @override
  String get groupJoinRequestApprove => 'Согласен';

  @override
  String get groupJoinRequestReject => 'Отклонить';

  @override
  String get groupJoinRequests => 'Заявки на вступление';

  @override
  String get groupNoJoinRequests => 'Нет заявок на вступление';

  @override
  String get groupReadReceipts => 'Отчёты о прочтении';

  @override
  String groupReadCount(int count) {
    return 'Прочитали: $count';
  }

  @override
  String groupUnreadCount(int count) {
    return 'Непрочитанных: $count';
  }

  @override
  String get friendAddTitle => 'Добавить контакт';

  @override
  String get friendSearchHint => 'Телефон / Email / StartLink ID';

  @override
  String get friendRequestSent => 'Запрос в друзья отправлен';

  @override
  String get friendRequestFailed => 'Не удалось отправить. Повторите попытку';

  @override
  String get friendAlreadyFriend => 'Уже в контактах';

  @override
  String get friendNewFriendsTitle => 'Новые друзья';

  @override
  String get friendNoRequests => 'Нет запросов в друзья';

  @override
  String get friendAccept => 'Принять';

  @override
  String get friendReject => 'Отклонить';

  @override
  String get friendAccepted => 'Принято';

  @override
  String get friendRejected => 'Отклонено';

  @override
  String get friendDeleteConfirm => 'Удалить этот контакт?';

  @override
  String get friendDeleteSuccess => 'Контакт удалён';

  @override
  String get friendDeleteFailed => 'Не удалось удалить. Повторите попытку';

  @override
  String get friendRemarkName => 'Псевдоним';

  @override
  String get friendGroupName => 'Группа';

  @override
  String get friendSendMessage => 'Сообщение';

  @override
  String get friendMatchTypeLppId => 'Совпадение по StartLink ID';

  @override
  String get friendMatchTypeMobile => 'Совпадение по телефону';

  @override
  String get friendMatchTypeEmail => 'Совпадение по email';

  @override
  String get friendSearchEmpty => 'Пользователи не найдены';

  @override
  String get friendAddMessage => 'Хочу добавить вас в контакты';

  @override
  String get friendBlockConfirm => 'Заблокировать этого пользователя?';

  @override
  String get friendUnblockConfirm => 'Разблокировать этого пользователя?';

  @override
  String get friendBlockSuccess => 'Заблокирован';

  @override
  String get friendUnblockSuccess => 'Разблокирован';

  @override
  String get profilePageTitle => 'Личная информация';

  @override
  String get profilePageSendMessage => 'Сообщение';

  @override
  String get profilePageAddFriend => 'Добавить в друзья';

  @override
  String get profilePageAlreadyFriend => 'Уже друзья';

  @override
  String get profilePageBlocked => 'Заблокирован';

  @override
  String get profilePageBlock => 'Заблокировать';

  @override
  String get profilePageUnblock => 'Разблокировать';

  @override
  String get profilePageHidden => 'Этот пользователь скрыл свой профиль';

  @override
  String get profilePageFriendsOnly =>
      'Этот пользователь показывает профиль только друзьям';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'Примечания';

  @override
  String get profilePageEditRemark => 'Изменить псевдоним';

  @override
  String get profilePageSaveRemarkSuccess => 'Псевдоним сохранён';

  @override
  String get profilePageSaveRemarkFailed =>
      'Не удалось сохранить. Повторите попытку';

  @override
  String get searchTitle => 'Поиск';

  @override
  String get searchHint => 'Поиск по телефону, email или StartLink ID';

  @override
  String get searchNoResults => 'Ничего не найдено';

  @override
  String get searchMessages => 'Сообщения';

  @override
  String get searchUsers => 'Пользователи';

  @override
  String get searchFailed => 'Ошибка поиска. Повторите попытку';

  @override
  String get scanTitle => 'Сканировать';

  @override
  String get scanFailed => 'Ошибка распознавания. Повторите попытку';

  @override
  String get scanInvalidQrCode => 'Недействительный QR-код';

  @override
  String get scanFlashOn => 'Включить фонарик';

  @override
  String get scanFlashOff => 'Выключить фонарик';

  @override
  String get scanAlbum => 'Выбрать из альбома';

  @override
  String get favoritesTitle => 'Избранное';

  @override
  String get favoritesEmpty => 'Ничего еще не сохранено';

  @override
  String get favoritesAll => 'Все';

  @override
  String get favoritesText => 'Текст';

  @override
  String get favoritesImage => 'Изображения';

  @override
  String get favoritesVideo => 'Видео';

  @override
  String get favoritesVoice => 'Голосовые сообщения';

  @override
  String get favoritesFile => 'Файлы';

  @override
  String get favoritesOther => 'Другое';

  @override
  String get favoritesDeleteConfirm => 'Удалить из избранного?';

  @override
  String get favoritesDeleteSuccess => 'Удалено из сохраненных';

  @override
  String get favoritesDeleteFailed => 'Не удалось удалить';

  @override
  String get favoritesOriginalRecalled => 'Сообщение отозвано';

  @override
  String get favoritesViewOriginal => 'Посмотреть оригинал';

  @override
  String get favoritesSearchHint => 'Поиск в избранном';

  @override
  String get favoritesNoResults => 'Нет подходящих элементов избранного';

  @override
  String get noticeTitle => 'Объявления';

  @override
  String get noticeEmpty => 'Нет объявлений';

  @override
  String get noticeDetail => 'Подробности объявления';

  @override
  String get noticePublishedAt => 'Опубликовано';

  @override
  String get noticePriorityNormal => 'Обычный';

  @override
  String get noticePriorityImportant => 'Важное';

  @override
  String get noticePriorityUrgent => 'Срочное';

  @override
  String get organizationTitle => 'Организация';

  @override
  String get organizationEmpty => 'Нет информации об отделе';

  @override
  String get organizationMembers => 'Участники';

  @override
  String get organizationDepartment => 'Отдел';

  @override
  String get organizationPosition => 'Должность';

  @override
  String get organizationLeader => 'Руководитель';

  @override
  String get qrCodeTitle => 'Мой QR-код';

  @override
  String get qrCodeSave => 'Сохранить в альбом';

  @override
  String get qrCodeShare => 'Поделиться';

  @override
  String get qrCodeSaveSuccess => 'Сохранено в альбом';

  @override
  String get qrCodeSaveFailed => 'Не удалось сохранить. Повторите попытку';

  @override
  String get qrCodeRefresh => 'Обновить QR-код';

  @override
  String get qrCodeExpired => 'Срок QR-кода истёк. Обновите его';

  @override
  String get qrCodeScanToAdd => 'Отсканируйте, чтобы добавить меня в контакты';

  @override
  String get spacePersonal => 'Личное';

  @override
  String get spaceEnterprise => 'Компания';

  @override
  String get spaceJoinByCode => 'Вступить по коду компании';

  @override
  String get spaceJoinByInvite => 'Вступить по коду приглашения';

  @override
  String get spaceEnterCode => 'Введите код компании';

  @override
  String get spaceEnterInviteCode => 'Введите код приглашения';

  @override
  String get spaceSearchEnterprise => 'Найти компанию';

  @override
  String get spaceJoinRequestSent => 'Заявка отправлена, ожидает одобрения';

  @override
  String get spaceJoinRequestPending => 'Ожидает одобрения';

  @override
  String get spaceJoinRequestApproved => 'Заявка одобрена';

  @override
  String get spaceJoinRequestRejected => 'Заявка отклонена';

  @override
  String get spaceAlreadyMember => 'Вы уже участник';

  @override
  String get spaceAutoApproved => 'Одобрено автоматически. Добро пожаловать!';

  @override
  String get spacePendingApprovalHint =>
      'Регистрация завершена. Заявка на вступление отправлена.';

  @override
  String get spaceNoSpaces => 'Нет пространств';

  @override
  String get spaceInviteExpired => 'Срок кода приглашения истёк';

  @override
  String get spaceInviteTargetMismatch =>
      'Этот код приглашения предназначен не для вашего аккаунта';

  @override
  String get spaceAcceptInviteSuccess => 'Вы успешно вступили в компанию';

  @override
  String get spaceAcceptInviteFailed =>
      'Не удалось вступить. Повторите попытку';

  @override
  String get spaceTenantSelectTitle => 'Выберите пространство';

  @override
  String get spaceTenantSelectHint => 'Выберите пространство для входа';

  @override
  String get spaceEnterPersonal => 'Войти в личное пространство';

  @override
  String get spaceEnterEnterprise => 'Войти в пространство компании';

  @override
  String get aboutTitle => 'О StartLink';

  @override
  String get aboutVersion => 'Версия';

  @override
  String get aboutTerms => 'Пользовательское соглашение';

  @override
  String get aboutPrivacy => 'Политика конфиденциальности';

  @override
  String get aboutOpenSource => 'Лицензии открытого ПО';

  @override
  String get aboutCheckUpdate => 'Проверить обновления';

  @override
  String get aboutLatestVersion => 'Вы используете последнюю версию';

  @override
  String get aboutUpdateAvailable => 'Доступна новая версия';

  @override
  String get aboutUpdateNow => 'Обновить сейчас';

  @override
  String get aboutUpdateLater => 'Позже';

  @override
  String get notificationTitle => 'Уведомления';

  @override
  String get notificationGlobalMute => 'Не беспокоить';

  @override
  String get notificationSound => 'Звук';

  @override
  String get notificationVibration => 'Вибрация';

  @override
  String get notificationPreview => 'Предпросмотр сообщений';

  @override
  String get notificationDndStart => 'Начало режима «Не беспокоить»';

  @override
  String get notificationDndEnd => 'Окончание режима «Не беспокоить»';

  @override
  String get blacklistTitle => 'В чёрном списке';

  @override
  String get blacklistEmpty => 'Нет заблокированных пользователей';

  @override
  String get blacklistRemove => 'Разблокировать';

  @override
  String get blacklistRemoveConfirm => 'Разблокировать этого пользователя?';

  @override
  String get feedbackTitle => 'Обратная связь';

  @override
  String get feedbackTypeComplaint => 'Жалоба';

  @override
  String get feedbackTypeSuggestion => 'Предложение';

  @override
  String get feedbackTypeBug => 'Сообщить об ошибке';

  @override
  String get feedbackContent => 'Описание';

  @override
  String get feedbackContentHint => 'Подробно опишите проблему или предложение';

  @override
  String get feedbackContact => 'Контакт (необязательно)';

  @override
  String get feedbackSubmit => 'Отправить';

  @override
  String get feedbackSuccess => 'Отзыв отправлен. Спасибо!';

  @override
  String get feedbackFailed => 'Не удалось отправить. Повторите попытку';

  @override
  String get networkTitle => 'Сменить линию';

  @override
  String get networkAutoSelect => 'Авто';

  @override
  String get networkManual => 'Вручную';

  @override
  String get timezoneTitle => 'Часовой пояс';

  @override
  String get timezoneAuto => 'Как в системе';

  @override
  String get autoTranslateTitle => 'Автоперевод';

  @override
  String get autoTranslateEnabled => 'Включить автоперевод';

  @override
  String get autoTranslateLanguage => 'Язык перевода';

  @override
  String get displayTitle => 'Отображение';

  @override
  String get displayFontSize => 'Размер шрифта';

  @override
  String get displayChatBackground => 'Фон чата';

  @override
  String get displayDarkMode => 'Оформление';

  @override
  String get displayDarkModeSystem => 'Как в системе';

  @override
  String get displayDarkModeSystemHint =>
      'Автоматически менять по настройкам системы';

  @override
  String get displayDarkModeOff => 'Светлая';

  @override
  String get displayDarkModeOffHint => 'Всегда использовать светлую тему';

  @override
  String get displayDarkModeOn => 'Тёмная';

  @override
  String get displayDarkModeOnHint => 'Всегда использовать тёмную тему';

  @override
  String get chatSettingsTitle => 'Чат';

  @override
  String get chatHistoryTitle => 'История чата';

  @override
  String get chatHistoryClear => 'Очистить всю историю';

  @override
  String get chatHistoryClearConfirm =>
      'Очистить всю историю чатов? Это действие необратимо.';

  @override
  String get chatHistoryClearSuccess => 'История чатов очищена';

  @override
  String get accountSecurityTitle => 'Безопасность аккаунта';

  @override
  String get accountSecurityChangePassword => 'Изменить пароль';

  @override
  String get accountSecurityChangeMobile => 'Изменить номер телефона';

  @override
  String get accountSecurityChangeEmail => 'Изменить email';

  @override
  String get accountSecurityLoggedDevices => 'Устройства с активным входом';

  @override
  String get accountSecurityDeactivate => 'Удалить аккаунт';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Все данные будут безвозвратно удалены через 7 дней. Удалить аккаунт?';

  @override
  String get loggedDevicesTitle => 'Устройства с активным входом';

  @override
  String get loggedDevicesCurrent => 'Это устройство';

  @override
  String get loggedDevicesRevoke => 'Выйти';

  @override
  String get loggedDevicesRevokeConfirm => 'Выйти на этом устройстве?';

  @override
  String get loggedDevicesRevokeSuccess => 'Выполнен выход на устройстве';

  @override
  String get loggedDevicesRevokeFailed => 'Не удалось. Повторите попытку';

  @override
  String get loggedDevicesLastActive => 'Последняя активность';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Веб';

  @override
  String get loggedDevicesTypeDesktop => 'Компьютер';

  @override
  String get loggedDevicesTypeUnknown => 'Неизвестное устройство';

  @override
  String get privacySettingsTitle => 'Конфиденциальность';

  @override
  String get privacySearchableByMobile => 'Разрешить поиск по номеру телефона';

  @override
  String get privacySearchableByLppId => 'Разрешить поиск по StartLink ID';

  @override
  String get privacyAllowFriendRequest => 'Разрешить запросы в друзья';

  @override
  String get privacyProfileVisibility => 'Видимость профиля';

  @override
  String get privacyEveryone => 'Все';

  @override
  String get privacyFriendsOfFriends => 'Друзья друзей';

  @override
  String get privacyNobody => 'Никто';

  @override
  String get privacyFriendsOnly => 'Только друзья';

  @override
  String get privacySaveSuccess => 'Настройки сохранены';

  @override
  String get privacySaveFailed => 'Не удалось сохранить. Повторите попытку';

  @override
  String get fontSizeTitle => 'Размер шрифта';

  @override
  String get fontSizeSmall => 'Мелкий';

  @override
  String get fontSizeNormal => 'Стандартный';

  @override
  String get fontSizeLarge => 'Крупный';

  @override
  String get fontSizeExtraLarge => 'Очень крупный';

  @override
  String get fontSizePreview => 'Предпросмотр';

  @override
  String get chatBackgroundTitle => 'Фон чата';

  @override
  String get chatBackgroundDefault => 'По умолчанию';

  @override
  String get chatBackgroundCustom => 'Свой';

  @override
  String get chatBackgroundReset => 'Восстановить настройки по умолчанию';

  @override
  String get termsTitle => 'Пользовательское соглашение';

  @override
  String get privacyPolicyTitle => 'Политика конфиденциальности';

  @override
  String get recentContactsTitle => 'Недавние';

  @override
  String get recentContactsEmpty => 'Нет недавних контактов';

  @override
  String get inviteFriendsTitle => 'Пригласить друзей';

  @override
  String get inviteFriendsCopyLink => 'Копировать ссылку приглашения';

  @override
  String get inviteFriendsLinkCopied => 'Ссылка приглашения скопирована';

  @override
  String get imageViewerTitle => 'Фото';

  @override
  String get imageViewerSave => 'Сохранить в альбом';

  @override
  String get imageViewerSaveSuccess => 'Сохранено в альбом';

  @override
  String get imageViewerSaveFailed => 'Не удалось сохранить. Повторите попытку';

  @override
  String get customerServiceTitle => 'Служба поддержки';

  @override
  String get customerServiceQueue => 'В очереди';

  @override
  String get customerServiceActive => 'Активные';

  @override
  String get customerServiceClaim => 'Принять';

  @override
  String get customerServiceTakeover => 'Перехватить';

  @override
  String get customerServiceClose => 'Завершить обслуживание';

  @override
  String get customerServiceCloseConfirm =>
      'Завершить этот сеанс обслуживания?';

  @override
  String get customerServiceNoQueue => 'Нет сеансов в очереди';

  @override
  String get customerServiceNoActive => 'Нет активных сеансов';

  @override
  String get customerServiceVisitor => 'Посетитель';

  @override
  String get customerServiceCustomer => 'Клиент';

  @override
  String get customerServiceAssignedTo => 'Назначено';

  @override
  String get customerServiceTransferConversation => 'Передать чат';

  @override
  String get marketingToolbar => 'Маркетинговые инструменты';

  @override
  String get callIncoming => 'Входящий звонок';

  @override
  String get callOutgoing => 'Исходящий звонок';

  @override
  String get callAccept => 'Принять';

  @override
  String get callReject => 'Отклонить';

  @override
  String get callHangup => 'Завершить';

  @override
  String get callMissed => 'Пропущенный звонок';

  @override
  String get callDuration => 'Длительность';

  @override
  String get callAudio => 'Голосовой звонок';

  @override
  String get callGeneric => 'Звонок';

  @override
  String get callVideo => 'Видеозвонок';

  @override
  String get callConnecting => 'Подключение...';

  @override
  String get callRinging => 'Вызов...';

  @override
  String get callEnded => 'Звонок завершён';

  @override
  String get callFailed => 'Ошибка звонка';

  @override
  String get callRejected => 'Звонок отклонён';

  @override
  String get callTimeout => 'Нет ответа';

  @override
  String get callCancelled => 'Отменён';

  @override
  String get callUnknownPeer => 'Неизвестно';

  @override
  String get callVideoInvitation => 'Приглашение на видеозвонок';

  @override
  String get callAudioInvitation => 'Приглашение на голосовой звонок';

  @override
  String get callAnswerAudio => 'Ответить голосом';

  @override
  String get callAnswerVideo => 'Ответить с видео';

  @override
  String get callViewProfile => 'Посмотреть профиль';

  @override
  String get callOpeningCamera => 'Включение камеры...';

  @override
  String get callWaitingRemoteVideo => 'Ожидание видео собеседника...';

  @override
  String get callCameraOff => 'Камера выключена';

  @override
  String get callCameraOn => 'Камера включена';

  @override
  String get callMicrophoneOff => 'Микрофон выключен';

  @override
  String get callMicrophoneOn => 'Микрофон включён';

  @override
  String get callSpeakerOff => 'Динамик выключен';

  @override
  String get callSpeakerOn => 'Динамик включён';

  @override
  String get callVideoPermissionFailure =>
      'Не удалось начать видеозвонок. Проверьте разрешения на камеру и микрофон и повторите попытку.';

  @override
  String get callAudioPermissionFailure =>
      'Не удалось начать голосовой звонок. Проверьте разрешение на микрофон и повторите попытку.';

  @override
  String get callIncompleteIncoming =>
      'Информация о входящем звонке неполная. Ответить невозможно.';

  @override
  String get callInProgress => 'Разговор';

  @override
  String get callCalling => 'Вызов...';

  @override
  String callEndedMedia(String media) {
    return '$media завершён';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media отклонён';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media остался без ответа';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media отменён';
  }

  @override
  String get callConnectionLost => 'Соединение звонка потеряно';

  @override
  String get callAdminEnded => 'Звонок завершён администратором';

  @override
  String callFailedMedia(String media) {
    return '$media: ошибка';
  }

  @override
  String get callBusy => 'Собеседник занят';

  @override
  String callDurationValue(String duration) {
    return 'Длительность звонка $duration';
  }

  @override
  String get callNotConnected => 'Нет соединения';

  @override
  String get callDialed => 'Исходящий';

  @override
  String get callAnswered => 'Принят';

  @override
  String get callRejectedByPeer => 'Отклонён собеседником';

  @override
  String get callRejectedBySelf => 'Отклонено';

  @override
  String get callPeerDidNotAnswer => 'Собеседник не ответил';

  @override
  String get callMissedIncoming => 'Пропущенный входящий звонок';

  @override
  String get callPeerCancelled => 'Отменён собеседником';

  @override
  String get notificationNewMessageTitle => 'Новое сообщение StartLink';

  @override
  String get notificationOnlineServiceTitle => 'Новое сообщение поддержки';

  @override
  String get notificationNewMessageBody => 'Вы получили новое сообщение';

  @override
  String get notificationImagePreview => 'Отправлено изображение';

  @override
  String get notificationVideoPreview => 'Отправлено видео';

  @override
  String get notificationVoicePreview => 'Отправлено голосовое сообщение';

  @override
  String get notificationFilePreview => 'Отправлен файл';

  @override
  String get notificationContactPreview => 'Отправлена карточка контакта';

  @override
  String get notificationCallLogPreview => 'Отправлена запись звонка';

  @override
  String get notificationLocationPreview => 'Отправлено местоположение';

  @override
  String get notificationLinkPreview => 'Отправлена ссылка';

  @override
  String notificationMentionMe(String body) {
    return 'Упомянули вас: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender упоминает вас: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Упомянули всех: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender упоминает всех: $body';
  }

  @override
  String get notificationSecurityTitle =>
      'Предупреждение безопасности аккаунта';

  @override
  String get notificationSecurityBody =>
      'Настройки безопасности аккаунта StartLink изменены. Проверьте их сейчас.';

  @override
  String get notificationFriendAcceptedTitle => 'Запрос в друзья принят';

  @override
  String get notificationFriendRejectedTitle => 'Запрос в друзья отклонён';

  @override
  String get notificationFriendAcceptedBody =>
      'Собеседник принял ваш запрос в друзья';

  @override
  String get notificationFriendRejectedBody =>
      'Собеседник отклонил ваш запрос в друзья';

  @override
  String get notificationVideoCallTitle => 'Приглашение на видеозвонок';

  @override
  String get notificationAudioCallTitle => 'Приглашение на голосовой звонок';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller приглашает вас на видеозвонок';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller приглашает вас на голосовой звонок';
  }

  @override
  String get notificationMessageChannelName => 'Сообщения';

  @override
  String get notificationMessageChannelDescription =>
      'Сообщения чатов, записи звонков и системные уведомления';

  @override
  String get notificationCallChannelName => 'Звонки';

  @override
  String get notificationCallChannelDescription =>
      'Уведомления о голосовых и видеозвонках';

  @override
  String get notificationSecurityChannelName => 'Безопасность аккаунта';

  @override
  String get notificationSecurityChannelDescription =>
      'Уведомления о входе, смене пароля и номера телефона';

  @override
  String get notificationUnknownCaller => 'Неизвестный абонент';

  @override
  String get pendingJoinRequestsTitle => 'Новые заявки';

  @override
  String get pendingJoinRequestsEmpty => 'Нет заявок';

  @override
  String get pendingJoinRequestApprove => 'Согласен';

  @override
  String get pendingJoinRequestReject => 'Отклонить';

  @override
  String get pendingJoinRequestApproveSuccess => 'Одобрено';

  @override
  String get pendingJoinRequestRejectSuccess => 'Отклонено';

  @override
  String get pendingJoinRequestFailed =>
      'Не удалось выполнить действие. Повторите попытку';

  @override
  String get myCustomersTitle => 'Мои клиенты';

  @override
  String get myCustomersEmpty => 'Нет клиентов';

  @override
  String get groupListTitle => 'Группы';

  @override
  String get groupListEmpty => 'Нет групп';

  @override
  String get addFriendTitle => 'Добавить контакт';

  @override
  String get addFriendSearchHint => 'Телефон / Email / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'Добавить';

  @override
  String get addFriendCannotAddSelf => 'Нельзя добавить самого себя';

  @override
  String get addFriendUnsupportedUser =>
      'Этого пользователя нельзя добавить. Вы можете написать ему напрямую.';

  @override
  String get addFriendMessageHint => 'Введите сообщение';

  @override
  String get addFriendSendRequest => 'Отправить запрос';

  @override
  String get joinCompanyTitle => 'Вступить в компанию';

  @override
  String get joinCompanyCodeHint => 'Введите код компании';

  @override
  String get joinCompanySearchHint => 'Поиск по названию компании';

  @override
  String get joinCompanyApply => 'Подать заявку на вступление';

  @override
  String get joinCompanyApplySuccess => 'Заявка отправлена';

  @override
  String get joinCompanyApplyFailed =>
      'Не удалось подать заявку. Повторите попытку';

  @override
  String get joinCompanyAutoApproved =>
      'Одобрено автоматически. Добро пожаловать!';

  @override
  String get joinCompanyPending => 'Заявка отправлена, ожидает одобрения';

  @override
  String get joinCompanyInviteCodeHint => 'Введите код приглашения';

  @override
  String get joinCompanyAcceptInvite => 'Принять приглашение';

  @override
  String get joinCompanyNoResults => 'Компании не найдены';

  @override
  String joinCompanyMemberCount(int count) {
    return 'Участников: $count';
  }

  @override
  String get timezoneNameHawaii => 'Гавайи';

  @override
  String get timezoneNameAlaska => 'Аляска';

  @override
  String get timezoneNamePacificTime => 'Тихоокеанское время';

  @override
  String get timezoneNameMountainTime => 'Горное время';

  @override
  String get timezoneNameCentralTime => 'Центральное время';

  @override
  String get timezoneNameEasternTime => 'Восточное время';

  @override
  String get timezoneNameAtlanticTime => 'Атлантическое время';

  @override
  String get timezoneNameBrasilia => 'Бразилиа';

  @override
  String get timezoneNameAzores => 'Азорские острова';

  @override
  String get timezoneNameLondonDublin => 'Лондон/Дублин';

  @override
  String get timezoneNameBerlinParisRome => 'Берлин/Париж/Рим';

  @override
  String get timezoneNameCairoHelsinki => 'Каир/Хельсинки';

  @override
  String get timezoneNameMoscowRiyadh => 'Москва/Эр-Рияд';

  @override
  String get timezoneNameTehran => 'Тегеран';

  @override
  String get timezoneNameDubaiBaku => 'Дубай/Баку';

  @override
  String get timezoneNameKabul => 'Кабул';

  @override
  String get timezoneNameKarachiTashkent => 'Карачи/Ташкент';

  @override
  String get timezoneNameMumbaiNewDelhi => 'Мумбаи/Нью-Дели';

  @override
  String get timezoneNameKathmandu => 'Катманду';

  @override
  String get timezoneNameDhakaAlmaty => 'Дакка/Алматы';

  @override
  String get timezoneNameYangon => 'Янгон';

  @override
  String get timezoneNameBangkokHanoiJakarta => 'Бангкок/Ханой/Джакарта';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Пекин/Шанхай/Гонконг/Тайбэй';

  @override
  String get timezoneNameTokyoSeoul => 'Токио/Сеул';

  @override
  String get timezoneNameAdelaide => 'Аделаида';

  @override
  String get timezoneNameSydneyMelbourne => 'Сидней/Мельбурн';

  @override
  String get timezoneNameSolomonIslands => 'Соломоновы Острова';

  @override
  String get timezoneNameAucklandFiji => 'Окленд/Фиджи';

  @override
  String get networkSmartSelectBestRoute => 'Умный выбор лучшего маршрута';

  @override
  String get networkTesting => 'Проверка...';

  @override
  String get networkTestingShort => 'Проверка';

  @override
  String networkLatencyMs(int ms) {
    return 'Задержка $ms мс';
  }

  @override
  String get networkConnectionMode => 'Режим подключения';

  @override
  String get networkDirectMode => 'Прямой режим';

  @override
  String get networkProxyMode => 'Через прокси';

  @override
  String get networkDirectModeDesc => 'Прямое подключение к серверу';

  @override
  String get networkProxyModeDesc => 'Подключение через прокси-сервер';

  @override
  String get networkDirectRoutes => 'Прямые маршруты';

  @override
  String get networkProxyRoutes => 'Прокси-маршруты';

  @override
  String get networkTestAll => 'Проверить все';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Узел в Гонконге';

  @override
  String get networkSingaporeNode => 'Узел в Сингапуре';

  @override
  String get networkJapanNode => 'Узел в Японии';

  @override
  String get networkUnitedStatesNode => 'Узел в США';

  @override
  String get networkHint =>
      'Подсказки:\n• Прямой режим быстрее и подходит для использования внутри страны\n• Прокси-режим стабильнее для международной связи\n• Нажмите значок обновления, чтобы проверить задержку отдельного маршрута';

  @override
  String get teenModeTitle => 'Подростковый режим';

  @override
  String get teenModeStatusOn => 'Включено';

  @override
  String get teenModeStatusOff => 'Выключен';

  @override
  String get teenModeStatusLoading => 'Загрузка';

  @override
  String get teenModeUnavailable =>
      'Статус подросткового режима временно недоступен';

  @override
  String get teenModeInvalidResponse =>
      'Подростковый режим вернул некорректный ответ';

  @override
  String get teenModeEnableDescription =>
      'Правила платформы ограничат время использования и отдельные функции.';

  @override
  String get teenModePasscode => 'Код-пароль';

  @override
  String get teenModeCurrentPasscode => 'Текущий код-пароль';

  @override
  String get teenModeNewPasscode => 'Новый код-пароль';

  @override
  String get teenModePasscodeHint => 'Введите 4–6 цифр';

  @override
  String get teenModeEnable => 'Включить подростковый режим';

  @override
  String get teenModeDisable => 'Выключить подростковый режим';

  @override
  String get teenModeChangePasscode => 'Изменить код-пароль';

  @override
  String get teenModeSource => 'Включено пользователем';

  @override
  String get teenModeDailyUsage => 'Использовано сегодня';

  @override
  String get teenModeRemaining => 'Осталось времени';

  @override
  String get teenModeMinutesUnit => 'Минуты';

  @override
  String get teenModeUnlimited => 'Без ограничений';

  @override
  String get teenModeRequestExtension => 'Запросить больше времени';

  @override
  String get teenModeExtensionSubmitted => 'Запрос времени отправлен опекуну';

  @override
  String get teenModeTimeLimitReached => 'Дневной лимит использования исчерпан';

  @override
  String get teenModeCurfewActive =>
      'Сейчас период ограниченного использования';

  @override
  String get teenModeReliefHint =>
      'Вы по-прежнему можете просматривать историю, обращаться в официальную поддержку и сообщать о проблемах.';

  @override
  String get teenModeRestrictedNotice =>
      'Подростковый режим сейчас запрещает отправлять сообщения';

  @override
  String get teenModeActionBlocked =>
      'Подростковый режим сейчас запрещает это действие';

  @override
  String get teenModeMyRequests => 'Мои запросы';

  @override
  String get guardianCenterTitle => 'Центр опекуна';

  @override
  String get guardianRelationships => 'Связи с опекунами';

  @override
  String get guardianMinors => 'Дети под моим надзором';

  @override
  String get guardianApprovals => 'Ожидают одобрения';

  @override
  String get guardianBind => 'Введите код привязки';

  @override
  String get guardianCreateMinorCode => 'Я ребёнок — создать код';

  @override
  String get guardianCreateGuardianCode => 'Я опекун — создать код';

  @override
  String get guardianRelation => 'Связь';

  @override
  String get guardianPrimary => 'Основной опекун';

  @override
  String get guardianCode => '6-значный код привязки';

  @override
  String get guardianCodeHint => 'Введите код, полученный от другого человека';

  @override
  String get guardianCodeCreated =>
      'Код создан. Поделитесь им до истечения срока.';

  @override
  String get guardianEmpty => 'Нет связей с опекунами';

  @override
  String get guardianNoMinors => 'Нет детей под надзором';

  @override
  String get guardianUnbind => 'Удалить связь';

  @override
  String get guardianExtend => 'Добавить время ребёнку';

  @override
  String get guardianPolicyTitle => 'Правила использования';

  @override
  String get guardianPolicyLocked => 'Заблокировано платформой';

  @override
  String get approvalEmpty => 'Нет запросов';

  @override
  String get approvalApprove => 'Согласен';

  @override
  String get approvalReject => 'Отклонить';

  @override
  String get approvalPending => 'Ожидает';

  @override
  String get approvalApproved => 'Одобрено';

  @override
  String get approvalRejected => 'Отклонено';

  @override
  String get approvalExpired => 'Истёк';

  @override
  String get approvalCancelled => 'Отменён';

  @override
  String get approvalReplayFailed =>
      'Исходное действие не выполнено. Повторите его.';

  @override
  String get requestCancelled => 'Запрос отменён';

  @override
  String get kycTitle => 'Верификация личности';

  @override
  String get kycNotRequired => 'Подтверждение личности не требуется';

  @override
  String get kycVerified => 'Личность подтверждена';

  @override
  String get kycDeclared => 'Данные о личности отправлены';

  @override
  String get kycPending => 'На рассмотрении';

  @override
  String get kycRejected => 'Проверка отклонена';

  @override
  String get kycNone => 'Данные о личности не отправлены';

  @override
  String get kycRealName => 'Полное имя';

  @override
  String get kycIdNumber => 'Номер документа';

  @override
  String get kycIdType => 'Тип документа';

  @override
  String get kycApplicability =>
      'Введите реальные данные для выбранного документа. Допустимые типы указаны в списке.';

  @override
  String get kycCamera => 'Сделать фото';

  @override
  String get kycGallery => 'Выбрать из альбома';

  @override
  String get kycPhotoLimit => 'Максимум на фото';

  @override
  String get kycSelectPhoto => 'Выбрать фото';

  @override
  String get kycPhotoSelected => 'Выбрано';

  @override
  String get kycViewPhoto => 'Нажмите, чтобы посмотреть фото';

  @override
  String get kycReplacePhoto => 'Выбрать другое фото';

  @override
  String get kycDisclosure =>
      'Мы используем имя, номер документа и фотографии документа для проверки личности. Без них нельзя подать заявку, а некоторые ограниченные функции могут быть недоступны.';

  @override
  String get kycConsent =>
      'Я отдельно соглашаюсь на обработку этих данных о личности';

  @override
  String get kycConsentRequired => 'Перед отправкой дайте отдельное согласие';

  @override
  String get kycResubmitTitle => 'Повторно отправить данные о личности';

  @override
  String get kycResubmitWarning =>
      'Повторная отправка заменит ожидающую заявку. Продолжить?';

  @override
  String get kycSubmitting => 'Отправка';

  @override
  String get kycSubmitFailed => 'Не удалось отправить. Повторите попытку.';

  @override
  String get kycSubmitUnavailable =>
      'Сейчас нельзя отправить данные о личности';

  @override
  String get kycResubmitNotAllowed =>
      'Повторная отправка после отказа недоступна. При необходимости обратитесь в поддержку.';

  @override
  String get kycDailyLimit =>
      'Дневной лимит отправок исчерпан. Попробуйте завтра.';

  @override
  String get kycTypeUnavailable =>
      'Нет доступных типов документов. Повторите попытку позже.';

  @override
  String get kycNameInvalid => 'Официальное имя должно содержать 2–64 символа';

  @override
  String get kycNumberRequired => 'Введите номер документа';

  @override
  String get kycFrontRequired => 'Загрузите лицевую сторону документа';

  @override
  String get kycBackRequired => 'Загрузите обратную сторону документа';

  @override
  String get kycPhotoTooLarge =>
      'Фото превышает допустимый размер. Сожмите его и повторите попытку.';

  @override
  String get kycAccountChanged =>
      'Аккаунт или пространство изменились. Откройте страницу заново.';

  @override
  String get kycPhotoInvalid => 'Выберите корректное изображение';

  @override
  String get kycPortraitSide => 'Сторона с портретом';

  @override
  String get kycEmblemSide => 'Сторона с гербом';

  @override
  String get kycPassportDataPage => 'Страница паспорта с данными';

  @override
  String get kycPassportOtherPage => 'Визовая или пустая страница паспорта';

  @override
  String get kycFront => 'Лицевая сторона документа';

  @override
  String get kycBack => 'Оборотная сторона документа';

  @override
  String get kycRequired => 'Перед созданием группы нужно подтвердить личность';

  @override
  String get kycGoVerify => 'Подтвердить сейчас';

  @override
  String get kycStatusUnknown => 'Статус личности недоступен. Обновите позже.';

  @override
  String get kycSuperseded =>
      'Более поздняя отправка заменила эту. Проверьте актуальный статус личности.';

  @override
  String get kycMediaNotFound =>
      'Фото документа недоступно в этом пространстве. Выберите его повторно перед отправкой.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Рассылка клиентам';

  @override
  String get officialAccountBadge => 'Официальный';

  @override
  String get officialAccountOpenConversation => 'Открыть беседу';

  @override
  String get officialAccountJoinHint =>
      'Добавление этого аккаунта присоединит вас к компании в качестве клиента. Одобрение дружбы не требуется.';

  @override
  String get officialAccountJoinDisabled =>
      'Эта компания не принимает новых клиентов. Обратитесь в поддержку.';

  @override
  String get officialAccountRemoved =>
      'Вы удалены из этой компании. Попросите компанию пригласить вас снова.';

  @override
  String get officialAccountBanned => 'Ваш аккаунт отключён в этой компании.';

  @override
  String get officialAccountUnavailable =>
      'Этот официальный аккаунт сейчас недоступен.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'В текущем режиме нельзя вступать в компании.';

  @override
  String get officialAccountPlatformRequired =>
      'Используйте аккаунт платформы, чтобы добавить этот официальный аккаунт.';

  @override
  String get officialAccountOpenFailed =>
      'Не удалось открыть беседу. Повторите попытку.';

  @override
  String get officialAccountAccountChanged =>
      'Аккаунт или пространство изменились. Откройте заново.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Каталог компании не обновлён. Повторите попытку чуть позже.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Не удалось синхронизировать официальный аккаунт. Локальные данные доступны.';

  @override
  String get officialAccountInboxSyncing =>
      'Синхронизация сообщений официального аккаунта';

  @override
  String get diagnosticsTitle => 'Диагностика';

  @override
  String get diagnosticsExplanation =>
      'Журналы очищены от чувствительных данных и содержат сведения об операциях и ошибках этого аккаунта и пространства, а также общие события запуска. Содержимое чатов и учётные данные не включаются.';

  @override
  String get diagnosticsHour => 'За последний час';

  @override
  String get diagnosticsDay => 'За последние 24 часа';

  @override
  String get diagnosticsWeek => '7 дн.';

  @override
  String diagnosticsEventCount(int count) {
    return 'Доступно событий: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Журналы сохраняются на этом устройстве и доступны после перезапуска.';

  @override
  String get diagnosticsNotPersistent =>
      'Некоторые записи не сохранены. Обновите для повторной попытки.';

  @override
  String get diagnosticsExport => 'Экспортировать и поделиться';

  @override
  String get diagnosticsRefresh => 'Обновить';

  @override
  String get diagnosticsClear => 'Очистить журналы этого пространства';

  @override
  String get diagnosticsClearConfirm =>
      'Очистить диагностические журналы этого пространства? История чатов сохранится.';

  @override
  String get diagnosticsShared =>
      'Системная отправка завершена. Проверьте файл в принимающем приложении.';

  @override
  String get diagnosticsCancelled =>
      'Отправка отменена. Можно экспортировать снова.';

  @override
  String get diagnosticsUnconfirmed =>
      'Не удалось подтвердить отправку. Проверьте принимающее приложение.';

  @override
  String get diagnosticsFailed =>
      'Не удалось выполнить действие. Повторите попытку.';
}
