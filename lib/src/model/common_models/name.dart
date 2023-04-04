import '../interfaces/model.dart';
import '../interfaces/serializable.dart';

class Name implements Serializable {
  final String firstName;
  final String middleName;
  final String lastName;

  const Name({required this.firstName, required this.middleName, required this.lastName});

  String get fullName => '$lastName $firstName $middleName';

  @override
  Map<String, dynamic> toJSON() {
    // TODO: implement toJSON
    throw UnimplementedError();
  }
}
