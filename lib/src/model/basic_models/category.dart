import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

class Category extends Model implements ConvertibleToRow {
  static final Schema<Category> schema = [
    Retriever<int, Category>(
      field: 'categoryId',
      getter: (category) => category.categoryId,
    ),
    Retriever<String, Category>(
      field: 'categoryName',
      getter: (category) => category.categoryName,
    ),
  ];

  final int categoryId;
  final String categoryName;

  const Category({
    required this.categoryId,
    required this.categoryName,
  });

  static Category? fromJson(JsonMap json) {
    final categoryJson = retrieveFromJson(schema, json);

    return categoryJson == null
        ? null
        : Category(
            categoryId: categoryJson['categoryId'],
            categoryName: categoryJson['categoryName'],
          );
  }

  @override
  get primaryKey => categoryId;

  @override
  JsonMap toJson() => convertToJson(schema, this);

  @override
  DataRow buildRow(BuildContext context) {
    final cellsText = [categoryName];

    return buildRowFromFields(context, cellsText);
  }
}
