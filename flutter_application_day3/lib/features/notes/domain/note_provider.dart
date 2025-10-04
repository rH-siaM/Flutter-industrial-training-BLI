import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/note_model.dart';
import '../data/note_db.dart';

final noteProvider =
    StateNotifierProvider<NoteNotifier, List<Note>>((ref) => NoteNotifier());

class NoteNotifier extends StateNotifier<List<Note>> {
  final _db = NoteDatabase();

  NoteNotifier() : super([]) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await _db.getNotes();
      print('Loaded ${notes.length} notes'); // Debug
      state = notes;
    } catch (e) {
      print('Error loading notes: $e'); // Debug
    }
  }

  Future<void> add(Note note) async {
    try {
      final id = await _db.addNote(note);
      print('Note added with ID: $id'); // Debug
      await _loadNotes();
    } catch (e) {
      print('Error adding note: $e'); // Debug
      rethrow;
    }
  }

  Future<void> delete(int id) async {
    try {
      await _db.deleteNote(id);
      print('Note deleted: $id'); // Debug
      await _loadNotes();
    } catch (e) {
      print('Error deleting note: $e'); // Debug
    }
  }
}