import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:notification_app/data/models/consent.dart';
import 'package:notification_app/data/models/custom_field.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/repositories/loyalty_program_repository.dart';
import 'package:notification_app/presentation/screens/home_screen.dart';
import 'package:notification_app/services/push_notification_service.dart';
import 'package:notification_app/presentation/screens/setup_push_notifications_screen.dart';
import 'package:notification_app/extensions/extensions.dart' show Formatter;

part 'push_notifications_event.dart';
part 'push_notifications_state.dart';

class PushNotificationsBloc
    extends Bloc<PushNotificationsEvent, PushNotificationsState> {
  final LoyaltyProgramRepository _loyaltyProgramRepository;
  final PushNotificationsService _pushNotificationsService =
      PushNotificationsService();
  Widget? _notificationsScreen;

  PushNotificationsBloc(
      {required LoyaltyProgramRepository loyaltyProgramRepository})
      : _loyaltyProgramRepository = loyaltyProgramRepository,
        super(PushNotificationsInitial());

  @override
  Stream<PushNotificationsState> mapEventToState(
      PushNotificationsEvent event) async* {
    if (event is PushNotificationsStarted) {
      yield* _mapPushNotificationsStartedToState();
    } else if (event is PushNotificationsEnableEvent) {
      yield* _mapPushNotificationsEnableToState(event.loyaltyProgram);
    } else if (event is PushNotificationsDisableEvent) {
      yield* _mapPushNotificationsDisableToState(event.loyaltyProgram);
    } else if (event is PushNotificationsDisallowEvent) {
      yield* _mapPushNotificationsDisallowToState(event);
    }
  }

  Stream<PushNotificationsState> _mapPushNotificationsStartedToState() async* {
    PostponedInfo? postponedInfo =
        await _loyaltyProgramRepository.retrievePostponeInfo();

    if (postponedInfo != null) {
      _notificationsScreen = HomeScreen();
      yield PushNotificationPostponed(
        untilDate: postponedInfo.untilDate,
        token: postponedInfo.token,
      );
    } else {
      _notificationsScreen = SetupPushNotifications();
      yield PushNotificationsInitial();
    }
  }

  Stream<PushNotificationsState> _mapPushNotificationsEnableToState(
      LoyaltyProgram loyaltyProgram) async* {
    final bool allowedPushNotifications =
        await _pushNotificationsService.requestPushNotificationPermissions();

    /// On Android always will be true.
    /// Refer _pushNotificationsService.requestPushNotificationPermissions
    /// comment notes.
    if (allowedPushNotifications) {
      final String? token =
          await _pushNotificationsService.getPushNotificationsToken();

      if (token != null) {
        try {
          yield Loading();

          /// Update push notifications preferences
          loyaltyProgram.customFields
            ..removeWhere((CustomField item) =>
                item.name == CustomField.pushMobileOsTokenId)
            ..add(CustomField(
                name: CustomField.pushMobileOsTokenId, value: token));

          loyaltyProgram.consents
            ..removeWhere(
                (Consent item) => item.name == Consent.pushPreferredContact)
            ..add(Consent(name: Consent.pushPreferredContact, value: true));

          await _loyaltyProgramRepository.updateProgramProfile(loyaltyProgram);
          yield PushNotificationsEnabled(token);
        } catch (e) {
          yield Error(errorMessage: e.toString());
        }
      } else {
        PushNotificationsTokenUnavailable();
      }
    } else {
      final bool alreadyRequestedPermissions =
          await _pushNotificationsService.isPreviouslyRequestedPermission();

      yield alreadyRequestedPermissions
          ? PushNotificationsSettingsRequested()
          : PushNotificationsDisallowed();
    }
  }

  Stream<PushNotificationsState> _mapPushNotificationsDisableToState(
      LoyaltyProgram loyaltyProgram) async* {
    try {
      yield Loading();

      /// Update push notifications preferences
      loyaltyProgram.consents
        ..removeWhere(
            (Consent item) => item.name == Consent.pushPreferredContact)
        ..add(Consent(name: Consent.pushPreferredContact, value: false));

      await _loyaltyProgramRepository.updateProgramProfile(loyaltyProgram);
      yield PushNotificationsDisabled();
    } catch (e) {
      yield Error(errorMessage: e.toString());
    }
  }

  Stream<PushNotificationsState> _mapPushNotificationsDisallowToState(
    PushNotificationsEvent event,
  ) async* {
    yield PushNotificationsDisallowed();
  }

  Widget get notificationsScreen {
    return _notificationsScreen ?? SetupPushNotifications();
  }
}
