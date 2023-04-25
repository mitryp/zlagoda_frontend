import 'package:flutter/material.dart';

import '../../model/basic_models/client.dart';
import '../../services/query_builder/filter.dart';
import '../../services/query_builder/sort.dart';
import '../../utils/navigation.dart';
import '../../utils/value_status.dart';
import '../widgets/queries/filters/search_filter.dart';
import '../widgets/queries/sort_block.dart';
import '../widgets/resources/collections/collection_view.dart';
import '../widgets/resources/collections/model_collection_view.dart';

Future<ValueStatusWrapper> _redirectToAddingModel(BuildContext context) =>
    AppNavigation.of(context).openModelCreation<Client>();

class ClientsView extends ModelCollectionView<Client> {
  const ClientsView({super.key})
      : super(
    defaultSortField: SortOption.clientSurname,
    searchFilterDelegate: ClientsSearchFilters.new,
    onAddPressed: _redirectToAddingModel,
  );
}

class ClientsSearchFilters extends CollectionSearchFilterDelegate {
  const ClientsSearchFilters({
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
      SearchFilter(
        filterOption: FilterOption.clientSurname,
        removeFilter: removeFilter,
        addFilter: addFilter,
        caption: 'Прізвище клієнта...',
      ),
      SearchFilter(
        filterOption: FilterOption.discount,
        removeFilter: removeFilter,
        addFilter: addFilter,
        caption: 'Має знижку...',
      ),
    ];
  }

  @override
  Widget buildSort(BuildContext context) {
    const sortOptions = [
      SortOption.clientSurname,
    ];

    return SortBlock(
      sortOptions: sortOptions,
      initialSort: queryBuilder.sort,
      setSort: updateSort,
    );
  }
}
