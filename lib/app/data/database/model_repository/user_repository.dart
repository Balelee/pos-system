import 'package:bcrypt/bcrypt.dart';
import 'package:pos/app/data/database/database_pos.dart';
import 'package:pos/app/models/session.dart';
import 'package:pos/app/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  final dbProvider = DatabaseHelper.instance;
  Future<User?> insertUser(User user) async {
    final db = await dbProvider.database;
    String hashedPassword = BCrypt.hashpw(user.password, BCrypt.gensalt());
    final userToInsert = User(
      username: user.username,
      password: hashedPassword,
      status: user.status,
    );
    try {
      final id = await db.insert(
        'users',
        userToInsert.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return User(
        id: id,
        username: userToInsert.username,
        password: userToInsert.password,
        status: userToInsert.status,
      );
    } catch (e) {
      print("Erreur lors de l'insertion de l'utilisateur : $e");
      return null;
    }
  }

  Future<List<User>> fetchUsers() async {
    final db = await dbProvider.database;
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<List<User>> fetchUsersCashier() async {
    final db = await dbProvider.database;
    final result = await db.query(
      'users',
      where: 'status = ?',
      whereArgs: ['cashier'],
    );
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<bool> updateUser(User user) async {
    final db = await dbProvider.database;
    Map<String, dynamic> updatedRow = user.toMap();
    if (user.password.isNotEmpty) {
      if (!user.password.startsWith(r'$2a$')) {
        updatedRow['password'] = BCrypt.hashpw(user.password, BCrypt.gensalt());
      }
    } else {
      updatedRow.remove('password');
    }
    final rowsAffected = await db.update(
      'users',
      updatedRow,
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return rowsAffected > 0;
  }


  Future<int> deleteUser(User user) async {
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
        await db.insert(
          'sessions',
          {
            'user_id': user.id,
            'login_time': DateTime.now().toIso8601String(),
          },
        );
        return user;
      }
    }
    return null;
  }

  Future<void> logoutUser(int userId) async {
    final db = await dbProvider.database;
    await db.update(
      'sessions',
      {
        'logout_time': DateTime.now().toIso8601String(),
      },
      where: 'user_id = ? AND logout_time IS NULL',
      whereArgs: [userId],
    );
  }

  Future<List<Session>> fetchLastSessionCashiers() async {
    final db = await dbProvider.database;
    final usersResult = await db.query(
      'users',
      where: 'status = ?',
      whereArgs: ['cashier'],
    );
    List<Session> sessions = [];
    for (var userMap in usersResult) {
      final user = User.fromMap(userMap);
      final sessionResult = await db.query(
        'sessions',
        where: 'user_id = ?',
        whereArgs: [user.id],
        orderBy: 'login_time DESC',
        limit: 1,
      );
      if (sessionResult.isNotEmpty) {
        final session = Session.fromMap(sessionResult.first, user);
        sessions.add(session);
      }
    }
    return sessions;
  }
}
