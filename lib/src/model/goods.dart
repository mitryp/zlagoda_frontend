import 'package:flutter/material.dart';

import 'model.dart';

class Goods extends Model {
  // todo finish @Kate
  final String manufacturer;
  final int id;

  const Goods({required this.id, required this.manufacturer});

  factory Goods.fromJSON(dynamic json) {
    return Goods(
      id: json['id'],
      manufacturer: json['manufacturer'],
    );
  }

  @override
  DataRow buildRow(BuildContext context) {
    return DataRow(cells: []);
  }

  @override
  get primaryKey => id;

  @override
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'manufacturer': manufacturer,
    };
  }
}
