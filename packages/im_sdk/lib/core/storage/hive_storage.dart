import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Hive 本地存储管理
///
/// 负责初始化 Hive 并按空间/会话隔离管理各 Box。
class HiveStorage {
  static const String _messagesBoxPrefix = 'messages';
  static const String _conversationsBoxPrefix = 'conversations';
  static const String _draftsBoxPrefix = 'drafts';
  static String? _directory;
  static String _namespace = 'im_sdk_default';
  static String? get storageDirectory => _directory;
  static String boxName(String name) => '${_namespace}_$name';
  static String get _settingsName => boxName('app_settings');

  static Future<void> initForSdk(
      {required String directory, required String namespace}) async {
    if (directory.isEmpty ||
        !RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(namespace)) {
      throw ArgumentError('SDK storage directory and namespace are required');
    }
    if (_directory != null &&
        (_directory != directory || _namespace != 'im_sdk_$namespace')) {
      throw StateError('SDK Hive storage is already initialized');
    }
    _directory = directory;
    _namespace = 'im_sdk_$namespace';
    await Directory(directory).create(recursive: true);
    if (!Hive.isBoxOpen(_settingsName)) {
      await Hive.openBox<String>(_settingsName, path: directory);
    }
  }

  static Future<void> closeForSdk() async {
    if (Hive.isBoxOpen(_settingsName))
      await Hive.box<String>(_settingsName).close();
    _directory = null;
    _namespace = 'im_sdk_default';
  }

  static Future<Box<dynamic>> _open(String name) {
    final directory = _directory;
    if (directory == null) throw StateError('SDK storage is not initialized');
    final physical = boxName(name);
    return Hive.isBoxOpen(physical)
        ? Future.value(Hive.box<dynamic>(physical))
        : Hive.openBox<dynamic>(physical, path: directory);
  }

  /// 初始化 Hive（在 main() 中调用）
  static Future<void> init() => initDeviceSettings();

  /// Opens only device-level settings and performs no business/network startup.
  /// Safe to call before privacy consent so the consent shell can honor the
  /// language previously selected on this device.
  static Future<void> initDeviceSettings() async {
    if (_directory != null && Hive.isBoxOpen(_settingsName)) return;
    final support = await getApplicationSupportDirectory();
    await initForSdk(
        directory: p.join(support.path, 'im_sdk', 'default'),
        namespace: 'default');
  }

  /// 获取消息 Box（按 spaceId + conversationId 隔离）
  static Future<Box<dynamic>> messagesBox(
      String spaceId, String conversationId) async {
    return _open('${_messagesBoxPrefix}_${spaceId}_$conversationId');
  }

  /// 获取会话 Box（按 spaceId 隔离）
  static Future<Box<dynamic>> conversationsBox(String spaceId) async {
    return _open('${_conversationsBoxPrefix}_$spaceId');
  }

  static Box<String> get settingsBox => Hive.box<String>(_settingsName);

  static const String _profileBoxName = 'user_profiles';

  /// 获取用户 profile Box（按 spaceId 隔离）
  static Future<Box<dynamic>> profileBox(String spaceId) async {
    return _open('${_profileBoxName}_$spaceId');
  }

  static Future<Box<dynamic>> draftsBox(String spaceId) async {
    return _open('${_draftsBoxPrefix}_$spaceId');
  }
}
