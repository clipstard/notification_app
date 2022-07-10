part of 'push_notifications_bloc.dart';

@immutable
abstract class PushNotificationsEvent extends Equatable {
  const PushNotificationsEvent();

  @override
  List<Object> get props => <Object>[];
}

class PushNotificationsStarted extends PushNotificationsEvent {}

class PushNotificationsEnableEvent extends PushNotificationsEvent {
  PushNotificationsEnableEvent({required this.loyaltyProgram});
  final LoyaltyProgram loyaltyProgram;

  @override
  List<Object> get props => <Object>[loyaltyProgram];
}

class PushNotificationsDisableEvent extends PushNotificationsEvent {
  PushNotificationsDisableEvent({required this.loyaltyProgram});
  final LoyaltyProgram loyaltyProgram;

  @override
  List<Object> get props => <Object>[loyaltyProgram];
}

class PushNotificationsSkipEvent extends PushNotificationsEvent {}

class PushNotificationsDisallowEvent extends PushNotificationsEvent {}
