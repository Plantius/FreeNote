import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/providers/events_provider.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:free_note/widgets/overlays/creators/create_event_overlay.dart';
import 'package:free_note/widgets/overlays/creators/create_note_overlay.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class AddNotePopupMenu extends StatelessWidget {
  const AddNotePopupMenu({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        dynamic added = await showPopover<dynamic>(
          context: context,
          bodyBuilder: (context) => AddMenuItems(),
          // width: 50,
          height: 140,
          backgroundColor: Colors.deepPurple,
          direction: PopoverDirection.top,
        );

        logger.i('Added $added');

        if (added is Note && context.mounted) {
          context.push('/note/${added.id}');
        }
      },
      child: Icon(Icons.add),
    );
  }
}

class AddMenuItems extends StatelessWidget {
  const AddMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => _onAddNote(context),
          child: Icon(Icons.note, size: 30, color: Colors.white),
        ),

        TextButton(
          onPressed: () => _onAddEvent(context),
          child: Icon(Icons.event, size: 30, color: Colors.white),
        ),

        TextButton(
          onPressed: null,
          child: Icon(Icons.music_note, size: 30, color: Colors.white),
        ),

        TextButton(
          onPressed: null,
          child: Icon(Icons.image, size: 30, color: Colors.white),
        ),
      ],
    );
  }

  Future<void> _onAddNote(BuildContext context) async {
    final Note? note = await showModalBottomSheet(
      context: context, 
      builder: (context) => CreateNoteOverlay(
        isNested: false,
      ),
    );

    if (note != null && context.mounted) {
      Note? created = await context.read<NotesProvider>().saveNote(note);

      if (context.mounted) {
        context.pop(created);
      }
    }
  }

  Future<void> _onAddEvent(BuildContext context) async {
    final Event? event = await showModalBottomSheet(
      context: context,
      builder: (context) => CreateEventOverlay(),
    );

    if (event != null && context.mounted) {
      Event? created = await context.read<EventsProvider>().addEvent(event);

      if (context.mounted) {
        context.pop(created);
      }
    }
  }
}
