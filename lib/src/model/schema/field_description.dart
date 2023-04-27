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

typedef TransitiveFieldPresentation<T> = String Function(T);

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
  final TransitiveFieldPresentation<R>? transitiveFieldPresentation;
  final ForeignKeyOptionality? foreignKeyOptionality;

  const FieldDescription(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    this.fieldDisplayMode = FieldDisplayMode.everywhere,
    this.isEditable = true,
    this.validator = _noValidation,
    this.fieldType = FieldType.text,
    this.dateConstraints,
  })  : enumConstraint = null,
        defaultForeignKey = null,
        serializableEditorBuilder = null,
        transitiveFieldPresentation = null,
        foreignKeyOptionality = null,
        assert(fieldType != FieldType.transitive),
        assert(fieldType != FieldType.constrainedToEnum),
        assert(fieldType != FieldType.serializable),
        assert(fieldType != FieldType.intForeignKey && fieldType != FieldType.stringForeignKey),
        assert(fieldType != FieldType.date || dateConstraints != null);

  const FieldDescription.stringForeignKey(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    required ForeignKey this.defaultForeignKey,
    this.fieldDisplayMode = FieldDisplayMode.inModelView,
    this.isEditable = true,
    this.foreignKeyOptionality = ForeignKeyOptionality.required,
  })  : enumConstraint = null,
        validator = _noValidation,
        fieldType = FieldType.stringForeignKey,
        serializableEditorBuilder = null,
        dateConstraints = null,
        transitiveFieldPresentation = null;

  const FieldDescription.intForeignKey(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    required ForeignKey this.defaultForeignKey,
    this.fieldDisplayMode = FieldDisplayMode.inModelView,
    this.isEditable = true,
    this.foreignKeyOptionality = ForeignKeyOptionality.required,
  })  : enumConstraint = null,
        validator = _noValidation,
        fieldType = FieldType.intForeignKey,
        serializableEditorBuilder = null,
        dateConstraints = null,
        transitiveFieldPresentation = null;

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
        foreignKeyOptionality = null,
        dateConstraints = null,
        defaultForeignKey = null,
        transitiveFieldPresentation = null;

  const FieldDescription.serializable(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    required SerializableFieldEditor this.serializableEditorBuilder,
    this.fieldDisplayMode = FieldDisplayMode.everywhere,
  })  : fieldType = FieldType.serializable,
        isEditable = true,
        enumConstraint = null,
        foreignKeyOptionality = null,
        validator = _noValidation,
        dateConstraints = null,
        defaultForeignKey = null,
        transitiveFieldPresentation = null;

  const FieldDescription.transitive(
    this.fieldName,
    this.fieldGetter, {
    required this.labelCaption,
    required this.transitiveFieldPresentation,
    this.fieldDisplayMode = FieldDisplayMode.everywhere,
  })  : fieldType = FieldType.transitive,
        isEditable = false,
        foreignKeyOptionality = null,
        enumConstraint = null,
        validator = _noValidation,
        dateConstraints = null,
        defaultForeignKey = null,
        serializableEditorBuilder = null;

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

    if (value == null) {
      return 'немає даних';
    }

    if (fieldType == FieldType.transitive) {
      return transitiveFieldPresentation!(value);
    }

    return fieldType.presentation(value);
  }

  bool get isForeignKey =>
      fieldType == FieldType.stringForeignKey || fieldType == FieldType.intForeignKey;

  bool get isOwnProperty => !isForeignKey && fieldType != FieldType.transitive;

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

enum ForeignKeyOptionality {
  optional,
  required;
}
