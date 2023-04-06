import 'package:zlagoda_frontend/src/services/auth/user.dart';

import 'model/basic_models/employee.dart';

void main() {
  const employeeJSON = {
    'employeeId': '1',
    'name': {
      'firstName': 'Kateryna',
      'middleName': 'Ihorivna',
      'lastName': 'Verkhohliad'
    },
    'login': 'kathryn',
    'position': 'manager',
    'salary': 20000,
    'workStartDate': 1680530056,
    'birthDate': 1680530059,
    'phone': '+380971656624',
    'address': {
      'city': 'Kyiv',
      'street': 'Street',
      'index': '44-444'
    }
  };

  final employee = Employee.fromJson(employeeJSON);

  print(employee == null ? employee : employee.toJson());

  const userJson = {
    'userId': '1',
    'login': 'kathryn',
    'name': {
      'firstName': 'Kateryna',
      'middleName': 'Ihorivna',
      'lastName': 'Verkhohliad'
    },
    'position': 'manager',
  };

  final user = User.fromJSON(userJson);

  print(user == null ? user : user.toJson());
}