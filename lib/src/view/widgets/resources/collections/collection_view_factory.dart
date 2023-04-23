import 'package:flutter/foundation.dart';

import '../../../../model/basic_models/product.dart';
import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../pages/goods/products_view.dart';
import 'model_collection_view.dart';

typedef CollectionViewConstructor<SCol extends ConvertibleToRow<SCol>> = //
    ModelCollectionView<SCol> Function({Key? key});

const Map<Type, CollectionViewConstructor> _typesToCollectionViews = {
  Product: ProductsView.new,
};

CollectionViewConstructor makeCollectionViewConstructor<SCol extends ConvertibleToRow<SCol>>() {
  final collectionViewConstructor = _typesToCollectionViews[SCol];

  if (collectionViewConstructor == null) {
    throw StateError('Could not find a CollectionView for type $SCol');
  }

  return collectionViewConstructor;
}
