import '../../typedefs.dart';
import '../interfaces/serializable.dart';

class Address implements Serializable {
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
  JsonMap toJson() {
    return {'city': city, 'street': street, 'index': index};
  }
}
