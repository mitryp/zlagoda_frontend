import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../pages/page_base.dart';

abstract class SearchFilterDelegate {
  final EventSink<void> updateSink;

  const SearchFilterDelegate({required this.updateSink});

  List<Widget> buildSearches(BuildContext context);

  List<Widget> buildFilters(BuildContext context);

  Widget buildSort(BuildContext context);
}

class CollectionView<M extends Model> extends StatefulWidget {
  final List<M> collection;
  final SearchFilterDelegate searchFilterDelegate;
  final EventSink<void> updateSink;
  final VoidCallback onAddPressed;
  final List<String> columnNames;

  const CollectionView(
    this.collection, {
    required this.columnNames,
    required this.updateSink,
    required this.searchFilterDelegate,
    required this.onAddPressed,
    super.key,
  });

  @override
  State<CollectionView<M>> createState() => _CollectionViewState();
}

class _CollectionViewState<M extends Model> extends State<CollectionView<M>> {
  @override
  Widget build(BuildContext context) {
    return PageBase.column(
      children: [
        buildSearchFilters(),
        DataTable(
          columns: widget.columnNames.map((name) => DataColumn(label: Text(name))).toList(),
          rows: widget.collection.map((m) => m.buildRow(context)).toList(),
        ),
        buildAddButton(),
      ],
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
