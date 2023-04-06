import '../../typedefs.dart';
import '../interfaces/retriever/extractors.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

class Name implements Serializable {
  final String firstName;
  final String? middleName;
  final String lastName;

  static final Schema<Name> schema = [
    Retriever<String, Name>(
      field: 'firstName',
      getter: (name) => name.firstName,
    ),
    Retriever<String?, Name>(
      field: 'middleName',
      getter: (name) => name.middleName,
      optional: true,
    ),
    Retriever<String, Name>(
      field: 'lastName',
      getter: (name) => name.lastName,
    ),
  ];

  const Name({
    required this.firstName,
    this.middleName,
    required this.lastName,
  });

  String get fullName => '$lastName $firstName $middleName';

  @override
  JsonMap toJson() => convertToJson(schema, this);

  static Name? fromJson(JsonMap json) {
    return NameExtractor().extractFrom(json, 'name');
  }
}
