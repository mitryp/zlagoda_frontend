//import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/model.dart';
import '../interfaces/serializable.dart';
import '../common_models/name.dart';
import '../common_models/address.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

enum Position implements Serializable {
  cashier,
  manager;

  const Position();

  @override
  String toJson() => name;
}

class Employee extends Model {
//class Employee extends Model implements ConvertibleToRow {
  static final Schema<Employee> schema = Schema(
    Employee.new,
    [
      Retriever<String, Employee>('employeeId', (o) => o.employeeId),
      Retriever<String, Employee>('login', (o) => o.login),
      Retriever<Name, Employee>('employeeName', (o) => o.employeeName),
      Retriever<Position, Employee>('position', (o) => o.position),
      Retriever<int, Employee>('salary', (o) => o.salary),
      Retriever<DateTime, Employee>('workStartDate', (o) => o.workStartDate),
      Retriever<DateTime, Employee>('birthDate', (o) => o.birthDate),
      Retriever<String, Employee>('phone', (o) => o.phone),
      Retriever<Address, Employee>('address', (o) => o.address),
    ],
  );

  final String employeeId;
  final String login;
  final Name employeeName;
  final Position position;
  final int salary;
  final DateTime workStartDate;
  final DateTime birthDate;
  final String phone;
  final Address address;

  const Employee({
    required this.employeeId,
    required this.login,
    required this.employeeName,
    required this.position,
    required this.salary,
    required this.workStartDate,
    required this.birthDate,
    required this.phone,
    required this.address,
  });

  static Employee? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  get primaryKey => employeeId;

  @override
  JsonMap toJson() => schema.toJson(this);

// @override
// DataRow buildRow(BuildContext context) {
//   final List<String> cellsText = [
//     name.fullName,
//     position.toString(),
//     phone,
//     address.fullAddress
//   ];
//
//   return buildRowFromFields(context, cellsText);
// }
}
