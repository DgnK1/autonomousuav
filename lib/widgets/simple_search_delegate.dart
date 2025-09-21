import 'package:flutter/material.dart';

class SimpleSearchDelegate extends SearchDelegate<String> {
  final List<String> data;
  final String emptyLabel;

  SimpleSearchDelegate({
    required this.data,
    this.emptyLabel = 'No matches',
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = data
        .where((e) => e.toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (results.isEmpty) {
      return Center(child: Text(emptyLabel));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          title: Text(item),
          onTap: () => close(context, item),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = data
        .where((e) => e.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          title: Text(item),
          onTap: () {
            query = item;
            showResults(context);
          },
        );
      },
    );
  }
}
