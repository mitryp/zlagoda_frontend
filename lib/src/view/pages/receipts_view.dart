import 'package:flutter/material.dart';

import '../../model/basic_models/receipt.dart';
import '../../model/other_models/table_receipt.dart';
import '../../model/search_models/short_employee.dart';
import '../../services/query_builder/filter.dart';
import '../../services/query_builder/sort.dart';
import '../../utils/navigation.dart';
import '../widgets/queries/filters/date_filter.dart';
import '../widgets/queries/search_button.dart';
import '../widgets/queries/sort_block.dart';
import '../widgets/resources/collections/collection_view.dart';
import '../widgets/resources/collections/model_collection_view.dart';

void _redirectToAddingModel(BuildContext context) =>
    AppNavigation.of(context).openModelCreation<Receipt>();

class ReceiptsView extends ModelCollectionView<TableReceipt> {
  const ReceiptsView({super.key})
      : super(
          defaultSortField: SortOption.date,
          searchFilterDelegate: ReceiptsSearchFilters.new,
          onAddPressed: _redirectToAddingModel,
        );
}

class ReceiptsSearchFilters extends CollectionSearchFilterDelegate {
  const ReceiptsSearchFilters({
    required super.queryBuilder,
    required super.updateCallback,
  });

  @override
  List<Widget> buildFilters(BuildContext context) {
    return [
      DateFilter(addFilter: addFilter, removeFilter: removeFilter),
    ];
  }

  @override
  List<Widget> buildSearches(BuildContext context) {
    return [
      SearchButton<String, ShortEmployee>(
        filterOption: FilterOption.employeeName,
        searchCaption: 'ПІБ касира...',
        addFilter: addFilter,
        removeFilter: removeFilter,
      ),
    ];
  }

  @override
  Widget buildSort(BuildContext context) {
    const sortOptions = [
      SortOption.date,
    ];

    return SortBlock(
      sortOptions: sortOptions,
      initialSort: queryBuilder.sort,
      setSort: updateSort,
    );
  }
}