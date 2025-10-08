import 'package:sqflite/sqflite.dart';

class CreateConfigurationTable {
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE configuration (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        logoPath TEXT
      )
    ''');
  }
}
