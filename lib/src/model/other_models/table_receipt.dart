import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/coins_to_currency.dart';
import '../../utils/navigation.dart';
import '../../utils/value_status.dart';
import '../basic_models/receipt.dart';
import '../common_models/name.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../schema/date_constraints.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';

class TableReceipt extends Model with ConvertibleToRow<TableReceipt> {
  static final Schema<TableReceipt> schema = Schema(
    TableReceipt.new,
    [
      FieldDescription<int?, TableReceipt>(
        'receiptId',
        (o) => o.receiptId,
        labelCaption: 'Номер чеку',
        fieldType: FieldType.number,
        fieldDisplayMode: FieldDisplayMode.none,
      ),
      FieldDescription<DateTime, TableReceipt>(
        'date',
        (o) => o.date,
        labelCaption: 'Дата',
        fieldType: FieldType.datetime,
        dateConstraints: const DateConstraints(toFirstDate: Duration(days: 365 * 100)),
      ),
      FieldDescription<Name?, TableReceipt>.serializable(
        'clientName',
        (o) => o.clientName,
        labelCaption: "Ім'я клієнта",
        serializableEditorBuilder: nameEditorBuilder,
      ),
      FieldDescription<Name, TableReceipt>.serializable(
        'employeeName',
        (o) => o.employeeName,
        labelCaption: "Ім'я касира",
        serializableEditorBuilder: nameEditorBuilder,
      ),
      FieldDescription<int, TableReceipt>(
        'cost',
        (o) => o.cost,
        labelCaption: 'Вартість',
      ),
      FieldDescription<int, TableReceipt>(
        'tax',
        (o) => o.tax,
        labelCaption: 'Податок',
        fieldType: FieldType.number,
      ),
      FieldDescription<int, TableReceipt>(
        'discount',
        (o) => o.discount,
        labelCaption: 'Знижка',
        fieldType: FieldType.number,
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

  const TableReceipt({
    this.receiptId,
    required this.cost,
    required this.date,
    this.clientName,
    required this.tax,
    required this.discount,
    required this.employeeName,
  });

  static TableReceipt? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  get primaryKey => receiptId;

  @override
  Future<ValueStatusWrapper> redirectToModelView(BuildContext context) =>
      AppNavigation.of(context).toModelView<Receipt>(primaryKey);

  @override
  DataRow buildRow(BuildContext context, UpdateCallback<ValueChangeStatus> updateCallback) {
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
          updateCallback(await redirectToModelView(context).then((v) => v.status)),
    );
  }
}
