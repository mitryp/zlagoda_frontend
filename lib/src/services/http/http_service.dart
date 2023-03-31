import '../../model/model.dart';
import '../query_builder/query_builder.dart';

// todo @Kate
abstract class HttpService<M extends Model> {
  final QueryBuilder queryBuilder;

  const HttpService(this.queryBuilder);

  Future<List<M>> get();

  Future<M?> singleById(dynamic id);

  Future<bool> update(M row);

  Future<bool> delete(dynamic id);
}
