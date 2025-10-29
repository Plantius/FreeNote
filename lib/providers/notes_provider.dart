import 'package:flutter/material.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/data/database_service.dart';

class NotesProvider with ChangeNotifier {
  final DatabaseService database;
  List<Note>? _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  NotesProvider(this.database);

  List<Note> get notes => _notes == null ? [] : _notes!;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadNotes({bool forceRefresh = false}) async {
    if (_notes != null && !forceRefresh) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notes = await database.fetchNotes();
    } catch (e) {
      _errorMessage = 'Failed to fetch nodes: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
