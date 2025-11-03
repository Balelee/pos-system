import 'package:sqflite/sqflite.dart';

class CreateUsersTable {
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'admin' CHECK(status IN ('admin', 'cashier')),
        is_blocked INTEGER NOT NULL DEFAULT 0 CHECK(is_blocked IN (0, 1))
      )
    ''');

    // Table des sessions
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        login_time TEXT NOT NULL,
        logout_time TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }
}
