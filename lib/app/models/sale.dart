class Sale {
  final int? id;
  final int? user_id;
  final DateTime? date;

  Sale({
    this.id,
    this.user_id,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'date': date?.toIso8601String(),
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      user_id: map['user_id'],
      date: DateTime.parse(map['date']),
    );
  }
}