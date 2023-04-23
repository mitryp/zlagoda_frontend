import '../../typedefs.dart';
import '../interfaces/search_model.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

class ShortProduct extends SearchModel {
  static final Schema<ShortProduct> schema = Schema(
      ShortProduct.new,
      [
        FieldDescription<String, ShortProduct>(
          'upc',
              (o) => o.primaryKey,
          labelCaption: 'Пошук за UPC',
        ),
        FieldDescription<String, ShortProduct>(
          'productName',
              (o) => o.descriptiveField,
          labelCaption: 'Пошук за назвою товару',
        ),
      ]);

      ShortProduct(upc, productName): super(upc, productName);

  static ShortProduct? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

}