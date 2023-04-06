import 'dart:async';

import 'package:flutter/material.dart';

typedef MiddlewareFilter<T> = bool Function(T);

abstract class HttpMiddleware<T> {
  final BuildContext context;
  final MiddlewareFilter<T> filter;

  const HttpMiddleware(this.context, {this.filter = _alwaysSatisfied});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HttpMiddleware && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.toString().hashCode;

  FutureOr<T> process(T t) {
    if (!filter(t)) return t;

    return processFiltered(t);
  }

  FutureOr<T> processFiltered(T r);
}

bool _alwaysSatisfied(dynamic _) => true;