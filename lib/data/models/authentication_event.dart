part of 'package:notification_app/data/repositories/authentication_repository.dart';

class AuthnenticationEvent {
  final AuthenticationStatus status;
  final AuthenticationOrigin origin;
  final bool withBiometrics;

  AuthnenticationEvent({
    required this.status,
    required this.origin,
    required this.withBiometrics,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': this.status.toString(),
        'origin': this.origin.toString(),
        'withBiometrics': this.withBiometrics,
      };

  @override
  String toString() {
    return json.encode(toJson());
  }
}
