import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/coins_to_currency.dart';
import '../../utils/navigation.dart';
import '../../utils/value_status.dart';
import '../common_models/name.dart';
import '../interfaces/convertible_to_pdf.dart';
import '../interfaces/convertible_to_row.dart';
import '../joined_models/joined_sale.dart';
import '../model_reference.dart';
import '../schema/date_constraints.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';
import '../search_models/short_cashier.dart';
import '../search_models/short_client.dart';
import 'client.dart';
import 'employee.dart';
import '../interfaces/model.dart';

class Receipt extends Model
    with ConvertibleToRow<Receipt>, ConvertibleToPdf<Receipt> {
  static final Schema<Receipt> schema = Schema(
    Receipt.new,
    [
      FieldDescription<int?, Receipt>(
          'receiptId',
              (o) => o.receiptId,
          labelCaption: 'Номер чеку',
          fieldType: FieldType.number,
          fieldDisplayMode: FieldDisplayMode.none
      ),
      FieldDescription<String?, Receipt>.stringForeignKey(
        'clientId',
            (o) => o.clientId,
        labelCaption: 'Номер картки клієнта',
        defaultForeignKey: foreignKey<Client, ShortClient>('clientId'),
        fieldDisplayMode: FieldDisplayMode.none,
      ),
      FieldDescription<Name?, Receipt>.serializable(
        'clientName',
            (o) => o.clientName,
        labelCaption: "Ім'я клієнта",
        serializableEditorBuilder: nameEditorBuilder,
      ),
      FieldDescription<DateTime, Receipt>(
        'date',
            (o) => o.date,
        labelCaption: 'Дата',
        fieldType: FieldType.datetime,
        dateConstraints:
        const DateConstraints(toFirstDate: Duration(days: 365 * 100)),
      ),
      FieldDescription<int, Receipt>(
        'tax',
            (o) => o.tax,
        labelCaption: 'Податок',
        fieldType: FieldType.number,
      ),
      FieldDescription<int, Receipt>(
        'discount',
            (o) => o.discount,
        labelCaption: 'Знижка',
        fieldType: FieldType.number,
      ),
      FieldDescription<int, Receipt>(
        'cost',
            (o) => o.cost,
        labelCaption: 'Загальна вартість',
        fieldType: FieldType.currency,
      ),
      FieldDescription<String, Receipt>.stringForeignKey(
        'employeeId',
            (o) => o.employeeId,
        labelCaption: 'Табельний номер працівника',
        defaultForeignKey: foreignKey<Employee, ShortCashier>('employeeId'),
        fieldDisplayMode: FieldDisplayMode.none,
      ),
      FieldDescription<Name, Receipt>.serializable(
        'employeeName',
            (o) => o.employeeName,
        labelCaption: "Ім'я касира",
        serializableEditorBuilder: nameEditorBuilder,
      ),
      FieldDescription<List<JoinedSale>, Receipt>(
        'sales',
            (o) => o.sales,
        labelCaption: 'Продані товари',
        fieldType: FieldType.auto,
        fieldDisplayMode: FieldDisplayMode.none,
      ),
    ],
  );

  final int? receiptId;
  final int cost;
  final Name? clientName;
  final Name employeeName;
  final DateTime date;
  final int discount;
  final int tax;
  final String? clientId;
  final String employeeId;
  final List<JoinedSale> sales;

  const Receipt({
    this.clientId,
    this.receiptId,
    required this.cost,
    required this.date,
    this.clientName,
    required this.tax,
    required this.discount,
    required this.employeeName,
    required this.employeeId,
    required this.sales,
  });

  @override
  get primaryKey => receiptId;

  static Receipt? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  Future<ValueStatusWrapper> redirectToModelView(BuildContext context) =>
      AppNavigation.of(context).toModelView<Receipt>(primaryKey);

  @override
  DataRow buildRow(BuildContext context,
      UpdateCallback<ValueChangeStatus> updateCallback) {
    final cellValues = [
      FieldType.datetime.presentation(date),
      clientName?.fullName ?? 'немає даних',
      employeeName.fullName,
      toHryvnas(cost),
      toHryvnas(tax),
      '$discount %'
    ];
    return DataRow(
      cells: cellValues.map((v) => DataCell(Text(v))).toList(),
      onSelectChanged: (_) async =>
          updateCallback(
              await redirectToModelView(context).then((v) => v.status)),
    );
  }

  @override
  List<dynamic> get pdfRow => schema.fields.map((field)
  {
    final value = field.fieldGetter(this);

    if (value is List<JoinedSale>)
      return value.join('\n');

    return value;
  }).toList();
}
