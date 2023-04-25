import '../../typedefs.dart';
import '../interfaces/serializable.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';
import '../schema/validators.dart';

class PromStoreProduct implements Serializable {
  static final Schema<PromStoreProduct> schema = Schema(PromStoreProduct.new, [
    FieldDescription<int, PromStoreProduct>(
      'quantity',
          (o) => o.quantity,
      labelCaption: 'Кількість',
      fieldType: FieldType.number,
      validator: isNonNegativeInteger,
    ),
    FieldDescription<int, PromStoreProduct>(
      'baseStoreProductId',
          (o) => o.baseStoreProductId,
      labelCaption: 'ID базового товару у магазині',
      isEditable: false,
    ),
  ]);

  final int quantity;
  final int baseStoreProductId;

  const PromStoreProduct({
    required this.quantity,
    required this.baseStoreProductId,
  });

  static PromStoreProduct? fromJSON(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);
}
