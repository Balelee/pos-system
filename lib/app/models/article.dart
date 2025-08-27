class Article {
  final int? id;
  final int? category_id;
  final String label;
  final double? unit_price;
  final String? image;

  Article(
      {this.id,
      this.category_id,
      required this.label,
      required this.unit_price,
      this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': category_id,
      'label': label,
      'unit_price': unit_price,
      'image': image
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      category_id: map['category_id'],
      label: map['label'],
      unit_price: map['unit_price'],
      image: map['image'],
    );
  }

  @override
  String toString() {
    return 'Article{id: $id, category_id: $category_id, label: $label, unitPrice: $unit_price, image: $image}';
  }
}
