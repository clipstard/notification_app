part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoginSubmitted extends LoginEvent {
  final String msisdn;
  final String password;
  final bool rememberMe;

  LoginSubmitted(this.msisdn, this.password, this.rememberMe);

  @override
  List<Object> get props => <Object>[msisdn, password, rememberMe];
}

class LoginWithBiometricRequested extends LoginEvent {
  final String reason;

  LoginWithBiometricRequested(this.reason);

  @override
  List<Object> get props => <Object>[reason];
}
