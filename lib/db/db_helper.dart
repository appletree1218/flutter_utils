import 'package:object_detection/data/audio_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'audio.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE audio(file_name TEXT PRIMARY KEY, path text)');
        });
  }

  Future<int> insertData(AudioData audioData) async {
    final db = await database;
    return await db.insert('audio', audioData.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AudioData>> getFiles() async {
    final db = await database;
    List<Map<String, dynamic>> files = await db.query('audio');
    return files.map((e) => AudioData(fileName: e['file_name'], path: e['path'])
    ).toList();
  }

  Future<int> delData(String fileName) async {
    final db = await database;
    return await db.delete('audio', where: 'file_name=?',
    whereArgs: [fileName]);
  }
}