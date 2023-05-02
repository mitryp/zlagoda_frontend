import 'package:flutter/material.dart';

import '../services/http/helpers/http_service_helper.dart';
import '../typedefs.dart';
import '../view/dialogs/creation_dialog.dart';

typedef JsonPresenter = Widget Function(JsonMap json);
typedef InputConverter = dynamic Function(String input);

abstract class StaticSpecialQuery {
  final String path;
  final String queryName;

  const StaticSpecialQuery(this.path, this.queryName);

  Uri makeUri(Map<String, String> queryParams) => Uri.http(baseRoute, 'api/$path', queryParams);

  Widget makePresentationWidget(BuildContext context, dynamic json, VoidCallback updateCallback);
}

abstract class SingleInputSpecialQuery extends StaticSpecialQuery {
  final String parameterName;
  final InputBuilder inputBuilder;
  final InputConverter inputConverter;

  const SingleInputSpecialQuery(
      super.path,
      super.queryName, {
        required this.parameterName,
        required this.inputBuilder,
        required this.inputConverter,
      });
}
