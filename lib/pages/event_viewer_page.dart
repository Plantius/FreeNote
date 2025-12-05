import 'package:flutter/material.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:free_note/widgets/note_entry.dart';
import 'package:free_note/widgets/overlays/creators/create_note_overlay.dart';
import 'package:intl/intl.dart';
import 'package:free_note/models/event.dart';
import 'package:free_note/pages/error_page.dart';
import 'package:free_note/providers/events_provider.dart';
import 'package:provider/provider.dart';

class EventViewerPage extends StatefulWidget {
  final Event? event;
  final int eventId;

  const EventViewerPage({super.key, this.event, required this.eventId});

  @override
  State<EventViewerPage> createState() => _EventViewerPageState();
}

class _EventViewerPageState extends State<EventViewerPage> {
  Event? event;

  @override
  void initState() {
    _loadEvent();
    super.initState();
  }

  void _loadEvent() {
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    if (event == null) {
      return ErrorPage(error: 'Event is (null)!');
    }

    final provider = context.read<EventsProvider>();
    final calendar = provider.getCalendar(event!.calendarId);

    Note? note = context.watch<NotesProvider>().getNote(
      event!.noteId, 
      strict: false
    );

    logger.i(event);

    return Scaffold(
      appBar: AppBar(
        title: Text(event!.title),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event!.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 8),
                    Text(
                      "${DateFormat('y MMM d H:m').format(event!.start)}"
                      " - ${DateFormat('y MMM d H:m').format(event!.end)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Color(calendar?.color ?? 0xFFFFFFFF),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      'Calendar: ${calendar?.name ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12),

            _buildAttachedNote(
              context, 
              note,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachedNote(BuildContext context, Note? note) {
    if (note == null) {
      return TextButton(
        onPressed: () async {
          final note = await showModalBottomSheet(
            context: context, 
            builder: (context) => CreateNoteOverlay(
              isNested: true
            ),
          );

          logger.d(note);

          if (note != null && context.mounted) {
            Note? created = await context.read<NotesProvider>().saveNote(note);
            logger.d(created);

            if (context.mounted) {
              context.read<EventsProvider>().addNoteToEvent(widget.event!, created);
            }
          }
        }, 
        child: const Text('Add Note to Event'),
      );
    }

    return NoteEntry(
      note: note, 
      noteId: 0,
    );
  }
}
