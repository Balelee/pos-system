import 'package:pos/app/data/database/seeders/userSeeder.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSeeder {
  Future<void> run(Database db) async {
    await UserSeeder.seed(db);
  }
}
