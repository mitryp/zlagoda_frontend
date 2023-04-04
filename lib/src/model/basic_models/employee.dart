import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../interfaces/serializable.dart';
import '../common_models/name.dart';
import '../common_models/address.dart';

enum Position { cashier, manager }

class Employee extends Model implements ConvertibleToRow{
  final int employeeId;
  final String login;
  final Name name;
  final Position position;
  final int salary;
  final DateTime workStartDate;
  final DateTime birthDate;
  final String phone;
  final Address address;

  const Employee({
    required this.employeeId,
    required this.login,
    required this.name,
    required this.position,
    required this.salary,
    required this.workStartDate,
    required this.birthDate,
    required this.phone,
    required this.address,
  });

  static final Schema schema = [
    Retriever<int, Employee>(
        field: 'employeeId',
        fromJSON: (field, json) => json[field],
        getter: (employee) => employee.employeeId),
    Retriever<Name, Employee>(
      field: 'name',
      fromJSON: (field, json) => Name(
          lastName: json[field]['lastName'],
          middleName: json[field]['middleName'],
          firstName: json[field]['firstName']),
      getter: (employee) => employee.name,
    ),
    Retriever<Position, Employee>(
        field: 'position',
        fromJSON: (field, json) =>
            Position.values.firstWhere((e) => e.name == json[field]),
        getter: (employee) => employee.position),
    Retriever<int, Employee>(
        field: 'salary',
        fromJSON: (field, json) => json[field],
        getter: (employee) => employee.salary),
    Retriever<DateTime, Employee>(
        field: 'workStartDate',
        fromJSON: (field, json) => DateTime.parse(json[field].toString()),
        getter: (employee) => employee.workStartDate),
    Retriever<DateTime, Employee>(
        field: 'birthDate',
        fromJSON: (field, json) => DateTime.parse(json[field].toString()),
        getter: (employee) => employee.birthDate),
    Retriever<String, Employee>(
        field: 'phone',
        fromJSON: (field, json) => json[field],
        getter: (employee) => employee.phone),
    Retriever<Address, Employee>(
        field: 'address',
        fromJSON: (field, json) => Address(
            city: json[field]['city'],
            street: json[field]['street'],
            index: json[field]['index']),
        getter: (employee) => employee.address),
  ];

  factory Employee.fromJSON(dynamic json) {
    final values = <String, dynamic>{};
    for (final retriever in schema) {
      values[retriever.field] = retriever.extractFrom(json);
    }
    return Employee(
      employeeId: values['employeeId'],
      login: values['login'],
      name: values['name'],
      position: values['position'],
      salary: values['salary'],
      workStartDate: values['workStartDate'],
      birthDate: values['birthDate'],
      phone: values['phone'],
      address: values['address'],
    );
  }

  @override
  get primaryKey => employeeId;

  @override
  Map<String, dynamic> toJSON() {
    return convertToJSON(schema, this);
  }

  @override
  DataRow buildRow(BuildContext context) {
    final List<String> cellsText = [
      name.fullName,
      position.toString(),
      salary.toString(),
      workStartDate.toString(),
      birthDate.toString(),
      phone,
      address.fullAddress
    ];

    return buildRowFromFields(context, cellsText);
  }
}
