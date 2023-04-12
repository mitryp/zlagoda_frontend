import 'package:flutter/material.dart';

import '../model_scheme_factory.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';
import 'serializable.dart';

mixin ConvertibleToRow<R extends ConvertibleToRow<R>> on Serializable {
  /// The row should redirect to the individual model page in onSelectedChanged.
  ///
  DataRow buildRow(BuildContext context) => rowFrom<R>(this as R, context: context);

  /// This method is used in the [rowFrom] function to automatically redirect navigator to the
  /// ModelView bound to this convertible object.
  ///
  void redirectToModelView(BuildContext context);
}

/// Returns the values of the fields of the [convertible] which are displayed in the DataRow in the order
/// of their [Retriever]s in the [Schema].
///
Iterable<dynamic> rowValues<R extends ConvertibleToRow<R>>(R convertible) {
  final schema = makeModelSchema<R>();

  return schema.retrievers.where((r) => r.isShownInTable).map((r) => r.fieldGetter(convertible));
}

List<DataCell> cellsFromValues<R extends ConvertibleToRow<R>>(BuildContext context, R convertible) {
  final values = rowValues<R>(convertible);

  return values.map((v) => DataCell(Text('$v'))).toList();
}

DataRow rowFrom<R extends ConvertibleToRow<R>>(R convertible, {required BuildContext context}) {
  return DataRow(
    cells: cellsFromValues(context, convertible),
    onSelectChanged: (_) => convertible.redirectToModelView(context),
  );
}
