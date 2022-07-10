part of 'package:notification_app/data/repositories/otp_repository.dart';

class OtpStorage {
  static const String _keyStorageKey = 'OTP_SAVED_KEYS';
  final SecureStorage _secureStorage = SecureStorage();

  Future<void> _storeSavedKey(String key) async {
    List<String> _keys = await _retrieveStoredKeys();
    _keys.add(key);
    await _secureStorage.write(
      _keyStorageKey,
      json.encode(_keys),
    );
  }

  Future<List<String>> _retrieveStoredKeys() async {
    String? data = await _secureStorage.read(_keyStorageKey);
    if (data == null) {
      return <String>[];
    }

    return json.decode(data).cast<String>() as List<String>;
  }

  Future<void> _removeStoredKey(String key) async {
    List<String> _keys = await _retrieveStoredKeys();
    _keys = _keys.where((String element) => element != key).toList();
    await _secureStorage.write(
      _keyStorageKey,
      json.encode(_keys),
    );
  }

  Future<void> _removeKeys() async {
    await _secureStorage.delete(_keyStorageKey);
  }
}
