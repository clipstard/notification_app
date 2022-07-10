part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.origin = AuthenticationOrigin.synthetic,
    this.loyaltyProgram = LoyaltyProgram.empty,
    this.error = null,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(
    LoyaltyProgram loyaltyProgram,
    AuthenticationOrigin origin,
  ) : this._(
          status: AuthenticationStatus.authenticated,
          origin: origin,
          loyaltyProgram: loyaltyProgram,
          error: null,
        );

  const AuthenticationState.unauthenticated(AuthenticationOrigin origin,
      [String? error])
      : this._(
          status: AuthenticationStatus.unauthenticated,
          origin: origin,
          error: error,
        );

  const AuthenticationState.authDataChanged(LoyaltyProgram loyaltyProgram)
      : this._(
          status: AuthenticationStatus.authenticated,
          loyaltyProgram: loyaltyProgram,
        );

  final AuthenticationStatus status;
  final AuthenticationOrigin origin;
  final LoyaltyProgram loyaltyProgram;
  final String? error;

  @override
  List<Object> get props => <Object>[status, origin, loyaltyProgram];
}
