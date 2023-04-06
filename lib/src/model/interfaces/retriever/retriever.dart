import '../../../typedefs.dart';
import '../serializable.dart';
import 'extractors.dart';

class Retriever<T, S extends Serializable> {
  final String field;
  final T Function(S) getter;

  const Retriever({
    required this.field,
    required this.getter,
  });

  T extractFrom(JsonMap json) =>
      JsonExtractorFactory.getExtractor<T>().extractFrom(json, field);
}
