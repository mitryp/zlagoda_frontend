import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/navigation.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';

class Category extends Model with ConvertibleToRow<Category> {
  static final Schema<Category> schema = Schema(
    Category.new,
    [
      FieldDescription<int, Category>(
        'categoryId',
        (o) => o.categoryId,
        labelCaption: 'ID категорії',
        isEditable: false,
        fieldType: FieldType.auto,
        fieldDisplayMode: FieldDisplayMode.none,
      ),
      FieldDescription<String, Category>(
        'categoryName',
        (o) => o.categoryName,
        labelCaption: 'Категорія',
      ),
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
  String toString() => 'Категорія "$categoryName"';

  @override
  void redirectToModelView(BuildContext context) =>
      AppNavigation.of(context).toModelView<Category>(primaryKey);
}
