// import '../../model/other_models/prom_store_product.dart';
// import 'http_service_helper.dart';
//
//
//
// Future<PromStoreProduct?> post(PromStoreProduct row) async {
//   final response = await makeRequest(
//     HttpMethod.post,
//     Uri.http(baseRoute, makeRoute()),
//     body: row.toJson(),
//   ).catchError((err) => http.Response(err.message, 503));
//
//   return httpServiceController(response, _tryDecodeSingleResource);
// }
//
// Future<SSingle?> update(SSingle row, dynamic primaryKey) async {
//   final response = await makeRequest(
//     HttpMethod.put,
//     Uri.http(baseRoute, makeRoute(primaryKey)),
//     body: row.toJson(),
//   ).catchError((err) => http.Response(err.message, 503));
//
//   return httpServiceController(response, _tryDecodeSingleResource);
// }
//
// Future<bool> delete(dynamic id) async {
//   final response = await makeRequest(HttpMethod.delete, Uri.http(baseRoute, makeRoute(id)))
//       .catchError((err) => http.Response(err.message, 503));
//
//   return httpServiceController(response, (response) => true, (response) => false);
// }