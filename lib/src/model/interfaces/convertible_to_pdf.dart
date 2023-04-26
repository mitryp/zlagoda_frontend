import 'package:flutter/foundation.dart';

import '../basic_models/employee.dart';
import '../basic_models/product.dart';
import '../basic_models/receipt.dart';
import '../joined_models/product_with_category.dart';
import 'convertibles_helper.dart';
import 'serializable.dart';

mixin ConvertibleToPdf<R extends ConvertibleToPdf<R>> on Serializable {
  List<dynamic> get pdfRow => rowValues<R>(this as R).toList();
}

final _columnNamesOverride = <Type, List<String>>{
  Receipt: Receipt.schema.fields.map((field) => field.labelCaption).toList(),
  ProductWithCategory: [
    ...Product.schema.fields
        .sublist(0, Product.schema.fields.length - 1)
        .map((field) => field.labelCaption),
    'Категорія'
  ],
  Employee: Employee.schema.fields
        .sublist(0, Employee.schema.fields.length - 2)
        .map((field) => field.labelCaption).toList(),
};

List<String> pdfColumns<R extends ConvertibleToPdf<R>>() {
  final overriddenColumnNames = _columnNamesOverride[R];
  if (overriddenColumnNames != null) return overriddenColumnNames;

  return columnNamesOf<R>().toList();
}
