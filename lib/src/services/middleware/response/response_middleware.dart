import 'package:flutter/material.dart';

import 'package:http/http.dart' show Response;

import '../../../view/widgets/middleware_context/response_middleware_context.dart';
import '../http_middleware.dart';

typedef StatusCodeFilter = bool Function(Response res);

/// True for all status codes.
bool allCodes(Response _) => true;

/// True for codes in range [200, 299].
bool hasSuccessCode(Response res) => res.statusCode >= 200 && res.statusCode < 300 || res.statusCode == 304;

/// True for codes in range [400, 599].
bool failureCodes(Response res) => res.statusCode >= 400 && res.statusCode < 600;

/// True for 401 code.
bool unauthorized(Response res) => res.statusCode == 401;

/// A class defining the response middleware for the [Response] objects.
///
/// The BuildContext [context] is required to access the widget tree.
/// It can be provided by the [ResponseMiddlewareContext] widget inserted into the widget tree.
///
/// The [filter] is a function of an integer response status code that returns a boolean
/// value.
/// The middleware will be applied to the response if the response status code satisfies the filter.
/// Defaults to [allCodes] filter, i.e. every code satisfies the filter.
///
/// Ancestors must override the [processFiltered] method, which will only be called on the
/// responses satisfying the [filter].
///
abstract class ResponseMiddleware extends HttpMiddleware<Response> {
  const ResponseMiddleware(
    super.context, {
    super.filter = allCodes,
  });
}
