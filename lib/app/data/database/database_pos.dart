import 'package:pos/app/data/database/seeders/articleSeeder.dart';
import 'package:pos/app/data/database/seeders/categorySeeder.dart';
import 'package:pos/app/data/database/seeders/userSeeder.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static const String _dbName = 'pos.db';
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // ─────────── Création des tables ───────────
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'cashier' CHECK(status IN ('admin','cashier'))
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

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

    // ─────────── Seed initial data ───────────
    await UserSeeder.seed(db);
    await CategorySeeder.seed(db);
    await ArticleSeeder.seed(db);
  }
}
