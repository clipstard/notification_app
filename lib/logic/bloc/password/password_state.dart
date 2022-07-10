part of 'password_bloc.dart';

class PasswordState {
  final bool isValid;
  final bool isPwned;
  final bool isGuessable;
  final bool passwordWasChanged;
  final FormSubmissionStatus status;

  PasswordState({
    required this.isValid,
    required this.isPwned,
    required this.isGuessable,
    required this.passwordWasChanged,
    this.status = const InitialFormStatus(),
  });

  factory PasswordState.empty() {
    return PasswordState(
      isValid: false,
      isPwned: true,
      isGuessable: true,
      passwordWasChanged: false,
      status: FormSubmitting(),
    );
  }

  PasswordState copyWith({
    bool? isValid,
    bool? isPwned,
    bool? isGuessable,
    bool? passwordWasChanged,
    FormSubmissionStatus? status,
  }) {
    return PasswordState(
      isValid: isValid ?? this.isValid,
      isPwned: isPwned ?? this.isPwned,
      isGuessable: isGuessable ?? this.isGuessable,
      passwordWasChanged: passwordWasChanged ?? false,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'PasswordState{isValid: $isValid,' +
        'isPwned: $isPwned, isGuessable: $isGuessable,' +
        'passwordWasChanged: $passwordWasChanged}';
  }
}
