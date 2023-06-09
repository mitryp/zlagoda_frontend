import 'package:flutter/material.dart';

import '../../../../services/query_builder/filter.dart';
import '../../../../theme.dart';
import 'types.dart';

class SearchFilter<K> extends StatefulWidget {
  final String caption;
  final AddFilter addFilter;
  final RemoveFilter removeFilter;
  final FilterOption<K> filterOption;

  const SearchFilter({
    required this.caption,
    required this.filterOption,
    required this.removeFilter,
    required this.addFilter,
    super.key,
  });

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleInput(String value) async {
    setState(() {
      if (value.isEmpty)
        widget.removeFilter(widget.filterOption);
      else {
        widget.addFilter(Filter(widget.filterOption, value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
      child: TextField(
        controller: _controller,
        onChanged: (String value) => _handleInput(value),
        decoration: InputDecoration(
          label: Text(widget.caption),
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!),
            borderRadius: defaultBorderRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: defaultBorderRadius,
          ),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
