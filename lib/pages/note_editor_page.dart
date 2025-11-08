import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class NoteEditorPage extends StatefulWidget {
  final Note note;
  const NoteEditorPage({super.key, required this.note});

  @override
  NoteEditorPageState createState() => NoteEditorPageState();
}

class NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool unsavedchanges = false; //If True unsaved changes are present

  void setUnsavedTrue() {
    unsavedchanges = true;
  }

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
        leading: BackButton(
          onPressed: () {
            if(unsavedchanges == true)
            {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('You have unsaved changes. Discard these?'),
                    actions: [
                      TextButton(
                        child: const Text('No'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () => context.go('/'), /*Navigator.of(context).popUntil(
                          ModalRoute.withName('/'),*/
                        //),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: TextField(
          controller: _titleController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration.collapsed(hintText: 'Title'),
          style: Theme.of(context).textTheme.titleLarge,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'[\r\n]')),
          ],
          onChanged: (value) => {
            if(unsavedchanges == false)
            {
              setUnsavedTrue()
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.note.content = _contentController.text;
              widget.note.title = _titleController.text;
              unsavedchanges = false;
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
                onChanged: (value) => {
                  if(unsavedchanges == false)
                  {
                    setUnsavedTrue()
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
