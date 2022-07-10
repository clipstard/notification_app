import 'dart:convert' show json;

import 'package:notification_app/extensions/extensions.dart' show Trimmer;

class Consent {
  static const String smsPreferredContact = 'smsPreferredContact';
  static const String pushPreferredContact = 'pushPreferredContact';
  static const String emailPreferredContact = 'emailPreferredContact';
  static const String loyalty = 'loyaltyConsent';

  final String name;
  final bool value;

  Consent({
    required this.name,
    required this.value,
  });

  factory Consent.fromJson(dynamic json) => Consent(
        name: (json['name'] ?? '') as String,
        value: json['value'].toString().parseBool(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': this.name,
        'value': this.value,
      };

  @override
  String toString() {
    return json.encode(toJson()).toSingleLine().reduceSpaces();
  }
}
