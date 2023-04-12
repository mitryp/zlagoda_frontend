import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../common_models/name.dart';
import '../common_models/address.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

class Client extends Model {
  static final Schema<Client> schema = Schema(
    Client.new,
    [
      Retriever<String, Client>('clientId', (o) => o.clientId),
      Retriever<Name, Client>('clientName', (o) => o.clientName),
      Retriever<String, Client>('phone', (o) => o.phone),
      Retriever<Address?, Client>('address', (o) => o.address),
      Retriever<int, Client>('discount', (o) => o.discount),
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

  // @override
  // DataRow buildRow(BuildContext context) {
  //   final List<String> cellsText = [
  //     clientId,
  //     clientName.fullName,
  //     discount.toString(),
  //   ];
  //
  //   return buildRowFromFields(context, cellsText);
  // }
}
