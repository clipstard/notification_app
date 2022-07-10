import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/widgets.dart';
import 'package:notification_app/data/models/user.dart';

import 'package:notification_app/data/providers/http_provider.dart';
import 'package:notification_app/utils/utils.dart' show msisdnToCustomerId;

class UserProvider with ChangeNotifier {
  HttpProvider _httpProvider = HttpProvider(useMock: false);

  Future<User> getUser(String customerId) async {
    final dynamic response = await _httpProvider.get(
      '/user',
      headers: <String, String>{
        'customerId': customerId,
      },
    );

    return User.fromJson(response);
  }

  Future<bool> updateUser(String userId, User userInfos) async {
    final dynamic response = await _httpProvider.put(
      '/user',
      body: json.encode(<String, dynamic>{
        'userId': userId,
        'userProfile': userInfos.toJson(),
      }),
    );

    return response.toString().isEmpty;
  }

  Future<bool> setPassword({
    required String msisdn,
    required String password,
    required String token,
  }) async {
    final dynamic response = await _httpProvider.put(
      '/user/setPassword',
      headers: <String, String>{
        'X-OTP-AUTH': token,
      },
      body: json.encode(
        <String, String>{
          'userId': msisdnToCustomerId(msisdn),
          'password': password,
        },
      ),
    );

    return response.toString().isEmpty;
  }
}
