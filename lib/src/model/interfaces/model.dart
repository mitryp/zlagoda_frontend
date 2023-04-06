import '../../typedefs.dart';
import '../interfaces/serializable.dart';

abstract class Model implements Serializable {
  const Model();

  dynamic get primaryKey;

  static JsonMap flatValues(Schema schema, JsonMap json) {
    var values = <String, dynamic>{};

    for (final retriever in schema) {
      values[retriever.field] = retriever.extractFrom(json);
    }

    return values;
  }
}
