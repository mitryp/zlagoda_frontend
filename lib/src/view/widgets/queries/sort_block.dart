import 'package:flutter/material.dart';

import '../../../services/query_builder/sort.dart';
import '../../../theme.dart';

typedef SetSort = void Function(Sort);

class SortBlock extends StatefulWidget {
  final List<SortOption> sortOptions;
  final Sort initialSort;
  final SetSort setSort;

  const SortBlock({
    required this.sortOptions,
    required this.initialSort,
    required this.setSort,
    super.key,
  });

  @override
  State<SortBlock> createState() => _SortBlockState();

  List<Widget> get sortTextWidgets => sortOptions
      .map((sortOption) => Padding(
            padding: defaultButtonStyle.padding!.resolve({})! ~/ 2,
            child: Text(sortOption.caption),
          ))
      .toList();
}

class _SortBlockState extends State<SortBlock> {
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
    widget.setSort(sort);
  }

  void _toggleSortOrder() {
    setState(() {
      final sortOption = currentSort.sortOption;
      final newSortOrder = currentSort.order == Order.asc ? Order.desc : Order.asc;

      updateSort(Sort(sortOption, newSortOrder));
    });
  }

  void _changeSortField(int index, List<bool> selectedSortFields) {
    if (widget.sortOptions[index] == currentSort.sortOption) return;

    setState(() {
      for (int i = 0; i < selectedSortFields.length; i++) {
        selectedSortFields[i] = i == index;
      }

      updateSort(Sort(widget.sortOptions[index]));
    });
  }

  Widget buildSortFieldButton() {
    final List<bool> selectedSortFields =
        widget.sortOptions.map((field) => field == currentSort.sortOption).toList();

    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) => _changeSortField(index, selectedSortFields),
      isSelected: selectedSortFields,
      children: widget.sortTextWidgets,
    );
  }

  Widget buildDirectionButton() => IconButton(
        onPressed: () => _toggleSortOrder(),
        icon: Icon(currentSort.order.icon),
        splashRadius: 20,
      );
}
