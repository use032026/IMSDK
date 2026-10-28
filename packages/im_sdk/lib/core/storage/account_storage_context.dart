import 'dart:io';

import 'package:hive/hive.dart';
import 'package:im_sdk/core/runtime/account_operation_guard.dart';
import 'package:im_sdk/core/runtime/account_write_gate.dart';
import 'package:im_sdk/core/space/account_scope.dart';
import 'package:sqflite/sqflite.dart';

class AccountStorageContext {
  AccountStorageContext({
    required this.scope,
    required this.database,
    required this.accountBox,
    required this.settingsBox,
    required this.mediaRoot,
    required this.operationContext,
    required this.writeGate,
    required Future<void> Function() release,
  }) : _release = release;

  final AccountScope scope;
  final Database database;
  final Box<dynamic> accountBox;
  final Box<dynamic> settingsBox;
  final Directory mediaRoot;
  final AccountOperationContext operationContext;
  final AccountWriteGate writeGate;
  final Future<void> Function() _release;
  var _released = false;

  String get storageKeyHash => scope.storageKeyHash;

  Future<void> release() async {
    if (_released) return;
    await _release();
    _released = true;
  }
}

class AccountStorageBusy implements Exception {}

class AccountStorageFingerprintMismatch implements Exception {}
