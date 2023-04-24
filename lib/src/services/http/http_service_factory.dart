import '../../model/basic_models/category.dart';
import '../../model/basic_models/client.dart';
import '../../model/basic_models/employee.dart';
import '../../model/basic_models/product.dart';
import '../../model/basic_models/receipt.dart';
import '../../model/basic_models/store_product.dart';
import '../../model/interfaces/search_model.dart';
import '../../model/interfaces/serializable.dart';
import '../../model/joined_models/joined_store_product.dart';
import '../../model/joined_models/product_with_category.dart';
import '../../model/other_models/table_receipt.dart';
import '../../model/search_models/short_category.dart';
import '../../typedefs.dart';
import 'model_http_service.dart';
import 'short_model_http_service.dart';

ModelHttpService makeModelHttpService<S extends Serializable>() {
  const classesToConstructors = <Type, Constructor<ModelHttpService>>{
    Employee: EmployeeService.new,
    StoreProduct: StoreProductService.new,
    JoinedStoreProduct: StoreProductService.new,
    Product: ProductService.new,
    ProductWithCategory: ProductService.new,
    Client: ClientService.new,
    Receipt: ReceiptService.new,
    TableReceipt: ReceiptService.new,
    Category: CategoryService.new
  };

  final serviceConstructor = classesToConstructors[S];

  if (serviceConstructor == null) {
    throw StateError('No ResourceHttpService found for type $S');
  }

  return serviceConstructor();
}

ShortModelHttpService<SM> makeShortModelHttpService<SM extends SearchModel>() {
  const classesToConstructors = <Type, Constructor<ShortModelHttpService>>{
    ShortCategory: ShortCategoryService.new
  };

  final serviceConstructor = classesToConstructors[SM];

  if (serviceConstructor == null) {
    throw StateError('No ResourceHttpService found for type $SM');
  }

  return serviceConstructor() as ShortModelHttpService<SM>;
}


