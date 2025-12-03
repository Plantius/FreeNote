import 'package:flutter/material.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:free_note/widgets/note_entry.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [Expanded(child: _buildNotesList(context))]),
    );
  }

  Widget _buildNotesList(BuildContext context) {
    final provider = context.watch<NotesProvider>();
    final notes = provider.rootNotes;

    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[notes.length - index - 1];

          return NoteEntry(
            note: note,
            noteId: note.id,
          );
        },
      ),
      onRefresh: () async {
        await provider.loadNotes();
      },
    );
  }
}
