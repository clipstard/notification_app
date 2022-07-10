import 'dart:async';

import 'package:notification_app/data/models/oauth.dart';
import 'package:notification_app/data/providers/device_info_provider.dart';
import 'package:notification_app/data/providers/http_provider.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:notification_app/utils/utils.dart' show msisdnToCustomerId;

class AuthProvider extends DeviceInfoProvider with ChangeNotifier {
  HttpProvider _httpProvider = HttpProvider();

  Future<Oauth> logIn({
    required String msisdn,
    required String password,
  }) async {
    final String basicAuthKey = dotenv.env['API_BASIC_AUTH_KEY']!;

    final dynamic response = await _httpProvider.post(
      '/oauth/token',
      body: <String, String>{
        'grant_type': 'password',
        'username': msisdnToCustomerId(msisdn),
        'password': password,
      },
      headers: <String, String>{
        'content-type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${basicAuthKey}',
      }..addAll(await deviceHeaders()),
      purePath: true,
    );

    return Oauth.fromJson(response);
  }
}
