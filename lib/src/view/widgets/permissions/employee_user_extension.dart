import '../../../model/basic_models/employee.dart';
import 'user.dart';

extension EmployeeUser on Employee {
  User get user => User(
        login: login,
        name: name,
        position: position,
      );
}
