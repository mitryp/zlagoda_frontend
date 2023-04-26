import '../../typedefs.dart';
import '../interfaces/serializable.dart';
import 'field_description.dart';
import 'field_type.dart';

class Schema<O> {
  final Function classConstructor;
  final List<FieldDescription<dynamic, O>> fields;

  const Schema(this.classConstructor, this.fields);

  O? fromJson(JsonMap json) {
    final namedArgs = <Symbol, dynamic>{};

    for (final field in fields) {
      if (field.fieldType == FieldType.transitive) continue;
      final retrievedValue = field.extractor.extractFrom(json, field.fieldName);

      if (field.isNullable || retrievedValue != null)
        namedArgs[field.symbol] = retrievedValue;
      else
        return null;
    }

    return Function.apply(classConstructor, null, namedArgs);
  }

  JsonMap toJson(O object) {
    final json = <String, dynamic>{};

    for (final retriever in fields) {
      final field = retriever.fieldName;
      final retrievedValue = retriever.fieldGetter(object);

      json[field] = processValue(retrievedValue);
    }

    return json;
  }

  static processValue(dynamic value) {
    if (value is Serializable) return value.toJson();
    if (value is List) return value.map(processValue);
    if (value is DateTime) return value.millisecondsSinceEpoch ~/ 1000;

    return value;
  }
}
