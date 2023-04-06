import 'package:http/http.dart' show Request;

import '../http_middleware.dart';

abstract class RequestMiddleware extends HttpMiddleware<Request> {
  const RequestMiddleware(super.context);
}