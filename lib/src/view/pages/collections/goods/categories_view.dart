import 'package:flutter/material.dart';

import '../../../../model/basic_models/category.dart';
import '../../../../services/query_builder/sort.dart';
import '../../../../utils/navigation.dart';
import '../../../../utils/value_status.dart';
import '../../../widgets/queries/sort_block.dart';
import '../../../widgets/resources/collections/collection_view.dart';
import '../../../widgets/resources/collections/model_collection_view.dart';


Future<ValueStatusWrapper> _redirectToAddingModel(BuildContext context) =>
    AppNavigation.of(context).openModelCreation<Category>();

class CategoriesView extends ModelCollectionView<Category, Category> {
  const CategoriesView({super.key})
      : super(
          defaultSortField: SortOption.categoryName,
          searchFilterDelegate: CategorySearchFilters.new,
          onAddPressed: _redirectToAddingModel,
        );
}

class CategorySearchFilters extends CollectionSearchFilterDelegate {
  const CategorySearchFilters({
    required super.queryBuilder,
    required super.updateCallback,
  });

  @override
  List<Widget> buildFilters(BuildContext context) {
    return [];
  }

  @override
  List<Widget> buildSearches(BuildContext context) {
    return [];
  }

  @override
  Widget buildSort(BuildContext context) {
    const sortOptions = [
      SortOption.categoryName,
    ];

    return SortBlock(
      sortOptions: sortOptions,
      initialSort: queryBuilder.sort,
      setSort: updateSort,
    );
  }
}
