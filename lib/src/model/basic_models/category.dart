import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/navigation.dart';
import '../../utils/value_status.dart';
import '../interfaces/convertible_to_pdf.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';
import '../schema/validators.dart';
import '../search_models/short_category.dart';

class Category extends Model with ConvertibleToRow<Category>, ConvertibleToPdf<Category> {
  static final Schema<Category> schema = Schema(
    Category.new,
    [
      FieldDescription<int?, Category>(
        'categoryId',
        (o) => o.categoryId,
        labelCaption: 'ID категорії',
        fieldType: FieldType.number,
        isEditable: false,
        fieldDisplayMode: FieldDisplayMode.none,
      ),
      FieldDescription<String, Category>(
        'categoryName',
        (o) => o.categoryName,
        labelCaption: 'Категорія',
        validator: notEmpty,
      ),
    ],
  );

  final int? categoryId;
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
  String toString() => categoryName;

  @override
  Future<ValueStatusWrapper> redirectToModelView(BuildContext context) =>
      AppNavigation.of(context).openModelViewFor<Category>(this);

  @override
  ShortCategory toSearchModel() =>
      ShortCategory(primaryKey: categoryId!, descriptiveAttr: categoryName);
}
