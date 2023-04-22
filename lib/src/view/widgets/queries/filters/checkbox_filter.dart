import 'package:flutter/material.dart';

import '../../../../services/query_builder/filter.dart';
import 'types.dart';

class CheckboxFilter extends StatefulWidget {
  final String title;
  final AddFilter addFilter;
  final RemoveFilter removeFilter;
  final FilterOption<bool> filterOption;

  const CheckboxFilter({
    required this.title,
    required this.filterOption,
    required this.addFilter,
    required this.removeFilter,
    super.key,
  });

  @override
  State<CheckboxFilter> createState() => _CheckboxFilterState();
}

class _CheckboxFilterState extends State<CheckboxFilter> {
  bool isChecked = false;

  void _handleCheck(bool? value) {
    setState(() {
      isChecked = value!;
      if (value)
        widget.addFilter(Filter(widget.filterOption, true));
      else
        widget.removeFilter(widget.filterOption);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        children: [
          Checkbox(
            //checkColor: Colors.white,
            //fillColor: MaterialStateProperty.resolveWith(getColor),
            value: isChecked,
            onChanged: (bool? value) => _handleCheck(value),
          ),
          Text(widget.title),
        ]
      ),
    );
  }
}
