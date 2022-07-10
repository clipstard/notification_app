import 'dart:convert' show json;

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notification_app/data/exceptions/network_exceptions.dart';

import 'package:notification_app/data/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:notification_app/logic/form_submission_status.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'package:notification_app/data/models/login_attempt.dart';

class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    final LoginState currentState = state;

    if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(
        event.msisdn,
        event.password,
        event.rememberMe,
        currentState.attempt,
      );
    } else if (event is LoginWithBiometricRequested) {
      yield* _mapLoginWithBiometricRequestedToState(event.reason);
    }
  }

  Stream<LoginState> _mapLoginSubmittedToState(
    String msisdn,
    String password,
    bool rememberMe,
    LoginAttempt attempt,
  ) async* {
    yield state.copyWith(status: FormSubmitting());

    try {
      await _authenticationRepository.logIn(
        msisdn: msisdn,
        password: password,
        rememberMe: rememberMe,
        withBiometrics: false,
        origin: AuthenticationOrigin.userInteraction,
      );

      yield state.copyWith(
          status: SubmissionSuccess(), attempt: LoginAttempt.empty);
    } catch (e) {
      final bool isBadCredentials = (e is UnauthorizedException &&
          (e).reason == UnauthorizedReason.BAD_CREDENTIALS);

      if (e is BadRequestException || isBadCredentials) {
        final int attemptIntervalInMinutes = DateTime.now()
            .difference(attempt.lastAttempt ?? DateTime.now())
            .inMinutes;

        /// Increase attempt only in next incoming attempt is within 60minutes
        /// with previous one, otherwise reset the attempt
        final int count = attemptIntervalInMinutes < 60 ? attempt.count + 1 : 0;
        final Duration duration = _getAttemptDuration(count);

        yield state.copyWith(
          status: SubmissionFailed(e),
          attempt: LoginAttempt(
            count: count,
            lastAttempt: DateTime.now(),
            duration: duration.inSeconds,
          ),
        );
      } else {
        yield state.copyWith(status: SubmissionFailed(e));
      }
    }
  }

  Stream<LoginState> _mapLoginWithBiometricRequestedToState(
      String reason) async* {
    yield state.copyWith(status: FormSubmitting());

    try {
      await _authenticationRepository.biometricLogin(reason);

      yield state.copyWith(status: SubmissionSuccess());
    } catch (e) {
      yield state.copyWith(status: SubmissionFailed(e));
    }
  }

  Duration _getAttemptDuration(int attempt) {
    if (attempt == 4) {
      return Duration(seconds: 60);
    } else if (attempt == 5) {
      return Duration(seconds: 120);
    } else if (attempt >= 6) {
      return Duration(seconds: 300);
    } else {
      return Duration(seconds: 30);
    }
  }

  @override
  LoginState fromJson(Map<String, dynamic> json) {
    final LoginState state = LoginState(
      status: const InitialFormStatus(),
      attempt: LoginAttempt.fromJson(json['attempt']),
    );

    return state;
  }

  @override
  Map<String, dynamic> toJson(LoginState state) {
    return <String, dynamic>{
      'attempt': state.attempt,
    };
  }
}
