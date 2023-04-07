import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

class Category extends Model implements ConvertibleToRow {
  static final Schema<Category> schema = Schema(
    Category.new,
    [
      Retriever<int, Category>('categoryId', (o) => o.categoryId),
      Retriever<String, Category>('categoryName', (o) => o.categoryName),
    ],
  );

  final int categoryId;
  final String categoryName;

  const Category({
    required this.categoryId,
    required this.categoryName,
  });

  static Category? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  get primaryKey => categoryId;

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  DataRow buildRow(BuildContext context) {
    final cellsText = [categoryName];

    return buildRowFromFields(context, cellsText);
  }
}
