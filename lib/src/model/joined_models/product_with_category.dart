import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/navigation.dart';
import '../../utils/value_status.dart';
import '../../view/widgets/resources/models/model_table.dart';
import '../basic_models/category.dart';
import '../basic_models/product.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/serializable.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

abstract class _ProductWithCategory implements Serializable {
  const _ProductWithCategory();
}

class ProductWithCategory extends _ProductWithCategory with ConvertibleToRow<ProductWithCategory> {
  static final Schema<ProductWithCategory> schema = Schema(ProductWithCategory.new, [
    FieldDescription<Product, ProductWithCategory>(
      'product',
      (o) => o.product,
      labelCaption: 'Товар',
    ),
    FieldDescription<Category, ProductWithCategory>(
      'category',
      (o) => o.category,
      labelCaption: 'Категорія',
    )
  ]);

  final Product product;
  final Category category;

  const ProductWithCategory(this.product, this.category);

  static ProductWithCategory? fromJson(JsonMap json) {
    final product = Product.schema.fromJson(json);
    final category = Category.schema.fromJson(json);

    if ([product, category].contains(null)) return null;

    return ProductWithCategory(product!, category!);
  }

  @override
  JsonMap toJson() => {...Product.schema.toJson(product), ...Category.schema.toJson(category)};

  @override
  Future<ValueStatusWrapper> redirectToModelView(BuildContext context) => AppNavigation.of(context)
      .openModelViewFor<Product>(product, [ModelTable<Category>(category)]);

  @override
  DataRow buildRow(BuildContext context, UpdateCallback<ValueChangeStatus> updateCallback) =>
      DataRow(
        cells: [
          ...product.buildRow(context, (_) {}).cells,
          ...category.buildRow(context, (_) {}).cells
        ],
        onSelectChanged: (_) async =>
            updateCallback(await redirectToModelView(context).then((v) => v.status)),
      );
}
