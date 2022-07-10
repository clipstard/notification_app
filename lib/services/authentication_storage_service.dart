import 'package:notification_app/data/models/persistent_login.dart';
import 'package:notification_app/services/local_storage_service.dart';
import 'package:notification_app/services/secure_storage_service.dart';

class AuthenticationStorage {
  final SecureStorage _secureStorage = SecureStorage();
  final LocalStorage _localStorage = LocalStorage();

  static const String _tokenKey = 'AUTH_ACCESS_TOKEN';
  static const String _passwordKey = 'AUTH_PASSWORD';

  /// Token
  ///
  Future<void> persistToken(String token) async {
    await _secureStorage.write(_tokenKey, token);
  }

  Future<void> deleteToken() async {
    return _secureStorage.delete(_tokenKey);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(_tokenKey) ?? '';
  }

  Future<bool> hasToken() async {
    final String? value = await _secureStorage.read(_tokenKey);
    return value != null;
  }

  /// Password
  ///
  Future<void> persistPassword(String password) async {
    await _secureStorage.write(_passwordKey, password);
  }

  Future<void> deletePassword() async {
    return _secureStorage.delete(_passwordKey);
  }

  Future<String> getPassword() async {
    return await _secureStorage.read(_passwordKey) ?? '';
  }

  Future<bool> hasPassword() async {
    final String? value = await _secureStorage.read(_passwordKey);
    return value != null;
  }

  Future<PersistentLogin> getPersistentLoginData() async {
    final String msisdn = _localStorage.msisdn;
    final bool rememberMe = _localStorage.rememberMe;
    final String firstName = _localStorage.userFirstName;
    final bool isFirstLogin = _localStorage.isFirstLogin;
    final String password = await this.getPassword();

    final bool shouldActivateRememberMe =
        msisdn.isNotEmpty && firstName.isNotEmpty && rememberMe;

    final PersistentLogin data = PersistentLogin(
      firstName: firstName,
      rememberMe: shouldActivateRememberMe,
      isFirstLogin: isFirstLogin,
      msisdn: msisdn,
      password: password,
    );

    return data;
  }

  Future<void> deleteAll() async {
    return _secureStorage.deleteAll();
  }
}
