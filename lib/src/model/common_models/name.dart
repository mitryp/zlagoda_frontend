import '../../typedefs.dart';
import '../interfaces/serializable.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

class Name implements Serializable {
  final String firstName;
  final String? middleName;
  final String lastName;

  static final Schema<Name> schema = Schema(
    Name.new,
    [
      Retriever<String, Name>('firstName', (o) => o.firstName),
      Retriever<String?, Name>('middleName', (o) => o.middleName),
      Retriever<String, Name>('lastName', (o) => o.lastName),
    ],
  );


  // static final Schema<Name> schema = [
  //   Retriever<String, Name>(
  //     field: 'firstName',
  //     getter: (name) => name.firstName,
  //   ),
  //   Retriever<String?, Name>(
  //     field: 'middleName',
  //     getter: (name) => name.middleName,
  //     nullable: true,
  //   ),
  //   Retriever<String, Name>(
  //     field: 'lastName',
  //     getter: (name) => name.lastName,
  //   ),
  // ];

  const Name({
    required this.firstName,
    this.middleName,
    required this.lastName,
  });

  String get fullName => '$lastName $firstName $middleName';

  @override
  JsonMap toJson() => schema.toJson(this);

  static Name? fromJson(JsonMap json) => schema.fromJson(json);
}
