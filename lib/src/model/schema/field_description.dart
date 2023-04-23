import 'package:flutter/cupertino.dart';

import '../interfaces/serializable.dart';
import '../model_reference.dart';
import 'date_constraints.dart';
import 'enum_constraints.dart';
import 'extractors.dart';
import 'field_type.dart';
import 'validators.dart';

typedef FieldGetter<R, O> = R Function(O);

String? _noValidation(_) => null;

typedef SerializableFieldEditor<S extends Serializable> = Future<S> Function(
  BuildContext context,
  S? serializable,
);

class FieldDescription<R, O> {
  final String fieldName;
  final FieldGetter<R, O> fieldGetter;
  final String labelCaption;
  final FieldDisplayMode fieldDisplayMode;
  final bool isEditable;
  final FieldValidator validator;
  final FieldType fieldType;
  final EnumConstraint? enumConstraint;
  final SerializableFieldEditor? serializableEditorBuilder;
  final DateConstraints? dateConstraints;
  final ForeignKey? defaultForeignKey;

  const FieldDescription(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    this.enumConstraint,
    this.fieldDisplayMode = FieldDisplayMode.everywhere,
    this.isEditable = true,
    this.validator = _noValidation,
    this.fieldType = FieldType.text,
    this.serializableEditorBuilder,
    this.dateConstraints,
    this.defaultForeignKey,
  }) : assert(fieldType != FieldType.date || dateConstraints != null);

  const FieldDescription.stringForeignKey(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    required this.defaultForeignKey,
    this.fieldDisplayMode = FieldDisplayMode.inModelView,
    this.isEditable = true,
  })  : enumConstraint = null,
        validator = _noValidation,
        fieldType = FieldType.stringForeignKey,
        serializableEditorBuilder = null,
        dateConstraints = null;

  const FieldDescription.intForeignKey(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    required this.defaultForeignKey,
    this.fieldDisplayMode = FieldDisplayMode.inModelView,
    this.isEditable = true,
  })  : enumConstraint = null,
        validator = _noValidation,
        fieldType = FieldType.intForeignKey,
        serializableEditorBuilder = null,
        dateConstraints = null;

  const FieldDescription.enumType(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    required EnumConstraint this.enumConstraint,
    this.fieldDisplayMode = FieldDisplayMode.everywhere,
    this.isEditable = true,
  })  : validator = _noValidation,
        fieldType = FieldType.constrainedToEnum,
        serializableEditorBuilder = null,
        dateConstraints = null,
        defaultForeignKey = null;

  const FieldDescription.serializable(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    required this.serializableEditorBuilder,
    this.fieldDisplayMode = FieldDisplayMode.everywhere,
  })  : fieldType = FieldType.serializable,
        isEditable = true,
        enumConstraint = null,
        validator = _noValidation,
        dateConstraints = null,
        defaultForeignKey = null;

  Symbol get symbol => Symbol(fieldName);

  bool get isShownOnIndividualPage =>
      fieldDisplayMode != FieldDisplayMode.whenEditing && fieldDisplayMode != FieldDisplayMode.none;

  /// [FieldDisplayMode.everywhere] has no effect if the [labelCaption] is null.
  bool get isShownInTable => fieldDisplayMode == FieldDisplayMode.everywhere;

  Extractor<R> get extractor => makeExtractor<R>();

  bool get isNullable => null is R;

  Type get returnType => R;

  String presentFieldOf(O object) {
    final value = fieldGetter(object);
    return fieldType.presentation(value);
  }

  bool get isOwnProperty =>
      fieldType != FieldType.stringForeignKey && fieldType != FieldType.intForeignKey;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldDescription &&
          runtimeType == other.runtimeType &&
          fieldName == other.fieldName &&
          fieldGetter == other.fieldGetter &&
          labelCaption == other.labelCaption &&
          fieldDisplayMode == other.fieldDisplayMode &&
          isEditable == other.isEditable &&
          validator == other.validator &&
          fieldType == other.fieldType &&
          enumConstraint == other.enumConstraint &&
          serializableEditorBuilder == other.serializableEditorBuilder &&
          dateConstraints == other.dateConstraints &&
          defaultForeignKey == other.defaultForeignKey;

  @override
  int get hashCode =>
      fieldName.hashCode ^
      fieldGetter.hashCode ^
      labelCaption.hashCode ^
      fieldDisplayMode.hashCode ^
      isEditable.hashCode ^
      validator.hashCode ^
      fieldType.hashCode ^
      enumConstraint.hashCode ^
      serializableEditorBuilder.hashCode ^
      dateConstraints.hashCode ^
      defaultForeignKey.hashCode;

  @override
  String toString() {
    return 'Field "$fieldName" of class $O';
  }
}

enum FieldDisplayMode {
  everywhere,
  inModelView,
  whenEditing,
  none;
}
