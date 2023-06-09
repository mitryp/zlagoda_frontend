import 'package:flutter/material.dart';

import '../../../model/basic_models/employee.dart';
import '../../../services/auth/user.dart';
import '../../../services/query_builder/filter.dart';
import '../../../services/query_builder/sort.dart';
import '../../../utils/navigation.dart';
import '../../../utils/value_status.dart';
import '../../widgets/auth/authorizer.dart';
import '../../widgets/queries/filters/chips_filter.dart';
import '../../widgets/queries/filters/search_filter.dart';
import '../../widgets/queries/sort_block.dart';
import '../../widgets/resources/collections/collection_view.dart';
import '../../widgets/resources/collections/model_collection_view.dart';

Future<ValueStatusWrapper> _redirectToAddingModel(BuildContext context) =>
    AppNavigation.of(context).openModelCreation<Employee>();

bool _isManager(User? user) => hasPosition(Position.manager)(user);

class EmployeesView extends ModelCollectionView<Employee, Employee> {
  const EmployeesView({super.key})
      : super(
          defaultSortField: SortOption.employeeSurname,
          searchFilterDelegate: EmployeesSearchFilters.new,
          onAddPressed: _redirectToAddingModel,
          authorizationStrategy: _isManager,
        );
}

class EmployeesSearchFilters extends CollectionSearchFilterDelegate {
  const EmployeesSearchFilters({
    required super.queryBuilder,
    required super.updateCallback,
  });

  @override
  List<Widget> buildFilters(BuildContext context) {
    return [
      ChipsFilter(
        filterOption: FilterOption.position,
        availableChoices: {
          Position.cashier: Position.cashier.toString(),
          Position.manager: Position.manager.toString()
        },
        addFilter: addFilter,
        removeFilter: removeFilter,
      ),
    ];
  }

  @override
  List<Widget> buildSearches(BuildContext context) {
    return [
      SearchFilter(
        filterOption: FilterOption.employeeSurname,
        removeFilter: removeFilter,
        addFilter: addFilter,
        caption: 'Прізвище працівника...',
      ),
    ];
  }

  @override
  Widget buildSort(BuildContext context) {
    const sortOptions = [
      SortOption.employeeSurname,
    ];

    return SortBlock(
      sortOptions: sortOptions,
      initialSort: queryBuilder.sort,
      setSort: updateSort,
    );
  }
}
