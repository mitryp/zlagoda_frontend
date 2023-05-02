import 'package:flutter/material.dart';

import '../model/schema/field_type.dart';
import '../model/schema/validators.dart';
import '../typedefs.dart';
import '../utils/coins_to_currency.dart';
import '../view/dialogs/creation_dialog.dart';
import 'special_query_base.dart';

InputBuilder inputWithLabel(String label, {FieldValidator? validator}) {
  return (controller) => TextFormField(
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          label: Text(
            label,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
      );
}

int intConverter(String text) => int.parse(text.trim());

Widget? makeListGuard(BuildContext context, dynamic json) {
  if (json == null || json is! List) {
    return const Text('Помилка виконання');
  }

  if (json.isEmpty) {
    return const Text('Рядків, що відповідають запиту, не знайдено');
  }

  return null;
}

class RegularClients extends SingleInputSpecialQuery {
  static Widget input(TextEditingController controller) {
    return inputWithLabel(
      'Мінімальна кількість покупок клієнта',
      validator: isNonNegativeInteger,
    )(controller);
  }

  const RegularClients()
      : super(
          'clients/regular_clients',
          'Постійні клієнти',
          parameterName: 'minPurchases',
          inputBuilder: input,
          inputConverter: intConverter,
        );

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    final guard = makeListGuard(context, json);
    if (guard != null) {
      return guard;
    }

    const columnNames = [
      'Номер картки клієнта',
      'Прізвище',
      'Ім\'я',
      'Кількість чеків'
    ];

    return DataTable(
      columns:
          columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: (json as List<dynamic>)
          .cast<JsonMap>()
          .map((item) => DataRow(cells: [
                DataCell(Text(item['card_number']!)),
                DataCell(Text(item['cust_surname']!)),
                DataCell(Text(item['cust_name']!)),
                DataCell(Text('${item['total_receipts']}')),
              ]))
          .toList(),
    );
  }
}

class ReceiptsWithAllCategories extends StaticSpecialQuery {
  const ReceiptsWithAllCategories()
      : super('receipts/receipts_with_all_categories',
            'Чеки з продуктами усіх категорій');

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    final guard = makeListGuard(context, json);
    if (guard != null) {
      return guard;
    }

    const columnNames = [
      'Номер чека',
      'Табельний номер касира',
      "Ім'я касира",
      'Номер карти клієнта',
      "Ім'я клієнта",
      'Дата створення чека',
      'Вартість',
      'ПДВ',
    ];

    return DataTable(
      columns:
          columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: (json as List<dynamic>).cast<JsonMap>().map((item) {
        final customerFirstName = item['cust_name'],
            customerLastName = item['cust_surname'];
        final customerName =
            [customerFirstName, customerLastName].contains(null)
                ? 'немає даних'
                : '$customerLastName $customerFirstName';
        final printDate = FieldType.datetime.presentation(
            DateTime.fromMillisecondsSinceEpoch(item['print_date'] * 1000));

        return DataRow(cells: [
          DataCell(Text('${item['receipt_number']}')),
          DataCell(Text(item['id_employee'])),
          DataCell(Text('${item['empl_surname']} ${item['empl_name']}')),
          DataCell(Text(item['card_number'] ?? 'немає даних')),
          DataCell(Text(customerName)),
          DataCell(Text(printDate)),
          DataCell(Text(toHryvnas(item['sum_total']))),
          DataCell(Text(toHryvnas(item['vat']))),
        ]);
      }).toList(),
    );
  }
}

class ProductsSoldByAllCashiers extends StaticSpecialQuery {
  const ProductsSoldByAllCashiers()
      : super(
            'products/sold_by_all_cashiers', 'Товари, продані всіма касирами');

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    final guard = makeListGuard(context, json);
    if (guard != null) {
      return guard;
    }

    const columnNames = [
      'UPC',
      'Назва товару',
      'Виробник',
    ];

    return DataTable(
      columns:
          columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: (json as List<dynamic>)
          .cast<JsonMap>()
          .map((item) => DataRow(cells: [
                DataCell(Text(item['UPC'])),
                DataCell(Text(item['product_name'])),
                DataCell(Text(item['manufacturer'])),
              ]))
          .toList(),
    );
  }
}

class BestCashiers extends SingleInputSpecialQuery {
  static Widget input(TextEditingController controller) => inputWithLabel(
        'Мінімальна кількість проданих товарів',
        validator: isPositiveInteger,
      )(controller);

  const BestCashiers()
      : super(
          'employees/best_cashiers',
          'Найпродуктивніші касири',
          parameterName: 'minSold',
          inputConverter: intConverter,
          inputBuilder: input,
        );

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    final guard = makeListGuard(context, json);
    if (guard != null) {
      return guard;
    }

    const columnNames = [
      'Табельний номер',
      'Ім\'я касира',
      'Кількість проданих товарів',
    ];

    return DataTable(
      columns:
          columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: (json as List<dynamic>)
          .cast<JsonMap>()
          .map((item) => DataRow(cells: [
                DataCell(Text(item['id_employee'])),
                DataCell(Text('${item['empl_surname']} ${item['empl_name']}')),
                DataCell(Text('${item['num_products_sold']}')),
              ]))
          .toList(),
    );
  }
}

class SoldFor extends SingleInputSpecialQuery {
  static Widget input(TextEditingController controller) => inputWithLabel(
        'Мінімальна сумарна вартість продажів (необов.)',
        validator: optional(isNonNegativeInteger),
      )(controller);

  static String converter(String text) {
    final integerValue = int.tryParse(text.trim());
    return integerValue != null ? (integerValue * 100).toStringAsFixed(2) : '';
  }

  const SoldFor()
      : super(
          'products/sold_for',
          'Сумарна вартість продажів товарів',
          parameterName: 'minTotalFilter',
          inputBuilder: input,
          inputConverter: converter,
        );

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    final guard = makeListGuard(context, json);
    if (guard != null) {
      return guard;
    }

    const columnNames = [
      'UPC',
      'Назва продукту',
      'Категорія',
      'Сумарна вартість продажів',
    ];

    return DataTable(
      columns:
          columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: (json as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((item) => DataRow(cells: [
                DataCell(Text(item['upc'])),
                DataCell(Text(item['productName'])),
                DataCell(Text(item['categoryName'])),
                DataCell(Text(
                    '${((item['soldFor'] as int) / 100).toStringAsFixed(2)} грн.')),
              ]))
          .toList(),
    );
  }
}

class PurchasedByAllClients extends SingleInputSpecialQuery {
  const PurchasedByAllClients()
      : super(
          'products/purchased_by_all_clients',
          'Товари куплені всіма клієнтами',
          parameterName: 'clientSurnameFilter',
          inputConverter: converter,
          inputBuilder: input,
        );

  static Widget input(TextEditingController controller) =>
      inputWithLabel('Прізвище клієнта має містити (необов.)')(controller);

  static converter(String s) => s.trim();

  @override
  Widget makePresentationWidget(BuildContext context, dynamic json) {
    final guard = makeListGuard(context, json);
    if (guard != null) {
      return guard;
    }

    const columnNames = [
      'UPC',
      'Назва продукту',
      'Категорія',
    ];

    return DataTable(
      columns:
          columnNames.map((name) => DataColumn(label: Text(name))).toList(),
      rows: (json as List<dynamic>)
          .cast<JsonMap>()
          .map(
            (item) => DataRow(cells: [
              DataCell(Text(item['upc'])),
              DataCell(Text(item['productName'])),
              DataCell(Text(item['categoryName'])),
            ]),
          )
          .toList(),
    );
  }
}
