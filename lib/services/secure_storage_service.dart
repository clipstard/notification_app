import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = new FlutterSecureStorage();

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<Map<String, String>> readAll() async {
    Map<String, String> allValues = await _storage.readAll();
    return allValues;
  }

  Future<void> delete(String key) async {
    return await _storage.delete(key: key);
  }

  Future<void> deleteBulk(List<String> keys) async {
    if (keys.isNotEmpty) {
      for (final String key in keys) {
        await _storage.delete(key: key);
      }
    }
  }

  Future<void> deleteAll() async {
    return await _storage.deleteAll();
  }

  Future<void> write(String key, String value) async {
    return await _storage.write(key: key, value: value);
  }
}
