import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/navigation.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../model_reference.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';
import '../schema/validators.dart';
import '../search_models/short_category.dart';
import 'category.dart';

class Product extends Model with ConvertibleToRow<Product> {
  static final Schema<Product> schema = Schema(
    Product.new,
    [
      FieldDescription<String, Product>(
        'upc',
        (o) => o.upc,
        labelCaption: 'UPC',
        validator: hasLength(12),
      ),
      FieldDescription<String, Product>(
        'productName',
        (o) => o.productName,
        labelCaption: 'Назва',
        validator: notEmpty,
      ),
      FieldDescription<String, Product>(
        'manufacturer',
        (o) => o.manufacturer,
        labelCaption: 'Виробник',
        validator: notEmpty,
      ),
      FieldDescription<String, Product>(
        'specs',
        (o) => o.specs,
        labelCaption: 'Характеристики',
        fieldDisplayMode: FieldDisplayMode.inModelView,
        validator: notEmpty,
      ),
      FieldDescription<int, Product>.intForeignKey(
        'categoryId',
        (o) => o.categoryId,
        labelCaption: 'Категорія',
        fieldDisplayMode: FieldDisplayMode.none,
        defaultForeignKey: foreignKey<Category, ShortCategory>('categoryId'),
      ),
    ],
  );

  final String upc;
  final String productName;
  final String manufacturer;
  final String specs;
  final int categoryId;

  const Product({
    required this.upc,
    required this.productName,
    required this.manufacturer,
    required this.specs,
    required this.categoryId,
  });

  static Product? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  get primaryKey => upc;

  @override
  List<ForeignKey> get foreignKeys =>
      [foreignKey<Category, ShortCategory>('categoryId', categoryId)];

  @override
  void redirectToModelView(BuildContext context) =>
      AppNavigation.of(context).toModelView<Product>(primaryKey);
}
