import 'package:pos/app/models/article.dart';

class Soldarticle {
  final int? id;
  final int? sale_id;
  final Article? article;
  int quantity;
  final double unit_price;

  Soldarticle({
    this.id,
    this.sale_id,
    this.article,
    required this.quantity,
    required this.unit_price,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'article_id': article?.id, 
      'quantity': quantity,
      'unit_price': unit_price,
    };
    if (id != null) map['id'] = id;
    if (sale_id != null) map['sale_id'] = sale_id;
    return map;
  }

  factory Soldarticle.fromMap(Map<String, dynamic> map, {Article? article}) {
    return Soldarticle(
      id: map['id'],
      sale_id: map['sale_id'],
      article: article,
      quantity: map['quantity'],
      unit_price: map['unit_price']?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return "Soldarticle(article: ${article?.label}, qty: $quantity, price: $unit_price, sale_id: $sale_id)";
  }
}
