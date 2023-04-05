import 'package:http/http.dart' show Response;

import '../../view/widgets/response_middleware_context.dart';

/// Applies the currently registered middlewares to the response [res].
/// The middlewares can be registered with [ResponseMiddlewareContext] widgets in the widget tree.
///
/// Each of the registered middlewares will be applied to the request. The middlewares can modify
/// the response, while the type of the response must remain the same.
///
Response applyCurrentlyRegisteredMiddleware(Response res) {
  final middlewares = ResponseMiddlewareContext.middlewareSet;
  var processedResponse = res;
  for (final middleware in middlewares) {
    processedResponse = middleware.process(processedResponse);
  }

  return processedResponse;
}