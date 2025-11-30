import 'package:flutter/material.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:free_note/services/cache_service.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/services/database_service.dart';

class NotesProvider with ChangeNotifier {
  final DatabaseService database;

  List<Note>? _notes;
  bool _isLoading = false;
  String? _errorMessage;

  NotesProvider(this.database) {
    AuthService.instance.userStream.listen((state) {
      loadNotes(forceRefresh: true);
    });
  }

  List<Note> get notes => _notes == null ? [] : _notes!;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadNotes({bool forceRefresh = false}) async {
    logger.i('Triggered reload of notes list: refresh = $forceRefresh');

    if (_notes != null && !forceRefresh) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notes = await database.fetchNotes();
      for (var note in _notes!) {
        if (!await CacheService.isNoteUpToDate(note.id, note.updatedAt)) {
          logger.i('Note ${note.id} is behind, saving to cache.');
          await CacheService.saveNote(note);
        }
        note = Note(
          id: note.id,
          title: note.title,
          content: note.content,
          createdAt: note.createdAt,
          updatedAt: note.updatedAt,
        );
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

  Future<Note?> loadNote(int id) async {
    var note = await CacheService.loadNoteFromCache(id);
    note ??= await database.fetchNote(id);

    if (note == null) {
      logger.e('No note found with id $id, locally or in the cloud.');
      return null;
    }

    return note;
  }

  Future<void> saveNote(Note note) async {
    try {
      if (note.id == 0) {
        final createdNote = await database.createNote(note);

        if (createdNote != null) {
          note = createdNote;
        } else {
          throw Exception('Failed to create note in database.');
        }
      } else {
        note.updatedAt = DateTime.now().toUtc();
        await CacheService.saveNote(note);
      }

      logger.i('Saving note ${note.id} to database.');
      await database.updateNote(note);

      notifyListeners();
    } catch (e) {
      logger.w('Failed to save note ${note.id} to database: $e');
      try {
        final index = _notes?.indexWhere((n) => n.id == note.id);
        if (index != null && index >= 0) {
          _notes![index] = note;
        } else {
          _notes = [...?_notes, note];
        }
      } catch (e) {
        logger.e('Failed to save note ${note.id} to cache: $e');
      }
    }
  }

  Future<void> shareNote(Note note, Profile profile) async {
    database.shareNote(note, profile);
    notifyListeners(); // Nothing to notify but anyway
  }

  Future<void> deleteNote(Note note) async {
    database.deleteNote(note.id);

    assert(_notes != null);
    if (!_notes!.remove(note)) {
      logger.w('Could not remove notes from list');
    }

    logger.e('TODO: Delete note from cache?');

    notifyListeners();
  }

  Future<void> createNote() async {
    //TODO: Add note creation here
    debugPrint('Do we reach here?');
  }
}
