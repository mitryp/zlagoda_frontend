import 'dart:async';

import 'package:http/http.dart' show Response, Request;

import '../../view/widgets/middleware_context/request_middleware_context.dart';
import '../../view/widgets/middleware_context/response_middleware_context.dart';
import 'http_middleware.dart';

/// Applies the currently registered middlewares to the response [response].
/// The middlewares can be registered with [ResponseMiddlewareContext] widgets in the widget tree.
///
/// Each of the registered middlewares will be applied to the request. The middlewares can modify
/// the response, while the type of the response must remain the same.
///
FutureOr<Response> applyResponseMiddleware(Response response) =>
    _applyMiddlewaresOn(response, from: ResponseMiddlewareContext.responseMiddlewareSet);

void clearResponseMiddlewares() {
  ResponseMiddlewareContext.responseMiddlewareSet.clear();
}

FutureOr<Request> applyRequestMiddleware(Request request) =>
    _applyMiddlewaresOn(request, from: RequestMiddlewareContext.requestMiddlewareSet);

void clearRequestMiddlewares() => RequestMiddlewareContext.requestMiddlewareSet.clear();

FutureOr<R> _applyMiddlewaresOn<R>(R r, {required Iterable<HttpMiddleware<R>> from}) async {
  final middlewares = from;

  var processed = r;
  for (final mw in middlewares) {
    processed = await mw.process(processed);
  }

  return processed;
}
