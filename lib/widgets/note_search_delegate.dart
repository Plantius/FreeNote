
import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/widgets/note_entry.dart';

class NoteSearchDelegate extends SearchDelegate<Note?> {
  List<Note> notes;

  NoteSearchDelegate({required this.notes});

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
    final results = notes
      .where((note) {
        return note.title.toLowerCase().contains(query.toLowerCase())
          || note.content.toLowerCase().contains(query.toLowerCase());
      })
      .map((note) => NoteEntry(
        note: note, 
        noteId: note.id,
        onTap: () {
          close(context, note);
        },
      ))
      .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => results[index]
    );
  }
}
