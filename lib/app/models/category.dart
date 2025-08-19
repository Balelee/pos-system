class Category {
  final int? id;
  final String label;

  Category({
    this.id,
    required this.label,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': label,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      label: map['label'],
    );
  }
}
