import 'package:flutter/material.dart';

DataRow buildRowFromFields(BuildContext context, List<String> cellsText) {
  return DataRow(
      cells: cellsText.map((cellText) => DataCell(Text(cellText))).toList());
}

mixin ConvertibleToRow {
  DataRow buildRow(BuildContext context);
}