import 'package:flutter/material.dart';

import '../model/interfaces/convertible_to_row.dart';
import '../model/interfaces/model.dart';
import '../model/interfaces/serializable.dart';
import '../services/http/http_service_factory.dart';
import '../services/http/model_http_service.dart';
import '../view/widgets/resources/collections/collection_view_factory.dart';
import '../view/widgets/resources/models/model_view.dart';

class AppNavigation {
  final BuildContext context;

  const AppNavigation.of(this.context);

  ModelHttpService<S> _serviceOf<S extends Serializable>() => makeHttpService<S>();

  void toModelView<M extends Model>(dynamic primaryKey) {
    final modelFuture = _serviceOf<M>().singleById(primaryKey).then((v) => v!);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ModelView<M>(fetchFunction: () => modelFuture),
      ),
    );
  }

  void toCollectionView<R extends ConvertibleToRow<R>>() {
    final viewConstructor = makeCollectionViewConstructor<R>();

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => viewConstructor()),
    );
  }
}
