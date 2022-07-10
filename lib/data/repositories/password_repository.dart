import 'dart:convert' show utf8;

import 'package:crypto/crypto.dart';
import 'package:notification_app/data/providers/password_provider.dart';
import 'package:notification_app/data/providers/user_provider.dart';

class PasswordRepository {
  PasswordProvider _passwordProvider = PasswordProvider();
  UserProvider _userProvider = UserProvider();
  List<String> _guessableList = <String>[];

  /// Search the Guessable Passwords database for the provided [password]
  /// appearance.
  ///
  /// Throws an [error] if dictionary of guessable passwords is not available.
  /// Returns the boolean which says the guessable passwords dictionary
  /// is not empty and [password] exists in the dictionary.
  Future<bool> isGuessablePassword(String password) async {
    try {
      /// Store the password in local variable in order to do not perform
      /// multiple calls
      if (_guessableList.isEmpty) {
        final List<String> response =
            await _passwordProvider.getGuessablePasswords();
        _guessableList = response;
      }

      return _guessableList.isNotEmpty && _guessableList.contains(password);
    } catch (e) {
      throw e;
    }
  }

  /// Search the Pwned Passwords database for the first 5 chars of a SHA-1 hash
  /// of the provided [password].
  ///
  /// Throws an [error] if data breach API is not available.
  /// Returns the boolean which says the pwned passwords dictionary is not empty
  /// and the SHA-1 suffix exists in data breached dictionary.
  Future<bool> isPwnedPassword(String password) async {
    try {
      List<int> bytes = utf8.encode(password);
      String pwdHash = sha1.convert(bytes).toString();
      String pwdHashPefix = pwdHash.substring(0, 5);
      String pwdHashSuffix = pwdHash.substring(5);

      final List<String> response =
          await _passwordProvider.getPwnedPasswordsByHash(pwdHashPefix);

      return response.isNotEmpty && response.contains(pwdHashSuffix);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> updateUserPassword(
    String msisdn,
    String password,
    String token,
  ) {
    return _userProvider.setPassword(
      msisdn: msisdn,
      password: password,
      token: token,
    );
  }
}
