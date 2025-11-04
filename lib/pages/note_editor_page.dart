import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class NoteEditorPage extends StatefulWidget {
  final Note note;
  const NoteEditorPage({super.key, required this.note});

  @override
  NoteEditorPageState createState() => NoteEditorPageState();
}

class NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController _controller;
  NotesProvider? _notesProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notesProvider ??= context.read<NotesProvider>();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    logger.d('Saving note ${widget.note.id} [todo]');
    final updatedNote = widget.note.copyWith(content: _controller.text);
    _notesProvider?.saveNote(updatedNote);
    Navigator.of(context).pop(updatedNote);

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.note.title)),
      body: Column(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration.collapsed(hintText: '...'),
            ),
          ),
        ],
      ),
    );
  }
}
