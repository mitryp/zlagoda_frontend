import 'package:flutter/material.dart';

import '../../../model/basic_models/product.dart';
import '../../../services/query_builder/query_builder.dart';
import '../../../services/query_builder/sort.dart';
import '../../widgets/resources/collections/collection_view.dart';
import '../../widgets/resources/collections/model_collection_view.dart';

class ProductsView extends ModelCollectionView<Product> {
  const ProductsView({super.key})
      : super(
          defaultSortField: SortField.productName,
          searchFilterDelegate: ProductsSearchFilters.new,
        );
}

class ProductsSearchFilters extends CollectionSearchFilterDelegate {
  const ProductsSearchFilters({
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
