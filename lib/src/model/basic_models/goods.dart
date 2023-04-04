import 'package:flutter/material.dart';

import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';

class Goods extends Model with ConvertibleToRow {
  final int upc;
  final int typeId;
  final int price;
  final int quantity;
  final bool isProm;

  const Goods({
    required this.upc,
    required this.typeId,
    required this.price,
    required this.quantity,
    required this.isProm,
  });

  factory Goods.fromJSON(dynamic json) {
    return Goods(
      upc: json['upc'],
      typeId: json['typeId'],
      price: json['price'],
      quantity: json['quantity'],
      isProm: json['isProm'],
    );
  }

  @override
  get primaryKey => upc;

  @override
  Map<String, dynamic> toJSON() {
    return {
      'upc': upc,
      'typeId': typeId,
      'price': price,
      'quantity': quantity,
      'isProm': isProm,
    };
  }

  @override
  DataRow buildRow(BuildContext context) {
    // todo how to show that the goods is prom?
    final cellsText = [
      upc.toString(),
      typeId.toString(),
      price.toString(),
      quantity.toString(),
    ];

    return buildRowFromFields(context, cellsText);
  }
}
