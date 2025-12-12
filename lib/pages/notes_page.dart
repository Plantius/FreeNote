import 'package:flutter/material.dart';
import 'package:free_note/providers/events_provider.dart';
import 'package:free_note/providers/friends_provider.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:free_note/providers/notifications_provider.dart';
import 'package:free_note/widgets/note_entry.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [Expanded(child: _buildNotesList(context))]),
    );
  }

  Widget _buildNotesList(BuildContext context) {
    final noteProvider = context.watch<NotesProvider>();
    final notificationsProvider = context.watch<NotificationsProvider>();
    final eventsProvider = context.watch<EventsProvider>();
    final friendsProvider = context.watch<FriendsProvider>();
    final notes = noteProvider.rootNotes;

    if (noteProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return NoteEntry(note: note, noteId: note.id);
        },
      ),
      onRefresh: () async {
        await noteProvider.loadNotes();
        await notificationsProvider.loadNotifications();
        await eventsProvider.loadEventsAndCalendars();
        await friendsProvider.loadFriends();
      },
    );
  }
}
