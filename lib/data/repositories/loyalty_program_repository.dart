import 'dart:async' show StreamController;
import 'dart:convert' show json;

import 'package:notification_app/constants/app_config.dart';
import 'package:notification_app/data/models/loyalty_program.dart';
import 'package:notification_app/data/providers/loyalty_program_provider.dart';
import 'package:notification_app/services/secure_storage_service.dart';
import 'package:notification_app/extensions/extensions.dart' show Formatter;

class LoyaltyProgramRepository {
  static const String delayedPushNotificationConsentKey =
      'DELAYED_PUSH_NOTIFICATION_CONSENT';

  final LoyaltyProgramProvider _loyaltyProgram = LoyaltyProgramProvider();
  final SecureStorage _secureStorage = SecureStorage();

  final StreamController<LoyaltyProgram> _controller =
      StreamController<LoyaltyProgram>();

  Stream<LoyaltyProgram> get onNewData => _controller.stream;

  Future<LoyaltyProgram> getProgram(String programName) =>
      _loyaltyProgram.getLoyaltyProgram(programName);

  Future<dynamic> optIn(LoyaltyProgram loyaltyProgram, String token) =>
      _loyaltyProgram.optIn(loyaltyProgram, token: token);

  Future<dynamic> updateProgramProfile(LoyaltyProgram loyaltyProgram) async {
    try {
      await _loyaltyProgram.updateProgramProfile(loyaltyProgram);

      /// If succeed, update the stream controller
      /// In order to notify other listeners that loyaltyprogram was updated
      _controller.add(loyaltyProgram);
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> optOut(String customerId) =>
      _loyaltyProgram.optOut(customerId);

  Future<void> storePostponeInfo(String token) async {
    await _secureStorage.write(
      delayedPushNotificationConsentKey,
      json.encode(PostponedInfo(token: token).toJson()),
    );
  }

  Future<PostponedInfo?> retrievePostponeInfo() async {
    String? data = await _secureStorage.read(
      delayedPushNotificationConsentKey,
    );
    if (data == null) {
      return null;
    }

    return PostponedInfo.fromJson(data);
  }

  void dispose() => _controller.close();
}

class PostponedInfo {
  String token;
  DateTime untilDate;

  PostponedInfo({
    required this.token,
    DateTime? untilDate,
  }) : this.untilDate = untilDate ?? DateTime.now()
          ..add(
            Duration(days: AppConfig.pushNotificationsDelayDays),
          );

  Map<String, String> toJson() {
    return <String, String>{
      'token': this.token,
      'untilDate': this.untilDate.toUEFormat(),
    };
  }

  factory PostponedInfo.fromJson(dynamic jsonData) {
    Map<String, dynamic> data;
    if (jsonData is String) {
      data = json.decode(jsonData) as Map<String, dynamic>;
    } else {
      data = jsonData as Map<String, dynamic>;
    }

    return PostponedInfo(
      token: data['token'] as String,
      untilDate: DateTime.parse(data['untilDate'] as String),
    );
  }
}
