import 'dart:async';
import 'dart:convert' show json;

import 'package:local_auth/local_auth.dart';
import 'package:notification_app/data/models/oauth.dart';
import 'package:notification_app/data/providers/authentication_provider.dart';
import 'package:notification_app/services/authentication_storage_service.dart';
import 'package:notification_app/services/local_storage_service.dart';

part 'package:notification_app/data/models/authentication_event.dart';

enum AuthenticationStatus {
  initialize,
  unknown,
  authenticated,
  unauthenticated,
}

enum AuthenticationOrigin {
  synthetic,
  userInteraction,
}

class AuthenticationRepository extends AuthenticationStorage {
  final AuthProvider _auth = AuthProvider();
  final LocalStorage _localStorage = LocalStorage();
  final LocalAuthentication _biometricAuth = LocalAuthentication();
  final StreamController<AuthnenticationEvent> _controller =
      StreamController<AuthnenticationEvent>();

  Stream<AuthnenticationEvent> get event async* {
    yield AuthnenticationEvent(
      status: AuthenticationStatus.initialize,
      withBiometrics: false,
      origin: AuthenticationOrigin.synthetic,
    );

    yield* _controller.stream;
  }

  Future<Oauth> logIn({
    required String msisdn,
    required String password,
    required bool rememberMe,
    required bool withBiometrics,
    required AuthenticationOrigin origin,
    bool shouldPersistPassword = true,
  }) =>
      _auth
          .logIn(
        msisdn: msisdn,
        password: password,
      )
          .then((Oauth value) {
        _localStorage.msisdn = msisdn;
        _localStorage.rememberMe = rememberMe;

        /// Persist token into a secure storage
        persistToken(value.access_token);

        /// Persist password into a secure storage
        /// For the future usage with Biometric Authentication
        if (shouldPersistPassword) {
          persistPassword(password);
        }

        _controller.add(AuthnenticationEvent(
          status: AuthenticationStatus.authenticated,
          withBiometrics: withBiometrics,
          origin: origin,
        ));

        return value;
      });

  /// Used for biometric authentication
  /// As we don't have refresh token, we just store the password in secure
  /// storage and then try to login automatically with persisted credentials
  Future<Oauth> autoLogin({
    required AuthenticationOrigin origin,
    required bool withBiometrics,
  }) async {
    final String msisdn = _localStorage.msisdn;
    final bool rememberMe = _localStorage.rememberMe;
    final String? password = await getPassword();

    if (msisdn.isNotEmpty && password != null) {
      return logIn(
        msisdn: msisdn,
        password: password,
        rememberMe: rememberMe,
        withBiometrics: withBiometrics,
        origin: origin,
      );
    }

    throw Exception('Oops.. Something went wrong. Try manual login.');
  }

  /// Biometric login
  Future<Oauth> biometricLogin(String reason) async {
    try {
      final bool isAuthenticated = await _biometricAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );

      return this.autoLogin(
        withBiometrics: isAuthenticated,
        origin: AuthenticationOrigin.userInteraction,
      );
    } catch (e) {
      throw Exception(
          'Biometric authentication unavailable. Try manual login.');
    }
  }

  void logOut(AuthenticationOrigin origin) async {
    /// Delete only the token from secure storage in order to invalidate
    /// all future requests
    await deleteToken();

    _controller.add(AuthnenticationEvent(
      status: AuthenticationStatus.unauthenticated,
      withBiometrics: false,
      origin: origin,
    ));
  }

  void dispose() => _controller.close();
}
