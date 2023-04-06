import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

class StoreProduct extends Model with ConvertibleToRow {
  static final Schema<StoreProduct> schema = [
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

  static StoreProduct? fromJSON(JsonMap json) {
    final storeProductJson = retrieveFromJson(schema, json);

    return storeProductJson == null
        ? null
        : StoreProduct(
            upc: storeProductJson['upc'],
            typeId: storeProductJson['typeId'],
            price: storeProductJson['price'],
            quantity: storeProductJson['quantity'],
            isProm: storeProductJson['isProm'],
          );
  }

  @override
  get primaryKey => upc;

  @override
  JsonMap toJson() => convertToJson(schema, this);

  @override
  DataRow buildRow(BuildContext context) {
    // todo is prom
    final cellsText = [
      upc,
      price.toString(),
      quantity.toString(),
    ];

    return buildRowFromFields(context, cellsText);
  }
}
