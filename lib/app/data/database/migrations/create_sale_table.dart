import 'package:sqflite/sqflite.dart';

class CreateSalesAndSoldArticlesTables {
  Future<void> up(Database db) async {
    // 1️⃣ Création de la table sales
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        date TEXT,
        total REAL NOT NULL,
        payment_method TEXT, 
        phone TEXT 
      )
    ''');

    // 2️⃣ Création de la table sold_articles
    await db.execute('''
      CREATE TABLE sold_articles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_id INTEGER,
        article_id INTEGER,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        FOREIGN KEY (sale_id) REFERENCES sales(id),
        FOREIGN KEY (article_id) REFERENCES articles(id)
      )
    ''');
  }
}
