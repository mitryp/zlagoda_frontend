import 'package:http/http.dart' as http;

import '../../model/other_models/prom_store_product.dart';
import '../../utils/json_decode.dart';
import 'http_service_helper.dart';

String makeRoute(int id) => 'api/store_products/$id/prom}';

PromStoreProduct? _tryDecodeSingleResource(http.Response response) =>
    PromStoreProduct.fromJSON(
        decodeResponseBody<Map<String, dynamic>>(response));

Future<PromStoreProduct?> post(PromStoreProduct row) async {
  final response = await makeRequest(
    HttpMethod.post,
    Uri.http(baseRoute, makeRoute(row.baseStoreProductId)),
    body: row.toJson(),
  ).catchError((err) => http.Response(err.message, 503));

  return httpServiceController(response, _tryDecodeSingleResource);
}

Future<PromStoreProduct?> update(
    PromStoreProduct row, bool controlTotalQuantity) async {
  final response = await makeRequest(
    HttpMethod.patch,
    Uri.http(baseRoute, makeRoute(row.baseStoreProductId)),
    body: {
      ...row.toJson(),
      'controlTotalQuantity': controlTotalQuantity,
    },
  ).catchError((err) => http.Response(err.message, 503));

  return httpServiceController(response, _tryDecodeSingleResource);
}

Future<bool> delete(int id) async {
  final response =
      await makeRequest(HttpMethod.delete, Uri.http(baseRoute, makeRoute(id)))
          .catchError((err) => http.Response(err.message, 503));

  return httpServiceController(
      response, (response) => true, (response) => false);
}
