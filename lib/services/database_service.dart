import 'package:free_note/models/note.dart';
import 'package:free_note/services/supabase_service.dart';
import 'package:free_note/event_logger.dart';

class DatabaseService {
  final supabase = SupabaseService.client;

  static final DatabaseService _instance = DatabaseService._();

  DatabaseService._();

  static DatabaseService get instance {
    return _instance;
  }

  Future<List<Note>> fetchNotes() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabase
        .from('notes')
        .select('*, user_notes(*)')
        .eq('user_notes.user_id', userId)
        .order('updated_at', ascending: false);

    logger.i(
      'Successfully fetched notes for user ${supabase.auth.currentUser?.email}',
    );

    return (response as List).map((note) => Note.fromJson(note)).toList();
  }

  Future<Note?> fetchNote(int id) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await supabase
        .from('notes')
        .select('*, user_notes(*)')
        .eq('user_notes.user_id', userId)
        .eq('id', id)
        .maybeSingle();

    if (response == null) {
      logger.w('No note found with id $id for user $userId');
      return null;
    }

    logger.i('Successfully fetched note with id $id for user $userId');
    return Note.fromJson(response);
  }

  Future<List<Note>> fetchCalendar() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabase
        .from('calendar')
        .select('id, timestamp, notes(*), user_notes!inner(user_id, note_id)')
        .eq('user_notes.user_id', userId)
        .order('timestamp', ascending: false);

    logger.i('Successfully fetched calender entries for user $userId');
    return (response as List).map((note) => Note.fromJson(note)).toList();
  }

  Future<Note?> createNote(Note note) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;

    try {
      final inserted = await supabase
          .rpc(
            'create_note_with_user',
            params: {'p_title': note.title, 'p_content': note.content},
          )
          .select()
          .single();
      return Note.fromJson(inserted);
    } catch (e) {
      logger.e('Failed to create note for user $userId: $e');
      rethrow;
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await supabase
          .from('notes')
          .update({
            'title': note.title,
            'content': note.content,
            'updated_at': note.updatedAt.toIso8601String(),
          })
          .eq('id', note.id);
    } catch (e) {
      logger.e('Failed to update note ${note.id}: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await supabase.from('notes').delete().eq('id', id);
    } catch (e) {
      logger.e('Failed to delete note $id: $e');
      rethrow;
    }
  }
}
