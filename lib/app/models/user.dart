enum UserStatus { admin, cashier }

extension UserStatusExtension on UserStatus {
  String get label {
    switch (this) {
      case UserStatus.admin:
        return "Administrateur";
      case UserStatus.cashier:
        return "Caissier";
    }
  }

  static UserStatus? fromString(String? status) {
    if (status == null) return null;
    return UserStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == status.toLowerCase(),
      orElse: () => UserStatus.cashier,
    );
  }
}

class User {
  final int? id;
  final String username;
  final String password;
  final UserStatus? status;
  final bool isBlocked;

  User({
    this.id,
    required this.username,
    required this.password,
    this.status,
    this.isBlocked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'status': status?.name,
      'is_blocked': isBlocked ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      status: UserStatusExtension.fromString(map['status']),
      isBlocked: (map['is_blocked'] ?? 0) == 1,
    );
  }
}
