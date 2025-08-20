import 'package:sqflite/sqflite.dart';

class CreateUsersTable {
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'admin' CHECK(status IN ('admin', 'cashier'))
      )
    ''');
  }
}
