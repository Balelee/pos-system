class Update {
  final int? id;
  final int articleId;
  final int userId;
  final double newQuantity;
  final DateTime date;

  Update({
    this.id,
    required this.articleId,
    required this.userId,
    required this.newQuantity,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'article_id': articleId,
      'user_id': userId,
      'new_quantity': newQuantity,
      'date': date.toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Update.fromMap(Map<String, dynamic> map) {
    return Update(
      id: map['id'] as int?,
      articleId: map['article_id'] as int,
      userId: map['user_id'] as int,
      newQuantity: (map['new_quantity'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }
}
