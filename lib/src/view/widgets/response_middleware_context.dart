import 'package:flutter/material.dart';

import '../../services/response_middleware/middleware_application.dart';
import '../../services/response_middleware/response_middleware.dart';

typedef MiddlewareBuilder = ResponseMiddleware Function(BuildContext context);

/// Widget that registers the response middleware provided by the [middlewareBuilders] iterable with
/// the current context.
///
/// To use the middleware on a response, use the [applyCurrentlyRegisteredMiddleware] function.
///
/// The middleware bound to this [ResponseMiddlewareContext] will be unregistered when the widget
/// is disposed from the widget tree.
///
class ResponseMiddlewareContext extends StatefulWidget {
  static Set<ResponseMiddleware> middlewareSet = {};

  final Widget child;
  final Iterable<MiddlewareBuilder> middlewareBuilders;

  const ResponseMiddlewareContext({
    required this.child,
    required this.middlewareBuilders,
    super.key,
  });

  @override
  State<ResponseMiddlewareContext> createState() => _ResponseMiddlewareContextState();
}

class _ResponseMiddlewareContextState extends State<ResponseMiddlewareContext> {
  late final Set<ResponseMiddleware> localMiddlewares;
  bool isRegistered = false;

  void register(BuildContext context) {
    localMiddlewares = widget.middlewareBuilders.map((mwBuilder) => mwBuilder(context)).toSet();
    ResponseMiddlewareContext.middlewareSet.addAll(localMiddlewares);
    isRegistered = true;
  }

  @override
  void dispose() {
    ResponseMiddlewareContext.middlewareSet.removeAll(localMiddlewares);
    localMiddlewares.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isRegistered) register(context);

    return widget.child;
  }
}
