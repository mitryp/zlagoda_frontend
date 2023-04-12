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

class MiddlewareContextState<T extends HttpMiddleware> extends State<MiddlewareContext<T>> with AutomaticKeepAliveClientMixin {
  late final Set<T> localMiddlewares;
  bool isRegistered = false;

  @override
  bool get wantKeepAlive => isRegistered;

  void register(BuildContext context) {
    localMiddlewares = widget.middlewareBuilders.map((builder) => builder(context)).toSet();
    widget.staticMiddlewareSet.addAll(localMiddlewares);
    isRegistered = true;
  }

  void unregister() {
    widget.staticMiddlewareSet.removeAll(localMiddlewares);
    localMiddlewares.clear();
    isRegistered = false;
  }

  @override
  void dispose() {
    unregister();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    register(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
