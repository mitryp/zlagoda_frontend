import '../../typedefs.dart';

import '../interfaces/model.dart';
import '../model_reference.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';
import '../search_models/short_product.dart';
import 'product.dart';

class StoreProduct extends Model {
  static final Schema<StoreProduct> schema = Schema(
    StoreProduct.new,
    [
      FieldDescription<int, StoreProduct>(
        'storeProductId',
        (o) => o.storeProductId,
        labelCaption: 'ID товару',
      ),
      FieldDescription<String, StoreProduct>.stringForeignKey(
        'upc',
        (o) => o.upc,
        labelCaption: 'UPC',
        defaultForeignKey: foreignKey<Product, ShortProduct>('upc'),
      ),
      FieldDescription<int, StoreProduct>(
        'price',
        (o) => o.price,
        labelCaption: 'Ціна',
      ),
      FieldDescription<int, StoreProduct>(
        'quantity',
        (o) => o.quantity,
        labelCaption: 'Кількість',
      ),
      FieldDescription<int?, StoreProduct>(
        'baseProduct',
            (o) => o.baseStoreProductId,
        labelCaption: 'ID базового товару у магазині',
      ),
    ],
  );

  final int storeProductId;
  final String upc;
  final int price;
  final int quantity;
  final int? baseStoreProductId;

  const StoreProduct({
    required this.storeProductId,
    required this.upc,
    required this.price,
    required this.quantity,
    this.baseStoreProductId
  });

  static StoreProduct? fromJSON(JsonMap json) => schema.fromJson(json);

  bool get isProm => baseStoreProductId != null;

  @override
  get primaryKey => storeProductId;

  @override
  JsonMap toJson() => schema.toJson(this);

  List<ForeignKey> get foreignKeys => [foreignKey<Product, ShortProduct>('upc', upc)];
}
