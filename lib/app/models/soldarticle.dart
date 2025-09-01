class Soldarticle {
  final int? id;
  final int? article_id;
  final int? sale_id;
  final int quantity;
  final double? unit_price;

  Soldarticle({
    this.id,
    this.article_id,
    this.sale_id,
    required this.unit_price,
    required this.quantity,
  });

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'article_id': article_id,
      'sale_id': sale_id,
      'quantity': quantity,
      'unit_price': unit_price,
    };
  }


  factory Soldarticle.fromMap(Map<String, dynamic> map) {
    return Soldarticle(
      id: map['id'],
      article_id: map['article_id'],
      sale_id: map['sale_id'],
      unit_price: map['unit_price'],
      quantity: map['quantity'],
    );
  }
}
