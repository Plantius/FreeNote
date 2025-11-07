import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  void dispose() {
    logger.d('Saving note ${widget.note.id} [todo]');

    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration.collapsed(hintText: 'Title'),
          style: Theme.of(context).textTheme.titleLarge,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'[\r\n]')),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.note.content = _contentController.text;
              widget.note.title = _titleController.text;
              context.read<NotesProvider>().saveNote(widget.note);
            },
            icon: Icon(Icons.save),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: _contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration.collapsed(hintText: '...'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
