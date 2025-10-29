import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';

import 'package:free_note/widgets/markdown_viewer.dart';

class NoteDetailPage extends StatelessWidget {
  final Note note;
  const NoteDetailPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(note.title)),
      body: MarkdownViewer(data: note.content),
    );
  }
}
