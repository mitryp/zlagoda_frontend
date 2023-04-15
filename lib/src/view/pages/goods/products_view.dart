import 'package:flutter/material.dart';

import '../../../model/basic_models/product.dart';
import '../../../services/query_builder/query_builder.dart';
import '../../widgets/resources/collections/collection_view.dart';
import '../../widgets/resources/collections/model_collection_view.dart';

class ProductsView extends ModelCollectionView<Product> {
  const ProductsView({super.key}) : super(searchFilterDelegate: TestSfd.new);
}

class TestSfd extends CollectionSearchFilterDelegate {
  const TestSfd({
    required QueryBuilder queryBuilder,
    required super.updateSink,
  });

  @override
  List<Widget> buildFilters(BuildContext context) {
    // TODO: implement buildFilters
    return [];
  }

  @override
  List<Widget> buildSearches(BuildContext context) {
    // TODO: implement buildSearches
    return [];
  }

  @override
  Widget buildSort(BuildContext context) {
    // TODO: implement buildSort
    return const SizedBox();
  }
}
