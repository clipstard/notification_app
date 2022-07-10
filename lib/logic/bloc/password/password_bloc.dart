import 'package:bloc/bloc.dart';
import 'package:notification_app/data/repositories/password_repository.dart';
import 'package:notification_app/logic/form_submission_status.dart';
import 'package:notification_app/utils/utils.dart' show Validators;
import 'package:equatable/equatable.dart';

part 'password_event.dart';
part 'password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final PasswordRepository _passwordRepository;

  PasswordBloc({required PasswordRepository passwordRepository})
      : _passwordRepository = passwordRepository,
        super(PasswordState.empty());

  @override
  Stream<PasswordState> mapEventToState(PasswordEvent event) async* {
    if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is PasswordGuessable) {
      yield* _mapPasswordGuessableToState(event.password);
    } else if (event is PasswordPwned) {
      yield* _mapPasswordPwnedToState(event.password);
    } else if (event is PaswordSequentialValidation) {
      yield* _mapPasswordSequentialValidationToState(event.password);
    } else if (event is UpdateUserPassword) {
      yield* _updateUserPassword(event.msisdn, event.password, event.token);
    }
  }

  Stream<PasswordState> _mapPasswordChangedToState(
    String password,
  ) async* {
    final bool isValidPassword =
        Validators.isNotEmpty(password) && Validators.isValidPassword(password);

    yield state.copyWith(
      isValid: isValidPassword,
      isGuessable: state.isGuessable || !isValidPassword,
      isPwned: state.isPwned || !isValidPassword,
      passwordWasChanged: true,
    );
  }

  Stream<PasswordState> _mapPasswordGuessableToState(
    String password,
  ) async* {
    try {
      final bool isGuessable =
          await _passwordRepository.isGuessablePassword(password);
      yield state.copyWith(isGuessable: isGuessable);
    } on Exception catch (_) {
      /// Skip the validation in case of failure
      yield state.copyWith(isGuessable: false);
    }
  }

  Stream<PasswordState> _mapPasswordPwnedToState(
    String password,
  ) async* {
    try {
      final bool isPwned = await _passwordRepository.isPwnedPassword(password);
      yield state.copyWith(isPwned: isPwned);
    } on Exception catch (_) {
      /// Skip the validation in case of failure
      yield state.copyWith(isPwned: false);
    }
  }

  Stream<PasswordState> _mapPasswordSequentialValidationToState(
    String password,
  ) async* {
    /// 1. Guessable passwords validation first
    yield* _mapPasswordGuessableToState(password);

    /// 2. If guessable password validation passed only then check for the
    /// pwned passwords, otherwise no check
    if (!state.isGuessable) {
      yield* _mapPasswordPwnedToState(password);
    }
  }

  /// TODO
  /// Move to user bloc / repositroy / provider
  Stream<PasswordState> _updateUserPassword(
    String msisdn,
    String password,
    String token,
  ) async* {
    try {
      yield state.copyWith(status: FormSubmitting());
      await _passwordRepository.updateUserPassword(msisdn, password, token);
      yield state.copyWith(status: SubmissionSuccess());
    } catch (e) {
      yield state.copyWith(status: SubmissionFailed(e));
    }
  }
}
