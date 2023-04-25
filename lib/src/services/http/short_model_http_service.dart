import 'package:http/http.dart' as http;

import '../../model/interfaces/search_model.dart';
import '../../model/search_models/short_category.dart';
import '../../model/search_models/short_cashier.dart';
import '../../model/search_models/short_product.dart';
import '../../utils/json_decode.dart';
import 'http_service_helper.dart';

class ShortModelHttpService<SM extends ShortModel> {
  static const String baseRoute = 'localhost:5000';

  final String route;
  final JsonCastFunction<SM> castFunction;

  const ShortModelHttpService({required route, required this.castFunction})
      : route = 'api/$route/short';

  Future<List<SM>> get() async {
    final response = await makeRequest(
      HttpMethod.get,
      Uri.http(baseRoute, route),
    ).catchError((err) => http.Response(err.message, 503));

    return httpServiceController(response, (response) {
      return decodeResponseBody<List<dynamic>>(response)
          .map((m) => castFunction(m))
          .where((e) => e != null)
          .toList()
          .cast<SM>();
    });
  }
}


/*
  Concrete implementations
 */

class ShortCategoryService extends ShortModelHttpService<ShortCategory> {
  const ShortCategoryService()
      : super(route: 'categories', castFunction: ShortCategory.fromJson);
}

class ShortProductService extends ShortModelHttpService<ShortProduct> {
  const ShortProductService()
      : super(route: 'products', castFunction: ShortProduct.fromJson);
}

class ShortCashierService extends ShortModelHttpService<ShortCashier> {
  const ShortCashierService()
      : super(route: 'cashiers', castFunction: ShortCashier.fromJson);
}