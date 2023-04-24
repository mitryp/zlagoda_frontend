import 'package:flutter/material.dart';

import '../../../model/interfaces/search_model.dart';
import '../../../services/http/http_service_factory.dart';
import '../../../services/query_builder/filter.dart';
import '../../../typedefs.dart';
import 'filters/types.dart';
import 'model_search_initiator.dart';
import 'search_popup_delegate.dart';

class SearchButton<K, SM extends ShortModel<K>> extends StatefulWidget {
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

class _SearchButtonState<K, SM extends ShortModel<K>> extends State<SearchButton> {
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
      query: selectedItem?.toString() ?? '',
    );

    setState(() {
      if (selected == null) {
        selectedItem = null;
        widget.removeFilter(widget.filterOption);
      } else {
        selectedItem = selected.descriptiveAttr;
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

class ConnectedModelFilter<K, SM extends ShortModel<K>> extends StatelessWidget {
  final FilterOption<K> filterOption;
  final String caption;
  final UpdateCallback<Filter<K>> addFilter;
  final UpdateCallback<FilterOption> removeFilterByOption;

  const ConnectedModelFilter({
    required this.filterOption,
    required this.caption,
    required this.addFilter,
    required this.removeFilterByOption,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ModelSearchInitiator<K, SM>(
      preserveSearchOnCancel: false,
      selectionBuilder: (context, selected) {
        return Text(selected != null ? selected.descriptiveAttr : caption);
      },
      container: ({required child, required onTap}) => ElevatedButton(
        onPressed: onTap,
        child: child,
      ),
      onUpdate: (newPrimaryKey) {
        if (newPrimaryKey == null) {
          removeFilterByOption(filterOption);
        }
        else {
          addFilter(Filter(filterOption, newPrimaryKey));
        }
      },
    );
  }
}
