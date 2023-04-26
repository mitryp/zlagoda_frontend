import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/navigation.dart';
import '../../utils/value_status.dart';
import '../common_models/address.dart';
import '../common_models/name.dart';
import '../interfaces/convertible_to_pdf.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';
import '../schema/validators.dart';
import '../search_models/short_client.dart';

class Client extends Model with ConvertibleToRow<Client>, ConvertibleToPdf<Client> {
  static final Schema<Client> schema = Schema(
    Client.new,
    [
      FieldDescription<String, Client>(
        'clientId',
        (o) => o.clientId,
        labelCaption: 'Номер картки покупця',
        validator: hasLength(13),
      ),
      FieldDescription<Name, Client>.serializable(
        'clientName',
        (o) => o.clientName,
        labelCaption: "Ім'я клієнта",
        serializableEditorBuilder: nameEditorBuilder,
      ),
      FieldDescription<String, Client>(
        'phone',
        (o) => o.phone,
        labelCaption: 'Номер телефону',
        validator: isPhoneNumber,
      ),
      FieldDescription<Address?, Client>.serializable(
        'address',
        (o) => o.address,
        labelCaption: 'Адреса',
        serializableEditorBuilder: addressEditorBuilder,
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
  Future<ValueStatusWrapper> redirectToModelView(BuildContext context) =>
      AppNavigation.of(context).toModelView<Client>(primaryKey);

  @override
  ShortClient toSearchModel() =>
      ShortClient(primaryKey: clientId, descriptiveAttr: '$clientId ${clientName.fullName}');
}
