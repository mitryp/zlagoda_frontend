import '../../typedefs.dart';
import '../interfaces/serializable.dart';
import 'retriever.dart';

class Schema<O> {
  final Function classConstructor;
  final List<Retriever<dynamic, O>> retrievers;

  const Schema(this.classConstructor, this.retrievers);

  O? fromJson(JsonMap json) {
    final namedArgs = <Symbol, dynamic>{};

    for (final retriever in retrievers) {
      final retrievedValue =
      retriever.extractor.extractFrom(json, retriever.fieldName);

      if (retriever.nullable || retrievedValue != null)
        namedArgs[retriever.symbol] = retrievedValue;
      else
        return null;
    }

    return Function.apply(classConstructor, null, namedArgs);
  }

  JsonMap toJson(O object) {
    final json = <String, dynamic>{};

    for (final retriever in retrievers) {
      final field = retriever.fieldName;
      final retrievedValue = retriever.fieldGetter(object);

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
}