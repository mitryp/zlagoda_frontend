import 'extractors.dart';

// class Retriever<T, S extends Serializable> {
//   final String field;
//   final T Function(S) getter;
//   final bool nullable;
//
//   const Retriever({
//     required this.field,
//     required this.getter,
//     this.nullable = false,
//   });
//
//   T? retrieveFrom(JsonMap json) =>
//       JsonExtractorFactory.getExtractor<T>().extractFrom(json, field);
//
// }

typedef FieldGetter<R, O> = R Function(O);

class Retriever<R, O> {
  final String fieldName;
  final FieldGetter<R, O> fieldGetter;
  final String? labelCaption;

  const Retriever(this.fieldName, this.fieldGetter,
      {this.labelCaption});

  Symbol get symbol => Symbol(fieldName);

  bool get isShownOnIndividualPage => labelCaption != null;

  Extractor<R> get extractor => makeExtractor<R>();

  bool get nullable => null is R;
}

