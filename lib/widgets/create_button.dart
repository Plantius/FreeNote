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

class CreateButton extends StatelessWidget {
  const CreateButton({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        dynamic created = await showPopover<dynamic>(
          context: context,
          bodyBuilder: (context) => CreatePopOver(),
          height: 120,
          backgroundColor: Theme.of(context).colorScheme.surface,
          direction: PopoverDirection.top,
        );

        logger.i('Created $created');

        if (created is Note && context.mounted) {
          context.push('/note/${created.id}');
        }
      },
      child: Icon(Icons.add),
    );
  }
}

class CreatePopOver extends StatelessWidget {
  const CreatePopOver({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => _onCreateNote(context),
          child: Icon(Icons.note, size: 30, color: Colors.white),
        ),

        TextButton(
          onPressed: () => _onCreateEvent(context),
          child: Icon(Icons.event, size: 30, color: Colors.white),
        ),

        // TextButton(
        //   onPressed: null,
        //   child: Icon(Icons.music_note, size: 30, color: Colors.white),
        // ),

        // TextButton(
        //   onPressed: null,
        //   child: Icon(Icons.image, size: 30, color: Colors.white),
        // ),
      ],
    );
  }

  Future<void> _onCreateNote(BuildContext context) async {
    final Note? note = await showModalBottomSheet(
      context: context,
      builder: (context) => CreateNoteOverlay(isNested: false),
    );

    if (context.mounted) {
      if (note == null) {
        context.pop(null);
      } else {
        Note? created = await context.read<NotesProvider>().saveNote(note);

        if (context.mounted) {
          context.pop(created);
        }
      }
    }
  }

  Future<void> _onCreateEvent(BuildContext context) async {
    final Event? event = await showModalBottomSheet(
      context: context,
      builder: (context) => CreateEventOverlay(),
    );

    if (context.mounted) {
      if (event == null) {
        context.pop(null);
      } else {
        Event? created = await context.read<EventsProvider>().addEvent(event);

        if (context.mounted) {
          context.pop(created);
        }
      }
    }
  }
}
