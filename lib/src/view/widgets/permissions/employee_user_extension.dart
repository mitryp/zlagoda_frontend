import '../../../model/basic_models/employee.dart';
import 'user.dart';

extension EmployeeUser on Employee {
  User get user => User(
        // todo change this string to the value
        userId: 'employeeId',
        login: login,
        name: name,
        position: position,
      );
}
