//import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../common_models/address.dart';
import '../common_models/name.dart';
import '../interfaces/model.dart';
import '../interfaces/serializable.dart';
import '../schema/enum_constraints.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';

enum Position implements Serializable {
  cashier('Касир'),
  manager('Менеджер');

  final String caption;

  const Position(this.caption);

  @override
  String toJson() => name;

  @override
  String toString() => caption;
}

class Employee extends Model {
//class Employee extends Model implements ConvertibleToRow {
  static final Schema<Employee> schema = Schema(
    Employee.new,
    [
      FieldDescription<String, Employee>(
        'employeeId',
        (o) => o.employeeId,
        labelCaption: 'Табельний номер',
      ),
      FieldDescription<String, Employee>(
        'login',
        (o) => o.login,
        labelCaption: 'Логін',
        fieldDisplayMode: FieldDisplayMode.inModelView,
      ),
      FieldDescription<Name, Employee>(
        'employeeName',
        (o) => o.employeeName,
        labelCaption: 'Ім\'я',
        fieldType: FieldType.auto,
      ),
      FieldDescription<Position, Employee>.enumType(
        'position',
        (o) => o.position,
        labelCaption: 'Посада',
        enumConstraint: const EnumConstraint(Position.values),
      ),
      FieldDescription<int, Employee>(
        'salary',
        (o) => o.salary,
        labelCaption: 'Зарплатня',
        fieldType: FieldType.currency,
        fieldDisplayMode: FieldDisplayMode.inModelView,
      ),
      FieldDescription<DateTime, Employee>(
        'workStartDate',
        (o) => o.workStartDate,
        labelCaption: 'Дата початку роботи',
        fieldType: FieldType.date,
        fieldDisplayMode: FieldDisplayMode.inModelView,
      ),
      FieldDescription<DateTime, Employee>(
        'birthDate',
        (o) => o.birthDate,
        labelCaption: 'Дата народження',
        fieldType: FieldType.date,
        fieldDisplayMode: FieldDisplayMode.inModelView,
      ),
      FieldDescription<String, Employee>(
        'phone',
        (o) => o.phone,
        labelCaption: 'Телефон',
        fieldDisplayMode: FieldDisplayMode.inModelView,
      ),
      FieldDescription<Address, Employee>(
        'address',
        (o) => o.address,
        labelCaption: 'Адреса проживання',
        fieldType: FieldType.auto,
        fieldDisplayMode: FieldDisplayMode.inModelView,
      ),
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
