import 'package:pos/app/data/database/database_pos.dart';
import 'package:pos/app/models/category.dart';

class CategoryDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insertCategory(Category category) async {
    final db = await dbHelper.database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getAllCategories() async {
    final db = await dbHelper.database;
    final result = await db.query('categories');
    return result.map((map) => Category.fromMap(map)).toList();
  }

  Future<int> updateCategory(Category category) async {
    final db = await dbHelper.database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
