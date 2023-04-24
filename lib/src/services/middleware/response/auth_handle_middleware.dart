import 'package:flutter/material.dart';
import 'package:http/http.dart' show Response;

import '../../auth/login_manager.dart';
import 'response_middleware.dart';

/// A middleware that redirects the [Navigator] of the context to the /login endpoint, if a
/// processed response has a status code of 401.
///
class AuthHandleMiddleware extends ResponseMiddleware {
  const AuthHandleMiddleware(super.context) : super(filter: unauthorized);

  @override
  Response processFiltered(Response r) {
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      if (!context.mounted) return;
      LoginManager.of(context).clearLoginData();
      Navigator.maybeOf(context)?.pushReplacementNamed('/login');
    });

    return r;
  }
}
