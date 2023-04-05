import '../interfaces/serializable.dart';

class Name implements Serializable {
  final String firstName;
  final String middleName;
  final String lastName;

  const Name({required this.firstName, required this.middleName, required this.lastName});

  String get fullName => '$lastName $firstName $middleName';

  @override
  Map<String, dynamic> toJSON() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
    };
  }

  static Name? fromJSON(dynamic json) {
    String? firstName, middleName, lastName;
    try {
      firstName = json['firstName'];
      middleName = json['middleName'];
      lastName = json['lastName'];
    } on NoSuchMethodError {
      return null;
    }

    if ([firstName, middleName, lastName].contains(null)) return null;

    return Name(
      firstName: firstName!,
      middleName: middleName!,
      lastName: lastName!,
    );
  }
}
