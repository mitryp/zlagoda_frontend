import 'package:flutter/material.dart';
import 'package:http/http.dart' show Response;

import 'response_middleware.dart';

/// A middleware that redirects the [Navigator] of the context to the /login endpoint, if a
/// processed response has a status code of 401.
///
class LoginRedirectMiddleware extends ResponseMiddleware {
  const LoginRedirectMiddleware(super.context) : super(statusCodeFilter: unauthorized);

  @override
  Response processFilteredResponse(Response res) {
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      Navigator.maybeOf(context)?.pushReplacementNamed('/login');
    });

    return res;
  }
}
