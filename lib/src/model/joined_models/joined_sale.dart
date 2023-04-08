import '../../typedefs.dart';
import '../interfaces/serializable.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

class JoinedSale implements Serializable {
  static final Schema<JoinedSale> schema = Schema(
    JoinedSale.new,
    [
      Retriever<String, JoinedSale>('productName', (o) => o.productName),
      Retriever<String, JoinedSale>('upc', (o) => o.upc),
      Retriever<int, JoinedSale>('price', (o) => o.price),
      Retriever<int, JoinedSale>('quantity', (o) => o.quantity),
    ],
  );

  final String productName;
  final String upc;
  final int price;
  final int quantity;

  const JoinedSale({
    required this.productName,
    required this.upc,
    required this.price,
    required this.quantity,
  });

  static JoinedSale? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);
}
