import '../../typedefs.dart';
import '../common_models/name.dart';
import '../interfaces/model.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

class TableReceipt extends Model {
  static final Schema<TableReceipt> schema = Schema(
    TableReceipt.new,
    [
      Retriever<int, TableReceipt>('receiptId', (o) => o.receiptId),
      Retriever<int, TableReceipt>('cost', (o) => o.cost),
      Retriever<Name?, TableReceipt>('clientName', (o) => o.clientName),
      Retriever<Name, TableReceipt>('employeeName', (o) => o.employeeName),
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
