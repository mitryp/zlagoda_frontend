import 'package:flutter/material.dart';

import '../../../services/query_builder/sort.dart';

typedef SetSort = void Function(Sort);

class SortWidget extends StatefulWidget {
  final List<SortOption> sortOptions;
  final Sort initialSort;
  final SetSort addSortToQB;

  const SortWidget({
    required this.sortOptions,
    required this.initialSort,
    required this.addSortToQB,
    super.key,
  });

  @override
  State<SortWidget> createState() => _SortWidgetState();

  List<Widget> get sortWidgets =>
      sortOptions.map((sortOption) => Text(sortOption.caption)).toList();
}

class _SortWidgetState extends State<SortWidget> {
  late Sort currentSort = widget.initialSort;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      buildSortFieldButton(),
      buildDirectionButton(),
    ]);
  }

  void updateSort(Sort sort) {
    currentSort = sort;
    widget.addSortToQB(sort);
  }

  void _toggleSortOrder() {
    setState(() {
      final sortOption = currentSort.sortOption;
      final newSortOrder =
          currentSort.order == Order.asc ? Order.desc : Order.asc;

      updateSort(Sort(sortOption, newSortOrder));
    });
  }

  void _changeSortField(int index, List<bool> selectedSortFields) {
    setState(() {
      for (int i = 0; i < selectedSortFields.length; i++) {
        selectedSortFields[i] = i == index;

        if (selectedSortFields[i])
          updateSort(Sort(widget.sortOptions[i]));
      }
    });
  }

  Widget buildSortFieldButton() {
    final List<bool> selectedSortFields = widget.sortOptions
        .map((field) => field == currentSort.sortOption)
        .toList();

    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) => _changeSortField(index, selectedSortFields),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.red[700],
      // TODO
      selectedColor: Colors.white,
      // TODO
      fillColor: Colors.red[200],
      // TODO
      color: Colors.red[400],
      // TODO
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 80.0,
      ),
      isSelected: selectedSortFields,
      children: widget.sortWidgets,
    );
  }

  Widget buildDirectionButton() {
    const icons = {
      Order.asc: Icon(Icons.arrow_upward_rounded),
      Order.desc: Icon(Icons.arrow_downward_rounded),
    };

    return ElevatedButton(
      onPressed: () => _toggleSortOrder(),
      child: icons[currentSort.order],
    );
  }
}
