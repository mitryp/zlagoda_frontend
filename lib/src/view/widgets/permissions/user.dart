import '../../../model/basic_models/employee.dart';
import '../../../model/common_models/name.dart';

class User {
  final String login;
  final Name name;
  final Position position;

  const User({required this.login, required this.position, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          login == other.login &&
          position == other.position;

  @override
  int get hashCode => name.hashCode ^ login.hashCode ^ position.hashCode;
}
