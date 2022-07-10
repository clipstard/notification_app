part of 'push_notifications_bloc.dart';

abstract class PushNotificationsState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class PushNotificationsInitial extends PushNotificationsState {}

class PushNotificationPostponed extends PushNotificationsState {
  final DateTime untilDate;
  final String token;
  PushNotificationPostponed({
    required this.untilDate,
    required this.token,
  });

  @override
  List<Object> get props => <Object>[token, untilDate.toUEFormat()];
}

class PushNotificationsEnabled extends PushNotificationsState {
  final String token;
  PushNotificationsEnabled(this.token);

  @override
  List<Object> get props => <Object>[token];
}

class PushNotificationsDisabled extends PushNotificationsState {}

class PushNotificationsTokenUnavailable extends PushNotificationsState {}

class PushNotificationsDisallowed extends PushNotificationsState {}

class PushNotificationsSettingsRequested extends PushNotificationsState {}

class Loading extends PushNotificationsState {}

class Error extends PushNotificationsState {
  final String errorMessage;
  Error({required this.errorMessage});

  @override
  List<Object> get props => <Object>[errorMessage];
}
