import 'dart:math';

import 'package:flutter/material.dart';

import '../../../model/interfaces/search_model.dart';

class SearchPopupDelegate<SM extends SearchModel> extends SearchDelegate<SM?> {
  final List<SM> initialOptions;
  SM? result;

  SearchPopupDelegate(this.initialOptions, [searchHint = 'Пошук'])
      : super(searchFieldLabel: searchHint);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () => close(context, result),
          icon: const Icon(Icons.check),
        ),
        IconButton(
          onPressed: () {
            if (query.isEmpty)
              close(context, null);
            else {
              query = '';
              result = null;
            }
          },
          icon: const Icon(Icons.close),
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    List<SM> suggestions = initialOptions.where((option) {
      final suggestion = option.toString().toLowerCase();
      final input = query.toLowerCase();

      return suggestion.contains(input);
    }).toList();

    suggestions = suggestions.sublist(0, min(suggestions.length, 20));

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
              title: Text(suggestion.toString()),
              onTap: () {
                query = suggestion.toString();
                result = suggestion;
                close(context, result);
              });
        });
  }
}
