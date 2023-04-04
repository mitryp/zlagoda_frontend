import '../../typedefs.dart';
import '../interfaces/serializable.dart';

typedef JsonExtractor<T> = T Function(String field, JsonMap json);

class Retriever<T, M extends Model> {
  final String field;
  final JsonExtractor<T> _jsonExtractor;
  final T Function(M) getter;

  const Retriever(
      {required this.field,
        required JsonExtractor<T> fromJSON,
        required this.getter})
      : _jsonExtractor = fromJSON;

  T extractFrom(JsonMap json) => _jsonExtractor(field, json);
}

abstract class Model implements Serializable{
  const Model();

  dynamic get primaryKey;

  JsonMap flatValues(Schema schema, JsonMap json) {
    final values = <String, dynamic>{};

    for (final retriever in schema) {
      values[retriever.field] = retriever.extractFrom(json);
    }

    return values;
  }
}
