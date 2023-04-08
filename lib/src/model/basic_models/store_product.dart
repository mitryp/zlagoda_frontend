//import 'package:flutter/material.dart';

import '../../typedefs.dart';
//import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

//class StoreProduct extends Model with ConvertibleToRow {
class StoreProduct extends Model{
  static final Schema<StoreProduct> schema = Schema(
    StoreProduct.new,
    [
      Retriever<int, StoreProduct>('productId', (o) => o.productId),
      Retriever<String, StoreProduct>('upc', (o) => o.upc),
      Retriever<int, StoreProduct>('price', (o) => o.price),
      Retriever<int, StoreProduct>('quantity', (o) => o.quantity),
      Retriever<bool, StoreProduct>('isProm', (o) => o.isProm),
    ],
  );

  final int productId;
  final String upc;
  final int price;
  final int quantity;
  final bool isProm;

  const StoreProduct({
    required this.productId,
    required this.upc,
    required this.price,
    required this.quantity,
    required this.isProm,
  });

  static StoreProduct? fromJSON(JsonMap json) => schema.fromJson(json);

  @override
  get primaryKey => productId;

  @override
  JsonMap toJson() => schema.toJson(this);

  // @override
  // DataRow buildRow(BuildContext context) {
  //   // todo is prom
  //   final cellsText = [
  //     productId.toString(),
  //     price.toString(),
  //     quantity.toString(),
  //   ];
  //
  //   return buildRowFromFields(context, cellsText);
  // }
}
