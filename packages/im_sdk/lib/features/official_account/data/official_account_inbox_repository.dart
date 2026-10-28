import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:im_sdk/core/diagnostics/app_diagnostics.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/core/storage/account_storage_context.dart';
import 'package:im_sdk/features/official_account/data/official_account_card_mapper.dart';
import 'package:im_sdk/features/official_account/domain/entities/official_account_card.dart';

/// Uses the existing personal account store; no tenant conversation/message
/// rows or read cursors are written by this platform projection.
class OfficialAccountInboxRepository {
  OfficialAccountInboxRepository(this._dio, this._storage);

  static const cacheKey = 'official_account_inbox_v1';
  final Dio _dio;
  final AccountStorageContext _storage;

  List<OfficialAccountConversationSummary>? loadCached() {
    final raw = _storage.accountBox.get(cacheKey);
    if (raw == null) return null;
    try {
      return _parseItems(jsonDecode(raw as String));
    } catch (error) {
      _diagnose('cache_invalid', error);
      return null;
    }
  }

  Future<List<OfficialAccountConversationSummary>> fetch(String token) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/platform/v1/my/official-accounts',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return _parseItems((response.data?['data'] as Map)['items']);
    } on DioException catch (error) {
      throw ErrorHandler.fromDioException(error);
    } catch (error) {
      _diagnose('response_invalid', error);
      rethrow;
    }
  }

  Future<void> save(List<OfficialAccountConversationSummary> items) {
    return _storage.writeGate.run(_storage.operationContext, () async {
      await _storage.accountBox.put(
        cacheKey,
        jsonEncode(items.map(officialAccountSummaryToJson).toList()),
      );
    });
  }

  List<OfficialAccountConversationSummary> _parseItems(Object? raw) {
    if (raw is! List) {
      throw const FormatException('Missing official inbox items');
    }
    final items = <OfficialAccountConversationSummary>[];
    final keys = <String>{};
    for (final value in raw) {
      if (value is! Map) {
        throw const FormatException('Invalid official inbox item');
      }
      final item =
          officialAccountSummaryFromJson(Map<String, dynamic>.from(value));
      if (!keys.add(item.key)) {
        throw const FormatException('Duplicate official inbox conversation');
      }
      items.add(item);
    }
    return List.unmodifiable(items);
  }

  void _diagnose(String phase, Object error) {
    AppDiagnostics.instance.warning(
      'official_account.inbox.$phase',
      'Official account inbox snapshot could not be read',
      context: {'errorType': error.runtimeType.toString()},
    );
  }
}
