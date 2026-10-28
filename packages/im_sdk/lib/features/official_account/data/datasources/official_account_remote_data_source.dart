import 'package:dio/dio.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account.dart';

class OfficialAccountRemoteDataSource {
  final Dio _dio;

  const OfficialAccountRemoteDataSource(this._dio);

  Future<OfficialAccount> getOfficialAccount() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/official-account',
      );
      return _officialAccount(_dataMap(response.data));
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  Future<OfficialAccountMenu> getMenu() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/client/v1/official-account/menu',
      );
      return _menu(_dataMap(response.data));
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  Future<OfficialAccountMenuClickResult> clickMenuItem(String itemId) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/official-account/menu/${Uri.encodeComponent(itemId)}/click',
      );
      return _clickResult(_dataMap(response.data));
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  Future<OfficialAccountHandoff> contactService() async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/client/v1/official-account/contact-service',
      );
      final code = response.data?['code'];
      if (code != null && code != 'OK') {
        throw ServerError(
            code: code.toString(),
            message: 'Customer service request rejected');
      }
      return _handoff(_dataMap(response.data));
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    }
  }

  OfficialAccount _officialAccount(Map<String, dynamic> data) {
    return OfficialAccount(
      userId: _requiredString(data['officialUserId'], 'officialUserId'),
      displayName: _requiredString(data['displayName'], 'displayName'),
      avatarUrl: _nullableString(data['avatarUrl']),
      status: _integer(data['status']),
      conversationId: _nullableString(data['conversationId']),
      menu: _menu(_map(data['menu'])),
    );
  }

  OfficialAccountMenu _menu(Map<String, dynamic> data) {
    return OfficialAccountMenu(
      enabled: data['menuEnabled'] == true,
      version: _integer(data['menuVersion']),
      items: _list(data['items']).map(_menuItem).toList(growable: false),
    );
  }

  OfficialAccountMenuItem _menuItem(Map<String, dynamic> data) {
    return OfficialAccountMenuItem(
      id: _requiredString(data['itemId'], 'itemId'),
      title: _requiredString(data['title'], 'title'),
      type: _menuItemType(data['itemType']),
      url: _nullableString(data['url']),
      appRoute: _nullableString(data['appRoute']),
      replyText: _nullableString(data['replyText']),
      actionCode: _nullableString(data['actionCode']),
      iconUrl: _nullableString(data['iconUrl']),
      enabled: data['isEnabled'] != false,
      sortOrder: _integer(data['sortOrder']),
      children: _list(data['children']).map(_menuItem).toList(growable: false),
    );
  }

  OfficialAccountMenuClickResult _clickResult(Map<String, dynamic> data) {
    final handoff = data['handoff'];
    return OfficialAccountMenuClickResult(
      itemId: _requiredString(data['itemId'], 'itemId'),
      type: _menuItemType(data['itemType']),
      url: _nullableString(data['url']),
      appRoute: _nullableString(data['appRoute']),
      actionCode: _nullableString(data['actionCode']),
      replied: data['replied'] == true,
      handoff: handoff is Map ? _handoff(_map(handoff)) : null,
    );
  }

  OfficialAccountHandoff _handoff(Map<String, dynamic> data) {
    return OfficialAccountHandoff(
      threadId: _requiredString(data['threadId'], 'threadId'),
      status: _handoffStatus(data['status']),
      staffUserId: _nullableString(data['staffUserId']),
      staffDisplayName: _nullableString(data['staffDisplayName']),
      conversationId: _nullableString(data['conversationId']),
    );
  }

  OfficialAccountMenuItemType _menuItemType(Object? value) {
    return switch (_nullableString(value)) {
      'url' => OfficialAccountMenuItemType.url,
      'app_route' => OfficialAccountMenuItemType.appRoute,
      'text' => OfficialAccountMenuItemType.text,
      'action' => OfficialAccountMenuItemType.action,
      'group' => OfficialAccountMenuItemType.group,
      _ => OfficialAccountMenuItemType.unknown,
    };
  }

  OfficialAccountHandoffStatus _handoffStatus(Object? value) {
    return switch (_nullableString(value)) {
      'active' => OfficialAccountHandoffStatus.active,
      'queued' => OfficialAccountHandoffStatus.queued,
      _ => OfficialAccountHandoffStatus.unknown,
    };
  }

  Map<String, dynamic> _dataMap(Map<String, dynamic>? envelope) {
    return _map(envelope?['data']);
  }

  Map<String, dynamic> _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, entry) => MapEntry(key.toString(), entry));
    }
    return const {};
  }

  List<Map<String, dynamic>> _list(Object? value) {
    if (value is! List) return const [];
    return value.whereType<Map>().map(_map).toList(growable: false);
  }

  String? _nullableString(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  String _requiredString(Object? value, String field) {
    final text = _nullableString(value);
    if (text == null) {
      throw StateError('Official account response is missing $field');
    }
    return text;
  }

  int _integer(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;
}
