import 'package:flutter/material.dart';

import '../../../services/middleware/http_middleware.dart';

typedef MiddlewareBuilder<T extends HttpMiddleware> = T Function(BuildContext context);

abstract class MiddlewareContext<T extends HttpMiddleware> extends StatefulWidget {
  final Iterable<MiddlewareBuilder<T>> middlewareBuilders;
  final Widget child;

  const MiddlewareContext({
    required this.child,
    required this.middlewareBuilders,
    super.key,
  });

  Set<T> get staticMiddlewareSet;

  @override
  State<MiddlewareContext<T>> createState() => MiddlewareContextState<T>();
}

class MiddlewareContextState<T extends HttpMiddleware> extends State<MiddlewareContext<T>> {
  late final Set<T> localMiddlewares;
  bool isRegistered = false;

  void register(BuildContext context) {
    localMiddlewares = widget.middlewareBuilders.map((builder) => builder(context)).toSet();
    widget
      ..staticMiddlewareSet.removeAll(localMiddlewares)
      ..staticMiddlewareSet.addAll(localMiddlewares);
    isRegistered = true;
  }

  void unregister() {
    widget.staticMiddlewareSet.removeAll(localMiddlewares);
    // todo check where the correct middleware goes
    localMiddlewares.clear();
    isRegistered = false;
  }

  @override
  void initState() {
    super.initState();
    register(context);
  }

  @override
  void dispose() {
    unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
