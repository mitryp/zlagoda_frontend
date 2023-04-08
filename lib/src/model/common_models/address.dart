import '../../typedefs.dart';
import '../interfaces/serializable.dart';
import '../schema/retriever.dart';
import '../schema/schema.dart';

class Address implements Serializable {
  static final Schema<Address> schema = Schema(
    Address.new,
    [
      Retriever<String, Address>('city', (o) => o.city),
      Retriever<String, Address>('street', (o) => o.street),
      Retriever<String, Address>('index', (o) => o.index),
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
  JsonMap toJson() => schema.toJson(this);
}
