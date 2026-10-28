import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:im_sdk/core/network/error_handler.dart';
import 'package:im_sdk/features/auth/data/datasources/auth_remote_datasource.dart';

class _ProfileAdapter implements HttpClientAdapter {
  _ProfileAdapter(this.profile, {this.status = 200});
  final Map<String, dynamic> profile;
  final int status;

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    expect(options.path, '/api/client/v1/profile/me');
    expect(options.headers['Authorization'], startsWith('Bearer '));
    return ResponseBody.fromString(
        jsonEncode({
          'code': status == 200 ? 'OK' : 'AUTH_INVALID_TOKEN',
          'data': profile,
        }),
        status,
        headers: {
          Headers.contentTypeHeader: ['application/json']
        });
  }

  @override
  void close({bool force = false}) {}
}

// Fixtures model a profile server accepting/rejecting the bearer. This test
// does not claim to implement or bypass the server's JWT signature validation.
String _acceptedToken(Map<String, Object?> claims) =>
    'header.${base64Url.encode(utf8.encode(jsonEncode(claims))).replaceAll('=', '')}.server-signature';

void main() {
  const userClaim =
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier';

  AuthRemoteDataSourceImpl source(Map<String, dynamic> profile,
      {int status = 200}) {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.invalid'));
    dio.httpClientAdapter = _ProfileAdapter(profile, status: status);
    return AuthRemoteDataSourceImpl(dio);
  }

  test('server-accepted token fills the omitted platform ID with user binding',
      () async {
    final identity = await source({'userId': 'user-a', 'userType': 1})
        .getTenantIdentity(_acceptedToken(
            {userClaim: 'user-a', 'platform_user_id': 'platform-a'}));
    expect(identity.userId, 'user-a');
    expect(identity.platformUserId, 'platform-a');
  });

  test('a token claim for another profile user is rejected', () async {
    await expectLater(
        source({'userId': 'user-a'}).getTenantIdentity(_acceptedToken(
            {userClaim: 'user-b', 'platform_user_id': 'platform-a'})),
        throwsA(isA<ServerError>()));
  });

  test('missing platform claim fails closed', () async {
    await expectLater(
        source({'userId': 'user-a'})
            .getTenantIdentity(_acceptedToken({userClaim: 'user-a'})),
        throwsA(isA<ServerError>()));
  });

  test('malformed opaque token cannot fill an omitted platform ID', () async {
    await expectLater(
        source({'userId': 'user-a'}).getTenantIdentity('opaque-token'),
        throwsA(isA<ServerError>()));
  });

  test('server-rejected token never provides an identity from claims',
      () async {
    await expectLater(
        source({'userId': 'user-a'}, status: 401).getTenantIdentity(
            _acceptedToken(
                {userClaim: 'user-a', 'platform_user_id': 'platform-a'})),
        throwsA(isA<AuthError>()));
  });

  test('explicit authoritative profile identity supports opaque tokens',
      () async {
    final identity = await source(
            {'userId': 'user-a', 'platformUserId': 'platform-a', 'userType': 1})
        .getTenantIdentity('opaque-token');
    expect(identity.platformUserId, 'platform-a');
  });
}
