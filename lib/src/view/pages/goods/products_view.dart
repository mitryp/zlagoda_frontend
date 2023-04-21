import 'package:flutter/material.dart';

import '../../../model/basic_models/product.dart';
import '../../../services/query_builder/sort.dart';
import '../../widgets/queries/sort_widget.dart';
import '../../widgets/resources/collections/collection_view.dart';
import '../../widgets/resources/collections/model_collection_view.dart';

void _nothing() {}

class ProductsView extends ModelCollectionView<Product> {
  const ProductsView({super.key})
      : super(
          defaultSortField: SortOption.productName,
          searchFilterDelegate: ProductsSearchFilters.new,
          onAddPressed: _nothing,
        );
}

class ProductsSearchFilters extends CollectionSearchFilterDelegate {
  const ProductsSearchFilters({
    required super.queryBuilder,
    required super.updateCallback,
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
    const sortOptions = [
      SortOption.productName,
      //TODO remove
      SortOption.manufacturer,
    ];

    return SortWidget(
      sortOptions: sortOptions,
      initialSort: queryBuilder.sort,
      addSortToQB: updateSort,
    );
  }
}
