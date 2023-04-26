import 'package:flutter/material.dart';

import '../../../../model/schema/field_type.dart';
import '../../../../services/query_builder/filter.dart';
import '../../../../theme.dart';
import 'types.dart';

class DateFilter extends StatefulWidget {
  final AddFilter addFilter;
  final RemoveFilter removeFilter;

  const DateFilter({
    required this.addFilter,
    required this.removeFilter,
    super.key,
  });

  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  final defaultPeriodChoiceCaption = 'Обрати період';
  late final options = ['За увесь період', defaultPeriodChoiceCaption];
  int currentIndex = 0;

  Future<DateTimeRange?> pickDateTimeRange() async {
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: primary),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
  }

  Future _handleClick(int index, List<bool> selectedOptions) async {
    if (index == currentIndex) return;

    currentIndex = index;

    for (int i = 0; i < selectedOptions.length; i++) {
      selectedOptions[i] = i == index;
    }

    if (index == 0) {
      widget.removeFilter(FilterOption.dateMax);
      widget.removeFilter(FilterOption.dateMin);

      setState(() {
        options[1] = defaultPeriodChoiceCaption;
      });

      return;
    }

    final dateTimeRange = await pickDateTimeRange();
    if (dateTimeRange == null) {
      currentIndex = 0;
      return;
    }

    final start = dateTimeRange.start;
    final end = dateTimeRange.end;

    widget.addFilter(Filter(FilterOption.dateMin, start));
    widget.addFilter(Filter(FilterOption.dateMax, end));

    setState(() {
      options[1] =
          '${FieldType.date.presentation(start)} - ${FieldType.date.presentation(end)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedOptions = options
        .map((option) => options.indexOf(option) == currentIndex)
        .toList();

    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) => _handleClick(index, selectedOptions),
      isSelected: selectedOptions,
      children: options
          .map((option) => Padding(
                padding: defaultButtonStyle.padding!.resolve({})! ~/ 2,
                child: Text(option),
              ))
          .toList(),
    );
  }
}
