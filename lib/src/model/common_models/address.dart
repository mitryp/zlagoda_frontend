import '../../typedefs.dart';
import '../interfaces/retriever/retriever.dart';
import '../interfaces/serializable.dart';

class Address implements Serializable {
  static final Schema<Address> schema = [
    Retriever<String, Address>(
      field: 'city',
      getter: (address) => address.city,
    ),
    Retriever<String, Address>(
      field: 'street',
      getter: (address) => address.street,
    ),
    Retriever<String, Address>(
      field: 'index',
      getter: (address) => address.index,
    ),
  ];

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
