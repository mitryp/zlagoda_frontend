import 'package:flutter/material.dart';

import 'typedefs.dart';

typedef JsonPresenter = Widget Function(JsonMap json);

abstract class SpecialQuery {
  final String path;
  final String? parameterName;

  const SpecialQuery(this.path, [this.parameterName]);

  Uri makeUri(Map<String, String> queryParams);

  Widget makePresentationWidget(BuildContext context, JsonMap json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SpecialQuery && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;
}

class CustomersWithMinPurchasesCount extends SpecialQuery {
  const CustomersWithMinPurchasesCount() : super('api/clients/?');

  @override
  Widget makePresentationWidget(BuildContext context, JsonMap json) {
    // TODO: implement makePresentationWidget
    throw UnimplementedError();
  }

  @override
  Uri makeUri(Map<String, String> queryParams) {
    // TODO: implement makeUri
    throw UnimplementedError();
  }
  
  
}