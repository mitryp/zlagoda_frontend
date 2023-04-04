import 'package:flutter/material.dart';

import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../common_models/name.dart';
import '../common_models/address.dart';

class Client extends Model implements ConvertibleToRow {
  final int clientId;
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
    return Client(
      clientId: json['clientId'],
      name: Name(
          firstName: json['name']['firstName'],
          middleName: json['name']['middleName'],
          lastName: json['name']['lastName']),
      phone: json['phone'],
      address: Address(
          city: json['address']['city'],
          street: json['address']['street'],
          index: json['address']['index']
      ),
      discount: json['discount'],
    );
  }

  @override
  get primaryKey => clientId;

  @override
  Map<String, dynamic> toJSON() {
    return {
      'clientId': clientId,
      'name': name.toJSON(),
      'phone': phone,
      'address': address.toJSON(),
      'discount': discount,
    };
  }

  @override
  DataRow buildRow(BuildContext context) {
    final List<String> cellsText = [
      name.fullName,
      phone,
      address.fullAddress,
      discount.toString(),
    ];

    return buildRowFromFields(context, cellsText);
  }
}