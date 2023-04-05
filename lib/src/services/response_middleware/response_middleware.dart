import 'package:flutter/material.dart';

import 'package:http/http.dart' show Response;

import '../../view/widgets/response_middleware_context.dart';

typedef StatusCodeFilter = bool Function(int statusCode);

/// True for all status codes.
bool allCodes(int _) => true;

/// True for codes in range [200, 299].
bool successCodes(int statusCode) => statusCode >= 200 && statusCode < 300;

/// True for codes in range [400, 599].
bool failureCodes(int statusCode) => statusCode >= 400 && statusCode < 600;

/// True for 401 code.
bool unauthorized(int statusCode) => statusCode == 401;

/// A class defining the response middleware for the [Response] objects.
///
/// The BuildContext [context] is required to access the widget tree.
/// It can be provided by the [ResponseMiddlewareContext] widget inserted into the widget tree.
///
/// The [statusCodeFilter] is a function of an integer response status code that returns a boolean
/// value.
/// The middleware will be applied to the response if the response status code satisfies the filter.
/// Defaults to [allCodes] filter, i.e. every code satisfies the filter.
///
/// Ancestors must override the [processFilteredResponse] method, which will only be called on the
/// responses satisfying the [statusCodeFilter].
///
abstract class ResponseMiddleware {
  final BuildContext context;
  final StatusCodeFilter statusCodeFilter;

  const ResponseMiddleware(
    this.context, {
    this.statusCodeFilter = allCodes,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ResponseMiddleware && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.toString().hashCode;

  Response process(Response res) {
    if (!statusCodeFilter(res.statusCode)) return res;

    return processFilteredResponse(res);
  }

  Response processFilteredResponse(Response res);
}
