import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../model_reference.dart';
import '../other_models/search_product.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';
import 'category.dart';


class Product extends SearchProduct with ConvertibleToRow {
  static final Schema<Product> schema = Schema(
    Product.new,
    [
      Retriever<String, Product>('upc', (o) => o.upc, labelCaption: 'UPC'),
      Retriever<String, Product>('productName', (o) => o.productName, labelCaption: 'Назва'),
      Retriever<String, Product>('manufacturer', (o) => o.manufacturer, labelCaption: 'Виробник'),
      Retriever<String, Product>('specs', (o) => o.specs, labelCaption: 'Характеристики'),
      Retriever<int, Product>('categoryId', (o) => o.categoryId),
    ],
  );

  final String manufacturer;
  final String specs;
  final int categoryId;

  const Product({
    required super.upc,
    required super.productName,
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
  DataRow buildRow(BuildContext context) {
    // TODO: implement buildRow
    return DataRow(cells: [
      DataCell(Text(productName)),
      DataCell(Text(manufacturer)),
      DataCell(Text(specs)),
    ]);
  }

  @override
  List<ModelTableGenerator<Model>> get connectedTables => [
        connectedTable<Category>(categoryId),
      ];
}
