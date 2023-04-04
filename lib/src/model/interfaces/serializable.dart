import '../../typedefs.dart';
import 'model.dart';

typedef Schema = List<Retriever>;

JsonMap convertToJSON(Schema schema, Model model) {
  final json = <String, dynamic>{};

  for (final retriever in schema) {
    final field = retriever.field;
    final value = retriever.getter(model);

    if (value is Model) {
      json[field] = value.toJSON();
    } else if (value is Enum) {
      json[field] = value.name;
    } else {
      json[field] = value;
    }
  }

  return json;
}

abstract class Serializable {
  Map<String, dynamic> toJSON();
}