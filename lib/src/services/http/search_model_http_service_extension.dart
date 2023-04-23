// import 'package:http/http.dart' as http;
//
// import '../../model/interfaces/model.dart';
// import '../../model/model_schema_factory.dart';
// import '../../model/other_models/search_model.dart';
// import '../../utils/json_decode.dart';
// import 'model_http_service.dart';
//

// extension SearchModelHttpServiceExtension<M extends Model, SM extends SearchModel<M>>
//     on ModelHttpService<M> {
//   Future<List<SM>> fetchSearchItems() async {
//     final schema = makeModelSchema<SM>(SM);
//     final response = await http
//         .get(Uri.http(ModelHttpService.baseRoute, makeRoute('/search')))
//         .catchError((err) => http.Response(err.message, 503));
//
//     return httpServiceController(response, (response) {
//       return decodeResponseBody<List<dynamic>>(response)
//           .map((item) => schema.fromJson(item))
//           .where((e) => e != null)
//           .toList()
//           .cast<SM>();
//     });
//   }
// }
