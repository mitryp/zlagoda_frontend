import 'package:http/http.dart' show Request;

import '../../auth/login_manager.dart';
import 'request_middleware.dart';

/// A middleware that adds the authentication token of the current [context] to the request, if
/// present.
///
class RequestAuthMiddleware extends RequestMiddleware {
  const RequestAuthMiddleware(super.context);

  @override
  Future<Request> processFiltered(Request r) async {
    final token = await LoginManager.of(context).loginData.then((ld) => ld?.token);
    if (token == null) return r;

    r.headers['Authorization'] = 'Bearer $token';
    print('token set in headers by RequestAuthMiddleware: ${r.headers}');
    return r;
  }
}
