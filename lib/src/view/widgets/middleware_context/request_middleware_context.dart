import '../../../services/middleware/middleware_application.dart';
import '../../../services/middleware/request/request_middleware.dart';
import 'middleware_context.dart';

/// Widget that registers the request middleware provided by the [middlewareBuilders] iterable with
/// the current context.
///
/// To use the middleware on a request, use the [applyRequestMiddleware] function.
///
/// The middleware bound to this [RequestMiddlewareContext] will be unregistered when the widget
/// is disposed from the widget tree.
///
class RequestMiddlewareContext extends MiddlewareContext<RequestMiddleware> {
  static final requestMiddlewareSet = <RequestMiddleware>{};

  const RequestMiddlewareContext({
    required super.child,
    required super.middlewareBuilders,
    super.key,
  });

  @override
  Set<RequestMiddleware> get staticMiddlewareSet => requestMiddlewareSet;
}
