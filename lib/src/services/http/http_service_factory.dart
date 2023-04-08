import '../../model/basic_models/category.dart';
import '../../model/basic_models/client.dart';
import '../../model/basic_models/employee.dart';
import '../../model/basic_models/product.dart';
import '../../model/basic_models/receipt.dart';
import '../../model/basic_models/store_product.dart';
import '../../model/interfaces/model.dart';
import 'model_http_service.dart';

typedef ResourceServiceConstructor = ModelHttpService Function();

const _classesToConstructors = <Type, ResourceServiceConstructor>{
  Employee: EmployeeService.new,
  StoreProduct: StoreProductService.new,
  Product: ProductService.new,
  Client: ClientService.new,
  Receipt: ReceiptService.new,
  Category: CategoryService.new
};

ModelHttpService<M> makeHttpService<M extends Model>() {
  final serviceConstructor = _classesToConstructors[M];

  if (serviceConstructor == null) {
    throw StateError('No ResourceHttpService found for model type $M');
  }

  return serviceConstructor() as ModelHttpService<M>;
}
