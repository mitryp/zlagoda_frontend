import 'package:flutter/foundation.dart';

import '../../../../model/basic_models/product.dart';
import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../pages/goods/products_view.dart';
import 'model_collection_view.dart';

typedef CollectionViewConstructor<R extends ConvertibleToRow<R>> = ModelCollectionView<R> Function({
  Key? key,
});

const Map<Type, CollectionViewConstructor> _typesToCollectionViews = {
  Product: ProductsView.new,
};

CollectionViewConstructor<R> makeCollectionViewConstructor<R extends ConvertibleToRow<R>>() {
  final collectionViewConstructor = _typesToCollectionViews[R];

  if (collectionViewConstructor == null) {
    throw StateError('Could not find a CollectionView for type $R');
  }

  return collectionViewConstructor as CollectionViewConstructor<R>;
}
