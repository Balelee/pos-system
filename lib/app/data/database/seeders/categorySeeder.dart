import 'package:sqflite/sqflite.dart';

class CategorySeeder {
  static Future<void> seed(Database db) async {
    final categories = await db.query('categories');
    if (categories.isEmpty) {
      await db.insert('categories', {'name': 'Boissons'});
      await db.insert('categories', {'name': 'Alimentation'});
    }
  }
}
