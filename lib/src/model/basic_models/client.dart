import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../common_models/name.dart';
import '../common_models/address.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

final Schema<Client> schema = [
  Retriever<String, Client>(
    field: 'clientId',
    getter: (client) => client.clientId,
  ),
  Retriever<Name, Client>(
    field: 'name',
    getter: (client) => client.name,
  ),
  Retriever<String, Client>(
    field: 'clientId',
    getter: (client) => client.phone,
  ),
  Retriever<Address, Client>(
    field: 'address',
    getter: (employee) => employee.address,
  ),
  Retriever<int, Client>(
    field: 'discount',
    getter: (client) => client.discount,
  ),
];

class Client extends Model implements ConvertibleToRow {
  final String clientId;
  final Name name;
  final String phone;
  final Address address;
  final int discount;

  const Client({
    required this.clientId,
    required this.name,
    required this.phone,
    required this.address,
    required this.discount,
  });

  factory Client.fromJSON(dynamic json) {
    final values = Model.flatValues(schema, json);

    return Client(
      clientId: values['clientId'],
      name: values['name'],
      phone: values['phone'],
      address: values['address'],
      discount: values['discount'],
    );
  }

  @override
  get primaryKey => clientId;

  @override
  JsonMap toJson() => convertToJson(schema, this);

  @override
  DataRow buildRow(BuildContext context) {
    final List<String> cellsText = [
      clientId,
      name.fullName,
      //phone,
      //address.fullAddress,
      discount.toString(),
    ];

    return buildRowFromFields(context, cellsText);
  }
}