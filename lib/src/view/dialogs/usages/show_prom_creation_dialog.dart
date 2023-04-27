import 'package:flutter/material.dart';

import '../../../model/basic_models/store_product.dart';
import '../../../model/other_models/prom_store_product.dart';
import '../../../model/schema/validators.dart';
import '../../../services/http/prom_store_product_services.dart';
import '../../../theme.dart';
import '../../../utils/value_status.dart';
import '../contents/prom_store_product_creation_dialog_content.dart';
import '../creation_dialog.dart';

Future<ValueStatusWrapper<StoreProduct>?> showPromCreationDialog(
    BuildContext context, StoreProduct model) {
  return showCreationDialog<ValueStatusWrapper<StoreProduct>>(
    context: context,
    inputBuilder: (textController) =>
        PromStoreProductTextField(controller: textController, validator: isNonNegativeInteger),
    buttonProps: [
      ButtonProps<StoreProduct>(
        fetchCallback: (quantity) {
          return PromStoreProductService.update(
              PromStoreProduct(
                baseStoreProductId: model.baseStoreProductId!,
                quantity: quantity,
              ),
              controlTotalQuantity: true);
        },
        caption: 'Встановити',
        message: 'Кількість пов\'язаних неакційних товарів буде відредаговано так, '
            'щоб загальна кількість товару на складі не змінилася',
      ),
      ButtonProps<StoreProduct>(
        fetchCallback: (quantity) {
          return PromStoreProductService.update(
            PromStoreProduct(
              baseStoreProductId: model.baseStoreProductId!,
              quantity: quantity,
            ),
            controlTotalQuantity: false,
          );
        },
        caption: 'Встановити без обліку',
        color: secondary,
        message: 'Буде встановлено нову кількість акційних товарів без '
            'зміни кількості неакційних товарів',
      ),
    ],
  );
}
