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
        isBlocked: user.isBlocked);
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
          isBlocked: user.isBlocked);
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

  Future<bool> toggleCashierStatus(int userId, bool newStatus) async {
    final db = await dbProvider.database;
    try {
      final rows = await db.update(
        'users',
        {'is_blocked': newStatus ? 1 : 0},
        where: 'id = ?',
        whereArgs: [userId],
      );
      return rows > 0;
    } catch (e) {
      print("Erreur lors du changement de statut du caissier : $e");
      return false;
    }
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
      if (user.isBlocked == true) {
        throw Exception("blocked");
      }
      if (BCrypt.checkpw(password, user.password)) {
        await db.update(
          'sessions',
          {'logout_time': DateTime.now().toIso8601String()},
          where: 'logout_time IS NULL',
        );
        await db.insert(
          'sessions',
          {
            'user_id': user.id,
            'login_time': DateTime.now().toIso8601String(),
            'logout_time': null,
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
      {'logout_time': DateTime.now().toIso8601String()},
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

  Future<User?> getCurrentUser() async {
    final db = await dbProvider.database;
    final result = await db.rawQuery('''
    SELECT u.* FROM users u
    INNER JOIN sessions s ON u.id = s.user_id
    WHERE s.logout_time IS NULL
    ORDER BY s.login_time DESC
    LIMIT 1
  ''');

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<bool> hasActiveSession() async {
    final db = await dbProvider.database;
    final result = await db.rawQuery('''
    SELECT 1 FROM sessions
    WHERE logout_time IS NULL
    LIMIT 1
  ''');
    return result.isNotEmpty;
  }

  Future<bool> resetCurrentUserPassword() async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) return false;
    final db = await dbProvider.database;
    final hashedPassword =
        BCrypt.hashpw(currentUser.username, BCrypt.gensalt());
    final rows = await db.update(
      'users',
      {'password': hashedPassword},
      where: 'id = ?',
      whereArgs: [currentUser.id],
    );

    return rows > 0;
  }

}
