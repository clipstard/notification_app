part of 'biometric_bloc.dart';

abstract class BiometricIdEvent extends Equatable {
  const BiometricIdEvent();

  @override
  List<Object> get props => <Object>[];
}

class BiometricIdCheckAvailabilityEvent extends BiometricIdEvent {}

class BiometricIdConsentSaveEvent extends BiometricIdEvent {
  BiometricIdConsentSaveEvent({required this.value});

  final bool value;

  @override
  List<Object> get props => <Object>[value];
}
