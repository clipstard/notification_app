import 'dart:convert' show json;

import 'package:notification_app/constants/app_config.dart';
import 'package:notification_app/extensions/extensions.dart' show Trimmer;

import 'custom_field.dart';
import 'preference.dart';
import 'user.dart';
import 'consent.dart';

class LoyaltyProgram {
  final String customerId;
  final String programName;
  final List<Consent> consents;
  final List<CustomField> customFields;
  final List<Preference> preferences;
  final User? userInfos;

  const LoyaltyProgram({
    required this.customerId,
    this.programName = AppConfig.loyaltyProgramName,
    this.consents = const <Consent>[],
    this.customFields = const <CustomField>[],
    this.preferences = const <Preference>[],
    this.userInfos,
  });

  factory LoyaltyProgram.fromJson(dynamic json) {
    List<Consent> getConsents(dynamic data) {
      return ((data ?? <dynamic>[]) as List<dynamic>)
          .map((dynamic e) => Consent.fromJson(e))
          .toList();
    }

    List<CustomField> getCustomFields(dynamic data) {
      return ((data ?? <dynamic>[]) as List<dynamic>)
          .map((dynamic e) => CustomField.fromJson(e))
          .toList();
    }

    List<Preference> getPreferences(dynamic data) {
      return ((data ?? <dynamic>[]) as List<dynamic>)
          .map((dynamic e) => Preference.fromJson(e))
          .toList();
    }

    return LoyaltyProgram(
      customerId: json['customerId'] as String,
      programName: (json['programName'] ?? '') as String,
      consents: getConsents(json['consents']),
      customFields: getCustomFields(json['customFields']),
      preferences: getPreferences(json['preferences']),
      userInfos: User.fromJson(json['userInfos']),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{
      'customerId': customerId,
      'programName': programName,
      'consents': consents.map((Consent entry) => entry.toJson()).toList(),
      'customFields':
          customFields.map((CustomField entry) => entry.toJson()).toList(),
      'preferences':
          preferences.map((Preference entry) => entry.toJson()).toList(),
    };

    if (this.userInfos != null) {
      map['userInfos'] = this.userInfos!.toJson();
    }

    return map;
  }

  LoyaltyProgram copyWith({
    String? customerId,
    String? programName,
    List<Consent>? consents,
    List<CustomField>? customFields,
    List<Preference>? preferences,
    User? userInfos,
  }) {
    return LoyaltyProgram(
      customerId: customerId ?? this.customerId,
      programName: programName ?? this.programName,
      consents: consents ?? this.consents,
      customFields: customFields ?? this.customFields,
      preferences: preferences ?? this.preferences,
      userInfos: userInfos ?? this.userInfos,
    );
  }

  @override
  String toString() {
    return json.encode(toJson()).toSingleLine().reduceSpaces();
  }

  static const LoyaltyProgram empty = LoyaltyProgram(
    customerId: '',
    programName: AppConfig.loyaltyProgramName,
    userInfos: null,
  );
}
