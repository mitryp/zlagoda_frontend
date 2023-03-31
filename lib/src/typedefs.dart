import 'model/model.dart';

typedef FetchFunction = Future<List<dynamic>> Function(dynamic queryBuilder);

typedef JsonModelCast<M extends Model> = M Function(dynamic json);