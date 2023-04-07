import '../../typedefs.dart';
import '../interfaces/model.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

class Product extends Model {
  static final Schema<Product> schema = Schema(
    Product.new,
    [
      Retriever<String, Product>('upc', (o) => o.upc),
      Retriever<String, Product>('productName', (o) => o.productName),
      Retriever<String, Product>('manufacturer', (o) => o.manufacturer),
      Retriever<String, Product>('specs', (o) => o.specs),
      Retriever<int, Product>('categoryId', (o) => o.categoryId),
    ],
  );

  final String upc;
  final String productName;
  final String manufacturer;
  final String specs;
  final int categoryId;

  const Product({
    required this.upc,
    required this.productName,
    required this.manufacturer,
    required this.specs,
    required this.categoryId,
  });

  static Product? fromJson(JsonMap json)  => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  get primaryKey => upc;
}
