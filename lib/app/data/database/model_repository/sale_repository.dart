import 'package:pos/app/data/database/database_pos.dart';
import 'package:pos/app/models/sale.dart';
import 'package:pos/app/models/soldarticle.dart';

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
            [item.quantity, item.article_id],
          );
        }
      });
      return true;
    } catch (e) {
      print("Erreur lors de l'application de la vente : $e");
      return false;
    }
  }

  Future<List<Sale>> fetchSales() async {
    final db = await dbProvider.database;
    final result = await db.query('sales', orderBy: 'date DESC');
    return result.map((map) => Sale.fromMap(map)).toList();
  }

  Future<List<Soldarticle>> fetchSoldArticles(int saleId) async {
    final db = await dbProvider.database;
    final result = await db.query(
      'sold_articles',
      where: 'sale_id = ?',
      whereArgs: [saleId],
    );
    return result.map((map) => Soldarticle.fromMap(map)).toList();
  }
}
