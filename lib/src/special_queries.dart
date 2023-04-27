import 'package:flutter/material.dart';

import 'typedefs.dart';
import 'view/dialogs/creation_dialog.dart';
import 'view/pages/special_queries_page.dart';

typedef JsonPresenter = Widget Function(JsonMap json);

abstract class SpecialQuery {
  final String path;
  final String? parameterName;
  final String queryName;
  final InputBuilder? inputBuilder;
  final InputConverter? inputConverter;

  const SpecialQuery(
    this.path,
    this.queryName, {
    this.parameterName,
    this.inputBuilder,
    this.inputConverter,
  });

  bool get isStaticQuery => parameterName == null;

  Uri makeUri(Map<String, String> queryParams);

  Widget makePresentationWidget(BuildContext context, dynamic json);
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
