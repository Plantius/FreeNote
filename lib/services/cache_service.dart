import 'dart:io';
import 'dart:convert';
import 'package:free_note/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:free_note/event_logger.dart';

class CacheService {
  static Future<String> _notesDirPath() async {
    final dir = await getApplicationDocumentsDirectory();

    final notesDir = Directory('${dir.path}/notes');
    if (!await notesDir.exists()) {
      await notesDir.create(recursive: true);
    }
    return notesDir.path;
  }

  static Future<File> _noteFile(int id) async {
    final dir = await _notesDirPath();
    return File('$dir/note_$id.md');
  }

  static Future<File> _metaFile(int id) async {
    final dir = await _notesDirPath();
    return File('$dir/note_$id.meta.json');
  }

  static Future<void> saveNote(Note note) async {
    final noteFile = await _noteFile(note.id);
    await noteFile.writeAsString(note.content);

    final metaFile = await _metaFile(note.id);
    final metaData = {
      'id': note.id,
      'title': note.title,
      'updated_at': note.updatedAt.toIso8601String(),
    };
    await metaFile.writeAsString(jsonEncode(metaData));

    logger.i('Cached note ${note.id} locally');
  }

  static Future<String?> loadNoteIfUpToDate(int id, DateTime updatedAt) async {
    final noteFile = await _noteFile(id);
    final metaFile = await _metaFile(id);

    if (await noteFile.exists() && await metaFile.exists()) {
      try {
        final metaData = jsonDecode(await metaFile.readAsString());
        final cachedTimestamp = DateTime.tryParse(metaData['updated_at']);

        if (cachedTimestamp != null &&
            cachedTimestamp.isAtSameMomentAs(updatedAt)) {
          logger.i('Loaded note $id from cache');
          return await noteFile.readAsString();
        }
      } catch (e) {
        logger.w('Failed to read meta for note $id: $e');
      }
    }

    return null;
  }

  static Future<List<Note>> loadAllNotesFromCache() async {
    final dir = Directory(await _notesDirPath());
    if (!await dir.exists()) return [];

    final noteFiles = dir.listSync().where((f) => f.path.endsWith('.md'));
    List<Note> cachedNotes = [];

    for (var file in noteFiles) {
      final id = int.tryParse(
        RegExp(r'note_(\d+)\.md').firstMatch(file.path)?.group(1) ?? '',
      );
      if (id == null) continue;

      final content = await File(file.path).readAsString();
      final metaFile = await _metaFile(id);

      String title = 'Offline Note $id';
      DateTime updatedAt = DateTime.now();

      if (await metaFile.exists()) {
        try {
          final metaData = jsonDecode(await metaFile.readAsString());
          title = metaData['title'] ?? title;
          updatedAt = DateTime.tryParse(metaData['updated_at']) ?? updatedAt;
        } catch (e) {
          logger.w('Failed to parse meta for note $id: $e');
        }
      }

      cachedNotes.add(
        Note(
          id: id,
          title: title,
          content: content,
          createdAt: updatedAt,
          updatedAt: updatedAt,
        ),
      );
    }

    return cachedNotes;
  }
}
