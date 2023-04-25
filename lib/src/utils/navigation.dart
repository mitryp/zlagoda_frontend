import 'package:flutter/material.dart';

import '../model/basic_models/store_product.dart';
import '../model/interfaces/convertible_to_row.dart';
import '../model/interfaces/model.dart';
import '../model/interfaces/serializable.dart';
import '../model/other_models/prom_store_product.dart';
import '../model/schema/validators.dart';
import '../services/http/http_service_factory.dart';
import '../services/http/model_http_service.dart';
import '../services/http/prom_store_product_services.dart';
import '../theme.dart';
import '../view/dialogs/contents/prom_store_product_creation_dialog_content.dart';
import '../view/dialogs/creation_dialog.dart';
import '../view/widgets/resources/collections/collection_view_factory.dart';
import '../view/widgets/resources/models/model_edit_view.dart';
import '../view/widgets/resources/models/model_table.dart';
import '../view/widgets/resources/models/model_view.dart';
import 'value_status.dart';

class AppNavigation {
  final BuildContext context;

  const AppNavigation.of(this.context);

  ModelHttpService<dynamic, S> _serviceOf<S extends Serializable>() =>
      makeModelHttpService<S>() as ModelHttpService<dynamic, S>;

  Future<ValueStatusWrapper<SSingle>> toModelView<SSingle extends Model>(
      dynamic primaryKey) {
    assert(SSingle != Model);

    final modelFuture =
        _serviceOf<SSingle>().singleById(primaryKey).then((v) => v!);

    return Navigator.of(context)
        .push<ValueStatusWrapper<SSingle>>(
          MaterialPageRoute(
            builder: (context) =>
                ModelView<SSingle>(fetchFunction: () => modelFuture),
          ),
        )
        .then((wr) => wr ?? ValueStatusWrapper<SSingle>.notChanged());
  }

  Future<ValueStatusWrapper<SSingle>> openModelViewFor<SSingle extends Model>(
      SSingle model,
      {List<ModelTable>? connectedTables,
      List<WidgetBuilder>? additionalButtonsBuilders}) {
    assert(SSingle != Model);

    return Navigator.of(context)
        .push<ValueStatusWrapper<SSingle>>(
          MaterialPageRoute(
            builder: (context) => ModelView<SSingle>(
              fetchFunction: () => model,
              connectedTables: connectedTables,
              additionalButtonsBuilders: additionalButtonsBuilders,
            ),
          ),
        )
        .then((wr) => wr ?? ValueStatusWrapper<SSingle>.notChanged());
  }

  Future<ValueStatusWrapper<SSingle>>
      openModelEditViewFor<SSingle extends Model>(
    SSingle model, {
    List<Model>? connectedModels,
  }) {
    //TODO test
    if (model is StoreProduct && model.isProm) {
      return showCreationDialog<ValueStatusWrapper<SSingle>>(
        context: context,
        inputBuilder: (textController) => PromStoreProductTextField(
            controller: textController, validator: isNonNegativeInteger),
        buttonProps: [
          ButtonProps<PromStoreProduct>(
            fetchCallback: (quantity) => update(
                PromStoreProduct(
                  baseStoreProductId: model.baseStoreProductId!,
                  quantity: quantity,
                ),
                true),
            caption: 'Додати',
            message: 'Акційні товари будуть створені на основі доступних неакційних',
          ),
          ButtonProps<PromStoreProduct>(
            fetchCallback: (quantity) => update(
                PromStoreProduct(
                  baseStoreProductId: model.baseStoreProductId!,
                  quantity: quantity,
                ),
                false),
            caption: 'Встановити',
            color: secondary,
            message: 'Буде встановлено нову кількість акційних товарів без зміни кількості неакційних товарів',
          ),
        ],
      ).then((wr) => wr ?? ValueStatusWrapper<SSingle>.notChanged());
    }

    return Navigator.of(context)
        .push<ValueStatusWrapper<SSingle>>(MaterialPageRoute(
          builder: (context) => ModelEditForm<SSingle>(
            model: model,
            connectedModels: /*connectedModelTables.map((t) => t.model).toList()*/
                connectedModels,
          ),
        ))
        .then((wr) => wr ?? ValueStatusWrapper<SSingle>.notChanged());
  }

  Future<ValueStatusWrapper<SSingle>>
      openModelCreation<SSingle extends Model>() {
    return Navigator.of(context)
        .push<ValueStatusWrapper<SSingle>>(MaterialPageRoute(
          builder: (context) => ModelEditForm<SSingle>(),
        ))
        .then((wr) => wr ?? ValueStatusWrapper<SSingle>.notChanged());
  }

  void toCollectionView<SCol extends ConvertibleToRow<SCol>>() {
    final viewConstructor = makeCollectionViewConstructor<SCol>();

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => viewConstructor()),
    );
  }
}
