import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/basic_models/category.dart';
import '../../model/basic_models/client.dart';
import '../../model/basic_models/employee.dart';
import '../../model/basic_models/store_product.dart';
import '../../model/basic_models/product.dart';
import '../../model/basic_models/receipt.dart';
import '../../model/interfaces/model.dart';
import '../query_builder/query_builder.dart';

typedef JsonCastFunction<M extends Model> = M Function(dynamic json);
typedef ControllerSuccessfulLogic<T> = T Function(http.Response response);

/// Authors:
/// Interface - Popov Dmytro
/// Implementation - Verkhohliad Kateryna
abstract class HttpService<M extends Model> {
  //static final String baseRoute = "http://localhost:5000/api";
  static const String baseRoute = '/api';

  final String route;
  final JsonCastFunction<M> castFunction;

  const HttpService({required this.route, required this.castFunction});

  String _route([String? path]) {
    return '$baseRoute/$route${path == null ? '/$path' : ''}';
  }

  T _controller<T>(
      http.Response response, ControllerSuccessfulLogic<T> successLogic) {
    //TODO handle 401 error: redirect to login
    if (response.statusCode == 200) {
      return successLogic(response);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<M>> get(QueryBuilder queryBuilder) async {
    final response = await http
        .get(Uri.http(baseRoute, _route(), queryBuilder.getQueryParams()));

    return _controller(response, (response) {
      final items = jsonDecode(response.body);

      return items.map(castFunction);
    });
  }

  Future<M?> singleById(dynamic id) async {
    final response = await http.get(Uri.http(baseRoute, _route(id)));

    return _controller(response, (response) {
      final item = jsonDecode(response.body);

      return castFunction(item);
    });
  }

  Future<bool> post(M row) async {
    final response =
        await http.post(Uri.http(baseRoute, _route()), body: row.toJson());

    return _controller(response, (response) {
      return true;
    });
  }

  Future<bool> update(M row) async {
    final response = await http.put(Uri.http(baseRoute, _route(row.primaryKey)),
        body: row.toJson());

    return _controller(response, (response) {
      return true;
    });
  }

  Future<bool> delete(dynamic id) async {
    final response = await http.put(Uri.http(baseRoute, _route(id)));

    return _controller(response, (response) {
      return true;
    });
  }
}

/*
  Concrete implementations
 */

class EmployeeService extends HttpService<Employee> {
  const EmployeeService()
      : super(
            route: 'employees',
            castFunction: Employee.fromJSON);
}

class GoodsService extends HttpService<StoreProduct> {
  const GoodsService()
      : super(
      route: 'goods',
      castFunction: StoreProduct.fromJSON);
}

class GoodsTypeService extends HttpService<Product> {
  const GoodsTypeService()
      : super(
      route: 'goods_types',
      castFunction: Product.fromJSON);
}

class CategoriesService extends HttpService<Category> {
  const CategoriesService()
      : super(
      route: 'categories',
      castFunction: Category.fromJSON);
}

class ClientsService extends HttpService<Client> {
  const ClientsService()
      : super(
      route: 'clients',
      castFunction: Client.fromJSON);
}

class ReceiptsService extends HttpService<Receipt> {
  const ReceiptsService()
      : super(
      route: 'receipts',
      castFunction: Receipt.fromJSON);
}