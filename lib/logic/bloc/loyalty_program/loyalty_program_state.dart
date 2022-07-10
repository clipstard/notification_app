part of 'loyalty_program_bloc.dart';

class LoyaltyProgramState extends Equatable {
  const LoyaltyProgramState({
    this.status = const InitialFormStatus(),
  });

  final FormSubmissionStatus status;

  LoyaltyProgramState copyWith({
    FormSubmissionStatus? status,
  }) {
    return LoyaltyProgramState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => <Object>[status];
}
