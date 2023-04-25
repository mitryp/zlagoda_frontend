import 'package:flutter/material.dart';

import '../../../model/basic_models/receipt.dart';
import '../../../model/other_models/table_receipt.dart';
import '../../../model/search_models/short_cashier.dart';
import '../../../services/query_builder/filter.dart';
import '../../../services/query_builder/sort.dart';
import '../../../utils/navigation.dart';
import '../../../utils/value_status.dart';
import '../../widgets/queries/connected_model_filter.dart';
import '../../widgets/queries/filters/date_filter.dart';
import '../../widgets/queries/sort_block.dart';
import '../../widgets/resources/collections/collection_view.dart';
import '../../widgets/resources/collections/model_collection_view.dart';

Future<ValueStatusWrapper> _redirectToAddingModel(BuildContext context) =>
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
      DateFilter(
        addFilter: addFilter,
        removeFilter: removeFilter,
      ),
      ConnectedModelFilter<String, ShortCashier>(
        filterOption: FilterOption.employeeId,
        addFilter: addFilter,
        removeFilterByOption: removeFilter,
        caption: 'Всі касири',
        searchHint: 'Пошук касирів за табельним номером або ПІБ...',
      ),
    ];
  }

  @override
  List<Widget> buildSearches(BuildContext context) {
    return [];
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
