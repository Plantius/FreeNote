import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<NotesProvider>().loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Selection Menu goes here'),

        SizedBox(height: 8),

        Expanded(child: _buildNotesList(context)),

        const Text('Search bar goes here'),
      ],
    );
  }

  Widget _buildNotesList(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            child: ListView.builder(
              itemCount: provider.notes.length,
              itemBuilder: (context, index) {
                return _buildNoteEntry(context, provider.notes[index]);
              },
            ),
            onRefresh: () async {
              await provider.loadNotes(forceRefresh: true);
            },
          );
        }
      },
    );
  }

  Widget _buildNoteEntry(BuildContext context, Note note) {
    return TextButton(
      onPressed: () {
        context.push('/note/${note.id}', extra: note);
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        foregroundColor: Colors.white,
        alignment: Alignment.centerLeft,
      ),
      child: Row(
        children: [
          SizedBox(child: Icon(Icons.note, size: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  note.content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
