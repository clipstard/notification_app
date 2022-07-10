part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => <Object>[];
}

class AuthenticationEventChanged extends AuthenticationEvent {
  const AuthenticationEventChanged(this.event);

  final AuthnenticationEvent event;

  @override
  List<Object> get props => <Object>[event];
}

class AuthenticatedDataChanged extends AuthenticationEvent {
  const AuthenticatedDataChanged(this.loyaltyProgram);

  final LoyaltyProgram loyaltyProgram;

  @override
  List<Object> get props => <Object>[loyaltyProgram];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
