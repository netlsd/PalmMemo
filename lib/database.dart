import 'package:palmmemo/model/word.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  // var databasesPath = await getDatabasesPath();
  // String path = join(databasesPath, 'demo.db');

  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'words.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE words(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, word TEXT, mean Text)",
      );
    },
    version: 1,
  );

  return database;
}

Future<void> insertWord(Future<Database> database, Word word) async {
  final Database db = await database;

  await db.insert(
    'words',
    word.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Word>> getWords(Future<Database> database) async {
  final Database db = await database;

  final List<Map<String, dynamic>> maps = await db.query('words');

  return List.generate(maps.length, (i) {
    return Word(maps[i]['word'], maps[i]['mean']);
  });
}

Future<void> closeDb(Future<Database> database) async {
  final Database db = await database;
  await db.close();
}
