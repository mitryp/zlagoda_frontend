import 'package:flutter/material.dart';

import '../../../model/basic_models/product.dart';
import '../../../services/query_builder/filter.dart';
import '../../../services/query_builder/sort.dart';
import '../../widgets/queries/filters/checkbox_filter.dart';
import '../../widgets/queries/filters/date_filter.dart';
import '../../widgets/queries/filters/chips_filter.dart';
import '../../widgets/queries/filters/search_filter.dart';
import '../../widgets/queries/search_button.dart';
import '../../widgets/queries/sort_block.dart';
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
    return [
      DateFilter(
        addFilter: addFilter,
        removeFilter: removeFilter,
      ),
      ChipsFilter(
          filterOption: FilterOption.categoryName,
          availableChoices: const ['Овочі', 'Фрукти'],
          addFilter: addFilter,
          removeFilter: removeFilter),
      CheckboxFilter(
        filterOption: FilterOption.isProm,
        addFilter: addFilter,
        removeFilter: removeFilter,
        title: 'Тільки акційні товари',
      )
    ];
  }

  @override
  List<Widget> buildSearches(BuildContext context) {
    // TODO: implement buildSearches
    return [
      SearchButton(
        filterOption: FilterOption.categoryName,
        searchCaption: 'Пошук за категорією',
        addFilter: addFilter,
        removeFilter: removeFilter,
      ),
      SearchFilter(
        filterOption: FilterOption.productName,
        removeFilter: removeFilter,
        addFilter: addFilter,
        caption: 'Назва продукту...',
      ),
    ];
  }

  @override
  Widget buildSort(BuildContext context) {
    const sortOptions = [
      SortOption.productName,
      //TODO remove
      SortOption.manufacturer,
    ];

    return SortBlock(
      sortOptions: sortOptions,
      initialSort: queryBuilder.sort,
      setSort: updateSort,
    );
  }
}
