import 'package:http/http.dart' as http;

import '../../model/basic_models/store_product.dart';
import '../../model/other_models/prom_store_product.dart';
import '../../utils/json_decode.dart';
import 'helpers/http_service_helper.dart';

String _makeRoute(int id) => 'api/store_products/$id/prom';

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
      Uri.http(baseRoute, _makeRoute(row.baseStoreProductId)),
      body: row.toJson(),
    );

    return httpServiceController(response, _tryDecodeSingleResource, (response) => null);
  }

  static Future<StoreProduct?> update(PromStoreProduct row, {required bool controlTotalQuantity}) async {
    final response = await makeRequest(
      HttpMethod.patch,
      Uri.http(baseRoute, _makeRoute(row.baseStoreProductId)),
      body: {
        ...row.toJson(),
        'controlTotalQuantity': controlTotalQuantity,
      },
    );

    return httpServiceController(response, _tryDecodeSingleResource, (response) => null);
  }

  static Future<bool> delete(int id) async {
    final response = await makeRequest(HttpMethod.delete, Uri.http(baseRoute, _makeRoute(id)));

    return httpServiceController(response, (response) => true, (response) => false);
  }

}
