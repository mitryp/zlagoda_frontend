import '../../typedefs.dart';
import '../common_models/address.dart';
import '../common_models/name.dart';
import '../interfaces/model.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';

class Client extends Model {
  static final Schema<Client> schema = Schema(
    Client.new,
    [
      FieldDescription<String, Client>(
        'clientId',
        (o) => o.clientId,
        labelCaption: 'Номер картки покупця',
      ),
      FieldDescription<Name, Client>(
        'clientName',
        (o) => o.clientName,
        fieldType: FieldType.auto,
        labelCaption: "Ім'я клієнта"
      ),
      FieldDescription<String, Client>(
        'phone',
        (o) => o.phone,
        labelCaption: 'Номер телефону',
      ),
      FieldDescription<Address?, Client>(
        'address',
        (o) => o.address,
        fieldType: FieldType.auto,
        labelCaption: 'Адреса',
      ),
      FieldDescription<int, Client>(
        'discount',
        (o) => o.discount,
        labelCaption: 'Знижка',
        fieldType: FieldType.number,
      ),
    ],
  );

  final String clientId;
  final Name clientName;
  final String phone;
  final Address? address;
  final int discount;

  const Client({
    required this.clientId,
    required this.clientName,
    required this.phone,
    this.address,
    required this.discount,
  });

  static Client? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  get primaryKey => clientId;

  @override
  JsonMap toJson() => schema.toJson(this);

// @override
// DataRow buildRow(BuildContext context) {
//   final List<String> cellsText = [
//     clientId,
//     clientName.fullName,
//     discount.toString(),
//   ];
//
//   return buildRowFromFields(context, cellsText);
// }
}
