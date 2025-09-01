import 'package:pos/app/data/database/migrations/create_article_table.dart';
import 'package:pos/app/data/database/migrations/create_category_table.dart';
import 'package:pos/app/data/database/migrations/create_sale_table.dart';
import 'package:pos/app/data/database/migrations/create_users_table.dart';
import 'package:pos/app/data/database/seeders/database_seeder.dart';
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
    await CreateUsersTable().up(db);
    await CreateCategoryTable().up(db);
    await CreateArticleTable().up(db);
    await CreateSalesAndSoldArticlesTables().up(db);

    // ─────────── Seed initial data ───────────
    DatabaseSeeder().run(db);
  }
}
