import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/widgets.dart';
import 'package:notification_app/constants/app_config.dart';
import 'package:notification_app/data/models/consent.dart';
import 'package:notification_app/data/models/custom_field.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/providers/device_info_provider.dart';
import 'package:notification_app/data/providers/http_provider.dart';

class LoyaltyProgramProvider extends DeviceInfoProvider with ChangeNotifier {
  HttpProvider _httpProvider = HttpProvider(useMock: false);

  Future<LoyaltyProgram> getLoyaltyProgram(String customerId) async {
    final String programName =
        Uri.encodeComponent(AppConfig.loyaltyProgramName);

    final dynamic response = await _httpProvider.get(
      '/loyaltyProgram/programProfile/${programName}',
      headers: <String, String>{
        'customerId': customerId,
      },
    );

    return LoyaltyProgram.fromJson(response);
  }

  Future<dynamic> optIn(
    LoyaltyProgram loyaltyProgram, {
    required String token,
  }) async {
    final dynamic response = await _httpProvider.put(
      '/loyaltyProgram/optin',
      body: json.encode(loyaltyProgram.toJson()),
      parameters: <String, String>{
        'authenticated': 'true',
      },
      headers: <String, String>{
        'X-OTP-AUTH': token,
      }..addAll(await deviceHeaders()),
    );

    return response;
  }

  Future<dynamic> optOut(String customerId) async {
    final dynamic response = await _httpProvider.put(
      '/loyaltyProgram/optout',
      body: json.encode(
        <String, String>{
          'customerId': customerId,
          'programId': AppConfig.loyaltyProgramName,
        },
      ),
      headers: await deviceHeaders(),
    );

    return response;
  }

  Future<dynamic> updateProgramProfile(LoyaltyProgram loyaltyProgram) async {
    final dynamic response = await _httpProvider.put(
      '/loyaltyProgram/programProfile/update',
      body: json.encode(
        loyaltyProgram.toJson(),
      ),
      headers: await deviceHeaders(),
    );

    return response;
  }

  Future<dynamic> setPushNotificationToken(
    String customerId,
    String token,
  ) async {
    dynamic response = await _httpProvider.put(
      '/loyaltyProgram/programProfile/update',
      body: json.encode(
        LoyaltyProgram(
          customerId: customerId,
          programName: AppConfig.loyaltyProgramName,
          customFields: <CustomField>[
            CustomField(
              name: 'pushMobileOsTokenId',
              value: token,
            ),
          ],
          consents: <Consent>[
            Consent(
              name: Consent.pushPreferredContact,
              value: true,
            ),
          ],
        ).toJson(),
      ),
      headers: await deviceHeaders(),
    );

    return response;
  }

  Future<dynamic> disablePushNotifications(String customerId) async {
    dynamic response = await _httpProvider.put(
      '/loyaltyProgram/programProfile/update',
      body: json.encode(
        LoyaltyProgram(
          customerId: customerId,
          programName: AppConfig.loyaltyProgramName,
          consents: <Consent>[
            Consent(
              name: Consent.pushPreferredContact,
              value: false,
            ),
          ],
        ).toJson(),
      ),
      headers: await deviceHeaders(),
    );

    return response;
  }

  Future<dynamic> resetEmail(LoyaltyProgram loyaltyProgram) async {
    dynamic response = await _httpProvider.put(
      '/loyaltyProgram/programProfile/update',
      body: json.encode(
        loyaltyProgram.toJson(),
      ),
      headers: await deviceHeaders(),
    );
    return response;
  }
}
