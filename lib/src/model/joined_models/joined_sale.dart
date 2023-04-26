import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/coins_to_currency.dart';
import '../../utils/navigation.dart';
import '../../utils/value_status.dart';
import '../basic_models/product.dart';
import '../basic_models/store_product.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/model.dart';
import '../interfaces/search_model.dart';
import '../model_reference.dart';
import '../schema/field_description.dart';
import '../schema/field_type.dart';
import '../schema/schema.dart';
import '../search_models/short_product.dart';

class JoinedSale extends Model with ConvertibleToRow<JoinedSale> {
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
        fieldType: FieldType.currency,
      ),
      FieldDescription<int, JoinedSale>(
        'quantity',
        (o) => o.quantity,
        labelCaption: 'Кількість',
        fieldType: FieldType.number,
      ),
      FieldDescription<int, JoinedSale>.intForeignKey(
        'storeProductId',
        (o) => o.storeProductId,
        labelCaption: 'Товар в магазині',
        defaultForeignKey: foreignKey<StoreProduct, ShortModel>('storeProductId'),
      ),
      FieldDescription<String, JoinedSale>.transitive(
        'cost',
        (o) => toHryvnas(o.price * o.quantity),
        labelCaption: 'Вартість',
        transitiveFieldPresentation: (f) => '$f',
      ),
      FieldDescription<bool, JoinedSale>(
        'isProm',
        (o) => o.isProm,
        labelCaption: 'Акційність',
        fieldType: FieldType.boolean,
      )
    ],
  );

  final int storeProductId;
  final int price;
  final int quantity;
  final String productName;
  final String upc;
  final bool isProm;

  const JoinedSale({
    required this.storeProductId,
    required this.price,
    required this.quantity,
    required this.productName,
    required this.upc,
    required this.isProm,
  });

  @override
  get primaryKey => throw UnimplementedError('JoinedSale is not a real model, '
      "don't call its primaryKey");

  @override
  List<ForeignKey> get foreignKeys => [foreignKey<Product, ShortProduct>('upc', upc)];

  static JoinedSale? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  Future<ValueStatusWrapper> redirectToModelView(BuildContext context) =>
      AppNavigation.of(context).toModelView<StoreProduct>(storeProductId);
}
