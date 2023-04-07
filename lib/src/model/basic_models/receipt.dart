import '../../typedefs.dart';
import '../interfaces/model.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

class Receipt extends Model {
  static final Schema<Receipt> schema = Schema(
    Receipt.new,
    [
      Retriever<int, Receipt>('receiptId', (o) => o.receiptId),
      Retriever<DateTime, Receipt>('date', (o) => o.date),
      Retriever<int, Receipt>('amount', (o) => o.amount),
      Retriever<int, Receipt>('tax', (o) => o.tax),
      Retriever<int?, Receipt>('clientId', (o) => o.clientId),
      Retriever<int, Receipt>('employeeId', (o) => o.employeeId),
      Retriever<List<int>, Receipt>('goodsIds', (o) => o.goodsIds),
    ],
  );

  //TODO do the same as in Swagger
  final int receiptId;
  final DateTime date;
  final int amount;
  final int tax;
  final int? clientId;
  final int employeeId;
  //TODO change to JoinedSales
  final List<int> goodsIds;

  const Receipt({
    required this.receiptId,
    required this.date,
    required this.amount,
    required this.tax,
    this.clientId,
    required this.employeeId,
    required this.goodsIds,
  });

  static Receipt? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  get primaryKey => receiptId;
}
