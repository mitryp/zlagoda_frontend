import '../../typedefs.dart';
import '../interfaces/search_model.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class ShortStoreProduct extends ShortModel<int> {
  static final Schema<ShortStoreProduct> schema = Schema(ShortStoreProduct.new, [
    FieldDescription<int, ShortStoreProduct>(
      'primaryKey',
      (o) => o.primaryKey,
      labelCaption: '',
    ),
    FieldDescription<String, ShortStoreProduct>(
      'descriptiveAttr',
      (o) => o.descriptiveAttr,
      labelCaption: 'Пошук за UPC або назвою товару',
    ),
  ]);

  ShortStoreProduct({required super.primaryKey, required super.descriptiveAttr});

  static ShortStoreProduct? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  String toString() => '$primaryKey $descriptiveAttr';
}
