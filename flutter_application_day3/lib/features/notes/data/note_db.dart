import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'note_model.dart';

class NoteDatabase {
  static final NoteDatabase _instance = NoteDatabase._internal();
  factory NoteDatabase() => _instance;
  NoteDatabase._internal();

  Database? _db;
  final _store = intMapStoreFactory.store('notes');

  Future<Database> get database async {
    if (_db != null) return _db!;
    
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = '${dir.path}/notes.db';
    _db = await databaseFactoryIo.openDatabase(dbPath);
    
    return _db!;
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final snapshots = await _store.find(db);
    return snapshots.map((snapshot) {
      final data = Map<String, dynamic>.from(snapshot.value);
      data['id'] = snapshot.key;
      return Note.fromMap(data);
    }).toList();
  }

  Future<int> addNote(Note note) async {
    final db = await database;
    final key = await _store.add(db, note.toMap());
    return key;
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await _store.record(id).delete(db);
  }
}