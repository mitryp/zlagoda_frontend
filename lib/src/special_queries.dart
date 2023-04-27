import 'package:flutter/material.dart';
import 'services/http/helpers/http_service_helper.dart';

import 'typedefs.dart';
import 'view/dialogs/creation_dialog.dart';
import 'view/pages/special_queries_page.dart';

typedef JsonPresenter = Widget Function(JsonMap json);

abstract class SpecialQuery {
  final String path;
  final String? parameterName;
  final String queryName;
  final InputBuilder? inputBuilder;
  final InputConverter? inputConverter;

  const SpecialQuery(
    this.path,
    this.queryName,{
    this.parameterName,
    this.inputBuilder,
    this.inputConverter,
  });

  Uri makeUri(Map<String, String> queryParams) => Uri.http('$baseRoute/api', path, queryParams);

  Widget makePresentationWidget(BuildContext context, dynamic json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialQuery && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;
}

class RegularClients extends SpecialQuery {
  const RegularClients() : super('clients/regular_clients', 'minPurchases');

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    const columnNames = [
      'Номер картки клієнта',
      'Прізвище',
      'Ім\'я',
      'Кількість чеків'
    ];

    return DataTable(
        columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
        rows: json.map((item) => DataRow(cells: [
          DataCell(item['card_number']),
          DataCell(item['cust_surname']),
          DataCell(item['cust_name']),
          DataCell(item['total_receipts']),
        ])).toList(),
    );
  }
}

// class ReceiptsWithAllCategories extends SpecialQuery {
//   const ReceiptsWithAllCategories() : super('clients/receipts_with_all_categories');
//
//   @override
//   Widget makePresentationWidget(BuildContext context, dynamic json) {
//     const columnNames = [
//       'Номер чека',
//       'Табельний номер касира',
//       'Ім\'я касира',
//       'Номер карти клієнта',
//       'Ім\'я клієнта',
//       'Дата створення чека',
//       'Вартість',
//       'ПДВ',
//     ];
//
//     return DataTable(
//       columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
//       rows: json.map((item) => DataRow(cells: [
//         DataCell(item['check_number']),
//         DataCell(item['cust_surname']),
//         DataCell(item['cust_name']),
//         DataCell(item['total_receipts']),
//       ])).toList(),
//     );
//   }
// }
//
