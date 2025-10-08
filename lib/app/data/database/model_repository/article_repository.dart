import 'package:pos/app/data/database/database_pos.dart';
import 'package:pos/app/models/article.dart';
import 'package:sqflite/sqflite.dart';

class ArticleRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<List<Article>> getAllArticles() async {
    final db = await dbHelper.database;
    final result = await db.query('articles');
    return result.map((map) => Article.fromMap(map)).toList();
  }

  Future<Article?> getArticleById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'articles',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Article.fromMap(result.first);
    }
    return null;
  }

  Future<Article> insertArticle(Article article) async {
    final db = await dbHelper.database;
    final id = await db.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return Article(
      id: id,
      category_id: article.category_id,
      label: article.label,
      unit_price: article.unit_price,
    );
  }

  Future<int> updateArticle(Article article) async {
    final db = await dbHelper.database;
    return await db.update(
      'articles',
      article.toMap(),
      where: 'id = ?',
      whereArgs: [article.id],
    );
  }

 Future<Article?> deleteArticle(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query('articles', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    final article = Article.fromMap(maps.first);
    await db.delete('articles', where: 'id = ?', whereArgs: [id]);
    return article;
  }


  Future<List<Article>> searchArticles(String query) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'articles',
      where: 'label LIKE ? COLLATE NOCASE',
      whereArgs: ['%$query%'],
    );
    return result.map((map) => Article.fromMap(map)).toList();
  }
}
