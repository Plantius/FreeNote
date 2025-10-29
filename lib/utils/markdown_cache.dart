import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MarkdownCache {
  static Future<File> _getFile(int noteId) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/note_$noteId.md');
  }

  static Future<File> _getMetaFile(int noteId) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/note_$noteId.meta');
  }

  /// Save markdown + updatedAt timestamp
  static Future<void> save(
    int noteId,
    String markdown,
    DateTime updatedAt,
  ) async {
    final file = await _getFile(noteId);
    final meta = await _getMetaFile(noteId);

    await file.writeAsString(markdown);
    await meta.writeAsString(updatedAt.toIso8601String());
  }

  /// Load cached markdown text
  static Future<String?> load(int noteId) async {
    final file = await _getFile(noteId);
    if (await file.exists()) return await file.readAsString();
    return null;
  }

  /// Check if local cache is up to date
  static Future<bool> isUpToDate(int noteId, DateTime updatedAt) async {
    final meta = await _getMetaFile(noteId);
    if (await meta.exists()) {
      final cachedUpdatedAt = await meta.readAsString();
      return cachedUpdatedAt == updatedAt.toIso8601String();
    }
    return false;
  }
}
