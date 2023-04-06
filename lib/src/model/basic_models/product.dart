import '../../typedefs.dart';
import '../interfaces/model.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

class Product extends Model {
  static final Schema<Product> schema = [
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

  static Product? fromJson(JsonMap json) {
    final productJson = retrieveFromJson(schema, json);

    return productJson == null
        ? null
        : Product(
            typeId: productJson['typeId'],
            productName: productJson['productName'],
            manufacturer: productJson['manufacturer'],
            specs: productJson['specs'],
            categoryId: productJson['categoryId'],
          );
  }

  @override
  JsonMap toJson() => convertToJson(schema, this);

  @override
  get primaryKey => typeId;
}
