import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/basic_models/product.dart';
import '../../services/query_builder/filter.dart';
import '../../services/query_builder/query_builder.dart';
import '../../services/query_builder/sort.dart';
import '../widgets/queries/filters/date_filter.dart';
import '../widgets/resources/models/model_view.dart';
import '../widgets/stats_block.dart';
import 'confirmation_dialog.dart';

class ProductStatsDialogContent extends StatefulWidget {
  final String upc;

  const ProductStatsDialogContent({required this.upc, super.key});

  @override
  State<ProductStatsDialogContent> createState() => _ProductStatsDialogContentState();
}

class _ProductStatsDialogContentState extends State<ProductStatsDialogContent> {
  late final fetcher = StatsFetcher<int>(
      fieldName: 'quantity',
      label: 'Кількість одиниць товару проданого за заданий час',
      url: 'api/products/${widget.upc}/total_sold',
      allowedFilters: const [
        FilterOption.dateMin,
        FilterOption.dateMax,
      ]);

  final QueryBuilder queryBuilder = QueryBuilder(sort: Sort(SortOption.productName));
  late String presentation;
  bool isLoaded = false;
  final StreamController<void> updateController = StreamController();

  void withUpdate(VoidCallback fn) {
    fn();
    updateController.add(null);
  }

  void addFilter(Filter filter) => withUpdate(() => queryBuilder.addFilter(filter));

  void removeFilter(FilterOption filterOption) =>
      withUpdate(() => queryBuilder.removeFilter(filterOption));

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DateFilter(addFilter: addFilter, removeFilter: removeFilter),
        SizedBox(height: ConfirmationDialog.defaultStyle.padding),
        StatsBlock(
          [fetcher],
          updateStream: updateController.stream,
          queryBuilder: queryBuilder,
        ),
      ],
    );
  }
}

Widget buildProductStatsDialogButton(BuildContext context) {
  final key = context.widget.key as GlobalKey<ModelViewState<Product>>;

  void showStatsDialog(BuildContext context) => showConfirmationDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          content: ProductStatsDialogContent(
            upc: key.currentState!.model.upc,
          ),
          style: ConfirmationDialog.defaultStyle.copyWith(cancelButtonLabel: null),
        ),
      );

  return OutlinedButton.icon(
    onPressed: () => showStatsDialog(context),
    label: const Text('Переглянути статистику'),
    icon: const Icon(Icons.query_stats),
  );
}
