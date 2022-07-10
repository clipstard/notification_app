import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/widgets.dart';
import 'package:notification_app/data/models/otp.dart';
import 'package:notification_app/data/providers/device_info_provider.dart';
import 'package:notification_app/data/providers/http_provider.dart';
import 'package:notification_app/utils/convert_util.dart';

enum OtpType {
  Register,
  Renew,
  Password,
}

class OtpProvider extends DeviceInfoProvider with ChangeNotifier {
  HttpProvider _httpProvider = HttpProvider();

  Future<OneTimePassword> otpSend(
    OtpType otpType,
    String msisdn,
  ) async {
    final dynamic response = await _httpProvider.post(
      '/otp/send',
      body: json.encode(
        <String, String>{
          'otpType': describeEnum(otpType),
          'userId': msisdnToCustomerId(msisdn),
        },
      ),
      headers: await deviceHeaders(),
    );

    try {
      return OneTimePassword.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> otpValidate({
    required String otpCode,
    required OtpType otpType,
    required String msisdn,
  }) async {
    await _httpProvider.put(
      '/otp',
      body: json.encode(
        <String, String>{
          'otpType': describeEnum(otpType),
          'otpCode': otpCode,
          'userId': msisdnToCustomerId(msisdn),
        },
      ),
      headers: await deviceHeaders(),
    );

    /// in case of error [ApiError] will be returned
    return true;
  }
}
