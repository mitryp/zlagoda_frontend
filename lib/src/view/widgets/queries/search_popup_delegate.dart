import 'dart:math';

import 'package:flutter/material.dart';

class SearchPopupDelegate extends SearchDelegate {
  final List<String> initialSuggestions;
  final String? searchHint;

  SearchPopupDelegate(this.initialSuggestions, [this.searchHint = 'Пошук']);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () => close(context, query),
          icon: const Icon(Icons.check),
        ),
        IconButton(
          onPressed: () {
            if (query.isEmpty)
              close(context, null);
            else
              query = '';
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
    List<String> suggestions = initialSuggestions.where((suggestion) {
      final result = suggestion.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    suggestions = suggestions.sublist(0, min(suggestions.length, 20));

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
              title: Text(suggestion),
              onTap: () {
                query = suggestion;
                close(context, query);
                // showResults(context);
              });
        });
  }
}
