import 'package:flutter/material.dart';

import '../../../model/basic_models/store_product.dart';
import '../../../model/joined_models/joined_store_product.dart';
import '../../../services/query_builder/filter.dart';
import '../../../services/query_builder/sort.dart';
import '../../../utils/navigation.dart';
import '../../widgets/queries/filters/checkbox_filter.dart';
import '../../widgets/queries/filters/chips_filter.dart';
import '../../widgets/queries/sort_block.dart';
import '../../widgets/resources/collections/collection_view.dart';
import '../../widgets/resources/collections/model_collection_view.dart';

//TODO change the model to an appropriate one
void _redirectToAddingModel(BuildContext context) =>
    AppNavigation.of(context).openModelCreation<StoreProduct>();

class StoreProductsView extends ModelCollectionView<JoinedStoreProduct> {
  const StoreProductsView({super.key})
      : super(
          defaultSortField: SortOption.productName,
          searchFilterDelegate: StoreProductsSearchFilters.new,
          onAddPressed: _redirectToAddingModel,
        );
}

class StoreProductsSearchFilters extends CollectionSearchFilterDelegate {
  const StoreProductsSearchFilters({
    required super.queryBuilder,
    required super.updateCallback,
  });

  @override
  List<Widget> buildFilters(BuildContext context) {
    return [
      ChipsFilter(
        filterOption: FilterOption.isProm,
        addFilter: addFilter,
        removeFilter: removeFilter,
        availableChoices: const {
          true: 'Акійні товари',
          false: 'Неакійні товари',
        },
      )
    ];
  }

  @override
  List<Widget> buildSearches(BuildContext context) {
    return [];
  }

  @override
  Widget buildSort(BuildContext context) {
    const sortOptions = [
      SortOption.productName,
      SortOption.quantity,
    ];

    return SortBlock(
      sortOptions: sortOptions,
      initialSort: queryBuilder.sort,
      setSort: updateSort,
    );
  }
}
