import 'package:flutter/foundation.dart';

import '../../../../model/basic_models/product.dart';
import '../../../../model/interfaces/convertible_to_pdf.dart';
import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../pages/collections/goods/products_view.dart';
import 'model_collection_view.dart';

typedef CollectionViewConstructor<SCol extends ConvertibleToRow<SCol>, CTPdf extends ConvertibleToPdf<CTPdf>> = //
    ModelCollectionView<SCol, CTPdf> Function({Key? key});

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
