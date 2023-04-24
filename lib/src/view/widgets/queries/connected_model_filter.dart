import 'package:flutter/material.dart';

import '../../../model/interfaces/search_model.dart';
import '../../../services/query_builder/filter.dart';
import '../../../typedefs.dart';
import 'model_search_initiator.dart';

class ConnectedModelFilter<K, SM extends ShortModel<K>> extends StatelessWidget {
  final FilterOption<K> filterOption;
  final String caption;
  final UpdateCallback<Filter<K>> addFilter;
  final UpdateCallback<FilterOption> removeFilterByOption;
  final String? searchHint;

  const ConnectedModelFilter({
    required this.filterOption,
    required this.caption,
    required this.addFilter,
    required this.removeFilterByOption,
    this.searchHint,
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
      searchHint: searchHint,
    );
  }
}
