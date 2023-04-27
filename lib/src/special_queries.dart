import 'package:flutter/material.dart';

import 'typedefs.dart';
import 'view/dialogs/creation_dialog.dart';
import 'view/pages/special_queries_page.dart';

typedef JsonPresenter = Widget Function(JsonMap json);

abstract class SpecialQuery {
  final String path;
  final String? parameterName;
  final String queryName;
  final QueryType queryType;
  final InputBuilder? inputBuilder;
  final InputConverter? inputConverter;

  const SpecialQuery(
    this.path,
    this.queryName,
    this.queryType, {
    this.parameterName,
    this.inputBuilder,
    this.inputConverter,
  });

  Uri makeUri(Map<String, String> queryParams);

  Widget makePresentationWidget(BuildContext context, dynamic json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialQuery && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;
}

enum QueryType {
  static,
  withParam;
}

class CustomersWithMinPurchasesCount extends SpecialQuery {
  const CustomersWithMinPurchasesCount() : super('api/clients/?');

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    // TODO: implement makePresentationWidget
    throw UnimplementedError();
  }

  @override
  Uri makeUri(Map<String, String> queryParams) {
    // TODO: implement makeUri
    throw UnimplementedError();
  }
}
