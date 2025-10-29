import 'package:flutter/material.dart';
import 'package:free_note/data/database_service.dart';
import 'package:free_note/models/note.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dbService = DatabaseService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('All Notes')),
      body: FutureBuilder<List<Note>>(
        future: dbService.getUserNotes(), // fetch all notes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there was an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no notes exist
            return const Center(child: Text('No notes found.'));
          } else {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                );
              },
            );
          }
        },
      ),
    );
  }
}
