import 'package:flutter/material.dart';
import 'package:free_note/services/cache_service.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/services/database_service.dart';

class NotesProvider with ChangeNotifier {
  final DatabaseService database;
  List<Note>? _notes;
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
      for (var note in _notes!) {
        final cachedContent = await CacheService.loadNoteIfUpToDate(
          note.id,
          note.updatedAt,
        );

        if (cachedContent != null) {
          note = Note(
            id: note.id,
            title: note.title,
            content: cachedContent,
            createdAt: note.createdAt,
            updatedAt: note.updatedAt,
          );
        } else {
          logger.i('Note ${note.id} is behind, saving to cache.');
          await CacheService.saveNote(note);
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch nodes: $e';
      try {
        final cachedNotes = await CacheService.loadAllNotesFromCache();
        if (cachedNotes.isNotEmpty) {
          _notes = cachedNotes;
          logger.i('Loaded ${cachedNotes.length} notes from local cache.');
        } else {
          _errorMessage = 'No cached notes available.';
        }
      } catch (cacheError) {
        _errorMessage = 'Failed to load notes: $cacheError';
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
