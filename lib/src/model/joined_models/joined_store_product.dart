import 'package:flutter/material.dart';

import '../../services/http/prom_store_product_services.dart';
import '../../typedefs.dart';
import '../../utils/coins_to_currency.dart';
import '../../utils/navigation.dart';
import '../../utils/value_status.dart';
import '../../view/dialogs/contents/prom_store_product_creation_dialog_content.dart';
import '../../view/dialogs/creation_dialog.dart';
import '../basic_models/store_product.dart';
import '../interfaces/convertible_to_pdf.dart';
import '../interfaces/convertible_to_row.dart';
import '../interfaces/serializable.dart';
import '../model_reference.dart';
import '../other_models/prom_store_product.dart';
import '../schema/field_description.dart';
import '../schema/schema.dart';
import '../schema/validators.dart';
import '../search_models/short_product.dart';

abstract class _JoinedStoreProduct implements Serializable {
  const _JoinedStoreProduct();
}

class JoinedStoreProduct extends _JoinedStoreProduct
    with ConvertibleToRow<JoinedStoreProduct>, ConvertibleToPdf<JoinedStoreProduct> {
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
      FieldDescription<int?, JoinedStoreProduct>.intForeignKey(
        'baseStoreProductId',
        (o) => o.baseStoreProductId,
        labelCaption: 'ID базового товару у магазині',
        fieldDisplayMode: FieldDisplayMode.none,
        defaultForeignKey: foreignKey<StoreProduct, ShortProduct>('baseStoreProductId'),
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

  void _onAddDiscountProduct(BuildContext context) {
    showCreationDialog(
      context: context,
      inputBuilder: (textController) =>
          PromStoreProductTextField(controller: textController, validator: isPositiveInteger),
      buttonProps: [
        ButtonProps<StoreProduct>(
          fetchCallback: (quantity) => post(PromStoreProduct(
            baseStoreProductId: storeProductId,
            quantity: quantity,
          )),
          caption: 'Створити нову акцію',
          message: 'На основі неакційного товару',
        )
      ],
    );
  }

  Widget _addDiscountProductButton(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text('Додати акційний товар'),
      icon: const Icon(Icons.add),
      onPressed: () => _onAddDiscountProduct(context),
    );
  }

  @override
  Future<ValueStatusWrapper> redirectToModelView(BuildContext context) async {
    StoreProduct? storeProduct = StoreProduct.fromJSON(toJson());

    if (storeProduct == null) {
      print('store product is null');
      return ValueStatusWrapper.notChanged();
    }

    return AppNavigation.of(context).openModelViewFor<StoreProduct>(
      storeProduct,
      additionalButtonsBuilders: isProm ? null : [(context) => _addDiscountProductButton(context)],
    );
  }

  List<String> get cellsData => [
    upc,
    productName,
    manufacturer,
    toHryvnas(price),
    quantity.toString(),
    toHryvnas(price * quantity),
    isProm ? 'Так' : 'Ні',
  ];

  @override
  DataRow buildRow(BuildContext context, UpdateCallback<ValueChangeStatus> updateCallback) {
    return DataRow(
      cells: cellsData.map((cell) => DataCell(Text(cell))).toList(),
      onSelectChanged: (_) async =>
          updateCallback(await redirectToModelView(context).then((v) => v.status)),
    );
  }

  @override
  List<dynamic> get pdfRow => cellsData;
}
