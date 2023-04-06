import '../../model/basic_models/employee.dart';
import '../../model/common_models/name.dart';
import '../../model/interfaces/serializable.dart';

class User implements Serializable {
  final String userId;
  final String login;
  final Name name;
  final Position position;

  const User({
    required this.userId,
    required this.login,
    required this.position,
    required this.name,
  });

  static User? fromJSON(dynamic json) {
    final userId = json['userId'];
    final login = json['login'];
    final name = Name.fromJSON(json['name']);
    final positionName = json['position'];
    Position? position;
    if (positionName != null)
      position = Position.values.firstWhere((pos) => pos.name == positionName);

    if ([userId, login, name, position].contains(null)) return null;

    return User(
      userId: userId,
      login: login,
      position: position!,
      name: name!,
    );
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'userId': userId,
      'login': login,
      'position': position.name,
      'name': name.toJSON(),
    };
  }

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

class AuthorizedUser {
  final User user;
  final String token;

  const AuthorizedUser(this.user, this.token);
}
