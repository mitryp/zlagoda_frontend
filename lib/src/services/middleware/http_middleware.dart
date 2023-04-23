import 'dart:async';

import 'package:flutter/material.dart';

typedef MiddlewareFilter<T> = bool Function(T);

abstract class HttpMiddleware<T> {
  final BuildContext context;
  final MiddlewareFilter<T> filter;

  const HttpMiddleware(this.context, {this.filter = _alwaysSatisfied});

  FutureOr<T> process(T t) {
    if (!filter(t) || !context.mounted) return t;

    return processFiltered(t);
  }

  FutureOr<T> processFiltered(T r);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HttpMiddleware<T> && filter == other.filter;

  @override
  int get hashCode => filter.hashCode;
}

bool _alwaysSatisfied(dynamic _) => true;
