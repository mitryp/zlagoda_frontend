import '../../typedefs.dart';
import '../basic_models/employee.dart';
import '../common_models/address.dart';
import '../common_models/name.dart';
import '../joined_models/joined_sale.dart';

typedef NullableName = Name?;
typedef NullableAddress = Address?;

Extractor<T> makeExtractor<T>() {
  final typesToExtractors = {
    bool: BoolExtractor.new,
    DateTime: DateTimeExtractor.new,
    Address: AddressExtractor.new,
    NullableAddress: AddressExtractor.new,
    Name: NameExtractor.new,
    NullableName: NameExtractor.new,
    JoinedSale: JoinedSaleExtractor.new,
    Position: PositionExtractor.new,
    List<JoinedSale>: () => ListExtractor<JoinedSale>(),
  };

  final extractor = typesToExtractors[T];

  return (extractor == null ? Extractor<T>() : extractor()) as Extractor<T>;
}

T? extractInlineFrom<T>(JsonMap json, String field) {
  try {
    return json[field];
  } catch (e) {
    print('Error when extracting $field from json: $e');

    return null;
  }
}

class Extractor<T> {
  T? extractFrom(JsonMap json, String field) =>
      extractInlineFrom<T>(json, field);
}

class BoolExtractor extends Extractor<bool> {
  @override
  bool? extractFrom(JsonMap json, String field) {
    final intValue = extractInlineFrom<int>(json, field);

    return intValue == null ? null : intValue == 1;
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

    return Name.schema.fromJson(nameFromJson);
  }
}

class AddressExtractor extends Extractor<Address> {
  @override
  Address? extractFrom(JsonMap json, String field) {
    final addressFromJson = extractInlineFrom<JsonMap>(json, field);

    if (addressFromJson == null) return null;

    return Address.schema.fromJson(addressFromJson);
  }
}

class JoinedSaleExtractor extends Extractor<JoinedSale> {
  @override
  JoinedSale? extractFrom(JsonMap json, String field) {
    final saleFromJson = extractInlineFrom<JsonMap>(json, field);

    if (saleFromJson == null) return null;

    return JoinedSale.schema.fromJson(saleFromJson);
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

class ListExtractor<T> extends Extractor<List<T>> {
  @override
  List<T>? extractFrom(JsonMap json, String field) {
    final listFromJson = extractInlineFrom<List<dynamic>>(json, field);

    if (listFromJson == null) return null;
    return listFromJson
        .map((item) => makeExtractor<T>().extractFrom({'': item}, ''))
        .where((e) => e != null)
        .toList()
        .cast<T>();
  }
}
