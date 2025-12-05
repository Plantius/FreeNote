import 'package:flutter/material.dart';
import 'package:free_note/models/profile.dart';
import 'package:free_note/services/auth_service.dart';
import 'package:free_note/services/cache_service.dart';
import 'package:free_note/event_logger.dart';
import 'package:free_note/models/note.dart';
import 'package:free_note/services/database_service.dart';
import 'package:free_note/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesProvider with ChangeNotifier {
  final DatabaseService database;
  final supabase = SupabaseService.client;

  List<Note> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  RealtimeChannel? _channel;

  NotesProvider(this.database) {
    AuthService.instance.userStream.listen((state) {
      _reloadChannel();
      loadNotes();
    });

    _reloadChannel();
  }

  void _reloadChannel() {
    logger.d('Reloading notes channel for ${supabase.auth.currentUser?.id}.');
    final userId = supabase.auth.currentUser?.id;

    _unsubscribeChannel();

    if (userId == null) return;

    final filter = PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'user_id',
      value: supabase.auth.currentUser?.id,
    );

    _channel = database.getChannel('user_notes', filter, handlePayload);
  }

  void _unsubscribeChannel() {
    if (_channel != null) {
      _channel!.unsubscribe();
      _channel = null;
    }
  }

  void handlePayload(PostgresChangePayload payload) {
    logger.d('Received notification payload: $payload');

    if ((payload.eventType == PostgresChangeEvent.update ||
            payload.eventType == PostgresChangeEvent.insert) &&
        payload.newRecord.isNotEmpty) {
      logger.d('Updating note ${payload.newRecord['note_id']}.');

      database.fetchNote(payload.newRecord['note_id']).then((note) {
        if (note != null) {
          updateNote(note);
        }
      });
    } else if (payload.eventType == PostgresChangeEvent.delete) {
      logger.d('Removing note ${payload.oldRecord['note_id']}.');

      final id = payload.oldRecord['note_id'] as int?;
      if (id != null) {
        removeNote(id);
      }
    }
  }

  @override
  void dispose() {
    _channel!.unsubscribe();
    super.dispose();
  }

  List<Note> get rootNotes => _notes.where((note) => !note.isNested).toList();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadNotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notes = await database.fetchNotes();
      for (var note in _notes) {
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
          isNested: note.isNested,
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

  @Deprecated('Use getNote(int id)')
  Future<Note?> loadNote(int id) async {
    var note = await CacheService.loadNoteFromCache(id);
    note ??= await database.fetchNote(id);

    if (note == null) {
      logger.e('No note found with id $id, locally or in the cloud.');
      return null;
    }

    return note;
  }

  Note? getNote(int id, {bool strict = true}) {
    Note? note = _notes.where((note) => note.id == id).singleOrNull;

    if (note == null && strict) {
      logger.e('Could not find Note #$id');
    }

    return note;
  }

  void updateNote(Note updatedNote) {
    int index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index >= 0) {
      _notes[index] = updatedNote;
      notifyListeners();
    } else {
      logger.e('Could not find Note #${updatedNote.id} to update');
    }
  }

  void removeNote(int id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  Future<Note> saveNote(Note note) async {
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
    } catch (e) {
      logger.w('Failed to save note ${note.id} to database: $e');
      try {
        final index = _notes.indexWhere((n) => n.id == note.id);
        if (index >= 0) {
          _notes[index] = note;
        } else {
          _notes = [..._notes, note];
        }
      } catch (e) {
        logger.e('Failed to save note ${note.id} to cache: $e');
      }
    }

    // kinda keep it sorted
    _notes.remove(note);
    _notes.add(note);
    notifyListeners();

    return note;
  }

  Future<void> shareNote(Note note, Profile profile) async {
    database.shareNote(note, profile);
    notifyListeners(); // Nothing to notify but anyway
  }

  Future<void> deleteNote(Note note) async {
    database.deleteNote(note.id);

    if (!_notes.remove(note)) {
      logger.w('Could not remove notes from list');
    }

    logger.e('TODO: Delete note from cache?');

    notifyListeners();
  }

  @Deprecated('Use updateNote(Note note), creation is handled if id == 0')
  Future<void> createNote() async {}
}
