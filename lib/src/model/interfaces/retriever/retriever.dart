import '../../../typedefs.dart';
import '../serializable.dart';
import 'extractors.dart';

class Retriever<T, S extends Serializable> {
  final String field;
  final T Function(S) getter;
  final bool optional;

  const Retriever({
    required this.field,
    required this.getter,
    this.optional = false,
  });

  T? retrieveFrom(JsonMap json) =>
      JsonExtractorFactory.getExtractor<T>().extractFrom(json, field);
}
