import 'dart:convert';

import 'package:http/http.dart' as http;

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

const _baseRoute = 'http://localhost:3000';
const _loginRoute = '$_baseRoute/api/login';
const _validateRoute = '$_baseRoute/api/login/validate';

class AuthService {
  const AuthService();

  Future<AuthorizedUser?> login(String username, String password) async {
    // todo remove!!! and make sure that the code works with the actual server
    if (username == testUser.login && password == '')
      return const AuthorizedUser(testUser, 'token');

    final responseJson = await _postBasicLogin(username, password)
        .catchError(logAndReturn(http.Response('', 400)))
        .then(applyResponseMiddleware)
        .then(decodeResponseBody)
        .catchError(logAndReturn(<String, dynamic>{}));

    final user = User.fromJSON(responseJson);
    final token = responseJson['token'];

    if (user == null || token == null) return null;

    return AuthorizedUser(user, token);
  }

  Future<bool> authorizeToken(String token) async {
    return http.post(
      Uri.parse(_validateRoute),
      headers: {'Authorization': 'Bearer $token'},
    ).then((res) => res.statusCode >= 200 && res.statusCode < 300);
  }

  Future<http.Response> _postBasicLogin(String username, String password) {
    return http.post(
      Uri.parse(_loginRoute),
      headers: {
        'Authorization': _basicAuthorizationHeaderValue(username, password),
      },
    );
  }
}
