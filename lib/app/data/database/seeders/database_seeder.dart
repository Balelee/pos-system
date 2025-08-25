import 'package:pos/app/data/database/seeders/articleSeeder.dart';
import 'package:pos/app/data/database/seeders/categorySeeder.dart';
import 'package:pos/app/data/database/seeders/userSeeder.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseSeeder {
  Future<void> run(Database db) async {
    await UserSeeder.seed(db);
    await CategorySeeder.seed(db);
    await ArticleSeeder.seed(db);
  }
}
