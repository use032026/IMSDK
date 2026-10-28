// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get navWorkbench => 'Bàn làm việc';

  @override
  String get navBadgeOverflow => '99+';

  @override
  String get appRuntimeLoadFailed => 'Không thể tải dữ liệu tài khoản';

  @override
  String get startupFailureTitle => 'Khởi động thất bại';

  @override
  String get startupFailureMessage => 'Hãy kiểm tra mạng rồi thử lại';

  @override
  String get privacyConsentTitle =>
      'Điều khoản dịch vụ và Chính sách quyền riêng tư';

  @override
  String privacyConsentBodyAndroid(String brand) {
    return 'Chào mừng bạn đến với $brand. Để cung cấp tính năng đăng nhập tài khoản, nhắn tin tức thời, cộng tác doanh nghiệp, chăm sóc khách hàng trực tuyến, thông báo tin nhắn và bảo vệ an toàn, chúng tôi cần xử lý các thông tin cần thiết theo Điều khoản dịch vụ và Chính sách quyền riêng tư.\n\nTrước khi bạn nhấn Đồng ý, chúng tôi sẽ không đọc thông tin bảng tạm, không khởi tạo JPush/JCore hay SDK thông báo đẩy của nhà sản xuất thiết bị và không dùng các SDK đó để truy cập Android ID, OAID, danh sách ứng dụng đã cài đặt, địa chỉ MAC hoặc thông tin tương tự. Nếu bạn chưa đồng ý, chúng tôi sẽ lưu lựa chọn đó; bạn vẫn có thể tiếp tục đọc tài liệu và chọn lại sau.\n\nSau khi bạn đồng ý, để gửi thông báo về tin nhắn, chăm sóc khách hàng và cuộc gọi đến, JPush/JCore cùng dịch vụ thông báo đẩy của nhà sản xuất có thể xử lý mẫu thiết bị, phiên bản Android, tên gói và phiên bản ứng dụng, loại mạng, địa chỉ IP, Android ID, OAID, Registration ID thông báo đẩy, Token của nhà sản xuất và dữ liệu gửi/nhấn thông báo. Chúng tôi đã tắt các khả năng không cần thiết như đẩy thông minh, danh sách ứng dụng đã cài, MAC, IMEI, IMSI, danh sách Wi-Fi, tự động đánh thức và khởi động liên kết.\n\nBảng tạm chỉ được truy cập khi bạn chủ động dùng tính năng sao chép hoặc dán. Quyền truy cập camera, micrô, thông báo và các quyền hệ thống khác chỉ được yêu cầu khi bạn chủ động dùng tính năng tương ứng. Việc từ chối một quyền chỉ ảnh hưởng đến tính năng đó. Vui lòng đọc đầy đủ các tài liệu bên dưới và tự chọn có đồng ý hay không.';
  }

  @override
  String privacyConsentBodyIos(String brand) {
    return 'Chào mừng bạn đến với $brand. Để cung cấp tính năng đăng nhập tài khoản, nhắn tin tức thời, cộng tác doanh nghiệp, chăm sóc khách hàng trực tuyến, thông báo tin nhắn và bảo vệ an toàn, chúng tôi cần xử lý các thông tin cần thiết theo Điều khoản dịch vụ và Chính sách quyền riêng tư.\n\nTrước khi bạn nhấn Đồng ý, chúng tôi sẽ không đọc thông tin bảng tạm, không khởi tạo JPush/JCore hoặc đăng ký với dịch vụ thông báo đẩy của Apple (APNs), cũng không lấy các mã định danh thông báo đẩy như JPush Registration ID hoặc mã thiết bị APNs. Nếu bạn chưa đồng ý, chúng tôi sẽ lưu lựa chọn đó; bạn vẫn có thể tiếp tục đọc tài liệu và chọn lại sau.\n\nSau khi bạn đồng ý, để gửi thông báo về tin nhắn, chăm sóc khách hàng và cuộc gọi đến, chúng tôi có thể xử lý mẫu iPhone, phiên bản iOS, tên gói và phiên bản ứng dụng, loại mạng, địa chỉ IP, IDFV, JPush Registration ID, mã thiết bị APNs và dữ liệu gửi/nhấn thông báo. JPush/JCore dùng để kết nối dịch vụ thông báo đẩy; Apple APNs xử lý mã định danh ứng dụng, mã thiết bị và nội dung thông báo để gửi thông báo hệ thống. Phiên bản iOS hiện tại không sử dụng dịch vụ quảng cáo hoặc lấy IDFA.\n\nBảng tạm chỉ được truy cập khi bạn chủ động dùng tính năng sao chép hoặc dán. Quyền truy cập camera, micrô, thông báo và các quyền hệ thống khác chỉ được yêu cầu khi bạn chủ động dùng tính năng tương ứng. Việc từ chối một quyền chỉ ảnh hưởng đến tính năng đó. Vui lòng đọc đầy đủ các tài liệu bên dưới và tự chọn có đồng ý hay không.';
  }

  @override
  String get privacyConsentTermsLink => 'Điều khoản dịch vụ';

  @override
  String get privacyConsentConjunction => 'và';

  @override
  String get privacyConsentPrivacyLink => 'Chính sách quyền riêng tư';

  @override
  String get privacyConsentDecline => 'Từ chối';

  @override
  String get privacyConsentDeclinedExit =>
      'Bạn chưa đồng ý với Điều khoản dịch vụ và Chính sách quyền riêng tư. Ứng dụng sẽ đóng.';

  @override
  String get privacyConsentAccept => 'Đồng ý';

  @override
  String get privacyConsentRuntimeFailure =>
      'Khởi động thất bại. Hãy kiểm tra mạng rồi thử lại.';

  @override
  String get privacyConsentSaveFailure =>
      'Không thể lưu lựa chọn của bạn. Vui lòng thử lại.';

  @override
  String get appUpdateRequiredTitle => 'Cần cập nhật để tiếp tục';

  @override
  String get appUpdateOptionalTitle => 'Đã có phiên bản mới';

  @override
  String appUpdateVersionAvailable(String brand, String version) {
    return 'Đã có $brand $version';
  }

  @override
  String get appUpdateLater => 'Để sau';

  @override
  String get appUpdateNow => 'Cập nhật ngay';

  @override
  String get appUpdateProcessing => 'Đang xử lý...';

  @override
  String get appUpdateInvalidUrl =>
      'Địa chỉ cập nhật không hợp lệ. Vui lòng thử lại sau.';

  @override
  String get appUpdateOpenUrlFailed =>
      'Không thể mở liên kết cập nhật. Vui lòng thử lại sau.';

  @override
  String get appUpdateDownloadInterrupted =>
      'Tải xuống bị gián đoạn. Hãy kiểm tra mạng rồi thử lại.';

  @override
  String get appUpdatePackageVerificationFailed =>
      'Xác minh gói cài đặt thất bại. Vui lòng tải lại.';

  @override
  String appUpdatePermissionDenied(String brand) {
    return 'Hãy cho phép $brand cài đặt bản cập nhật trong cài đặt hệ thống.';
  }

  @override
  String get appUpdateOpenInstallerFailed =>
      'Không thể mở trình cài đặt hệ thống. Hãy kiểm tra quyền cài đặt.';

  @override
  String get appUpdateGenericFailure =>
      'Cập nhật thất bại. Hãy kiểm tra mạng rồi thử lại.';

  @override
  String get appUpdateUnavailable =>
      'Chưa thể tải phiên bản mới. Vui lòng thử lại sau.';

  @override
  String get appUpdateCheckFailed =>
      'Không thể kiểm tra bản cập nhật. Vui lòng thử lại sau.';

  @override
  String get appUpdateChecking => 'Đang kiểm tra';

  @override
  String get commonConfirm => 'Xác nhận';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonEdit => 'Chỉnh sửa';

  @override
  String get commonDelete => 'Xóa';

  @override
  String get commonSearch => 'Tìm kiếm';

  @override
  String get commonLoading => 'Đang tải...';

  @override
  String get commonLoadFailed => 'Tải thất bại';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonEmpty => 'Không có dữ liệu';

  @override
  String get commonCopy => 'Sao chép';

  @override
  String get commonForward => 'Chuyển tiếp';

  @override
  String get commonFavorite => 'Yêu thích';

  @override
  String get commonClose => 'Đóng';

  @override
  String get commonSend => 'Gửi';

  @override
  String get commonDone => 'Xong';

  @override
  String get commonMore => 'Xem thêm';

  @override
  String get commonSettings => 'Cài đặt';

  @override
  String get commonCopied => 'Đã sao chép';

  @override
  String get commonUnknown => 'Không xác định';

  @override
  String get commonNotSet => 'Chưa đặt';

  @override
  String get commonUnbound => 'Chưa liên kết';

  @override
  String get commonViewAll => 'Xem tất cả';

  @override
  String get commonSubmit => 'Gửi';

  @override
  String get commonAdd => 'Thêm';

  @override
  String get commonRemove => 'Xóa';

  @override
  String get commonCreate => 'Tạo';

  @override
  String get commonUpdate => 'Cập nhật';

  @override
  String get commonUpload => 'Tải lên';

  @override
  String get commonShare => 'Chia sẻ';

  @override
  String get commonBlock => 'Chặn';

  @override
  String get commonUnblock => 'Bỏ chặn';

  @override
  String get commonMute => 'Tắt thông báo';

  @override
  String get commonUnmute => 'Bật thông báo';

  @override
  String get commonPin => 'Ghim';

  @override
  String get commonUnpin => 'Bỏ ghim';

  @override
  String get commonMarkRead => 'Đánh dấu đã đọc';

  @override
  String get commonMarkUnread => 'Đánh dấu chưa đọc';

  @override
  String get commonOnline => 'Trực tuyến';

  @override
  String get commonOffline => 'Ngoại tuyến';

  @override
  String get commonOperationFailed => 'Thao tác thất bại, vui lòng thử lại';

  @override
  String get commonNetworkError => 'Lỗi mạng, vui lòng kiểm tra kết nối';

  @override
  String get navMessages => 'Tin nhắn';

  @override
  String get navContacts => 'Danh bạ';

  @override
  String get navMe => 'Tôi';

  @override
  String get authLoginTitle => 'Đăng nhập StartLink';

  @override
  String get authTabMobile => 'Số điện thoại';

  @override
  String get authTabEmail => 'Email';

  @override
  String get authTabLoginName => 'StartLink ID';

  @override
  String get authHintMobile => 'Nhập số điện thoại';

  @override
  String get authHintEmail => 'Nhập địa chỉ email';

  @override
  String get authHintPassword => 'Nhập mật khẩu';

  @override
  String get authHintCode => 'Nhập mã xác minh';

  @override
  String get authHintLoginName => 'Nhập StartLink ID (lpp_xxxxxxxx)';

  @override
  String get authLoginButton => 'Đăng nhập';

  @override
  String get authGetCode => 'Lấy mã';

  @override
  String authResendCode(int seconds) {
    return 'Gửi lại sau ${seconds}s';
  }

  @override
  String get authUsePassword => 'Dùng mật khẩu';

  @override
  String get authUseCode => 'Dùng mã xác minh';

  @override
  String get authAgreementPrefix => 'Tôi đã đọc và đồng ý với ';

  @override
  String get authAgreementAnd => ' và ';

  @override
  String get authTermsLink => 'Điều khoản dịch vụ';

  @override
  String get authPrivacyLink => 'Chính sách bảo mật';

  @override
  String get authCaptchaTitle => 'Xác minh bảo mật';

  @override
  String get authCaptchaHint => 'Nhập câu trả lời';

  @override
  String get authCaptchaFailed => 'Lấy mã xác minh thất bại, vui lòng thử lại';

  @override
  String get authErrorEmptyCode => 'Vui lòng nhập mã xác minh';

  @override
  String get authErrorEmptyPassword => 'Vui lòng nhập mật khẩu';

  @override
  String get authErrorEmptyLoginName => 'Vui lòng nhập StartLink ID';

  @override
  String get authErrorWrongCredentials => 'Tài khoản hoặc mật khẩu không đúng';

  @override
  String get authDeactivatingTitle => 'Đang xóa tài khoản';

  @override
  String get authDeactivatingContent =>
      'Tài khoản của bạn đang trong thời gian chờ xóa (7 ngày).\n\nĐể hủy xóa, nhấn \"Hủy xóa\"; nếu không nhấn \"Tiếp tục\" để vào ứng dụng.';

  @override
  String get authContinueUse => 'Tiếp tục';

  @override
  String get authCancelDeactivation => 'Hủy xóa';

  @override
  String get authDeactivationCancelled => 'Đã hủy xóa tài khoản';

  @override
  String get authDeactivationCancelFailed => 'Hủy thất bại, vui lòng thử lại';

  @override
  String get authLogout => 'Đăng xuất';

  @override
  String get authLogoutConfirm => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get authSendingCode => 'Đang gửi...';

  @override
  String get authCodeSent => 'Đã gửi mã xác minh';

  @override
  String get authLoginFailed => 'Đăng nhập thất bại, vui lòng thử lại';

  @override
  String get authRegisterFailed => 'Đăng ký thất bại, vui lòng thử lại';

  @override
  String get authEnterpriseCode => 'Mã doanh nghiệp';

  @override
  String get authEnterpriseCodeHint => 'Nhập mã doanh nghiệp';

  @override
  String get authPendingApproval =>
      'Đăng ký thành công. Yêu cầu tham gia doanh nghiệp đã được gửi và đang chờ phê duyệt.';

  @override
  String get authNoAccount => 'Chưa có tài khoản?';

  @override
  String get authRegisterNow => 'Đăng ký ngay';

  @override
  String get authCountryPickerTitle => 'Chọn quốc gia/khu vực';

  @override
  String get authCountrySearchHint => 'Tìm quốc gia/khu vực';

  @override
  String get authCountryChinaMainland => 'Trung Quốc đại lục';

  @override
  String get authCountryHongKong => 'Hồng Kông, Trung Quốc';

  @override
  String get authCountryMacau => 'Ma Cao, Trung Quốc';

  @override
  String get authCountryTaiwan => 'Đài Loan, Trung Quốc';

  @override
  String get authCountryUnitedStates => 'Hoa Kỳ';

  @override
  String get authCountryUnitedKingdom => 'Vương quốc Anh';

  @override
  String get authCountryJapan => 'Nhật Bản';

  @override
  String get authCountrySouthKorea => 'Hàn Quốc';

  @override
  String get authCountrySingapore => 'Singapore';

  @override
  String get authCountryMalaysia => 'Malaysia';

  @override
  String get authCountryAustralia => 'Úc';

  @override
  String get authCountryCanada => 'Canada';

  @override
  String get authCountryGermany => 'Đức';

  @override
  String get authCountryFrance => 'Pháp';

  @override
  String get authCountryIndia => 'Ấn Độ';

  @override
  String get authCountryThailand => 'Thái Lan';

  @override
  String get authCountryVietnam => 'Việt Nam';

  @override
  String get authCountryIndonesia => 'Indonesia';

  @override
  String get authCountryPhilippines => 'Philippines';

  @override
  String get authQuickLoginTitle => 'Đăng nhập nhanh';

  @override
  String authQuickLoginSummary(int count) {
    return '$count tài khoản đăng nhập nhanh. Thông tin xác thực do ứng dụng chủ cung cấp.';
  }

  @override
  String get authQuickLoginProgress => 'Đang đăng nhập. Vui lòng chờ.';

  @override
  String get authRoleOwner => 'Chủ sở hữu';

  @override
  String get authRoleAdministrator => 'Quản trị viên';

  @override
  String get authRoleCustomerService => 'Chăm sóc khách hàng';

  @override
  String get authRoleTechnicalSupport => 'Hỗ trợ kỹ thuật';

  @override
  String get authRoleEmployee => 'Nhân viên';

  @override
  String get authRoleMember => 'Thành viên';

  @override
  String get authRoleEnterpriseCustomer => 'Khách hàng doanh nghiệp';

  @override
  String get authUnavailablePrefix => 'Không khả dụng · ';

  @override
  String get authUnassignedService => 'Chưa phân công nhân viên';

  @override
  String authAssignedService(String staff) {
    return 'Do $staff phụ trách';
  }

  @override
  String authCustomerIdentity(String assignment) {
    return 'Khách hàng · $assignment';
  }

  @override
  String authEmployeeIdentity(String tenant) {
    return 'Nhân viên · $tenant';
  }

  @override
  String authUserCount(int count) {
    return '$count người dùng';
  }

  @override
  String get authMetaPhone => 'Điện thoại';

  @override
  String get authMetaIdentity => 'Danh tính';

  @override
  String get authRegisterTitle => 'Đăng ký';

  @override
  String get authNickname => 'Biệt danh';

  @override
  String get authNicknameHint => 'Đặt biệt danh';

  @override
  String get authPassword => 'Mật khẩu';

  @override
  String get authPasswordSetHint => 'Đặt mật khẩu (ít nhất 6 ký tự)';

  @override
  String get authConfirmPassword => 'Xác nhận mật khẩu';

  @override
  String get authConfirmPasswordHint => 'Nhập lại mật khẩu';

  @override
  String get authVerificationCode => 'Mã xác minh';

  @override
  String get authRegisterAndLogin => 'Đăng ký và đăng nhập';

  @override
  String get authHaveAccount => 'Đã có tài khoản?';

  @override
  String get authGoLogin => 'Đăng nhập';

  @override
  String get authEmailVerificationUnavailable =>
      'Không thể xác minh email. Hãy đăng ký bằng số di động.';

  @override
  String get authSmsVerificationUnavailable =>
      'Không thể xác minh SMS. Hãy đăng ký bằng email.';

  @override
  String get authSendFailed => 'Không thể gửi. Vui lòng thử lại.';

  @override
  String get authErrorEmptyNickname => 'Nhập biệt danh';

  @override
  String get authErrorInvalidMobile => 'Nhập số di động hợp lệ';

  @override
  String get authErrorInvalidEmail => 'Nhập địa chỉ email hợp lệ';

  @override
  String get authErrorPasswordTooShort => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get authErrorPasswordMismatch => 'Mật khẩu không khớp';

  @override
  String get authErrorVerificationRequired =>
      'Hãy lấy và nhập mã xác minh trước';

  @override
  String get authRegisterErrorTitle => 'Đăng ký thất bại';

  @override
  String get authGotIt => 'Đã hiểu';

  @override
  String get authJoinCredentialHint => 'Nhập mã mời';

  @override
  String authTenantNotFound(String code) {
    return 'Không tìm thấy doanh nghiệp \"$code\". Hãy kiểm tra mã doanh nghiệp.';
  }

  @override
  String get authTenantSearchFailed => 'Tìm kiếm thất bại. Vui lòng thử lại.';

  @override
  String get authInvitationInvalid =>
      'Mã mời không hợp lệ. Hãy kiểm tra và thử lại.';

  @override
  String get authCollapseJoin => 'Ẩn thông tin tham gia';

  @override
  String get authExpandJoin =>
      'Tham gia doanh nghiệp? Nhập mã mời (không bắt buộc)';

  @override
  String authInvitationValid(String name) {
    return 'Lời mời hợp lệ: $name';
  }

  @override
  String authTenantFound(String name) {
    return 'Đã tìm thấy doanh nghiệp: $name';
  }

  @override
  String get authJoinNotFound => 'Mã mời không hợp lệ hoặc không tồn tại';

  @override
  String get authJoinHelp =>
      'Nhập mã mời do doanh nghiệp cung cấp để tham gia sau khi đăng ký.';

  @override
  String get authSelectOrganization => 'Chọn tổ chức';

  @override
  String get authNoOrganization => 'Không có tổ chức khả dụng';

  @override
  String get authNoOrganizationHint =>
      'Yêu cầu quản trị viên mời bạn vào tổ chức';

  @override
  String get authPersonalSpace => 'Không gian cá nhân';

  @override
  String get authPersonalSpaceSubtitle =>
      'Trò chuyện bạn bè và mục yêu thích cá nhân';

  @override
  String get authSpaceIdentityValidationFailed =>
      'Không thể xác minh danh tính không gian. Vui lòng thử lại.';

  @override
  String get authPersonalSpaceRestoreFailed =>
      'Không thể khôi phục không gian cá nhân. Vui lòng thử lại.';

  @override
  String get authJoinEnterpriseFailed =>
      'Không thể tham gia doanh nghiệp. Vui lòng thử lại sau.';

  @override
  String get homeTitle => 'Tin nhắn';

  @override
  String get homeGatewayConnectingTitle => 'Đang kết nối';

  @override
  String get homePersonalSpace => 'Không gian cá nhân';

  @override
  String get homeOfficialService => 'Dịch vụ chính thức';

  @override
  String get homeSwitchSpace => 'Chuyển không gian';

  @override
  String get homeSpaceSubtitle => 'Cá nhân · Doanh nghiệp';

  @override
  String get homeJoinEnterprise => 'Tham gia doanh nghiệp';

  @override
  String get homeCreateGroup => 'Tạo nhóm';

  @override
  String get homeAddFriend => 'Thêm bạn bè';

  @override
  String get homeScan => 'Quét mã QR';

  @override
  String get homeJoinNewSpace => 'Tham gia không gian mới';

  @override
  String get homeSearchConversation => 'Tìm kiếm cuộc trò chuyện';

  @override
  String get homeNoMessages => 'Chưa có tin nhắn';

  @override
  String get homeDeleteConversation => 'Xóa cuộc trò chuyện';

  @override
  String get homeDeleteConversationConfirm =>
      'Xóa cuộc trò chuyện này? Lịch sử chat sẽ bị xóa.';

  @override
  String get homePersonalNote => 'Tôi (Ghi chú cá nhân)';

  @override
  String get homeWorkNote => 'Tôi (Ghi chú công việc)';

  @override
  String homeConversationCount(int count) {
    return '$count cuộc trò chuyện';
  }

  @override
  String homeUnreadCount(int count) {
    return '$count chưa đọc';
  }

  @override
  String get chatInputHint => 'Nhập tin nhắn...';

  @override
  String get chatVoiceHint => 'Giữ để nói';

  @override
  String get chatVoiceRelease => 'Thả để gửi';

  @override
  String get chatVoiceCancel => 'Vuốt lên để hủy';

  @override
  String get chatMenuCopy => 'Sao chép';

  @override
  String get chatMenuForward => 'Chuyển tiếp';

  @override
  String get chatMenuRecall => 'Thu hồi';

  @override
  String get chatMenuDelete => 'Xóa';

  @override
  String get chatMenuFavorite => 'Yêu thích';

  @override
  String get chatMenuReply => 'Trả lời';

  @override
  String get chatMenuMultiSelect => 'Chọn nhiều';

  @override
  String get chatMenuTranslate => 'Dịch';

  @override
  String get chatMenuVoiceToText => 'Chuyển thành văn bản';

  @override
  String get chatMenuTextToSpeech => 'Đọc thành tiếng';

  @override
  String get chatStatusRecalled => 'Tin nhắn đã được thu hồi';

  @override
  String get chatRecallSuccess => 'Đã thu hồi';

  @override
  String get chatRecallFailed => 'Thu hồi thất bại';

  @override
  String get chatRecallTimeout => 'Không thể thu hồi tin nhắn quá 2 phút';

  @override
  String get chatTranslateFailed => 'Dịch thất bại, vui lòng thử lại';

  @override
  String get chatTranslateNotConfigured => 'Dịch vụ dịch thuật chưa khả dụng';

  @override
  String get chatVoiceToTextFailed => 'Chuyển đổi thất bại, vui lòng thử lại';

  @override
  String get chatTextToSpeechFailed =>
      'Đọc thành tiếng thất bại, vui lòng thử lại';

  @override
  String get chatVoiceToText => 'Chuyển chữ';

  @override
  String get chatForwardSuccess => 'Đã chuyển tiếp';

  @override
  String get chatForwardFailed => 'Chuyển tiếp thất bại, vui lòng thử lại';

  @override
  String get chatNoConversations => 'Không có cuộc trò chuyện để chuyển tiếp';

  @override
  String get chatSendFailed => 'Gửi thất bại';

  @override
  String get chatResend => 'Gửi lại';

  @override
  String get chatNotFriend => 'Không phải bạn bè';

  @override
  String get chatNotFriendHint => 'Bạn chưa là bạn bè, không thể gửi tin nhắn';

  @override
  String get chatMutedHint => 'Tất cả thành viên đang bị tắt tiếng';

  @override
  String get chatFileUploadFailed => 'Tải file thất bại, vui lòng thử lại';

  @override
  String get chatFileStatusNotDownloaded => 'Chưa tải';

  @override
  String get chatFileStatusDownloaded => 'Đã tải';

  @override
  String get chatFileStatusUploading => 'Đang tải lên';

  @override
  String get chatFileStatusUploadFailed => 'Tải lên thất bại';

  @override
  String get chatCardSendFailed => 'Gửi danh thiếp thất bại';

  @override
  String get chatFavoriteSuccess => 'Đã thêm vào yêu thích';

  @override
  String get chatFavoriteFailed => 'Thêm vào yêu thích thất bại';

  @override
  String get chatLoadFailed => 'Tải thất bại';

  @override
  String get chatImageMessage => '[Hình ảnh]';

  @override
  String get chatVoiceMessage => '[Giọng nói]';

  @override
  String get chatVideoMessage => '[Video]';

  @override
  String get chatFileMessage => '[File]';

  @override
  String get chatLocationMessage => '[Vị trí]';

  @override
  String get chatContactCardMessage => '[Danh thiếp]';

  @override
  String get chatCallLogMessage => '[Lịch sử cuộc gọi]';

  @override
  String chatGroupMemberCount(int count) {
    return '($count)';
  }

  @override
  String chatReadCount(int count) {
    return '$count người đã đọc';
  }

  @override
  String get chatUnread => 'Chưa đọc';

  @override
  String get chatRecalledSelf => 'Bạn đã thu hồi một tin nhắn';

  @override
  String chatRecalledPeer(String sender) {
    return '$sender đã thu hồi một tin nhắn';
  }

  @override
  String chatTranslationPrefix(String translation) {
    return 'Bản dịch: $translation';
  }

  @override
  String get chatMessageDeleted => 'Tin nhắn đã bị xóa';

  @override
  String get chatPeer => 'Đối phương';

  @override
  String get chatSelf => 'Tôi';

  @override
  String get chatGenericMessage => '[Tin nhắn]';

  @override
  String get chatVoiceHideText => 'Ẩn văn bản';

  @override
  String get chatVoiceShowText => 'Chuyển thành văn bản';

  @override
  String get chatFileDefaultName => 'Tệp';

  @override
  String get chatContactDefaultName => 'Liên hệ';

  @override
  String get chatContactCardTitle => 'Danh thiếp';

  @override
  String get chatCallMissed => 'Nhỡ cuộc gọi';

  @override
  String get chatCallCancelled => 'Đã hủy';

  @override
  String get chatCallRejected => 'Đã từ chối';

  @override
  String get chatCallDisconnected => 'Mất kết nối';

  @override
  String get chatCallEnded => 'Cuộc gọi đã kết thúc';

  @override
  String get chatCallFailed => 'Cuộc gọi thất bại';

  @override
  String chatCallDuration(String duration) {
    return 'Thời lượng $duration';
  }

  @override
  String get chatVideoCallTitle => 'Cuộc gọi video';

  @override
  String get chatVoiceCallTitle => 'Cuộc gọi thoại';

  @override
  String get chatToolPhotos => 'Ảnh';

  @override
  String get chatToolCamera => 'Máy ảnh';

  @override
  String get chatToolFile => 'Tệp';

  @override
  String get chatToolLocation => 'Vị trí';

  @override
  String get chatToolContactCard => 'Liên hệ';

  @override
  String get chatToolVoiceCall => 'Gọi thoại';

  @override
  String get chatToolVideoCall => 'Gọi video';

  @override
  String get chatToolFavorites => 'Yêu thích';

  @override
  String get chatToolTranslate => 'Dịch';

  @override
  String get chatTranslationChooseLanguage => 'Chọn ngôn ngữ dịch';

  @override
  String get chatTranslationEnterText => 'Hãy nhập nội dung trước';

  @override
  String get chatTranslationMentionsUnsupported =>
      'Chưa hỗ trợ dịch tin nhắn có nhắc tên';

  @override
  String get chatTranslationScheduledUnsupported =>
      'Chưa hỗ trợ dịch khi sửa tin nhắn hẹn giờ';

  @override
  String get chatTranslationFailed => 'Dịch thất bại. Hãy thử lại';

  @override
  String get chatTranslationEmpty => 'Không có bản dịch. Hãy thử lại';

  @override
  String get chatTranslationTranslating => 'Đang dịch…';

  @override
  String get chatTranslationSend => 'Gửi bản dịch';

  @override
  String get chatTranslationSending => 'Đang gửi…';

  @override
  String get chatTranslationExpand => 'Xem thêm';

  @override
  String get chatTranslationCollapse => 'Thu gọn';

  @override
  String get chatFileTooLarge => 'Tệp vượt quá giới hạn (100 MB)';

  @override
  String get chatInputMutedAdminOnly =>
      'Chỉ chủ nhóm hoặc thành viên được chỉ định có thể nói.';

  @override
  String get chatImageUploadUnsupported =>
      'Tải ảnh thất bại. Máy chủ chưa hỗ trợ.';

  @override
  String get chatFavoriteLongPressHint =>
      'Nhấn giữ tin nhắn để thêm vào yêu thích';

  @override
  String chatSelectedCount(int count) {
    return 'Đã chọn $count';
  }

  @override
  String get chatLocationSheetTitle => 'Gửi vị trí';

  @override
  String get chatLocationNameLabel => 'Tên địa điểm';

  @override
  String get chatLocationNameHint => 'VD: Văn phòng, địa chỉ khách hàng';

  @override
  String get chatLocationAddressLabel => 'Địa chỉ chi tiết';

  @override
  String get chatLocationOptionalHint => 'Không bắt buộc';

  @override
  String get chatLocationLatitudeLabel => 'Vĩ độ';

  @override
  String get chatLocationLatitudeHint => '-90 đến 90';

  @override
  String get chatLocationLongitudeLabel => 'Kinh độ';

  @override
  String get chatLocationLongitudeHint => '-180 đến 180';

  @override
  String chatLocationValidationRequired(String label) {
    return 'Vui lòng nhập $label';
  }

  @override
  String chatLocationValidationRange(String label) {
    return '$label không đúng phạm vi';
  }

  @override
  String get chatLocationDefaultTitle => 'Vị trí';

  @override
  String get chatMutedFullNotice =>
      'Nhóm này đang tắt tiếng toàn bộ. Chỉ chủ nhóm hoặc thành viên được chỉ định có thể nói.';

  @override
  String get chatNotFriendSendBlocked =>
      'Bạn không còn là bạn bè với đối phương nên không thể gửi tin nhắn';

  @override
  String get chatPersonalNotesTitle => 'Ghi chú cá nhân';

  @override
  String get chatWorkNotesTitle => 'Ghi chú công việc';

  @override
  String get chatPersonalNotesDescription =>
      'Ghi lại suy nghĩ cá nhân và lưu thông tin quan trọng tại đây\nĐồng bộ giữa các thiết bị, truy cập mọi lúc';

  @override
  String get chatWorkNotesDescription =>
      'Ghi lại việc cần làm và lưu tài liệu công việc tại đây\nKhông gian nhóm được tách riêng và bảo mật';

  @override
  String get chatNoMessages => 'Chưa có tin nhắn';

  @override
  String chatReplyTo(String sender) {
    return 'Trả lời $sender';
  }

  @override
  String chatFeatureComingSoon(String feature) {
    return '$feature sắp ra mắt';
  }

  @override
  String get chatForwardSelectTitle => 'Chọn cuộc trò chuyện';

  @override
  String get chatContactSelectTitle => 'Chọn liên hệ';

  @override
  String get chatNoContacts => 'Không có liên hệ';

  @override
  String get contactsTitle => 'Danh bạ';

  @override
  String get contactsSearch => 'Tìm kiếm liên hệ';

  @override
  String get contactsNewFriends => 'Bạn bè mới';

  @override
  String get contactsGroups => 'Nhóm';

  @override
  String get contactsFavorites => 'Yêu thích';

  @override
  String get contactsRecent => 'Liên hệ gần đây';

  @override
  String get contactsOrganization => 'Sơ đồ tổ chức';

  @override
  String get contactsAnnouncement => 'Thông báo';

  @override
  String get contactsNewApplications => 'Yêu cầu mới';

  @override
  String get contactsCustomerGroups => 'Nhóm khách hàng';

  @override
  String get contactsAllCustomers => 'Tất cả khách hàng';

  @override
  String get contactsMyCustomers => 'Khách hàng của tôi';

  @override
  String get contactsViewAll => 'Xem tất cả';

  @override
  String get contactsMyContacts => 'Liên hệ của tôi';

  @override
  String get contactsMyAdvisor => 'Cố vấn của tôi';

  @override
  String get contactsNoAdvisor => 'Chưa được phân công cố vấn';

  @override
  String get contactsAdvisorLoading => 'Đang tải...';

  @override
  String get contactsNavigateFailed => 'Điều hướng thất bại, vui lòng thử lại';

  @override
  String get contactsEmpty => 'Không có liên hệ';

  @override
  String get contactsNoAnnouncement => 'Không có thông báo';

  @override
  String get contactsOfficialBadge => 'Chính thức';

  @override
  String get contactsCustomerBadge => 'Khách hàng';

  @override
  String get contactsEmptyCustomers => 'Không có khách hàng';

  @override
  String get myTitle => 'Tôi';

  @override
  String get myEnterpriseInfo => 'Thông tin doanh nghiệp';

  @override
  String get myEnterpriseManage => 'Quản lý doanh nghiệp';

  @override
  String get myQrCode => 'Danh thiếp QR';

  @override
  String get myFavorites => 'Yêu thích';

  @override
  String get myLanguage => 'Ngôn ngữ';

  @override
  String get myTimezone => 'Múi giờ';

  @override
  String get myAutoTranslate => 'Tự động dịch';

  @override
  String get myNetworkSwitch => 'Mạng';

  @override
  String get mySettings => 'Cài đặt';

  @override
  String get myLogout => 'Đăng xuất';

  @override
  String get myLogoutConfirm => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get myLeaveEnterprise => 'Rời doanh nghiệp';

  @override
  String get myLeaveEnterpriseConfirm =>
      'Bạn có chắc muốn rời doanh nghiệp này? Bạn sẽ mất quyền truy cập dữ liệu doanh nghiệp.';

  @override
  String get myLeaveEnterpriseSuccess => 'Đã rời doanh nghiệp';

  @override
  String get myLeaveEnterpriseFailed => 'Rời thất bại, vui lòng thử lại';

  @override
  String get myLppIdCopied => 'Đã sao chép StartLink ID';

  @override
  String myLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String myFriendCount(int count) {
    return '$count bạn bè';
  }

  @override
  String get myAutoSelect => 'Tự động';

  @override
  String get myPresenceStatus => 'Trạng thái online';

  @override
  String get myPresenceStatusTitle => 'Đặt trạng thái online';

  @override
  String get myPresenceOnline => 'Online';

  @override
  String get myPresenceBusy => 'Bận';

  @override
  String get myPresenceAway => 'Vắng mặt';

  @override
  String get myPresenceInvisible => 'Ẩn';

  @override
  String get profileTitle => 'Hồ sơ';

  @override
  String get profileName => 'Tên';

  @override
  String get profileGender => 'Giới tính';

  @override
  String get profileBirthday => 'Ngày sinh';

  @override
  String get profileRegion => 'Khu vực';

  @override
  String get profileSignature => 'Giới thiệu';

  @override
  String get profileSignatureHint => 'Giới thiệu về bản thân';

  @override
  String get profileTapTapText => 'Tap Tap';

  @override
  String get profileTapTapHint => 'Văn bản hiển thị khi tap (tối đa 20 ký tự)';

  @override
  String get profileAccountSection => 'Tài khoản';

  @override
  String get profileBasicSection => 'Thông tin cơ bản';

  @override
  String get profileLppId => 'StartLink ID';

  @override
  String get profileLppIdNotSet => 'Chưa đặt';

  @override
  String get profileMobile => 'Số điện thoại';

  @override
  String get profileMobileUnbound => 'Chưa liên kết';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailUnbound => 'Chưa liên kết';

  @override
  String get profileQrCode => 'Mã QR của tôi';

  @override
  String get profileChangePassword => 'Đổi mật khẩu';

  @override
  String get profileGenderMale => 'Nam';

  @override
  String get profileGenderFemale => 'Nữ';

  @override
  String get profileGenderOther => 'Khác';

  @override
  String get profileGenderUnset => 'Chưa đặt';

  @override
  String get profileSaveFailed => 'Lưu thất bại, vui lòng thử lại';

  @override
  String get profileLppIdTitle => 'StartLink ID';

  @override
  String get profileLppIdSetOnce =>
      'StartLink ID chỉ có thể thay đổi một lần. Vui lòng điền cẩn thận.';

  @override
  String get profileLppIdChangeFailed =>
      'Thay đổi thất bại (StartLink ID chỉ thay đổi được một lần)';

  @override
  String get profileChangePasswordOld => 'Mật khẩu hiện tại';

  @override
  String get profileChangePasswordNew => 'Mật khẩu mới';

  @override
  String get profileChangePasswordConfirm => 'Xác nhận mật khẩu mới';

  @override
  String get profileChangePasswordMismatch => 'Mật khẩu không khớp';

  @override
  String get profileChangePasswordSuccess =>
      'Đổi mật khẩu thành công. Vui lòng đăng nhập lại.';

  @override
  String get profileChangePasswordFailed =>
      'Đổi mật khẩu thất bại, vui lòng thử lại';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsSectionEnterprise => 'Doanh nghiệp';

  @override
  String get settingsSectionAccount => 'Tài khoản';

  @override
  String get settingsSectionGeneral => 'Chung';

  @override
  String get settingsSectionFeatures => 'Tính năng';

  @override
  String get settingsSectionAbout => 'Giới thiệu';

  @override
  String get settingsEnterpriseInfo => 'Thông tin doanh nghiệp';

  @override
  String get settingsProfile => 'Hồ sơ';

  @override
  String get settingsAccountSecurity => 'Bảo mật tài khoản';

  @override
  String get settingsNotification => 'Thông báo';

  @override
  String get settingsDisplay => 'Hiển thị';

  @override
  String get settingsFriendPrivacy => 'Quyền riêng tư';

  @override
  String get settingsChat => 'Chat';

  @override
  String get settingsChatHistory => 'Lịch sử chat';

  @override
  String get settingsAbout => 'Về StartLink';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsTimezone => 'Múi giờ';

  @override
  String get settingsAutoTranslate => 'Tự động dịch';

  @override
  String get settingsNetworkSwitch => 'Mạng';

  @override
  String get enterpriseInfoTitle => 'Thông tin doanh nghiệp';

  @override
  String get enterpriseName => 'Tên doanh nghiệp';

  @override
  String get enterpriseDescription => 'Mô tả';

  @override
  String get enterpriseUpdateSuccess => 'Cập nhật thành công';

  @override
  String get enterpriseUpdateFailed => 'Cập nhật thất bại, vui lòng thử lại';

  @override
  String get enterpriseLeave => 'Rời doanh nghiệp';

  @override
  String get enterpriseLeaveConfirm => 'Bạn có chắc muốn rời doanh nghiệp này?';

  @override
  String get enterpriseLeaveSuccess => 'Đã rời doanh nghiệp';

  @override
  String get enterpriseLeaveFailed => 'Rời thất bại, vui lòng thử lại';

  @override
  String get enterpriseLeaveOwnerError =>
      'Chủ sở hữu không thể rời trực tiếp. Vui lòng chuyển quyền sở hữu trước.';

  @override
  String get enterpriseMemberCount => 'Số thành viên';

  @override
  String get enterpriseCreatedAt => 'Ngày tạo';

  @override
  String get enterpriseCode => 'Mã doanh nghiệp';

  @override
  String get enterpriseInviteMembers => 'Mời thành viên';

  @override
  String get enterpriseCopyInviteCode => 'Sao chép mã mời';

  @override
  String get enterpriseInviteCodeCopied => 'Đã sao chép mã mời';

  @override
  String get groupCreateTitle => 'Tạo nhóm';

  @override
  String get groupNameHint => 'Nhập tên nhóm';

  @override
  String get groupCreateSuccess => 'Tạo nhóm thành công';

  @override
  String get groupCreateFailed => 'Tạo nhóm thất bại';

  @override
  String get groupSettings => 'Cài đặt nhóm';

  @override
  String get groupName => 'Tên nhóm';

  @override
  String get groupAvatar => 'Ảnh nhóm';

  @override
  String get groupAnnouncement => 'Thông báo nhóm';

  @override
  String get groupMembers => 'Thành viên';

  @override
  String get groupAddMember => 'Thêm thành viên';

  @override
  String get groupRemoveMember => 'Xóa thành viên';

  @override
  String get groupRemoveMemberConfirm => 'Xóa thành viên này?';

  @override
  String get groupSetAdmin => 'Đặt làm quản trị viên';

  @override
  String get groupRemoveAdmin => 'Xóa quyền quản trị';

  @override
  String get groupTransferOwner => 'Chuyển quyền sở hữu';

  @override
  String get groupTransferOwnerConfirm =>
      'Chuyển quyền sở hữu cho thành viên này?';

  @override
  String get groupTransferOwnerSuccess => 'Đã chuyển quyền sở hữu';

  @override
  String get groupTransferOwnerFailed => 'Chuyển thất bại, vui lòng thử lại';

  @override
  String get groupLeave => 'Rời nhóm';

  @override
  String get groupLeaveConfirm => 'Rời nhóm này?';

  @override
  String get groupLeaveSuccess => 'Đã rời nhóm';

  @override
  String get groupLeaveFailed => 'Rời thất bại, vui lòng thử lại';

  @override
  String get groupDissolve => 'Giải tán nhóm';

  @override
  String get groupDissolveConfirm =>
      'Giải tán nhóm này? Tất cả thành viên sẽ bị xóa.';

  @override
  String get groupDissolveSuccess => 'Đã giải tán nhóm';

  @override
  String get groupDissolveFailed => 'Giải tán thất bại, vui lòng thử lại';

  @override
  String get groupQrCode => 'Mã QR nhóm';

  @override
  String get groupMuteAll => 'Tắt tiếng tất cả';

  @override
  String get groupMuteAllOn => 'Bật tắt tiếng tất cả';

  @override
  String get groupMuteAllOff => 'Tắt tắt tiếng tất cả';

  @override
  String get groupAllowMemberInvite => 'Cho phép thành viên mời';

  @override
  String get groupAllowMemberModifyTitle => 'Cho phép thành viên đổi tên nhóm';

  @override
  String get groupAllowMemberAtAll => 'Cho phép thành viên @tất cả';

  @override
  String get groupAllowMemberViewMemberList =>
      'Cho phép xem danh sách thành viên';

  @override
  String get groupAllowQrCodeJoin => 'Cho phép tham gia bằng mã QR';

  @override
  String get groupRequireApproval => 'Yêu cầu phê duyệt khi tham gia';

  @override
  String get groupAllowMemberAddFriend =>
      'Cho phép thành viên kết bạn với nhau';

  @override
  String get groupRoleOwner => 'Chủ nhóm';

  @override
  String get groupRoleAdmin => 'Quản trị viên';

  @override
  String get groupRoleMember => 'Thành viên';

  @override
  String get groupNoMembers => 'Không có thành viên';

  @override
  String get groupNoAnnouncements => 'Không có thông báo';

  @override
  String get groupCreateAnnouncement => 'Đăng thông báo';

  @override
  String get groupEditAnnouncement => 'Chỉnh sửa thông báo';

  @override
  String get groupDeleteAnnouncement => 'Xóa thông báo';

  @override
  String get groupDeleteAnnouncementConfirm => 'Xóa thông báo này?';

  @override
  String get groupAnnouncementTitle => 'Tiêu đề';

  @override
  String get groupAnnouncementContent => 'Nội dung';

  @override
  String get groupAnnouncementPin => 'Ghim thông báo';

  @override
  String groupMemberCount(int count) {
    return '$count thành viên';
  }

  @override
  String groupSelectedCount(int count) {
    return 'Đã chọn $count';
  }

  @override
  String get groupJoinRequestApprove => 'Chấp nhận';

  @override
  String get groupJoinRequestReject => 'Từ chối';

  @override
  String get groupJoinRequests => 'Yêu cầu tham gia';

  @override
  String get groupNoJoinRequests => 'Không có yêu cầu tham gia';

  @override
  String get groupReadReceipts => 'Xác nhận đã đọc';

  @override
  String groupReadCount(int count) {
    return '$count đã đọc';
  }

  @override
  String groupUnreadCount(int count) {
    return '$count chưa đọc';
  }

  @override
  String get friendAddTitle => 'Thêm bạn bè';

  @override
  String get friendSearchHint => 'SĐT / Email / StartLink ID';

  @override
  String get friendRequestSent => 'Đã gửi lời mời kết bạn';

  @override
  String get friendRequestFailed => 'Gửi thất bại, vui lòng thử lại';

  @override
  String get friendAlreadyFriend => 'Đã là bạn bè';

  @override
  String get friendNewFriendsTitle => 'Bạn bè mới';

  @override
  String get friendNoRequests => 'Không có lời mời kết bạn';

  @override
  String get friendAccept => 'Chấp nhận';

  @override
  String get friendReject => 'Từ chối';

  @override
  String get friendAccepted => 'Đã chấp nhận';

  @override
  String get friendRejected => 'Đã từ chối';

  @override
  String get friendDeleteConfirm => 'Xóa bạn bè này?';

  @override
  String get friendDeleteSuccess => 'Đã xóa bạn bè';

  @override
  String get friendDeleteFailed => 'Xóa thất bại, vui lòng thử lại';

  @override
  String get friendRemarkName => 'Biệt danh';

  @override
  String get friendGroupName => 'Nhóm';

  @override
  String get friendSendMessage => 'Nhắn tin';

  @override
  String get friendMatchTypeLppId => 'Khớp theo StartLink ID';

  @override
  String get friendMatchTypeMobile => 'Khớp theo SĐT';

  @override
  String get friendMatchTypeEmail => 'Khớp theo email';

  @override
  String get friendSearchEmpty => 'Không tìm thấy người dùng';

  @override
  String get friendAddMessage => 'Tôi muốn kết bạn với bạn';

  @override
  String get friendBlockConfirm => 'Chặn người dùng này?';

  @override
  String get friendUnblockConfirm => 'Bỏ chặn người dùng này?';

  @override
  String get friendBlockSuccess => 'Đã chặn';

  @override
  String get friendUnblockSuccess => 'Đã bỏ chặn';

  @override
  String get profilePageTitle => 'Hồ sơ';

  @override
  String get profilePageSendMessage => 'Nhắn tin';

  @override
  String get profilePageAddFriend => 'Kết bạn';

  @override
  String get profilePageAlreadyFriend => 'Đã là bạn bè';

  @override
  String get profilePageBlocked => 'Đã chặn';

  @override
  String get profilePageBlock => 'Chặn';

  @override
  String get profilePageUnblock => 'Bỏ chặn';

  @override
  String get profilePageHidden => 'Người dùng này đã ẩn hồ sơ';

  @override
  String get profilePageFriendsOnly =>
      'Người dùng này chỉ hiển thị hồ sơ cho bạn bè';

  @override
  String get profilePageLppId => 'StartLink ID';

  @override
  String get profilePageRemarkName => 'Biệt danh';

  @override
  String get profilePageEditRemark => 'Chỉnh sửa biệt danh';

  @override
  String get profilePageSaveRemarkSuccess => 'Đã lưu biệt danh';

  @override
  String get profilePageSaveRemarkFailed => 'Lưu thất bại, vui lòng thử lại';

  @override
  String get searchTitle => 'Tìm kiếm';

  @override
  String get searchHint => 'Tìm theo SĐT, email hoặc StartLink ID';

  @override
  String get searchNoResults => 'Không tìm thấy kết quả';

  @override
  String get searchMessages => 'Tin nhắn';

  @override
  String get searchUsers => 'Người dùng';

  @override
  String get searchFailed => 'Tìm kiếm thất bại, vui lòng thử lại';

  @override
  String get scanTitle => 'Quét mã QR';

  @override
  String get scanFailed => 'Nhận dạng thất bại, vui lòng thử lại';

  @override
  String get scanInvalidQrCode => 'Mã QR không hợp lệ';

  @override
  String get scanFlashOn => 'Bật đèn flash';

  @override
  String get scanFlashOff => 'Tắt đèn flash';

  @override
  String get scanAlbum => 'Chọn từ thư viện';

  @override
  String get favoritesTitle => 'Yêu thích';

  @override
  String get favoritesEmpty => 'Chưa có mục yêu thích';

  @override
  String get favoritesAll => 'Tất cả';

  @override
  String get favoritesText => 'Văn bản';

  @override
  String get favoritesImage => 'Hình ảnh';

  @override
  String get favoritesVideo => 'Video';

  @override
  String get favoritesVoice => 'Giọng nói';

  @override
  String get favoritesFile => 'File';

  @override
  String get favoritesOther => 'Khác';

  @override
  String get favoritesDeleteConfirm => 'Xóa khỏi yêu thích?';

  @override
  String get favoritesDeleteSuccess => 'Đã xóa khỏi yêu thích';

  @override
  String get favoritesDeleteFailed => 'Xóa thất bại';

  @override
  String get favoritesOriginalRecalled => 'Tin nhắn đã được thu hồi';

  @override
  String get favoritesViewOriginal => 'Xem tin nhắn gốc';

  @override
  String get favoritesSearchHint => 'Tìm kiếm yêu thích';

  @override
  String get favoritesNoResults => 'Không tìm thấy mục yêu thích phù hợp';

  @override
  String get noticeTitle => 'Thông báo';

  @override
  String get noticeEmpty => 'Không có thông báo';

  @override
  String get noticeDetail => 'Chi tiết thông báo';

  @override
  String get noticePublishedAt => 'Ngày đăng';

  @override
  String get noticePriorityNormal => 'Thường';

  @override
  String get noticePriorityImportant => 'Quan trọng';

  @override
  String get noticePriorityUrgent => 'Khẩn cấp';

  @override
  String get organizationTitle => 'Sơ đồ tổ chức';

  @override
  String get organizationEmpty => 'Không có thông tin phòng ban';

  @override
  String get organizationMembers => 'Thành viên';

  @override
  String get organizationDepartment => 'Phòng ban';

  @override
  String get organizationPosition => 'Chức vụ';

  @override
  String get organizationLeader => 'Trưởng nhóm';

  @override
  String get qrCodeTitle => 'Mã QR của tôi';

  @override
  String get qrCodeSave => 'Lưu vào thư viện';

  @override
  String get qrCodeShare => 'Chia sẻ';

  @override
  String get qrCodeSaveSuccess => 'Đã lưu vào thư viện';

  @override
  String get qrCodeSaveFailed => 'Lưu thất bại, vui lòng thử lại';

  @override
  String get qrCodeRefresh => 'Làm mới mã QR';

  @override
  String get qrCodeExpired => 'Mã QR đã hết hạn, vui lòng làm mới';

  @override
  String get qrCodeScanToAdd => 'Quét mã QR để kết bạn với tôi';

  @override
  String get spacePersonal => 'Cá nhân';

  @override
  String get spaceEnterprise => 'Doanh nghiệp';

  @override
  String get spaceJoinByCode => 'Tham gia bằng mã doanh nghiệp';

  @override
  String get spaceJoinByInvite => 'Tham gia bằng mã mời';

  @override
  String get spaceEnterCode => 'Nhập mã doanh nghiệp';

  @override
  String get spaceEnterInviteCode => 'Nhập mã mời';

  @override
  String get spaceSearchEnterprise => 'Tìm kiếm doanh nghiệp';

  @override
  String get spaceJoinRequestSent => 'Yêu cầu đã được gửi, đang chờ phê duyệt';

  @override
  String get spaceJoinRequestPending => 'Đang chờ phê duyệt';

  @override
  String get spaceJoinRequestApproved => 'Yêu cầu đã được chấp nhận';

  @override
  String get spaceJoinRequestRejected => 'Yêu cầu đã bị từ chối';

  @override
  String get spaceAlreadyMember => 'Bạn đã là thành viên';

  @override
  String get spaceAutoApproved => 'Đã được tự động chấp nhận. Chào mừng!';

  @override
  String get spacePendingApprovalHint =>
      'Đăng ký thành công. Yêu cầu tham gia đã được gửi và đang chờ phê duyệt.';

  @override
  String get spaceNoSpaces => 'Không có không gian';

  @override
  String get spaceInviteExpired => 'Mã mời đã hết hạn';

  @override
  String get spaceInviteTargetMismatch =>
      'Mã mời này không dành cho tài khoản của bạn';

  @override
  String get spaceAcceptInviteSuccess => 'Đã tham gia doanh nghiệp thành công';

  @override
  String get spaceAcceptInviteFailed => 'Tham gia thất bại, vui lòng thử lại';

  @override
  String get spaceTenantSelectTitle => 'Chọn không gian';

  @override
  String get spaceTenantSelectHint => 'Chọn không gian để vào';

  @override
  String get spaceEnterPersonal => 'Vào không gian cá nhân';

  @override
  String get spaceEnterEnterprise => 'Vào không gian doanh nghiệp';

  @override
  String get aboutTitle => 'Về StartLink';

  @override
  String get aboutVersion => 'Phiên bản';

  @override
  String get aboutTerms => 'Điều khoản dịch vụ';

  @override
  String get aboutPrivacy => 'Chính sách bảo mật';

  @override
  String get aboutOpenSource => 'Giấy phép mã nguồn mở';

  @override
  String get aboutCheckUpdate => 'Kiểm tra cập nhật';

  @override
  String get aboutLatestVersion => 'Đã là phiên bản mới nhất';

  @override
  String get aboutUpdateAvailable => 'Có bản cập nhật mới';

  @override
  String get aboutUpdateNow => 'Cập nhật ngay';

  @override
  String get aboutUpdateLater => 'Để sau';

  @override
  String get notificationTitle => 'Thông báo';

  @override
  String get notificationGlobalMute => 'Không làm phiền';

  @override
  String get notificationSound => 'Âm thanh';

  @override
  String get notificationVibration => 'Rung';

  @override
  String get notificationPreview => 'Xem trước thông báo';

  @override
  String get notificationDndStart => 'Giờ bắt đầu không làm phiền';

  @override
  String get notificationDndEnd => 'Giờ kết thúc không làm phiền';

  @override
  String get blacklistTitle => 'Danh sách chặn';

  @override
  String get blacklistEmpty => 'Không có người dùng bị chặn';

  @override
  String get blacklistRemove => 'Bỏ chặn';

  @override
  String get blacklistRemoveConfirm => 'Bỏ chặn người dùng này?';

  @override
  String get feedbackTitle => 'Phản hồi';

  @override
  String get feedbackTypeComplaint => 'Khiếu nại';

  @override
  String get feedbackTypeSuggestion => 'Đề xuất';

  @override
  String get feedbackTypeBug => 'Báo lỗi';

  @override
  String get feedbackContent => 'Nội dung';

  @override
  String get feedbackContentHint =>
      'Mô tả chi tiết vấn đề hoặc đề xuất của bạn';

  @override
  String get feedbackContact => 'Liên hệ (tùy chọn)';

  @override
  String get feedbackSubmit => 'Gửi';

  @override
  String get feedbackSuccess => 'Đã gửi phản hồi. Cảm ơn bạn!';

  @override
  String get feedbackFailed => 'Gửi thất bại, vui lòng thử lại';

  @override
  String get networkTitle => 'Mạng';

  @override
  String get networkAutoSelect => 'Tự động';

  @override
  String get networkManual => 'Thủ công';

  @override
  String get timezoneTitle => 'Múi giờ';

  @override
  String get timezoneAuto => 'Theo hệ thống';

  @override
  String get autoTranslateTitle => 'Tự động dịch';

  @override
  String get autoTranslateEnabled => 'Bật tự động dịch';

  @override
  String get autoTranslateLanguage => 'Ngôn ngữ đích';

  @override
  String get displayTitle => 'Hiển thị';

  @override
  String get displayFontSize => 'Cỡ chữ';

  @override
  String get displayChatBackground => 'Nền chat';

  @override
  String get displayDarkMode => 'Tối';

  @override
  String get displayDarkModeSystem => 'Theo hệ thống';

  @override
  String get displayDarkModeSystemHint =>
      'Tự động chuyển đổi theo cài đặt hệ thống';

  @override
  String get displayDarkModeOff => 'Sáng';

  @override
  String get displayDarkModeOffHint => 'Luôn dùng giao diện sáng';

  @override
  String get displayDarkModeOn => 'Tối';

  @override
  String get displayDarkModeOnHint => 'Luôn dùng giao diện tối';

  @override
  String get chatSettingsTitle => 'Chat';

  @override
  String get chatHistoryTitle => 'Lịch sử chat';

  @override
  String get chatHistoryClear => 'Xóa tất cả lịch sử';

  @override
  String get chatHistoryClearConfirm =>
      'Xóa tất cả lịch sử chat? Không thể hoàn tác.';

  @override
  String get chatHistoryClearSuccess => 'Đã xóa lịch sử chat';

  @override
  String get accountSecurityTitle => 'Bảo mật tài khoản';

  @override
  String get accountSecurityChangePassword => 'Đổi mật khẩu';

  @override
  String get accountSecurityChangeMobile => 'Đổi số điện thoại';

  @override
  String get accountSecurityChangeEmail => 'Đổi email';

  @override
  String get accountSecurityLoggedDevices => 'Thiết bị đã đăng nhập';

  @override
  String get accountSecurityDeactivate => 'Xóa tài khoản';

  @override
  String get accountSecurityDeactivateConfirm =>
      'Tất cả dữ liệu sẽ bị xóa vĩnh viễn sau 7 ngày. Xóa tài khoản?';

  @override
  String get loggedDevicesTitle => 'Thiết bị đã đăng nhập';

  @override
  String get loggedDevicesCurrent => 'Thiết bị này';

  @override
  String get loggedDevicesRevoke => 'Đăng xuất';

  @override
  String get loggedDevicesRevokeConfirm => 'Đăng xuất khỏi thiết bị này?';

  @override
  String get loggedDevicesRevokeSuccess => 'Đã đăng xuất khỏi thiết bị';

  @override
  String get loggedDevicesRevokeFailed => 'Thất bại, vui lòng thử lại';

  @override
  String get loggedDevicesLastActive => 'Hoạt động lần cuối';

  @override
  String get loggedDevicesTypeIos => 'iOS';

  @override
  String get loggedDevicesTypeAndroid => 'Android';

  @override
  String get loggedDevicesTypeWeb => 'Web';

  @override
  String get loggedDevicesTypeDesktop => 'Máy tính';

  @override
  String get loggedDevicesTypeUnknown => 'Thiết bị không xác định';

  @override
  String get privacySettingsTitle => 'Quyền riêng tư';

  @override
  String get privacySearchableByMobile => 'Cho phép tìm kiếm theo SĐT';

  @override
  String get privacySearchableByLppId => 'Cho phép tìm kiếm theo StartLink ID';

  @override
  String get privacyAllowFriendRequest => 'Cho phép lời mời kết bạn';

  @override
  String get privacyProfileVisibility => 'Hiển thị hồ sơ';

  @override
  String get privacyEveryone => 'Tất cả mọi người';

  @override
  String get privacyFriendsOfFriends => 'Bạn của bạn bè';

  @override
  String get privacyNobody => 'Không ai';

  @override
  String get privacyFriendsOnly => 'Chỉ bạn bè';

  @override
  String get privacySaveSuccess => 'Đã lưu cài đặt';

  @override
  String get privacySaveFailed => 'Lưu thất bại, vui lòng thử lại';

  @override
  String get fontSizeTitle => 'Cỡ chữ';

  @override
  String get fontSizeSmall => 'Nhỏ';

  @override
  String get fontSizeNormal => 'Bình thường';

  @override
  String get fontSizeLarge => 'Lớn';

  @override
  String get fontSizeExtraLarge => 'Rất lớn';

  @override
  String get fontSizePreview => 'Xem trước';

  @override
  String get chatBackgroundTitle => 'Nền chat';

  @override
  String get chatBackgroundDefault => 'Mặc định';

  @override
  String get chatBackgroundCustom => 'Tùy chỉnh';

  @override
  String get chatBackgroundReset => 'Đặt lại mặc định';

  @override
  String get termsTitle => 'Điều khoản dịch vụ';

  @override
  String get privacyPolicyTitle => 'Chính sách bảo mật';

  @override
  String get recentContactsTitle => 'Liên hệ gần đây';

  @override
  String get recentContactsEmpty => 'Không có liên hệ gần đây';

  @override
  String get inviteFriendsTitle => 'Mời bạn bè';

  @override
  String get inviteFriendsCopyLink => 'Sao chép link mời';

  @override
  String get inviteFriendsLinkCopied => 'Đã sao chép link mời';

  @override
  String get imageViewerTitle => 'Ảnh';

  @override
  String get imageViewerSave => 'Lưu vào thư viện';

  @override
  String get imageViewerSaveSuccess => 'Đã lưu vào thư viện';

  @override
  String get imageViewerSaveFailed => 'Lưu thất bại, vui lòng thử lại';

  @override
  String get customerServiceTitle => 'Dịch vụ khách hàng';

  @override
  String get customerServiceQueue => 'Đang chờ';

  @override
  String get customerServiceActive => 'Đang phục vụ';

  @override
  String get customerServiceClaim => 'Tiếp nhận';

  @override
  String get customerServiceTakeover => 'Tiếp quản';

  @override
  String get customerServiceClose => 'Kết thúc dịch vụ';

  @override
  String get customerServiceCloseConfirm => 'Kết thúc phiên dịch vụ này?';

  @override
  String get customerServiceNoQueue => 'Không có phiên đang chờ';

  @override
  String get customerServiceNoActive => 'Không có phiên đang hoạt động';

  @override
  String get customerServiceVisitor => 'Khách';

  @override
  String get customerServiceCustomer => 'Khách hàng';

  @override
  String get customerServiceAssignedTo => 'Nhân viên phụ trách';

  @override
  String get customerServiceTransferConversation => 'Chuyển cuộc trò chuyện';

  @override
  String get marketingToolbar => 'Công cụ marketing';

  @override
  String get callIncoming => 'Cuộc gọi đến';

  @override
  String get callOutgoing => 'Cuộc gọi đi';

  @override
  String get callAccept => 'Chấp nhận';

  @override
  String get callReject => 'Từ chối';

  @override
  String get callHangup => 'Kết thúc';

  @override
  String get callMissed => 'Cuộc gọi nhỡ';

  @override
  String get callDuration => 'Thời lượng';

  @override
  String get callAudio => 'Gọi thoại';

  @override
  String get callGeneric => 'Cuộc gọi';

  @override
  String get callVideo => 'Gọi video';

  @override
  String get callConnecting => 'Đang kết nối...';

  @override
  String get callRinging => 'Đang đổ chuông...';

  @override
  String get callEnded => 'Cuộc gọi đã kết thúc';

  @override
  String get callFailed => 'Cuộc gọi thất bại';

  @override
  String get callRejected => 'Cuộc gọi bị từ chối';

  @override
  String get callTimeout => 'Không có phản hồi';

  @override
  String get callCancelled => 'Đã hủy';

  @override
  String get callUnknownPeer => 'Không xác định';

  @override
  String get callVideoInvitation => 'Lời mời gọi video';

  @override
  String get callAudioInvitation => 'Lời mời gọi thoại';

  @override
  String get callAnswerAudio => 'Trả lời bằng âm thanh';

  @override
  String get callAnswerVideo => 'Trả lời bằng video';

  @override
  String get callViewProfile => 'Xem hồ sơ';

  @override
  String get callOpeningCamera => 'Đang mở camera...';

  @override
  String get callWaitingRemoteVideo => 'Đang chờ video từ đầu bên kia...';

  @override
  String get callCameraOff => 'Camera đã tắt';

  @override
  String get callCameraOn => 'Camera đã bật';

  @override
  String get callMicrophoneOff => 'Micrô đã tắt';

  @override
  String get callMicrophoneOn => 'Micrô đã bật';

  @override
  String get callSpeakerOff => 'Loa đã tắt';

  @override
  String get callSpeakerOn => 'Loa đã bật';

  @override
  String get callVideoPermissionFailure =>
      'Không thể bắt đầu cuộc gọi video. Hãy kiểm tra quyền camera và micrô rồi thử lại.';

  @override
  String get callAudioPermissionFailure =>
      'Không thể bắt đầu cuộc gọi thoại. Hãy kiểm tra quyền micrô rồi thử lại.';

  @override
  String get callIncompleteIncoming =>
      'Thông tin cuộc gọi đến không đầy đủ nên không thể trả lời.';

  @override
  String get callInProgress => 'Đang gọi';

  @override
  String get callCalling => 'Đang gọi...';

  @override
  String callEndedMedia(String media) {
    return '$media đã kết thúc';
  }

  @override
  String callRejectedMedia(String media) {
    return '$media đã bị từ chối';
  }

  @override
  String callUnansweredMedia(String media) {
    return '$media không được trả lời';
  }

  @override
  String callCancelledMedia(String media) {
    return '$media đã bị hủy';
  }

  @override
  String get callConnectionLost => 'Kết nối cuộc gọi đã bị gián đoạn';

  @override
  String get callAdminEnded => 'Cuộc gọi đã bị quản trị viên kết thúc';

  @override
  String callFailedMedia(String media) {
    return '$media thất bại';
  }

  @override
  String get callBusy => 'Người kia đang bận';

  @override
  String callDurationValue(String duration) {
    return 'Thời lượng cuộc gọi $duration';
  }

  @override
  String get callNotConnected => 'Chưa kết nối';

  @override
  String get callDialed => 'Đã gọi đi';

  @override
  String get callAnswered => 'Đã trả lời';

  @override
  String get callRejectedByPeer => 'Người kia đã từ chối';

  @override
  String get callRejectedBySelf => 'Đã từ chối';

  @override
  String get callPeerDidNotAnswer => 'Người kia không trả lời';

  @override
  String get callMissedIncoming => 'Cuộc gọi đến bị nhỡ';

  @override
  String get callPeerCancelled => 'Người kia đã hủy';

  @override
  String get notificationNewMessageTitle => 'Tin nhắn StartLink mới';

  @override
  String get notificationOnlineServiceTitle =>
      'Tin nhắn chăm sóc khách hàng mới';

  @override
  String get notificationNewMessageBody => 'Bạn đã nhận được một tin nhắn mới';

  @override
  String get notificationImagePreview => 'Đã gửi một hình ảnh';

  @override
  String get notificationVideoPreview => 'Đã gửi một video';

  @override
  String get notificationVoicePreview => 'Đã gửi một tin nhắn thoại';

  @override
  String get notificationFilePreview => 'Đã gửi một tệp';

  @override
  String get notificationContactPreview => 'Đã gửi một danh thiếp';

  @override
  String get notificationCallLogPreview => 'Đã gửi một bản ghi cuộc gọi';

  @override
  String get notificationLocationPreview => 'Đã chia sẻ một vị trí';

  @override
  String get notificationLinkPreview => 'Đã chia sẻ một liên kết';

  @override
  String notificationMentionMe(String body) {
    return 'Đã nhắc đến bạn: $body';
  }

  @override
  String notificationMentionMeBy(String sender, String body) {
    return '$sender đã nhắc đến bạn: $body';
  }

  @override
  String notificationMentionAll(String body) {
    return 'Đã nhắc đến mọi người: $body';
  }

  @override
  String notificationMentionAllBy(String sender, String body) {
    return '$sender đã nhắc đến mọi người: $body';
  }

  @override
  String get notificationSecurityTitle => 'Cảnh báo bảo mật tài khoản';

  @override
  String get notificationSecurityBody =>
      'Cài đặt bảo mật tài khoản StartLink của bạn đã thay đổi. Hãy kiểm tra ngay.';

  @override
  String get notificationFriendAcceptedTitle =>
      'Yêu cầu kết bạn đã được chấp nhận';

  @override
  String get notificationFriendRejectedTitle => 'Yêu cầu kết bạn đã bị từ chối';

  @override
  String get notificationFriendAcceptedBody =>
      'Người kia đã chấp nhận yêu cầu kết bạn của bạn';

  @override
  String get notificationFriendRejectedBody =>
      'Người kia đã từ chối yêu cầu kết bạn của bạn';

  @override
  String get notificationVideoCallTitle => 'Lời mời gọi video';

  @override
  String get notificationAudioCallTitle => 'Lời mời gọi thoại';

  @override
  String notificationVideoCallBody(String caller) {
    return '$caller đã mời bạn gọi video';
  }

  @override
  String notificationAudioCallBody(String caller) {
    return '$caller đã mời bạn gọi thoại';
  }

  @override
  String get notificationMessageChannelName => 'Tin nhắn';

  @override
  String get notificationMessageChannelDescription =>
      'Tin nhắn trò chuyện, bản ghi cuộc gọi và cảnh báo hệ thống';

  @override
  String get notificationCallChannelName => 'Cuộc gọi';

  @override
  String get notificationCallChannelDescription =>
      'Cảnh báo cuộc gọi thoại và video';

  @override
  String get notificationSecurityChannelName => 'Bảo mật tài khoản';

  @override
  String get notificationSecurityChannelDescription =>
      'Cảnh báo thay đổi đăng nhập, mật khẩu và số điện thoại';

  @override
  String get notificationUnknownCaller => 'Người gọi không xác định';

  @override
  String get pendingJoinRequestsTitle => 'Yêu cầu mới';

  @override
  String get pendingJoinRequestsEmpty => 'Không có yêu cầu';

  @override
  String get pendingJoinRequestApprove => 'Chấp nhận';

  @override
  String get pendingJoinRequestReject => 'Từ chối';

  @override
  String get pendingJoinRequestApproveSuccess => 'Đã chấp nhận';

  @override
  String get pendingJoinRequestRejectSuccess => 'Đã từ chối';

  @override
  String get pendingJoinRequestFailed => 'Thao tác thất bại, vui lòng thử lại';

  @override
  String get myCustomersTitle => 'Khách hàng của tôi';

  @override
  String get myCustomersEmpty => 'Không có khách hàng';

  @override
  String get groupListTitle => 'Danh sách nhóm';

  @override
  String get groupListEmpty => 'Không có nhóm';

  @override
  String get addFriendTitle => 'Thêm bạn bè';

  @override
  String get addFriendSearchHint => 'SĐT / Email / StartLink ID';

  @override
  String addFriendLppIdLabel(String lppId) {
    return 'StartLink ID: $lppId';
  }

  @override
  String get addFriendButton => 'Kết bạn';

  @override
  String get addFriendCannotAddSelf => 'Bạn không thể thêm chính mình';

  @override
  String get addFriendUnsupportedUser =>
      'Không thể thêm người dùng này. Bạn có thể nhắn tin trực tiếp.';

  @override
  String get addFriendMessageHint => 'Nhập tin nhắn';

  @override
  String get addFriendSendRequest => 'Gửi yêu cầu';

  @override
  String get joinCompanyTitle => 'Tham gia doanh nghiệp';

  @override
  String get joinCompanyCodeHint => 'Nhập mã doanh nghiệp';

  @override
  String get joinCompanySearchHint => 'Tìm kiếm tên doanh nghiệp';

  @override
  String get joinCompanyApply => 'Gửi yêu cầu tham gia';

  @override
  String get joinCompanyApplySuccess => 'Đã gửi yêu cầu';

  @override
  String get joinCompanyApplyFailed => 'Gửi yêu cầu thất bại, vui lòng thử lại';

  @override
  String get joinCompanyAutoApproved => 'Đã được tự động chấp nhận. Chào mừng!';

  @override
  String get joinCompanyPending => 'Đã gửi yêu cầu, đang chờ phê duyệt';

  @override
  String get joinCompanyInviteCodeHint => 'Nhập mã mời';

  @override
  String get joinCompanyAcceptInvite => 'Chấp nhận lời mời';

  @override
  String get joinCompanyNoResults => 'Không tìm thấy doanh nghiệp';

  @override
  String joinCompanyMemberCount(int count) {
    return '$count thành viên';
  }

  @override
  String get timezoneNameHawaii => 'Hawaii';

  @override
  String get timezoneNameAlaska => 'Alaska';

  @override
  String get timezoneNamePacificTime => 'Giờ Thái Bình Dương';

  @override
  String get timezoneNameMountainTime => 'Giờ Miền núi';

  @override
  String get timezoneNameCentralTime => 'Giờ Miền Trung';

  @override
  String get timezoneNameEasternTime => 'Giờ Miền Đông';

  @override
  String get timezoneNameAtlanticTime => 'Giờ Đại Tây Dương';

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
  String get timezoneNameBangkokHanoiJakarta => 'Bangkok/Hà Nội/Jakarta';

  @override
  String get timezoneNameBeijingShanghaiHongKongTaipei =>
      'Bắc Kinh/Thượng Hải/Hồng Kông/Đài Bắc';

  @override
  String get timezoneNameTokyoSeoul => 'Tokyo/Seoul';

  @override
  String get timezoneNameAdelaide => 'Adelaide';

  @override
  String get timezoneNameSydneyMelbourne => 'Sydney/Melbourne';

  @override
  String get timezoneNameSolomonIslands => 'Quần đảo Solomon';

  @override
  String get timezoneNameAucklandFiji => 'Auckland/Fiji';

  @override
  String get networkSmartSelectBestRoute => 'Tự chọn tuyến tối ưu';

  @override
  String get networkTesting => 'Đang kiểm tra...';

  @override
  String get networkTestingShort => 'Đang kiểm tra';

  @override
  String networkLatencyMs(int ms) {
    return 'Độ trễ ${ms}ms';
  }

  @override
  String get networkConnectionMode => 'Chế độ kết nối';

  @override
  String get networkDirectMode => 'Chế độ trực tiếp';

  @override
  String get networkProxyMode => 'Chế độ proxy';

  @override
  String get networkDirectModeDesc => 'Kết nối trực tiếp tới máy chủ';

  @override
  String get networkProxyModeDesc => 'Kết nối qua máy chủ proxy';

  @override
  String get networkDirectRoutes => 'Tuyến trực tiếp';

  @override
  String get networkProxyRoutes => 'Tuyến proxy';

  @override
  String get networkTestAll => 'Kiểm tra tất cả';

  @override
  String get networkChinaTelecom => 'China Telecom';

  @override
  String get networkChinaUnicom => 'China Unicom';

  @override
  String get networkChinaMobile => 'China Mobile';

  @override
  String get networkHongKongNode => 'Nút Hồng Kông';

  @override
  String get networkSingaporeNode => 'Nút Singapore';

  @override
  String get networkJapanNode => 'Nút Nhật Bản';

  @override
  String get networkUnitedStatesNode => 'Nút Hoa Kỳ';

  @override
  String get networkHint =>
      'Gợi ý:\n• Chế độ trực tiếp: nhanh hơn, phù hợp dùng trong nước\n• Chế độ proxy: ổn định hơn cho liên lạc xuyên biên giới\n• Nhấn biểu tượng làm mới để kiểm tra độ trễ từng tuyến';

  @override
  String get teenModeTitle => 'Chế độ thanh thiếu niên';

  @override
  String get teenModeStatusOn => 'Đã bật';

  @override
  String get teenModeStatusOff => 'Đã tắt';

  @override
  String get teenModeStatusLoading => 'Đang tải';

  @override
  String get teenModeUnavailable =>
      'Tạm thời không thể tải trạng thái chế độ thanh thiếu niên';

  @override
  String get teenModeInvalidResponse =>
      'Dịch vụ Chế độ thanh thiếu niên đã trả về phản hồi không hợp lệ';

  @override
  String get teenModeEnableDescription =>
      'Quy tắc nền tảng sẽ giới hạn thời gian sử dụng và một số tính năng.';

  @override
  String get teenModePasscode => 'Mật mã';

  @override
  String get teenModeCurrentPasscode => 'Mật mã hiện tại';

  @override
  String get teenModeNewPasscode => 'Mật mã mới';

  @override
  String get teenModePasscodeHint => 'Nhập 4–6 chữ số';

  @override
  String get teenModeEnable => 'Bật chế độ thanh thiếu niên';

  @override
  String get teenModeDisable => 'Tắt chế độ thanh thiếu niên';

  @override
  String get teenModeChangePasscode => 'Đổi mật mã';

  @override
  String get teenModeSource => 'Nguồn kích hoạt';

  @override
  String get teenModeDailyUsage => 'Đã dùng hôm nay';

  @override
  String get teenModeRemaining => 'Thời gian còn lại';

  @override
  String get teenModeMinutesUnit => 'phút';

  @override
  String get teenModeUnlimited => 'Không giới hạn';

  @override
  String get teenModeRequestExtension => 'Yêu cầu thêm thời gian';

  @override
  String get teenModeExtensionSubmitted =>
      'Đã gửi yêu cầu thêm thời gian cho người giám hộ';

  @override
  String get teenModeTimeLimitReached => 'Đã hết thời gian sử dụng hôm nay';

  @override
  String get teenModeCurfewActive => 'Hiện đang trong khung giờ hạn chế';

  @override
  String get teenModeReliefHint =>
      'Bạn vẫn có thể xem lịch sử, liên hệ hỗ trợ chính thức và báo cáo vấn đề.';

  @override
  String get teenModeRestrictedNotice =>
      'Chế độ thanh thiếu niên đang hạn chế gửi tin nhắn';

  @override
  String get teenModeActionBlocked =>
      'Chế độ thanh thiếu niên đang hạn chế thao tác này';

  @override
  String get teenModeMyRequests => 'Yêu cầu của tôi';

  @override
  String get guardianCenterTitle => 'Trung tâm giám hộ';

  @override
  String get guardianRelationships => 'Quan hệ giám hộ';

  @override
  String get guardianMinors => 'Trẻ tôi giám hộ';

  @override
  String get guardianApprovals => 'Chờ tôi phê duyệt';

  @override
  String get guardianBind => 'Nhập mã liên kết';

  @override
  String get guardianCreateMinorCode => 'Tôi là trẻ — tạo mã';

  @override
  String get guardianCreateGuardianCode => 'Tôi là người giám hộ — tạo mã';

  @override
  String get guardianRelation => 'Quan hệ';

  @override
  String get guardianPrimary => 'Người giám hộ chính';

  @override
  String get guardianCode => 'Mã liên kết 6 chữ số';

  @override
  String get guardianCodeHint => 'Nhập mã do người kia cung cấp';

  @override
  String get guardianCodeCreated => 'Đã tạo mã. Hãy chia sẻ trước khi hết hạn.';

  @override
  String get guardianEmpty => 'Chưa có quan hệ giám hộ';

  @override
  String get guardianNoMinors => 'Chưa có trẻ được giám hộ';

  @override
  String get guardianUnbind => 'Gỡ quan hệ';

  @override
  String get guardianExtend => 'Thêm thời gian cho trẻ';

  @override
  String get guardianPolicyTitle => 'Quy tắc sử dụng';

  @override
  String get guardianPolicyLocked => 'Đã bị nền tảng khóa';

  @override
  String get approvalEmpty => 'Không có yêu cầu';

  @override
  String get approvalApprove => 'Đồng ý';

  @override
  String get approvalReject => 'Từ chối';

  @override
  String get approvalPending => 'Đang chờ';

  @override
  String get approvalApproved => 'Đã đồng ý';

  @override
  String get approvalRejected => 'Đã từ chối';

  @override
  String get approvalExpired => 'Đã hết hạn';

  @override
  String get approvalCancelled => 'Đã hủy';

  @override
  String get approvalReplayFailed =>
      'Thao tác ban đầu thất bại. Vui lòng thực hiện lại.';

  @override
  String get requestCancelled => 'Đã hủy yêu cầu';

  @override
  String get kycTitle => 'Xác minh danh tính';

  @override
  String get kycNotRequired => 'Không cần xác minh danh tính';

  @override
  String get kycVerified => 'Đã xác minh danh tính';

  @override
  String get kycDeclared => 'Đã gửi thông tin danh tính';

  @override
  String get kycPending => 'Đang xét duyệt';

  @override
  String get kycRejected => 'Xét duyệt bị từ chối';

  @override
  String get kycNone => 'Chưa gửi thông tin danh tính';

  @override
  String get kycRealName => 'Họ tên pháp lý';

  @override
  String get kycIdNumber => 'Số giấy tờ';

  @override
  String get kycIdType => 'Loại giấy tờ';

  @override
  String get kycApplicability =>
      'Nhập thông tin chính xác theo loại giấy tờ đã chọn. Xem danh sách giấy tờ được chấp nhận.';

  @override
  String get kycCamera => 'Chụp ảnh';

  @override
  String get kycGallery => 'Chọn từ thư viện';

  @override
  String get kycPhotoLimit => 'Giới hạn mỗi ảnh';

  @override
  String get kycSelectPhoto => 'Chọn ảnh';

  @override
  String get kycPhotoSelected => 'Đã chọn';

  @override
  String get kycViewPhoto => 'Nhấn để xem ảnh';

  @override
  String get kycReplacePhoto => 'Chọn lại ảnh';

  @override
  String get kycDisclosure =>
      'Chúng tôi dùng tên, số giấy tờ và ảnh giấy tờ để xét duyệt danh tính. Nếu không cung cấp, bạn không thể gửi và một số tính năng có thể bị hạn chế.';

  @override
  String get kycConsent =>
      'Tôi đồng ý riêng với việc xử lý thông tin danh tính này';

  @override
  String get kycConsentRequired => 'Vui lòng đồng ý riêng trước khi gửi';

  @override
  String get kycResubmitTitle => 'Gửi lại thông tin danh tính';

  @override
  String get kycResubmitWarning =>
      'Gửi lại sẽ hủy hồ sơ đang chờ xét duyệt. Tiếp tục?';

  @override
  String get kycSubmitting => 'Đang gửi';

  @override
  String get kycSubmitFailed => 'Gửi thất bại. Vui lòng thử lại.';

  @override
  String get kycSubmitUnavailable => 'Hiện không thể gửi thông tin danh tính';

  @override
  String get kycResubmitNotAllowed =>
      'Không thể gửi lại sau khi bị từ chối. Liên hệ hỗ trợ nếu cần.';

  @override
  String get kycDailyLimit =>
      'Bạn đã đạt giới hạn gửi hôm nay. Vui lòng thử lại ngày mai.';

  @override
  String get kycTypeUnavailable =>
      'Chưa có loại giấy tờ nào khả dụng. Vui lòng thử lại sau.';

  @override
  String get kycNameInvalid => 'Họ tên pháp lý phải dài 2–64 ký tự';

  @override
  String get kycNumberRequired => 'Nhập số giấy tờ';

  @override
  String get kycFrontRequired => 'Tải ảnh mặt trước giấy tờ lên';

  @override
  String get kycBackRequired => 'Tải ảnh mặt sau giấy tờ lên';

  @override
  String get kycPhotoTooLarge =>
      'Ảnh vượt quá giới hạn dung lượng. Hãy nén và thử lại.';

  @override
  String get kycAccountChanged =>
      'Tài khoản hoặc không gian đã thay đổi. Hãy mở lại trang này.';

  @override
  String get kycPhotoInvalid => 'Chọn ảnh hợp lệ';

  @override
  String get kycPortraitSide => 'Mặt có chân dung';

  @override
  String get kycEmblemSide => 'Mặt có quốc huy';

  @override
  String get kycPassportDataPage => 'Trang thông tin hộ chiếu';

  @override
  String get kycPassportOtherPage => 'Trang thị thực hoặc trang dự phòng';

  @override
  String get kycFront => 'Mặt trước giấy tờ';

  @override
  String get kycBack => 'Mặt sau giấy tờ';

  @override
  String get kycRequired => 'Cần xác minh danh tính trước khi tạo nhóm';

  @override
  String get kycGoVerify => 'Xác minh ngay';

  @override
  String get kycStatusUnknown =>
      'Tạm thời không thể hiển thị trạng thái danh tính. Hãy làm mới sau.';

  @override
  String get kycSuperseded =>
      'Lần gửi này đã được thay thế bằng lần gửi sau. Hãy xem trạng thái xác minh mới nhất.';

  @override
  String get kycMediaNotFound =>
      'Không tìm thấy ảnh giấy tờ trong không gian này. Hãy chọn lại trước khi gửi.';

  @override
  String get customerServiceBroadcastDirectTitle =>
      'Gửi hàng loạt cho khách hàng';

  @override
  String get officialAccountBadge => 'Chính thức';

  @override
  String get officialAccountOpenConversation => 'Mở cuộc trò chuyện';

  @override
  String get officialAccountJoinHint =>
      'Thêm tài khoản này sẽ tham gia doanh nghiệp với tư cách khách hàng, không cần duyệt kết bạn.';

  @override
  String get officialAccountJoinDisabled =>
      'Doanh nghiệp này chưa cho phép thêm. Vui lòng liên hệ hỗ trợ.';

  @override
  String get officialAccountRemoved =>
      'Bạn đã bị xóa khỏi doanh nghiệp. Hãy yêu cầu doanh nghiệp mời lại.';

  @override
  String get officialAccountBanned =>
      'Tài khoản của bạn đã bị vô hiệu hóa trong doanh nghiệp này.';

  @override
  String get officialAccountUnavailable =>
      'Tài khoản chính thức này hiện không khả dụng.';

  @override
  String get officialAccountJoinBindingDisabled =>
      'Chế độ hiện tại không cho phép tham gia doanh nghiệp.';

  @override
  String get officialAccountPlatformRequired =>
      'Hãy dùng tài khoản nền tảng để thêm tài khoản chính thức này.';

  @override
  String get officialAccountOpenFailed =>
      'Không thể mở cuộc trò chuyện. Vui lòng thử lại.';

  @override
  String get officialAccountAccountChanged =>
      'Tài khoản hoặc không gian đã thay đổi. Vui lòng mở lại.';

  @override
  String get officialAccountDirectoryUnavailable =>
      'Danh sách doanh nghiệp chưa được cập nhật. Vui lòng thử lại sau.';

  @override
  String get officialAccountInboxSyncFailed =>
      'Đồng bộ tài khoản chính thức thất bại. Nội dung cục bộ vẫn được giữ lại.';

  @override
  String get officialAccountInboxSyncing =>
      'Đang đồng bộ tin nhắn tài khoản chính thức';

  @override
  String get diagnosticsTitle => 'Chẩn đoán sự cố';

  @override
  String get diagnosticsExplanation =>
      'Nhật ký đã được ẩn thông tin nhạy cảm, chỉ gồm hoạt động và lỗi của tài khoản, không gian hiện tại và sự kiện khởi động chung. Không gồm nội dung trò chuyện hay thông tin đăng nhập.';

  @override
  String get diagnosticsHour => '1 giờ qua';

  @override
  String get diagnosticsDay => '24 giờ qua';

  @override
  String get diagnosticsWeek => '7 ngày qua';

  @override
  String diagnosticsEventCount(int count) {
    return 'Số bản ghi: $count';
  }

  @override
  String get diagnosticsPersistent =>
      'Nhật ký đã lưu trên thiết bị và có thể xuất sau khi khởi động lại.';

  @override
  String get diagnosticsNotPersistent =>
      'Một số nhật ký chưa được lưu. Vui lòng làm mới.';

  @override
  String get diagnosticsExport => 'Xuất và chia sẻ';

  @override
  String get diagnosticsRefresh => 'Làm mới';

  @override
  String get diagnosticsClear => 'Xóa nhật ký không gian này';

  @override
  String get diagnosticsClearConfirm =>
      'Xóa nhật ký chẩn đoán của không gian này? Lịch sử trò chuyện sẽ được giữ lại.';

  @override
  String get diagnosticsShared =>
      'Thao tác chia sẻ đã hoàn tất. Hãy kiểm tra tệp trong ứng dụng nhận.';

  @override
  String get diagnosticsCancelled => 'Đã hủy chia sẻ. Bạn có thể xuất lại.';

  @override
  String get diagnosticsUnconfirmed =>
      'Không thể xác nhận kết quả chia sẻ. Hãy kiểm tra ứng dụng nhận.';

  @override
  String get diagnosticsFailed => 'Thao tác thất bại. Vui lòng thử lại.';
}
