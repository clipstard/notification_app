import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notification_app/data/models/consent.dart';
import 'package:notification_app/data/models/custom_field.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/repositories/authentication_repository.dart';
import 'package:notification_app/data/repositories/loyalty_program_repository.dart';
import 'package:notification_app/logic/form_submission_status.dart';

part 'loyalty_program_event.dart';

part 'loyalty_program_state.dart';

class LoyaltyProgramBloc
    extends Bloc<LoyaltyProgramEvent, LoyaltyProgramState> {
  final LoyaltyProgramRepository _loyaltyProgramRepository;
  final AuthenticationRepository _authenticationRepository;

  LoyaltyProgramBloc({
    required LoyaltyProgramRepository loyaltyProgramRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _loyaltyProgramRepository = loyaltyProgramRepository,
        _authenticationRepository = authenticationRepository,
        super(LoyaltyProgramState());

  @override
  Stream<LoyaltyProgramState> mapEventToState(
      LoyaltyProgramEvent event) async* {
    if (event is OptInLoyaltyProgram) {
      yield* _mapOptInLoyaltyProgramToState(event);
    } else if (event is UpdateMarketingPreference) {
      yield* _mapUpdateMarketingPreferenceToState(event);
    } else if (event is OptOutLoyaltyProgram) {
      yield* _mapOptOutLoyaltyProgramToState(event);
    } else if (event is UpdateUserInfoCustomField) {
      yield* _mapUpdateUserInfoCustomFieldToState(event);
    }
  }

  Stream<LoyaltyProgramState> _mapOptInLoyaltyProgramToState(
      OptInLoyaltyProgram event) async* {
    try {
      yield state.copyWith(status: FormSubmitting());

      await _loyaltyProgramRepository.optIn(event.loyaltyProgram, event.token);

      /// [AuthenticationOrigin.synthetic] login in order to login the user,
      /// without the redirection to homepage, as we have to pass also
      /// Biometric Authentication and Push Notifications steps.
      /// [shouldPersistPassword] is set to false in order to require the user
      /// for manual login first time after he just optedIn
      await _authenticationRepository.logIn(
        msisdn: event.loyaltyProgram.customerId,
        password: event.loyaltyProgram.userInfos!.password!,
        rememberMe: false,
        withBiometrics: false,
        origin: AuthenticationOrigin.synthetic,
        shouldPersistPassword: false,
      );

      yield state.copyWith(status: SubmissionSuccess());
    } catch (e) {
      yield state.copyWith(status: SubmissionFailed(e));
    }
  }

  Stream<LoyaltyProgramState> _mapOptOutLoyaltyProgramToState(
      OptOutLoyaltyProgram event) async* {
    try {
      yield state.copyWith(status: FormSubmitting());

      await _loyaltyProgramRepository.optOut(event.customerId);

      yield state.copyWith(status: SubmissionSuccess());
    } catch (e) {
      yield state.copyWith(status: SubmissionFailed(e));
    }
  }

  Stream<LoyaltyProgramState> _mapUpdateMarketingPreferenceToState(
      UpdateMarketingPreference event) async* {
    final Consent consent = event.marketingPreference;
    final LoyaltyProgram loyaltyProgram = event.loyaltyProgram;

    loyaltyProgram.consents
      ..removeWhere((Consent item) => item.name == consent.name)
      ..add(Consent(name: consent.name, value: consent.value));

    try {
      yield state.copyWith(status: FormSubmitting());

      await _loyaltyProgramRepository.updateProgramProfile(loyaltyProgram);

      yield state.copyWith(status: SubmissionSuccess());
    } catch (e) {
      yield state.copyWith(status: SubmissionFailed(e));
    }
  }

  Stream<LoyaltyProgramState> _mapUpdateUserInfoCustomFieldToState(
      UpdateUserInfoCustomField event) async* {
    final LoyaltyProgram loyaltyProgram = event.loyaltyProgram;
    final CustomField customField = event.customField;

    loyaltyProgram.userInfos?.customFields
      ?..removeWhere((CustomField e) => e.name == customField.name)
      ..add(customField);

    try {
      yield state.copyWith(status: FormSubmitting());

      await _loyaltyProgramRepository.updateProgramProfile(loyaltyProgram);

      yield state.copyWith(status: SubmissionSuccess());
    } catch (e) {
      yield state.copyWith(status: SubmissionFailed(e));
    }
  }
}
