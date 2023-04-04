import 'package:flutter/material.dart';

import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';

class Category extends Model implements ConvertibleToRow  {
  final int categoryId;
  final String categoryName;

  const Category({
    required this.categoryId,
    required this.categoryName,
  });

  factory Category.fromJSON(dynamic json) {
    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
    );
  }

  @override
  get primaryKey => categoryId;

  @override
  Map<String, dynamic> toJSON() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }

  @override
  DataRow buildRow(BuildContext context) {
    final cellsText = [
      categoryName
    ];

    return buildRowFromFields(context, cellsText);
  }
}
