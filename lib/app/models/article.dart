class Article {
  final int? id;
  final int? category_id;
  final String label;
  final double? unit_price;
  final int? min_quantity;

  Article({
    this.id,
    this.category_id,
    required this.label,
    required this.unit_price,
    required this.min_quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': category_id,
      'label': label,
      'unit_price': unit_price,
      'min_quantity': min_quantity,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      label: map['label'],
      unit_price: map['unit_price'],
      min_quantity: map['min_quantity'],
    );
  }
}