import 'package:flutter/material.dart';

import '../../../model/interfaces/search_model.dart';
import '../../../services/http/http_service_factory.dart';
import '../../../services/query_builder/filter.dart';
import '../../../services/query_builder/sort.dart';
import 'filters/types.dart';
import 'search_popup_delegate.dart';

class SearchButton<K, SM extends SearchModel<K>> extends StatefulWidget {
  final FilterOption<K> filterOption;
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
  State<SearchButton> createState() => _SearchButtonState<K, SM>();
}

class _SearchButtonState<K, SM extends SearchModel<K>> extends State<SearchButton> {
  late String caption = widget.searchCaption;
  String? selectedItem;
  bool _isLoading = false;

  void _handleClick() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final fetchedItems = await makeShortModelHttpService<SM>().get();
    setState(() => _isLoading = false);

    if (!context.mounted) return;

    final selected = await showSearch(
        context: context,
        delegate: SearchPopupDelegate<SM>(fetchedItems, widget.searchCaption),
        query: selectedItem?.toString() ?? '');

    setState(() {
      if (selected == null) {
        selectedItem = null;
        widget.removeFilter(widget.filterOption);
      } else {
        selectedItem = selected.descriptiveField;
        widget.addFilter(Filter(widget.filterOption, selected.primaryKey));
      }

      caption =
          selectedItem == null ? widget.searchCaption : '${widget.searchCaption}: $selectedItem';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _handleClick,
      child: _isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            )
          : Text(caption),
    );
  }
}
