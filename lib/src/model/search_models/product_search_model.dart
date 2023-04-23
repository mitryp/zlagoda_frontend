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
              (o) => o.upc,
          labelCaption: 'UPC',
        ),
        FieldDescription<String, ShortProduct>(
          'productName',
              (o) => o.productName,
          labelCaption: 'Назва',
        ),
      ]);

      final String upc;
      final String productName;

      ShortProduct(
      this.upc,
      this.productName): super(upc, productName);

  static ShortProduct? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

}