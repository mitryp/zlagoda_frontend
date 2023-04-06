import '../../typedefs.dart';
import '../interfaces/model.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

final Schema<Receipt> schema = [
  Retriever<int, Receipt>(
    field: 'receiptId',
    getter: (receipt) => receipt.receiptId,
  ),
  Retriever<DateTime, Receipt>(
    field: 'date',
    getter: (receipt) => receipt.date,
  ),
  Retriever<int, Receipt>(
    field: 'amount',
    getter: (receipt) => receipt.amount,
  ),
  Retriever<int, Receipt>(
    field: 'tax',
    getter: (receipt) => receipt.tax,
  ),
  Retriever<int, Receipt>(
    field: 'clientId',
    getter: (receipt) => receipt.clientId,
  ),
  Retriever<int, Receipt>(
    field: 'employeeId',
    getter: (receipt) => receipt.employeeId,
  ),
  Retriever<List<int>, Receipt>(
    field: 'goodsIds',
    getter: (receipt) => receipt.goodsIds,
  ),
];

class Receipt extends Model {
  final int receiptId;
  final DateTime date;
  final int amount;
  final int tax;
  final int clientId;
  final int employeeId;
  final List<int> goodsIds;

  const Receipt({
    required this.receiptId,
    required this.date,
    required this.amount,
    required this.tax,
    required this.clientId,
    required this.employeeId,
    required this.goodsIds,
  });

  factory Receipt.fromJSON(dynamic json) {
    final values = Model.flatValues(schema, json);

    return Receipt(
      receiptId: values['receiptId'],
      date: values['date'],
      amount: values['amount'],
      tax: values['tax'],
      clientId: values['clientId'],
      employeeId: values['employeeId'],
      goodsIds: values['goodsIds'],
    );
  }

  @override
  JsonMap toJson() => convertToJson(schema, this);

  @override
  // TODO: implement primaryKey
  get primaryKey => throw UnimplementedError();
}
