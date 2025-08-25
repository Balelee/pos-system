import 'package:pos/app/models/user.dart';

class Session {
  final int? id;
  final User user;
  final DateTime loginTime;
  final DateTime? logoutTime;

  Session({
    this.id,
    required this.user,
    required this.loginTime,
    this.logoutTime,
  });

  factory Session.fromMap(Map<String, dynamic> map, User user) {
    return Session(
      id: map['id'],
      user: user,
      loginTime: DateTime.parse(map['login_time']),
      logoutTime: map['logout_time'] != null
          ? DateTime.parse(map['logout_time'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user.id,
      'login_time': loginTime.toIso8601String(),
      'logout_time': logoutTime?.toIso8601String(),
    };
  }

  String get loginTimeFormatted =>
      "${loginTime.day.toString().padLeft(2, '0')}/${loginTime.month.toString().padLeft(2, '0')}/${loginTime.year} ${loginTime.hour.toString().padLeft(2, '0')}:${loginTime.minute.toString().padLeft(2, '0')}";

  String? get logoutTimeFormatted => logoutTime != null
      ? "${logoutTime!.day.toString().padLeft(2, '0')}/${logoutTime!.month.toString().padLeft(2, '0')}/${logoutTime!.year} ${logoutTime!.hour.toString().padLeft(2, '0')}:${logoutTime!.minute.toString().padLeft(2, '0')}"
      : null;
}
