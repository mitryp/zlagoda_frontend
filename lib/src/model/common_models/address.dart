import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../view/widgets/resources/serializable_editor_popup.dart';
import '../interfaces/serializable.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';
import '../schema/validators.dart';

class Address implements Serializable {
  static final Schema<Address> schema = Schema(
    Address.new,
    [
      FieldDescription<String, Address>(
        'city',
        (o) => o.city,
        labelCaption: 'Місто',
        validator: notEmpty,
      ),
      FieldDescription<String, Address>(
        'street',
        (o) => o.street,
        labelCaption: 'Вулиця',
        validator: notEmpty,
      ),
      FieldDescription<String, Address>(
        'index',
        (o) => o.index,
        labelCaption: 'Поштовий індекс',
        validator: notEmpty,
      ),
    ],
  );

  final String city;
  final String street;
  final String index;

  const Address({
    required this.city,
    required this.street,
    required this.index,
  });

  String get fullAddress => [city, street, index].where((e) => e.isNotEmpty).join(', ');

  @override
  String toString() => fullAddress;

  @override
  JsonMap toJson() => schema.toJson(this);
}

Future<Address> addressEditorBuilder(BuildContext context, Serializable? initialName) {
  final initial = initialName as Address? ??
      const Address(
        city: '',
        street: '',
        index: '',
      );

  return showSerializableEditor<Address>(context, initial).then((v) => v ?? initial);
}
