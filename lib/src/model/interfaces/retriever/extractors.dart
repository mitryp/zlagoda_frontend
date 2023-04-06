import '../../../typedefs.dart';
import '../../basic_models/employee.dart';
import '../../common_models/address.dart';
import '../../common_models/name.dart';

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

class Extractor<T> {
  T extractFrom(JsonMap json, String field) => json[field];
}

class DateTimeExtractor extends Extractor<DateTime> {
  @override
  DateTime extractFrom(JsonMap json, String field) =>
      DateTime.fromMillisecondsSinceEpoch(json[field] * 1000);
}

class AddressExtractor extends Extractor<Address> {
  @override
  Address extractFrom(JsonMap json, String field) => Address(
        city: json[field]['city'],
        street: json[field]['street'],
        index: json[field]['index'],
      );
}

class NameExtractor extends Extractor<Name> {
  @override
  Name extractFrom(JsonMap json, String field) => Name(
        firstName: json[field]['firstName'],
        middleName: json[field]['middleName'],
        lastName: json[field]['lastName'],
      );
}

class PositionExtractor extends Extractor<Position> {
  @override
  Position extractFrom(JsonMap json, String field) =>
      Position.values.firstWhere((e) => e.name == json[field]);
}
