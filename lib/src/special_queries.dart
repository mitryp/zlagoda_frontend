import 'package:flutter/material.dart';
import 'model/schema/validators.dart';
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
  const RegularClients() : super('clients/regular_clients', 'Постійні клієнти', parameterName: 'minPurchases');

  static Widget input(TextEditingController controller) {
    return TextFormField(
      validator: isPositiveInteger,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  static converter(String text) => int.parse(text.trim());

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
          DataCell(Text(item['card_number'])),
          DataCell(Text(item['cust_surname'])),
          DataCell(Text(item['cust_name'])),
          DataCell(Text(item['total_receipts'])),
        ])).toList(),
    );
  }
}

class ReceiptsWithAllCategories extends SpecialQuery {
  const ReceiptsWithAllCategories() : super('clients/receipts_with_all_categories', 'Чеки з продуктами усіх категорій');

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    const columnNames = [
      'Номер чека',
      'Табельний номер касира',
      'Ім\'я касира',
      'Номер карти клієнта',
      'Ім\'я клієнта',
      'Дата створення чека',
      'Вартість',
      'ПДВ',
    ];

    return DataTable(
      columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: json.map((item) => DataRow(cells: [
        DataCell(Text(item['check_number'])),
        DataCell(Text(item['id_employee'])),
        DataCell(Text('${item['empl_surname']} ${item['empl_name']}')),
        DataCell(Text(item['card_number'])),
        DataCell(Text('${item['cust_surname']} ${item['cust_name']}')),
        DataCell(Text(item['print_date'])),
        DataCell(Text(item['sum_total'])),
        DataCell(Text(item['vat'])),
      ])).toList(),
    );
  }
}

class ProductsSoldByAllCashiers extends SpecialQuery {
  const ProductsSoldByAllCashiers() : super('products/sold_by_all_cashiers', 'Товари, продані всіма касирами');

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    const columnNames = [
      'Назва товару',
      'Категорія',
      'Властивості',
    ];

    return DataTable(
      columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: json.map((item) => DataRow(cells: [
        DataCell(Text(item['product_name'])),
        DataCell(Text(item['category_name'])),
        DataCell(Text(item['characteristics'])),
      ])).toList(),
    );
  }
}


class BestCashiers extends SpecialQuery {
  const BestCashiers() : super('employees/best_cashiers', 'Касири, що продали товарів більше ніж', parameterName: 'minSold');

  static Widget input(TextEditingController controller) {
    return TextFormField(
      validator: isPositiveInteger,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  static converter(String text) => int.parse(text.trim());

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    const columnNames = [
      'Табельний номер',
      'Ім\'я касира',
      'Кількість проданих товарів',
    ];

    return DataTable(
      columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: json.map((item) => DataRow(cells: [
        DataCell(Text(item['id_employee'])),
        DataCell(Text('${item['empl_surname']} ${item['empl_name']}')),
        DataCell(Text(item['num_products_sold'])),
      ])).toList(),
    );
  }
}


class SoldFor extends SpecialQuery {
  const SoldFor() : super('products/sold_for'
      , 'Сумарна вартість продажів'
      , parameterName: 'minTotalFilter',);

  static Widget input(TextEditingController controller) {
    return TextFormField(
      validator: isPositiveInteger,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  static converter(String text) => int.parse(text.trim());

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    const columnNames = [
      'UPC',
      'Назва продукту',
      'Категорія',
      'Сумарна вартість продажів',
    ];

    return DataTable(
      columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: json.map((item) => DataRow(cells: [
        DataCell(Text(item['upc'])),
        DataCell(Text(item['productName'])),
        DataCell(Text(item['categoryName'])),
        DataCell(Text(item['soldFor'])),
      ])).toList(),
    );
  }
}

class PurchasedByClients extends SpecialQuery {
  const PurchasedByClients() : super('products/purchased_by_clients'
    , ''
    , parameterName: 'clientSurnameFilter',);

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    const columnNames = [
      'UPC',
      'Назва продукту',
      'Категорія',
    ];

    return DataTable(
      columns: columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: json.map((item) => DataRow(cells: [
        DataCell(Text(item['upc'])),
        DataCell(Text(item['productName'])),
        DataCell(Text(item['categoryName'])),
      ])).toList(),
    );
  }
}