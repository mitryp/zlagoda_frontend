import '../../typedefs.dart';
import '../common_models/name.dart';
import '../interfaces/model.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';

class TableReceipt extends Model {
  static final Schema<TableReceipt> schema = Schema(
    TableReceipt.new,
    [
      FieldDescription<int, TableReceipt>(
        'receiptId',
        (o) => o.receiptId,
        labelCaption: 'Номер чеку',
        fieldType: FieldType.number,
      ),
      FieldDescription<int, TableReceipt>(
        'cost',
        (o) => o.cost,
        labelCaption: 'Вартість',
      ),
      FieldDescription<Name?, TableReceipt>(
        'clientName',
        (o) => o.clientName,
        labelCaption: "Ім'я клієнта",
        fieldType: FieldType.serializable,
      ),
      FieldDescription<Name, TableReceipt>(
        'employeeName',
        (o) => o.employeeName,
        labelCaption: "Ім'я працівника",
        fieldType: FieldType.serializable,
      ),
    ],
  );

  final int receiptId;
  final int cost;
  final Name? clientName;
  final Name employeeName;

  const TableReceipt({
    required this.receiptId,
    required this.cost,
    this.clientName,
    required this.employeeName,
  });

  static TableReceipt? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  get primaryKey => receiptId;
}
