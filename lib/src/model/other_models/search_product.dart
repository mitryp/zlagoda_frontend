import '../../typedefs.dart';
import '../interfaces/model.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

class SearchProduct extends Model {
  static final Schema<SearchProduct> schema = Schema(
    SearchProduct.new,
    [
      Retriever<String, SearchProduct>('upc', (o) => o.upc),
      Retriever<String, SearchProduct>('productName', (o) => o.productName),
    ],
  );

  final String upc;
  final String productName;

  const SearchProduct({
    required this.upc,
    required this.productName,
  });

  static SearchProduct? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  get primaryKey => upc;
}
