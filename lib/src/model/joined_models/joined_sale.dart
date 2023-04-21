import '../../typedefs.dart';
import '../basic_models/product.dart';
import '../interfaces/model.dart';
import '../model_reference.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class JoinedSale extends Model {
  static final Schema<JoinedSale> schema = Schema(
    JoinedSale.new,
    [
      FieldDescription<String, JoinedSale>(
        'productName',
        (o) => o.productName,
        labelCaption: 'Назва товару',
      ),
      FieldDescription<String, JoinedSale>(
        'upc',
        (o) => o.upc,
        labelCaption: 'UPC',
      ),
      FieldDescription<int, JoinedSale>(
        'price',
        (o) => o.price,
        labelCaption: 'Ціна',
      ),
      FieldDescription<int, JoinedSale>(
        'quantity',
        (o) => o.quantity,
        labelCaption: 'Кількість',
      ),
    ],
  );

  final String productName;
  final String upc;
  final int price;
  final int quantity;

  const JoinedSale({
    required this.productName,
    required this.upc,
    required this.price,
    required this.quantity,
  });

  @override
  get primaryKey => throw UnimplementedError('JoinedSale is not a real model, '
      "don't call its primaryKey");

  @override
  List<ForeignKey<Model>> get foreignKeys => [foreignKey<Product>('upc', upc)];

  static JoinedSale? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);
}
