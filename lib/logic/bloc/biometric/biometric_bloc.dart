import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notification_app/services/biometric_auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:notification_app/services/local_storage_service.dart';

part 'biometric_event.dart';
part 'biometric_state.dart';

class BiometricIdBloc extends Bloc<BiometricIdEvent, BiometricIdState> {
  final BiometricAuthService _biometricAuth = BiometricAuthService();
  final LocalStorage _localStorage = LocalStorage();

  BiometricIdBloc() : super(BiometricIdInitialState());

  @override
  Stream<BiometricIdState> mapEventToState(BiometricIdEvent event) async* {
    if (event is BiometricIdCheckAvailabilityEvent) {
      yield* _mapBiometricIdCheckAvailabilityToState();
    } else if (event is BiometricIdConsentSaveEvent) {
      yield* _mapBiometricIdConsentSaveEventToState(event);
    }
  }

  Stream<BiometricIdState> _mapBiometricIdCheckAvailabilityToState() async* {
    bool supported = await _biometricAuth.isSupported();
    BiometricType? biometricId =
        supported ? await _biometricAuth.getBiometricId() : null;

    if (biometricId != null) {
      yield BiometricIdAvailableState(biometricId);
    } else {
      yield BiometricIdUnavailableState();
    }
  }

  Stream<BiometricIdState> _mapBiometricIdConsentSaveEventToState(
      BiometricIdConsentSaveEvent event) async* {
    _localStorage.biometricLoginActivated = event.value;
    yield BiometricIdConsentSavedState();
  }
}
