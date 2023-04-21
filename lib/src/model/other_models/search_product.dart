import '../../typedefs.dart';
import '../basic_models/product.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';
import 'search_model.dart';

class SearchProduct extends SearchModel<Product> {
  static final Schema<SearchProduct> schema = Schema(
    SearchProduct.new,
    [
      FieldDescription<String, SearchProduct>(
        'upc',
        (o) => o.upc,
        labelCaption: 'UPC',
      ),
      FieldDescription<String, SearchProduct>(
        'productName',
        (o) => o.productName,
        labelCaption: 'Назва',
      ),
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
