import '../../typedefs.dart';
import '../interfaces/model.dart';
import '../interfaces/search_model.dart';
import '../model_reference.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';
import '../schema/validators.dart';
import '../search_models/short_product.dart';
import '../search_models/short_store_product.dart';
import 'product.dart';

class StoreProduct extends Model {
  static final Schema<StoreProduct> schema = Schema(
    StoreProduct.new,
    [
      FieldDescription<int?, StoreProduct>(
        'storeProductId',
        (o) => o.storeProductId,
        labelCaption: 'ID товару',
        fieldType: FieldType.number,
        isEditable: false,
        fieldDisplayMode: FieldDisplayMode.none,
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
        fieldType: FieldType.currency,
        validator: isCurrencyValue,
      ),
      FieldDescription<int, StoreProduct>(
        'quantity',
        (o) => o.quantity,
        labelCaption: 'Кількість',
        fieldType: FieldType.number,
        validator: isNonNegativeInteger,
      ),
      FieldDescription<int?, StoreProduct>.intForeignKey(
        'baseStoreProductId',
        (o) => o.baseStoreProductId,
        labelCaption: 'ID базового товару у магазині',
        isEditable: false,
        fieldDisplayMode: FieldDisplayMode.none,
        foreignKeyOptionality: ForeignKeyOptionality.optional,
        defaultForeignKey: foreignKey<StoreProduct, ShortModel>('baseStoreProductId'),
      ),
      FieldDescription.transitive(
        'isProm',
        (o) => o.isProm,
        labelCaption: 'Акційний',
        transitiveFieldPresentation: (b) => FieldType.boolean.presentation(b),
      )
    ],
  );

  final int? storeProductId;
  final String upc;
  final int price;
  final int quantity;
  final int? baseStoreProductId;

  const StoreProduct({
    this.storeProductId,
    required this.upc,
    required this.price,
    required this.quantity,
    this.baseStoreProductId,
  });

  static StoreProduct? fromJSON(JsonMap json) => schema.fromJson(json);

  bool get isProm => baseStoreProductId != null;

  @override
  get primaryKey => storeProductId;

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  List<ForeignKey> get foreignKeys => [
        foreignKey<Product, ShortProduct>('upc', upc),
        foreignKey<StoreProduct, ShortModel>('baseStoreProductId', baseStoreProductId),
      ];

  @override
  ShortModel toSearchModel() => ShortStoreProduct(
        primaryKey: primaryKey,
        descriptiveAttr: 'UPC $upc${isProm ? ' Акційний' : ''}',
      );
}
