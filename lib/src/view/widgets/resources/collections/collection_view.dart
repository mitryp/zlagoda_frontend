import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../model/interfaces/convertible_to_row.dart';
import '../../../../model/schema/schema.dart';
import '../../../../services/query_builder/query_builder.dart';
import '../../../../services/query_builder/sort.dart';
import '../../../pages/page_base.dart';

abstract class CollectionSearchFilterDelegate {
  final EventSink<void> updateSink;
  final QueryBuilder queryBuilder;

  const CollectionSearchFilterDelegate({
    required this.updateSink,
    required this.queryBuilder,
  });

  void updateSort(Sort sort) {
    queryBuilder.sort = sort;
    updateSink.add(null);
  }

  List<Widget> buildSearches(BuildContext context);

  List<Widget> buildFilters(BuildContext context);

  Widget buildSort(BuildContext context);
}

class CollectionView<M extends ConvertibleToRow<M>> extends StatefulWidget {
  final List<M> collection;
  final CollectionSearchFilterDelegate searchFilterDelegate;
  final EventSink<void> updateSink;
  final VoidCallback onAddPressed;

  // final List<String> columnNames;
  final Schema<M> elementSchema;

  const CollectionView(
    this.collection, {
    // required this.columnNames,
    required this.elementSchema,
    required this.updateSink,
    required this.searchFilterDelegate,
    required this.onAddPressed,
    super.key,
  });

  @override
  State<CollectionView<M>> createState() => _CollectionViewState<M>();
}

class _CollectionViewState<M extends ConvertibleToRow<M>>
    extends State<CollectionView<M>> {
  late final List<String> columnNames = widget.elementSchema.retrievers
      .where((r) => r.isShownInTable)
      .map((r) => r.labelCaption!)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBase.column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSearchFilters(),
          DataTable(
            showCheckboxColumn: false,
            columns: columnNames
                .map((name) => DataColumn(label: Text(name)))
                .toList(),
            rows: widget.collection.map((m) => m.buildRow(context)).toList(),
          ),
        ],
      ),
      floatingActionButton: buildAddButton(),
    );
  }

  Widget buildSearchFilters() {
    const divider = VerticalDivider();

    return Card(
      child: Row(
        children: [
          ...widget.searchFilterDelegate.buildSearches(context),
          divider,
          ...widget.searchFilterDelegate.buildFilters(context),
          divider,
          widget.searchFilterDelegate.buildSort(context)
        ],
      ),
    );
  }

  Widget buildAddButton() => ElevatedButton(
        onPressed: widget.onAddPressed,
        child: const Text('Додати'),
      );
}
