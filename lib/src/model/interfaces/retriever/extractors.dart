import '../../../typedefs.dart';
import '../../basic_models/employee.dart';
import '../../common_models/address.dart';
import '../../common_models/name.dart';
import '../serializable.dart';

class JsonExtractorFactory {
  static Extractor<T> getExtractor<T>() {
    if (T == DateTime) return DateTimeExtractor() as Extractor<T>;
    if (T == Address) return AddressExtractor() as Extractor<T>;
    if (T == Name) return NameExtractor() as Extractor<T>;
    if (T == Position) return PositionExtractor() as Extractor<T>;
    if (T == DateTime) return DateTimeExtractor() as Extractor<T>;

    return Extractor<T>();
  }
}

T? extractInlineFrom<T>(JsonMap json, String field) {
  try {
    return json[field];
  } catch (e) {
    print(e);

    return null;
  }
}

class Extractor<T> {
  T? extractFrom(JsonMap json, String field) {
    return extractInlineFrom<T>(json, field);
  }
}

class DateTimeExtractor extends Extractor<DateTime> {
  @override
  DateTime? extractFrom(JsonMap json, String field) {
    int? secondsSinceEpoch = extractInlineFrom<int>(json, field);

    return secondsSinceEpoch == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(secondsSinceEpoch * 1000);
  }
}

class NameExtractor extends Extractor<Name> {
  @override
  Name? extractFrom(JsonMap json, String field) {
    final nameFromJson = extractInlineFrom<JsonMap>(json, field);

    if (nameFromJson == null) return null;

    final jsonName = retrieveFromJson(Name.schema, nameFromJson);

    if(jsonName == null) return null;

    return Name(
      firstName: jsonName['firstName'],
      middleName: jsonName['middleName'],
      lastName: jsonName['lastName'],
    );
  }
}

class AddressExtractor extends Extractor<Address> {
  @override
  Address? extractFrom(JsonMap json, String field) {
    final addressFromJson = extractInlineFrom<JsonMap>(json, field);

    if (addressFromJson == null) return null;

    final jsonName = retrieveFromJson(Address.schema, addressFromJson);

    if(jsonName == null) return null;

    return Address(
      city: jsonName['city'],
      street: jsonName['street'],
      index: jsonName['index'],
    );
  }
}

class PositionExtractor extends Extractor<Position> {
  @override
  Position? extractFrom(JsonMap json, String field) {
    final positionFromJson = extractInlineFrom<String>(json, field);

    if (positionFromJson == null) return null;

    return Position.values.map((value) => value.name).contains(positionFromJson)
        ? Position.values.firstWhere((e) => e.name == json[field])
        : null;
  }
}
