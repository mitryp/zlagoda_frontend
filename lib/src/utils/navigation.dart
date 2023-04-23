import 'package:flutter/material.dart';

import '../model/interfaces/convertible_to_row.dart';
import '../model/interfaces/model.dart';
import '../model/interfaces/serializable.dart';
import '../services/http/http_service_factory.dart';
import '../services/http/model_http_service.dart';
import '../view/widgets/resources/collections/collection_view_factory.dart';
import '../view/widgets/resources/models/model_table.dart';
import '../view/widgets/resources/models/model_view.dart';

class AppNavigation {
  final BuildContext context;

  const AppNavigation.of(this.context);

  ModelHttpService<dynamic, S> _serviceOf<S extends Serializable>() =>
      makeModelHttpService<S>() as ModelHttpService<dynamic, S>;

  void toModelView<SSingle extends Model>(dynamic primaryKey) {
    assert(SSingle != Model);

    final modelFuture = _serviceOf<SSingle>().singleById(primaryKey).then((v) => v!);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ModelView<SSingle>(fetchFunction: () => modelFuture),
      ),
    );
  }

  void openModelViewFor<SSingle extends Model>(SSingle model, [List<ModelTable>? connectedTables]) {
    assert(SSingle != Model);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ModelView<SSingle>(
          fetchFunction: () => model,
          connectedTables: connectedTables,
        ),
      ),
    );
  }

  void toCollectionView<SCol extends ConvertibleToRow<SCol>>() {
    final viewConstructor = makeCollectionViewConstructor<SCol>();

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => viewConstructor()),
    );
  }
}
