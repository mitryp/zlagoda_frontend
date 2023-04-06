import '../../../services/middleware/middleware_application.dart';
import '../../../services/middleware/response/response_middleware.dart';
import 'middleware_context.dart';

/// Widget that registers the response middleware provided by the [middlewareBuilders] iterable with
/// the current context.
///
/// To use the middleware on a response, use the [applyResponseMiddleware] function.
///
/// The middleware bound to this [ResponseMiddlewareContext] will be unregistered when the widget
/// is disposed from the widget tree.
///
class ResponseMiddlewareContext extends MiddlewareContext<ResponseMiddleware> {
  static final responseMiddlewareSet = <ResponseMiddleware>{};

  const ResponseMiddlewareContext({
    required super.child,
    required super.middlewareBuilders,
    super.key,
  });

  @override
  Set<ResponseMiddleware> get staticMiddlewareSet => responseMiddlewareSet;
}
