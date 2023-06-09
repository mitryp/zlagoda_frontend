import 'package:http/http.dart' as http;

import '../../model/basic_models/category.dart';
import '../../model/basic_models/client.dart';
import '../../model/basic_models/employee.dart';
import '../../model/basic_models/product.dart';
import '../../model/basic_models/receipt.dart';
import '../../model/basic_models/store_product.dart';
import '../../model/interfaces/serializable.dart';
import '../../model/joined_models/joined_store_product.dart';
import '../../model/joined_models/product_with_category.dart';
import '../../typedefs.dart';
import '../../utils/json_decode.dart';
import '../query_builder/query_builder.dart';
import 'helpers/collection_slice_wrapper.dart';
import 'helpers/http_service_helper.dart';

typedef JsonCastFunction<S extends Serializable> = S? Function(JsonMap json);
typedef ControllerSuccessfulLogic<T> = T Function(http.Response response);

/// Authors:
/// Interface - Popov Dmytro
/// Implementation - Verkhohliad Kateryna
/// [SCol] - the type of the recourse when the whole collection is fetched by GET collection
/// [SSingle] - the type of the single row fetched by GET single
abstract class ModelHttpService<SCol extends Serializable, SSingle extends Serializable> {
  final String route;
  final JsonCastFunction<SCol> collectionCastFunction;
  final JsonCastFunction<SSingle> singleCastFunction;

  const ModelHttpService({
    required this.route,
    required this.collectionCastFunction,
    JsonCastFunction<SSingle>? singleCastFunction,
  })  : assert(SCol == SSingle || singleCastFunction != null),
        singleCastFunction =
            singleCastFunction ?? collectionCastFunction as JsonCastFunction<SSingle>;

  String makeRoute([Object? path]) => 'api/$route${path != null ? '/$path' : ''}';

  Future<CollectionSliceWrapper<SCol>> get(QueryBuilder queryBuilder) async {
    final response = await makeRequest(
      HttpMethod.get,
      Uri.http(
          baseRoute,
          makeRoute(queryBuilder.subRoute.isNotEmpty ? queryBuilder.subRoute : null),
          queryBuilder.queryParams),
    );

    final totalCount = int.tryParse(response.headers['x-total-count']??'')??0;
    final items = await httpServiceController(response, (response) {
      return decodeResponseBody<List<dynamic>>(response)
          .map((m) => collectionCastFunction(m))
          .where((e) => e != null)
          .toList()
          .cast<SCol>();
    });

    return CollectionSliceWrapper<SCol>(items: items, totalCount: totalCount);
  }

  Future<SSingle?> singleById(dynamic id) async {
    final response = await makeRequest(HttpMethod.get, Uri.http(baseRoute, makeRoute(id)));

    return httpServiceController(response, _tryDecodeSingleResource);
  }

  Future<SSingle?> post(SSingle row) async {
    final response = await makeRequest(
      HttpMethod.post,
      Uri.http(baseRoute, makeRoute()),
      body: row.toJson(),
    );

    return httpServiceController(response, _tryDecodeSingleResource);
  }

  Future<SSingle?> update(SSingle row, dynamic primaryKey) async {
    final response = await makeRequest(
      HttpMethod.put,
      Uri.http(baseRoute, makeRoute(primaryKey)),
      body: row.toJson(),
    );

    return httpServiceController(response, _tryDecodeSingleResource);
  }

  Future<bool> delete(dynamic id) async {
    final response = await makeRequest(HttpMethod.delete, Uri.http(baseRoute, makeRoute(id)));

    return httpServiceController(response, (response) => true, (response) => false);
  }

  SSingle? _tryDecodeSingleResource(http.Response response) =>
      singleCastFunction(decodeResponseBody<Map<String, dynamic>>(response));
}

/*
  Concrete implementations
 */

class EmployeeService extends ModelHttpService<Employee, Employee> {
  const EmployeeService() : super(route: 'employees', collectionCastFunction: Employee.fromJson);
}

class StoreProductService extends ModelHttpService<JoinedStoreProduct, StoreProduct> {
  const StoreProductService()
      : super(
          route: 'store_products',
          collectionCastFunction: JoinedStoreProduct.fromJson,
          singleCastFunction: StoreProduct.fromJSON,
        );
}

class ProductService extends ModelHttpService<ProductWithCategory, Product> {
  const ProductService()
      : super(
          route: 'products',
          collectionCastFunction: ProductWithCategory.fromJson,
          singleCastFunction: Product.fromJson,
        );
}

class CategoryService extends ModelHttpService<Category, Category> {
  const CategoryService()
      : super(
          route: 'categories',
          collectionCastFunction: Category.fromJson,
        );
}

class ClientService extends ModelHttpService<Client, Client> {
  const ClientService()
      : super(
          route: 'clients',
          collectionCastFunction: Client.fromJson,
        );
}

class ReceiptService extends ModelHttpService<Receipt, Receipt> {
  const ReceiptService()
      : super(
          route: 'receipts',
          collectionCastFunction: Receipt.fromJson,
          singleCastFunction: Receipt.fromJson,
        );
}
