import 'dart:io';

import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication biometricAuth = LocalAuthentication();

  Future<BiometricType?> getBiometricId() async {
    List<BiometricType> availableBiometrics =
        await biometricAuth.getAvailableBiometrics();

    if (Platform.isIOS && availableBiometrics.contains(BiometricType.face)) {
      return BiometricType.face;
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return BiometricType.fingerprint;
    }

    return null;
  }

  Future<bool> isSupported() async {
    bool isBiometricSupported = false;
    bool canCheckBiometrics = false;

    try {
      isBiometricSupported = await biometricAuth.isDeviceSupported();
      canCheckBiometrics = await biometricAuth.canCheckBiometrics;
    } catch (error) {
      throw error;
    }

    return isBiometricSupported && canCheckBiometrics;
  }
}
