import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/value_status.dart';
import '../joined_models/joined_store_product.dart';
import '../joined_models/product_with_category.dart';
import '../model_schema_factory.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';
import 'serializable.dart';

mixin ConvertibleToRow<R extends ConvertibleToRow<R>> on Serializable {
  /// The row should redirect to the individual model page in onSelectedChanged.
  ///
  DataRow buildRow(BuildContext context, UpdateCallback<ValueChangeStatus> updateCallback) =>
      rowFrom<R>(this as R, context: context, updateCallback: updateCallback);

  /// This method is used in the [rowFrom] function to automatically redirect navigator to the
  /// ModelView bound to this convertible object.
  ///
  Future<ValueStatusWrapper> redirectToModelView(BuildContext context);
}

/// Allows to override the default column names for the model.
///
const _columnNamesOverride = <Type, List<String>>{
  ProductWithCategory: ['UPC', 'Назва', 'Виробник', 'Категорія'],
  JoinedStoreProduct: ['UPC', 'Назва', 'Виробник', 'Ціна', 'Кількість', 'Вартість', 'Акційність'],
};

/// Returns the column names of the [R] table.
/// If override exists in the [_columnNamesOverride] map, uses that override. Otherwise, builds the column
/// names from the [R] schema.
///
List<String> columnNamesOf<R extends ConvertibleToRow<R>>() {
  final overriddenColumnNames = _columnNamesOverride[R];
  if (overriddenColumnNames != null) return overriddenColumnNames;

  final schema = makeModelSchema<R>();
  return schema.fields.where((r) => r.isShownInTable).map((r) => r.labelCaption).toList();
}

/// Returns the values of the fields of the [convertible] which are displayed in the DataRow in the order
/// of their [FieldDescription]s in the [Schema].
///
Iterable<dynamic> rowValues<R extends ConvertibleToRow<R>>(R convertible) {
  final schema = makeModelSchema<R>();

  return schema.fields.where((r) => r.isShownInTable).map((r) => r.fieldGetter(convertible));
}

List<DataCell> cellsFromValues<R extends ConvertibleToRow<R>>(R convertible,
    {required BuildContext context}) {
  final values = rowValues<R>(convertible);

  return values.map((v) => DataCell(Text('$v'))).toList();
}

DataRow rowFrom<R extends ConvertibleToRow<R>>(
  R convertible, {
  required BuildContext context,
  required UpdateCallback<ValueChangeStatus> updateCallback,
}) {
  return DataRow(
    cells: cellsFromValues(convertible, context: context),
    onSelectChanged: (_) async =>
        updateCallback(await convertible.redirectToModelView(context).then((v) => v.status)),
  );
}
