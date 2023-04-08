import '../../typedefs.dart';
import '../common_models/name.dart';
import '../joined_models/joined_sale.dart';
import '../other_models/table_receipt.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

class Receipt extends TableReceipt {
  static final Schema<Receipt> schema = Schema(
    Receipt.new,
    [
      Retriever<int, Receipt>('receiptId', (o) => o.receiptId),
      Retriever<int, Receipt>('cost', (o) => o.cost),
      Retriever<Name?, Receipt>('clientName', (o) => o.clientName),
      Retriever<Name, Receipt>('employeeName', (o) => o.employeeName),
      Retriever<DateTime, Receipt>('date', (o) => o.date),
      Retriever<int, Receipt>('tax', (o) => o.tax),
      Retriever<String?, Receipt>('clientId', (o) => o.clientId),
      Retriever<String, Receipt>('employeeId', (o) => o.employeeId),
      Retriever<List<JoinedSale>, Receipt>('sales', (o) => o.sales),
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
