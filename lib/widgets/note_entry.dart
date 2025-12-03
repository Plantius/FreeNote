import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NoteEntry extends StatelessWidget {
  final Note note;

  const NoteEntry({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
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
                  _formatTimeStamp(note.updatedAt.toLocal()),
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

  String _formatTimeStamp(DateTime t) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    String two(int n) => n.toString().padLeft(2, '0');

    final time = '${two(t.hour)}:${two(t.minute)}';
    final date = DateTime(t.year, t.month, t.day);

    final month = DateFormat.MMMM().format(date);

    if (date == today) {
      return time;
    }

    if (date == today.subtract(Duration(days: 1))) {
      return 'Yesterday $time';
    }

    if (date.year == now.year) {
      return '$time - ${t.day} $month';
    } else {
      return '${t.day} $month, ${t.year}';
    }
  }
}