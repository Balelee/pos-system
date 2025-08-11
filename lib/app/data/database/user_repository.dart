import 'package:bcrypt/bcrypt.dart';
import 'package:pos/app/data/database/database_pos.dart';
import 'package:pos/app/models/user.dart';

class UserRepository {
  final dbProvider = DatabaseHelper.instance;

  Future<int> insertUser(User user) async {
    final db = await dbProvider.database;
    String hashedPassword = BCrypt.hashpw(user.password, BCrypt.gensalt());
    final userToInsert = User(
      username: user.username,
      password: hashedPassword,
    );
    return await db.insert('users', userToInsert.toMap());
  }

  Future<List<User>> fetchUsers() async {
    final db = await dbProvider.database;
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await dbProvider.database;
    Map<String, dynamic> updatedRow = user.toMap();
    if (user.password.isNotEmpty) {
      updatedRow['password'] = BCrypt.hashpw(user.password, BCrypt.gensalt());
    }
    return await db.update(
      'users',
      updatedRow,
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUserByModel(User user) async {
    final db = await dbProvider.database;
    if (user.id == null) {
      throw Exception("L'utilisateur doit avoir un id pour être supprimé");
    }
    return await db.delete('users', where: 'id = ?', whereArgs: [user.id]);
  }

  Future<User?> loginUser(String username, String password) async {
    final db = await dbProvider.database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (results.isNotEmpty) {
      final user = User.fromMap(results.first);
      if (BCrypt.checkpw(password, user.password)) {
        return user;
      }
    }
    return null;
  }
}
