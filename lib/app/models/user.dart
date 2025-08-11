class User {
  final int? id;
  final String username;
  final String password;
  User({
    this.id,
    required this.username,
    required this.password,
  });


  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'username': username,
      'password': password,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }
}
