import 'package:pos/app/models/soldarticle.dart';
import 'package:pos/app/models/user.dart';

class Sale {
  final int? id;
  final int? user_id;
  final DateTime? date;
  final double total;
  final String? paymentMethod;
  final String? phone;
  bool isReceived;
  User? user;
  List<Soldarticle> soldArticles;

  Sale({
    this.id,
    this.user_id,
    required this.date,
    required this.total,
    this.paymentMethod,
    this.phone,
    this.isReceived = false,
    this.soldArticles = const [],
    this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'date': date?.toIso8601String(),
      'total': total,
      'payment_method': paymentMethod,
      'phone': phone,
      'is_received': isReceived ? 1 : 0,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      user_id: map['user_id'],
      date: DateTime.parse(map['date']),
      total: (map['total'] ?? 0).toDouble(),
      paymentMethod: map['payment_method'],
      phone: map['phone'],
      isReceived: (map['is_received'] ?? 0) == 1,
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      soldArticles: [],
    );
  }

  @override
  String toString() {
    return "Sale(id:$id ,user_id: $user_id, date: $date,)";
  }
}
