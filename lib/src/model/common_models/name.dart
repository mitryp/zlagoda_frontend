import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../view/widgets/resources/serializable_editor_popup.dart';
import '../interfaces/serializable.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class Name implements Serializable {
  final String firstName;
  final String? middleName;
  final String lastName;

  static final Schema<Name> schema = Schema(
    Name.new,
    [
      FieldDescription<String, Name>(
        'firstName',
        (o) => o.firstName,
        labelCaption: 'Ім\'я',
      ),
      FieldDescription<String?, Name>(
        'middleName',
        (o) => o.middleName,
        labelCaption: 'По батькові',
      ),
      FieldDescription<String, Name>(
        'lastName',
        (o) => o.lastName,
        labelCaption: 'Прізвище',
      ),
    ],
  );

  const Name({
    required this.firstName,
    this.middleName,
    required this.lastName,
  });

  String get fullName => '$lastName $firstName${middleName != null ? ' $middleName' : ''}';

  @override
  String toString() => fullName;

  @override
  JsonMap toJson() => schema.toJson(this);

  static Name? fromJson(JsonMap json) => schema.fromJson(json);
}

Future<Name> nameEditorBuilder(BuildContext context, Serializable? initialName) {
  final initial = initialName as Name? ??
      const Name(
        firstName: '',
        lastName: '',
      );

  return showSerializableEditor<Name>(context, initial).then((v) => v ?? initial);
}
