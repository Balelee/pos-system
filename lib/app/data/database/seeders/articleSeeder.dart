import 'package:sqflite/sqflite.dart';

class ArticleSeeder {
  static Future<void> seed(Database db) async {
    final articles = await db.query('articles');
    if (articles.isEmpty) {
      await db.insert('articles', {
        'category_id': 1,
        'label': 'Coca-Cola',
        'unit_price': 1.5,
        'min_quantity': 10,
      });
      await db.insert('articles', {
        'category_id': 2,
        'label': 'Pain',
        'unit_price': 0.8,
        'min_quantity': 20,
      });
    }
  }
}
