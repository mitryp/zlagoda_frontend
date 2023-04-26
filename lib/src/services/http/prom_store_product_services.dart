import 'package:http/http.dart' as http;

import '../../model/basic_models/store_product.dart';
import '../../model/other_models/prom_store_product.dart';
import '../../utils/json_decode.dart';
import 'helpers/http_service_helper.dart';

String makeRoute(int id) => 'api/store_products/$id/prom';

class PromStoreProductService {
  static StoreProduct? _tryDecodeSingleResource(http.Response response) {
    Map<String, dynamic> json;
    // try {
    json = decodeResponseBody<Map<String, dynamic>?>(response) ?? {};
    // } on FormatException {
    //   json = {};
    // } // todo

    return StoreProduct.fromJSON(json);
  }

  static Future<StoreProduct?> post(PromStoreProduct row) async {
    final response = await makeRequest(
      HttpMethod.post,
      Uri.http(baseRoute, makeRoute(row.baseStoreProductId)),
      body: row.toJson(),
    ).catchError((err) => http.Response(err.message, 503));

    return httpServiceController(response, _tryDecodeSingleResource, (response) => null);
  }

  static Future<StoreProduct?> update(PromStoreProduct row, {required bool controlTotalQuantity}) async {
    final response = await makeRequest(
      HttpMethod.patch,
      Uri.http(baseRoute, makeRoute(row.baseStoreProductId)),
      body: {
        ...row.toJson(),
        'controlTotalQuantity': controlTotalQuantity,
      },
    ).catchError((err) => http.Response(err.message, 503));

    return httpServiceController(response, _tryDecodeSingleResource, (response) => null);
  }

  static Future<bool> delete(int id) async {
    final response = await makeRequest(HttpMethod.delete, Uri.http(baseRoute, makeRoute(id)))
        .catchError((err) => http.Response(err.message, 503));

    return httpServiceController(response, (response) => true, (response) => false);
  }

}
