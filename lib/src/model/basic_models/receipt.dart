import '../../typedefs.dart';
import '../interfaces/model.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

class Receipt extends Model {
  static final Schema<Receipt> schema = [
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

  static Receipt? fromJson(JsonMap json) {
    final receiptJson = retrieveFromJson(schema, json);

    return receiptJson == null
        ? null
        : Receipt(
            receiptId: receiptJson['receiptId'],
            date: receiptJson['date'],
            amount: receiptJson['amount'],
            tax: receiptJson['tax'],
            clientId: receiptJson['clientId'],
            employeeId: receiptJson['employeeId'],
            goodsIds: receiptJson['goodsIds'],
          );
  }

  @override
  JsonMap toJson() => convertToJson(schema, this);

  @override
  get primaryKey => receiptId;
}
