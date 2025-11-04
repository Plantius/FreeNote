import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/widgets/markdown_viewer.dart';
import 'package:go_router/go_router.dart';

class NoteViewerPage extends StatelessWidget {
  final Note note;
  const NoteViewerPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/note/${note.id}/edit', extra: note);
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: MarkdownViewer(data: note.content),
    );
  }
}
