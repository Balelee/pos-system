import 'package:pos/app/data/database/database_pos.dart';
import 'package:pos/app/models/article.dart';
import 'package:sqflite/sqflite.dart';

class ArticleRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // Récupérer tous les articles
  Future<List<Article>> getAllArticles() async {
    final db = await dbHelper.database;
    final result = await db.query('articles');
    return result.map((map) => Article.fromMap(map)).toList();
  }

  // Récupérer un article par ID
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

  // Ajouter un nouvel article
  Future<int> insertArticle(Article article) async {
    final db = await dbHelper.database;
    return await db.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Mettre à jour un article
  Future<int> updateArticle(Article article) async {
    final db = await dbHelper.database;
    return await db.update(
      'articles',
      article.toMap(),
      where: 'id = ?',
      whereArgs: [article.id],
    );
  }

  // Supprimer un article
  Future<int> deleteArticle(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'articles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Rechercher des articles par label
  Future<List<Article>> searchArticles(String query) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'articles',
      where: 'label LIKE ?',
      whereArgs: ['%$query%'],
    );
    return result.map((map) => Article.fromMap(map)).toList();
  }
}
