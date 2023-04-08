import 'package:flutter/material.dart';

import 'model.dart';

DataRow buildRowFromFields(BuildContext context, List<String> cellsText) {
  return DataRow(
      cells: cellsText.map((cellText) => DataCell(Text(cellText))).toList());
}

mixin ConvertibleToRow on Model {
  DataRow buildRow(BuildContext context);
}