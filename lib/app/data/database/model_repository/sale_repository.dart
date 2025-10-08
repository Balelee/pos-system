import 'package:pos/app/data/database/database_pos.dart';
import 'package:pos/app/models/article.dart';
import 'package:pos/app/models/sale.dart';
import 'package:pos/app/models/soldarticle.dart';
import 'package:pos/app/models/user.dart';

class SaleRepository {
  final dbProvider = DatabaseHelper.instance;
  Future<bool> applySale(Sale sale, List<Soldarticle> items) async {
    final db = await dbProvider.database;
    try {
      await db.transaction((txn) async {
        int saleId = await txn.insert('sales', sale.toMap());
        for (var item in items) {
          final map = item.toMap();
          map['sale_id'] = saleId;
          await txn.insert('sold_articles', map);
          await txn.rawUpdate(
            'UPDATE articles SET quantity = quantity - ? WHERE id = ?',
            [item.quantity, item.article?.id],
          );
        }
      });
      return true;
    } catch (e) {
      print("❌ Erreur lors de l'application de la vente : $e");
      return false;
    }
  }

  Future<List<Sale>> fetchSalesWithArticles() async {
    final db = await dbProvider.database;
    final salesResult = await db.query('sales', orderBy: 'date DESC');
    List<Sale> sales = [];
    for (var saleMap in salesResult) {
      final sale = Sale.fromMap(saleMap);
      final soldArticlesResult = await db.query(
        'sold_articles',
        where: 'sale_id = ?',
        whereArgs: [sale.id],
      );
      final soldArticles = <Soldarticle>[];
      for (var soldMap in soldArticlesResult) {
        Article? article;
        final articleResult = await db.query(
          'articles',
          where: 'id = ?',
          whereArgs: [soldMap['article_id']],
          limit: 1,
        );
        if (articleResult.isNotEmpty) {
          article = Article.fromMap(articleResult.first);
        }
        soldArticles.add(Soldarticle.fromMap(soldMap, article: article));
      }
      sale.soldArticles = soldArticles;
      if (sale.user_id != null) {
        final userResult = await db.query(
          'users',
          where: 'id = ?',
          whereArgs: [sale.user_id],
          limit: 1,
        );
        if (userResult.isNotEmpty) {
          sale.user = User.fromMap(userResult.first);
        }
      }
      sales.add(sale);
    }
    return sales;
  }
}
