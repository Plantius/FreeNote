import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/note.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteViewerPage extends StatefulWidget {
  final Note note;
  const NoteViewerPage({super.key, required this.note});

  @override
  State<NoteViewerPage> createState() => _NoteViewerPageState();
}

class _NoteViewerPageState extends State<NoteViewerPage> {
  final QuillController _controller = QuillController.basic();
  bool editing = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      _controller.document = Document.fromJson(jsonDecode(widget.note.content));
    } on FormatException {
      logger.e('Unconverted note: "${widget.note.title}" (#${widget.note.id})');
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title, style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                editing = !editing;
              });
            },
            icon: Icon(
              editing 
              ? Icons.remove_red_eye 
              : Icons.edit
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          QuillSimpleToolbar(
            controller: _controller,
            config: const QuillSimpleToolbarConfig(),
          ),
          Expanded(
            child: QuillEditor.basic(
              controller: _controller,
              config: const QuillEditorConfig(),
            ),
          )
        ],
      ),
    );
  }
}
