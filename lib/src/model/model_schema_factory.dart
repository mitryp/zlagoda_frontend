import 'basic_models/category.dart';
import 'basic_models/client.dart';
import 'basic_models/employee.dart';
import 'basic_models/product.dart';
import 'basic_models/receipt.dart';
import 'basic_models/store_product.dart';
import 'common_models/address.dart';
import 'common_models/name.dart';
import 'interfaces/serializable.dart';
import 'joined_models/product_with_category.dart';
import 'other_models/search_product.dart';
import 'schema/schema.dart';

final _classesToSchemas = <Type, Schema>{
  Category: Category.schema,
  Client: Client.schema,
  Employee: Employee.schema,
  Product: Product.schema,
  ProductWithCategory: ProductWithCategory.schema,
  Receipt: Receipt.schema,
  StoreProduct: StoreProduct.schema,
  Name: Name.schema,
  Address: Address.schema,
  SearchProduct: SearchProduct.schema,
};

Schema<S> makeModelSchema<S extends Serializable>([Type? modelType]) {
  final schema = _classesToSchemas[modelType ?? S];

  if (schema == null) {
    throw StateError('Schema for model type $S was not found');
  }

  return schema as Schema<S>;
}