part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = const InitialFormStatus(),
    this.attempt = LoginAttempt.empty,
  });

  final FormSubmissionStatus status;
  final LoginAttempt attempt;

  LoginState copyWith({
    FormSubmissionStatus? status,
    LoginAttempt? attempt,
  }) {
    return LoginState(
      status: status ?? this.status,
      attempt: attempt ?? this.attempt,
    );
  }

  @override
  List<Object> get props => <Object>[status, attempt];
}
