import './retriever/retriever.dart';

import 'model.dart';

typedef Schema<S extends Serializable> = List<Retriever<dynamic, S>>;

abstract class Serializable {
  dynamic toJson();
}

dynamic convertToJson<S extends Serializable>(
  Schema<S> schema,
  S serializable,
) {
  var json = <String, dynamic>{};

  for (final retriever in schema) {
    final field = retriever.field;
    final value = retriever.getter(serializable);

    json[field] = value is Serializable
        ? value.toJson()
        : value is DateTime
            ? value.millisecondsSinceEpoch
            : value;
  }

  return json;
}
