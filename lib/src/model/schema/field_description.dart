import '../model_reference.dart';
import 'enum_constraints.dart';
import 'extractors.dart';
import 'field_type.dart';

typedef FieldGetter<R, O> = R Function(O);
typedef FieldValidator = String? Function(String?);

String? _noValidation(_) => null;

class FieldDescription<R, O> {
  final String fieldName;
  final FieldGetter<R, O> fieldGetter;
  final String labelCaption;
  final FieldDisplayMode fieldDisplayMode;
  final bool isEditable;
  final FieldValidator validator;
  final FieldType fieldType;
  final EnumConstraint? enumConstraint;
  final ForeignKey? defaultForeignKey;
  // final R

  const FieldDescription(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    this.enumConstraint,
    this.fieldDisplayMode = FieldDisplayMode.everywhere,
    this.isEditable = true,
    this.validator = _noValidation,
    this.fieldType = FieldType.text,
    this.defaultForeignKey,
  })  : assert(fieldType != FieldType.constrainedToEnum || enumConstraint != null),
        assert(fieldType != FieldType.foreignKey || defaultForeignKey != null);

  const FieldDescription.foreignKey(
    this.fieldName,
    this.fieldGetter, {
    required ForeignKey this.defaultForeignKey,
    required this.labelCaption,
    this.fieldDisplayMode = FieldDisplayMode.inModelView,
    this.isEditable = true,
  })  : enumConstraint = null,
        validator = _noValidation,
        fieldType = FieldType.foreignKey;

  const FieldDescription.enumType(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    required EnumConstraint this.enumConstraint,
    this.fieldDisplayMode = FieldDisplayMode.everywhere,
    this.isEditable = true,
  })  : validator = _noValidation,
        fieldType = FieldType.constrainedToEnum,
        defaultForeignKey = null;

  Symbol get symbol => Symbol(fieldName);

  bool get isShownOnIndividualPage => fieldDisplayMode != FieldDisplayMode.whenEditing;

  /// [FieldDisplayMode.everywhere] has no effect if the [labelCaption] is null.
  bool get isShownInTable => fieldDisplayMode == FieldDisplayMode.everywhere;

  Extractor<R> get extractor => makeExtractor<R>();

  bool get nullable => null is R;

  Type get returnType => R;

  String presentFieldOf(O object) {
    final value = fieldGetter(object);
    return fieldType == FieldType.currency
        ? ((value as int) / 100).toStringAsFixed(2)
        : _typePresentations[value.runtimeType]?.call(value as dynamic) ?? value.toString();
  }

  bool get isOwnProperty => fieldType != FieldType.foreignKey;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldDescription &&
          runtimeType == other.runtimeType &&
          fieldName == other.fieldName &&
          labelCaption == other.labelCaption &&
          fieldDisplayMode == other.fieldDisplayMode &&
          isEditable == other.isEditable &&
          fieldType == other.fieldType &&
          enumConstraint == other.enumConstraint;

  @override
  int get hashCode =>
      fieldName.hashCode ^
      labelCaption.hashCode ^
      fieldDisplayMode.hashCode ^
      isEditable.hashCode ^
      fieldType.hashCode ^
      enumConstraint.hashCode;

  @override
  String toString() {
    return 'Field "$fieldName" of class $O';
  }
}

enum FieldDisplayMode {
  everywhere,
  inModelView,
  whenEditing;
}

final _typePresentations = {
  DateTime: (DateTime dt) => '${dt.day}.${dt.month}.${dt.year}',
};
