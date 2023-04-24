import '../../typedefs.dart';
import '../interfaces/search_model.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class ShortProduct extends ShortModel<String> {
  static final Schema<ShortProduct> schema = Schema(ShortProduct.new, [
    FieldDescription<String, ShortProduct>(
      'primaryKey',
      (o) => o.primaryKey,
      labelCaption: '',
    ),
    FieldDescription<String, ShortProduct>(
      'descriptiveAttr',
      (o) => o.descriptiveAttr,
      labelCaption: 'Пошук за UPC, назвою товару або виробником',
    ),
  ]);

  ShortProduct({required super.primaryKey, required super.descriptiveAttr});

  static ShortProduct? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  String toString() {
    return '$primaryKey $descriptiveAttr';
  }
}
