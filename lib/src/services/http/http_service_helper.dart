import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/interfaces/serializable.dart';
import '../../typedefs.dart';
import '../../utils/exceptions.dart';
import '../middleware/middleware_application.dart';
import '../middleware/response/response_middleware.dart';

typedef JsonCastFunction<S extends Serializable> = S? Function(JsonMap json);
typedef ControllerSuccessfulLogic<T> = T Function(http.Response response);

enum HttpMethod {
  get,
  post,
  put,
  delete;
}

Future<T> httpServiceController<T>(
    http.Response response,
    ControllerSuccessfulLogic<T> successLogic,
    ) async {
  final res = await applyResponseMiddleware(response);

  if (successCodes(res)) {
    return successLogic(res);
  }

  throw ResourceNotFetchedException(res.reasonPhrase);
}


Future<http.Response> makeRequest(HttpMethod method, Uri path, {Object? body}) async {
  final req = http.Request(method.name, path)..body = body != null ? jsonEncode(body) : '';

  return http.Client().send(await applyRequestMiddleware(req)).then(http.Response.fromStream);
}