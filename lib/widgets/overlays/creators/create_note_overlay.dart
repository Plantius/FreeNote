import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/widgets/overlays/bottom_overlay.dart';

class CreateNoteOverlay extends StatefulWidget {
  final bool isNested;

  const CreateNoteOverlay({super.key, required this.isNested});

  @override
  State<CreateNoteOverlay> createState() => _CreateNoteOverlayState();
}

class _CreateNoteOverlayState extends State<CreateNoteOverlay> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BottomOverlay<Note>(
      onDone: () {
        final name = _nameController.text.trim();
        if (name.isEmpty) return null;

        return Note(
          id: 0,
          title: name,
          content: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isNested: widget.isNested,
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