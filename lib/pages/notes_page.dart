import 'package:flutter/material.dart';
import 'package:free_note/providers/notes_provider.dart';
import 'package:provider/provider.dart';


class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNodes();
    });
  }

  void _loadNodes() {
    final nodeProvider = Provider.of<NotesProvider>(context, listen: false);
    nodeProvider.loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Text('loading...');
        } else {
          return Text(provider.notes.length.toString());
        }
      },
    );
  }
}
