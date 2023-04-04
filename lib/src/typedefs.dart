import 'model/interfaces/model.dart';

typedef FetchFunction = Future<List<dynamic>> Function(dynamic queryBuilder);

typedef JsonMap = Map<String, dynamic>;

// TODO change dynamic into JSON type
typedef JsonModelCast<M extends Model> = M Function(dynamic json);