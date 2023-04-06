import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

final Schema<StoreProduct> schema = [
  Retriever<String, StoreProduct>(
    field: 'upc',
    getter: (storeProduct) => storeProduct.upc,
  ),
  Retriever<int, StoreProduct>(
    field: 'typeId',
    getter: (storeProduct) => storeProduct.typeId,
  ),
  Retriever<int, StoreProduct>(
    field: 'price',
    getter: (storeProduct) => storeProduct.price,
  ),
  Retriever<int, StoreProduct>(
    field: 'quantity',
    getter: (storeProduct) => storeProduct.quantity,
  ),
  Retriever<bool, StoreProduct>(
    field: 'isProm',
    getter: (storeProduct) => storeProduct.isProm,
  ),
];

class StoreProduct extends Model with ConvertibleToRow {
  final String upc;
  final int typeId;
  final int price;
  final int quantity;
  final bool isProm;

  const StoreProduct({
    required this.upc,
    required this.typeId,
    required this.price,
    required this.quantity,
    required this.isProm,
  });

  factory StoreProduct.fromJSON(dynamic json) {
    final values = Model.flatValues(schema, json);

    return StoreProduct(
      upc: values['upc'],
      typeId: values['typeId'],
      price: values['price'],
      quantity: values['quantity'],
      isProm: values['isProm'],
    );
  }

  @override
  get primaryKey => upc;

  @override
  JsonMap toJson() => convertToJson(schema, this);

  @override
  DataRow buildRow(BuildContext context) {
    // todo how to show that the goods is prom?
    final cellsText = [
      upc,
      price.toString(),
      quantity.toString(),
    ];

    return buildRowFromFields(context, cellsText);
  }
}
