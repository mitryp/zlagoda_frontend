import '../../model/basic_models/employee.dart';
import '../../model/common_models/name.dart';
import '../../model/interfaces/serializable.dart';
import '../../model/schema/retriever.dart';
import '../../model/schema/schema.dart';
import '../../typedefs.dart';

class User implements Serializable {
  static final Schema<User> schema = Schema(
    User.new,
    [
      Retriever<String, User>('userId', (o) => o.userId),
      Retriever<String, User>('login', (o) => o.login),
      Retriever<Name, User>('name', (o) => o.name),
      Retriever<Position, User>('position', (o) => o.position),
    ],
  );

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

  static User? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          login == other.login &&
          name == other.name &&
          position == other.position;

  @override
  int get hashCode => userId.hashCode ^ login.hashCode ^ name.hashCode ^ position.hashCode;
}

class AuthorizedUser {
  final User user;
  final String token;

  const AuthorizedUser(this.user, this.token);
}
