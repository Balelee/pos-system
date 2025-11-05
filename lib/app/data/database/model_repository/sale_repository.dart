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


  Future<double> getTotalSales() async {
    final db = await dbProvider.database;
    try {
      final result =
          await db.rawQuery('SELECT SUM(total) as total_sum FROM sales');
      if (result.isNotEmpty && result.first['total_sum'] != null) {
        return (result.first['total_sum'] as num).toDouble();
      }
      return 0.0;
    } catch (e) {
      print("❌ Erreur lors du calcul du total des ventes : $e");
      return 0.0;
    }
  }


  Future<bool> markSaleAsReceived(int saleId, {bool received = true}) async {
    final db = await dbProvider.database;
    try {
      await db.update(
        'sales',
        {'is_received': received ? 1 : 0},
        where: 'id = ?',
        whereArgs: [saleId],
      );
      return true;
    } catch (e) {
      print("❌ Erreur lors de la mise à jour de isReceived : $e");
      return false;
    }
  }

  Future<bool> markAllSalesAsReceived(List<int> saleIds) async {
    final db = await dbProvider.database;
    try {
      final ids = saleIds.join(',');
      await db.rawUpdate(
        'UPDATE sales SET is_received = 1 WHERE id IN ($ids)',
      );
      return true;
    } catch (e) {
      print("❌ Erreur lors de la mise à jour de toutes les ventes : $e");
      return false;
    }
  }

}
