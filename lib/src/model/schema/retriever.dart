import 'extractors.dart';

typedef FieldGetter<R, O> = R Function(O);

class Retriever<R, O> {
  final String fieldName;
  final FieldGetter<R, O> fieldGetter;
  final String? labelCaption;
  final FieldDisplayMode fieldDisplayMode;

  const Retriever(
    this.fieldName,
    this.fieldGetter, {
    this.labelCaption,
    this.fieldDisplayMode = FieldDisplayMode.everywhere,
  });

  Symbol get symbol => Symbol(fieldName);

  bool get isShownOnIndividualPage => labelCaption != null;

  /// [FieldDisplayMode.everywhere] has no effect if the [labelCaption] is null.
  bool get isShownInTable =>
      isShownOnIndividualPage && fieldDisplayMode == FieldDisplayMode.everywhere;

  Extractor<R> get extractor => makeExtractor<R>();

  bool get nullable => null is R;
}

enum FieldDisplayMode {
  everywhere,
  inModelView;
}
