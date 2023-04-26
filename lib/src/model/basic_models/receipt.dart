import '../../typedefs.dart';
import '../common_models/name.dart';
import '../interfaces/convertible_to_pdf.dart';
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

class Receipt extends TableReceipt with ConvertibleToPdf<Receipt> {
  static final Schema<Receipt> schema = Schema(
    Receipt.new,
    [
      FieldDescription<int?, Receipt>(
        'receiptId',
        (o) => o.receiptId,
        labelCaption: 'Номер чеку',
        fieldType: FieldType.number,
      ),
      FieldDescription<int, Receipt>(
        'cost',
        (o) => o.cost,
        labelCaption: 'Загальна вартість',
        fieldType: FieldType.currency,
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
        fieldType: FieldType.datetime,
        dateConstraints: const DateConstraints(toFirstDate: Duration(days: 365 * 100)),
      ),
      FieldDescription<int, Receipt>(
        'tax',
        (o) => o.tax,
        labelCaption: 'Податок',
        fieldType: FieldType.number,
      ),
      FieldDescription<String, Receipt>.stringForeignKey(
        'employeeId',
        (o) => o.employeeId,
        labelCaption: 'Табельний номер працівника',
        defaultForeignKey: foreignKey<Employee, ShortCashier>('employeeId'),
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
      ),
      FieldDescription<int, Receipt>(
        'discount',
        (o) => o.discount,
        labelCaption: 'Знижка',
        fieldType: FieldType.number,
      ),
    ],
  );

  final String? clientId;
  final String employeeId;
  final List<JoinedSale> sales;

  const Receipt({
    super.receiptId,
    required super.cost,
    this.clientId,
    super.clientName,
    required super.employeeName,
    required super.date,
    required super.tax,
    required super.discount,
    required this.employeeId,
    required this.sales,
  });

  static Receipt? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);
}
