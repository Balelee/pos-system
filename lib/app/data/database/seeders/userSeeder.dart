import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';

class UserSeeder {
  static Future<void> seed(Database db) async {
    final users = await db.query('users');
    if (users.isEmpty) {
      // Admin
      String adminPassword = BCrypt.hashpw('admin123', BCrypt.gensalt());
      await db.insert('users', {
        'username': 'admin',
        'password': adminPassword,
        'status': 'admin',
      });

      // Caissier
      String cashierPassword = BCrypt.hashpw('cashier', BCrypt.gensalt());
      await db.insert('users', {
        'username': 'aymard',
        'password': cashierPassword,
        'status': 'cashier',
      });
    }
  }
}
