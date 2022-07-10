import 'dart:convert';

class PersistentLogin {
  final String? firstName;
  final bool rememberMe;
  final String msisdn;
  final String? password;
  final bool isFirstLogin;

  const PersistentLogin({
    required this.rememberMe,
    required this.msisdn,
    required this.isFirstLogin,
    this.password,
    this.firstName,
  });

  static const PersistentLogin empty = PersistentLogin(
    firstName: null,
    rememberMe: false,
    isFirstLogin: false,
    msisdn: '',
    password: null,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'firstName': this.firstName,
        'rememberMe': this.rememberMe,
        'isFirstLogin': this.isFirstLogin,
        'msisdn': this.msisdn,
        'password': this.password,
      };

  @override
  String toString() {
    return json.encode(toJson());
  }
}
