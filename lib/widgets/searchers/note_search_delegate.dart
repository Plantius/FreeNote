import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/widgets/note_entry.dart';
import 'package:free_note/widgets/searchers/simple_search_delegate.dart';

class NoteSearchDelegate extends SimpleSearchDelegate<Note> {
  NoteSearchDelegate({required super.entries});

  @override
  Widget buildEntry(BuildContext context, Note note) {
    return NoteEntry(
      note: note,
      noteId: note.id,
      onTap: () {
        close(context, note);
      },
    );
  }

  @override
  bool matches(String query, Note entry) {
    return entry.title.toLowerCase().contains(query.toLowerCase()) ||
        entry.content.toLowerCase().contains(query.toLowerCase());
  }
}
