import 'package:flutter/material.dart';

import '../../../model/basic_models/product.dart';
import '../../../model/joined_models/product_with_category.dart';
import '../../../model/search_models/short_category.dart';
import '../../../services/query_builder/filter.dart';
import '../../../services/query_builder/sort.dart';
import '../../../utils/navigation.dart';
import '../../widgets/queries/filters/search_filter.dart';
import '../../widgets/queries/search_button.dart';
import '../../widgets/queries/sort_block.dart';
import '../../widgets/resources/collections/collection_view.dart';
import '../../widgets/resources/collections/model_collection_view.dart';

void _redirectToAddingModel(BuildContext context) =>
    AppNavigation.of(context).openModelCreation<Product>();

class ProductsView extends ModelCollectionView<ProductWithCategory> {
  const ProductsView({super.key})
      : super(
          defaultSortField: SortOption.productName,
          searchFilterDelegate: ProductsSearchFilters.new,
          onAddPressed: _redirectToAddingModel,
        );
}

class ProductsSearchFilters extends CollectionSearchFilterDelegate {
  const ProductsSearchFilters({
    required super.queryBuilder,
    required super.updateCallback,
  });

  @override
  List<Widget> buildFilters(BuildContext context) {
    return [];
  }

  @override
  List<Widget> buildSearches(BuildContext context) {
    return [
      ConnectedModelFilter<int, ShortCategory>(
        filterOption: FilterOption.categoryId,
        caption: 'Всі категорії',
        addFilter: addFilter,
        removeFilterByOption: removeFilter,
      ),
      // SearchButton<int, ShortCategory>(
      //   filterOption: FilterOption.categoryId,
      //   searchCaption: 'Назва категорії...',
      //   addFilter: addFilter,
      //   removeFilter: removeFilter,
      // ),
      SearchFilter(
        filterOption: FilterOption.productName,
        removeFilter: removeFilter,
        addFilter: addFilter,
        caption: 'Назва товару...',
      ),
    ];
  }

  @override
  Widget buildSort(BuildContext context) {
    const sortOptions = [
      SortOption.productName,
    ];

    return SortBlock(
      sortOptions: sortOptions,
      initialSort: queryBuilder.sort,
      setSort: updateSort,
    );
  }
}
