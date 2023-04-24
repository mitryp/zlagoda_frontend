import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Response;

import '../../../view/widgets/middleware_context/response_middleware_context.dart';
import 'response_middleware.dart';

typedef SnackBarBuilder = SnackBar Function(Response res);

const codesToMessages = {
  200: 'Запит успішно виконано',
  201: 'Успішно створено',
  400: 'Некоректний запит',
  401: 'Некоректні дані авторизації',
  403: 'Вам бракує дозволів, щоб виконати цю дію',
  404: 'Ресурс не було знайдено',
  409: 'Неможливо виконати дію',
  500: 'Ваш запит вбив сервер',
  503: 'Сервер наразі недоступний, ми працюємо над цим',
  504: 'Сервер не зміг виконати запит вчасно',
};

SnackBar _defaultSnackBar(Response res) {
  String? message;
  try {
    message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
  } catch (e) {
    message = 'Сервер не надав додаткової інформації';
  }

  final color = successCodes(res) ? Colors.green[300] : Colors.red[100];
  final title = codesToMessages[res.statusCode] ?? 'Невідомий код відповіді';
  final subtitle = message != null ? Text(message) : null;

  return SnackBar(
    content: ListTile(
      title: Text(title),
      subtitle: subtitle,
    ),
    backgroundColor: color,
  );
}

/// A middleware for displaying an informational snackbar about the processed response.
///
/// The [snackBarBuilder] is a function of [Response] that returns a [SnackBar] about the processed
/// response.
///
/// To use this middleware, the [ResponseMiddlewareContext] which registers it must have a
/// [Scaffold] among its parent widgets as it uses [ScaffoldMessenger] to display the snackbar.
///
class ResponseDisplayMiddleware extends ResponseMiddleware {
  final SnackBarBuilder snackBarBuilder;

  const ResponseDisplayMiddleware(
    super.context, {
    this.snackBarBuilder = _defaultSnackBar,
  }) : super(filter: allCodes);

  const ResponseDisplayMiddleware.errors(
    super.context, {
    this.snackBarBuilder = _defaultSnackBar,
  }) : super(filter: failureCodes);

  @override
  Response processFiltered(Response r) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      print('ResponseDisplayMiddleware could not find the ScaffoldMessenger '
          'of the given context');
      return r;
    }

    messenger.showSnackBar(snackBarBuilder(r));

    return r;
  }
}
