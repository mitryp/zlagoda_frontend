import '../joined_models/joined_store_product.dart';
import '../joined_models/product_with_category.dart';
import 'serializable.dart';

import '../model_schema_factory.dart';

/// Returns the values of the fields of the [convertible] which are displayed in the DataRow in the order
/// of their [FieldDescription]s in the [Schema].
///
Iterable<dynamic> rowValues<R extends Serializable>(R convertible) {
  final schema = makeModelSchema<R>();

  return schema.fields.where((r) => r.isShownInTable).map((r) => r.fieldGetter(convertible));
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
List<String> columnNamesOf<R extends Serializable>() {
  final overriddenColumnNames = _columnNamesOverride[R];
  if (overriddenColumnNames != null) return overriddenColumnNames;

  final schema = makeModelSchema<R>();
  return schema.fields.where((r) => r.isShownInTable).map((r) => r.labelCaption).toList();
}