import '../../typedefs.dart';
import './retriever/retriever.dart';

typedef Schema<S extends Serializable> = List<Retriever<dynamic, S>>;

abstract class Serializable {
  dynamic toJson();
}

JsonMap? retrieveFromJson(Schema schema, JsonMap json) {
  var values = <String, dynamic>{};

  for (final retriever in schema) {
    final retrievedValue = retriever.retrieveFrom(json);

    if (retriever.optional || retrievedValue != null) {
      values[retriever.field] = retrievedValue;

    } else {
      return null;
    }
  }

  return values;
}

JsonMap convertToJson<S extends Serializable>(
  Schema<S> schema,
  S serializable,
) {
  var json = <String, dynamic>{};

  for (final retriever in schema) {
    final field = retriever.field;
    final retrievedValue = retriever.getter(serializable);

    if (retrievedValue is Serializable) {
      json[field] = retrievedValue.toJson();
    } else if (retrievedValue is DateTime) {
      json[field] = retrievedValue.millisecondsSinceEpoch;
    } else {
      json[field] = retrievedValue;
    }
  }

  return json;
}
