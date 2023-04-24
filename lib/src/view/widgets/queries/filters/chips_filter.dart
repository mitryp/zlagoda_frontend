import 'package:flutter/material.dart';

import '../../../../services/query_builder/filter.dart';
import '../../utils/helping_functions.dart';
import 'types.dart';

class ChipsFilter<V> extends StatefulWidget {
  final AddFilter addFilter;
  final RemoveFilter removeFilter;
  final FilterOption<V> filterOption;
  final Map<V, String> availableChoices;

  const ChipsFilter({
    required this.filterOption,
    required this.availableChoices,
    required this.addFilter,
    required this.removeFilter,
    super.key,
  });

  @override
  State<ChipsFilter> createState() => _ChipsFilterState();
}

class _ChipsFilterState<V> extends State<ChipsFilter<V>> {
  late final List<V> _options = [...widget.availableChoices.keys];

  @override
  Widget build(BuildContext context) {
    final filterChips = widget.availableChoices.keys
        .map((option) => buildFilterChip(option))
        .toList();

    return Row(children: makeSeparated(filterChips));
  }

  void _handleChoice(bool value, V option) {
    setState(() {
      if (value) {
        if (_options.contains(option)) return;

        _options.add(option);

        if (_options.length == widget.availableChoices.length) {
          widget.removeFilter(widget.filterOption);
        }
      } else {
        _options.remove(option);

        if (_options.isEmpty) {
          _options.addAll(widget.availableChoices.keys);
          widget.removeFilter(widget.filterOption);

          return;
        }

        V anotherOption = _options.firstWhere((o) => o != option);

        widget.addFilter(Filter(widget.filterOption, anotherOption));
      }
    });
  }

  Widget buildFilterChip(V option) {
    return FilterChip(
      label: Text(widget.availableChoices[option]!),
      selected: _options.contains(option),
      onSelected: (bool value) => _handleChoice(value, option),
    );
  }
}
