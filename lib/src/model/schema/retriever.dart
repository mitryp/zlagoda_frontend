import 'extractors.dart';

typedef FieldGetter<R, O> = R Function(O);

class Retriever<R, O> {
  final String fieldName;
  final FieldGetter<R, O> fieldGetter;
  final String? labelCaption;

  const Retriever(this.fieldName, this.fieldGetter, {this.labelCaption});

  Symbol get symbol => Symbol(fieldName);

  bool get isShownOnIndividualPage => labelCaption != null;

  Extractor<R> get extractor => makeExtractor<R>();

  bool get nullable => null is R;
}
