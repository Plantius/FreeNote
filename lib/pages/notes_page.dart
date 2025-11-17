import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
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
                  () {
                    final dt = note.updatedAt.toLocal();
                    final now = DateTime.now();

                    final today = DateTime(now.year, now.month, now.day);

                    String two(int n) => n.toString().padLeft(2, '0');
                    final time = '${two(dt.hour)}:${two(dt.minute)}';
                    final date = DateTime(dt.year, dt.month, dt.day);

                    const monthNames = [
                      '',
                      'January',
                      'February',
                      'March',
                      'April',
                      'May',
                      'June',
                      'July',
                      'August',
                      'September',
                      'October',
                      'November',
                      'December',
                    ];
                    final monthName = monthNames[dt.month];

                    if (date == today) {
                      return time;
                    }
                    if (date == today.subtract(Duration(days: 1))) {
                      return 'Yesterday $time';
                    }
                    if (date.year == now.year) {
                      return '$time - ${dt.day} $monthName';
                    } else {
                      return '${dt.day} $monthName, ${dt.year}';
                    }
                  }(),
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
