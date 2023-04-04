import '../interfaces/model.dart';

class Receipt implements Model {
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
    return Receipt(
      receiptId: json['receiptId'],
      date: DateTime(json['date']),
      amount: json['amount'],
      tax: json['tax'],
      clientId: json['clientId'],
      employeeId: json['employeeId'],
      goodsIds: json['goodsIds'],
    );
  }

  @override
  get primaryKey => clientId;

  @override
  Map<String, dynamic> toJSON() {
    return {
      'receiptId': receiptId,
      'date': date,
      'amount': amount,
      'tax': tax,
      'clientId': clientId,
      'employeeId': employeeId,
      'goodsIds': goodsIds,
    };
  }
}