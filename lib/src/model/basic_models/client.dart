import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/navigation.dart';
import '../common_models/address.dart';
import '../common_models/name.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';
import '../schema/validators.dart';

class Client extends Model with ConvertibleToRow<Client> {
  static final Schema<Client> schema = Schema(
    Client.new,
    [
      FieldDescription<String, Client>(
        'clientId',
        (o) => o.clientId,
        labelCaption: 'Номер картки покупця',
        validator: hasLength(14),
      ),
      FieldDescription<Name, Client>(
        'clientName',
        (o) => o.clientName,
        labelCaption: "Ім'я клієнта",
        fieldType: FieldType.serializable,
      ),
      FieldDescription<String, Client>(
        'phone',
        (o) => o.phone,
        labelCaption: 'Номер телефону',
        validator: notEmpty,
      ),
      FieldDescription<Address?, Client>(
        'address',
        (o) => o.address,
        labelCaption: 'Адреса',
        fieldType: FieldType.serializable,
      ),
      FieldDescription<int, Client>(
        'discount',
        (o) => o.discount,
        labelCaption: 'Знижка (%)',
        fieldType: FieldType.number,
        validator: isInteger,
      ),
    ],
  );

  final String clientId;
  final Name clientName;
  final String phone;
  final Address? address;
  final int discount;

  const Client({
    required this.clientId,
    required this.clientName,
    required this.phone,
    this.address,
    required this.discount,
  });

  static Client? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  get primaryKey => clientId;

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  void redirectToModelView(BuildContext context) =>
      AppNavigation.of(context).toModelView<Client>(primaryKey);
}
