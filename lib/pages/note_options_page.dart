import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:free_note/widgets/option_button.dart';
import 'package:free_note/widgets/confirm_dialog.dart';
import 'package:free_note/widgets/overlays/friends_overlay.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NoteOptionsPage extends StatefulWidget {
  final Note note;

  const NoteOptionsPage({super.key, required this.note});

  @override
  State<NoteOptionsPage> createState() => _NoteOptionsPageState();
}

class _NoteOptionsPageState extends State<NoteOptionsPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Options', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            OptionButton(
              action: () => _onShareNote(provider),
              icon: Icons.share,
              text: 'Share note',
            ),

            OptionButton(
              action: () => _onDeleteNote(provider),
              icon: Icons.delete,
              text: 'Delete Note',
              danger: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onShareNote(NotesProvider provider) async {
    Profile? profile = await showModalBottomSheet(
      context: context,
      builder: (context) => FriendsOverlay(),
    );

    if (profile != null && mounted) {
      provider.shareNote(widget.note, profile);
    }
  }

  Future<void> _onDeleteNote(NotesProvider provider) async {
    bool? delete = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          text: 'Are you sure that you want to delete this note?',
        );
      },
    );

    if ((delete ?? false) && mounted) {
      provider.deleteNote(widget.note);
      context.go('/notes');
    }
  }
}
