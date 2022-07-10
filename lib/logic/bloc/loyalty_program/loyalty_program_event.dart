part of 'loyalty_program_bloc.dart';

abstract class LoyaltyProgramEvent extends Equatable {
  const LoyaltyProgramEvent();

  @override
  List<Object> get props => <Object>[];
}

class OptInLoyaltyProgram extends LoyaltyProgramEvent {
  OptInLoyaltyProgram({
    required this.loyaltyProgram,
    required this.token,
  });

  final LoyaltyProgram loyaltyProgram;
  final String token;

  @override
  List<Object> get props => <Object>[loyaltyProgram, token];
}

class OptOutLoyaltyProgram extends LoyaltyProgramEvent {
  OptOutLoyaltyProgram({
    required this.customerId,
  });

  final String customerId;

  @override
  List<Object> get props => <Object>[customerId];
}

class UpdateMarketingPreference extends LoyaltyProgramEvent {
  UpdateMarketingPreference({
    required this.loyaltyProgram,
    required this.marketingPreference,
  });

  final LoyaltyProgram loyaltyProgram;
  final Consent marketingPreference;

  @override
  List<Object> get props => <Object>[loyaltyProgram, marketingPreference];
}

class UpdateUserInfoCustomField extends LoyaltyProgramEvent {
  UpdateUserInfoCustomField({
    required this.loyaltyProgram,
    required this.customField,
  });

  final LoyaltyProgram loyaltyProgram;
  final CustomField customField;

  @override
  List<Object> get props => <Object>[loyaltyProgram, customField];
}
