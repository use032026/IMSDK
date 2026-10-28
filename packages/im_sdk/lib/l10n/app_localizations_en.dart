// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navWorkbench => 'Workbench';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Account data failed to load';

  @override
  String get startupFailureTitle => 'Startup failed';

  @override
  String get startupFailureMessage => 'Check your network and retry';

  @override
  String get privacyConsentTitle => 'Terms of Service and Privacy Policy';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Welcome to $brand. To provide account sign-in, instant messaging, enterprise collaboration, online customer service, message notifications, and security protection, we need to process necessary information under the Terms of Service and Privacy Policy.\n\nBefore you tap Agree, we will not read clipboard information, initialize JPush/JCore or device-vendor push SDKs, or use those SDKs to access Android ID, OAID, installed-app lists, MAC addresses, or similar information. If you decline for now, we will save that choice; you can continue reading the documents and choose again later.\n\nAfter you agree, to deliver message, customer-service, and incoming-call notifications, JPush/JCore and device-vendor push services may process device model, Android version, app package and version, network type, IP address, Android ID, OAID, push Registration ID, vendor push token, and notification delivery/click data. We have disabled nonessential capabilities including smart push, installed-app lists, MAC, IMEI, IMSI, Wi-Fi lists, auto wake-up, and linked startup.\n\nThe clipboard is accessed only when you actively use copy or paste. Camera, microphone, notification, and other system permissions are requested only when you actively use the corresponding feature. Denying one permission affects only that feature. Please review the full documents below and choose whether to agree.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Welcome to $brand. To provide account sign-in, instant messaging, enterprise collaboration, online customer service, message notifications, and security protection, we need to process necessary information under the Terms of Service and Privacy Policy.\n\nBefore you tap Agree, we will not read clipboard information, initialize JPush/JCore, register with Apple Push Notification service (APNs), or obtain push identifiers such as the JPush Registration ID or APNs device token. If you decline for now, we will save that choice; you can continue reading the documents and choose again later.\n\nAfter you agree, to deliver message, customer-service, and incoming-call notifications, we may process iPhone model, iOS version, app package and version, network type, IP address, IDFV, JPush Registration ID, APNs device token, and notification delivery/click data. JPush/JCore connects to the push service; Apple APNs processes the app identifier, device token, and notification payload to deliver system notifications. The current iOS app does not use advertising services or obtain IDFA.\n\nThe clipboard is accessed only when you actively use copy or paste. Camera, microphone, notification, and other system permissions are requested only when you actively use the corresponding feature. Denying one permission affects only that feature. Please review the full documents below and choose whether to agree.';
  }

  @override
  String get privacyConsentTermsLink => 'Terms of Service';

  @override
  String get privacyConsentConjunction => 'and';

  @override
  String get privacyConsentPrivacyLink => 'Privacy Policy';

  @override
  String get privacyConsentDecline => 'Decline';

  @override
  String get privacyConsentDeclinedExit =>
      'You did not agree to the Terms of Service and Privacy Policy. The app will now close.';

  @override
  String get privacyConsentAccept => 'Agree';

  @override
  String get privacyConsentRuntimeFailure =>
      'Startup failed. Check your network and retry.';

  @override
  String get privacyConsentSaveFailure =>
      'Could not save your choice. Please retry.';

  @override
  String get appUpdateRequiredTitle => 'Update required to continue';

  @override
  String get appUpdateOptionalTitle => 'New version available';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return '$brand $version is available';
  }

  @override
  String get appUpdateLater => 'Later';

  @override
  String get appUpdateNow => 'Update now';

  @override
  String get appUpdateProcessing => 'Processing...';

  @override
  String get appUpdateInvalidUrl =>
      'The update address is invalid. Please retry later.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Could not open the update link. Please retry later.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Download interrupted. Check your network and retry.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Package verification failed. Download it again.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Allow $brand to install updates in system settings.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Could not open the system installer. Check install permissions.';

  @override
  String get appUpdateGenericFailure =>
      'Update failed. Check your network and retry.';

  @override
  String get appUpdateUnavailable =>
      'The new version is not available for download yet. Please try later.';

  @override
  String get appUpdateCheckFailed =>
      'Could not check for updates. Please retry later.';

  @override
  String get appUpdateChecking => 'Checking';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonLoadFailed => 'Failed to load';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonEmpty => 'No data';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonForward => 'Forward';

  @override
  String get commonFavorite => 'Favorite';

  @override
  String get commonClose => 'Close';

  @override
  String get commonSend => 'Send';

  @override
  String get commonDone => 'Done';

  @override
  String get commonMore => 'More';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonCopied => 'Copied';

  @override
  String get commonUnknown => 'Unknown';

  @override
  String get commonNotSet => 'Not set';

  @override
  String get commonUnbound => 'Not bound';

  @override
  String get commonViewAll => 'View all';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonUpdate => 'Update';

  @override
  String get commonUpload => 'Upload';

  @override
  String get commonShare => 'Share';

  @override
  String get commonBlock => 'Block';

  @override
  String get commonUnblock => 'Unblock';

  @override
  String get commonMute => 'Mute';

  @override
  String get commonUnmute => 'Unmute';

  @override
  String get commonPin => 'Pin';

  @override
  String get commonUnpin => 'Unpin';

  @override
  String get commonMarkRead => 'Mark as read';

  @override
  String get commonMarkUnread => 'Mark as unread';

  @override
  String get commonOnline => 'Online';

  @override
  String get commonOffline => 'Offline';

  @override
  String get commonOperationFailed => 'Operation failed, please try again';

  @override
  String get commonNetworkError =>
      'Network error, please check your connection';

  @override
  String get navMessages => 'Chats';

  @override
  String get navContacts => 'Contacts';

  @override
  String get navMe => 'Me';

  @override
  String get authLoginTitle => 'Sign in to StartLink';

  @override
  String get authTabMobile => 'Phone';

  @override
  String get authTabEmail => 'Email';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'Enter phone number';

  @override
  String get authHintEmail => 'Enter email address';

  @override
  String get authHintPassword => 'Enter password';

  @override
  String get authHintCode => 'Enter verification code';

  @override
  String get authHintLoginName => 'Enter StartLink ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Sign In';

  @override
  String get authGetCode => 'Get Code';

  @override
  String authResendCode(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get authUsePassword => 'Use password';

  @override
  String get authUseCode => 'Use verification code';

  @override
  String get authAgreementPrefix => 'I have read and agree to the ';

  @override
  String get authAgreementAnd => ' and ';

  @override
  String get authTermsLink => 'Terms of Service';

  @override
  String get authPrivacyLink => 'Privacy Policy';

  @override
  String get authCaptchaTitle => 'Security Verification';

  @override
  String get authCaptchaHint => 'Enter the answer';

  @override
  String get authCaptchaFailed => 'Failed to get captcha, please try again';

  @override
  String get authErrorEmptyCode => 'Please enter verification code';

  @override
  String get authErrorEmptyPassword => 'Please enter password';

  @override
  String get authErrorEmptyLoginName => 'Please enter StartLink ID';

  @override
  String get authErrorWrongCredentials => 'Incorrect account or password';

  @override
  String get authDeactivatingTitle => 'Account Deactivation';

  @override
  String get authDeactivatingContent =>
      'Your account is in the deactivation cooling-off period (7 days).\n\nTo cancel deactivation, tap \"Cancel Deactivation\"; otherwise tap \"Continue\" to enter the app.';

  @override
  String get authContinueUse => 'Continue';

  @override
  String get authCancelDeactivation => 'Cancel Deactivation';

  @override
  String get authDeactivationCancelled =>
      'Deactivation cancelled, account restored';

  @override
  String get authDeactivationCancelFailed =>
      'Failed to cancel, please try again';

  @override
  String get authLogout => 'Sign Out';

  @override
  String get authLogoutConfirm => 'Are you sure you want to sign out?';

  @override
  String get authSendingCode => 'Sending...';

  @override
  String get authCodeSent => 'Code sent';

  @override
  String get authLoginFailed => 'Sign in failed, please try again';

  @override
  String get authRegisterFailed => 'Registration failed, please try again';

  @override
  String get authEnterpriseCode => 'Enterprise Code';

  @override
  String get authEnterpriseCodeHint => 'Enter enterprise code';

  @override
  String get authPendingApproval =>
      'Registration successful. Your request to join the enterprise has been submitted and is awaiting approval.';

  @override
  String get authNoAccount => 'No account?';

  @override
  String get authRegisterNow => 'Register now';

  @override
  String get authCountryPickerTitle => 'Select country/region';

  @override
  String get authCountrySearchHint => 'Search country/region';

  @override
  String get authCountryChinaMainland => 'Mainland China';

  @override
  String get authCountryHongKong => 'Hong Kong, China';

  @override
  String get authCountryMacau => 'Macao, China';

  @override
  String get authCountryTaiwan => 'Taiwan, China';

  @override
  String get authCountryUnitedStates => 'United States';

  @override
  String get authCountryUnitedKingdom => 'United Kingdom';

  @override
  String get authCountryJapan => 'Japan';

  @override
  String get authCountrySouthKorea => 'South Korea';

  @override
  String get authCountrySingapore => 'Singapore';

  @override
  String get authCountryMalaysia => 'Malaysia';

  @override
  String get authCountryAustralia => 'Australia';

  @override
  String get authCountryCanada => 'Canada';

  @override
  String get authCountryGermany => 'Germany';

  @override
  String get authCountryFrance => 'France';

  @override
  String get authCountryIndia => 'India';

  @override
  String get authCountryThailand => 'Thailand';

  @override
  String get authCountryVietnam => 'Vietnam';

  @override
  String get authCountryIndonesia => 'Indonesia';

  @override
  String get authCountryPhilippines => 'Philippines';

  @override
  String get authQuickLoginTitle => 'Quick login';

  @override
  String authQuickLoginSummary(int count) {
    return '$count quick-login accounts. Credentials are supplied by the host.';
  }

  @override
  String get authQuickLoginProgress => 'Signing in. Please wait.';

  @override
  String get authRoleOwner => 'Owner';

  @override
  String get authRoleAdministrator => 'Administrator';

  @override
  String get authRoleCustomerService => 'Customer service';

  @override
  String get authRoleTechnicalSupport => 'Technical support';

  @override
  String get authRoleEmployee => 'Employee';

  @override
  String get authRoleMember => 'Member';

  @override
  String get authRoleEnterpriseCustomer => 'Enterprise customer';

  @override
  String get authUnavailablePrefix => 'Unavailable · ';

  @override
  String get authUnassignedService => 'No assigned agent';

  @override
  String authAssignedService(String staff) {
    return 'Assigned to $staff';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Customer · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Employee · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count users';
  }

  @override
  String get authMetaPhone => 'Phone';

  @override
  String get authMetaIdentity => 'Identity';

  @override
  String get authRegisterTitle => 'Register';

  @override
  String get authNickname => 'Nickname';

  @override
  String get authNicknameHint => 'Set a nickname';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordSetHint => 'Set a password (at least 6 characters)';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authConfirmPasswordHint => 'Enter the password again';

  @override
  String get authVerificationCode => 'Verification code';

  @override
  String get authRegisterAndLogin => 'Register and sign in';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authGoLogin => 'Sign in';

  @override
  String get authEmailVerificationUnavailable =>
      'Email verification is unavailable. Register with a mobile number instead.';

  @override
  String get authSmsVerificationUnavailable =>
      'SMS verification is unavailable. Register with an email instead.';

  @override
  String get authSendFailed => 'Could not send. Please retry.';

  @override
  String get authErrorEmptyNickname => 'Enter a nickname';

  @override
  String get authErrorInvalidMobile => 'Enter a valid mobile number';

  @override
  String get authErrorInvalidEmail => 'Enter a valid email address';

  @override
  String get authErrorPasswordTooShort =>
      'Password must contain at least 6 characters';

  @override
  String get authErrorPasswordMismatch => 'The passwords do not match';

  @override
  String get authErrorVerificationRequired =>
      'Get and enter the verification code first';

  @override
  String get authRegisterErrorTitle => 'Registration failed';

  @override
  String get authGotIt => 'Got it';

  @override
  String get authJoinCredentialHint => 'Enter an invitation code';

  @override
  String authTenantNotFound(String code) {
    return 'Enterprise \"$code\" was not found. Check the enterprise code.';
  }

  @override
  String get authTenantSearchFailed => 'Search failed. Please retry.';

  @override
  String get authInvitationInvalid =>
      'The invitation code is invalid. Check it and retry.';

  @override
  String get authCollapseJoin => 'Hide join information';

  @override
  String get authExpandJoin =>
      'Join an enterprise? Enter an invitation code (optional)';

  @override
  String authInvitationValid(String name) {
    return 'Valid invitation: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Enterprise found: $name';
  }

  @override
  String get authJoinNotFound =>
      'The invitation code is invalid or does not exist';

  @override
  String get authJoinHelp =>
      'Enter an invitation code provided by the enterprise to join after registration.';

  @override
  String get authSelectOrganization => 'Select organization';

  @override
  String get authNoOrganization => 'No organizations available';

  @override
  String get authNoOrganizationHint =>
      'Ask an administrator to invite you to an organization';

  @override
  String get authPersonalSpace => 'Personal space';

  @override
  String get authPersonalSpaceSubtitle => 'Friend chats and personal favorites';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Could not verify the space identity. Please retry.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Could not restore the personal space. Please retry.';

  @override
  String get authJoinEnterpriseFailed =>
      'Could not join the enterprise. Please retry later.';

  @override
  String get homeTitle => 'Chats';

  @override
  String get homeGatewayConnectingTitle => 'Connecting';

  @override
  String get homePersonalSpace => 'Personal';

  @override
  String get homeOfficialService => 'Official Service';

  @override
  String get homeSwitchSpace => 'Switch Space';

  @override
  String get homeSpaceSubtitle => 'Personal · Enterprise';

  @override
  String get homeJoinEnterprise => 'Join Enterprise';

  @override
  String get homeCreateGroup => 'New Group';

  @override
  String get homeAddFriend => 'Add Contact';

  @override
  String get homeScan => 'Scan';

  @override
  String get homeJoinNewSpace => 'Join New Space';

  @override
  String get homeSearchConversation => 'Search';

  @override
  String get homeNoMessages => 'No messages yet';

  @override
  String get homeDeleteConversation => 'Delete Chat';

  @override
  String get homeDeleteConversationConfirm =>
      'Delete this chat? Chat history will be cleared.';

  @override
  String get homePersonalNote => 'Me (Personal Notes)';

  @override
  String get homeWorkNote => 'Me (Work Notes)';

  @override
  String homeConversationCount(int count) {
    return '$count chats';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count unread';
  }

  @override
  String get chatInputHint => 'Type a message...';

  @override
  String get chatVoiceHint => 'Hold to talk';

  @override
  String get chatVoiceRelease => 'Release to send';

  @override
  String get chatVoiceCancel => 'Slide up to cancel';

  @override
  String get chatMenuCopy => 'Copy';

  @override
  String get chatMenuForward => 'Forward';

  @override
  String get chatMenuRecall => 'Recall';

  @override
  String get chatMenuDelete => 'Delete';

  @override
  String get chatMenuFavorite => 'Favorite';

  @override
  String get chatMenuReply => 'Reply';

  @override
  String get chatMenuMultiSelect => 'Select';

  @override
  String get chatMenuTranslate => 'Translate';

  @override
  String get chatMenuVoiceToText => 'Convert to Text';

  @override
  String get chatMenuTextToSpeech => 'Read Aloud';

  @override
  String get chatStatusRecalled => 'Message recalled';

  @override
  String get chatRecallSuccess => 'Recalled';

  @override
  String get chatRecallFailed => 'Failed to recall';

  @override
  String get chatRecallTimeout =>
      'Messages older than 2 minutes cannot be recalled';

  @override
  String get chatTranslateFailed => 'Translation failed, please try again';

  @override
  String get chatTranslateNotConfigured => 'Translation service not available';

  @override
  String get chatVoiceToTextFailed => 'Conversion failed, please try again';

  @override
  String get chatTextToSpeechFailed => 'Read aloud failed, please try again';

  @override
  String get chatVoiceToText => 'Convert';

  @override
  String get chatForwardSuccess => 'Forwarded';

  @override
  String get chatForwardFailed => 'Failed to forward, please try again';

  @override
  String get chatNoConversations => 'No chats to forward to';

  @override
  String get chatSendFailed => 'Failed to send';

  @override
  String get chatResend => 'Resend';

  @override
  String get chatNotFriend => 'Not in contact list';

  @override
  String get chatNotFriendHint =>
      'You are not contacts yet. Unable to send messages.';

  @override
  String get chatMutedHint => 'All members are muted';

  @override
  String get chatFileUploadFailed => 'File upload failed, please try again';

  @override
  String get chatFileStatusNotDownloaded => 'Not downloaded';

  @override
  String get chatFileStatusDownloaded => 'Downloaded';

  @override
  String get chatFileStatusUploading => 'Uploading';

  @override
  String get chatFileStatusUploadFailed => 'Upload failed';

  @override
  String get chatCardSendFailed => 'Failed to send contact card';

  @override
  String get chatFavoriteSuccess => 'Added to favorites';

  @override
  String get chatFavoriteFailed => 'Failed to add to favorites';

  @override
  String get chatLoadFailed => 'Failed to load';

  @override
  String get chatImageMessage => '[Image]';

  @override
  String get chatVoiceMessage => '[Voice]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[File]';

  @override
  String get chatLocationMessage => '[Location]';

  @override
  String get chatContactCardMessage => '[Contact]';

  @override
  String get chatCallLogMessage => '[Call]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return 'Read by $count';
  }

  @override
  String get chatUnread => 'Unread';

  @override
  String get chatRecalledSelf => 'You recalled a message';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender recalled a message';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Translation: $translation';
  }

  @override
  String get chatMessageDeleted => 'Message deleted';

  @override
  String get chatPeer => 'Other';

  @override
  String get chatSelf => 'Me';

  @override
  String get chatGenericMessage => '[Message]';

  @override
  String get chatVoiceHideText => 'Hide text';

  @override
  String get chatVoiceShowText => 'Convert to text';

  @override
  String get chatFileDefaultName => 'File';

  @override
  String get chatContactDefaultName => 'Contact';

  @override
  String get chatContactCardTitle => 'Contact card';

  @override
  String get chatCallMissed => 'Missed';

  @override
  String get chatCallCancelled => 'Cancelled';

  @override
  String get chatCallRejected => 'Declined';

  @override
  String get chatCallDisconnected => 'Disconnected';

  @override
  String get chatCallEnded => 'Call ended';

  @override
  String get chatCallFailed => 'Call failed';

  @override
  String chatCallDuration(String duration) {
    return 'Duration $duration';
  }

  @override
  String get chatVideoCallTitle => 'Video call';

  @override
  String get chatVoiceCallTitle => 'Voice call';

  @override
  String get chatToolPhotos => 'Photos';

  @override
  String get chatToolCamera => 'Camera';

  @override
  String get chatToolFile => 'File';

  @override
  String get chatToolLocation => 'Location';

  @override
  String get chatToolContactCard => 'Contact';

  @override
  String get chatToolVoiceCall => 'Voice call';

  @override
  String get chatToolVideoCall => 'Video call';

  @override
  String get chatToolFavorites => 'Favorites';

  @override
  String get chatToolTranslate => 'Translate';

  @override
  String get chatTranslationChooseLanguage => 'Choose translation language';

  @override
  String get chatTranslationEnterText => 'Enter text first';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Translation is unavailable for messages with mentions';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Translation is unavailable while editing a scheduled message';

  @override
  String get chatTranslationFailed => 'Translation failed. Try again';

  @override
  String get chatTranslationEmpty => 'No translation returned. Try again';

  @override
  String get chatTranslationTranslating => 'Translating…';

  @override
  String get chatTranslationSend => 'Send translation';

  @override
  String get chatTranslationSending => 'Sending…';

  @override
  String get chatTranslationExpand => 'Show more';

  @override
  String get chatTranslationCollapse => 'Show less';

  @override
  String get chatFileTooLarge => 'File exceeds the limit (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Only the owner or selected members can speak.';

  @override
  String get chatImageUploadUnsupported =>
      'Image upload failed. Server support is not available yet.';

  @override
  String get chatFavoriteLongPressHint => 'Long press a message to favorite it';

  @override
  String chatSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get chatLocationSheetTitle => 'Send location';

  @override
  String get chatLocationNameLabel => 'Place name';

  @override
  String get chatLocationNameHint => 'e.g. Office, customer address';

  @override
  String get chatLocationAddressLabel => 'Address';

  @override
  String get chatLocationOptionalHint => 'Optional';

  @override
  String get chatLocationLatitudeLabel => 'Latitude';

  @override
  String get chatLocationLatitudeHint => '-90 to 90';

  @override
  String get chatLocationLongitudeLabel => 'Longitude';

  @override
  String get chatLocationLongitudeHint => '-180 to 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Enter $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label is out of range';
  }

  @override
  String get chatLocationDefaultTitle => 'Location';

  @override
  String get chatMutedFullNotice =>
      'This group is muted. Only the owner or selected members can speak.';

  @override
  String get chatNotFriendSendBlocked =>
      'You are no longer friends and cannot send messages';

  @override
  String get chatPersonalNotesTitle => 'Personal notes';

  @override
  String get chatWorkNotesTitle => 'Work notes';

  @override
  String get chatPersonalNotesDescription =>
      'Record personal thoughts and save important info here\nSynced across devices for access anytime';

  @override
  String get chatWorkNotesDescription =>
      'Record work tasks and save work materials here\nTeam spaces stay separate and secure';

  @override
  String get chatNoMessages => 'No messages yet';

  @override
  String chatReplyTo(String sender) {
    return 'Reply to $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature is coming soon';
  }

  @override
  String get chatForwardSelectTitle => 'Choose chat';

  @override
  String get chatContactSelectTitle => 'Choose contact';

  @override
  String get chatNoContacts => 'No contacts';

  @override
  String get contactsTitle => 'Contacts';

  @override
  String get contactsSearch => 'Search contacts';

  @override
  String get contactsNewFriends => 'New Friends';

  @override
  String get contactsGroups => 'Groups';

  @override
  String get contactsFavorites => 'Favorites';

  @override
  String get contactsRecent => 'Recent';

  @override
  String get contactsOrganization => 'Organization';

  @override
  String get contactsAnnouncement => 'Announcements';

  @override
  String get contactsNewApplications => 'New Applications';

  @override
  String get contactsCustomerGroups => 'Customer Groups';

  @override
  String get contactsAllCustomers => 'All Customers';

  @override
  String get contactsMyCustomers => 'My Customers';

  @override
  String get contactsViewAll => 'View All';

  @override
  String get contactsMyContacts => 'My Contacts';

  @override
  String get contactsMyAdvisor => 'My Advisor';

  @override
  String get contactsNoAdvisor => 'No advisor assigned yet';

  @override
  String get contactsAdvisorLoading => 'Loading...';

  @override
  String get contactsNavigateFailed => 'Navigation failed, please try again';

  @override
  String get contactsEmpty => 'No contacts';

  @override
  String get contactsNoAnnouncement => 'No announcements';

  @override
  String get contactsOfficialBadge => 'Official';

  @override
  String get contactsCustomerBadge => 'Customer';

  @override
  String get contactsEmptyCustomers => 'No customers';

  @override
  String get myTitle => 'Me';

  @override
  String get myEnterpriseInfo => 'Enterprise Info';

  @override
  String get myEnterpriseManage => 'Enterprise Management';

  @override
  String get myQrCode => 'QR Code';

  @override
  String get myFavorites => 'Favorites';

  @override
  String get myLanguage => 'Language';

  @override
  String get myTimezone => 'Timezone';

  @override
  String get myAutoTranslate => 'Auto Translate';

  @override
  String get myNetworkSwitch => 'Network';

  @override
  String get mySettings => 'Settings';

  @override
  String get myLogout => 'Sign Out';

  @override
  String get myLogoutConfirm => 'Are you sure you want to sign out?';

  @override
  String get myLeaveEnterprise => 'Leave Enterprise';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Are you sure you want to leave this enterprise? You will lose access to enterprise data.';

  @override
  String get myLeaveEnterpriseSuccess => 'Left enterprise';

  @override
  String get myLeaveEnterpriseFailed => 'Failed to leave, please try again';

  @override
  String get myLppIdCopied => 'StartLink ID copied';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count contacts';
  }

  @override
  String get myAutoSelect => 'Auto';

  @override
  String get myPresenceStatus => 'Presence';

  @override
  String get myPresenceStatusTitle => 'Set Presence';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Busy';

  @override
  String get myPresenceAway => 'Away';

  @override
  String get myPresenceInvisible => 'Invisible';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileName => 'Name';

  @override
  String get profileGender => 'Gender';

  @override
  String get profileBirthday => 'Birthday';

  @override
  String get profileRegion => 'Region';

  @override
  String get profileSignature => 'Bio';

  @override
  String get profileSignatureHint => 'Tell something about yourself';

  @override
  String get profileTapTapText => 'Tap Tap';

  @override
  String get profileTapTapHint => 'Text shown when tapped (max 20 chars)';

  @override
  String get profileAccountSection => 'Account';

  @override
  String get profileBasicSection => 'Basic Info';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'Not set';

  @override
  String get profileMobile => 'Phone';

  @override
  String get profileMobileUnbound => 'Not bound';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailUnbound => 'Not bound';

  @override
  String get profileQrCode => 'My QR Code';

  @override
  String get profileChangePassword => 'Change Password';

  @override
  String get profileGenderMale => 'Male';

  @override
  String get profileGenderFemale => 'Female';

  @override
  String get profileGenderOther => 'Other';

  @override
  String get profileGenderUnset => 'Not set';

  @override
  String get profileSaveFailed => 'Failed to save, please try again';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'StartLink ID can only be changed once. Please choose carefully.';

  @override
  String get profileLppIdChangeFailed =>
      'Change failed (StartLink ID can only be changed once)';

  @override
  String get profileChangePasswordOld => 'Current Password';

  @override
  String get profileChangePasswordNew => 'New Password';

  @override
  String get profileChangePasswordConfirm => 'Confirm New Password';

  @override
  String get profileChangePasswordMismatch => 'Passwords do not match';

  @override
  String get profileChangePasswordSuccess =>
      'Password changed. Please sign in again.';

  @override
  String get profileChangePasswordFailed =>
      'Failed to change password, please try again';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionEnterprise => 'Enterprise';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionFeatures => 'Features';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsEnterpriseInfo => 'Enterprise Info';

  @override
  String get settingsProfile => 'Profile';

  @override
  String get settingsAccountSecurity => 'Account Security';

  @override
  String get settingsNotification => 'Notifications';

  @override
  String get settingsDisplay => 'Display';

  @override
  String get settingsFriendPrivacy => 'Privacy';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsChatHistory => 'Chat History';

  @override
  String get settingsAbout => 'About StartLink';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTimezone => 'Timezone';

  @override
  String get settingsAutoTranslate => 'Auto Translate';

  @override
  String get settingsNetworkSwitch => 'Network';

  @override
  String get enterpriseInfoTitle => 'Enterprise Info';

  @override
  String get enterpriseName => 'Name';

  @override
  String get enterpriseDescription => 'Description';

  @override
  String get enterpriseUpdateSuccess => 'Updated successfully';

  @override
  String get enterpriseUpdateFailed => 'Update failed, please try again';

  @override
  String get enterpriseLeave => 'Leave Enterprise';

  @override
  String get enterpriseLeaveConfirm =>
      'Are you sure you want to leave this enterprise?';

  @override
  String get enterpriseLeaveSuccess => 'Left enterprise';

  @override
  String get enterpriseLeaveFailed => 'Failed to leave, please try again';

  @override
  String get enterpriseLeaveOwnerError =>
      'Owner cannot leave directly. Please transfer ownership first.';

  @override
  String get enterpriseMemberCount => 'Members';

  @override
  String get enterpriseCreatedAt => 'Created';

  @override
  String get enterpriseCode => 'Enterprise Code';

  @override
  String get enterpriseInviteMembers => 'Invite Members';

  @override
  String get enterpriseCopyInviteCode => 'Copy Invite Code';

  @override
  String get enterpriseInviteCodeCopied => 'Invite code copied';

  @override
  String get groupCreateTitle => 'New Group';

  @override
  String get groupNameHint => 'Enter group name';

  @override
  String get groupCreateSuccess => 'Group created';

  @override
  String get groupCreateFailed => 'Failed to create group';

  @override
  String get groupSettings => 'Group Settings';

  @override
  String get groupName => 'Group Name';

  @override
  String get groupAvatar => 'Group Avatar';

  @override
  String get groupAnnouncement => 'Announcement';

  @override
  String get groupMembers => 'Members';

  @override
  String get groupAddMember => 'Add Members';

  @override
  String get groupRemoveMember => 'Remove Member';

  @override
  String get groupRemoveMemberConfirm => 'Remove this member?';

  @override
  String get groupSetAdmin => 'Set as Admin';

  @override
  String get groupRemoveAdmin => 'Remove Admin';

  @override
  String get groupTransferOwner => 'Transfer Ownership';

  @override
  String get groupTransferOwnerConfirm =>
      'Transfer group ownership to this member?';

  @override
  String get groupTransferOwnerSuccess => 'Ownership transferred';

  @override
  String get groupTransferOwnerFailed => 'Transfer failed, please try again';

  @override
  String get groupLeave => 'Leave Group';

  @override
  String get groupLeaveConfirm => 'Leave this group?';

  @override
  String get groupLeaveSuccess => 'Left group';

  @override
  String get groupLeaveFailed => 'Failed to leave, please try again';

  @override
  String get groupDissolve => 'Dissolve Group';

  @override
  String get groupDissolveConfirm =>
      'Dissolve this group? All members will be removed.';

  @override
  String get groupDissolveSuccess => 'Group dissolved';

  @override
  String get groupDissolveFailed => 'Failed to dissolve, please try again';

  @override
  String get groupQrCode => 'Group QR Code';

  @override
  String get groupMuteAll => 'Mute All';

  @override
  String get groupMuteAllOn => 'Enable Mute All';

  @override
  String get groupMuteAllOff => 'Disable Mute All';

  @override
  String get groupAllowMemberInvite => 'Allow member invites';

  @override
  String get groupAllowMemberModifyTitle =>
      'Allow members to change group name';

  @override
  String get groupAllowMemberAtAll => 'Allow members to @All';

  @override
  String get groupAllowMemberViewMemberList =>
      'Allow members to view member list';

  @override
  String get groupAllowQrCodeJoin => 'Allow QR code join';

  @override
  String get groupRequireApproval => 'Require approval to join';

  @override
  String get groupAllowMemberAddFriend => 'Allow members to add each other';

  @override
  String get groupRoleOwner => 'Owner';

  @override
  String get groupRoleAdmin => 'Admin';

  @override
  String get groupRoleMember => 'Member';

  @override
  String get groupNoMembers => 'No members';

  @override
  String get groupNoAnnouncements => 'No announcements';

  @override
  String get groupCreateAnnouncement => 'Post Announcement';

  @override
  String get groupEditAnnouncement => 'Edit Announcement';

  @override
  String get groupDeleteAnnouncement => 'Delete Announcement';

  @override
  String get groupDeleteAnnouncementConfirm => 'Delete this announcement?';

  @override
  String get groupAnnouncementTitle => 'Title';

  @override
  String get groupAnnouncementContent => 'Content';

  @override
  String get groupAnnouncementPin => 'Pin Announcement';

  @override
  String groupMemberCount(int count) {
    return '$count members';
  }

  @override
  String groupSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get groupJoinRequestApprove => 'Approve';

  @override
  String get groupJoinRequestReject => 'Reject';

  @override
  String get groupJoinRequests => 'Join Requests';

  @override
  String get groupNoJoinRequests => 'No join requests';

  @override
  String get groupReadReceipts => 'Read Receipts';

  @override
  String groupReadCount(int count) {
    return '$count read';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count unread';
  }

  @override
  String get friendAddTitle => 'Add Contact';

  @override
  String get friendSearchHint => 'Phone / Email / StartLink ID';

  @override
  String get friendRequestSent => 'Friend request sent';

  @override
  String get friendRequestFailed => 'Failed to send, please try again';

  @override
  String get friendAlreadyFriend => 'Already contacts';

  @override
  String get friendNewFriendsTitle => 'New Friends';

  @override
  String get friendNoRequests => 'No friend requests';

  @override
  String get friendAccept => 'Accept';

  @override
  String get friendReject => 'Decline';

  @override
  String get friendAccepted => 'Accepted';

  @override
  String get friendRejected => 'Declined';

  @override
  String get friendDeleteConfirm => 'Remove this contact?';

  @override
  String get friendDeleteSuccess => 'Contact removed';

  @override
  String get friendDeleteFailed => 'Failed to remove, please try again';

  @override
  String get friendRemarkName => 'Nickname';

  @override
  String get friendGroupName => 'Group';

  @override
  String get friendSendMessage => 'Message';

  @override
  String get friendMatchTypeLppId => 'Matched by StartLink ID';

  @override
  String get friendMatchTypeMobile => 'Matched by phone';

  @override
  String get friendMatchTypeEmail => 'Matched by email';

  @override
  String get friendSearchEmpty => 'No users found';

  @override
  String get friendAddMessage => 'I\'d like to add you as a contact';

  @override
  String get friendBlockConfirm => 'Block this user?';

  @override
  String get friendUnblockConfirm => 'Unblock this user?';

  @override
  String get friendBlockSuccess => 'Blocked';

  @override
  String get friendUnblockSuccess => 'Unblocked';

  @override
  String get profilePageTitle => 'Profile';

  @override
  String get profilePageSendMessage => 'Message';

  @override
  String get profilePageAddFriend => 'Add Friend';

  @override
  String get profilePageAlreadyFriend => 'Already Friends';

  @override
  String get profilePageBlocked => 'Blocked';

  @override
  String get profilePageBlock => 'Block';

  @override
  String get profilePageUnblock => 'Unblock';

  @override
  String get profilePageHidden => 'This user has hidden their profile';

  @override
  String get profilePageFriendsOnly =>
      'This user only shows profile to friends';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'Nickname';

  @override
  String get profilePageEditRemark => 'Edit Nickname';

  @override
  String get profilePageSaveRemarkSuccess => 'Nickname saved';

  @override
  String get profilePageSaveRemarkFailed => 'Failed to save, please try again';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search by phone, email or StartLink ID';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get searchMessages => 'Messages';

  @override
  String get searchUsers => 'Users';

  @override
  String get searchFailed => 'Search failed, please try again';

  @override
  String get scanTitle => 'Scan';

  @override
  String get scanFailed => 'Recognition failed, please try again';

  @override
  String get scanInvalidQrCode => 'Invalid QR code';

  @override
  String get scanFlashOn => 'Turn on flashlight';

  @override
  String get scanFlashOff => 'Turn off flashlight';

  @override
  String get scanAlbum => 'Choose from album';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty => 'No favorites yet';

  @override
  String get favoritesAll => 'All';

  @override
  String get favoritesText => 'Text';

  @override
  String get favoritesImage => 'Images';

  @override
  String get favoritesVideo => 'Videos';

  @override
  String get favoritesVoice => 'Voice';

  @override
  String get favoritesFile => 'Files';

  @override
  String get favoritesOther => 'Other';

  @override
  String get favoritesDeleteConfirm => 'Remove from favorites?';

  @override
  String get favoritesDeleteSuccess => 'Removed from favorites';

  @override
  String get favoritesDeleteFailed => 'Failed to remove';

  @override
  String get favoritesOriginalRecalled => 'Message recalled';

  @override
  String get favoritesViewOriginal => 'View Original';

  @override
  String get favoritesSearchHint => 'Search favorites';

  @override
  String get favoritesNoResults => 'No matching favorites';

  @override
  String get noticeTitle => 'Announcements';

  @override
  String get noticeEmpty => 'No announcements';

  @override
  String get noticeDetail => 'Announcement Detail';

  @override
  String get noticePublishedAt => 'Published';

  @override
  String get noticePriorityNormal => 'Normal';

  @override
  String get noticePriorityImportant => 'Important';

  @override
  String get noticePriorityUrgent => 'Urgent';

  @override
  String get organizationTitle => 'Organization';

  @override
  String get organizationEmpty => 'No department info';

  @override
  String get organizationMembers => 'Members';

  @override
  String get organizationDepartment => 'Department';

  @override
  String get organizationPosition => 'Position';

  @override
  String get organizationLeader => 'Leader';

  @override
  String get qrCodeTitle => 'My QR Code';

  @override
  String get qrCodeSave => 'Save to Album';

  @override
  String get qrCodeShare => 'Share';

  @override
  String get qrCodeSaveSuccess => 'Saved to album';

  @override
  String get qrCodeSaveFailed => 'Failed to save, please try again';

  @override
  String get qrCodeRefresh => 'Refresh QR Code';

  @override
  String get qrCodeExpired => 'QR code expired, please refresh';

  @override
  String get qrCodeScanToAdd => 'Scan to add me as a contact';

  @override
  String get spacePersonal => 'Personal';

  @override
  String get spaceEnterprise => 'Enterprise';

  @override
  String get spaceJoinByCode => 'Join by Enterprise Code';

  @override
  String get spaceJoinByInvite => 'Join by Invite Code';

  @override
  String get spaceEnterCode => 'Enter enterprise code';

  @override
  String get spaceEnterInviteCode => 'Enter invite code';

  @override
  String get spaceSearchEnterprise => 'Search Enterprise';

  @override
  String get spaceJoinRequestSent => 'Request submitted, awaiting approval';

  @override
  String get spaceJoinRequestPending => 'Approval pending';

  @override
  String get spaceJoinRequestApproved => 'Request approved';

  @override
  String get spaceJoinRequestRejected => 'Request rejected';

  @override
  String get spaceAlreadyMember => 'You are already a member';

  @override
  String get spaceAutoApproved => 'Approved automatically. Welcome!';

  @override
  String get spacePendingApprovalHint =>
      'Registration successful. Your request to join has been submitted.';

  @override
  String get spaceNoSpaces => 'No spaces';

  @override
  String get spaceInviteExpired => 'Invite code expired';

  @override
  String get spaceInviteTargetMismatch =>
      'This invite code is not for your account';

  @override
  String get spaceAcceptInviteSuccess => 'Successfully joined enterprise';

  @override
  String get spaceAcceptInviteFailed => 'Failed to join, please try again';

  @override
  String get spaceTenantSelectTitle => 'Select Space';

  @override
  String get spaceTenantSelectHint => 'Choose a space to enter';

  @override
  String get spaceEnterPersonal => 'Enter Personal Space';

  @override
  String get spaceEnterEnterprise => 'Enter Enterprise Space';

  @override
  String get aboutTitle => 'About StartLink';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutTerms => 'Terms of Service';

  @override
  String get aboutPrivacy => 'Privacy Policy';

  @override
  String get aboutOpenSource => 'Open Source Licenses';

  @override
  String get aboutCheckUpdate => 'Check for Updates';

  @override
  String get aboutLatestVersion => 'Already up to date';

  @override
  String get aboutUpdateAvailable => 'Update Available';

  @override
  String get aboutUpdateNow => 'Update Now';

  @override
  String get aboutUpdateLater => 'Later';

  @override
  String get notificationTitle => 'Notifications';

  @override
  String get notificationGlobalMute => 'Do Not Disturb';

  @override
  String get notificationSound => 'Sound';

  @override
  String get notificationVibration => 'Vibration';

  @override
  String get notificationPreview => 'Message Preview';

  @override
  String get notificationDndStart => 'DND Start Time';

  @override
  String get notificationDndEnd => 'DND End Time';

  @override
  String get blacklistTitle => 'Blocked';

  @override
  String get blacklistEmpty => 'No blocked users';

  @override
  String get blacklistRemove => 'Unblock';

  @override
  String get blacklistRemoveConfirm => 'Unblock this user?';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackTypeComplaint => 'Complaint';

  @override
  String get feedbackTypeSuggestion => 'Suggestion';

  @override
  String get feedbackTypeBug => 'Bug Report';

  @override
  String get feedbackContent => 'Description';

  @override
  String get feedbackContentHint =>
      'Please describe your issue or suggestion in detail';

  @override
  String get feedbackContact => 'Contact (optional)';

  @override
  String get feedbackSubmit => 'Submit';

  @override
  String get feedbackSuccess => 'Feedback submitted. Thank you!';

  @override
  String get feedbackFailed => 'Submission failed, please try again';

  @override
  String get networkTitle => 'Network';

  @override
  String get networkAutoSelect => 'Auto';

  @override
  String get networkManual => 'Manual';

  @override
  String get timezoneTitle => 'Timezone';

  @override
  String get timezoneAuto => 'Follow System';

  @override
  String get autoTranslateTitle => 'Auto Translate';

  @override
  String get autoTranslateEnabled => 'Enable Auto Translate';

  @override
  String get autoTranslateLanguage => 'Target Language';

  @override
  String get displayTitle => 'Display';

  @override
  String get displayFontSize => 'Font Size';

  @override
  String get displayChatBackground => 'Chat Background';

  @override
  String get displayDarkMode => 'Appearance';

  @override
  String get displayDarkModeSystem => 'Follow System';

  @override
  String get displayDarkModeSystemHint =>
      'Automatically switch based on system setting';

  @override
  String get displayDarkModeOff => 'Light';

  @override
  String get displayDarkModeOffHint => 'Always use light theme';

  @override
  String get displayDarkModeOn => 'Dark';

  @override
  String get displayDarkModeOnHint => 'Always use dark theme';

  @override
  String get chatSettingsTitle => 'Chat';

  @override
  String get chatHistoryTitle => 'Chat History';

  @override
  String get chatHistoryClear => 'Clear All History';

  @override
  String get chatHistoryClearConfirm =>
      'Clear all chat history? This cannot be undone.';

  @override
  String get chatHistoryClearSuccess => 'Chat history cleared';

  @override
  String get accountSecurityTitle => 'Account Security';

  @override
  String get accountSecurityChangePassword => 'Change Password';

  @override
  String get accountSecurityChangeMobile => 'Change Phone';

  @override
  String get accountSecurityChangeEmail => 'Change Email';

  @override
  String get accountSecurityLoggedDevices => 'Logged-in Devices';

  @override
  String get accountSecurityDeactivate => 'Deactivate Account';

  @override
  String get accountSecurityDeactivateConfirm =>
      'All data will be permanently deleted after 7 days. Deactivate?';

  @override
  String get loggedDevicesTitle => 'Logged-in Devices';

  @override
  String get loggedDevicesCurrent => 'This Device';

  @override
  String get loggedDevicesRevoke => 'Sign Out';

  @override
  String get loggedDevicesRevokeConfirm => 'Sign out from this device?';

  @override
  String get loggedDevicesRevokeSuccess => 'Signed out from device';

  @override
  String get loggedDevicesRevokeFailed => 'Failed, please try again';

  @override
  String get loggedDevicesLastActive => 'Last active';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Desktop';

  @override
  String get loggedDevicesTypeUnknown => 'Unknown Device';

  @override
  String get privacySettingsTitle => 'Privacy';

  @override
  String get privacySearchableByMobile => 'Allow search by phone number';

  @override
  String get privacySearchableByLppId => 'Allow search by StartLink ID';

  @override
  String get privacyAllowFriendRequest => 'Allow friend requests';

  @override
  String get privacyProfileVisibility => 'Profile Visibility';

  @override
  String get privacyEveryone => 'Everyone';

  @override
  String get privacyFriendsOfFriends => 'Friends of friends';

  @override
  String get privacyNobody => 'Nobody';

  @override
  String get privacyFriendsOnly => 'Friends only';

  @override
  String get privacySaveSuccess => 'Settings saved';

  @override
  String get privacySaveFailed => 'Failed to save, please try again';

  @override
  String get fontSizeTitle => 'Font Size';

  @override
  String get fontSizeSmall => 'Small';

  @override
  String get fontSizeNormal => 'Normal';

  @override
  String get fontSizeLarge => 'Large';

  @override
  String get fontSizeExtraLarge => 'Extra Large';

  @override
  String get fontSizePreview => 'Preview';

  @override
  String get chatBackgroundTitle => 'Chat Background';

  @override
  String get chatBackgroundDefault => 'Default';

  @override
  String get chatBackgroundCustom => 'Custom';

  @override
  String get chatBackgroundReset => 'Reset to Default';

  @override
  String get termsTitle => 'Terms of Service';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get recentContactsTitle => 'Recent';

  @override
  String get recentContactsEmpty => 'No recent contacts';

  @override
  String get inviteFriendsTitle => 'Invite Friends';

  @override
  String get inviteFriendsCopyLink => 'Copy Invite Link';

  @override
  String get inviteFriendsLinkCopied => 'Invite link copied';

  @override
  String get imageViewerTitle => 'Photo';

  @override
  String get imageViewerSave => 'Save to Album';

  @override
  String get imageViewerSaveSuccess => 'Saved to album';

  @override
  String get imageViewerSaveFailed => 'Failed to save, please try again';

  @override
  String get customerServiceTitle => 'Service Desk';

  @override
  String get customerServiceQueue => 'Queued';

  @override
  String get customerServiceActive => 'Active';

  @override
  String get customerServiceClaim => 'Accept';

  @override
  String get customerServiceTakeover => 'Take Over';

  @override
  String get customerServiceClose => 'End Service';

  @override
  String get customerServiceCloseConfirm => 'End this service session?';

  @override
  String get customerServiceNoQueue => 'No queued sessions';

  @override
  String get customerServiceNoActive => 'No active sessions';

  @override
  String get customerServiceVisitor => 'Visitor';

  @override
  String get customerServiceCustomer => 'Customer';

  @override
  String get customerServiceAssignedTo => 'Assigned to';

  @override
  String get customerServiceTransferConversation => 'Transfer Chat';

  @override
  String get marketingToolbar => 'Marketing Tools';

  @override
  String get callIncoming => 'Incoming Call';

  @override
  String get callOutgoing => 'Outgoing Call';

  @override
  String get callAccept => 'Accept';

  @override
  String get callReject => 'Reject';

  @override
  String get callHangup => 'End';

  @override
  String get callMissed => 'Missed Call';

  @override
  String get callDuration => 'Duration';

  @override
  String get callAudio => 'Voice Call';

  @override
  String get callGeneric => 'Call';

  @override
  String get callVideo => 'Video Call';

  @override
  String get callConnecting => 'Connecting...';

  @override
  String get callRinging => 'Ringing...';

  @override
  String get callEnded => 'Call ended';

  @override
  String get callFailed => 'Call failed';

  @override
  String get callRejected => 'Call declined';

  @override
  String get callTimeout => 'No answer';

  @override
  String get callCancelled => 'Cancelled';

  @override
  String get callUnknownPeer => 'Unknown';

  @override
  String get callVideoInvitation => 'Video call invitation';

  @override
  String get callAudioInvitation => 'Audio call invitation';

  @override
  String get callAnswerAudio => 'Answer with audio';

  @override
  String get callAnswerVideo => 'Answer with video';

  @override
  String get callViewProfile => 'View profile';

  @override
  String get callOpeningCamera => 'Opening camera...';

  @override
  String get callWaitingRemoteVideo => 'Waiting for remote video...';

  @override
  String get callCameraOff => 'Camera off';

  @override
  String get callCameraOn => 'Camera on';

  @override
  String get callMicrophoneOff => 'Microphone off';

  @override
  String get callMicrophoneOn => 'Microphone on';

  @override
  String get callSpeakerOff => 'Speaker off';

  @override
  String get callSpeakerOn => 'Speaker on';

  @override
  String get callVideoPermissionFailure =>
      'Could not start the video call. Check camera and microphone permissions and retry.';

  @override
  String get callAudioPermissionFailure =>
      'Could not start the audio call. Check microphone permission and retry.';

  @override
  String get callIncompleteIncoming =>
      'The incoming call information is incomplete and cannot be answered.';

  @override
  String get callInProgress => 'In call';

  @override
  String get callCalling => 'Calling...';

  @override
  String callEndedMedia(String media) {
    return '$media ended';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media was rejected';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media was not answered';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media was cancelled';
  }

  @override
  String get callConnectionLost => 'Call connection lost';

  @override
  String get callAdminEnded => 'Call ended by an administrator';

  @override
  String callFailedMedia(String media) {
    return '$media failed';
  }

  @override
  String get callBusy => 'The other person is busy';

  @override
  String callDurationValue(String duration) {
    return 'Call duration $duration';
  }

  @override
  String get callNotConnected => 'Not connected';

  @override
  String get callDialed => 'Outgoing';

  @override
  String get callAnswered => 'Answered';

  @override
  String get callRejectedByPeer => 'Declined by the other person';

  @override
  String get callRejectedBySelf => 'Declined';

  @override
  String get callPeerDidNotAnswer => 'The other person did not answer';

  @override
  String get callMissedIncoming => 'Missed incoming call';

  @override
  String get callPeerCancelled => 'Cancelled by the other person';

  @override
  String get notificationNewMessageTitle => 'New StartLink message';

  @override
  String get notificationOnlineServiceTitle => 'New customer service message';

  @override
  String get notificationNewMessageBody => 'You received a new message';

  @override
  String get notificationImagePreview => 'Sent an image';

  @override
  String get notificationVideoPreview => 'Sent a video';

  @override
  String get notificationVoicePreview => 'Sent a voice message';

  @override
  String get notificationFilePreview => 'Sent a file';

  @override
  String get notificationContactPreview => 'Sent a contact card';

  @override
  String get notificationCallLogPreview => 'Sent a call record';

  @override
  String get notificationLocationPreview => 'Shared a location';

  @override
  String get notificationLinkPreview => 'Shared a link';

  @override
  String notificationMentionMe(String body) {
    return 'Mentioned you: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender mentioned you: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Mentioned everyone: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender mentioned everyone: $body';
  }

  @override
  String get notificationSecurityTitle => 'Account security alert';

  @override
  String get notificationSecurityBody =>
      'Your StartLink account security settings changed. Review them now.';

  @override
  String get notificationFriendAcceptedTitle => 'Friend request accepted';

  @override
  String get notificationFriendRejectedTitle => 'Friend request declined';

  @override
  String get notificationFriendAcceptedBody =>
      'The other person accepted your friend request';

  @override
  String get notificationFriendRejectedBody =>
      'The other person declined your friend request';

  @override
  String get notificationVideoCallTitle => 'Video call invitation';

  @override
  String get notificationAudioCallTitle => 'Voice call invitation';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller invited you to a video call';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller invited you to a voice call';
  }

  @override
  String get notificationMessageChannelName => 'Messages';

  @override
  String get notificationMessageChannelDescription =>
      'Chat messages, call records, and system alerts';

  @override
  String get notificationCallChannelName => 'Calls';

  @override
  String get notificationCallChannelDescription =>
      'Voice and video call alerts';

  @override
  String get notificationSecurityChannelName => 'Account security';

  @override
  String get notificationSecurityChannelDescription =>
      'Sign-in, password, and mobile number change alerts';

  @override
  String get notificationUnknownCaller => 'Unknown caller';

  @override
  String get pendingJoinRequestsTitle => 'New Applications';

  @override
  String get pendingJoinRequestsEmpty => 'No applications';

  @override
  String get pendingJoinRequestApprove => 'Approve';

  @override
  String get pendingJoinRequestReject => 'Reject';

  @override
  String get pendingJoinRequestApproveSuccess => 'Approved';

  @override
  String get pendingJoinRequestRejectSuccess => 'Rejected';

  @override
  String get pendingJoinRequestFailed => 'Operation failed, please try again';

  @override
  String get myCustomersTitle => 'My Customers';

  @override
  String get myCustomersEmpty => 'No customers';

  @override
  String get groupListTitle => 'Groups';

  @override
  String get groupListEmpty => 'No groups';

  @override
  String get addFriendTitle => 'Add Contact';

  @override
  String get addFriendSearchHint => 'Phone / Email / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'Add';

  @override
  String get addFriendCannotAddSelf => 'You can\'t add yourself';

  @override
  String get addFriendUnsupportedUser =>
      'This user can\'t be added. You can message them directly.';

  @override
  String get addFriendMessageHint => 'Enter a message';

  @override
  String get addFriendSendRequest => 'Send Request';

  @override
  String get joinCompanyTitle => 'Join Enterprise';

  @override
  String get joinCompanyCodeHint => 'Enter enterprise code';

  @override
  String get joinCompanySearchHint => 'Search enterprise name';

  @override
  String get joinCompanyApply => 'Apply to Join';

  @override
  String get joinCompanyApplySuccess => 'Application submitted';

  @override
  String get joinCompanyApplyFailed => 'Failed to apply, please try again';

  @override
  String get joinCompanyAutoApproved => 'Approved automatically. Welcome!';

  @override
  String get joinCompanyPending => 'Application submitted, awaiting approval';

  @override
  String get joinCompanyInviteCodeHint => 'Enter invite code';

  @override
  String get joinCompanyAcceptInvite => 'Accept Invite';

  @override
  String get joinCompanyNoResults => 'No enterprises found';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count members';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Pacific Time';

  @override
  String get timezoneNameMountainTime => 'Mountain Time';

  @override
  String get timezoneNameCentralTime => 'Central Time';

  @override
  String get timezoneNameEasternTime => 'Eastern Time';

  @override
  String get timezoneNameAtlanticTime => 'Atlantic Time';

  @override
  String get timezoneNameBrasilia => 'Brasilia';

  @override
  String get timezoneNameAzores => 'Azores';

  @override
  String get timezoneNameLondonDublin => 'London/Dublin';

  @override
  String get timezoneNameBerlinParisRome => 'Berlin/Paris/Rome';

  @override
  String get timezoneNameCairoHelsinki => 'Cairo/Helsinki';

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
  String get timezoneNameSolomonIslands => 'Solomon Islands';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute => 'Smart select best route';

  @override
  String get networkTesting => 'Testing...';

  @override
  String get networkTestingShort => 'Testing';

  @override
  String networkLatencyMs(int ms) {
    return 'Latency ${ms}ms';
  }

  @override
  String get networkConnectionMode => 'Connection mode';

  @override
  String get networkDirectMode => 'Direct mode';

  @override
  String get networkProxyMode => 'Proxy mode';

  @override
  String get networkDirectModeDesc => 'Connect directly to the server';

  @override
  String get networkProxyModeDesc => 'Connect through a proxy server';

  @override
  String get networkDirectRoutes => 'Direct routes';

  @override
  String get networkProxyRoutes => 'Proxy routes';

  @override
  String get networkTestAll => 'Test all';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Hong Kong node';

  @override
  String get networkSingaporeNode => 'Singapore node';

  @override
  String get networkJapanNode => 'Japan node';

  @override
  String get networkUnitedStatesNode => 'United States node';

  @override
  String get networkHint =>
      'Tips:\n• Direct mode: faster and suitable for domestic use\n• Proxy mode: more stable for cross-border communication\n• Tap the refresh icon to test a single route latency';

  @override
  String get teenModeTitle => 'Teen Mode';

  @override
  String get teenModeStatusOn => 'On';

  @override
  String get teenModeStatusOff => 'Off';

  @override
  String get teenModeStatusLoading => 'Loading';

  @override
  String get teenModeUnavailable =>
      'Teen Mode status is temporarily unavailable';

  @override
  String get teenModeInvalidResponse =>
      'Teen Mode returned an invalid response';

  @override
  String get teenModeEnableDescription =>
      'Platform rules will limit usage time and selected features.';

  @override
  String get teenModePasscode => 'Passcode';

  @override
  String get teenModeCurrentPasscode => 'Current passcode';

  @override
  String get teenModeNewPasscode => 'New passcode';

  @override
  String get teenModePasscodeHint => 'Enter 4–6 digits';

  @override
  String get teenModeEnable => 'Turn on Teen Mode';

  @override
  String get teenModeDisable => 'Turn off Teen Mode';

  @override
  String get teenModeChangePasscode => 'Change passcode';

  @override
  String get teenModeSource => 'Enabled by';

  @override
  String get teenModeDailyUsage => 'Used today';

  @override
  String get teenModeRemaining => 'Time remaining';

  @override
  String get teenModeMinutesUnit => 'min';

  @override
  String get teenModeUnlimited => 'Unlimited';

  @override
  String get teenModeRequestExtension => 'Request more time';

  @override
  String get teenModeExtensionSubmitted =>
      'The time request was sent to a guardian';

  @override
  String get teenModeTimeLimitReached =>
      'Today\'s usage limit has been reached';

  @override
  String get teenModeCurfewActive => 'This is a restricted usage period';

  @override
  String get teenModeReliefHint =>
      'You can still view history, contact official support, and report issues.';

  @override
  String get teenModeRestrictedNotice =>
      'Teen Mode currently prevents sending messages';

  @override
  String get teenModeActionBlocked =>
      'Teen Mode currently prevents this action';

  @override
  String get teenModeMyRequests => 'My requests';

  @override
  String get guardianCenterTitle => 'Guardian Center';

  @override
  String get guardianRelationships => 'Guardian relationships';

  @override
  String get guardianMinors => 'Children I supervise';

  @override
  String get guardianApprovals => 'Pending approvals';

  @override
  String get guardianBind => 'Enter binding code';

  @override
  String get guardianCreateMinorCode => 'I am a child — create code';

  @override
  String get guardianCreateGuardianCode => 'I am a guardian — create code';

  @override
  String get guardianRelation => 'Relationship';

  @override
  String get guardianPrimary => 'Primary guardian';

  @override
  String get guardianCode => '6-digit binding code';

  @override
  String get guardianCodeHint => 'Enter the code provided by the other person';

  @override
  String get guardianCodeCreated => 'Code created. Share it before it expires.';

  @override
  String get guardianEmpty => 'No guardian relationships';

  @override
  String get guardianNoMinors => 'No supervised children';

  @override
  String get guardianUnbind => 'Remove relationship';

  @override
  String get guardianExtend => 'Add time for child';

  @override
  String get guardianPolicyTitle => 'Usage rules';

  @override
  String get guardianPolicyLocked => 'Locked by platform';

  @override
  String get approvalEmpty => 'No requests';

  @override
  String get approvalApprove => 'Approve';

  @override
  String get approvalReject => 'Reject';

  @override
  String get approvalPending => 'Pending';

  @override
  String get approvalApproved => 'Approved';

  @override
  String get approvalRejected => 'Rejected';

  @override
  String get approvalExpired => 'Expired';

  @override
  String get approvalCancelled => 'Cancelled';

  @override
  String get approvalReplayFailed =>
      'The original action failed. Please try it again.';

  @override
  String get requestCancelled => 'Request cancelled';

  @override
  String get kycTitle => 'Identity verification';

  @override
  String get kycNotRequired => 'Identity verification is not required';

  @override
  String get kycVerified => 'Identity verified';

  @override
  String get kycDeclared => 'Identity information submitted';

  @override
  String get kycPending => 'Under review';

  @override
  String get kycRejected => 'Review rejected';

  @override
  String get kycNone => 'No identity information submitted';

  @override
  String get kycRealName => 'Legal name';

  @override
  String get kycIdNumber => 'Document number';

  @override
  String get kycIdType => 'Document type';

  @override
  String get kycApplicability =>
      'Enter your real details for the selected document. Accepted types appear in the list.';

  @override
  String get kycCamera => 'Take photo';

  @override
  String get kycGallery => 'Choose from gallery';

  @override
  String get kycPhotoLimit => 'Maximum per photo';

  @override
  String get kycSelectPhoto => 'Choose photo';

  @override
  String get kycPhotoSelected => 'Selected';

  @override
  String get kycViewPhoto => 'Tap to view photo';

  @override
  String get kycReplacePhoto => 'Choose another photo';

  @override
  String get kycDisclosure =>
      'We use your name, document number, and document photos to review your identity. Without them you cannot submit, and some restricted features may be unavailable.';

  @override
  String get kycConsent =>
      'I separately consent to this identity information processing';

  @override
  String get kycConsentRequired =>
      'Please give separate consent before submitting';

  @override
  String get kycResubmitTitle => 'Resubmit identity information';

  @override
  String get kycResubmitWarning =>
      'Resubmitting will replace your pending application. Continue?';

  @override
  String get kycSubmitting => 'Submitting';

  @override
  String get kycSubmitFailed => 'Submission failed. Try again.';

  @override
  String get kycSubmitUnavailable =>
      'Identity information cannot be submitted now';

  @override
  String get kycResubmitNotAllowed =>
      'Resubmission is unavailable after rejection. Contact support if needed.';

  @override
  String get kycDailyLimit =>
      'You have reached today\'s submission limit. Try tomorrow.';

  @override
  String get kycTypeUnavailable =>
      'No document types are available. Try again later.';

  @override
  String get kycNameInvalid => 'Legal name must be 2–64 characters';

  @override
  String get kycNumberRequired => 'Enter your document number';

  @override
  String get kycFrontRequired => 'Upload the front of your document';

  @override
  String get kycBackRequired => 'Upload the back of your document';

  @override
  String get kycPhotoTooLarge =>
      'Photo exceeds the size limit. Compress it and try again.';

  @override
  String get kycAccountChanged =>
      'The account or space changed. Reopen this page.';

  @override
  String get kycPhotoInvalid => 'Choose a valid image';

  @override
  String get kycPortraitSide => 'Portrait side';

  @override
  String get kycEmblemSide => 'Emblem side';

  @override
  String get kycPassportDataPage => 'Passport data page';

  @override
  String get kycPassportOtherPage => 'Passport visa or spare page';

  @override
  String get kycFront => 'Document front';

  @override
  String get kycBack => 'Document back';

  @override
  String get kycRequired =>
      'Identity verification is required before creating a group';

  @override
  String get kycGoVerify => 'Verify now';

  @override
  String get kycStatusUnknown =>
      'Identity status is unavailable. Refresh later.';

  @override
  String get kycSuperseded =>
      'A later submission replaced this one. Check your latest identity status.';

  @override
  String get kycMediaNotFound =>
      'The document photo is unavailable in this space. Select it again before submitting.';

  @override
  String get customerServiceBroadcastDirectTitle => 'Customer broadcast';

  @override
  String get officialAccountBadge => 'Official';

  @override
  String get officialAccountOpenConversation => 'Open conversation';

  @override
  String get officialAccountJoinHint =>
      'Adding this account joins the enterprise as a customer. No friend approval is needed.';

  @override
  String get officialAccountJoinDisabled =>
      'This enterprise is not accepting new customers. Please contact support.';

  @override
  String get officialAccountRemoved =>
      'You were removed from this enterprise. Ask the enterprise to invite you again.';

  @override
  String get officialAccountBanned =>
      'Your account has been disabled in this enterprise.';

  @override
  String get officialAccountUnavailable =>
      'This official account is currently unavailable.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Joining an enterprise is not allowed in the current mode.';

  @override
  String get officialAccountPlatformRequired =>
      'Use a platform account to add this official account.';

  @override
  String get officialAccountOpenFailed =>
      'Could not open the conversation. Please retry.';

  @override
  String get officialAccountAccountChanged =>
      'The account or space changed. Please open it again.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'The enterprise directory is not up to date. Please retry shortly.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Official account sync failed. Local content is still available.';

  @override
  String get officialAccountInboxSyncing => 'Syncing official account messages';

  @override
  String get diagnosticsTitle => 'Diagnostics';

  @override
  String get diagnosticsExplanation =>
      'Logs are redacted and contain operational and error information for this account and space, plus public startup events. Chat content and credentials are excluded.';

  @override
  String get diagnosticsHour => 'Last hour';

  @override
  String get diagnosticsDay => 'Last 24 hours';

  @override
  String get diagnosticsWeek => 'Last 7 days';

  @override
  String diagnosticsEventCount(int count) {
    return 'Available events: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Logs are saved on this device and remain available after restart.';

  @override
  String get diagnosticsNotPersistent =>
      'Some logs have not been saved. Refresh to retry.';

  @override
  String get diagnosticsExport => 'Export and share';

  @override
  String get diagnosticsRefresh => 'Refresh';

  @override
  String get diagnosticsClear => 'Clear this space’s logs';

  @override
  String get diagnosticsClearConfirm =>
      'Clear diagnostic logs for this space? Chat history will be kept.';

  @override
  String get diagnosticsShared =>
      'System sharing completed. Confirm the file in the receiving app.';

  @override
  String get diagnosticsCancelled => 'Sharing cancelled. You can export again.';

  @override
  String get diagnosticsUnconfirmed =>
      'Sharing could not be confirmed. Check the receiving app.';

  @override
  String get diagnosticsFailed => 'The operation failed. Please retry.';
}
