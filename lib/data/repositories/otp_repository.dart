import 'dart:convert' show json;

import 'package:notification_app/constants/app_config.dart';
import 'package:notification_app/data/models/otp.dart';
import 'package:notification_app/data/models/otp_data.dart';
import 'package:notification_app/data/providers/otp_provider.dart';
import 'package:notification_app/services/secure_storage_service.dart';
import 'package:notification_app/extensions/extensions.dart' show Trimmer;
part 'package:notification_app/services/otp_storage_service.dart';

class OtpRepository extends OtpStorage {
  static const String _otpStorageKey = 'OTP';
  static const String _otpTrySessionStorageKey = 'OTP_TRY_SESSION_';
  final OtpProvider _otpProvider = OtpProvider();

  String _msisdnStorageKey(String msisdn) =>
      _otpTrySessionStorageKey +
      msisdn.backwardSubstring(AppConfig.phoneLength);

  Future<void> storeOTPData(OTPData otpData) async {
    await _secureStorage.write(_otpStorageKey, otpData.toString());
  }

  Future<void> storeOtpAttempt(OTPData otpData) async {
    List<OTPData> _attempts = await retrieveOtpAttempts(otpData.msisdn);
    _attempts.add(otpData);
    String _key = _msisdnStorageKey(otpData.msisdn);
    await _storeSavedKey(_key);
    await _secureStorage.write(
      _key,
      json.encode(_attempts.map((OTPData e) => e.toString()).toList()),
    );
  }

  Future<List<OTPData>> retrieveOtpAttempts(String msisdn) async {
    String? data = await _secureStorage.read(_msisdnStorageKey(msisdn));
    if (data == null) {
      return <OTPData>[];
    }

    return json
        .decode(data)
        .map((dynamic e) =>
            OTPData.fromJson(json.decode(e as String) as Map<String, dynamic>))
        .toList()
        .cast<OTPData>() as List<OTPData>;
  }

  Future<void> clearAttempts(String msisdn) async {
    String _key = _msisdnStorageKey(msisdn);
    _removeStoredKey(_key);
    await _secureStorage.delete(_key);
  }

  Future<OTPData?> retrieveOTPData() async {
    String? data = await _secureStorage.read(_otpStorageKey);
    if (data == null) {
      return null;
    }

    return OTPData.fromJson(json.decode(data) as Map<String, dynamic>);
  }

  Future<void> clear() async {
    List<String> _keys = await _retrieveStoredKeys();
    await Future.wait(_keys.map((String key) async {
      await clearAttempts(key);
    }));
    await _removeKeys();
    await removeOtpData();
  }

  Future<void> removeOtpData() async {
    await _secureStorage.delete(_otpStorageKey);
  }

  Future<OneTimePassword> requestOtpValidation({
    required String msisdn,
    required OtpType otpType,
  }) {
    try {
      return _otpProvider.otpSend(otpType, msisdn);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> validateOtp({
    required String otpCode,
    required String msisdn,
    required OtpType otpType,
  }) async {
    return await _otpProvider.otpValidate(
      msisdn: msisdn,
      otpType: otpType,
      otpCode: otpCode,
    );
  }
}
