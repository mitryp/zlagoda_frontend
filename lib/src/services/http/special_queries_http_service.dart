import '../../model/basic_models/client.dart';
import '../../model/basic_models/employee.dart';
import '../../model/basic_models/receipt.dart';
import '../../model/interfaces/convertible_to_row.dart';
import '../../model/joined_models/product_with_category.dart';
import '../../utils/json_decode.dart';
import '../query_builder/query_builder.dart';
import '../query_builder/sort.dart';
import 'helpers/http_service_helper.dart';

abstract class SpecialQueriesHttpService<R extends ConvertibleToRow<R>> {
  final String route;
  final JsonCastFunction<R> castFunction;

  String makeRoute() => '$baseRoute/$route';

  const SpecialQueriesHttpService({required this.route, required this.castFunction});

  Future<List<R>> baseGet(QueryBuilder queryBuilder) async {
    final response = await makeRequest(
      HttpMethod.get,
      Uri.http(
          baseRoute,
          makeRoute(),
          queryBuilder.queryParams),
    );

    return await httpServiceController(response, (response) {
      return decodeResponseBody<List<dynamic>>(response)
          .map((m) => castFunction(m))
          .where((e) => e != null)
          .toList()
          .cast<R>();
    });
  }
}

class RegularClientsService extends SpecialQueriesHttpService<Client>{
  RegularClientsService(): super(route: 'regularClients', castFunction: Client.fromJson);

  Future<List<Client>> get(int minPurchases) {
    final qb = QueryBuilder(sort: Sort(SortOption.clientSurname));
    qb.addOtherParam('minPurchases', minPurchases);

    return baseGet(qb);
  }
}

class HardworkingCashiersService extends SpecialQueriesHttpService<Employee>{
  HardworkingCashiersService(): super(route: 'hardworkingCashiers', castFunction: Employee.fromJson);

  Future<List<Employee>> get(int minSales) {
    final qb = QueryBuilder(sort: Sort(SortOption.employeeSurname));
    qb.addOtherParam('minSales', minSales);

    return baseGet(qb);
  }
}

class ProfitableProductsService extends SpecialQueriesHttpService<ProductWithCategory>{
  ProfitableProductsService(): super(route: 'profitableProducts', castFunction: ProductWithCategory.fromJson);

  Future<List<ProductWithCategory>> get(int minSum) {
    final qb = QueryBuilder(sort: Sort(SortOption.productName));
    qb.addOtherParam('minSum', minSum);

    return baseGet(qb);
  }
}

class ProductsSoldByAllCashiersService extends SpecialQueriesHttpService<ProductWithCategory>{
  ProductsSoldByAllCashiersService(): super(route: 'productsSoldByAllCashiers', castFunction: ProductWithCategory.fromJson);

  Future<List<ProductWithCategory>> get() {
    final qb = QueryBuilder(sort: Sort(SortOption.productName));

    return baseGet(qb);
  }
}

class ProductsBoughtByAllClientsService extends SpecialQueriesHttpService<ProductWithCategory>{
  ProductsBoughtByAllClientsService(): super(route: 'productsBoughtByAllClients', castFunction: ProductWithCategory.fromJson);

  Future<List<ProductWithCategory>> get() {
    final qb = QueryBuilder(sort: Sort(SortOption.productName));

    return baseGet(qb);
  }
}

class ReceiptsWithAllCategoriesService extends SpecialQueriesHttpService<Receipt>{
  ReceiptsWithAllCategoriesService(): super(route: 'receiptsWithAllCategories', castFunction: Receipt.fromJson);

  Future<List<Receipt>> get() {
    final qb = QueryBuilder(sort: Sort(SortOption.productName));

    return baseGet(qb);
  }
}