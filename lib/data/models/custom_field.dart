import 'dart:convert' show json;

import 'package:notification_app/extensions/extensions.dart' show Trimmer;

class CustomField {
  static const String dayMonth = 'dayMonthBirth';
  static const String county = 'county';
  static const String email = 'emailAddress';
  static const String pushMobileOsTokenId = 'pushMobileOsTokenId';

  final String name;
  final String? value;

  CustomField({
    required this.name,
    required this.value,
  });

  factory CustomField.fromJson(dynamic json) => CustomField(
        name: (json['name'] ?? '') as String,
        value: json['value'] != null ? json['value'] as String : null,
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
