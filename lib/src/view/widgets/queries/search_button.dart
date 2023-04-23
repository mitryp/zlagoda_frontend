import 'package:flutter/material.dart';

import '../../../services/query_builder/filter.dart';
import 'filters/types.dart';
import 'search_popup_delegate.dart';

class SearchButton extends StatefulWidget {
  final FilterOption filterOption;
  final String searchCaption;
  final AddFilter addFilter;
  final RemoveFilter removeFilter;

  const SearchButton({
    required this.filterOption,
    required this.searchCaption,
    required this.addFilter,
    required this.removeFilter,
    super.key,
  });

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  late String caption = widget.searchCaption;
  String? filterValue;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final categories = ['Овочі', 'Фрукти', 'Молочні продукти'];

        final selected = await showSearch(
          context: context,
          delegate: SearchPopupDelegate(categories, widget.searchCaption),
          query: filterValue
        );

        setState(() {
          if (selected == null || selected.isEmpty) {
            caption = widget.searchCaption;
            filterValue = null;
            widget.removeFilter(widget.filterOption);
          } else {
            caption = '${widget.searchCaption}: $selected';
            filterValue = selected;
            widget.addFilter(Filter(widget.filterOption, selected));
          }
        });
        // final categories = await const CategoryService()
        //     .get(QueryBuilder(sort: Sort(SortOption.categoryName)));

        // showSearch(
        //   context: context,
        //   delegate: SearchPopup(
        //       categories.map((category) => category.categoryName).toList()),
        // );
      },
      child: Text(caption),
    );
  }
}
