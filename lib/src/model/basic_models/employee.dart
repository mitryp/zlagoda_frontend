import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/navigation.dart';
import '../../utils/value_status.dart';
import '../common_models/address.dart';
import '../common_models/name.dart';
import '../interfaces/convertible_to_pdf.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../interfaces/serializable.dart';
import '../schema/date_constraints.dart';
import '../schema/enum_constraints.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';
import '../schema/validators.dart';
import '../search_models/short_cashier.dart';

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

class Employee extends Model with ConvertibleToRow<Employee>, ConvertibleToPdf<Employee> {
  static final Schema<Employee> schema = Schema(
    Employee.new,
    [
      FieldDescription<String, Employee>(
        'employeeId',
        (o) => o.employeeId,
        labelCaption: 'Табельний номер',
        validator: hasLength(10),
      ),
      FieldDescription<Name, Employee>.serializable(
        'employeeName',
        (o) => o.employeeName,
        labelCaption: 'Ім\'я',
        serializableEditorBuilder: nameEditorBuilder,
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
        validator: isDouble,
      ),
      FieldDescription<DateTime, Employee>(
        'workStartDate',
        (o) => o.workStartDate,
        labelCaption: 'Дата початку роботи',
        fieldType: FieldType.date,
        dateConstraints: const DateConstraints(
          toFirstDate: Duration(days: 365 * 100),
          toLastDate: Duration(),
        ),
        fieldDisplayMode: FieldDisplayMode.inModelView,
      ),
      FieldDescription<DateTime, Employee>(
        'birthDate',
        (o) => o.birthDate,
        labelCaption: 'Дата народження',
        fieldType: FieldType.date,
        dateConstraints: DateConstraints(
          toFirstDate: const Duration(days: 365 * 100),
          toLastDate: () {
            final now = DateTime.now();
            return Duration(days: now.copyWith(year: now.year - 18).difference(now).inDays.abs());
          }(),
        ),
        fieldDisplayMode: FieldDisplayMode.inModelView,
      ),
      FieldDescription<String, Employee>(
        'phone',
        (o) => o.phone,
        labelCaption: 'Телефон',
        fieldDisplayMode: FieldDisplayMode.inModelView,
        validator: isPhoneNumber,
      ),
      FieldDescription<Address, Employee>.serializable(
        'address',
        (o) => o.address,
        labelCaption: 'Адреса проживання',
        serializableEditorBuilder: addressEditorBuilder,
        fieldDisplayMode: FieldDisplayMode.inModelView,
      ),
      FieldDescription<String, Employee>(
        'login',
            (o) => o.login,
        labelCaption: 'Логін',
        fieldDisplayMode: FieldDisplayMode.inModelView,
        validator: notEmpty,
      ),
      FieldDescription<String?, Employee>(
        'password',
        (o) => o.password,
        labelCaption: 'Пароль',
        fieldType: FieldType.password,
        fieldDisplayMode: FieldDisplayMode.whenEditing,
      )
    ],
  );

  final String employeeId;
  final Name employeeName;
  final Position position;
  final int salary;
  final DateTime workStartDate;
  final DateTime birthDate;
  final String phone;
  final Address address;

  final String login;
  final String? password;

  const Employee({
    required this.employeeId,
    required this.employeeName,
    required this.position,
    required this.salary,
    required this.workStartDate,
    required this.birthDate,
    required this.phone,
    required this.address,
    required this.login,
    this.password,
  });

  static Employee? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  get primaryKey => employeeId;

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  Future<ValueStatusWrapper> redirectToModelView(BuildContext context) =>
      AppNavigation.of(context).toModelView<Employee>(primaryKey);

  @override
  ShortCashier toSearchModel() =>
      ShortCashier(primaryKey: employeeId, descriptiveAttr: '$employeeId ${employeeName.fullName}');

  @override
  List<dynamic> get pdfRow =>
    schema.fields
        .sublist(0, schema.fields.length - 2)
        .map((field) => field.fieldGetter(this)).toList();
}
