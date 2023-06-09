import 'package:flutter/material.dart';

import '../../../../model/basic_models/store_product.dart';
import '../../../../model/joined_models/joined_store_product.dart';
import '../../../../model/search_models/short_product.dart';
import '../../../../services/query_builder/filter.dart';
import '../../../../services/query_builder/sort.dart';
import '../../../../utils/navigation.dart';
import '../../../../utils/value_status.dart';
import '../../../widgets/queries/connected_model_filter.dart';
import '../../../widgets/queries/filters/chips_filter.dart';
import '../../../widgets/queries/sort_block.dart';
import '../../../widgets/resources/collections/collection_view.dart';
import '../../../widgets/resources/collections/model_collection_view.dart';

Future<ValueStatusWrapper> _redirectToAddingModel(BuildContext context) =>
    AppNavigation.of(context).openModelCreation<StoreProduct>();


class StoreProductsView extends ModelCollectionView<JoinedStoreProduct, JoinedStoreProduct> {
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
    return [
      ConnectedModelFilter<String, ShortProduct>(
        filterOption: FilterOption.upc,
        addFilter: addFilter,
        removeFilterByOption: removeFilter,
        caption: 'Всі товари',
        searchHint: 'Пошук за upc, назвою товару, виробником...',
      ),
    ];
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
