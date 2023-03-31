import '../../model/model.dart';
import '../query_builder/query_builder.dart';

typedef JsonCastFunction<M extends Model> = M Function(dynamic json);

// todo @Kate
abstract class HttpService<M extends Model> {
  final QueryBuilder queryBuilder;
  final JsonCastFunction castFunction;

  const HttpService({required this.queryBuilder, required this.castFunction});

  Future<List<M>> get();

  Future<M?> singleById(dynamic id);

  Future<bool> update(M row);

  Future<bool> delete(dynamic id);
}
