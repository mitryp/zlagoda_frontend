import '../../model/basic_models/category.dart';
import '../../model/basic_models/client.dart';
import '../../model/basic_models/employee.dart';
import '../../model/basic_models/product.dart';
import '../../model/basic_models/receipt.dart';
import '../../model/basic_models/store_product.dart';
import '../../model/interfaces/serializable.dart';
import '../../model/joined_models/product_with_category.dart';
import '../../model/other_models/table_receipt.dart';
import '../../typedefs.dart';
import 'model_http_service.dart';

const _classesToConstructors = <Type, Constructor<ModelHttpService>>{
  Employee: EmployeeService.new,
  StoreProduct: StoreProductService.new,
  Product: ProductService.new,
  ProductWithCategory: ProductService.new,
  Client: ClientService.new,
  Receipt: ReceiptService.new,
  TableReceipt: ReceiptService.new,
  Category: CategoryService.new
};

ModelHttpService makeHttpService<S extends Serializable>() {
  final serviceConstructor = _classesToConstructors[S];

  if (serviceConstructor == null) {
    throw StateError('No ResourceHttpService found for type $S');
  }

  return serviceConstructor();
}
