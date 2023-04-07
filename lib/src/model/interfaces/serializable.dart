

// typedef Schema<S extends Serializable> = List<Retriever<dynamic, S>>;
//
abstract class Serializable {
  dynamic toJson();
}

// JsonMap? retrieveFromJson(Schema schema, JsonMap json) {
//   var values = <String, dynamic>{};
//
//   for (final schema in schema) {
//     final retrievedValue = schema.retrieveFrom(json);
//
//     if (schema.nullable || retrievedValue != null) {
//       values[schema.field] = retrievedValue;
//
//     } else {
//       return null;
//     }
//   }
//
//   return values;
// }
//
// JsonMap convertToJson<S extends Serializable>(
//   Schema<S> schema,
//   S serializable,
// ) {
//   var json = <String, dynamic>{};
//
//   for (final schema in schema) {
//     final field = schema.field;
//     final retrievedValue = schema.getter(serializable);
//
//     if (retrievedValue is Serializable) {
//       json[field] = retrievedValue.toJson();
//     } else if (retrievedValue is DateTime) {
//       json[field] = retrievedValue.millisecondsSinceEpoch;
//     } else {
//       json[field] = retrievedValue;
//     }
//   }
//
//   return json;
// }
