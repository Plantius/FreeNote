import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:free_note/widgets/overlays/bottom_overlay.dart';
import 'package:provider/provider.dart';

class CreateNoteOverlay extends StatefulWidget {

  const CreateNoteOverlay({super.key});

  @override
  State<CreateNoteOverlay> createState() => _CreateNoteOverlayState();
}

class _CreateNoteOverlayState extends State<CreateNoteOverlay> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BottomOverlay(
      onDone: () {
        final name = _nameController.text.trim();
        if (name.isEmpty) return null;

        return context.read<NotesProvider>().saveNote(
          Note(
            id: 0,
            title: name,
            content: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isNested: true,
          )
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
          ],
        ),
      ),
    );
  }
}