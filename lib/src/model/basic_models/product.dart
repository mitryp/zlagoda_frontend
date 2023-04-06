import '../../typedefs.dart';
import '../interfaces/model.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

final Schema<Product> schema = [
  Retriever<int, Product>(
    field: 'typeId',
    getter: (product) => product.typeId,
  ),
  Retriever<String, Product>(
    field: 'productName',
    getter: (product) => product.productName,
  ),
  Retriever<String, Product>(
    field: 'manufacturer',
    getter: (product) => product.manufacturer,
  ),
  Retriever<String, Product>(
    field: 'specs',
    getter: (product) => product.specs,
  ),
  Retriever<int, Product>(
    field: 'categoryId',
    getter: (product) => product.categoryId,
  ),
];

class Product extends Model {
  final int typeId;
  final String productName;
  final String manufacturer;
  final String specs;
  final int categoryId;

  const Product({
    required this.typeId,
    required this.productName,
    required this.manufacturer,
    required this.specs,
    required this.categoryId,
  });

  factory Product.fromJSON(dynamic json) {
    final values = Model.flatValues(schema, json);

    return Product(
      typeId: values['typeId'],
      productName: values['productName'],
      manufacturer: values['manufacturer'],
      specs: values['specs'],
      categoryId: values['categoryId'],
    );
  }

  @override
  JsonMap toJson() => convertToJson(schema, this);

  @override
  get primaryKey => typeId;
}
