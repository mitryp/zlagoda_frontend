import 'package:http/http.dart' as http;

import '../../model/basic_models/category.dart';
import '../../model/basic_models/client.dart';
import '../../model/basic_models/employee.dart';
import '../../model/basic_models/product.dart';
import '../../model/basic_models/receipt.dart';
import '../../model/basic_models/store_product.dart';
import '../../model/interfaces/serializable.dart';
import '../../typedefs.dart';
import '../../utils/exceptions.dart';
import '../../utils/json_decode.dart';
import '../middleware/middleware_application.dart';
import '../middleware/response/response_middleware.dart';
import '../query_builder/query_builder.dart';

typedef JsonCastFunction<S extends Serializable> = S? Function(JsonMap json);
typedef ControllerSuccessfulLogic<T> = T Function(http.Response response);

/// Authors:
/// Interface - Popov Dmytro
/// Implementation - Verkhohliad Kateryna
abstract class ModelHttpService<S extends Serializable> {
  static const String baseRoute = 'localhost:5000';

  final String route;
  final JsonCastFunction<S> castFunction;

  const ModelHttpService({required this.route, required this.castFunction});

  String _route([Object? path]) => 'api/$route${path != null ? '/$path' : ''}';

  Future<T> _controller<T>(
    http.Response response,
    ControllerSuccessfulLogic<T> successLogic,
  ) async {
    final res = await applyResponseMiddleware(response);

    if (successCodes(res)) {
      return successLogic(res);
    }

    throw ResourceNotFetchedException(res.reasonPhrase);
  }

  Future<List<S>> get(QueryBuilder queryBuilder) async {
    final response = await http.get(Uri.http(baseRoute, _route(), queryBuilder.queryParams));

    return _controller(response, (response) {
      return decodeResponseBody<List<dynamic>>(response)
          .map((m) => castFunction(m))
          .where((e) => e != null)
          .toList()
          .cast<S>();
    });
  }

  Future<S?> singleById(dynamic id) async {
    final response = await http.get(Uri.http(baseRoute, _route(id)));

    return _controller(response, (response) => castFunction(decodeResponseBody(response)));
  }

  Future<bool> post(S row) async {
    final response = await http.post(Uri.http(baseRoute, _route()), body: row.toJson());

    return _controller(response, (response) => true);
  }

  Future<bool> update(S row, dynamic primaryKey) async {
    final response = await http.put(Uri.http(baseRoute, _route(primaryKey)), body: row.toJson());

    return _controller(response, (response) => true);
  }

  Future<bool> delete(dynamic id) async {
    final response = await http.put(Uri.http(baseRoute, _route(id)));

    return _controller(response, (response) => true);
  }
}

/*
  Concrete implementations
 */

class EmployeeService extends ModelHttpService<Employee> {
  const EmployeeService() : super(route: 'employees', castFunction: Employee.fromJson);
}

class StoreProductService extends ModelHttpService<StoreProduct> {
  const StoreProductService() : super(route: 'store_products', castFunction: StoreProduct.fromJSON);
}

class ProductService extends ModelHttpService<Product> {
  const ProductService() : super(route: 'products', castFunction: Product.fromJson);
}

class CategoryService extends ModelHttpService<Category> {
  const CategoryService() : super(route: 'categories', castFunction: Category.fromJson);
}

class ClientService extends ModelHttpService<Client> {
  const ClientService() : super(route: 'clients', castFunction: Client.fromJson);
}

class ReceiptService extends ModelHttpService<Receipt> {
  const ReceiptService() : super(route: 'receipts', castFunction: Receipt.fromJson);
}
