import 'dart:math';

import 'package:flutter/material.dart';

import '../../../model/interfaces/search_model.dart';

class SearchPopupDelegate<SM extends SearchModel> extends SearchDelegate<SM?> {
  final List<SM> initialOptions;
  final String? searchHint;
  SM? result;

  SearchPopupDelegate(this.initialOptions, [this.searchHint = 'Пошук']);

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
      final suggestion = option.descriptiveField.toLowerCase();
      final input = query.toLowerCase();

      return suggestion.contains(input);
    }).toList();

    suggestions = suggestions.sublist(0, min(suggestions.length, 20));

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
              title: Text(suggestion.descriptiveField),
              onTap: () {
                query = suggestion.descriptiveField;
                result = suggestion;
                close(context, result);
              });
        });
  }
}
