import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../common_models/name.dart';
import '../common_models/address.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

class Client extends Model implements ConvertibleToRow {
  static final Schema<Client> schema = [
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

  static Client? fromJson(JsonMap json) {
    final clientJson = retrieveFromJson(schema, json);

    return clientJson == null
        ? null
        : Client(
            clientId: clientJson['clientId'],
            name: clientJson['name'],
            phone: clientJson['phone'],
            address: clientJson['address'],
            discount: clientJson['discount'],
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
      discount.toString(),
    ];

    return buildRowFromFields(context, cellsText);
  }
}
