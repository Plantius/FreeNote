import 'package:flutter/material.dart';

abstract class SimpleSearchDelegate<T> extends SearchDelegate<T?> {
  List<T> entries;

  SimpleSearchDelegate({required this.entries});

  bool matches(String query, T entry);

  Widget buildEntry(BuildContext context, T entry);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildMatches(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildMatches(context);
  }

  Widget _buildMatches(BuildContext context) {
    final results = entries
        .where((entry) => matches(query, entry))
        .map((entry) => buildEntry(context, entry))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) => results[index],
      ),
    );
  }
}
