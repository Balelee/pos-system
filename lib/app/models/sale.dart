import 'package:pos/app/models/soldarticle.dart';
import 'package:pos/app/models/user.dart';

class Sale {
  final int? id;
  final int? user_id;
  final DateTime? date;
  final double total;
  User? user;
  List<Soldarticle> soldArticles;

  Sale(
      {this.id,
      this.user_id,
      required this.date,
      required this.total,
      this.soldArticles = const [],
      this.user});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'date': date?.toIso8601String(),
      'total': total,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      user_id: map['user_id'],
      date: DateTime.parse(map['date']),
      total: (map['total'] ?? 0).toDouble(),
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      soldArticles: [],
    );
  }

  @override
  String toString() {
    return "Sale(id:$id ,user_id: $user_id, date: $date,)";
  }
}
