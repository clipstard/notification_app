part of 'password_bloc.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => <Object>[];
}

class PasswordChanged extends PasswordEvent {
  PasswordChanged({required this.password});
  final String password;

  @override
  List<Object> get props => <Object>[password];
}

class PasswordGuessable extends PasswordEvent {
  PasswordGuessable({required this.password});
  final String password;

  @override
  List<Object> get props => <Object>[password];
}

class PasswordPwned extends PasswordEvent {
  PasswordPwned({required this.password});
  final String password;

  @override
  List<Object> get props => <Object>[password];
}

class PaswordSequentialValidation extends PasswordEvent {
  PaswordSequentialValidation({required this.password});
  final String password;

  @override
  List<Object> get props => <Object>[password];
}

class UpdateUserPassword extends PasswordEvent {
  UpdateUserPassword({
    required this.msisdn,
    required this.password,
    required this.token,
  });

  final String msisdn;
  final String password;
  final String token;

  @override
  List<Object> get props => <Object>[msisdn, password, token];
}
