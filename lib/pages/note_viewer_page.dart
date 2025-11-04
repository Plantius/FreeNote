import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:free_note/widgets/markdown_viewer.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NoteViewerPage extends StatelessWidget {
  final int noteId;
  const NoteViewerPage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    final notesProvider = context.watch<NotesProvider>();

    return FutureBuilder<Note?>(
      future: notesProvider.getNote(noteId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(body: Center(child: Text('Note not found')));
        }

        final note = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(note.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final updatedNote = await context.push(
                    '/note/${note.id}/edit',
                    extra: note,
                  );

                  if (updatedNote != null && context.mounted) {
                    // You can trigger a refresh manually if needed
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
            ],
          ),
          body: MarkdownViewer(data: note.content),
        );
      },
    );
  }
}
