part of 'package:notification_app/logic/bloc/login/login_bloc.dart';

class LoginAttempt {
  final int count;
  final DateTime? lastAttempt;
  final int? duration;

  const LoginAttempt({
    required this.count,
    this.lastAttempt,
    this.duration,
  });

  factory LoginAttempt.fromJson(dynamic json) => LoginAttempt(
        count: int.parse(json['count'].toString()),
        lastAttempt: json['lastAttempt'] != null
            ? DateTime.tryParse(json['lastAttempt'].toString())
            : null,
        duration: json['duration'] != null
            ? int.parse(json['duration'].toString())
            : null,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'count': this.count,
      'lastAttempt':
          this.lastAttempt != null ? this.lastAttempt!.toIso8601String() : null,
      'duration': this.duration != null ? this.duration!.toString() : null,
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }

  static const LoginAttempt empty = LoginAttempt(
    count: 0,
    lastAttempt: null,
    duration: null,
  );
}
