import 'package:flutter/material.dart';

import '../../typedefs.dart';
import '../../utils/navigation.dart';
import '../basic_models/store_product.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/serializable.dart';
import '../model_reference.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';

abstract class _JoinedStoreProduct implements Serializable {
  const _JoinedStoreProduct();
}

class JoinedStoreProduct extends _JoinedStoreProduct
    with ConvertibleToRow<JoinedStoreProduct> {
  static final Schema<JoinedStoreProduct> schema = Schema(
    JoinedStoreProduct.new,
    [
      FieldDescription<int, JoinedStoreProduct>(
        'storeProductId',
        (o) => o.storeProductId,
        labelCaption: 'ID товару',
        fieldDisplayMode: FieldDisplayMode.none,
      ),
      FieldDescription<String, JoinedStoreProduct>(
        'upc',
        (o) => o.upc,
        labelCaption: 'UPC',
      ), // todo default goods
      FieldDescription<String, JoinedStoreProduct>(
        'productName',
            (o) => o.productName,
        labelCaption: 'Назва',
      ),
      FieldDescription<String, JoinedStoreProduct>(
        'manufacturer',
            (o) => o.manufacturer,
        labelCaption: 'Виробник',
      ),
      FieldDescription<int, JoinedStoreProduct>(
        'price',
        (o) => o.price,
        labelCaption: 'Ціна',
      ),
      FieldDescription<int, JoinedStoreProduct>(
        'quantity',
        (o) => o.quantity,
        labelCaption: 'Кількість',
      ),
      FieldDescription<int?, JoinedStoreProduct>(
        'baseProduct',
        (o) => o.baseStoreProductId,
        labelCaption: 'ID базового товару у магазині',
        fieldDisplayMode: FieldDisplayMode.none,
      ),
    ],
  );

  final int storeProductId;
  final String upc;
  final int price;
  final int quantity;
  final int? baseStoreProductId;
  final String productName;
  final String manufacturer;

  const JoinedStoreProduct({
    required this.storeProductId,
    required this.upc,
    required this.price,
    required this.quantity,
    this.baseStoreProductId,
    required this.productName,
    required this.manufacturer,
  });

  bool get isProm => baseStoreProductId != null;

  static JoinedStoreProduct? fromJson(JsonMap json) => schema.fromJson(json);

  @override
  JsonMap toJson() => schema.toJson(this);

  @override
  void redirectToModelView(BuildContext context) {
    //TODO check whether it works
    StoreProduct? storeProduct = StoreProduct.fromJSON(toJson());

    if (storeProduct == null) {
      print('store product is null');
      return;
    }

    AppNavigation.of(context).openModelViewFor<StoreProduct>(storeProduct);
  }

  @override
  DataRow buildRow(BuildContext context) {
    final cells = [
      upc,
      productName,
      manufacturer,
      toHryvnas(price),
      quantity.toString(),
      toHryvnas(price * quantity),
      isProm.toString(), // TODO somehow visualize it
    ];

    return DataRow(
      cells: cells.map((cell) => DataCell(Text(cell))).toList(),
      onSelectChanged: (_) => redirectToModelView(context),
    );
  }
}
