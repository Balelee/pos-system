class User {
  final int? id;
  final String username;
  final String password;
  final String status;

  User({
    this.id,
    required this.username,
    required this.password,
    this.status = "cashier",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'status': status,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      status: map['status'],
    );
  }
}
