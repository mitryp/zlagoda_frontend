import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Response;

import '../../view/widgets/response_middleware_context.dart';
import 'response_middleware.dart';

typedef SnackBarBuilder = SnackBar Function(Response res);

const codesToMessages = {
  200: 'Запит успішно виконано',
  201: 'Успішно створено',
  400: 'Некоректний запит',
  401: 'Дані авторизації некоректні, потрібно увійти ще раз',
  403: 'Ви не можете виконати цю дію - бракує дозволів',
  404: 'Ресурс не було знайдено',
  500: 'Ваш запит вбив сервер',
  503: 'Сервер наразі недоступний, ми працюємо над цим',
  504: 'Сервер не зміг виконати запит вчасно',
};

SnackBar _defaultSnackBar(Response res) {
  final code = res.statusCode;

  String? message;
  try {
    message = jsonDecode(utf8.decode(res.bodyBytes))['message'];
  } on Exception {
    message = null;
  }

  final color = successCodes(code) ? Colors.green[300] : Colors.red[100];
  final title = codesToMessages[code] ?? 'Невідомий код відповіді';
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
  });

  @override
  Response processFilteredResponse(Response res) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      print('ResponseDisplayMiddleware could not find the ScaffoldMessenger '
          'of the given context');
      return res;
    }

    messenger.showSnackBar(snackBarBuilder(res));

    return res;
  }
}
