import 'dart:io';

import 'package:hive/hive.dart';
import 'package:im_sdk/core/auth/account_session.dart';
import 'package:im_sdk/core/database/app_database.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/runtime/account_write_gate.dart';
import 'package:im_sdk/core/space/account_scope.dart';
import 'package:im_sdk/core/storage/account_storage_context.dart';
import 'package:im_sdk/core/storage/hive_storage.dart';
import 'package:im_sdk/core/utils/async_lock.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AccountStorageRegistry {
  AccountStorageRegistry({
    required Directory documentsRoot,
    DatabaseFactory? databaseFactory,
  })  : _documentsRoot = documentsRoot,
        _databaseFactory = databaseFactory;

  final Directory _documentsRoot;
  final DatabaseFactory? _databaseFactory;
  final AsyncLock _lock = AsyncLock();
  final Set<String> _leasedStorageHashes = <String>{};

  Future<AccountStorageContext> open({
    required AccountSession session,
  }) =>
      _lock.synchronized(() async {
        final scope = session.scope;
        final hash = scope.storageKeyHash;
        if (!_leasedStorageHashes.add(hash)) throw AccountStorageBusy();

        Database? database;
        Box<dynamic>? box;
        Box<dynamic>? settingsBox;
        try {
          await _documentsRoot.create(recursive: true);
          final databasePath =
              p.join(_documentsRoot.path, 'lpp_chat_v2_$hash.db');
          database = await AppDatabase.openAccountScopedAt(
            databasePath,
            factory: _databaseFactory,
          );
          await _verifyDatabaseFingerprint(
            database,
            storageKeyHash: hash,
            accountScopeKey: scope.scopeKey,
          );

          final boxName = HiveStorage.boxName('account_v2_$hash');
          box = Hive.isBoxOpen(boxName)
              ? Hive.box<dynamic>(boxName)
              : await Hive.openBox<dynamic>(boxName, path: _documentsRoot.path);
          await _verifyHiveFingerprint(
            box,
            storageKeyHash: hash,
            accountScopeKey: scope.scopeKey,
          );
          final settingsBoxName = _settingsBoxName(hash);
          settingsBox = Hive.isBoxOpen(settingsBoxName)
              ? Hive.box<dynamic>(settingsBoxName)
              : await Hive.openBox<dynamic>(settingsBoxName,
                  path: _documentsRoot.path);
          await _verifyHiveFingerprint(
            settingsBox,
            storageKeyHash: hash,
            accountScopeKey: scope.scopeKey,
          );

          final mediaRoot = Directory(
            p.join(_documentsRoot.path, 'media_v2', hash),
          );
          await mediaRoot.create(recursive: true);
          final operationContext = AccountOperationContext(
            accountScopeKey: scope.scopeKey,
            identityRevision: session.identityRevision,
            sessionId: session.sessionId,
          );
          final writeGate = ScopedAccountWriteGate(operationContext);
          final openedDatabase = database;
          final openedBox = box;
          final openedSettingsBox = settingsBox;
          return AccountStorageContext(
            scope: scope,
            database: openedDatabase,
            accountBox: openedBox,
            settingsBox: openedSettingsBox,
            mediaRoot: mediaRoot,
            operationContext: operationContext,
            writeGate: writeGate,
            release: () => _release(
              hash: hash,
              database: openedDatabase,
              box: openedBox,
              settingsBox: openedSettingsBox,
            ),
          );
        } catch (error, stackTrace) {
          var cleanupSucceeded = true;
          try {
            await box?.close();
            await settingsBox?.close();
            await database?.close();
          } catch (_) {
            cleanupSucceeded = false;
          }
          if (cleanupSucceeded) _leasedStorageHashes.remove(hash);
          Error.throwWithStackTrace(error, stackTrace);
        }
      });

  Future<void> _release({
    required String hash,
    required Database database,
    required Box<dynamic> box,
    required Box<dynamic> settingsBox,
  }) =>
      _lock.synchronized(() async {
        if (!_leasedStorageHashes.contains(hash)) return;
        await box.close();
        await settingsBox.close();
        await database.close();
        _leasedStorageHashes.remove(hash);
      });

  static Future<void> _verifyDatabaseFingerprint(
    Database database, {
    required String storageKeyHash,
    required String accountScopeKey,
  }) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS account_storage_metadata (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
    final rows = await database.query(
      'account_storage_metadata',
      where: 'key IN (?, ?)',
      whereArgs: const ['storage_key_hash', 'account_scope_key'],
    );
    final metadata = <String, Object?>{
      for (final row in rows) row['key'] as String: row['value'],
    };
    if ((metadata['storage_key_hash'] != null &&
            metadata['storage_key_hash'] != storageKeyHash) ||
        (metadata['account_scope_key'] != null &&
            metadata['account_scope_key'] != accountScopeKey)) {
      throw AccountStorageFingerprintMismatch();
    }
    final batch = database.batch();
    batch.insert(
      'account_storage_metadata',
      {'key': 'storage_key_hash', 'value': storageKeyHash},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    batch.insert(
      'account_storage_metadata',
      {'key': 'account_scope_key', 'value': accountScopeKey},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    await batch.commit(noResult: true);
  }

  static Future<void> _verifyHiveFingerprint(
    Box<dynamic> box, {
    required String storageKeyHash,
    required String accountScopeKey,
  }) async {
    final storedHash = box.get('_storage_key_hash');
    final storedScope = box.get('_account_scope_key');
    if ((storedHash != null && storedHash != storageKeyHash) ||
        (storedScope != null && storedScope != accountScopeKey)) {
      throw AccountStorageFingerprintMismatch();
    }
    await box.putAll({
      '_storage_key_hash': storageKeyHash,
      '_account_scope_key': accountScopeKey,
    });
  }

  /// Deletes one account-owned setting without clearing unrelated preferences.
  /// The active runtime may already hold this box open during logout.
  static Future<void> deleteSettingForScope({
    required AccountScope scope,
    required String key,
  }) async {
    final boxName = _settingsBoxName(scope.storageKeyHash);
    final alreadyOpen = Hive.isBoxOpen(boxName);
    if (!alreadyOpen &&
        !await Hive.boxExists(boxName, path: HiveStorage.storageDirectory))
      return;
    final box = alreadyOpen
        ? Hive.box<dynamic>(boxName)
        : await Hive.openBox<dynamic>(boxName,
            path: HiveStorage.storageDirectory);
    try {
      await _verifyHiveFingerprint(
        box,
        storageKeyHash: scope.storageKeyHash,
        accountScopeKey: scope.scopeKey,
      );
      await box.delete(key);
    } finally {
      if (!alreadyOpen) await box.close();
    }
  }

  static String _settingsBoxName(String hash) =>
      HiveStorage.boxName('account_settings_v2_$hash');
}
