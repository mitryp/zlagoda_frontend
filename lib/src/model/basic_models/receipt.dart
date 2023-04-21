import '../../typedefs.dart';
import '../common_models/name.dart';
import '../joined_models/joined_sale.dart';
import '../other_models/table_receipt.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';

class Receipt extends TableReceipt {
  static final Schema<Receipt> schema = Schema(
    Receipt.new,
    [
      FieldDescription<int, Receipt>(
        'receiptId',
        (o) => o.receiptId,
        labelCaption: 'Номер чеку',
        fieldType: FieldType.number,
      ),
      FieldDescription<int, Receipt>(
        'cost',
        (o) => o.cost,
        labelCaption: 'Загальна вартість',
      ),
      FieldDescription<String?, Receipt>(
        'clientId',
        (o) => o.clientId,
        labelCaption: 'Номер картки клієнта',
      ),
      FieldDescription<Name?, Receipt>(
        'clientName',
        (o) => o.clientName,
        labelCaption: "Ім'я клієнта",
      ),
      FieldDescription<DateTime, Receipt>(
        'date',
        (o) => o.date,
        labelCaption: 'Дата',
        fieldType: FieldType.date,
      ),
      FieldDescription<int, Receipt>(
        'tax',
        (o) => o.tax,
        labelCaption: 'Податок',
        fieldType: FieldType.number,
      ),
      FieldDescription<Name, Receipt>(
        'employeeName',
        (o) => o.employeeName,
        labelCaption: "Ім'я касира",
      ),
      FieldDescription<String, Receipt>(
        'employeeId',
        (o) => o.employeeId,
        labelCaption: 'Табельний номер працівника',
      ),
      FieldDescription<List<JoinedSale>, Receipt>(
        'sales',
        (o) => o.sales,
        labelCaption: 'Продані товари',
        fieldType: FieldType.auto,
      ),
    ],
  );

  final DateTime date;
  final int tax;
  final String? clientId;
  final String employeeId;
  final List<JoinedSale> sales;

  const Receipt({
    required super.receiptId,
    required super.cost,
    super.clientName,
    required super.employeeName,
    required this.date,
    required this.tax,
    this.clientId,
    required this.employeeId,
    required this.sales,
  });

  static Receipt? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  get primaryKey => receiptId;
}
