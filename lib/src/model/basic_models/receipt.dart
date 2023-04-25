import '../../typedefs.dart';
import '../common_models/name.dart';
import '../joined_models/joined_sale.dart';
import '../model_reference.dart';
import '../other_models/table_receipt.dart';
import '../schema/date_constraints.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';
import '../search_models/short_cashier.dart';
import '../search_models/short_client.dart';
import 'client.dart';
import 'employee.dart';

class Receipt extends TableReceipt {
  static final Schema<Receipt> schema = Schema(
    Receipt.new,
    [
      FieldDescription<int?, Receipt>(
        'receiptId',
        (o) => o.receiptId,
        labelCaption: 'Номер чеку',
      ),
      FieldDescription<int, Receipt>(
        'cost',
        (o) => o.cost,
        labelCaption: 'Загальна вартість',
      ),
      FieldDescription<String?, Receipt>.stringForeignKey(
        'clientId',
        (o) => o.clientId,
        labelCaption: 'Номер картки клієнта',
        defaultForeignKey: foreignKey<Client, ShortClient>('clientId'),
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
        fieldType: FieldType.date,
        dateConstraints: const DateConstraints(toFirstDate: Duration(days: 365 * 100)),
      ),
      FieldDescription<int, Receipt>(
        'tax',
        (o) => o.tax,
        labelCaption: 'Податок',
        fieldType: FieldType.number,
      ),
      FieldDescription<Name, Receipt>.serializable('employeeName', (o) => o.employeeName,
          labelCaption: "Ім'я касира", serializableEditorBuilder: nameEditorBuilder),
      FieldDescription<String, Receipt>.stringForeignKey(
        'employeeId',
        (o) => o.employeeId,
        labelCaption: 'Табельний номер працівника',
        defaultForeignKey: foreignKey<Employee, ShortCashier>('employeeId'),
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
    super.receiptId,
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
