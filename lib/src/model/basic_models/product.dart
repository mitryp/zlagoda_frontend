import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/navigation.dart';
import '../interfaces/convertible_to_row.dart';
import '../model_reference.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';
import 'category.dart';
import '../interfaces/model.dart';

class Product extends Model with ConvertibleToRow<Product> {
  static final Schema<Product> schema = Schema(
    Product.new,
    [
      FieldDescription<String, Product>(
        'upc',
        (o) => o.upc,
        labelCaption: 'UPC',
      ),
      FieldDescription<String, Product>(
        'productName',
        (o) => o.productName,
        labelCaption: 'Назва',
      ),
      FieldDescription<String, Product>(
        'manufacturer',
        (o) => o.manufacturer,
        labelCaption: 'Виробник',
      ),
      FieldDescription<String, Product>(
        'specs',
        (o) => o.specs,
        labelCaption: 'Характеристики',
        fieldDisplayMode: FieldDisplayMode.inModelView,
      ),
      FieldDescription<int, Product>.foreignKey(
        'categoryId',
        (o) => o.categoryId,
        labelCaption: 'Категорія',
        fieldDisplayMode: FieldDisplayMode.whenEditing,
        defaultForeignKey: foreignKey<Category>('categoryId', 1),
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
  List<ForeignKey> get foreignKeys => [foreignKey<Category>('categoryId', categoryId)];

  @override
  void redirectToModelView(BuildContext context) =>
      AppNavigation.of(context).toModelView<Product>(primaryKey);
}
