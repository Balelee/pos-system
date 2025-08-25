
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

  User({
    this.id,
    required this.username,
    required this.password,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'status': status?.name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      status: UserStatusExtension.fromString(map['status']),
    );
  }
}
