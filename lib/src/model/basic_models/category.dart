import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

final Schema<Category> schema = [
  Retriever<int, Category>(
    field: 'categoryId',
    getter: (category) => category.categoryId,
  ),
  Retriever<String, Category>(
    field: 'categoryName',
    getter: (category) => category.categoryName,
  ),
];

class Category extends Model implements ConvertibleToRow {
  final int categoryId;
  final String categoryName;

  const Category({
    required this.categoryId,
    required this.categoryName,
  });

  factory Category.fromJSON(dynamic json) {
    final values = Model.flatValues(schema, json);

    return Category(
      categoryId: values['categoryId'],
      categoryName: values['categoryName'],
    );
  }

  @override
  get primaryKey => categoryId;

  @override
  JsonMap toJson() => convertToJson(schema, this);

  @override
  DataRow buildRow(BuildContext context) {
    final cellsText = [
      categoryName
    ];

    return buildRowFromFields(context, cellsText);
  }
}
