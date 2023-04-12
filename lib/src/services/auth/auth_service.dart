import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../../config.dart';
import '../../typedefs.dart';
import '../../utils/json_decode.dart';
import '../../utils/log_and_return.dart';
import '../../view/pages/login.dart';
import '../middleware/middleware_application.dart';
import 'user.dart';

String _basicAuthorizationHeaderValue(String username, String password) {
  final credentials = '$username:$password';
  final encodedCredentials = base64Encode(utf8.encode(credentials));

  return 'Basic $encodedCredentials';
}

typedef HttpSchema = Uri Function(String authority, [String path]);

enum AuthRouteStrategy {
  mock(schema: Uri.http, 'localhost:3000'),
  api(schema: Uri.http, '');

  final String authority;
  final HttpSchema schema;

  const AuthRouteStrategy(this.authority, {required this.schema});

  Uri get loginUri => schema(authority, path.join('api', 'login'));

  Uri get validateUri => schema(authority, path.join('api', 'login', 'validate'));
}

class AuthService {
  final AuthRouteStrategy strategy;

  const AuthService([this.strategy = authServiceStrategy]);

  Future<AuthorizedUser?> login(String username, String password) async {
    // todo remove!!! and make sure that the code works with the actual server
    if (username == testUser.login && password == '')
      return const AuthorizedUser(testUser, 'token');

    final responseJson = await _postBasicLogin(username, password)
        .catchError(logAndReturn(http.Response('', 400)))
        .then(applyResponseMiddleware)
        .then(decodeResponseBody<JsonMap?>)
        .catchError(logAndReturn(null));

    if (responseJson == null) return null;

    final user = User.fromJson(responseJson);
    final token = responseJson['token'];

    if (user == null || token == null) return null;

    return AuthorizedUser(user, token);
  }

  Future<bool> validateToken(String token) async {
    return http.post(
      strategy.validateUri,
      headers: {'Authorization': 'Bearer $token'},
    ).then((res) => res.statusCode >= 200 && res.statusCode < 300);
  }

  Future<http.Response> _postBasicLogin(String username, String password) {
    return http.post(
      strategy.loginUri,
      headers: {
        'Authorization': _basicAuthorizationHeaderValue(username, password),
      },
    );
  }
}
