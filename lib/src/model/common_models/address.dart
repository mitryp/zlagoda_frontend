import '../../typedefs.dart';
import '../interfaces/serializable.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class Address implements Serializable {
  static final Schema<Address> schema = Schema(
    Address.new,
    [
      FieldDescription<String, Address>(
        'city',
        (o) => o.city,
        labelCaption: 'Місто',
      ),
      FieldDescription<String, Address>(
        'street',
        (o) => o.street,
        labelCaption: 'Вулиця',
      ),
      FieldDescription<String, Address>(
        'index',
        (o) => o.index,
        labelCaption: 'Поштовий індекс',
      ),
    ],
  );

  final String city;
  final String street;
  final String index;

  const Address({
    required this.city,
    required this.street,
    required this.index,
  });

  String get fullAddress => '$city, $street, $index';

  @override
  String toString() => fullAddress;

  @override
  JsonMap toJson() => schema.toJson(this);
}
