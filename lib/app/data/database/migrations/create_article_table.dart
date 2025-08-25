import 'package:sqflite/sqflite.dart';

class CreateArticleTable {
  Future<void> up(Database db) async {
   await db.execute('''
      CREATE TABLE articles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        label TEXT NOT NULL,
        unit_price REAL NOT NULL,
        min_quantity INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL ON UPDATE CASCADE
      )
    ''');
  }
}
