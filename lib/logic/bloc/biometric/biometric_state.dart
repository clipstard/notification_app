part of 'biometric_bloc.dart';

abstract class BiometricIdState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class BiometricIdInitialState extends BiometricIdState {}

class BiometricIdAvailableState extends BiometricIdState {
  final BiometricType biometricId;

  BiometricIdAvailableState(this.biometricId);

  @override
  List<Object> get props => <Object>[biometricId];
}

class BiometricIdUnavailableState extends BiometricIdState {}

class BiometricIdConsentSavedState extends BiometricIdState {}
