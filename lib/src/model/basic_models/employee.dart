import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';
import '../common_models/name.dart';
import '../common_models/address.dart';

final Schema<Employee> schema = [
  Retriever<String, Employee>(
    field: 'employeeId',
    getter: (employee) => employee.employeeId,
  ),
  Retriever<String, Employee>(
    field: 'login',
    getter: (employee) => employee.login,
  ),
  Retriever<Name, Employee>(
    field: 'name',
    getter: (employee) => employee.name,
  ),
  Retriever<Position, Employee>(
    field: 'position',
    getter: (employee) => employee.position,
  ),
  Retriever<int, Employee>(
    field: 'salary',
    getter: (employee) => employee.salary,
  ),
  Retriever<DateTime, Employee>(
    field: 'workStartDate',
    getter: (employee) => employee.workStartDate,
  ),
  Retriever<DateTime, Employee>(
    field: 'birthDate',
    getter: (employee) => employee.birthDate,
  ),
  Retriever<String, Employee>(
    field: 'phone',
    getter: (employee) => employee.phone,
  ),
  Retriever<Address, Employee>(
    field: 'address',
    getter: (employee) => employee.address,
  ),
];

enum Position implements Serializable {
  cashier, manager;

  const Position();

  @override
  String toJson() => name;
}

class Employee extends Model implements ConvertibleToRow {
  final String employeeId;
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

  factory Employee.fromJSON(dynamic json) {
    final values = Model.flatValues(schema, json);

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
  JsonMap toJson() => convertToJson(schema, this);

  @override
  DataRow buildRow(BuildContext context) {
    final List<String> cellsText = [
      name.fullName,
      position.toString(),
      //salary.toString(),
      //workStartDate.toString(),
      //birthDate.toString(),
      phone,
      address.fullAddress
    ];

    return buildRowFromFields(context, cellsText);
  }
}
